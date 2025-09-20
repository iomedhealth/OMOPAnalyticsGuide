# Page: Documentation and CI/CD

# Documentation and CI/CD

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.Rbuildignore](.Rbuildignore)
- [.github/.gitignore](.github/.gitignore)
- [.github/workflows/R-CMD-check.yaml](.github/workflows/R-CMD-check.yaml)
- [.github/workflows/pkgdown.yaml](.github/workflows/pkgdown.yaml)
- [.github/workflows/test-coverage.yaml](.github/workflows/test-coverage.yaml)
- [_pkgdown.yml](_pkgdown.yml)
- [codecov.yml](codecov.yml)
- [vignettes/.gitignore](vignettes/.gitignore)
- [vignettes/create_cohorts.Rmd](vignettes/create_cohorts.Rmd)
- [vignettes/mock_data.Rmd](vignettes/mock_data.Rmd)

</details>



This page documents the documentation generation system and continuous integration/continuous deployment (CI/CD) pipeline for the DrugUtilisation package. This covers the automated processes for building package documentation, running tests, checking code quality, and deploying the package website.

For information about the testing framework and mock data generation, see [Testing and Mock Data](#9.2). For details about the package's public API and exported functions, see [Function Exports and API](#9.1).

## Documentation System

The DrugUtilisation package uses a comprehensive documentation system built around `pkgdown` for website generation and R Markdown vignettes for detailed usage guides.

### pkgdown Configuration

The package website is configured through `_pkgdown.yml`, which defines the site structure, reference organization, and vignette grouping:

```mermaid
graph TB
    subgraph "Documentation Sources"
        PKGDOWN["_pkgdown.yml<br/>Site Configuration"]
        VIGNETTES["vignettes/*.Rmd<br/>Usage Guides"]
        ROXYGEN["R/*.R<br/>Function Documentation"]
    end
    
    subgraph "pkgdown Build Process"
        BUILD["pkgdown::build_site()"]
        REFERENCE["Reference Pages<br/>Function docs"]
        ARTICLES["Articles<br/>Vignette HTML"]
        WEBSITE["Package Website<br/>docs/"]
    end
    
    subgraph "Deployment"
        GHPAGES["GitHub Pages<br/>gh-pages branch"]
        URL["https://darwin-eu.github.io/DrugUtilisation/"]
    end
    
    PKGDOWN --> BUILD
    VIGNETTES --> BUILD
    ROXYGEN --> BUILD
    
    BUILD --> REFERENCE
    BUILD --> ARTICLES
    BUILD --> WEBSITE
    
    WEBSITE --> GHPAGES
    GHPAGES --> URL
```

The site configuration organizes functions into logical groups and defines the vignette structure. Key organizational elements include:

| Section | Purpose | Functions |
|---------|---------|-----------|
| Generate drug cohorts | Cohort creation functions | `generateDrugUtilisationCohortSet`, `generateIngredientCohortSet` |
| Apply inclusion criteria | Cohort filtering functions | `requirePriorDrugWashout`, `requireIsFirstDrugEntry` |
| Drug use functions | Core analysis functions | `addDrugUtilisation`, `summariseDrugUtilisation` |
| Individual drug functions | Specific metric functions | `addNumberExposures`, `addDaysExposed` |

Sources: [_pkgdown.yml:1-93]()

### Vignette System

The package includes comprehensive vignettes that demonstrate package functionality:

```mermaid
graph LR
    subgraph "Vignette Categories"
        BASIC["mock_data.Rmd<br/>Basic Usage"]
        COHORTS["create_cohorts.Rmd<br/>Cohort Management"]
        ANALYSIS["Analysis Vignettes<br/>indication.Rmd<br/>daily_dose_calculation.Rmd<br/>drug_utilisation.Rmd"]
        ADVANCED["Advanced Topics<br/>summarise_treatments.Rmd<br/>treatment_discontinuation.Rmd<br/>drug_restart.Rmd"]
    end
    
    subgraph "Build Process"
        KNITR["knitr::rmarkdown"]
        HTML["HTML Articles"]
    end
    
    subgraph "Integration"
        PKGDOWN_ARTICLES["pkgdown articles section"]
        WEBSITE_NAV["Website navigation"]
    end
    
    BASIC --> KNITR
    COHORTS --> KNITR
    ANALYSIS --> KNITR
    ADVANCED --> KNITR
    
    KNITR --> HTML
    HTML --> PKGDOWN_ARTICLES
    PKGDOWN_ARTICLES --> WEBSITE_NAV
```

Each vignette follows a consistent structure with YAML headers specifying metadata for both R Markdown processing and pkgdown integration.

Sources: [vignettes/create_cohorts.Rmd:1-12](), [vignettes/mock_data.Rmd:1-8](), [_pkgdown.yml:5-16]()

## CI/CD Pipeline

The package uses GitHub Actions for automated testing, documentation building, and deployment through three main workflows.

### Workflow Architecture

```mermaid
graph TB
    subgraph "Trigger Events"
        PUSH["Push to main/master"]
        PR["Pull Request"]
        RELEASE["Release Published"]
        MANUAL["Manual Dispatch"]
    end
    
    subgraph "GitHub Actions Workflows"
        CHECK[".github/workflows/R-CMD-check.yaml<br/>Package Validation"]
        COVERAGE[".github/workflows/test-coverage.yaml<br/>Code Coverage"]
        PKGDOWN_WF[".github/workflows/pkgdown.yaml<br/>Documentation Deployment"]
    end
    
    subgraph "Execution Environment"
        UBUNTU["ubuntu-latest<br/>R release version"]
        DEPS["R Dependencies<br/>+ duckdb 1.2.2"]
        PANDOC["Pandoc Setup"]
    end
    
    subgraph "Outputs"
        CHECK_RESULTS["Check Results"]
        COV_REPORT["Coverage Report<br/>Codecov"]
        DOCS_DEPLOY["Documentation Site<br/>GitHub Pages"]
    end
    
    PUSH --> CHECK
    PUSH --> COVERAGE
    PUSH --> PKGDOWN_WF
    PR --> CHECK
    PR --> COVERAGE
    PR --> PKGDOWN_WF
    RELEASE --> PKGDOWN_WF
    MANUAL --> PKGDOWN_WF
    
    CHECK --> UBUNTU
    COVERAGE --> UBUNTU
    PKGDOWN_WF --> UBUNTU
    
    UBUNTU --> DEPS
    UBUNTU --> PANDOC
    
    CHECK --> CHECK_RESULTS
    COVERAGE --> COV_REPORT
    PKGDOWN_WF --> DOCS_DEPLOY
```

Sources: [.github/workflows/R-CMD-check.yaml:3-7](), [.github/workflows/test-coverage.yaml:3-7](), [.github/workflows/pkgdown.yaml:3-9]()

### R Package Check Workflow

The `R-CMD-check.yaml` workflow performs comprehensive package validation:

```mermaid
graph TD
    subgraph "Setup Phase"
        CHECKOUT["actions/checkout@v3"]
        SETUP_PANDOC["r-lib/actions/setup-pandoc@v2"]
        SETUP_R["r-lib/actions/setup-r@v2<br/>R release version"]
    end
    
    subgraph "Dependencies"
        DEPS["r-lib/actions/setup-r-dependencies@v2"]
        RCMDCHECK["any::rcmdcheck"]
        DUCKDB["duckdb_1.2.2.tar.gz<br/>Specific version"]
    end
    
    subgraph "Validation"
        CHECK["r-lib/actions/check-r-package@v2"]
        SNAPSHOTS["Upload snapshots"]
    end
    
    subgraph "Environment Variables"
        GITHUB_PAT["GITHUB_PAT: secrets.GITHUB_TOKEN"]
        PKG_SOURCE["R_KEEP_PKG_SOURCE: yes"]
    end
    
    CHECKOUT --> SETUP_PANDOC
    SETUP_PANDOC --> SETUP_R
    SETUP_R --> DEPS
    DEPS --> RCMDCHECK
    DEPS --> DUCKDB
    RCMDCHECK --> CHECK
    DUCKDB --> CHECK
    CHECK --> SNAPSHOTS
    
    GITHUB_PAT -.-> CHECK
    PKG_SOURCE -.-> CHECK
```

The workflow runs on Ubuntu with the R release version and includes a specific version of duckdb for consistent database testing.

Sources: [.github/workflows/R-CMD-check.yaml:11-48]()

### Test Coverage Workflow

The `test-coverage.yaml` workflow generates and reports code coverage metrics:

```mermaid
graph TD
    subgraph "Coverage Generation"
        COVR_SETUP["Setup R + covr package"]
        PACKAGE_COV["covr::package_coverage()<br/>Generate coverage data"]
        COBERTURA["covr::to_cobertura()<br/>Convert to XML format"]
    end
    
    subgraph "Reporting"
        CODECOV["codecov/codecov-action@v4<br/>Upload to Codecov"]
        TOKEN["CODECOV_TOKEN secret"]
    end
    
    subgraph "Artifacts"
        TESTTHAT["Show testthat output<br/>Debug failures"]
        UPLOAD["Upload test failures<br/>On failure only"]
    end
    
    subgraph "Configuration"
        CODECOV_YML["codecov.yml<br/>Coverage thresholds"]
    end
    
    COVR_SETUP --> PACKAGE_COV
    PACKAGE_COV --> COBERTURA
    COBERTURA --> CODECOV
    TOKEN -.-> CODECOV
    
    PACKAGE_COV --> TESTTHAT
    TESTTHAT --> UPLOAD
    
    CODECOV_YML -.-> CODECOV
```

The coverage workflow includes artifact collection for debugging test failures and uploads results to Codecov for tracking coverage over time.

Sources: [.github/workflows/test-coverage.yaml:19-65](), [codecov.yml:1-15]()

### Documentation Deployment Workflow

The `pkgdown.yaml` workflow builds and deploys the package website:

```mermaid
graph TD
    subgraph "Build Process"
        SETUP["Setup R + Dependencies<br/>pkgdown package"]
        BUILD["pkgdown::build_site_github_pages()<br/>Generate website"]
        DOCS["docs/ directory<br/>Generated site"]
    end
    
    subgraph "Deployment"
        DEPLOY["JamesIves/github-pages-deploy-action@v4.5.0"]
        GHPAGES["gh-pages branch"]
        WEBSITE["Published website<br/>GitHub Pages"]
    end
    
    subgraph "Concurrency Control"
        CONCURRENCY["group: pkgdown-${{ github.event_name }}"]
        RESTRICT["Non-PR jobs only"]
    end
    
    subgraph "Permissions"
        READ["permissions: read-all"]
        WRITE["contents: write<br/>For deployment"]
    end
    
    SETUP --> BUILD
    BUILD --> DOCS
    DOCS --> DEPLOY
    DEPLOY --> GHPAGES
    GHPAGES --> WEBSITE
    
    CONCURRENCY -.-> DEPLOY
    RESTRICT -.-> DEPLOY
    READ -.-> BUILD
    WRITE -.-> DEPLOY
```

The deployment only occurs for non-pull request events to prevent unauthorized deployments while still allowing testing of documentation builds.

Sources: [.github/workflows/pkgdown.yaml:15-49]()

## Build Configuration

### Package Build Settings

The `.Rbuildignore` file excludes development and documentation files from the package build:

| Pattern | Purpose |
|---------|---------|
| `^\.github$` | Exclude GitHub Actions workflows |
| `^_pkgdown\.yml$` | Exclude pkgdown configuration |
| `^docs$`, `^pkgdown$` | Exclude generated documentation |
| `^vignettes/.*\.Rmd$` | Exclude specific vignettes from build |
| `^extras/` | Exclude development scripts |

Sources: [.Rbuildignore:1-22]()

### Coverage Configuration

The `codecov.yml` file configures coverage reporting thresholds:

```yaml
coverage:
  status:
    project:
      target: auto
      threshold: 1%
      informational: true
    patch:
      target: auto  
      threshold: 1%
      informational: true
```

Both project and patch coverage use automatic targets with 1% thresholds set to informational mode, allowing flexibility while maintaining visibility into coverage trends.

Sources: [codecov.yml:3-15]()

## Deployment Process

### Website Publishing

The documentation website follows this deployment flow:

```mermaid
graph LR
    subgraph "Source"
        MAIN["main branch<br/>Source code"]
        CONFIG["_pkgdown.yml<br/>Site configuration"]
    end
    
    subgraph "Build"
        ACTION["GitHub Action<br/>pkgdown workflow"]
        SITE["Generated site<br/>docs/ directory"]
    end
    
    subgraph "Deployment"
        GHPAGES["gh-pages branch<br/>Static files"]
        PAGES["GitHub Pages<br/>darwin-eu.github.io/DrugUtilisation"]
    end
    
    MAIN --> ACTION
    CONFIG --> ACTION
    ACTION --> SITE
    SITE --> GHPAGES
    GHPAGES --> PAGES
```

The site is automatically updated on pushes to main and releases, ensuring documentation stays current with code changes.

### Integration Points

The CI/CD system integrates with several external services:

| Service | Purpose | Configuration |
|---------|---------|---------------|
| GitHub Pages | Website hosting | Automatic deployment from gh-pages branch |
| Codecov | Coverage reporting | Token-based authentication via secrets |
| CRAN | Package repository | R-CMD-check validation for submission |
| R-universe | Development builds | Automatic from GitHub releases |

Sources: [_pkgdown.yml:1](), [.github/workflows/pkgdown.yaml:43-49](), [.github/workflows/test-coverage.yaml:44-50]()