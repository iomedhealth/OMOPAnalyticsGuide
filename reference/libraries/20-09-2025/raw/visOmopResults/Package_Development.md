# Page: Package Development

# Package Development

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.Rbuildignore](.Rbuildignore)
- [.gitignore](.gitignore)
- [_pkgdown.yml](_pkgdown.yml)
- [tests/testthat.R](tests/testthat.R)
- [vignettes/.gitignore](vignettes/.gitignore)

</details>



This document provides technical guidance for developers contributing to the visOmopResults package. It covers the package's build configuration, documentation structure, testing framework, and development workflow. The content focuses on the technical infrastructure that supports package development rather than the functional APIs.

For information about the package's main functionality, see [Overview](#1). For testing utilities and mock data generation, see [Testing and Mock Data](#5).

## Package Structure and Build Configuration

The visOmopResults package follows standard R package conventions with specific build and documentation configurations. The package structure is controlled by several configuration files that define what gets included in builds and how documentation is generated.

### Build Configuration Files

The package uses `.Rbuildignore` to exclude development files from the built package:

```mermaid
graph TD
    subgraph "Build Configuration"
        RBUILDIGNORE[".Rbuildignore"]
        GITIGNORE[".gitignore"]
        RPROJ["visOmopResults.Rproj"]
    end
    
    subgraph "Excluded from Build"
        RPROJ_USER[".Rproj.user"]
        GITHUB[".github"]
        README_RMD["README.Rmd"]
        LICENSE_MD["LICENSE.md"]
        PKGDOWN_YML["_pkgdown.yml"]
        DOCS["docs"]
        PKGDOWN_DIR["pkgdown"]
        CRAN_COMMENTS["cran-comments.md"]
        CRAN_SUBMISSION["CRAN-SUBMISSION"]
        CODECOV_YML["codecov.yml"]
        DOC_INST["doc, Meta"]
        REVDEP["revdep"]
    end
    
    subgraph "Included in Package"
        R_CODE["R/ directory"]
        TESTS["tests/ directory"] 
        VIGNETTES["vignettes/ directory"]
        DESCRIPTION["DESCRIPTION"]
        NAMESPACE["NAMESPACE"]
    end
    
    RBUILDIGNORE --> RPROJ_USER
    RBUILDIGNORE --> GITHUB
    RBUILDIGNORE --> README_RMD
    RBUILDIGNORE --> LICENSE_MD
    RBUILDIGNORE --> PKGDOWN_YML
    RBUILDIGNORE --> DOCS
    RBUILDIGNORE --> PKGDOWN_DIR
    RBUILDIGNORE --> CRAN_COMMENTS
    RBUILDIGNORE --> CRAN_SUBMISSION
    RBUILDIGNORE --> CODECOV_YML
    RBUILDIGNORE --> DOC_INST
    RBUILDIGNORE --> REVDEP
```

**Package Build Exclusions**

The build configuration excludes development and documentation files while preserving core package components. Key exclusions include:

| File/Directory | Purpose | Exclusion Reason |
|----------------|---------|------------------|
| `.Rproj.user` | RStudio user settings | Development-specific |
| `.github` | GitHub workflows | CI/CD configuration |
| `docs`, `pkgdown` | Generated documentation | Build artifacts |
| `revdep` | Reverse dependency checks | Development tooling |
| `doc`, `Meta` | Built vignettes | Generated content |

Sources: [.Rbuildignore:1-14](), [.gitignore:1-11]()

## Documentation System Architecture

The package uses pkgdown for generating its documentation website, with a structured organization of functions and topics defined in the configuration.

### pkgdown Configuration Structure

```mermaid
graph TB
    subgraph "pkgdown Configuration"
        PKGDOWN_YML["_pkgdown.yml"]
        URL["URL: darwin-eu.github.io/visOmopResults"]
        BOOTSTRAP["Bootstrap 5 Template"]
    end
    
    subgraph "Documentation Categories"
        TABLE_FUNCTIONS["Table functions"]
        PLOT_FUNCTIONS["Plot functions"]
        OTHER_FUNCTIONS["Other functionalities"]
    end
    
    subgraph "Table Functions Organization"
        MAIN_TABLE["Main functions<br/>visOmopTable, visTable"]
        FORMAT_TABLE["Additional table formatting<br/>format*"]
        HELPER_TABLE["Helper table functions<br/>tableType, tableOptions, etc."]
    end
    
    subgraph "Plot Functions Organization"
        PLOT_MAIN["*Plot functions"]
        PLOT_HELPER["Helper plot functions<br/>themeVisOmop, plotColumns, etc."]
    end
    
    subgraph "Other Functions Organization"
        STYLE_TEXT["Text styling<br/>customiseText"]
        MOCK_DATA["Mock data<br/>mock*"]
    end
    
    PKGDOWN_YML --> URL
    PKGDOWN_YML --> BOOTSTRAP
    PKGDOWN_YML --> TABLE_FUNCTIONS
    PKGDOWN_YML --> PLOT_FUNCTIONS
    PKGDOWN_YML --> OTHER_FUNCTIONS
    
    TABLE_FUNCTIONS --> MAIN_TABLE
    TABLE_FUNCTIONS --> FORMAT_TABLE  
    TABLE_FUNCTIONS --> HELPER_TABLE
    
    PLOT_FUNCTIONS --> PLOT_MAIN
    PLOT_FUNCTIONS --> PLOT_HELPER
    
    OTHER_FUNCTIONS --> STYLE_TEXT
    OTHER_FUNCTIONS --> MOCK_DATA
```

**Function Organization Pattern**

The pkgdown configuration uses pattern matching to automatically categorize functions:

| Pattern | Functions Matched | Purpose |
|---------|------------------|---------|
| `matches("visOmopTable\|visTable")` | `visOmopTable`, `visTable` | Main table functions |
| `matches("format")` | `formatMinCellCount`, `formatEstimateValue`, etc. | Formatting pipeline |
| `ends_with("Plot")` | `barPlot`, `scatterPlot`, `boxPlot` | Plotting functions |
| `matches("themeVisOmop\|plotColumns\|themeDarwin")` | Theme and styling functions | Plot customization |
| `contains("customiseText")` | Text formatting utilities | Text styling |
| `matches("mock")` | Mock data generators | Testing utilities |

Sources: [_pkgdown.yml:1-31]()

## Testing Framework Configuration

The package uses testthat for unit testing with a standard configuration that integrates with the package's development workflow.

### Test Configuration

```mermaid
graph LR
    subgraph "Test Setup"
        TESTTHAT_R["tests/testthat.R"]
        TESTTHAT_LIB["library(testthat)"]
        VISOMOPR_LIB["library(visOmopResults)"]
        TEST_CHECK["test_check()"]
    end
    
    subgraph "Test Execution Flow"
        LOAD_TESTTHAT["Load testthat framework"]
        LOAD_PACKAGE["Load visOmopResults package"]
        RUN_TESTS["Run all tests in tests/testthat/"]
    end
    
    subgraph "Test Artifacts"
        VIGNETTE_IGNORE["vignettes/.gitignore"]
        HTML_R_IGNORE["*.html, *.R ignored"]
    end
    
    TESTTHAT_R --> TESTTHAT_LIB
    TESTTHAT_LIB --> VISOMOPR_LIB
    VISOMOPR_LIB --> TEST_CHECK
    
    TEST_CHECK --> LOAD_TESTTHAT
    LOAD_TESTTHAT --> LOAD_PACKAGE
    LOAD_PACKAGE --> RUN_TESTS
    
    VIGNETTE_IGNORE --> HTML_R_IGNORE
```

**Test Framework Components**

The testing configuration follows testthat best practices:

- **Test Runner**: [`tests/testthat.R`]() provides the standard testthat setup
- **Library Loading**: Explicitly loads both `testthat` and `visOmopResults` packages
- **Test Discovery**: Uses `test_check("visOmopResults")` to automatically discover and run tests
- **Vignette Artifacts**: Excludes generated HTML and R files from version control

Sources: [tests/testthat.R:1-12](), [vignettes/.gitignore:1-2]()

## Development Workflow Integration

The package development workflow integrates several tools and processes to ensure code quality and documentation consistency.

### Git and Build Integration

```mermaid
flowchart TD
    subgraph "Version Control"
        GIT_REPO["Git Repository"]
        GITIGNORE[".gitignore"]
        RHISTORY[".Rhistory excluded"]
        RDATA[".Rdata excluded"]
        DS_STORE[".DS_Store excluded"]
    end
    
    subgraph "R Package Development"
        RPROJ_USER[".Rproj.user excluded"]
        QUARTO[".quarto excluded"]
        INST_DOC["inst/doc excluded"]
    end
    
    subgraph "Documentation Generation"
        DOCS_DIR["docs/ excluded"]
        DOC_META["doc/, Meta/ excluded"]
        PKGDOWN_BUILD["pkgdown build artifacts"]
    end
    
    subgraph "Dependency Management"
        REVDEP_DIR["revdep/ excluded"]
        REVERSE_DEPS["Reverse dependency checks"]
    end
    
    GIT_REPO --> GITIGNORE
    GITIGNORE --> RHISTORY
    GITIGNORE --> RDATA
    GITIGNORE --> DS_STORE
    GITIGNORE --> RPROJ_USER
    GITIGNORE --> QUARTO
    GITIGNORE --> INST_DOC
    GITIGNORE --> DOCS_DIR
    GITIGNORE --> DOC_META
    GITIGNORE --> REVDEP_DIR
    
    DOCS_DIR --> PKGDOWN_BUILD
    REVDEP_DIR --> REVERSE_DEPS
```

**Development File Management**

The development workflow excludes various file types to maintain a clean repository:

| File Category | Examples | Management Strategy |
|---------------|----------|-------------------|
| R Session Files | `.Rhistory`, `.Rdata` | Excluded from git |
| IDE Files | `.Rproj.user`, `.DS_Store` | Excluded from git |
| Generated Documentation | `docs/`, `inst/doc` | Build artifacts excluded |
| Development Tools | `revdep/`, `.quarto` | Tool-specific exclusions |

**Package Website Deployment**

The package website is configured to deploy to `https://darwin-eu.github.io/visOmopResults/` using GitHub Pages integration with pkgdown's Bootstrap 5 template.

Sources: [.gitignore:1-11](), [_pkgdown.yml:1-3]()

## Configuration Dependencies

The package development infrastructure relies on several key configuration relationships that developers should understand when making changes.

### Configuration File Relationships

```mermaid
graph TD
    subgraph "Core Package Files"
        DESCRIPTION["DESCRIPTION"]
        NAMESPACE["NAMESPACE"]
        RPROJ["visOmopResults.Rproj"]
    end
    
    subgraph "Build Configuration"
        RBUILDIGNORE[".Rbuildignore"]
        GITIGNORE[".gitignore"]
    end
    
    subgraph "Documentation Configuration"
        PKGDOWN_YML["_pkgdown.yml"]
        README_RMD["README.Rmd"]
    end
    
    subgraph "Testing Configuration"  
        TESTTHAT_R["tests/testthat.R"]
        CODECOV_YML["codecov.yml"]
    end
    
    subgraph "Generated Artifacts"
        DOCS["docs/ (website)"]
        DOC_META["doc/, Meta/ (vignettes)"]
        CRAN_SUBMISSION["CRAN-SUBMISSION"]
    end
    
    DESCRIPTION --> PKGDOWN_YML
    NAMESPACE --> TESTTHAT_R
    
    RBUILDIGNORE --> PKGDOWN_YML
    RBUILDIGNORE --> README_RMD
    RBUILDIGNORE --> DOCS
    RBUILDIGNORE --> DOC_META
    RBUILDIGNORE --> CRAN_SUBMISSION
    
    GITIGNORE --> DOCS
    GITIGNORE --> DOC_META
    
    PKGDOWN_YML --> DOCS
    TESTTHAT_R --> CODECOV_YML
```

**Configuration Dependencies**

Key relationships between configuration files:

- **Build Exclusions**: `.Rbuildignore` must exclude files referenced in `.gitignore` for generated content
- **Documentation Generation**: `_pkgdown.yml` relies on `DESCRIPTION` and `NAMESPACE` for function discovery
- **Test Integration**: `tests/testthat.R` must load the package defined in `DESCRIPTION`
- **Website Deployment**: Generated `docs/` directory must be excluded from builds but included in git for GitHub Pages

Sources: [.Rbuildignore:6-14](), [_pkgdown.yml:1-31](), [tests/testthat.R:9-12]()