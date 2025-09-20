#!/bin/bash

# Script to scrape all library docs from README.md and combine into one MD file

# Extract URLs from README.md
urls=$(grep -o 'https://[^|]*' ../README.md)

# Run scrape for each URL
for url in $urls; do
    lib=$(basename "$url")
    echo "Scraping $lib from $url"
    python scrape_and_md.py "$url" -o "$lib.md"
done

# Combine all MD files
cat *.md > combined_libraries.md

# Clean up individual files (excluding combined)
for file in *.md; do
    if [[ "$file" != "combined_libraries.md" ]]; then
        rm "$file"
    fi
done

echo "Done. Combined file: combined_libraries.md"
