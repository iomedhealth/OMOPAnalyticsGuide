# Makefile for Jekyll project

.DEFAULT_GOAL := help

# Default path to Ruby binaries.
# Can be overridden from the command line, e.g.:
# make RUBY_PATH=/usr/local/bin serve
RUBY_PATH ?= /opt/homebrew/opt/ruby/bin

# Prepend the Ruby path to the system's PATH
export PATH := $(RUBY_PATH):$(PATH)
export GEM_HOME := $(shell dirname $(shell dirname $(RUBY_PATH)))/lib/ruby/gems/$(shell $(RUBY_PATH)/ruby -e 'print RUBY_VERSION.split(".")[0..1].join(".")')
export GEM_PATH := $(GEM_HOME)

.PHONY: install serve build clean help debug merge_interim scrape_all merge_md

help:
	@bash utils/help.sh "$(abspath $(MAKEFILE_LIST))"


install: ## Install dependencies
	@echo "Installing dependencies..."
	$(RUBY_PATH)/ruby -S bundle install

serve: ## Run the Jekyll server
	@echo "Starting Jekyll server..."
	$(RUBY_PATH)/ruby -S bundle exec jekyll serve

build: ## Build the Jekyll site
	@echo "Building Jekyll site..."
	$(RUBY_PATH)/ruby -S bundle exec jekyll build

clean: ## Clean the built site
	@echo "Cleaning up built site..."
	$(RUBY_PATH)/ruby -S bundle exec jekyll clean

debug: ## Print the path to the bundle executable
	@echo -n "Using bundle executable at: "
	@which bundle

merge_interim: ## Merge interim markdown files
	@echo "Merging interim files..."
	@bash utils/merge_interim.sh $(DATE)

scrape_all: ## Scrape all library docs and deepwiki content
	@echo "Scraping all library docs and deepwiki content..."
	@cd utils && bash scrape_all.sh

merge_md: ## Merge raw markdown files into interim
	@echo "Merging raw markdown files..."
	@bash utils/merge_md.sh $(DATE)




