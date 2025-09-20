#!/bin/bash

# Script to merge all .md files in each raw subdirectory into a single file in interim/
# Usage: bash merge_md.sh <date>
# Example: bash merge_md.sh 20-09-2025

if [ $# -ne 1 ]; then
    echo "Usage: $0 <date>"
    echo "Example: $0 20-09-2025"
    exit 1
fi

date="$1"
raw_dir="reference/libraries/$date/raw"
interim_dir="reference/libraries/$date/interim"

# Create interim dir if it doesn't exist
mkdir -p "$interim_dir"

# Loop through each subdirectory in raw/
for subdir in $(find "$raw_dir" -mindepth 1 -maxdepth 1 -type d); do
    if [ -d "$subdir" ]; then
        # Get the subdirectory name (e.g., CohortCharacteristics)
        name=$(basename "$subdir")
        output_file="$interim_dir/${name}.md"
        
        # Find and sort all .md files in the subdir, then concatenate
        find "$subdir" -name "*.md" -type f | sort | xargs cat > "$output_file"
        
        if [ -s "$output_file" ]; then
            echo "Merged $name into $output_file"
        else
            echo "No .md files found in $name, skipping"
            rm -f "$output_file"  # Remove empty file
        fi
    fi
done

# Also handle loose .md files in raw/ (not in subdirs)
for md_file in "$raw_dir"/*.md; do
    if [ -f "$md_file" ]; then
        name=$(basename "$md_file" .md)
        output_file="$interim_dir/${name}.md"
        cp "$md_file" "$output_file"
        echo "Copied $name into $output_file"
    fi
done

echo "Done merging for date $date."