# Agent Instructions for OMOPTooling

This document provides instructions for AI agents working on this Jekyll codebase.

## Build & Local Development

**IMPORTANT:** Due to environment constraints, do not attempt to install dependencies (`bundle install`) or build the site (`jekyll build`). These commands will fail.

- **Install dependencies**: `bundle install` (or `make install`)
- **Build the site**: `bundle exec jekyll build` (or `make build`) - **DO NOT RUN**
- **Run locally**: `bundle exec jekyll serve` (or `make serve`) - **DO NOT RUN**
- **Clean the build**: `make clean` - **DO NOT RUN**

## Code Style & Conventions

- **Formatting**: Follow standard Jekyll and Liquid templating conventions. Use 2 spaces for indentation.
- **Linting**: No linting tools are configured for this project.
- **Imports**: No specific import style, but keep includes clean and organized.
- **Naming**: Use descriptive names for files, variables, and layouts.
- **Error Handling**: Ensure Liquid logic is sound and doesn't produce build errors.
- **Types**: This is a Jekyll project, so no static typing.

## Testing

- There are no automated tests in this project.
- Manually verify changes by building the site and checking the output in the `_site` directory.
