'use client'

import { useState, useMemo, Fragment } from 'react'
import {
  useReactTable,
  getCoreRowModel,
  getSortedRowModel,
  getPaginationRowModel,
  getExpandedRowModel,
  flexRender,
  type ColumnDef,
  type SortingState,
  type ExpandedState,
  type Row,
} from '@tanstack/react-table'
import { ChevronRight, ChevronDown, ChevronUp, ChevronsUpDown } from 'lucide-react'
import { cn } from '@/lib/utils'
import {
  formatAmount,
  calculateYoYChange,
  isAnomaly,
  formatPercentage,
  getAmountFontClass,
} from '@/lib/format'
import type { RecipientRow, YearAmount } from '@/types/api'

// Collapsible year range (2016-2020 by default)
const COLLAPSED_YEARS_START = 2016
const COLLAPSED_YEARS_END = 2020

interface DataTableProps {
  data: RecipientRow[]
  availableYears: number[]
  primaryColumnName: string
  isLoading?: boolean
  totalRows?: number
  page?: number
  perPage?: number
  onPageChange?: (page: number) => void
  onPerPageChange?: (perPage: number) => void
  onSortChange?: (column: string, direction: 'asc' | 'desc') => void
  onRowExpand?: (primaryValue: string) => void
  renderExpandedRow?: (row: RecipientRow) => React.ReactNode
}

// Amount cell with trend anomaly indicator
function AmountCell({
  amount,
  previousAmount,
  isFirstYear,
}: {
  amount: number
  previousAmount?: number
  isFirstYear: boolean
}) {
  const formatted = formatAmount(amount)
  const fontClass = getAmountFontClass(formatted)
  const percentChange = isFirstYear ? null : calculateYoYChange(amount, previousAmount)
  const hasAnomaly = isAnomaly(percentChange)

  return (
    <div
      className={cn(
        'text-right tabular-nums',
        fontClass,
        hasAnomaly && 'bg-[var(--trend-anomaly-bg)] border border-[var(--trend-anomaly-border)] rounded px-1'
      )}
      title={percentChange !== null ? `${formatPercentage(percentChange)} vs vorig jaar` : undefined}
    >
      {formatted}
    </div>
  )
}

// Collapsed years cell (2016-2020 combined)
function CollapsedYearsCell({
  years,
  collapsedYearRange,
  onExpand,
}: {
  years: YearAmount[]
  collapsedYearRange: number[]
  onExpand: () => void
}) {
  const total = years
    .filter((y) => collapsedYearRange.includes(y.year))
    .reduce((sum, y) => sum + y.amount, 0)

  return (
    <button
      onClick={onExpand}
      className="flex items-center justify-end gap-1 w-full text-right tabular-nums text-sm hover:text-[var(--navy-medium)] transition-colors"
    >
      {formatAmount(total)}
      <ChevronRight className="h-3 w-3" />
    </button>
  )
}

export function DataTable({
  data,
  availableYears,
  primaryColumnName,
  isLoading = false,
  totalRows = 0,
  page = 1,
  perPage = 25,
  onPageChange,
  onPerPageChange,
  onSortChange,
  onRowExpand,
  renderExpandedRow,
}: DataTableProps) {
  const [sorting, setSorting] = useState<SortingState>([])
  const [expanded, setExpanded] = useState<ExpandedState>({})
  const [yearsExpanded, setYearsExpanded] = useState(false)

  // Determine which years to show based on expansion state
  const collapsedYears = availableYears.filter(
    (y) => y >= COLLAPSED_YEARS_START && y <= COLLAPSED_YEARS_END
  )
  const visibleYears = yearsExpanded
    ? availableYears
    : availableYears.filter((y) => y > COLLAPSED_YEARS_END)

  // Build columns dynamically based on available years
  const columns = useMemo<ColumnDef<RecipientRow>[]>(() => {
    const cols: ColumnDef<RecipientRow>[] = [
      // Expand button column
      {
        id: 'expand',
        header: () => null,
        cell: ({ row }) => (
          <button
            onClick={() => {
              row.toggleExpanded()
              if (!row.getIsExpanded() && onRowExpand) {
                onRowExpand(row.original.primary_value)
              }
            }}
            className="p-1 hover:bg-[var(--gray-light)] rounded transition-colors"
          >
            {row.getIsExpanded() ? (
              <ChevronDown className="h-4 w-4 text-[var(--navy-medium)]" />
            ) : (
              <ChevronRight className="h-4 w-4 text-[var(--navy-medium)]" />
            )}
          </button>
        ),
        size: 40,
      },
      // Primary column (Ontvanger) - sticky on mobile
      {
        id: 'primary',
        accessorKey: 'primary_value',
        header: ({ column }) => (
          <SortableHeader column={column} onSortChange={onSortChange}>
            {primaryColumnName}
          </SortableHeader>
        ),
        cell: ({ row }) => (
          <div className="font-medium text-[var(--navy-dark)]">
            {row.original.primary_value}
            {/* Cross-module indicator */}
            {row.original.sources && row.original.sources.length > 1 && (
              <div className="text-xs text-[var(--navy-medium)] mt-0.5">
                Ook in: {row.original.sources.filter(s => s !== 'current').join(', ')}
              </div>
            )}
          </div>
        ),
        minSize: 200,
        meta: { sticky: true }, // Mark as sticky column
      },
    ]

    // Collapsed years column (2016-2020)
    if (!yearsExpanded && collapsedYears.length > 0) {
      cols.push({
        id: 'collapsed-years',
        header: () => (
          <button
            onClick={() => setYearsExpanded(true)}
            className="flex items-center gap-1 text-xs font-semibold text-[var(--navy-dark)] hover:text-[var(--navy-medium)] transition-colors"
          >
            {COLLAPSED_YEARS_START}-{String(COLLAPSED_YEARS_END).slice(-2)}
            <ChevronRight className="h-3 w-3" />
          </button>
        ),
        cell: ({ row }) => (
          <CollapsedYearsCell
            years={row.original.years}
            collapsedYearRange={collapsedYears}
            onExpand={() => setYearsExpanded(true)}
          />
        ),
        size: 100,
      })
    }

    // Individual year columns
    visibleYears.forEach((year, index) => {
      const yearIndex = availableYears.indexOf(year)
      const previousYear = yearIndex > 0 ? availableYears[yearIndex - 1] : null

      cols.push({
        id: `year-${year}`,
        accessorFn: (row) => row.years.find((y) => y.year === year)?.amount ?? 0,
        header: ({ column }) => (
          <SortableHeader column={column} onSortChange={onSortChange}>
            {year}
            {/* Partial data indicator - will be populated from data_freshness */}
            {year === Math.max(...availableYears) && (
              <span className="text-[var(--warning)]" title="Data nog niet compleet">*</span>
            )}
          </SortableHeader>
        ),
        cell: ({ row }) => {
          const amount = row.original.years.find((y) => y.year === year)?.amount ?? 0
          const prevAmount = previousYear
            ? row.original.years.find((y) => y.year === previousYear)?.amount
            : undefined

          return (
            <AmountCell
              amount={amount}
              previousAmount={prevAmount}
              isFirstYear={yearIndex === 0}
            />
          )
        },
        size: 80,
      })
    })

    // Collapse button when expanded
    if (yearsExpanded && collapsedYears.length > 0) {
      cols.push({
        id: 'collapse-years',
        header: () => (
          <button
            onClick={() => setYearsExpanded(false)}
            className="p-1 hover:bg-[var(--gray-light)] rounded"
            title="Jaren inklappen"
          >
            <ChevronRight className="h-3 w-3 rotate-180" />
          </button>
        ),
        cell: () => null,
        size: 30,
      })
    }

    // Totaal column
    cols.push({
      id: 'total',
      accessorKey: 'total',
      header: ({ column }) => (
        <SortableHeader column={column} onSortChange={onSortChange}>
          Totaal
        </SortableHeader>
      ),
      cell: ({ row }) => {
        const formatted = formatAmount(row.original.total)
        const fontClass = getAmountFontClass(formatted)
        return (
          <div className={cn('text-right tabular-nums font-semibold', fontClass)}>
            {formatted}
          </div>
        )
      },
      size: 100,
    })

    return cols
  }, [availableYears, yearsExpanded, collapsedYears, visibleYears, primaryColumnName, onSortChange, onRowExpand])

  const table = useReactTable({
    data,
    columns,
    state: {
      sorting,
      expanded,
    },
    onSortingChange: setSorting,
    onExpandedChange: setExpanded,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getExpandedRowModel: getExpandedRowModel(),
    manualPagination: true, // Server-side pagination
    pageCount: Math.ceil(totalRows / perPage),
  })

  const totalPages = Math.ceil(totalRows / perPage)

  return (
    <div className="w-full">
      {/* Table container with horizontal scroll for expanded years */}
      <div className="overflow-x-auto border border-[var(--border)] rounded-lg">
        <table className="w-full border-collapse">
          <thead className="bg-[var(--gray-light)]">
            {table.getHeaderGroups().map((headerGroup) => (
              <tr key={headerGroup.id}>
                {headerGroup.headers.map((header, headerIndex) => {
                  const isSticky = (header.column.columnDef.meta as any)?.sticky || headerIndex === 0 || headerIndex === 1
                  return (
                    <th
                      key={header.id}
                      className={cn(
                        'px-3 py-2 text-left text-xs font-semibold text-[var(--navy-dark)] border-b border-[var(--border)]',
                        isSticky && 'sticky left-0 bg-[var(--gray-light)] z-10',
                        headerIndex === 1 && 'sticky left-10 bg-[var(--gray-light)] z-10 shadow-[2px_0_5px_-2px_rgba(0,0,0,0.1)]'
                      )}
                      style={{ width: header.getSize() }}
                    >
                      {header.isPlaceholder
                        ? null
                        : flexRender(header.column.columnDef.header, header.getContext())}
                    </th>
                  )
                })}
              </tr>
            ))}
          </thead>
          <tbody>
            {isLoading ? (
              // Loading skeleton
              Array.from({ length: 5 }).map((_, i) => (
                <tr key={`skeleton-${i}`} className="animate-pulse">
                  {columns.map((_, j) => (
                    <td key={`skeleton-${i}-${j}`} className="px-3 py-3 border-b border-[var(--border)]">
                      <div className="h-4 bg-[var(--gray-light)] rounded" />
                    </td>
                  ))}
                </tr>
              ))
            ) : data.length === 0 ? (
              // Empty state
              <tr>
                <td colSpan={columns.length} className="text-center py-12">
                  <div className="text-[var(--muted-foreground)]">
                    <p className="text-lg font-medium">Geen resultaten gevonden</p>
                    <p className="text-sm mt-1">Suggesties:</p>
                    <ul className="text-sm mt-2 space-y-1">
                      <li>Controleer de spelling</li>
                      <li>Probeer minder filters</li>
                      <li>Zoek op een deel van de naam</li>
                    </ul>
                  </div>
                </td>
              </tr>
            ) : (
              table.getRowModel().rows.map((row) => (
                <Fragment key={row.id}>
                  <tr
                    className={cn(
                      'hover:bg-[var(--gray-light)] transition-colors',
                      row.getIsExpanded() && 'bg-[var(--gray-light)]'
                    )}
                  >
                    {row.getVisibleCells().map((cell, cellIndex) => {
                      const isSticky = (cell.column.columnDef.meta as any)?.sticky || cellIndex === 0 || cellIndex === 1
                      const isExpanded = row.getIsExpanded()
                      return (
                        <td
                          key={cell.id}
                          className={cn(
                            'px-3 py-2 border-b border-[var(--border)]',
                            isSticky && 'sticky left-0 bg-white z-10',
                            cellIndex === 1 && 'sticky left-10 bg-white z-10 shadow-[2px_0_5px_-2px_rgba(0,0,0,0.1)]',
                            isExpanded && isSticky && 'bg-[var(--gray-light)]'
                          )}
                          style={{ width: cell.column.getSize() }}
                        >
                          {flexRender(cell.column.columnDef.cell, cell.getContext())}
                        </td>
                      )
                    })}
                  </tr>
                  {/* Expanded row content */}
                  {row.getIsExpanded() && renderExpandedRow && (
                    <tr>
                      <td colSpan={columns.length} className="bg-[var(--gray-light)] border-b border-[var(--border)]">
                        <div className="px-6 py-4">
                          {renderExpandedRow(row.original)}
                        </div>
                      </td>
                    </tr>
                  )}
                </Fragment>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Footer */}
      <div className="flex flex-col sm:flex-row items-center justify-between gap-4 mt-4 px-2">
        <div className="text-xs text-[var(--muted-foreground)]">
          Bedragen in &euro;
          {availableYears.includes(Math.max(...availableYears)) && (
            <span className="ml-4">* Data nog niet compleet</span>
          )}
        </div>

        {/* Pagination */}
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-2">
            <button
              onClick={() => onPageChange?.(page - 1)}
              disabled={page <= 1}
              className="px-3 py-1.5 text-sm border border-[var(--border)] rounded hover:bg-[var(--gray-light)] disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              &#9664; Vorige
            </button>
            <span className="text-sm text-[var(--muted-foreground)]">
              Pagina {page} van {totalPages}
            </span>
            <button
              onClick={() => onPageChange?.(page + 1)}
              disabled={page >= totalPages}
              className="px-3 py-1.5 text-sm border border-[var(--border)] rounded hover:bg-[var(--gray-light)] disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              Volgende &#9654;
            </button>
          </div>

          <select
            value={perPage}
            onChange={(e) => onPerPageChange?.(Number(e.target.value))}
            className="px-2 py-1.5 text-sm border border-[var(--border)] rounded bg-white"
          >
            {[25, 50, 100].map((size) => (
              <option key={size} value={size}>
                {size} per pagina
              </option>
            ))}
          </select>
        </div>
      </div>
    </div>
  )
}

// Sortable header component
function SortableHeader({
  column,
  children,
  onSortChange,
}: {
  column: any
  children: React.ReactNode
  onSortChange?: (column: string, direction: 'asc' | 'desc') => void
}) {
  const isSorted = column.getIsSorted()

  const handleSort = () => {
    const newDirection = isSorted === 'asc' ? 'desc' : 'asc'
    column.toggleSorting(newDirection === 'desc')
    onSortChange?.(column.id, newDirection)
  }

  return (
    <button
      onClick={handleSort}
      className="flex items-center gap-1 hover:text-[var(--navy-medium)] transition-colors"
    >
      {children}
      {isSorted === 'asc' ? (
        <ChevronUp className="h-3 w-3" />
      ) : isSorted === 'desc' ? (
        <ChevronDown className="h-3 w-3" />
      ) : (
        <ChevronsUpDown className="h-3 w-3 opacity-50" />
      )}
    </button>
  )
}
