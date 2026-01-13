# Database Analysis Summary

## Overview
Analysis of exported database schema and sample data from the current Rijksuitgaven.nl MySQL database.

**Database:** `instrumenten`
**Server:** MariaDB 12.1.2
**Character Set:** UTF-8 (utf8mb4_unicode_520_ci)
**Total Tables:** ~50+ tables
**Database Size:** ~2 GB (growing)

---

## Key Findings

### 1. Three-Table Pattern Per Module ✓ CONFIRMED

You mentioned this pattern, and the schema confirms it perfectly. For each data module, there are 3 tables:

**Pattern:**
1. **Source Table** (e.g., `instrumenten`, `apparaat`, `inkoop`, `provincie`, `stad`, `publiek`)
   - Normalized data with one row per transaction
   - Contains all detail fields
   - Year as a field value (`Begrotingsjaar` or `Jaar`)

2. **Pivot Table** (e.g., `instrumenten_pivot`, `apparaat_pivot`)
   - Individual records pivoted by year
   - Years as columns (2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024)
   - One row per unique combination of attributes
   - Includes `Totaal` column

3. **Consolidated Pivot Table** (e.g., `instrumenten_pivot_geconsolideerd`)
   - Aggregated by `Ontvanger` (recipient)
   - Years as columns
   - Multiple detail fields concatenated as longtext
   - Includes `row_count` (how many source rows)
   - Includes computed `year_count` (how many years with data)
   - Used for the "Geconsolideerd op ontvanger" view in UI

**Example - Financial Instruments Module:**
- `instrumenten` (source) - 479,215 rows
- `instrumenten_pivot` - 561,298 rows
- `instrumenten_pivot_geconsolideerd` - 266,775 rows

This pattern repeats for all 6 main modules.

---

## 2. Seven Data Modules

### Module 1: Financiële Instrumenten (Financial Instruments)
**Tables:** `instrumenten`, `instrumenten_pivot`, `instrumenten_pivot_geconsolideerd`
**Rows:** 479K source | 561K pivot | 267K consolidated
**Key Fields:**
- Ontvanger (Recipient)
- Begrotingshoofdstuk (Budget Chapter)
- Begrotingsnaam (Budget Name)
- RIS_IBOS_nummer (Reference number)
- Artikel, Artikelonderdeel
- Instrument, Regeling (Regulation)
- Detail
- Bedrag (Amount)
- KvK_nummer, Rechtsvorm, Plaats

**Years:** 2016-2024

---

### Module 2: Apparaatsuitgaven (Apparatus Expenditures)
**Tables:** `apparaat`, `apparaat_pivot`, `apparaat_pivot_geconsolideerd`
**Rows:** 21K source | 638 pivot | 415K consolidated
**Key Fields:**
- Kostensoort (Cost type) - **unique to this module**
- Budget fields (similar to instrumenten)
- Detail fields

**Years:** 2016-2024

---

### Module 3: Inkoopuitgaven (Procurement Expenditures)
**Tables:** `inkoop`, `inkoop_pivot`, `inkoop_pivot_geconsolideerd`, `inkoop_source_pivot`
**Rows:** 434K source | 619K pivot | 240K consolidated
**Key Fields:**
- Leverancier (Supplier) - **unique to this module**
- Ministerie (Ministry)
- Categorie (Category)
- Staffel (Bracket/Range)

**Special:** `inkoop_source_pivot` - extremely wide table with category columns as pivots (1000, 1110, 1120, ..., 9600)
**Years:** 2017-2024

---

### Module 4: Provinciale Subsidieregisters (Provincial Subsidies)
**Tables:** `provincie`, `provincie_pivot`, `provincie_pivot_geconsolideerd`
**Rows:** 37K source | 57K pivot | 49K consolidated
**Key Fields:**
- Provincie (Province) - **unique**
- Nummer (Number)
- Ontvanger
- Omschrijving (Description)
- Staffel

**Years:** 2018-2024

---

### Module 5: Gemeentelijke Subsidieregisters (Municipal Subsidies)
**Tables:** `stad`, `stad_pivot`, `stad_pivot_geconsolideerd`
**Rows:** 180K source | 190K pivot | 18K consolidated
**Key Fields:**
- Stad (City) - **unique**
- Nummer
- Ontvanger
- Omschrijving
- Beleidsterrein (Policy area) - **unique**
- Beleidsnota (Policy document) - **unique**
- Regeling

**Years:** 2018-2024

---

### Module 6: Publieke Uitvoeringsorganisaties (Public Implementation Organizations)
**Tables:** `publiek`, `publiek_pivot`, `publiek_pivot_geconsolideerd`, `publiekcoa`
**Rows:** 48K source | 20K pivot | 58K consolidated
**Key Fields:**
- Projectnummer (Project number) - **unique**
- Omschrijving
- Ontvanger
- KvK_nummer
- Regeling
- Locatie (POINT geometry) - **unique - geospatial data!**
- Trefwoorden (Keywords) - **unique**
- Sectoren (Sectors) - **unique**
- EU_besluit (EU decision) - **unique**
- Source, Provincie, Staffel, Onderdeel

**Years:** 2018-2024
**Special:** Has GIS/location data!

---

## 3. Universal Search Tables

**Tables:** `universal_search`, `universal_search_source`

**Purpose:** Cross-module search aggregation
- Combines data from all modules
- Groups by `Ontvanger` (recipient)
- Shows which modules (`Sources`) each recipient appears in
- Shows `Sub_sources` breakdown
- Years aggregated across all modules

**Rows:**
- `universal_search`: 2,145,227 rows (!!)
- `universal_search_source`: 905,751 rows

This is your **current search mechanism** - aggregating across all modules.

---

## 4. Analytical/Insights Tables

### Instrumenten Insights
- `instrumenten_inzichten_deviation` - Tracks year-over-year deviations
- `instrumenten_inzichten_deviation_view` - Calculated view
- `instrumenten_nieuwe_instrumenten` - New instruments by year
- `instrumenten_nieuwe_regelingen` - New regulations by year

### Top Lists
- `instrumenten_top_artikelen` - Top articles
- `instrumenten_top_artikelonderdeel` - Top article subsections
- `instrumenten_top_instrumenten` - Top instruments
- `instrumenten_top_ontvangers` - Top recipients
- `instrumenten_top_regelingen` - Top regulations

All with **Yearly** and **Overall** rankings.

### Other Analytics
- `instrumenten_view_jaar` - Yearly summary view
- `lkp_instrumenten_regeling` - Lookup table for regulations

**This shows you have a "BETA Inzichten" (Insights) feature** - matches the UI screenshot!

---

## 5. Data Characteristics

### Financial Amounts
- Stored as **integers** (amounts in thousands: `Bedrag`)
- Also `Bedrag_normalized` as **bigint** (amounts in euros)
- Example: `Bedrag = 9039` means €9,039,000

### Year Columns
Year columns are **integers** storing amounts for that year.

### Computed Columns
`year_count` - **Generated column** counting non-zero years:
```sql
GENERATED ALWAYS AS (
  case when `2016` is not null and `2016` <> 0 then 1 else 0 end +
  case when `2017` is not null and `2017` <> 0 then 1 else 0 end +
  ...
) STORED
```

This is smart - used for filtering/sorting by "how many years did this recipient receive funds?"

### Full-Text Search
Multiple tables have FULLTEXT indexes on `Ontvanger`:
- `instrumenten_pivot_geconsolideerd`
- Backup and historical tables

This enables MySQL FULLTEXT search but is **slow at scale**.

### Indexing Strategy
Heavy indexing on:
- `Ontvanger` (recipient) - most important search field
- `Ontvanger` + other fields (composite indexes for advanced filtering)
- `year_count` DESC + `id` (for pagination)

---

## 6. Data Quality Observations

### Good
- ✓ Consistent structure across modules
- ✓ UTF-8 encoding
- ✓ Year normalization
- ✓ Row counting for aggregations
- ✓ Source tracking (`Source` field)

### Issues to Address
- ⚠️ Longtext fields for concatenated data in consolidated tables
- ⚠️ No foreign key constraints
- ⚠️ Some nullable fields that shouldn't be
- ⚠️ Column years need updating each year (2025, 2026, etc.)
- ⚠️ Very wide tables (inkoop_source_pivot has 80+ columns!)
- ⚠️ Mix of varchar(255) and longtext

---

## 7. WordPress/ARMember Tables

### User Management
- `4yi3uwye_users` - WordPress users
- `4yi3uwye_usermeta` - User metadata

### ARMember (Subscription System)
- `4yi3uwye_arm_members` - Member records
- `4yi3uwye_arm_membership_setup` - Membership plans
- `4yi3uwye_arm_subscription_plans` - Subscription tiers
- `4yi3uwye_arm_payment_log` - Payment transactions

**Observation:** All membership/payment logic in ARMember tables, separate from WordPress core.

---

## 8. WordPress Plugins (27 Active)

### Critical for Migration
1. **ARMember** (membership) - Primary subscription system
2. **WPDataTables** - Data table display
3. **Mailster** + Mailgun - Email system
4. **Divi** + Supreme Modules - Page builder and UI

### Supporting Plugins
- Yoast SEO - SEO optimization
- Wordfence - Security
- WP Super Cache - Caching
- Google Site Kit - Analytics
- WP Mail SMTP - Email delivery
- WP Statistics - Usage tracking
- Code Snippets - Custom code
- Loco Translate - Translation management

### WPDataTables Extensions
- `wdt-master-detail` - Detail views
- `wdt-powerful-filters` - Advanced filtering

---

## 9. Performance Bottlenecks (Current)

### Why It's Slow (5 seconds)

1. **Universal Search Table**
   - 2.1M rows!
   - Full table scans for complex queries
   - Aggregating across modules on every search

2. **FULLTEXT Search Limitations**
   - MySQL FULLTEXT is slow for:
     - Large datasets
     - Complex boolean queries
     - Relevance ranking

3. **Pivot Table Queries**
   - Wide tables with year columns
   - Concatenated longtext fields need parsing
   - Multiple joins for consolidated views

4. **No Dedicated Search Engine**
   - All search logic in MySQL
   - No caching layer
   - No search optimization

5. **WordPress Overhead**
   - WordPress plugin architecture adds latency
   - Multiple database queries per page load
   - No API layer

---

## 10. Architecture Insights for New Platform

### What Works Well (Keep This)
✓ Three-table pattern concept (source, pivot, consolidated)
✓ Year-over-year comparison design
✓ Module separation
✓ Universal search concept
✓ Analytics/insights tables
✓ `year_count` for filtering

### What Should Change (Opportunities)
⚠️ Replace MySQL FULLTEXT with Elasticsearch/Typesense
⚠️ Normalize concatenated longtext fields
⚠️ Add proper foreign keys and relationships
⚠️ Create API layer instead of direct DB access
⚠️ Dynamic year columns → proper time-series structure
⚠️ Add caching layer (Redis)
⚠️ Separate OLTP (transactional) from OLAP (analytical) queries

---

## 11. Data Migration Strategy

### Phase 1: Direct Connection (RECOMMENDED)
**Approach:** New platform reads existing MySQL database

**Pros:**
- No data migration risk
- Fastest to launch
- Can validate against production data
- Easy rollback

**Implementation:**
1. New platform connects to existing MySQL (read-only)
2. Build API layer that queries existing tables
3. Add Elasticsearch for search (index from MySQL)
4. Add Redis for caching
5. Build new frontend
6. Launch!

### Phase 2: Data Transformation (Future)
**When:** After new platform is stable

**Changes:**
- Optimize schema (normalize, add FKs)
- Migrate to PostgreSQL (better for complex queries)
- Add proper time-series tables
- Improve data import pipeline

---

## 12. Search Strategy for New Platform

### Problem
Current: 2.1M row universal_search table + FULLTEXT on longtext → 5 seconds

### Solution
**Elasticsearch or Typesense** with this architecture:

#### Index Structure
```json
{
  "ontvanger": "PRORAIL B.V.",
  "modules": ["instrumenten", "apparaat"],
  "total_all_years": 5234567000,
  "years": {
    "2024": 234567,
    "2023": 456789,
    ...
  },
  "details": {
    "instrumenten": {
      "begrotingsnaam": ["Infrastructuurfonds", ...],
      "instrument": ["Bijdrage aan medeoverheden", ...],
      ...
    }
  }
}
```

#### Benefits
- **Sub-second search** (<100ms typical)
- **Natural language** queries possible
- **Boolean operators** (AND, OR, NOT)
- **Faceted search** (filter by year, module, amount range)
- **Typo tolerance**
- **Relevance ranking**
- **Suggestions/autocomplete**

#### API Design
```
GET /api/search?q=prorail&modules=instrumenten&year=2024
GET /api/recipients/prorail-bv
GET /api/modules/instrumenten/consolidated?ontvanger=prorail-bv
```

---

## 13. AI Integration Architecture

### Critical Requirement
AI natural language queries for financial data analysis.

### Approach: RAG (Retrieval-Augmented Generation)

```
User Query → AI → Search Query → Elasticsearch → Results → AI → Natural Language Answer
```

#### Example Flow
**User:** "Which organizations received the most infrastructure funding in 2024?"

**AI Process:**
1. Parse intent: Top recipients, Infrastructuurfonds, 2024
2. Generate search query:
   ```json
   {
     "module": "instrumenten",
     "begrotingsnaam": "Infrastructuurfonds",
     "year": 2024,
     "sort": "amount_desc",
     "limit": 10
   }
   ```
3. Execute search
4. Format results as natural language

**AI Response:** "In 2024, the top infrastructure funding recipients were: 1. ProRail B.V. (€461M), 2. Rijkswaterstaat (€234M), ..."

#### Technology Stack
- **AI Model:** OpenAI GPT-4 or Claude API
- **Vector DB:** Pinecone or Weaviate (for semantic search)
- **Search:** Elasticsearch (for structured queries)
- **Cache:** Redis (cache frequent AI queries)

---

## Next Steps

1. **Immediate:**
   - Design API layer for existing database
   - Proof of concept: Elasticsearch indexing
   - API endpoint design
   - AI query prototype

2. **Short-term:**
   - Choose tech stack (see recommendations coming)
   - Build API + search layer
   - Implement AI query system
   - Design new frontend

3. **Medium-term:**
   - User/subscription migration strategy
   - Performance testing
   - Deployment strategy

---

## Key Decisions Needed

1. **Search Engine:** Elasticsearch vs Typesense vs Algolia?
2. **Backend Framework:** Node.js vs Python vs other?
3. **Frontend Framework:** React vs Next.js vs Vue?
4. **Hosting:** Railway vs AWS vs Google Cloud?
5. **AI Provider:** OpenAI vs Anthropic (Claude) vs both?
6. **Database:** Keep MySQL vs migrate to PostgreSQL?

---

This analysis provides the foundation for architecture design and technology recommendations, coming next!
