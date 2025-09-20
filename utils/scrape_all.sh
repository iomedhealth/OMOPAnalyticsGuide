#!/bin/bash

# Script to scrape all library docs and deepwiki content

# Get today's date in DD-MM-YYYY format
today=$(date +%d-%m-%Y)

# Read libraries into array first, then scrape in parallel
libraries=()
while IFS=',' read -r repo url name; do
    # Trim whitespace
    repo=$(echo "$repo" | xargs)
    url=$(echo "$url" | xargs)
    name=$(echo "$name" | xargs)
    libraries+=("$repo|$url|$name")
done < <(tail -n +2 libraries.csv)

# Now process each library in parallel
for lib in "${libraries[@]}"; do
    IFS='|' read -r repo url name <<< "$lib"
    (
        echo "Scraping docs for $name from $url"
        base_dir="../reference/libraries/$today/raw/$name"
        mkdir -p "$base_dir"
        python scrape_and_md.py "$url" -o "$base_dir" &
        pid1=$!
        echo "Scraping deepwiki for $repo"
        python scrape_deepwiki.py "$repo" "$today" --base-dir "$base_dir" &
        pid2=$!
        wait $pid1 $pid2
    ) &
done
wait

echo "Done. Scraped docs and deepwiki stored in ../reference/libraries/$today/raw/"
