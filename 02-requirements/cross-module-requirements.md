# Cross-Module ("Integraal") Requirements

**Created:** 2026-01-20
**Source:** Brainstorm session

---

## Overview

Cross-module search allows users to search across all recipient-based modules in one view. It serves as a **discovery layer** - users find recipients, then drill down into specific modules for detail.

---

## Included Modules

| Module | Recipient Field | Included |
|--------|-----------------|----------|
| Financiële Instrumenten | `Ontvanger` | ✅ Yes |
| Gemeentelijke subsidies | `Ontvanger` | ✅ Yes |
| Provinciale subsidies | `Ontvanger` | ✅ Yes |
| Publiek (RVO/COA/NWO) | `Ontvanger` | ✅ Yes |
| Inkoopuitgaven | `Leverancier` | ✅ Yes |
| Apparaatsuitgaven | `Kostensoort` | ❌ No - separate module |

**Rationale:** Apparaatsuitgaven tracks government operational costs (cost types), not spending to external recipients. It's fundamentally different and remains a separate module.

---

## Data Architecture

### V1.0: Use Aggregated Table

Keep `universal_search` table (or equivalent) for cross-module queries.

**Reasons:**
1. Performance - single table query vs 5-table UNION
2. Data normalization - EUR values differ across modules:
   - Some modules: absolute EUR amounts
   - Some modules: amounts in thousands (x1000)
   - Aggregation script normalizes all values

**Table structure:**
```sql
CREATE TABLE universal_search (
  id INT,
  Ontvanger VARCHAR,           -- Normalized recipient name
  Sources VARCHAR,             -- Module names (comma-separated)
  Source_count INT,            -- Number of modules
  row_count INT,               -- Total payment count
  "2016" BIGINT,              -- Normalized amount
  "2017" BIGINT,
  "2018" BIGINT,
  "2019" BIGINT,
  "2020" BIGINT,
  "2021" BIGINT,
  "2022" BIGINT,
  "2023" BIGINT,
  "2024" BIGINT,
  Totaal BIGINT,
  year_count INT               -- Years with data
);
```

### Recipient Normalization (V1.0)

Use case-insensitive grouping:
```sql
GROUP BY UPPER(Ontvanger)
```

**Solves:** "politie" vs "Politie" vs "POLITIE"
**Does NOT solve:** "Politie" vs "Korps Nationale Politie"

Full entity resolution deferred to post-V1.0 (see backlog.md).

---

## UI Behavior

### Results Display

```
Search: "ProRail"

┌──────────────────────────────────────────────────────────────────────────────┐
│ ProRail B.V.                                          Total: €1.25B          │
├────────────────────────┬────────┬────────┬────────┬────────┬────────┬────────┤
│    Module              │ 2020   │ 2021   │ 2022   │ 2023   │ 2024   │ Totaal │
├────────────────────────┼────────┼────────┼────────┼────────┼────────┼────────┤
│ ALL MODULES            │ €191M  │ €208M  │ €225M  │ €234M  │ €247M  │ €1.1B  │
│ ▼ Fin. Instrumenten    │ €180M  │ €195M  │ €210M  │ €225M  │ €240M  │ €1.05B │
│   └─ Beheer onderhoud →│ €120M  │ €130M  │ €140M  │ €150M  │ €160M  │ €700M  │
│   └─ Realisatie pers → │ €40M   │ €45M   │ €50M   │ €55M   │ €60M   │ €250M  │
│ ▶ Publiek              │ €10M   │ €12M   │ €14M   │ €8M    │ €6M    │ €50M   │
│ ▶ Inkoop               │ €1M    │ €1M    │ €1M    │ €1M    │ €1M    │ €5M    │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Key Features

| Feature | Behavior |
|---------|----------|
| **Totals row** | Show grand total across ALL modules |
| **Year columns** | Always visible (2016-2024 + Totaal) |
| **Module breakdown** | Grouped by module under each recipient |
| **Expand module** | Shows module-specific grouping (Regeling, etc.) |
| **Click grouping** | Navigates to module page with filter applied |
| **Multiple matches** | Show all matching recipients, each expandable |
| **Single-module recipients** | Display normally (only 1 module shown) |

### Totals Calculation

| Total Type | Scope | Calculated By |
|------------|-------|---------------|
| **Row totals** (Totaal column) | Per recipient, all years | Backend SQL |
| **Column totals** (footer row) | Visible rows only | Frontend JavaScript |

Footer row shows "Totaal" - sum of visible rows on current page.

### Sorting

Users can sort ascending/descending on:
- Any year column (2016-2024)
- Totaal column
- Ontvanger (alphabetical)

### Filters

Based on current Integraal implementation:
- **Search bar** - Full-text search across recipients
- **Year range** - Filter by years with data (future enhancement)
- **Amount range** - Filter by total amount (future enhancement)

Minimal filtering in V1.0 - focus on search + sort.

---

## Navigation Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  CROSS-MODULE ("Integraal")                                                 │
│  Discovery layer - "Where does this recipient get money from?"              │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Click grouping row (e.g., "Beheer onderhoud →")
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  MODULE PAGE (e.g., Financiële Instrumenten)                                │
│  Pre-filtered: Ontvanger = "ProRail B.V." AND Regeling = "Beheer onderhoud" │
│  Full module functionality available                                         │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## URL Sharing (V1.0 Basic)

Cross-module URLs capture:
- Search term
- (Future: year range, amount range filters)

Example: `/integraal?q=prorail`

Full state restoration (expanded rows, scroll position) deferred to V2.0.

---

## Default State

Same as other modules: Random recipients with data in 4+ years.

---

## Performance Considerations

| Concern | Solution |
|---------|----------|
| Query speed | Use pre-aggregated `universal_search` table |
| Search speed | Typesense index on recipient names |
| Expand details | Fetch module breakdown on-demand |
| Large result sets | Pagination (50 per page) |

---

## Data Sync

When source data updates (monthly):
1. Run aggregation script on source tables
2. Rebuild `universal_search` table
3. Update Typesense index

---

## Related Documents

- [ADR-014: Single-View Architecture](../08-decisions/ADR-014-single-view-architecture.md)
- [Source Data Analysis](../03-wordpress-baseline/source-data-analysis.md)
- [Backlog - Entity Resolution](./backlog.md)
