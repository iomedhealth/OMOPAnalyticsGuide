#!/bin/bash

# Script to scrape all library docs and deepwiki content

# Get today's date in DD-MM-YYYY format
today=$(date +%d-%m-%Y)

# Read from libraries.csv and scrape both docs and deepwiki
tail -n +2 libraries.csv | while IFS=',' read -r repo url name; do
    # Trim whitespace
    repo=$(echo "$repo" | xargs)
    url=$(echo "$url" | xargs)
    name=$(echo "$name" | xargs)
    echo "Scraping docs for $name from $url"
    base_dir="../reference/libraries/$today/raw/$name"
    mkdir -p "$base_dir"
    python scrape_and_md.py "$url" -o "$base_dir"

    echo "Scraping deepwiki for $repo"
    python scrape_deepwiki.py "$repo" "$today" --base-dir "$base_dir"
done

echo "Done. Scraped docs and deepwiki stored in ../reference/libraries/$today/raw/"
