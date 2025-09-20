import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import html2text
import os
import time
import argparse
import re

def sanitize_filename(title):
    """Sanitize title for use as filename."""
    # Remove special characters and replace spaces with underscores
    sanitized = re.sub(r'[^\w\s-]', '', title)
    sanitized = re.sub(r'[-\s]+', '_', sanitized)
    return sanitized.strip('_')

def crawl_and_convert_to_markdown(base_url, output_dir):
    """
    Recursively crawls a website, converts each page to Markdown,
    and saves each page as a separate Markdown file.

    Args:
        base_url (str): The starting URL for the crawl.
        output_dir (str): The directory to save Markdown files.
    """
    # Use a set to store unique URLs to avoid duplicates and infinite loops
    collected_urls = set()
    urls_to_visit = [base_url]

    # Get the domain and specific path to ensure we stay on the target site and directory
    base_domain = urlparse(base_url).netloc
    base_path = urlparse(base_url).path
    if not base_path.endswith('/'):
        base_path += '/'

    print(f"Starting crawl from: {base_url}")

    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    while urls_to_visit:
        current_url = urls_to_visit.pop(0)

        # Remove fragment identifiers (#) to treat them as the same page
        cleaned_url = current_url.split('#')[0]

        # Skip if the URL has already been processed
        if cleaned_url in collected_urls:
            continue

        try:
            print(f"Processing: {cleaned_url}")
            
            # Add the cleaned URL to the set of processed URLs
            collected_urls.add(cleaned_url)

            response = requests.get(cleaned_url, timeout=10)
            response.raise_for_status() # Check for HTTP errors

            soup = BeautifulSoup(response.text, 'html.parser')
            
            # Find and process all links on the current page
            for link in soup.find_all('a', href=True):
                absolute_url = urljoin(cleaned_url, link['href'])
                parsed_url = urlparse(absolute_url)

                # Filter links based on your specific criteria
                # 1. Stay on the same domain
                # 2. Stay within the initial path or a sub-path
                # 3. Do not include query parameters (?) or common file extensions
                # 4. Exclude pages with only a fragment (#) if the base path is not unique
                if (parsed_url.netloc == base_domain and 
                    parsed_url.path.startswith(base_path) and 
                    not parsed_url.query and 
                    not parsed_url.path.lower().endswith(('.pdf', '.jpg', '.png', '.zip', '.tar'))):
                    
                    # Remove the fragment before adding to the queue
                    new_url_to_add = absolute_url.split('#')[0]
                    if new_url_to_add not in collected_urls and new_url_to_add not in urls_to_visit:
                        urls_to_visit.append(new_url_to_add)

            # Convert the page content to Markdown
            main_content = soup.find('body')
            if main_content:
                h = html2text.HTML2Text()
                h.body_width = 0  # To prevent line wrapping
                markdown_content = h.handle(str(main_content))

                # Extract title
                title_tag = soup.find('title')
                title = title_tag.get_text().strip() if title_tag else 'Untitled'

                # Sanitize filename
                filename = sanitize_filename(title) + '.md'
                filepath = os.path.join(output_dir, filename)

                # Write to file
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(f"# {title}\n\n")
                    f.write(markdown_content)

                print(f"Saved page: {filename}")
        
        except requests.exceptions.RequestException as e:
            print(f"Error processing {cleaned_url}: {e}")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
        
        # Add a small delay to be polite to the server
        time.sleep(1)

    print(f"\nCrawl finished. Pages saved to {output_dir}")

def main():
    """
    Parses command-line arguments and runs the web crawler.
    """
    parser = argparse.ArgumentParser(description="Recursively crawls a website and saves each page as a separate Markdown file.")
    parser.add_argument('start_url', help="The starting URL for the crawl. (e.g., 'https://deepwiki.com/oxford-pharmacoepi/RealWorldEvidenceSummerSchool2025/')")
    parser.add_argument('-o', '--output-dir', dest='output_dir', default='output',
                        help="The directory to save Markdown files. Defaults to 'output'.")

    args = parser.parse_args()

    crawl_and_convert_to_markdown(args.start_url, args.output_dir)

# Run the main function when the script is executed from the command line
if __name__ == "__main__":
    main()