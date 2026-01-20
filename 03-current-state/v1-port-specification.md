# V1.0 Specification

**Project:** Rijksuitgaven.nl SaaS Platform
**Version:** 1.0
**Date:** 2026-01-20
**Status:** UPDATED - No longer a 1:1 port (see ADR-014)

---

## Executive Summary

~~V1.0 is a **technology port** of the current rijksuitgaven.nl~~

**UPDATED:** V1.0 is a **redesign** with a smarter architecture:
- **Single-view UI** with on-the-fly aggregation (no two-view toggle)
- **Source tables only** (no pre-computed pivot tables)
- **Dynamic drill-down** with user-selectable grouping
- **Year columns always visible** for trend analysis

See **ADR-014** for the full architectural decision.

### Current Tech Stack (to replace)
- WordPress + Divi Theme
- wpDataTables plugin (data display)
- Bootstrap (UI components)
- MySQL database
- Custom PHP for data queries

### Target Tech Stack
- Next.js (frontend)
- FastAPI (backend)
- Supabase (PostgreSQL + Auth)
- Typesense (search)
- Tailwind CSS (styling)

---

## Web Archives Reference

| # | Page | File |
|---|------|------|
| 01 | Home (not logged in) | `01-Home-not logged in.html` |
| 02 | Login page | `02-Login page.html` |
| 03 | Home (logged in) | `03-Home-logged in.html` |
| 04a | Financiële instrumenten - Geconsolideerd | `04a-Zoek-Financiele instrumenten-Geconsolideerd op ontvanger.html` |
| 04b | Financiële instrumenten - Uitgebreid | `04b-Zoek-Financiele instrumenten-Uitgebreid zoeken met sorteren.html` |
| 04c | Detail page - via Geconsolideerd | `04c-Detail page-Financiele Instrument - via geconsolideerd zoeken.html` |
| 04d | Detail page - via Uitgebreid | `04d-Detail page-Financiele Instrument - via uitgebreid zoeken pagina.html` |
| 05a | Apparaatsuitgaven - Geconsolideerd | `05a-Zoek-Apparaatsuitgaven-Geconsolideerd op ontvanger.html` |
| 06a | Provinciale subsidies - Geconsolideerd | `06a-Zoek-Provinciale subsidieregisters-Geconsolideerd op ontvanger.html` |
| 06b | Provinciale subsidies - Uitgebreid | `06b-Zoek-Provinciale subsidieregisters-Uitgebreid zoeken met sorteren.html` |
| 07a | Gemeentelijke subsidies - Geconsolideerd | `07a-Zoek-Gemeentelijke subsidieregisters-Geconsolideerd op ontvanger.html` |
| 07b | Gemeentelijke subsidies - Uitgebreid | `07b-Zoek-Gemeentelijke subsidieregisters-Uitgebreid zoeken met sorteren.html` |
| 08a | Inkoopuitgaven - Geconsolideerd | `08a-Zoek-Inkoopuitgaven-Geconsolideerd op ontvanger.html` |
| 08b | Inkoopuitgaven - Uitgebreid | `08b-Zoek-Inkoopuitgaven-Uitgebreid zoeken met sorteren.html` |
| 09a | Publiek - Geconsolideerd | `09a-Zoek-Publiek-Geconsolideerd op ontvanger.html` |
| 09b | Publiek - Uitgebreid | `09b-Zoek-Publiek-Uitgebreid zoeken met sorteren.html` |
| 10a | Integraal - Geconsolideerd | `10a-Zoek-Integraal-Geconsolideerd op ontvanger.html` |
| 10b | Integraal - Uitgebreid | `10a-Zoek-Integraal-Uitgebreid zoeken met sorteren.html` |
| 11 | Support pages | `11- Support paginas.html` |
| 11a | Support example | `11a - Support example.html` |
| 13 | Over ons | `13 - Over ons.html` |

**Note:** Apparaatsuitgaven (05) only has consolidated view in archives.

---

## Component-by-Component Port Specification

### 1. Header / Navigation

**Current Implementation:**
- Logo (top-left)
- Main navigation: Zoeken (dropdown), Inzichten BETA, Support, Over ons, Contact
- Right side: Profile/Logout
- Phone number displayed

**Port Requirements:**
| Element | Port 1:1 | Notes |
|---------|----------|-------|
| Logo placement | Yes | Keep same position |
| Navigation items | Partial | Remove "Inzichten BETA" for V1.0 |
| Profile/Logout | Yes | Replace with Supabase Auth UI |
| Phone number | Yes | Keep visible |

**V1.0 Navigation:**
- Zoeken (module tabs) - replaces dropdown
- Support
- Over ons
- Contact
- Profile/Logout

**NOT in V1.0:**
- Inzichten BETA (pre-built analyses) → Post V1.0 as self-service BI feature

**NEW in V1.0:**
- Global search bar (replaces dropdown)

---

### 2. Module Navigation (Tabs)

**Current Implementation:**
- Horizontal tabs below header
- 7 modules:
  1. Financiële Instrumenten
  2. Apparaatsuitgaven
  3. Provinciale subsidieregisters
  4. Gemeentelijke subsidieregisters
  5. Inkoopuitgaven
  6. Publiek
  7. Integraal

**Port Requirements:**
| Element | Port 1:1 | Notes |
|---------|----------|-------|
| Tab layout | Yes | Horizontal tabs |
| Tab order | Yes | Keep exact order |
| Active tab styling | Yes | Pink/magenta highlight |
| Tab click behavior | Yes | Navigate to module |

---

### 3. Two-View Toggle → ELIMINATED (ADR-014)

**Current Implementation:**
- Divi `dsm_content_toggle` component
- Toggle between two views

**V1.0 NEW APPROACH: Single Smart View**

The toggle is **eliminated**. Instead:

```
┌──────────────────────────────────────────────────────────────────────────┐
│    │ Ontvanger       │ 2020   │ 2021   │ 2022   │ 2023   │ 2024  │ Totaal │
├────┼─────────────────┼────────┼────────┼────────┼────────┼───────┼────────┤
│ ▼  │ ProRail B.V.    │ €180M  │ €195M  │ €210M  │ €225M  │ €240M │ €1.2B  │
│    │  Group by: [Regeling ▼]                                             │
│    │ └─ Beh onderh   │ €120M  │ €130M  │ €140M  │ €150M  │ €160M │ €700M  │
│    │ └─ Real pers    │ €40M   │ €45M   │ €50M   │ €55M   │ €60M  │ €250M  │
│    │                                                  [Show all 847 rows] │
├────┼─────────────────┼────────┼────────┼────────┼────────┼───────┼────────┤
│ ▶  │ Rijkswaterstaat │ €150M  │ €160M  │ €170M  │ €180M  │ €190M │ €850M  │
└──────────────────────────────────────────────────────────────────────────┘
```

**Key features:**
- Year columns always visible (trend analysis)
- Aggregated by recipient by default
- Click ▶ to expand → shows grouped sub-rows
- User chooses grouping: Regeling, Artikel, Instrument, etc.
- "Show all rows" for raw data access

**Why eliminated:**
- Toggle was a database limitation, not user need
- Users want patterns, not to choose views upfront
- On-the-fly aggregation makes it unnecessary

---

### 4. Search Bar

**Current Implementation:**
- Large search input
- Placeholder: "Doorzoek €X aan [Module] - op ontvanger of uitgebreid"
- Dynamic placeholder showing total module value
- Clear button (x) appears when text entered

**Port Requirements:**
| Element | Port 1:1 | Notes |
|---------|----------|-------|
| Search bar size | Yes | Full width, prominent |
| Placeholder format | Yes | Include total € amount |
| Clear button | Yes | X button to clear |
| Search behavior | Yes | Filter table results |

**NEW in V1.0:**
- Autocomplete suggestions (<50ms)
- Typo tolerance
- Cross-module search capability

---

### 5. Data Table

**Current Implementation:**
- wpDataTables with Bootstrap styling
- Columns: Ontvanger, Year columns (2016-2024), Totaal
- Row click: Opens detail modal/expansion
- Alternating row colors (odd/even)
- Horizontal scroll on overflow
- "Download screenshot" button

**Port Requirements:**
| Element | Port 1:1 | Notes |
|---------|----------|-------|
| Column structure | Yes | Same columns per module |
| Year columns | Yes | 2016-2024 (adjust as data grows) |
| Totaal column | Yes | Sum of years |
| Row styling | Yes | Alternating colors |
| Row expansion | Yes | Click to expand details |
| Horizontal scroll | Yes | On mobile/narrow screens |
| Download screenshot | Backlog | Skip for V1.0, add later |

**NEW in V1.0:**
- Faster load times (<100ms)
- Better sorting controls
- Column customization (user preferences saved)

---

### 6. Filter Panel (Uitgebreid View Only)

**Current Implementation:**
- Bootstrap-select dropdowns
- Module-specific filters
- noUiSlider for range filters (Integraal module)
- Multi-select capability
- "Filters" collapsible section with badge count

**Port Requirements:**
| Element | Port 1:1 | Notes |
|---------|----------|-------|
| Filter dropdowns | Yes | Same options per module |
| Multi-select | Yes | Where applicable |
| Range sliders | Yes | For numeric filters |
| Collapsible panel | Yes | Expand/collapse filters |
| Active filter badge | Yes | Show count of active filters |

---

### 7. Detail View / Row Expansion

**Current Implementation:**
- Click row to navigate to detail page
- URL pattern: `/detail/[module]/?wdt_md_p_t_id=X&wdt_md_p_t_col_name=Ontvanger&wdt_md_col_value=NAME`
- Header: "Totaal X uitgaven aan Ontvanger" + recipient name
- Shows all related payments/entries
- "Sluit" (Close) button to return
- "Zoek op Google ↗" link for recipient name (external)

**See archives:**
- `04c-Detail page-Financiele Instrument - via geconsolideerd zoeken.html`
- `04d-Detail page-Financiele Instrument - via uitgebreid zoeken pagina.html`

**Port Requirements:**
| Element | Port 1:1 | Notes |
|---------|----------|-------|
| Detail page (separate URL) | Yes | `/detail/[module]/[recipient]` |
| Header with count | Yes | "Totaal X uitgaven aan Ontvanger" |
| Recipient name display | Yes | Large, prominent |
| All related entries | Yes | Table of all payments |
| Close button | Yes | "Sluit" label, returns to search |
| Google search link | Yes | External link with ↗ indicator |
| Year breakdown | Yes | Show per-year amounts |
| Detail columns | Yes | Module-specific (Regeling, Artikel, etc.) |

---

### 8. Login Page

**Current Implementation:**
- Centered login form
- Username and password fields
- "Wachtwoord vergeten?" link
- "Inloggen" button
- "Boek een demo" CTA
- Brand logo with tagline

**Port Requirements:**
| Element | Port 1:1 | Notes |
|---------|----------|-------|
| Form layout | Yes | Centered |
| Fields | Yes | Email only (Magic Link) |
| Forgot password | Yes | Link to reset |
| Demo CTA | Yes | Keep visible |
| Branding | Yes | Logo + tagline |

**Implementation:**
- Use Supabase Auth UI
- Style to match current design

---

### 9. Profile / Settings / Password Reset

**Current Implementation:** WordPress-based

**V1.0 Approach:** Redesign based on Supabase Auth capabilities

**Pages to create:**
| Page | Implementation |
|------|----------------|
| Profile settings | Custom page with Supabase user data |
| Change password | Supabase Auth flow |
| Password reset | Supabase Auth email flow |
| Column preferences | Custom (user_preferences table) |

**Design:** Modern, clean - not 1:1 port

---

### 10. Support Pages

**Current Implementation:** Static content pages (see `11a-Support example.html`)

**V1.0 Approach:** Redesign allowed

**Content to preserve:**
- FAQ content
- Contact information
- Help documentation

**Can modernize:**
- Layout and design
- Navigation structure
- Search within support

---

### 9. Footer

**Current Implementation:**
- Dark navy background
- "Ontdek Rijksuitgaven" section
- "Volg ons op" with social links (X, Bluesky, LinkedIn)
- Light purple decorative wave

**Port Requirements:**
| Element | Port 1:1 | Notes |
|---------|----------|-------|
| Layout | Yes | Same structure |
| Social links | Yes | Same platforms |
| Decorative wave | Yes | Keep visual style |
| Color scheme | Yes | Navy background |

---

## Module-Specific Requirements

### Module 1: Financiële Instrumenten

**SQL Tables:**
- Geconsolideerd: `instrumenten_pivot_geconsolideerd`
- Uitgebreid: `instrumenten_pivot`

**Filters (Uitgebreid view):**
| Filter | Type | Required |
|--------|------|----------|
| Begrotingsnaam | Dropdown | Yes |
| Artikel | Dropdown | Yes |
| Artikelonderdeel | Dropdown | Yes |
| Instrument | Dropdown | Yes |
| Detail | Dropdown | Yes |
| Regeling | Dropdown | Yes |

**Detail Columns:**
- Begrotingsnaam
- Artikel
- Artikelonderdeel
- Instrument
- Regeling

---

### Module 2: Apparaatsuitgaven

**SQL Tables:**
- Geconsolideerd: `apparaat_pivot_geconsolideerd`
- Uitgebreid: `apparaat_pivot`

**Filters (Uitgebreid view):**
| Filter | Type | Required |
|--------|------|----------|
| Kostensoort | Dropdown | Yes |
| Begrotingsnaam | Dropdown | Yes |
| Artikel | Dropdown | Yes |
| Detail | Dropdown | Yes |

**Detail Columns:**
- Kostensoort
- Begrotingsnaam
- Artikel
- Detail

---

### Module 3: Provinciale Subsidieregisters

**SQL Tables:**
- Geconsolideerd: `provincie_pivot_geconsolideerd`
- Uitgebreid: `provincie_pivot`

**Filters (Uitgebreid view):**
| Filter | Type | Required |
|--------|------|----------|
| Provincie | Dropdown | Yes |
| Omschrijving | Text/Dropdown | Yes |

**Detail Columns:**
- Provincie
- Omschrijving

---

### Module 4: Gemeentelijke Subsidieregisters

**SQL Tables:**
- Geconsolideerd: `stad_pivot_geconsolideerd`
- Uitgebreid: `stad_pivot`

**Filters (Uitgebreid view):**
| Filter | Type | Required |
|--------|------|----------|
| Gemeente | Dropdown | Yes |
| Beleidsterrein | Dropdown | Yes |
| Regeling | Dropdown | Yes |
| Omschrijving | Dropdown | Yes |
| Beleidsnota | Dropdown | Optional |

**Detail Columns:**
- Gemeente
- Beleidsterrein
- Regeling
- Omschrijving
- Beleidsnota

---

### Module 5: Inkoopuitgaven

**SQL Tables:**
- Geconsolideerd: `inkoop_pivot_geconsolideerd`
- Uitgebreid: `inkoop_pivot`

**Filters (Uitgebreid view):**
| Filter | Type | Required |
|--------|------|----------|
| Ministerie | Dropdown | Yes |
| Categorie | Dropdown | Yes |
| Staffel | Dropdown | Yes |

**Detail Columns:**
- Ministerie
- Categorie
- Staffel

**Note:** This module has 80+ category columns in source data.

---

### Module 6: Publiek

**SQL Tables:**
- Geconsolideerd: `publiek_pivot_geconsolideerd`
- Uitgebreid: `publiek_pivot`

**Filters (Uitgebreid view):**
| Filter | Type | Required |
|--------|------|----------|
| Bron | Dropdown | Yes |
| Regeling (RVO/COA) | Dropdown | Yes |
| Trefwoorden (RVO) | Dropdown | Yes |
| Sectoren (RVO) | Dropdown | Yes |
| Regio (RVO) | Dropdown | Yes |
| Staffel (COA) | Dropdown | Yes |
| Onderdeel (NWO) | Dropdown | Yes |

**Detail Columns:**
- Bron
- Regeling
- Trefwoorden
- Sectoren
- Regio
- Staffel
- Onderdeel

**Note:** Has POINT geometry field for location data (V2.0 geographic search).

---

### Module 7: Integraal (Cross-Module)

**SQL Tables:**
- `universal_search`

**Filters:**
| Filter | Type | Required |
|--------|------|----------|
| Modules per ontvanger | Multi-select | Yes |
| Instanties per ontvanger | Range slider | Yes |
| Totaal aantal betalingen | Range slider | Yes |

**Detail Columns:**
- Modules (which modules recipient appears in)
- Instanties
- Total payments

**Note:** This is the cross-module aggregation view.

---

## Features to Port 1:1

### Must Port Exactly

| Feature | Current | Port |
|---------|---------|------|
| Two-view toggle | Divi toggle | Custom component |
| Module tabs | 7 tabs | 7 tabs |
| Filter dropdowns | Bootstrap-select | Headless UI / Radix |
| Range sliders | noUiSlider | Similar component |
| Data table | wpDataTables | Custom with TanStack Table |
| Row expansion | wpDataTables detail | Custom expansion |
| Export CSV | wpDataTables export | Custom export (500 row limit) |

### Improve in Port

| Feature | Current | Improvement |
|---------|---------|-------------|
| Search speed | 5s | <100ms (Typesense) |
| Autocomplete | None | <50ms suggestions |
| Typo tolerance | None | Automatic |
| Page load | Slow | <1s |

### Redesign (Not 1:1 Port)

| Feature | Approach |
|---------|----------|
| Profile/Settings | Redesign based on Supabase Auth |
| Password reset | Supabase Auth flow |
| Support pages | Redesign allowed, preserve content |

### V1.0 Backlog (Post-Launch)

| Feature | Priority | Notes |
|---------|----------|-------|
| Download screenshot | Medium | html2canvas approach |
| Inzichten (pre-built analyses) | Low | Future: self-service BI |

---

## Data Migration Requirements

### Tables to Migrate (SOURCE TABLES ONLY - ADR-014)

| Current (MySQL) | Target (Supabase PostgreSQL) | Notes |
|-----------------|------------------------------|-------|
| `instrumenten` | `instrumenten` | Source table |
| `apparaat` | `apparaat` | Source table |
| `stad` | `gemeente` | **RENAMED** |
| `provincie` | `provincie` | Source table |
| `publiek` | `publiek` | Source table |
| `inkoop` | `inkoop` | Source table |
| `universal_search` | `universal_search` | Cross-module |

### Tables NOT Migrated (Eliminated)

| Table | Reason |
|-------|--------|
| `*_pivot` (7 tables) | Computed on-the-fly now |
| `*_pivot_geconsolideerd` (6 tables) | Computed on-the-fly now |

**Total: 7 source tables instead of 20+ tables**

### New Tables (V1.0)

| Table | Purpose |
|-------|---------|
| `users` | Supabase Auth (automatic) |
| `user_preferences` | Column customization per user per module |
| `search_history` | Recent searches (optional) |

### Table Renames (V1.0)

| Current | New | Reason |
|---------|-----|--------|
| `stad` | `gemeente` | More accurate Dutch term for municipal |
| `Stad` column | `Gemeente` | Consistency |
| `stad_pivot` | `gemeente_pivot` | If pivot tables kept |
| `stad_pivot_geconsolideerd` | `gemeente_pivot_geconsolideerd` | If pivot tables kept |

**user_preferences schema:**
```sql
CREATE TABLE user_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  module VARCHAR(50),  -- e.g., 'financiele_instrumenten'
  visible_columns JSONB,  -- e.g., ["Regeling", "Artikel"]
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, module)
);
```

---

## Visual Design to Preserve

### Colors (from web archives)

| Element | Color | Use |
|---------|-------|-----|
| Primary | Pink/Magenta (#E91E63) | CTAs, active states, toggles |
| Secondary | Navy Blue (#2C3E50) | Footer, headers |
| Background | White (#FFFFFF) | Main content |
| Accent | Light Blue | Decorative waves |
| Table odd rows | Light gray | Alternating rows |
| Table even rows | White | Alternating rows |

### Typography

| Element | Style |
|---------|-------|
| Headings | Bold, Inter/system font |
| Body | Regular, Inter/system font |
| Data/Numbers | Tabular figures |
| Links | Blue, underlined |

---

## Acceptance Criteria

### V1.0 is Complete When:

1. All 7 module pages render with correct aggregated data
2. **Single smart view works** (no toggle needed)
3. **Year columns visible** with trend data
4. **Expand/collapse works** for each recipient row
5. **Dynamic grouping works** (Regeling, Artikel, etc.)
6. All filters function correctly per module
7. Search returns results <100ms (Typesense)
8. Export CSV works (500 row limit)
9. Login/logout works (Supabase Auth)
10. Profile/settings page works
11. Column customization saved per user
12. Visual design: clean, modern (not 1:1 copy)
13. Performance: <1s page load, <200ms aggregation

### NOT in V1.0 Port:

- Research Mode (V2.0)
- AI features (V2.0)
- IBOS domain classification (V2.0)
- New visualizations (V2.0)
- Geographic search (V2.0)
- **Inzichten (pre-built analyses)** → Post V1.0 as self-service BI

### Future: Inzichten → Self-Service BI (Post V1.0)

Current "Inzichten BETA" offers pre-built reports:
- Top 50 ontvangers
- Top instrumenten / Nieuwe instrumenten
- Top artikelen / Top artikelonderdelen
- Top 50 regelingen / Nieuwe regelingen
- Begrotingsnaam overview

**Future vision:** Users create their own analyses (self-service BI)
- Custom dashboards
- Saved queries
- Scheduled reports
- Share with team

---

## Next Steps

1. Review this specification for completeness
2. Create development tasks/tickets
3. Start MySQL → Supabase data migration
4. Build component library (toggle, filters, table)
5. Implement module pages one by one
6. Add Typesense search integration
7. Test and validate against web archives

---

**Document Status:** Draft
**Last Updated:** 2026-01-20
