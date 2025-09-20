# Page: Quality Assurance and CI/CD

# Quality Assurance and CI/CD

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.github/.gitignore](.github/.gitignore)
- [.github/workflows/R-CMD-check.yaml](.github/workflows/R-CMD-check.yaml)
- [.github/workflows/pkgdown.yaml](.github/workflows/pkgdown.yaml)
- [.github/workflows/test-coverage.yaml](.github/workflows/test-coverage.yaml)
- [codecov.yml](codecov.yml)
- [man/mockPatientProfiles.Rd](man/mockPatientProfiles.Rd)
- [tests/testthat.R](tests/testthat.R)

</details>



This document covers the automated quality assurance processes and continuous integration/continuous deployment (CI/CD) pipeline for the PatientProfiles package. This includes the GitHub Actions workflows for testing, code coverage analysis, and documentation deployment that ensure code quality and reliability.

For information about the testing mock data infrastructure, see [Mock Data and Testing](#2.2). For details about the variable type system and statistical validation, see [Variable Types and Statistical Estimates](#5.1).

## CI/CD Pipeline Architecture

The PatientProfiles package employs a comprehensive CI/CD pipeline built on GitHub Actions that automatically validates code quality, runs tests, measures coverage, and deploys documentation.

### Workflow Overview

```mermaid
graph TB
    subgraph "GitHub Events"
        PUSH["Push to main/master"]
        PR["Pull Request"]
        RELEASE["Release Published"]
        MANUAL["Manual Dispatch"]
    end
    
    subgraph "CI/CD Pipeline"
        subgraph "Quality Gates"
            RCMD["R-CMD-check"]
            COVERAGE["test-coverage"]
            DOCS["pkgdown"]
        end
        
        subgraph "Validation Steps"
            SETUP["Environment Setup"]
            DEPS["Dependency Installation"]
            CHECK["Package Check"]
            TEST["Test Execution"]
            COV_GEN["Coverage Generation"]
            SITE_BUILD["Site Building"]
        end
        
        subgraph "Deployment Targets"
            CODECOV["Codecov Dashboard"]
            GHPAGES["GitHub Pages"]
            ARTIFACTS["Test Artifacts"]
        end
    end
    
    PUSH --> RCMD
    PUSH --> COVERAGE  
    PUSH --> DOCS
    PR --> RCMD
    PR --> COVERAGE
    PR --> DOCS
    RELEASE --> DOCS
    MANUAL --> DOCS
    
    RCMD --> SETUP
    COVERAGE --> SETUP
    DOCS --> SETUP
    
    SETUP --> DEPS
    DEPS --> CHECK
    DEPS --> TEST
    DEPS --> SITE_BUILD
    
    CHECK --> RCMD
    TEST --> COV_GEN
    COV_GEN --> CODECOV
    COV_GEN --> ARTIFACTS
    SITE_BUILD --> GHPAGES
```

Sources: [.github/workflows/R-CMD-check.yaml:1-47](), [.github/workflows/test-coverage.yaml:1-64](), [.github/workflows/pkgdown.yaml:1-50]()

### Workflow Trigger Configuration

The CI/CD system responds to multiple trigger events with different workflow combinations:

| Trigger Event | R-CMD-check | test-coverage | pkgdown |
|---------------|-------------|---------------|---------|
| Push to main/master | ✓ | ✓ | ✓ |
| Pull Request | ✓ | ✓ | ✓ (preview only) |
| Release Published | - | - | ✓ |
| Manual Dispatch | - | - | ✓ |

Sources: [.github/workflows/R-CMD-check.yaml:3-7](), [.github/workflows/test-coverage.yaml:3-7](), [.github/workflows/pkgdown.yaml:3-9]()

## Automated Testing Framework

The package uses the `testthat` framework for comprehensive automated testing, integrated into the CI/CD pipeline for continuous validation.

### Test Infrastructure

```mermaid
graph LR
    subgraph "Test Configuration"
        TESTTHAT_R["testthat.R"]
        TESTTHAT_LIB["testthat library"]
        PP_LIB["PatientProfiles library"]
    end
    
    subgraph "Test Execution"
        TEST_CHECK["test_check()"]
        R_CMD["R CMD check"]
        MOCK_ENV["mockPatientProfiles environment"]
    end
    
    subgraph "Test Validation"
        UNIT_TESTS["Unit Tests"]
        INTEGRATION["Integration Tests"]
        MOCK_DATA["Mock Data Tests"]
    end
    
    TESTTHAT_R --> TESTTHAT_LIB
    TESTTHAT_R --> PP_LIB
    TESTTHAT_LIB --> TEST_CHECK
    PP_LIB --> MOCK_ENV
    
    TEST_CHECK --> R_CMD
    R_CMD --> UNIT_TESTS
    R_CMD --> INTEGRATION
    MOCK_ENV --> MOCK_DATA
```

Sources: [tests/testthat.R:1-13]()

### R CMD Check Configuration

The primary quality gate uses `R-CMD-check` with specific build arguments optimized for the package:

- **Platform Matrix**: Ubuntu Latest with R release version
- **Build Arguments**: `--no-manual`, `--compact-vignettes=gs+qpdf`
- **Environment**: `R_KEEP_PKG_SOURCE=yes` for source preservation
- **Dependencies**: Automatic resolution with `rcmdcheck` package

Sources: [.github/workflows/R-CMD-check.yaml:20-46]()

## Code Coverage and Quality Metrics

The package maintains code quality through automated coverage analysis and reporting integrated with external quality monitoring services.

### Coverage Analysis Pipeline

```mermaid
graph TB
    subgraph "Coverage Generation"
        COVR["covr::package_coverage()"]
        COBERTURA["covr::to_cobertura()"]
        XML_OUT["cobertura.xml"]
    end
    
    subgraph "Coverage Configuration"
        QUIET["quiet = FALSE"]
        CLEAN["clean = FALSE"]
        INSTALL_PATH["install_path configuration"]
    end
    
    subgraph "Reporting and Upload"
        CODECOV_ACTION["codecov/codecov-action@v4"]
        CODECOV_TOKEN["token: d39775b8-5aec-4f5e-899a-fb7bee735f07"]
        FAIL_CI["fail_ci_if_error conditional"]
    end
    
    subgraph "Failure Handling"
        TESTTHAT_OUT["testthat.Rout* files"]
        ARTIFACT_UPLOAD["coverage-test-failures artifact"]
        TEMP_PACKAGE["${{ runner.temp }}/package"]
    end
    
    COVR --> COBERTURA
    COBERTURA --> XML_OUT
    QUIET --> COVR
    CLEAN --> COVR
    INSTALL_PATH --> COVR
    
    XML_OUT --> CODECOV_ACTION
    CODECOV_TOKEN --> CODECOV_ACTION
    FAIL_CI --> CODECOV_ACTION
    
    TESTTHAT_OUT --> ARTIFACT_UPLOAD
    TEMP_PACKAGE --> ARTIFACT_UPLOAD
```

Sources: [.github/workflows/test-coverage.yaml:33-63]()

### Coverage Quality Standards

The coverage system implements flexible quality thresholds:

| Metric | Target | Threshold | Mode |
|--------|--------|-----------|------|
| Project Coverage | Auto | 1% | Informational |
| Patch Coverage | Auto | 1% | Informational |

Sources: [codecov.yml:3-14]()

## Documentation Deployment

The package automatically builds and deploys documentation using `pkgdown` with GitHub Pages integration.

### Documentation Build Process

```mermaid
graph LR
    subgraph "Build Environment"
        PANDOC["setup-pandoc@v2"]
        R_SETUP["setup-r@v2"]
        R_DEPS["setup-r-dependencies@v2"]
    end
    
    subgraph "Dependencies"
        PKGDOWN["any::pkgdown"]
        LOCAL["local::."]
        NEEDS["needs: website"]
    end
    
    subgraph "Build Process"
        BUILD_SITE["pkgdown::build_site_github_pages()"]
        NEW_PROCESS["new_process = FALSE"]
        NO_INSTALL["install = FALSE"]
    end
    
    subgraph "Deployment"
        GHPAGES_ACTION["JamesIves/github-pages-deploy-action@v4.5.0"]
        BRANCH["branch: gh-pages"]
        FOLDER["folder: docs"]
        CLEAN["clean: false"]
    end
    
    PANDOC --> BUILD_SITE
    R_SETUP --> R_DEPS
    PKGDOWN --> R_DEPS
    LOCAL --> R_DEPS
    NEEDS --> R_DEPS
    
    R_DEPS --> BUILD_SITE
    NEW_PROCESS --> BUILD_SITE
    NO_INSTALL --> BUILD_SITE
    
    BUILD_SITE --> GHPAGES_ACTION
    BRANCH --> GHPAGES_ACTION
    FOLDER --> GHPAGES_ACTION
    CLEAN --> GHPAGES_ACTION
```

Sources: [.github/workflows/pkgdown.yaml:28-49]()

### Deployment Conditions

Documentation deployment follows conditional logic based on event type:

- **Pull Requests**: Build only (no deployment)
- **Push to main/master**: Build and deploy
- **Releases**: Build and deploy
- **Manual Dispatch**: Build and deploy

The concurrency control ensures only one deployment runs at a time: `pkgdown-${{ github.event_name != 'pull_request' || github.run_id }}`.

Sources: [.github/workflows/pkgdown.yaml:18-20](), [.github/workflows/pkgdown.yaml:44]()

## Quality Gates and Workflow Dependencies

The CI/CD system implements multiple quality gates that must pass before code integration and deployment.

### Workflow Job Matrix

```mermaid
graph TB
    subgraph "Parallel Quality Gates"
        RCMD_JOB["R-CMD-check Job"]
        COV_JOB["test-coverage Job"]
        PKG_JOB["pkgdown Job"]
    end
    
    subgraph "Common Setup Steps"
        CHECKOUT["actions/checkout@v4"]
        R_SETUP["r-lib/actions/setup-r@v2"]
        PANDOC["r-lib/actions/setup-pandoc@v2"]
        DEPS["r-lib/actions/setup-r-dependencies@v2"]
    end
    
    subgraph "Specialized Actions"
        CHECK_PKG["r-lib/actions/check-r-package@v2"]
        COVR_RUN["covr::package_coverage()"]
        PKGDOWN_BUILD["pkgdown::build_site_github_pages()"]
    end
    
    subgraph "Output Artifacts"
        SNAPSHOTS["upload-snapshots: true"]
        COVERAGE_XML["cobertura.xml"]
        DOCS_SITE["GitHub Pages Site"]
    end
    
    RCMD_JOB --> CHECKOUT
    COV_JOB --> CHECKOUT
    PKG_JOB --> CHECKOUT
    
    CHECKOUT --> R_SETUP
    R_SETUP --> DEPS
    DEPS --> CHECK_PKG
    DEPS --> COVR_RUN
    DEPS --> PKGDOWN_BUILD
    
    CHECK_PKG --> SNAPSHOTS
    COVR_RUN --> COVERAGE_XML
    PKGDOWN_BUILD --> DOCS_SITE
```

Sources: [.github/workflows/R-CMD-check.yaml:26-46](), [.github/workflows/test-coverage.yaml:19-49](), [.github/workflows/pkgdown.yaml:25-49]()

### Error Handling and Artifact Collection

Each workflow includes sophisticated error handling and artifact collection:

- **R-CMD-check**: Uploads test snapshots on failure
- **test-coverage**: Collects `testthat.Rout` files and package artifacts
- **pkgdown**: Continues with clean=false to preserve existing documentation

The system uses conditional execution (`if: always()`, `if: failure()`) to ensure diagnostic information is always collected even when tests fail.

Sources: [.github/workflows/R-CMD-check.yaml:45](), [.github/workflows/test-coverage.yaml:51-63](), [.github/workflows/pkgdown.yaml:47]()