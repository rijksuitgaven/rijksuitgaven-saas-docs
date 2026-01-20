# ADR-014: Single-View Architecture with On-the-Fly Aggregation

**Status:** Accepted

**Date:** 2026-01-20

**Deciders:** Product Owner, Technical Lead

**Supersedes:** Original "1:1 port" approach

---

## Context and Problem Statement

The current rijksuitgaven.nl uses a two-view toggle pattern:
- "Geconsolideerd op ontvanger" (aggregated by recipient)
- "Uitgebreid zoeken met filters" (individual line items)

This exists because of pre-computed pivot tables (`*_pivot`, `*_pivot_geconsolideerd`). Users must choose a view upfront before searching.

**Problems identified in brainstorm:**
1. Users don't know recipients - they know topics (Infrastructure, Environment)
2. The toggle forces users to understand database structure
3. Pre-computed tables cause data duplication and sync complexity
4. Users want to discover patterns, not search for known recipients

---

## Decision Drivers

- **User intent:** Pattern discovery > recipient lookup
- **Data structure:** Source tables are transactional (one row per payment)
- **Technology:** PostgreSQL can aggregate 1.3M rows on-the-fly
- **Simplicity:** Fewer tables = less complexity
- **Trends:** Year columns must always be visible for trend analysis

---

## Decision Outcome

**Build a single smart view with on-the-fly aggregation and dynamic drill-down.**

No toggle. No pre-computed pivot tables. Just source tables + real-time aggregation.

### The New UI Pattern

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Search: "infrastructure"                                    [Filters ▼]     │
└──────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│    │ Ontvanger       │ 2020   │ 2021   │ 2022   │ 2023   │ 2024   │ Totaal  │
├────┼─────────────────┼────────┼────────┼────────┼────────┼────────┼─────────┤
│ ▼  │ ProRail B.V.    │ €180M  │ €195M  │ €210M  │ €225M  │ €240M  │ €1.2B   │
│    ├─────────────────┴────────┴────────┴────────┴────────┴────────┴─────────┤
│    │  Group by: [Regeling ▼]                                                │
│    ├─────────────────┬────────┬────────┬────────┬────────┬────────┬─────────┤
│    │ └─ Beh onderh   │ €120M  │ €130M  │ €140M  │ €150M  │ €160M  │ €700M   │
│    │ └─ Real pers    │ €40M   │ €45M   │ €50M   │ €55M   │ €60M   │ €250M   │
│    │                                                    [Show all 847 rows]  │
├────┼─────────────────┼────────┼────────┼────────┼────────┼────────┼─────────┤
│ ▶  │ Rijkswaterstaat │ €150M  │ €160M  │ €170M  │ €180M  │ €190M  │ €850M   │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Key features:**
1. Year columns always visible (trend analysis)
2. Aggregated by recipient by default
3. Click to expand → shows grouped sub-rows
4. User chooses grouping (Regeling, Artikel, Instrument, etc.)
5. "Show all rows" for raw data access

---

## What This Eliminates

| Eliminated | Reason |
|------------|--------|
| Two-view toggle | Single smart view handles both use cases |
| `*_pivot` tables (7) | Compute on-the-fly |
| `*_pivot_geconsolideerd` tables (6) | Compute on-the-fly |
| `<br>` joined strings | Proper aggregation with STRING_AGG |
| User cognitive load | No upfront choice needed |
| Data sync complexity | Single source of truth |

**Tables removed: 13 → Kept: 7 source tables only**

---

## What This Enables

| New Capability | Description |
|----------------|-------------|
| Pattern-first search | Search topics, discover recipients |
| Flexible grouping | Group by any dimension dynamically |
| Always-visible trends | Year columns in every view |
| Drill-down anywhere | Expand any recipient inline |
| Simpler database | Only source tables |
| Easier data updates | Update source, aggregation follows |

---

## Technical Implementation

### Database Structure (Simplified)

**KEEP (source tables):**
- `instrumenten`
- `apparaat`
- `gemeente` (renamed from `stad`)
- `provincie`
- `publiek`
- `inkoop`
- `universal_search` (for cross-module)

**DELETE (pre-computed):**
- All `*_pivot` tables
- All `*_pivot_geconsolideerd` tables

### Example Query: Aggregated View

```sql
-- Main view: recipients with year columns
SELECT
  Ontvanger,
  SUM(CASE WHEN Begrotingsjaar = 2020 THEN Bedrag ELSE 0 END) as "2020",
  SUM(CASE WHEN Begrotingsjaar = 2021 THEN Bedrag ELSE 0 END) as "2021",
  SUM(CASE WHEN Begrotingsjaar = 2022 THEN Bedrag ELSE 0 END) as "2022",
  SUM(CASE WHEN Begrotingsjaar = 2023 THEN Bedrag ELSE 0 END) as "2023",
  SUM(CASE WHEN Begrotingsjaar = 2024 THEN Bedrag ELSE 0 END) as "2024",
  SUM(Bedrag) as Totaal,
  COUNT(*) as row_count
FROM instrumenten
WHERE /* search/filter conditions */
GROUP BY Ontvanger
ORDER BY Totaal DESC
LIMIT 100;
```

### Example Query: Expanded with Grouping

```sql
-- Drill-down: group by user-selected field
SELECT
  Regeling,  -- or Artikel, Instrument, etc.
  SUM(CASE WHEN Begrotingsjaar = 2020 THEN Bedrag ELSE 0 END) as "2020",
  SUM(CASE WHEN Begrotingsjaar = 2021 THEN Bedrag ELSE 0 END) as "2021",
  -- ... other years ...
  SUM(Bedrag) as Totaal
FROM instrumenten
WHERE Ontvanger = 'PRORAIL B.V.'
GROUP BY Regeling
ORDER BY Totaal DESC;
```

### Performance Strategy

| Concern | Solution |
|---------|----------|
| Large table scans | Indexes on Ontvanger, Year, Bedrag |
| Slow aggregations | PostgreSQL handles 1.3M rows well |
| Frequent queries | Redis cache for common searches |
| Search speed | Typesense for <100ms keyword search |

### Totals Calculation

| Total Type | Scope | Calculated By |
|------------|-------|---------------|
| **Row totals** (Totaal column) | Per recipient, all years | Backend: `SUM(Bedrag)` per GROUP BY |
| **Column totals** (footer row) | Visible rows only | Frontend: JavaScript sum of visible data |

This simplifies queries (single query, no separate totals query) and shows users totals relevant to what they're viewing.

### Required Indexes

```sql
-- Per source table
CREATE INDEX idx_ontvanger ON instrumenten(Ontvanger);
CREATE INDEX idx_year ON instrumenten(Begrotingsjaar);
CREATE INDEX idx_ontvanger_year ON instrumenten(Ontvanger, Begrotingsjaar);
```

---

## Grouping Options per Module

| Module | Group By Options | Default |
|--------|------------------|---------|
| Financiële Instrumenten | Regeling, Artikel, Instrument, Begrotingsnaam | Regeling |
| Apparaatsuitgaven | Artikel, Instrument, Detail, Begrotingsnaam | Artikel |
| Provinciale subsidies | Provincie, Omschrijving | Provincie |
| Gemeentelijke subsidies | Gemeente, Beleidsterrein, Regeling | Beleidsterrein |
| Inkoopuitgaven | Ministerie, Categorie | Categorie |
| Publiek | Bron, Regeling, Sectoren | Regeling |
| Integraal | Module | Module |

---

## Positive Consequences

- **Simpler database:** 7 tables instead of 20+
- **No sync issues:** Single source of truth
- **Better UX:** No confusing toggle
- **Pattern discovery:** Users find what they didn't know to search for
- **Trend analysis:** Year columns always visible
- **Flexible exploration:** Drill down by any dimension
- **Easier maintenance:** Less code, fewer edge cases

---

## Negative Consequences

- **Not a "port":** This is a redesign, not replication
- **Query complexity:** More complex SQL in backend
- **Testing:** Need to verify aggregations match old pivot tables
- **Learning curve:** Development team needs to understand new pattern

---

## Risks and Mitigations

| Risk | Mitigation |
|------|------------|
| Aggregation performance | Test with full dataset early; add indexes |
| User confusion (change) | Clear onboarding; the new UI is simpler |
| Data accuracy | Validate against old pivot tables before launch |
| Timeline impact | Actually simpler to build (fewer tables) |

---

## Comparison: Old vs New

| Aspect | Old (Pivot Tables) | New (On-the-Fly) |
|--------|-------------------|------------------|
| Tables | 20+ | 7 |
| Toggle needed | Yes | No |
| Data duplication | 3x | 1x |
| Sync complexity | High | None |
| Update data | Rebuild all pivots | Update source only |
| Flexibility | Fixed views | Dynamic grouping |
| Trend visibility | Depends on view | Always |

---

## Links

- [Source Data Analysis](../03-current-state/source-data-analysis.md)
- [ADR-013: Search Architecture](./ADR-013-search-semantic-architecture.md)
- [Original Port Specification](../03-current-state/v1-port-specification.md) - now superseded

---

## Decision History

This decision emerged from brainstorm session on 2026-01-20:

1. Started with "1:1 port" assumption
2. Analyzed source data → discovered transactional structure
3. Questioned: "Why pre-compute if we can aggregate on-the-fly?"
4. Questioned: "Why toggle if we can show both in one view?"
5. Decision: Build it right from the start

**Key insight:** The two-view toggle was a database limitation, not a user need.
