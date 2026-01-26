'use client'

import { useState, useEffect, useCallback, Suspense } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { DataTable, ExpandedRow } from '@/components/data-table'
import { FilterPanel, type FilterValues } from '@/components/filter-panel'
import { fetchModuleData } from '@/lib/api'
import type { ModuleDataResponse, RecipientRow } from '@/types/api'

const DEFAULT_FILTERS: FilterValues = {
  search: '',
  jaar: null,
  minBedrag: null,
  maxBedrag: null,
}

// Wrapper component to handle Suspense boundary for useSearchParams
export default function InstrumentenPage() {
  return (
    <Suspense fallback={<InstrumentenPageSkeleton />}>
      <InstrumentenPageContent />
    </Suspense>
  )
}

function InstrumentenPageSkeleton() {
  return (
    <div className="min-h-screen bg-white">
      <header className="bg-[var(--navy-dark)] text-white px-6 py-4">
        <div className="max-w-7xl mx-auto">
          <h1 className="text-xl font-semibold">Financiële Instrumenten</h1>
          <p className="text-sm text-[var(--blue-light)] mt-1">
            Overzicht van uitgaven via financiële instrumenten
          </p>
        </div>
      </header>
      <main className="max-w-7xl mx-auto px-6 py-8">
        <div className="animate-pulse space-y-4">
          <div className="h-12 bg-[var(--gray-light)] rounded-lg" />
          <div className="h-64 bg-[var(--gray-light)] rounded-lg" />
        </div>
      </main>
    </div>
  )
}

function InstrumentenPageContent() {
  const router = useRouter()
  const searchParams = useSearchParams()

  const [data, setData] = useState<ModuleDataResponse | null>(null)
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [page, setPage] = useState(1)
  const [perPage, setPerPage] = useState(25)
  const [sortBy, setSortBy] = useState<string>('total')
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc')

  // Initialize filters from URL params
  const [filters, setFilters] = useState<FilterValues>(() => ({
    search: searchParams.get('q') ?? '',
    jaar: searchParams.get('jaar') ? parseInt(searchParams.get('jaar')!, 10) : null,
    minBedrag: searchParams.get('min_bedrag') ? parseFloat(searchParams.get('min_bedrag')!) : null,
    maxBedrag: searchParams.get('max_bedrag') ? parseFloat(searchParams.get('max_bedrag')!) : null,
  }))

  // Update URL when filters change
  useEffect(() => {
    const params = new URLSearchParams()
    if (filters.search) params.set('q', filters.search)
    if (filters.jaar) params.set('jaar', String(filters.jaar))
    if (filters.minBedrag) params.set('min_bedrag', String(filters.minBedrag))
    if (filters.maxBedrag) params.set('max_bedrag', String(filters.maxBedrag))

    const newUrl = params.toString() ? `?${params.toString()}` : '/instrumenten'
    router.replace(newUrl, { scroll: false })
  }, [filters, router])

  // Fetch data when filters, pagination, or sorting changes
  useEffect(() => {
    async function loadData() {
      setIsLoading(true)
      setError(null)

      try {
        const response = await fetchModuleData('instrumenten', {
          page,
          per_page: perPage,
          sort_by: sortBy,
          sort_order: sortOrder,
          search: filters.search || undefined,
          jaar: filters.jaar ?? undefined,
          min_bedrag: filters.minBedrag ?? undefined,
          max_bedrag: filters.maxBedrag ?? undefined,
        })
        setData(response)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Er ging iets mis')
      } finally {
        setIsLoading(false)
      }
    }

    loadData()
  }, [page, perPage, sortBy, sortOrder, filters])

  const handleFilterChange = useCallback((newFilters: FilterValues) => {
    setFilters(newFilters)
    setPage(1) // Reset to first page on filter change
  }, [])

  const handleSortChange = useCallback((column: string, direction: 'asc' | 'desc') => {
    setSortBy(column)
    setSortOrder(direction)
    setPage(1)
  }, [])

  const handlePageChange = useCallback((newPage: number) => {
    setPage(newPage)
  }, [])

  const handlePerPageChange = useCallback((newPerPage: number) => {
    setPerPage(newPerPage)
    setPage(1)
  }, [])

  const handleRowExpand = useCallback((primaryValue: string) => {
    console.log('Expanding row:', primaryValue)
  }, [])

  const handleNavigateToModule = useCallback((module: string, recipient: string) => {
    router.push(`/${module}?q=${encodeURIComponent(recipient)}`)
  }, [router])

  // Render expanded row content
  const renderExpandedRow = useCallback((row: RecipientRow) => (
    <ExpandedRow
      row={row}
      module="instrumenten"
      availableYears={data?.availableYears ?? []}
      onNavigateToModule={handleNavigateToModule}
    />
  ), [data?.availableYears, handleNavigateToModule])

  if (error) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <p className="text-lg font-medium text-[var(--error)]">Er ging iets mis</p>
          <p className="text-sm text-[var(--muted-foreground)] mt-2">{error}</p>
          <button
            onClick={() => window.location.reload()}
            className="mt-4 px-4 py-2 bg-[var(--pink)] text-white rounded hover:opacity-90 transition-opacity"
          >
            Opnieuw proberen
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <header className="bg-[var(--navy-dark)] text-white px-6 py-4">
        <div className="max-w-7xl mx-auto">
          <h1 className="text-xl font-semibold">Financiële Instrumenten</h1>
          <p className="text-sm text-[var(--blue-light)] mt-1">
            Overzicht van uitgaven via financiële instrumenten
          </p>
        </div>
      </header>

      {/* Main content */}
      <main className="max-w-7xl mx-auto px-6 py-8">
        {/* Filter panel */}
        <FilterPanel
          module="instrumenten"
          availableYears={data?.availableYears ?? []}
          filters={filters}
          onFilterChange={handleFilterChange}
          isLoading={isLoading}
        />

        {/* Results count */}
        {data && (
          <div className="mb-4 text-sm text-[var(--muted-foreground)]">
            {data.pagination.totalRows.toLocaleString('nl-NL')} resultaten
            {filters.search && (
              <span> voor &ldquo;{filters.search}&rdquo;</span>
            )}
          </div>
        )}

        {/* DataTable */}
        <DataTable
          data={data?.rows ?? []}
          availableYears={data?.availableYears ?? []}
          primaryColumnName={data?.primaryColumn ?? 'Ontvanger'}
          isLoading={isLoading}
          totalRows={data?.pagination.totalRows ?? 0}
          page={page}
          perPage={perPage}
          onPageChange={handlePageChange}
          onPerPageChange={handlePerPageChange}
          onSortChange={handleSortChange}
          onRowExpand={handleRowExpand}
          renderExpandedRow={renderExpandedRow}
        />
      </main>
    </div>
  )
}
