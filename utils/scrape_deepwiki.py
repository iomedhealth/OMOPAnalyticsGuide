#!/usr/bin/env python3
"""
Script to fetch deepwiki content for a GitHub repository and store it in the reference directory.

Usage: python scrape_deepwiki.py <repo_name>

Example: python scrape_deepwiki.py oxford-pharmacoepi/COVID19VaccineSafetyDuringPregnancy
"""

import sys
import os
import re
from datetime import datetime
import asyncio
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client

def sanitize_filename(title):
    """Sanitize title for use as filename."""
    # Remove special characters and replace spaces with underscores
    sanitized = re.sub(r'[^\w\s-]', '', title)
    sanitized = re.sub(r'[-\s]+', '_', sanitized)
    return sanitized.strip('_')

async def fetch_deepwiki_content_async(repo_name):
    # Implement the call to MCP deepwiki read_wiki_contents using MCP SDK
    url = "https://mcp.deepwiki.com/mcp"

    try:
        async with streamablehttp_client(url) as (read_stream, write_stream, _):
            async with ClientSession(read_stream, write_stream) as session:
                await session.initialize()

                # Call the read_wiki_contents tool
                result = await session.call_tool("read_wiki_contents", arguments={"repoName": repo_name})

                # Extract content from result - concatenate all content blocks
                content = ""
                if result.content:
                    for content_block in result.content:
                        if hasattr(content_block, 'text'):
                            content += content_block.text
                        else:
                            content += str(content_block)
                elif hasattr(result, 'structuredContent') and result.structuredContent:
                    content = str(result.structuredContent)
                return content
    except Exception as e:
        print(f"Error fetching deepwiki content for {repo_name}: {e}")
        return ""

def fetch_deepwiki_content(repo_name):
    # Run the async function in sync context
    return asyncio.run(fetch_deepwiki_content_async(repo_name))

def process_and_save_content(repo_name, content, today=None, base_dir=None):
    # Get today's date in DD-MM-YYYY format if not provided
    if today is None:
        today = datetime.now().strftime('%d-%m-%Y')

    # Define paths
    if base_dir is None:
        base_dir = f"../reference/libraries/{today}/raw/{repo_name.replace('/', '_')}"
    os.makedirs(base_dir, exist_ok=True)

    # Split content by "# Page:"
    pages = content.split("# Page:")

    for page in pages:
        if not page.strip():
            continue

        # Extract title from first line
        lines = page.strip().split('\n', 1)
        if len(lines) < 1:
            continue

        title = lines[0].strip()
        page_content = "# Page: " + page.strip() if page.strip() else ""

        # Sanitize filename
        filename = sanitize_filename(title) + ".md"
        filepath = os.path.join(base_dir, filename)

        # Write to file
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(page_content)

        print(f"Saved page: {filename}")

import argparse

def main():
    parser = argparse.ArgumentParser(description="Fetch deepwiki content for a GitHub repository.")
    parser.add_argument('repo_name', help="GitHub repository in owner/repo format")
    parser.add_argument('date', nargs='?', help="Date in DD-MM-YYYY format (optional)")
    parser.add_argument('--base-dir', help="Base directory to save files (optional)")
    parser.add_argument('--content-file', help="File to read content from instead of fetching (optional)")

    args = parser.parse_args()

    repo_name = args.repo_name
    today = args.date
    base_dir = args.base_dir
    content_file = args.content_file

    if content_file:
        with open(content_file, 'r', encoding='utf-8') as f:
            content = f.read()
    else:
        # Fetch content using emulated tool call
        content = fetch_deepwiki_content(repo_name)

    if not content:
        print("No content available. Please provide a content file or implement fetching logic.")
        sys.exit(1)

    # Process and save
    process_and_save_content(repo_name, content, today, base_dir)

if __name__ == "__main__":
    main()