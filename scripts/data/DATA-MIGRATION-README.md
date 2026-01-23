# Data Migration: MySQL → Supabase

**Created:** 2026-01-23
**Status:** In Progress

---

## Overview

Migration of 7 data tables from MySQL (WordPress) to Supabase (PostgreSQL).

| Table | Rows | Source |
|-------|------|--------|
| instrumenten | 674,826 | Financiële instrumenten |
| apparaat | 21,315 | Apparaatsuitgaven |
| inkoop | 635,866 | Inkoopuitgaven |
| provincie | 67,456 | Provinciale uitgaven |
| gemeente | 126,377 | Gemeentelijke uitgaven |
| publiek | 115,020 | Publiek gefinancierd |
| universal_search | 1,456,095 | Search index |

**Total:** ~3.1 million rows

---

## Export Process

### Source
- **Database:** MySQL (via PhpMyAdmin)
- **Export format:** CSV
- **Settings:** Comma delimiter, double-quote enclosure
- **Encoding:** UTF-8

### Export Location
```
/Users/michielmaandag/Downloads/RoijksuitgavenSQL/
├── apparaat.csv
├── gemeente.csv
├── inkoop.csv
├── instrumenten.csv
├── provincie.csv
├── publiek.csv
└── universal_search.csv
```

---

## Transformation Required

The MySQL export CSVs needed transformation before Supabase import:

| Issue | Solution |
|-------|----------|
| Uppercase headers | Lowercase all column names |
| `id` column present | Remove (Supabase auto-generates SERIAL) |
| `stad` column in gemeente | Rename to `gemeente` |
| `sub_source` in universal_search | Rename to `sub_sources` |
| `source` in universal_search | Rename to `sources` |
| Literal "NULL" strings | Convert to empty (PostgreSQL NULL) |
| Character encoding | Ensure UTF-8 output |

---

## Transformation Script

### Location
```
scripts/data/transform-csv-headers.py
```

### Usage
```bash
python3 scripts/data/transform-csv-headers.py
```

### Output
```
/Users/michielmaandag/Downloads/RoijksuitgavenSQL/transformed/
├── apparaat.csv
├── gemeente.csv
├── inkoop.csv
├── instrumenten.csv
├── provincie.csv
├── publiek.csv
└── universal_search.csv
```

### Full Script

```python
#!/usr/bin/env python3
"""
Transform CSV headers for Supabase import
Created: 2026-01-23

Transforms MySQL export CSV headers to match Supabase schema:
- Lowercase all column names
- Rename specific columns
- Remove 'id' column (let Supabase auto-generate)
- Convert "NULL" strings to empty (for proper PostgreSQL NULL handling)
"""

import csv
import os
from pathlib import Path

SOURCE_DIR = Path("/Users/michielmaandag/Downloads/RoijksuitgavenSQL")
OUTPUT_DIR = SOURCE_DIR / "transformed"

# Column renames (after lowercase)
RENAMES = {
    "gemeente.csv": {"stad": "gemeente"},
    "universal_search.csv": {"sub_source": "sub_sources", "source": "sources"},
}

def transform_csv(filename):
    input_path = SOURCE_DIR / filename
    output_path = OUTPUT_DIR / filename

    renames = RENAMES.get(filename, {})

    with open(input_path, 'r', encoding='utf-8') as infile:
        reader = csv.DictReader(infile)

        # Transform headers: lowercase + renames + remove id
        old_fieldnames = reader.fieldnames
        new_fieldnames = []

        for col in old_fieldnames:
            col_lower = col.lower()
            if col_lower == 'id':
                continue  # Skip id column
            if col_lower in renames:
                col_lower = renames[col_lower]
            new_fieldnames.append(col_lower)

        # Write transformed CSV
        with open(output_path, 'w', encoding='utf-8', newline='') as outfile:
            writer = csv.DictWriter(outfile, fieldnames=new_fieldnames, quoting=csv.QUOTE_ALL)
            writer.writeheader()

            row_count = 0
            for row in reader:
                new_row = {}
                for old_col in old_fieldnames:
                    col_lower = old_col.lower()
                    if col_lower == 'id':
                        continue
                    if col_lower in renames:
                        col_lower = renames[col_lower]
                    # Convert "NULL" strings to empty (PostgreSQL handles empty as NULL)
                    value = row[old_col]
                    if value == 'NULL' or value == 'null':
                        value = ''
                    new_row[col_lower] = value
                writer.writerow(new_row)
                row_count += 1

    return row_count

def main():
    # Create output directory
    OUTPUT_DIR.mkdir(exist_ok=True)

    files = [
        "instrumenten.csv",
        "apparaat.csv",
        "inkoop.csv",
        "provincie.csv",
        "gemeente.csv",
        "publiek.csv",
        "universal_search.csv",
    ]

    print("Transforming CSV headers...")
    print(f"Source: {SOURCE_DIR}")
    print(f"Output: {OUTPUT_DIR}")
    print()

    for i, filename in enumerate(files, 1):
        print(f"{i}/7 {filename}")
        if (SOURCE_DIR / filename).exists():
            rows = transform_csv(filename)
            print(f"    Done: {rows:,} rows")
        else:
            print(f"    SKIPPED: file not found")

    print()
    print("=" * 50)
    print("Transformation complete!")
    print(f"Files ready for import in: {OUTPUT_DIR}")
    print("=" * 50)
    print()
    print("Next: Import each CSV via Supabase Dashboard")
    print("  1. Go to Table Editor")
    print("  2. Select table")
    print("  3. Insert → Import data from CSV")
    print("  4. Select file from transformed/ folder")

if __name__ == "__main__":
    main()
```

---

## Import Process

### Via Supabase Dashboard

1. Go to **Table Editor**
2. Select the target table
3. Click **Insert** → **Import data from CSV**
4. Select file from `transformed/` folder
5. Verify preview shows correct data
6. Click **Import**

### Import Order (Recommended)

1. `apparaat.csv` → apparaat (21K rows)
2. `provincie.csv` → provincie (67K rows)
3. `publiek.csv` → publiek (115K rows)
4. `gemeente.csv` → gemeente (126K rows)
5. `inkoop.csv` → inkoop (636K rows)
6. `instrumenten.csv` → instrumenten (675K rows)
7. `universal_search.csv` → universal_search (1.5M rows)

### If Import Fails Mid-Way

Truncate the table and retry:

```sql
TRUNCATE TABLE table_name RESTART IDENTITY;
```

---

## Issues Encountered & Solutions

### Issue 1: "Null" Error on Import

**Error:** Import failed with "Null" error
**Cause:** CSV contained `id` column, but Supabase uses SERIAL auto-generate
**Solution:** Updated transformation script to remove `id` column

### Issue 2: "Invalid input syntax for type integer: 'NULL'"

**Error:** `ERROR: 22P02: invalid input syntax for type integer: "NULL"`
**Cause:** MySQL export contains literal string "NULL" in integer columns
**Solution:** Updated script to convert "NULL" strings to empty values

```python
# Convert "NULL" strings to empty (PostgreSQL handles empty as NULL)
value = row[old_col]
if value == 'NULL' or value == 'null':
    value = ''
```

### Issue 3: Character Encoding (ö showing as weird characters)

**Error:** "Coöperatief" displayed as "CoVöperatief" or "CoÃ¶peratief"
**Cause:** Encoding mismatch between source and transformation
**Solution:** Verified source is UTF-8, ensured script reads/writes UTF-8

```python
with open(input_path, 'r', encoding='utf-8') as infile:
```

---

## Column Mappings

### instrumenten.csv
```
MySQL Header    → Supabase Column
------------    ----------------
Id              → (removed)
Begrotingsjaar  → begrotingsjaar
Ontvanger       → ontvanger
Bedrag          → bedrag
Hoofdstuk       → hoofdstuk
Artikel         → artikel
Instrument      → instrument
Regeling        → regeling
```

### apparaat.csv
```
MySQL Header    → Supabase Column
------------    ----------------
Id              → (removed)
Begrotingsjaar  → begrotingsjaar
Hoofdstuk       → hoofdstuk
Artikel         → artikel
Kostensoort     → kostensoort
Bedrag          → bedrag
```

### inkoop.csv
```
MySQL Header    → Supabase Column
------------    ----------------
Id              → (removed)
Jaar            → jaar
Ministerie      → ministerie
Categorie       → categorie
Staffel         → staffel
Bedrag          → bedrag
```

### provincie.csv
```
MySQL Header    → Supabase Column
------------    ----------------
Id              → (removed)
Provincie       → provincie
Nummer          → nummer
Jaar            → jaar
Ontvanger       → ontvanger
Omschrijving    → omschrijving
Bedrag          → bedrag
```

### gemeente.csv
```
MySQL Header    → Supabase Column
------------    ----------------
Id              → (removed)
Stad            → gemeente (renamed)
Beleidsterrein  → beleidsterrein
Taakveld        → taakveld
Jaar            → jaar
Bedrag          → bedrag
Omschrijving    → omschrijving
```

### publiek.csv
```
MySQL Header    → Supabase Column
------------    ----------------
Id              → (removed)
Naam            → naam
Locatie         → locatie
Jaar            → jaar
Bedrag          → bedrag
Bron            → bron
```

### universal_search.csv
```
MySQL Header    → Supabase Column
------------    ----------------
Id              → (removed)
Ontvanger       → ontvanger
Jaar            → jaar
Bedrag          → bedrag
Sub_source      → sub_sources (renamed)
Source          → sources (renamed)
```

---

## Verification Queries

After import, verify row counts match:

```sql
-- Check row counts
SELECT 'instrumenten' as table_name, COUNT(*) as rows FROM instrumenten
UNION ALL SELECT 'apparaat', COUNT(*) FROM apparaat
UNION ALL SELECT 'inkoop', COUNT(*) FROM inkoop
UNION ALL SELECT 'provincie', COUNT(*) FROM provincie
UNION ALL SELECT 'gemeente', COUNT(*) FROM gemeente
UNION ALL SELECT 'publiek', COUNT(*) FROM publiek
UNION ALL SELECT 'universal_search', COUNT(*) FROM universal_search;
```

Expected results:
| table_name | rows |
|------------|------|
| instrumenten | 674,826 |
| apparaat | 21,315 |
| inkoop | 635,866 |
| provincie | 67,456 |
| gemeente | 126,377 |
| publiek | 115,020 |
| universal_search | 1,456,095 |

---

## Next Steps

After successful import:
1. Verify row counts match MySQL source
2. Spot-check data integrity (random samples)
3. Test special characters display correctly
4. Update SESSION-CONTEXT.md with completion status
