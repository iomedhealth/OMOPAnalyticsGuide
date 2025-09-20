#!/bin/bash

# Script to merge all .md files in an interim subdirectory into a single final file.
# Usage: bash merge_interim.sh <date>
# Example: bash merge_interim.sh 20-09-2025

if [ $# -ne 1 ]; then
    echo "Usage: $0 <date>"
    echo "Example: $0 20-09-2025"
    exit 1
fi

date="$1"
interim_dir="reference/libraries/$date/interim"
final_dir="reference/libraries/$date/final"
output_file="$final_dir/combined_libraries.md"

# Create final dir if it doesn't exist
mkdir -p "$final_dir"

# Find and sort all .md files in the interim dir, then concatenate
find "$interim_dir" -name "*.md" -type f | sort | xargs cat > "$output_file"

if [ -s "$output_file" ]; then
    echo "Merged all .md files from $interim_dir into $output_file"
else
    echo "No .md files found in $interim_dir, skipping"
    rm -f "$output_file"  # Remove empty file
fi

echo "Done merging for date $date."
