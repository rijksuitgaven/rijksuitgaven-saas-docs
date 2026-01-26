# Frontend Documentation

**Last Updated:** 2026-01-26
**Stack:** Next.js 16.1.4 + TypeScript + Tailwind CSS + TanStack Table

---

## Project Structure

```
app/src/
├── app/                          # Next.js App Router pages
│   ├── layout.tsx                # Root layout (fonts, cookie banner)
│   ├── globals.css               # Global styles (brand colors, animations)
│   ├── page.tsx                  # Home page (module cards)
│   ├── privacybeleid/page.tsx    # Privacy policy page
│   ├── instrumenten/page.tsx     # Module page
│   ├── apparaat/page.tsx         # Module page
│   ├── inkoop/page.tsx           # Module page
│   ├── provincie/page.tsx        # Module page
│   ├── gemeente/page.tsx         # Module page
│   ├── publiek/page.tsx          # Module page
│   └── integraal/page.tsx        # Cross-module search page
├── components/
│   ├── cookie-banner/            # GDPR cookie disclosure
│   │   ├── cookie-banner.tsx
│   │   └── index.ts
│   ├── data-table/               # Main data table component
│   │   ├── data-table.tsx        # TanStack Table implementation
│   │   ├── expanded-row.tsx      # Expandable row with grouping
│   │   └── index.ts
│   ├── filter-panel/             # Search and filter UI
│   │   ├── filter-panel.tsx
│   │   └── index.ts
│   └── module-page/              # Reusable module page template
│       ├── module-page.tsx
│       └── index.ts
├── lib/
│   ├── api.ts                    # API client for backend
│   ├── format.ts                 # Number formatting utilities
│   └── utils.ts                  # CN utility for Tailwind
└── types/
    └── api.ts                    # TypeScript interfaces
```

---

## Fonts (Brand Identity)

| Font | Variable | Usage |
|------|----------|-------|
| Brawler | `--font-heading` | Headings, page titles |
| IBM Plex Sans Condensed | `--font-body` | Body text, UI elements |

Both fonts are self-hosted via `next/font/google` - no external requests to Google.

**Usage in CSS:**
```css
.heading {
  font-family: var(--font-heading), serif;
}
.body {
  font-family: var(--font-body), sans-serif;
}
```

---

## Brand Colors (CSS Variables)

Defined in `globals.css`:

| Variable | Hex | Usage |
|----------|-----|-------|
| `--navy-dark` | #0E3261 | Headers, primary text |
| `--navy-medium` | #436FA3 | Links, secondary elements |
| `--blue-light` | #8DBADC | Hover states, backgrounds |
| `--pink` | #E62D75 | CTAs, active states |
| `--gray-light` | #E1EAF2 | Backgrounds, disabled |
| `--success` | #85C97D | Positive indicators |
| `--warning` | #FFC857 | Attention |
| `--error` | #E30101 | Error, negative trends |
| `--trend-anomaly-bg` | rgba(227,1,1,0.1) | 10%+ YoY change highlight |

---

## Components

### DataTable (`components/data-table/data-table.tsx`)

Main data grid component using TanStack Table.

**Features:**
- Dynamic year columns (2016-2025)
- Collapsible 2016-2020 range (click to expand)
- Trend anomaly indicator (red highlight for 10%+ YoY change)
- Sticky columns on mobile (expand button + primary column)
- Server-side pagination
- Sortable columns
- Loading skeleton
- Empty state with suggestions

**Props:**
```typescript
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
```

### ExpandedRow (`components/data-table/expanded-row.tsx`)

Content displayed when a table row is expanded.

**Features:**
- Context header with recipient name
- Cross-module indicator ("Ook in: Instrumenten, Publiek")
- Grouping selector dropdown (per-module fields)
- Detail rows with tree structure (├ └ connectors)
- Lazy loading of detail data

**Groupable Fields Per Module:**

| Module | Fields |
|--------|--------|
| instrumenten | Regeling, Artikel, Begrotingsnaam |
| apparaat | Artikel, Begrotingsnaam |
| inkoop | Ministerie, Categorie |
| provincie | Provincie |
| gemeente | Gemeente, Beleidsterrein |
| publiek | Organisatie, Regeling |
| integraal | Module |

### FilterPanel (`components/filter-panel/filter-panel.tsx`)

Search and filter controls.

**Features:**
- Debounced search input (300ms)
- Year dropdown filter
- Expandable "Meer filters" section
- Amount range (min/max)
- Module-specific filters
- Clear all button
- URL state sync (filters in query params)

### ModulePage (`components/module-page/module-page.tsx`)

Reusable template for all module pages.

**Features:**
- Suspense boundary for useSearchParams
- URL state sync (search, jaar, min_bedrag, max_bedrag)
- Pagination state management
- Sort state management
- Error state with retry button
- Loading skeleton

**Module Configurations:**

| Module | Primary Column | Description |
|--------|---------------|-------------|
| instrumenten | Ontvanger | Subsidies, regelingen en bijdragen |
| apparaat | Kostensoort | Operationele kosten |
| inkoop | Leverancier | Inkoop bij leveranciers |
| provincie | Ontvanger | Provinciale subsidies |
| gemeente | Ontvanger | Gemeentelijke subsidies |
| publiek | Ontvanger | RVO, COA, NWO uitbetalingen |
| integraal | Ontvanger | Cross-module search |

### CookieBanner (`components/cookie-banner/cookie-banner.tsx`)

GDPR-compliant disclosure banner (essential cookies only).

**Behavior:**
1. Shows on first visit (checks `localStorage`)
2. Dismisses permanently on "OK" click
3. Links to `/privacybeleid`
4. Fixed bottom position, z-index 50
5. Fade-in animation (150ms)

---

## API Client (`lib/api.ts`)

**Base URL:** `https://rijksuitgaven-api-production-3448.up.railway.app`

(Can be overridden with `NEXT_PUBLIC_API_URL` env var)

**Functions:**

| Function | Purpose |
|----------|---------|
| `fetchModules()` | Get list of available modules |
| `fetchModuleData(module, params)` | Get paginated, filtered module data |
| `fetchDetailData(module, value, grouping)` | Get expanded row details |

**Response Transformation:**
- API returns years as object: `{ "2016": 0, "2017": 1000 }`
- Client transforms to array: `[{ year: 2016, amount: 0 }, ...]`
- API uses `totaal`, client uses `total`
- API uses `modules`, client uses `sources`

---

## Format Utilities (`lib/format.ts`)

| Function | Purpose |
|----------|---------|
| `formatAmount(amount)` | Dutch number formatting (1.234.567) |
| `calculateYoYChange(current, previous)` | Calculate year-over-year % change |
| `isAnomaly(percentChange)` | Check if change >= 10% |
| `formatPercentage(value)` | Format as "+12.3%" or "-5.0%" |
| `getAmountFontClass(formatted)` | Return smaller font class for large numbers |

---

## TypeScript Types (`types/api.ts`)

**Key Interfaces:**

```typescript
// Row displayed in table
interface RecipientRow {
  primary_value: string
  years: YearAmount[]  // Array for iteration
  total: number
  row_count: number
  sources: string[] | null  // Cross-module indicator
}

// API response (before transformation)
interface ApiRecipientRow {
  primary_value: string
  years: Record<string, number>  // Object from API
  totaal: number
  row_count: number
  modules: string[] | null
}

// Query parameters
interface ModuleQueryParams {
  limit?: number
  offset?: number
  sort_by?: string
  sort_order?: 'asc' | 'desc'
  search?: string
  jaar?: number
  min_bedrag?: number
  max_bedrag?: number
}
```

---

## Routes

| Route | Page | Description |
|-------|------|-------------|
| `/` | Home | Module selection cards |
| `/instrumenten` | Module | Financiële Instrumenten |
| `/apparaat` | Module | Apparaatsuitgaven |
| `/inkoop` | Module | Inkoopuitgaven |
| `/provincie` | Module | Provinciale Subsidies |
| `/gemeente` | Module | Gemeentelijke Subsidies |
| `/publiek` | Module | Publiek (RVO/COA/NWO) |
| `/integraal` | Module | Cross-module search |
| `/privacybeleid` | Static | Privacy policy |

---

## URL State (Shareable Filters)

**Supported Parameters:**

| Parameter | Type | Example |
|-----------|------|---------|
| `q` | string | `?q=prorail` |
| `jaar` | number | `?jaar=2024` |
| `min_bedrag` | number | `?min_bedrag=1000000` |
| `max_bedrag` | number | `?max_bedrag=5000000` |

**Example URL:**
```
/instrumenten?q=prorail&jaar=2024&min_bedrag=1000000
```

**Not in URL (V1.0):**
- Expanded row state
- Pagination position
- Grouping selection

---

## Build & Deploy

**Build:**
```bash
cd app
npm run build
```

**Environment Variables:**
| Variable | Default | Description |
|----------|---------|-------------|
| `NEXT_PUBLIC_API_URL` | Railway API URL | Backend API endpoint |

**Deployment:**
- Platform: Railway
- Root directory: `app`
- Production URL: `rijksuitgaven-production.up.railway.app`
- Beta URL: `beta.rijksuitgaven.nl`

---

## Testing Checklist

### DataTable
- [ ] Year columns display correctly
- [ ] Collapsed years (2016-20) expandable
- [ ] Trend anomaly highlight (10%+ change)
- [ ] Sorting works (click headers)
- [ ] Pagination controls work
- [ ] Row expand/collapse works
- [ ] Sticky columns on mobile scroll

### FilterPanel
- [ ] Search input debounces (300ms)
- [ ] Year filter works
- [ ] Amount range filters work
- [ ] Clear all resets filters
- [ ] URL updates with filters
- [ ] Page refresh preserves filters

### CookieBanner
- [ ] Shows on first visit
- [ ] Dismisses on OK click
- [ ] Stays dismissed on refresh
- [ ] Privacy link navigates correctly
- [ ] Touch target >= 44x44px

### ExpandedRow
- [ ] Detail data loads on expand
- [ ] Grouping selector changes data
- [ ] Cross-module indicator shows
- [ ] Navigate to module works

---

## Document History

| Date | Change |
|------|--------|
| 2026-01-26 | Initial documentation (Week 3-4 components) |
