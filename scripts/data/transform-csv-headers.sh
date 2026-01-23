#!/bin/bash
# =====================================================
# Transform CSV headers for Supabase import
# Created: 2026-01-23
# Updated: 2026-01-23 - Remove id column (let Supabase auto-generate)
#
# Transforms MySQL export CSV headers to match
# Supabase schema (lowercase + renames + remove id)
# =====================================================

SOURCE_DIR="/Users/michielmaandag/Downloads/RoijksuitgavenSQL"
OUTPUT_DIR="/Users/michielmaandag/Downloads/RoijksuitgavenSQL/transformed"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "Transforming CSV headers..."
echo "Source: $SOURCE_DIR"
echo "Output: $OUTPUT_DIR"
echo ""

# Function to remove id column and transform headers
# Usage: transform_csv input.csv output.csv [extra_sed_commands]
transform_csv() {
    local input="$1"
    local output="$2"
    local extra_sed="$3"

    # Get header and find id column position
    local header=$(head -1 "$input")

    # Transform header: lowercase + any extra transforms
    local new_header=$(echo "$header" | tr '[:upper:]' '[:lower:]')
    if [ -n "$extra_sed" ]; then
        new_header=$(echo "$new_header" | eval "$extra_sed")
    fi

    # Find which column is "id" (1-indexed for cut)
    local id_col=$(echo "$new_header" | tr ',' '\n' | grep -n '"id"' | cut -d: -f1)

    if [ -n "$id_col" ]; then
        # Build cut command to exclude id column
        local total_cols=$(echo "$new_header" | tr ',' '\n' | wc -l)
        local cols=""
        for i in $(seq 1 $total_cols); do
            if [ "$i" -ne "$id_col" ]; then
                if [ -n "$cols" ]; then
                    cols="$cols,$i"
                else
                    cols="$i"
                fi
            fi
        done

        # Remove id from header and write
        echo "$new_header" | cut -d',' -f$cols > "$output"
        # Remove id from data rows
        tail -n +2 "$input" | cut -d',' -f$cols >> "$output"
    else
        # No id column, just transform
        echo "$new_header" > "$output"
        tail -n +2 "$input" >> "$output"
    fi
}

# 1. instrumenten.csv
echo "1/7 instrumenten.csv"
transform_csv "$SOURCE_DIR/instrumenten.csv" "$OUTPUT_DIR/instrumenten.csv"
echo "   Done: $(wc -l < "$OUTPUT_DIR/instrumenten.csv") rows"

# 2. apparaat.csv
echo "2/7 apparaat.csv"
transform_csv "$SOURCE_DIR/apparaat.csv" "$OUTPUT_DIR/apparaat.csv"
echo "   Done: $(wc -l < "$OUTPUT_DIR/apparaat.csv") rows"

# 3. inkoop.csv
echo "3/7 inkoop.csv"
transform_csv "$SOURCE_DIR/inkoop.csv" "$OUTPUT_DIR/inkoop.csv"
echo "   Done: $(wc -l < "$OUTPUT_DIR/inkoop.csv") rows"

# 4. provincie.csv
echo "4/7 provincie.csv"
transform_csv "$SOURCE_DIR/provincie.csv" "$OUTPUT_DIR/provincie.csv"
echo "   Done: $(wc -l < "$OUTPUT_DIR/provincie.csv") rows"

# 5. gemeente.csv - also rename stad -> gemeente
echo "5/7 gemeente.csv"
transform_csv "$SOURCE_DIR/gemeente.csv" "$OUTPUT_DIR/gemeente.csv" "sed 's/\"stad\"/\"gemeente\"/g'"
echo "   Done: $(wc -l < "$OUTPUT_DIR/gemeente.csv") rows"

# 6. publiek.csv
echo "6/7 publiek.csv"
transform_csv "$SOURCE_DIR/publiek.csv" "$OUTPUT_DIR/publiek.csv"
echo "   Done: $(wc -l < "$OUTPUT_DIR/publiek.csv") rows"

# 7. universal_search.csv - rename sub_source -> sub_sources, source -> sources
echo "7/7 universal_search.csv"
transform_csv "$SOURCE_DIR/universal_search.csv" "$OUTPUT_DIR/universal_search.csv" "sed 's/\"sub_source\"/\"sub_sources\"/g' | sed 's/\"source\"/\"sources\"/g'"
echo "   Done: $(wc -l < "$OUTPUT_DIR/universal_search.csv") rows"

echo ""
echo "=========================================="
echo "Transformation complete!"
echo "Files ready for import in: $OUTPUT_DIR"
echo "=========================================="
echo ""
echo "Next: Import each CSV via Supabase Dashboard"
echo "  1. Go to Table Editor"
echo "  2. Select table"
echo "  3. Insert → Import data from CSV"
echo "  4. Select file from transformed/ folder"
