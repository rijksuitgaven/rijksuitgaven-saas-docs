# Source Data Analysis

**Date:** 2026-01-20
**Purpose:** Document the RAW source tables (not pivoted) to enable smarter architecture

---

## Key Insight

The current architecture uses **pre-computed pivot tables** (`*_pivot`, `*_pivot_geconsolideerd`), but the **source data is transactional** - one row per payment/subsidy. This means we can compute aggregations **on the fly** instead of maintaining duplicate tables.

---

## Source Table Structures

### 1. instrumenten (Financiële Instrumenten)

**One row = ONE PAYMENT to ONE recipient for ONE year**

```sql
CREATE TABLE instrumenten (
  id INT,
  Begrotingsjaar INT,              -- Year (2016-2024)
  Begrotingshoofdstuk VARCHAR,     -- Budget chapter (A, B, H, IV, etc.)
  Begrotingsnaam VARCHAR,          -- Budget name
  RIS_IBOS_nummer VARCHAR,         -- IBOS classification code
  Artikel VARCHAR,                 -- Article
  Artikelonderdeel VARCHAR,        -- Article section
  Instrument VARCHAR,              -- Instrument type
  Detail VARCHAR,
  Regeling VARCHAR,                -- Regulation name
  Ontvanger VARCHAR,               -- RECIPIENT
  Bedrag INT,                      -- Amount (in thousands)
  KvK_nummer INT,                  -- Chamber of Commerce number
  Rechtsvorm VARCHAR,              -- Legal form
  Plaats VARCHAR,                  -- City/Location
  Bedrag_normalized BIGINT,        -- Amount * 1000
  Source VARCHAR                   -- "Financiële instrumenten"
);
```

**Example row:**
```
2016, 'A', 'Infrastructuurfonds', '14', 'Regionaal, lokale infrastructuur',
'Bijdrage aan medeoverheden', NULL, 'Realisatie reg/lok',
'METROPOOLREGIO ROTTERDAM DEN HAAG', 9039, ...
```

---

### 2. apparaat (Apparaatsuitgaven)

**One row = ONE COST LINE for ONE year**

**Note:** This module has NO "Ontvanger" - it uses `Kostensoort` (cost type) as the grouping field.

```sql
CREATE TABLE apparaat (
  id INT,
  Begrotingsjaar INT,
  Begrotingshoofdstuk VARCHAR,
  Begrotingsnaam VARCHAR,
  RIS_IBOS_nummer VARCHAR,
  Artikel VARCHAR,
  Artikelonderdeel VARCHAR,
  Instrument VARCHAR,
  Detail VARCHAR,
  Kostensoort VARCHAR,             -- COST TYPE (acts as "recipient")
  Bedrag INT,
  Bedrag_normalized BIGINT,
  Source VARCHAR
);
```

**Example row:**
```
2023, 'IIIA', 'Algemene Zaken', '2023.3.1.1.0.0',
'Eenheid van het algemeen regeringsbeleid', 'Coördinatie van het algemeen communicatie en regeringsbeleid',
'Diversen communicatie', 1273, ...
```

---

### 3. stad → RENAME TO gemeente (Gemeentelijke subsidies)

**One row = ONE SUBSIDY to ONE recipient**

```sql
CREATE TABLE stad (  -- RENAME TO "gemeente"
  id INT,
  Stad VARCHAR,                    -- Municipality name (RENAME TO "Gemeente")
  Nummer VARCHAR,                  -- Reference number
  Jaar INT,                        -- Year
  Ontvanger VARCHAR,               -- RECIPIENT
  Omschrijving LONGTEXT,           -- Description
  Bedrag INT,                      -- Amount
  Beleidsterrein VARCHAR,          -- Policy area
  Beleidsnota MEDIUMTEXT,          -- Policy note
  Regeling VARCHAR,                -- Regulation
  Source VARCHAR
);
```

**Example row:**
```
'Amsterdam', '2010/00001', 2010,
'Amsterdam West Binnen de Ring stichting voor openbaar primair onderwijs',
'Realisatie kook- en buurtlokaal De Roos', 203000, 'Sociaal', NULL,
'Begrotingspost Subsidie en eenmalige initiatieven SD West'
```

---

### 4. provincie (Provinciale subsidies)

**One row = ONE SUBSIDY to ONE recipient**

```sql
CREATE TABLE provincie (
  id INT,
  Provincie VARCHAR,               -- Province name
  Nummer VARCHAR,                  -- Reference number
  Jaar INT,                        -- Year
  Ontvanger VARCHAR,               -- RECIPIENT
  Omschrijving LONGTEXT,           -- Description
  Bedrag INT,                      -- Amount
  Source VARCHAR
);
```

---

### 5. publiek (Public organizations: RVO, COA, NWO)

**One row = ONE SUBSIDY/PAYMENT**

```sql
CREATE TABLE publiek (
  id INT,
  Projectnummer VARCHAR,
  Jaar INT,                        -- Year
  Omschrijving TEXT,
  Ontvanger VARCHAR,               -- RECIPIENT
  KvK_nummer VARCHAR,
  Regeling VARCHAR,                -- Regulation
  Bedrag INT,                      -- Amount
  Locatie POINT,                   -- Geographic location (for V2.0)
  Trefwoorden TEXT,                -- Keywords
  Sectoren VARCHAR,                -- Sectors
  EU_besluit VARCHAR,
  Source VARCHAR,                  -- 'RVO', 'COA', 'NWO'
  Provincie VARCHAR,
  Staffel VARCHAR,
  Onderdeel VARCHAR
);
```

---

### 6. inkoop (Inkoopuitgaven)

**One row = ONE PROCUREMENT**

**Note:** Uses `Leverancier` instead of `Ontvanger`

```sql
CREATE TABLE inkoop (
  id INT,
  Jaar INT,                        -- Year
  Ministerie VARCHAR,              -- Ministry
  Leverancier VARCHAR,             -- SUPPLIER (= recipient)
  Categorie LONGTEXT,              -- Category
  Staffel INT,                     -- Tier
  Totaal_Avg DOUBLE,               -- Average amount
  Source VARCHAR
);
```

---

## Field Mapping Summary

| Module | Recipient Field | Year Field | Amount Field |
|--------|-----------------|------------|--------------|
| instrumenten | `Ontvanger` | `Begrotingsjaar` | `Bedrag` |
| apparaat | `Kostensoort` | `Begrotingsjaar` | `Bedrag` |
| stad/gemeente | `Ontvanger` | `Jaar` | `Bedrag` |
| provincie | `Ontvanger` | `Jaar` | `Bedrag` |
| publiek | `Ontvanger` | `Jaar` | `Bedrag` |
| inkoop | `Leverancier` | `Jaar` | `Totaal_Avg` |

---

## On-the-Fly Aggregation: FEASIBLE

### Current Architecture (Pre-computed)

```
Source Table → Pivot Table → Pivot Geconsolideerd Table
     ↓              ↓                    ↓
instrumenten → instrumenten_pivot → instrumenten_pivot_geconsolideerd
```

**Problems:**
- 3x data duplication
- Sync complexity when data updates
- `<br>` joined strings in consolidated table

### Proposed Architecture (On-the-fly)

```
Source Table → PostgreSQL Query → Real-time Aggregation
     ↓              ↓                    ↓
instrumenten → GROUP BY Ontvanger → Dynamic pivot by year
```

**Benefits:**
- Single source of truth
- No sync issues
- More flexible querying
- Pattern-first queries possible

---

## Example: On-the-fly Consolidated Query

```sql
-- Get consolidated view for search term "prorail"
SELECT
  Ontvanger,
  STRING_AGG(DISTINCT Begrotingsnaam, ', ') as Begrotingsnamen,
  STRING_AGG(DISTINCT Regeling, ', ') as Regelingen,
  SUM(CASE WHEN Begrotingsjaar = 2016 THEN Bedrag ELSE 0 END) as "2016",
  SUM(CASE WHEN Begrotingsjaar = 2017 THEN Bedrag ELSE 0 END) as "2017",
  SUM(CASE WHEN Begrotingsjaar = 2018 THEN Bedrag ELSE 0 END) as "2018",
  SUM(CASE WHEN Begrotingsjaar = 2019 THEN Bedrag ELSE 0 END) as "2019",
  SUM(CASE WHEN Begrotingsjaar = 2020 THEN Bedrag ELSE 0 END) as "2020",
  SUM(CASE WHEN Begrotingsjaar = 2021 THEN Bedrag ELSE 0 END) as "2021",
  SUM(CASE WHEN Begrotingsjaar = 2022 THEN Bedrag ELSE 0 END) as "2022",
  SUM(CASE WHEN Begrotingsjaar = 2023 THEN Bedrag ELSE 0 END) as "2023",
  SUM(CASE WHEN Begrotingsjaar = 2024 THEN Bedrag ELSE 0 END) as "2024",
  SUM(Bedrag) as Totaal,
  COUNT(*) as row_count
FROM instrumenten
WHERE Ontvanger ILIKE '%prorail%'
GROUP BY Ontvanger
ORDER BY Totaal DESC;
```

### Performance Considerations

| Factor | Mitigation |
|--------|------------|
| Large table scans | Index on Ontvanger, Begrotingsjaar |
| Complex aggregations | PostgreSQL handles well up to millions of rows |
| Frequent queries | Redis cache for common searches |
| Real-time filtering | Typesense handles search, PostgreSQL aggregates results |

---

## Recommended Indexes

```sql
-- For instrumenten
CREATE INDEX idx_instrumenten_ontvanger ON instrumenten(Ontvanger);
CREATE INDEX idx_instrumenten_year ON instrumenten(Begrotingsjaar);
CREATE INDEX idx_instrumenten_regeling ON instrumenten(Regeling);

-- For gemeente (renamed from stad)
CREATE INDEX idx_gemeente_ontvanger ON gemeente(Ontvanger);
CREATE INDEX idx_gemeente_jaar ON gemeente(Jaar);
CREATE INDEX idx_gemeente_gemeente ON gemeente(Gemeente);

-- Similar for other modules...
```

---

## Estimated Row Counts

| Module | Estimated Rows | Unique Recipients |
|--------|---------------|-------------------|
| instrumenten | ~200,000 | ~50,000 |
| apparaat | ~100,000 | ~5,000 (cost types) |
| gemeente | ~300,000 | ~100,000 |
| provincie | ~50,000 | ~20,000 |
| publiek | ~500,000 | ~200,000 |
| inkoop | ~200,000 | ~50,000 |
| **Total** | **~1.3M rows** | **~425,000** |

PostgreSQL can handle this easily with proper indexing.

---

## Rename Requirements

| Current | New | Reason |
|---------|-----|--------|
| `stad` table | `gemeente` | More accurate Dutch term |
| `Stad` column | `Gemeente` | Consistency |
| `stad_pivot` | `gemeente_pivot` | If kept |
| All UI references | Update | User-facing |

---

## Next: Brainstorm Question

**If we can aggregate on-the-fly, do we still need the two-view toggle (Geconsolideerd vs Uitgebreid)?**

Or can we create a **single, smarter view** that:
1. Shows aggregated recipients by default
2. Expands to show detail rows on click
3. Filters work on the detail level but display aggregated

This would eliminate the cognitive load of choosing a view upfront.
