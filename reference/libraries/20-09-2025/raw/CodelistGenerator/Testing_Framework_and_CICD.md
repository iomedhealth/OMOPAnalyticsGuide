# Page: Testing Framework and CI/CD

# Testing Framework and CI/CD

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.github/.gitignore](.github/.gitignore)
- [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)
- [.github/ISSUE_TEMPLATE/bug_report.md](.github/ISSUE_TEMPLATE/bug_report.md)
- [.github/ISSUE_TEMPLATE/feature_request.md](.github/ISSUE_TEMPLATE/feature_request.md)
- [.github/workflows/R-CMD-check.yaml](.github/workflows/R-CMD-check.yaml)
- [.github/workflows/pkgdown.yaml](.github/workflows/pkgdown.yaml)
- [.github/workflows/test-coverage.yaml](.github/workflows/test-coverage.yaml)
- [R/subsetOnDomain.R](R/subsetOnDomain.R)

</details>



## Purpose and Scope

This document covers the comprehensive testing framework and continuous integration/continuous deployment (CI/CD) infrastructure for the CodelistGenerator package. It details the automated testing pipelines, code quality assurance processes, and development workflows that ensure package reliability across multiple database backends and R environments.

For information about multi-database support architecture, see [Multi-Database Support](#7.1). For details about mock data utilities used in testing, see [Mock Data and Testing Utilities](#8.2).

## CI/CD Pipeline Architecture

The CodelistGenerator package employs a robust CI/CD pipeline built on GitHub Actions with three primary workflows that provide comprehensive validation and deployment automation.

```mermaid
graph TB
    subgraph "Trigger Events"
        PUSH["Push to main/master"]
        PR["Pull Request"]
        RELEASE["Release Published"]
        MANUAL["workflow_dispatch"]
    end
    
    subgraph "GitHub Actions Workflows"
        subgraph "R-CMD-check.yaml"
            SETUP_R["setup-r@v2"]
            SETUP_DEPS["setup-r-dependencies@v2"]
            CMD_CHECK["check-r-package@v2"]
            RCMDCHECK["rcmdcheck"]
        end
        
        subgraph "test-coverage.yaml"
            SETUP_COV["setup-r-dependencies@v2"]
            COVERAGE["covr::package_coverage()"]
            COBERTURA["covr::to_cobertura()"]
            CODECOV["codecov/codecov-action@v4"]
        end
        
        subgraph "pkgdown.yaml"
            SETUP_PKG["setup-r-dependencies@v2"]
            BUILD_SITE["pkgdown::build_site_github_pages()"]
            DEPLOY["JamesIves/github-pages-deploy-action@v4.4.1"]
        end
    end
    
    subgraph "Outputs"
        CHECK_RESULTS["Package Check Results"]
        COV_REPORT["Coverage Report"]
        DOCS_SITE["Documentation Website"]
        ARTIFACTS["Test Artifacts"]
    end
    
    PUSH --> SETUP_R
    PR --> SETUP_R
    PUSH --> SETUP_COV
    PR --> SETUP_COV
    PUSH --> SETUP_PKG
    PR --> SETUP_PKG
    RELEASE --> SETUP_PKG
    MANUAL --> SETUP_PKG
    
    SETUP_R --> SETUP_DEPS
    SETUP_DEPS --> CMD_CHECK
    CMD_CHECK --> RCMDCHECK
    RCMDCHECK --> CHECK_RESULTS
    
    SETUP_COV --> COVERAGE
    COVERAGE --> COBERTURA
    COBERTURA --> CODECOV
    CODECOV --> COV_REPORT
    CODECOV --> ARTIFACTS
    
    SETUP_PKG --> BUILD_SITE
    BUILD_SITE --> DEPLOY
    DEPLOY --> DOCS_SITE
```

**CI/CD Pipeline Overview**

The pipeline consists of three specialized workflows that run on Ubuntu environments:

| Workflow | Purpose | Triggers | Key Actions |
|----------|---------|----------|-------------|
| `R-CMD-check` | Package validation | Push, PR | `rcmdcheck`, dependency resolution |
| `test-coverage` | Code coverage analysis | Push, PR | `covr`, Codecov reporting |
| `pkgdown` | Documentation deployment | Push, PR, Release | Site building, GitHub Pages |

Sources: [.github/workflows/R-CMD-check.yaml:1-49](), [.github/workflows/test-coverage.yaml:1-62](), [.github/workflows/pkgdown.yaml:1-47]()

## Testing Strategy and Framework

The testing framework employs a multi-layered approach that combines unit testing, integration testing, and cross-platform validation to ensure package functionality across diverse database environments.

### Core Testing Components

The testing strategy is built around several key components:

- **`devtools::test()`** - Primary test runner for the testthat framework
- **`devtools::test_coverage()`** - Local coverage analysis during development  
- **`covr::package_coverage()`** - CI coverage computation with detailed reporting
- **Mock data utilities** - Isolated testing with `mockVocabRef()` and related functions

### Test Execution Workflow

```mermaid
graph LR
    subgraph "Local Development"
        DEV_TEST["devtools::test()"]
        DEV_COV["devtools::test_coverage()"]
        DEV_CHECK["devtools::check()"]
    end
    
    subgraph "CI Environment"
        CI_DEPS["setup-r-dependencies"]
        CI_CHECK["check-r-package"]
        CI_COV["covr::package_coverage"]
        CI_UPLOAD["codecov upload"]
    end
    
    subgraph "Quality Gates"
        RCMD_PASS["R CMD check PASS"]
        COV_THRESHOLD["Coverage Threshold"]
        NO_WARNINGS["Zero Warnings"]
    end
    
    subgraph "Test Types"
        UNIT["Unit Tests with Mock Data"]
        INTEGRATION["Integration Tests"]
        EXAMPLES["Example Code Validation"]
        VIGNETTES["Vignette Compilation"]
    end
    
    DEV_TEST --> CI_DEPS
    DEV_COV --> CI_COV
    DEV_CHECK --> CI_CHECK
    
    CI_DEPS --> CI_CHECK
    CI_CHECK --> UNIT
    CI_CHECK --> INTEGRATION
    CI_CHECK --> EXAMPLES
    CI_CHECK --> VIGNETTES
    
    CI_COV --> CI_UPLOAD
    
    UNIT --> RCMD_PASS
    INTEGRATION --> RCMD_PASS
    EXAMPLES --> NO_WARNINGS
    VIGNETTES --> NO_WARNINGS
    CI_UPLOAD --> COV_THRESHOLD
```

**Test Coverage and Reporting**

The coverage workflow uses `covr::package_coverage()` with specific configuration for comprehensive analysis, including clean installation paths and Cobertura XML output for integration with Codecov services.

Sources: [.github/workflows/test-coverage.yaml:32-39](), [.github/CONTRIBUTING.md:24-35]()

## Development Workflow and Quality Assurance

The development workflow integrates multiple quality assurance checkpoints that developers must satisfy before contributing code changes.

### Pre-Contribution Requirements

Before submitting pull requests, developers must execute a comprehensive validation sequence:

```mermaid
graph TD
    subgraph "Documentation Updates"
        DOC_UPDATE["devtools::document()"]
        RUN_EXAMPLES["devtools::run_examples()"]
        BUILD_README["devtools::build_readme()"]
        BUILD_VIGNETTES["devtools::build_vignettes()"]
        CHECK_MAN["devtools::check_man()"]
    end
    
    subgraph "Code Quality Checks"
        LINT["lintr::lint_package()"]
        STYLE_CHECK["camelCase validation"]
        SPELL_CHECK["spelling::spell_check_package()"]
        URL_CHECK["urlchecker::url_check()"]
    end
    
    subgraph "Testing and Validation"
        TEST_RUN["devtools::test()"]
        TEST_COV["devtools::test_coverage()"]
        PKG_CHECK["devtools::check()"]
        CRAN_CHECK["rcmdcheck::rcmdcheck()"]
        WIN_CHECK["devtools::check_win_devel()"]
    end
    
    subgraph "Specialized Procedures"
        VIGNETTE_PRECOMPUTE["precomputeVignetteData.R"]
        MOCK_TESTING["mockVocabRef() validation"]
    end
    
    DOC_UPDATE --> RUN_EXAMPLES
    RUN_EXAMPLES --> BUILD_README
    BUILD_README --> BUILD_VIGNETTES
    BUILD_VIGNETTES --> CHECK_MAN
    
    CHECK_MAN --> LINT
    LINT --> STYLE_CHECK
    STYLE_CHECK --> SPELL_CHECK
    SPELL_CHECK --> URL_CHECK
    
    URL_CHECK --> TEST_RUN
    TEST_RUN --> TEST_COV
    TEST_COV --> PKG_CHECK
    PKG_CHECK --> CRAN_CHECK
    CRAN_CHECK --> WIN_CHECK
    
    WIN_CHECK --> VIGNETTE_PRECOMPUTE
    VIGNETTE_PRECOMPUTE --> MOCK_TESTING
```

**Code Style and Linting Standards**

The package enforces strict code style requirements using `lintr::lint_package()` with camelCase naming conventions. The linting configuration specifically validates object naming patterns to ensure consistency across the codebase.

**Vignette Data Precomputation**

For vignettes requiring database connectivity, the package includes a specialized precomputation script that generates results against full vocabulary databases, ensuring reproducible documentation without requiring live database connections during builds.

Sources: [.github/CONTRIBUTING.md:12-70](), [.github/CONTRIBUTING.md:40-46]()

## Issue Tracking and Bug Reporting

The testing framework is supported by structured issue tracking templates that facilitate systematic bug reporting and feature requests.

### Bug Report Template Structure

The bug report template includes standardized sections for:
- **Reproduction steps** - Detailed sequence for reproducing issues
- **Expected behavior** - Clear specification of intended functionality  
- **Environment details** - OS, browser, and version information
- **Additional context** - Supporting information and screenshots

### Feature Request Process

Feature requests follow a structured template requiring:
- **Problem description** - Clear articulation of the underlying issue
- **Proposed solution** - Detailed description of desired functionality
- **Alternative considerations** - Evaluation of alternative approaches

The contributing guidelines emphasize that CodelistGenerator is developed as part of the DARWIN EU project and is closed to external contributions, requiring issue-based coordination before any development work.

Sources: [.github/ISSUE_TEMPLATE/bug_report.md:1-39](), [.github/ISSUE_TEMPLATE/feature_request.md:1-21](), [.github/CONTRIBUTING.md:1-11]()

## Artifact Management and Failure Handling

The CI/CD pipeline includes comprehensive artifact management and failure recovery mechanisms to facilitate debugging and maintain development velocity.

### Test Failure Artifact Collection

When tests fail, the coverage workflow automatically collects diagnostic artifacts:

- **Test output files** - Complete testthat execution logs from `testthat.Rout*` files
- **Package installation artifacts** - Full package installation directory for post-mortem analysis
- **Coverage data** - Detailed coverage reports even for failed runs

### Continuous Integration Permissions and Security

The workflows operate with `read-all` permissions and use GitHub Personal Access Tokens (`GITHUB_PAT`) and Codecov tokens (`CODECOV_TOKEN`) for secure access to external services while maintaining minimal privilege requirements.

Sources: [.github/workflows/test-coverage.yaml:49-62](), [.github/workflows/R-CMD-check.yaml:11-28]()