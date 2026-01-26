'use client'

import { useState, useEffect, useRef, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { Search, X, Loader2, FileText, User } from 'lucide-react'
import { cn } from '@/lib/utils'
import { formatAmount } from '@/lib/format'

const TYPESENSE_HOST = process.env.NEXT_PUBLIC_TYPESENSE_HOST || 'typesense-production-35ae.up.railway.app'
const TYPESENSE_API_KEY = process.env.NEXT_PUBLIC_TYPESENSE_API_KEY || '0vh4mxafjeuvd676gw92kpjflg6fuv57'

interface RecipientResult {
  type: 'recipient'
  name: string
  sources: string[]
  source_count: number
  totaal: number
}

interface KeywordResult {
  type: 'keyword'
  keyword: string
  field: string
  fieldLabel: string
  module: string
  moduleLabel: string
}

type SearchResultItem = RecipientResult | KeywordResult

interface SearchBarProps {
  className?: string
  placeholder?: string
  onSearch?: (query: string) => void
}

// Field labels for display
const FIELD_LABELS: Record<string, string> = {
  regeling: 'Regeling',
  omschrijving: 'Omschrijving',
  beleidsterrein: 'Beleidsterrein',
  begrotingsnaam: 'Begrotingsnaam',
  categorie: 'Categorie',
  trefwoorden: 'Trefwoorden',
}

// Module labels for display
const MODULE_LABELS: Record<string, string> = {
  instrumenten: 'Instrumenten',
  inkoop: 'Inkoop',
  publiek: 'Publiek',
  gemeente: 'Gemeente',
  provincie: 'Provincie',
  apparaat: 'Apparaat',
}

export function SearchBar({ className, placeholder = 'Zoek op ontvanger, regeling...', onSearch }: SearchBarProps) {
  const router = useRouter()
  const inputRef = useRef<HTMLInputElement>(null)
  const dropdownRef = useRef<HTMLDivElement>(null)

  const [query, setQuery] = useState('')
  const [keywords, setKeywords] = useState<KeywordResult[]>([])
  const [recipients, setRecipients] = useState<RecipientResult[]>([])
  const [isLoading, setIsLoading] = useState(false)
  const [isOpen, setIsOpen] = useState(false)
  const [selectedIndex, setSelectedIndex] = useState(-1)

  // Combined results for keyboard navigation
  const allResults: SearchResultItem[] = [...keywords, ...recipients]
  const totalResults = allResults.length

  // Debounced search
  useEffect(() => {
    if (query.length < 2) {
      setKeywords([])
      setRecipients([])
      setIsOpen(false)
      return
    }

    const timeout = setTimeout(async () => {
      setIsLoading(true)
      try {
        // Parallel fetch: recipients + keywords from multiple collections
        const [recipientsData, keywordsData] = await Promise.all([
          fetchRecipients(query),
          fetchKeywords(query),
        ])

        setRecipients(recipientsData)
        setKeywords(keywordsData)
        setIsOpen(recipientsData.length > 0 || keywordsData.length > 0)
        setSelectedIndex(-1)
      } catch (error) {
        console.error('Search error:', error)
        setRecipients([])
        setKeywords([])
      } finally {
        setIsLoading(false)
      }
    }, 150)

    return () => clearTimeout(timeout)
  }, [query])

  // Fetch recipients from recipients collection
  async function fetchRecipients(q: string): Promise<RecipientResult[]> {
    const response = await fetch(
      `https://${TYPESENSE_HOST}/collections/recipients/documents/search?` +
      new URLSearchParams({
        q,
        query_by: 'name,name_lower',
        prefix: 'true',
        per_page: '5',
        sort_by: 'totaal:desc',
      }),
      {
        headers: {
          'X-TYPESENSE-API-KEY': TYPESENSE_API_KEY,
        },
      }
    )

    if (!response.ok) return []

    const data = await response.json()
    return (data.hits || []).map((hit: any) => ({
      type: 'recipient' as const,
      name: hit.document.name,
      sources: hit.document.sources || [],
      source_count: hit.document.source_count || 0,
      totaal: hit.document.totaal || 0,
    }))
  }

  // Fetch keywords from module collections
  async function fetchKeywords(q: string): Promise<KeywordResult[]> {
    // Search keyword fields in different module collections
    const keywordSearches = [
      { collection: 'instrumenten', field: 'regeling', module: 'instrumenten' },
      { collection: 'publiek', field: 'regeling', module: 'publiek' },
      { collection: 'publiek', field: 'omschrijving', module: 'publiek' },
      { collection: 'gemeente', field: 'regeling', module: 'gemeente' },
      { collection: 'gemeente', field: 'beleidsterrein', module: 'gemeente' },
      { collection: 'gemeente', field: 'omschrijving', module: 'gemeente' },
      { collection: 'provincie', field: 'omschrijving', module: 'provincie' },
    ]

    const results: KeywordResult[] = []
    const seenKeywords = new Set<string>()

    // Fetch from each collection/field combo (in parallel, limited)
    const searches = keywordSearches.slice(0, 4).map(async ({ collection, field, module }) => {
      try {
        const response = await fetch(
          `https://${TYPESENSE_HOST}/collections/${collection}/documents/search?` +
          new URLSearchParams({
            q,
            query_by: field,
            prefix: 'true',
            per_page: '3',
            group_by: field,
            group_limit: '1',
          }),
          {
            headers: {
              'X-TYPESENSE-API-KEY': TYPESENSE_API_KEY,
            },
          }
        )

        if (!response.ok) return []

        const data = await response.json()
        const groupedHits = data.grouped_hits || []

        return groupedHits.map((group: any) => {
          const doc = group.hits?.[0]?.document
          if (!doc || !doc[field]) return null

          const keyword = doc[field]
          // Skip if we've seen this keyword or if it's too short
          if (seenKeywords.has(keyword.toLowerCase()) || keyword.length < 3) return null
          seenKeywords.add(keyword.toLowerCase())

          return {
            type: 'keyword' as const,
            keyword,
            field,
            fieldLabel: FIELD_LABELS[field] || field,
            module,
            moduleLabel: MODULE_LABELS[module] || module,
          }
        }).filter(Boolean)
      } catch {
        return []
      }
    })

    const searchResults = await Promise.all(searches)
    searchResults.forEach(hits => results.push(...hits))

    // Dedupe and limit to 4 keywords
    return results.slice(0, 4)
  }

  // Handle click outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target as Node) &&
        inputRef.current &&
        !inputRef.current.contains(event.target as Node)
      ) {
        setIsOpen(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const handleSelectRecipient = useCallback((result: RecipientResult) => {
    setQuery(result.name)
    setIsOpen(false)
    router.push(`/integraal?q=${encodeURIComponent(result.name)}`)
  }, [router])

  const handleSelectKeyword = useCallback((result: KeywordResult) => {
    setQuery(result.keyword)
    setIsOpen(false)
    // Navigate to the specific module with the keyword search
    router.push(`/${result.module}?q=${encodeURIComponent(result.keyword)}`)
  }, [router])

  const handleSubmit = useCallback((e: React.FormEvent) => {
    e.preventDefault()
    if (query.trim()) {
      setIsOpen(false)
      if (selectedIndex >= 0 && allResults[selectedIndex]) {
        const selected = allResults[selectedIndex]
        if (selected.type === 'recipient') {
          handleSelectRecipient(selected)
        } else {
          handleSelectKeyword(selected)
        }
      } else {
        router.push(`/integraal?q=${encodeURIComponent(query.trim())}`)
      }
      onSearch?.(query.trim())
    }
  }, [query, selectedIndex, allResults, router, onSearch, handleSelectRecipient, handleSelectKeyword])

  const handleKeyDown = useCallback((e: React.KeyboardEvent) => {
    if (!isOpen) return

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault()
        setSelectedIndex((prev) => (prev < totalResults - 1 ? prev + 1 : prev))
        break
      case 'ArrowUp':
        e.preventDefault()
        setSelectedIndex((prev) => (prev > 0 ? prev - 1 : -1))
        break
      case 'Escape':
        setIsOpen(false)
        setSelectedIndex(-1)
        break
    }
  }, [isOpen, totalResults])

  const handleClear = useCallback(() => {
    setQuery('')
    setKeywords([])
    setRecipients([])
    setIsOpen(false)
    inputRef.current?.focus()
  }, [])

  return (
    <div className={cn('relative', className)}>
      <form onSubmit={handleSubmit}>
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-white/60" />
          <input
            ref={inputRef}
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            onKeyDown={handleKeyDown}
            onFocus={() => (keywords.length > 0 || recipients.length > 0) && setIsOpen(true)}
            placeholder={placeholder}
            className="w-full pl-10 pr-10 py-2 bg-white/10 border border-white/20 rounded-lg text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-white/30 focus:border-transparent transition-all"
          />
          {isLoading && (
            <Loader2 className="absolute right-3 top-1/2 -translate-y-1/2 h-4 w-4 text-white/60 animate-spin" />
          )}
          {!isLoading && query && (
            <button
              type="button"
              onClick={handleClear}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-white/60 hover:text-white"
            >
              <X className="h-4 w-4" />
            </button>
          )}
        </div>
      </form>

      {/* Autocomplete dropdown */}
      {isOpen && (keywords.length > 0 || recipients.length > 0) && (
        <div
          ref={dropdownRef}
          className="absolute top-full left-0 right-0 mt-1 bg-white rounded-lg shadow-lg border border-[var(--border)] z-50 overflow-hidden"
        >
          <div className="max-h-96 overflow-y-auto">
            {/* Keywords section */}
            {keywords.length > 0 && (
              <div>
                <div className="px-4 py-2 text-xs font-semibold text-[var(--navy-medium)] uppercase tracking-wider bg-[var(--gray-light)]">
                  <FileText className="inline h-3 w-3 mr-1.5 -mt-0.5" />
                  Zoektermen
                </div>
                {keywords.map((result, index) => (
                  <button
                    key={`${result.keyword}-${result.field}`}
                    type="button"
                    onClick={() => handleSelectKeyword(result)}
                    className={cn(
                      'w-full px-4 py-2.5 text-left hover:bg-[var(--gray-light)] transition-colors border-b border-[var(--border)]',
                      selectedIndex === index && 'bg-[var(--gray-light)]'
                    )}
                  >
                    <div className="flex items-center justify-between">
                      <div className="font-medium text-[var(--navy-dark)] truncate">
                        {result.keyword}
                      </div>
                      <div className="flex items-center gap-2 text-xs text-[var(--muted-foreground)]">
                        <span className="px-1.5 py-0.5 bg-[var(--blue-light)]/20 text-[var(--navy-medium)] rounded">
                          {result.moduleLabel}
                        </span>
                        <span>in {result.fieldLabel}</span>
                      </div>
                    </div>
                  </button>
                ))}
              </div>
            )}

            {/* Recipients section */}
            {recipients.length > 0 && (
              <div>
                <div className="px-4 py-2 text-xs font-semibold text-[var(--navy-medium)] uppercase tracking-wider bg-[var(--gray-light)]">
                  <User className="inline h-3 w-3 mr-1.5 -mt-0.5" />
                  Ontvangers
                </div>
                {recipients.map((result, index) => {
                  const adjustedIndex = keywords.length + index
                  return (
                    <button
                      key={result.name}
                      type="button"
                      onClick={() => handleSelectRecipient(result)}
                      className={cn(
                        'w-full px-4 py-3 text-left hover:bg-[var(--gray-light)] transition-colors border-b border-[var(--border)] last:border-b-0',
                        selectedIndex === adjustedIndex && 'bg-[var(--gray-light)]'
                      )}
                    >
                      <div className="flex items-start justify-between gap-4">
                        <div className="flex-1 min-w-0">
                          <div className="font-medium text-[var(--navy-dark)] truncate">
                            {result.name}
                          </div>
                          {result.sources && result.sources.length > 0 && (
                            <div className="flex flex-wrap gap-1 mt-1">
                              {result.sources.slice(0, 4).map((source) => (
                                <span
                                  key={source}
                                  className="text-xs px-1.5 py-0.5 bg-[var(--blue-light)]/20 text-[var(--navy-medium)] rounded"
                                >
                                  {MODULE_LABELS[source] || source}
                                </span>
                              ))}
                              {result.sources.length > 4 && (
                                <span className="text-xs text-[var(--muted-foreground)]">
                                  +{result.sources.length - 4}
                                </span>
                              )}
                            </div>
                          )}
                        </div>
                        <div className="text-right">
                          <div className="text-sm font-medium text-[var(--navy-dark)]">
                            {formatAmount(result.totaal)}
                          </div>
                          <div className="text-xs text-[var(--muted-foreground)]">
                            totaal
                          </div>
                        </div>
                      </div>
                    </button>
                  )
                })}
              </div>
            )}
          </div>
          <div className="px-4 py-2 bg-[var(--gray-light)] text-xs text-[var(--muted-foreground)] border-t border-[var(--border)]">
            Druk op Enter om te zoeken in alle modules
          </div>
        </div>
      )}
    </div>
  )
}
