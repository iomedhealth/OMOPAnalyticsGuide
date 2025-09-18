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

.PHONY: install serve build clean help debug

help:
	@echo "Available targets:"
	@echo "  install    - Install dependencies"
	@echo "  serve      - Run the Jekyll server"
	@echo "  build      - Build the Jekyll site"
	@echo "  clean      - Clean the built site"
	@echo "  help       - Show this help message"
	@echo "  debug      - Print the path to the bundle executable"

# Install dependencies
install:
	@echo "Installing dependencies..."
	$(RUBY_PATH)/ruby -S bundle install

# Run the Jekyll server
serve:
	@echo "Starting Jekyll server..."
	$(RUBY_PATH)/ruby -S bundle exec jekyll serve

# Build the Jekyll site
build:
	@echo "Building Jekyll site..."
	$(RUBY_PATH)/ruby -S bundle exec jekyll build

# Clean the built site
clean:
	@echo "Cleaning up built site..."
	$(RUBY_PATH)/ruby -S bundle exec jekyll clean

# Debug target
debug:
	@echo -n "Using bundle executable at: "
	@which bundle

