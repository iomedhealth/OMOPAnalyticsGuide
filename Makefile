# Makefile for Jekyll project

.DEFAULT_GOAL := help

# Default path to Ruby binaries.
# Can be overridden from the command line, e.g.:
# make RUBY_PATH=/usr/local/bin serve
RUBY_PATH ?= /opt/homebrew/opt/ruby/bin

# Prepend the Ruby path to the system's PATH
export PATH := $(RUBY_PATH):$(PATH)

.PHONY: install serve build clean help

help:
	@echo "Available targets:"
	@echo "  install    - Install dependencies"
	@echo "  serve      - Run the Jekyll server"
	@echo "  build      - Build the Jekyll site"
	@echo "  clean      - Clean the built site"
	@echo "  help       - Show this help message"

# Install dependencies
install:
	@echo "Installing dependencies..."
	bundle install

# Run the Jekyll server
serve:
	@echo "Starting Jekyll server..."
	bundle exec jekyll serve

# Build the Jekyll site
build:
	@echo "Building Jekyll site..."
	bundle exec jekyll build

# Clean the built site
clean:
	@echo "Cleaning up built site..."
	bundle exec jekyll clean

