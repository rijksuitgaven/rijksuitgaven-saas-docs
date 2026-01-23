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
