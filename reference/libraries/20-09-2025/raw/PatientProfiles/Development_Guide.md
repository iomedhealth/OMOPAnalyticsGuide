# Page: Development Guide

# Development Guide

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.github/.gitignore](.github/.gitignore)
- [.github/workflows/R-CMD-check.yaml](.github/workflows/R-CMD-check.yaml)
- [.github/workflows/pkgdown.yaml](.github/workflows/pkgdown.yaml)
- [.github/workflows/test-coverage.yaml](.github/workflows/test-coverage.yaml)
- [R/formats.R](R/formats.R)
- [R/sysdata.rda](R/sysdata.rda)
- [codecov.yml](codecov.yml)
- [extras/addData.R](extras/addData.R)
- [extras/formats.csv](extras/formats.csv)
- [extras/formats_old.csv](extras/formats_old.csv)
- [man/mockPatientProfiles.Rd](man/mockPatientProfiles.Rd)
- [tests/testthat.R](tests/testthat.R)
- [tests/testthat/test-format.R](tests/testthat/test-format.R)

</details>



This document provides essential resources for developers working on or extending the PatientProfiles package. It covers the internal architecture, development workflows, testing frameworks, and quality assurance processes that maintain the package's reliability and performance.

For information about variable type classification and statistical estimates, see [Variable Types and Statistical Estimates](#5.1). For CI/CD pipeline details, see [Quality Assurance and CI/CD](#5.2). For package build configuration, see [Package Configuration](#5.4).

## Development Architecture Overview

The PatientProfiles package follows a modular architecture designed for maintainability and extensibility. The core systems are organized into several key layers that developers need to understand.

### Core Development Systems

```mermaid
graph TB
    subgraph "Development Infrastructure"
        TESTING["Testing Framework<br/>testthat + mockPatientProfiles"]
        CI_CD["CI/CD Pipeline<br/>GitHub Actions"]
        DOCS["Documentation<br/>roxygen2 + pkgdown"]
    end
    
    subgraph "Internal Data Systems"
        SYSDATA["R/sysdata.rda<br/>formats, estimatesFunc<br/>namesTable, formatsOld"]
        FORMATS_CSV["extras/formats.csv<br/>Estimate Definitions"]
        ADD_DATA["extras/addData.R<br/>Data Generation Script"]
    end
    
    subgraph "Core Development APIs"
        VARIABLE_TYPES["variableTypes()<br/>Data Classification"]
        AVAILABLE_EST["availableEstimates()<br/>Estimate Registry"]
        ASSERT_CLASS["assertClassification()<br/>Type Validation"]
        BINARY_VAR["binaryVariable()<br/>Binary Detection"]
    end
    
    subgraph "Extension Points"
        FORMATS_R["R/formats.R<br/>Type System"]
        ESTIMATES_FUNC["estimatesFunc<br/>Function Registry"]
        WEIGHTS_FUNC["estimatesFuncWeights<br/>Weighted Functions"]
    end
    
    ADD_DATA --> SYSDATA
    FORMATS_CSV --> ADD_DATA
    SYSDATA --> VARIABLE_TYPES
    SYSDATA --> AVAILABLE_EST
    
    VARIABLE_TYPES --> ASSERT_CLASS
    VARIABLE_TYPES --> BINARY_VAR
    
    FORMATS_R --> EXTENSION_POINTS
    ESTIMATES_FUNC --> EXTENSION_POINTS
    WEIGHTS_FUNC --> EXTENSION_POINTS
    
    TESTING --> CI_CD
    CI_CD --> DOCS
```

Sources: [R/formats.R](), [R/sysdata.rda](), [extras/addData.R](), [extras/formats.csv](), [tests/testthat.R]()

### Development Data Flow

```mermaid
flowchart LR
    subgraph "Configuration Layer"
        CSV["extras/formats.csv<br/>Estimate Definitions"]
        NAMES_TABLE["extras/namesTable.csv<br/>OMOP Table Config"]
    end
    
    subgraph "Data Generation"
        ADD_DATA_SCRIPT["extras/addData.R<br/>usethis::use_data()"]
        VARIABLES_LIST["variables list<br/>Type->Estimates mapping"]
        ESTIMATES_FUNC["estimatesFunc vector<br/>Function definitions"]
        WEIGHTS_FUNC["estimatesFuncWeights<br/>Weighted equivalents"]
    end
    
    subgraph "Runtime Systems"
        SYSDATA["R/sysdata.rda<br/>Internal data objects"]
        FORMATS_R["R/formats.R<br/>Public API functions"]
        TYPE_SYSTEM["variableTypes()<br/>assertClassification()"]
        ESTIMATE_SYSTEM["availableEstimates()<br/>binaryVariable()"]
    end
    
    CSV --> ADD_DATA_SCRIPT
    NAMES_TABLE --> ADD_DATA_SCRIPT
    ADD_DATA_SCRIPT --> VARIABLES_LIST
    ADD_DATA_SCRIPT --> ESTIMATES_FUNC
    ADD_DATA_SCRIPT --> WEIGHTS_FUNC
    
    VARIABLES_LIST --> SYSDATA
    ESTIMATES_FUNC --> SYSDATA
    WEIGHTS_FUNC --> SYSDATA
    
    SYSDATA --> TYPE_SYSTEM
    SYSDATA --> ESTIMATE_SYSTEM
    TYPE_SYSTEM --> FORMATS_R
    ESTIMATE_SYSTEM --> FORMATS_R
```

Sources: [extras/addData.R:7-77](), [R/formats.R:37-75](), [R/sysdata.rda]()

## Variable Type Classification System

The package implements a sophisticated variable type classification system that automatically categorizes data columns into analysis-appropriate types. This system is central to the package's functionality and provides extension points for developers.

### Type Classification Architecture

| Variable Type | R Class Mapping | Estimate Support |
|---------------|-----------------|------------------|
| `categorical` | `chr`, `fct`, `ord` | `count`, `percentage` |
| `date` | `date`, `dttm` | `mean`, `sd`, `median`, `qXX`, `min`, `max` |
| `logical` | `lgl` | `count`, `percentage` |
| `numeric` | `drtn`, `dbl` | Full statistical suite |
| `integer` | `int`, `int64` | Full statistical suite |

The classification logic is implemented in `assertClassification()` function at [R/formats.R:61-75](), which uses a switch statement to map R's `type_sum()` output to PatientProfiles variable types.

### Estimate Function Registry

The package maintains two parallel function registries for statistical estimates:

```mermaid
graph TB
    subgraph "Unweighted Functions"
        EST_FUNC["estimatesFunc vector<br/>55 functions"]
        BASE_STATS["Base Statistics<br/>min, max, mean, median, sum, sd"]
        QUANTILES["Quantile Functions<br/>q01 through q99"]
    end
    
    subgraph "Weighted Functions"  
        EST_FUNC_W["estimatesFuncWeights vector<br/>55 functions"]
        HMISC_STATS["Hmisc Statistics<br/>wtd.mean, wtd.quantile, wtd.var"]
        WEIGHT_QUANTILES["Weighted Quantiles<br/>q01 through q99"]
    end
    
    BASE_STATS --> EST_FUNC
    QUANTILES --> EST_FUNC
    HMISC_STATS --> EST_FUNC_W
    WEIGHT_QUANTILES --> EST_FUNC_W
    
    EST_FUNC --> SYSDATA["R/sysdata.rda"]
    EST_FUNC_W --> SYSDATA
```

Sources: [extras/addData.R:55-76](), [tests/testthat/test-format.R:138-146]()

## Development Workflows

### Adding New Variable Types

To extend the package with new variable types, developers must modify several interconnected components:

1. **Update Type Classification**: Modify `assertClassification()` in [R/formats.R:61-75]() to handle the new R class
2. **Define Available Estimates**: Add entries to the `variables` list in [extras/addData.R:9-15]()
3. **Update Configuration**: Add estimate definitions to [extras/formats.csv]()
4. **Regenerate Internal Data**: Run [extras/addData.R:77]() to update `sysdata.rda`
5. **Add Tests**: Create test cases in [tests/testthat/test-format.R]()

### Adding Statistical Estimates

New statistical estimates require updates to multiple function registries:

```mermaid
flowchart TD
    NEW_EST["New Estimate Definition"]
    FORMAT_CSV["extras/formats.csv<br/>Add estimate metadata"]
    EST_FUNC["estimatesFunc vector<br/>Add function implementation"]
    EST_FUNC_W["estimatesFuncWeights vector<br/>Add weighted version"]
    VARIABLES["variables list<br/>Map to variable types"]
    
    NEW_EST --> FORMAT_CSV
    NEW_EST --> EST_FUNC
    NEW_EST --> EST_FUNC_W
    NEW_EST --> VARIABLES
    
    FORMAT_CSV --> REGEN["Run extras/addData.R"]
    EST_FUNC --> REGEN
    EST_FUNC_W --> REGEN
    VARIABLES --> REGEN
    
    REGEN --> SYSDATA["Updated R/sysdata.rda"]
```

Sources: [extras/addData.R:55-76](), [extras/formats.csv:1-13]()

## Testing Infrastructure

The package employs a comprehensive testing strategy built on the `testthat` framework with specialized mock data capabilities.

### Testing Architecture

```mermaid
graph TB
    subgraph "Test Framework"
        TESTTHAT_R["tests/testthat.R<br/>Main test runner"]
        TEST_FILES["tests/testthat/test-*.R<br/>Individual test suites"]
        MOCK_DATA["mockPatientProfiles()<br/>Test data generation"]
    end
    
    subgraph "Format System Tests"
        TEST_FORMAT["test-format.R<br/>Variable type tests"]
        VAR_TYPES_TEST["variableTypes() validation"]
        AVAIL_EST_TEST["availableEstimates() checks"]
        BINARY_VAR_TEST["binaryVariable() logic"]
        EST_FUNC_TEST["estimatesFunc registry"]
    end
    
    subgraph "Test Execution"
        SKIP_CRAN["skip_on_cran()<br/>Conditional execution"]
        EXPECT_FUNCS["expect_* assertions<br/>Result validation"]
    end
    
    TESTTHAT_R --> TEST_FILES
    TEST_FILES --> TEST_FORMAT
    MOCK_DATA --> TEST_FORMAT
    
    VAR_TYPES_TEST --> SKIP_CRAN
    AVAIL_EST_TEST --> SKIP_CRAN
    BINARY_VAR_TEST --> SKIP_CRAN
    EST_FUNC_TEST --> SKIP_CRAN
    
    SKIP_CRAN --> EXPECT_FUNCS
```

Sources: [tests/testthat.R:9-12](), [tests/testthat/test-format.R:1-146]()

### Mock Data System

The `mockPatientProfiles()` function provides a complete CDM environment for testing, documented in [man/mockPatientProfiles.Rd:6-13]().

## Quality Assurance Pipeline

The package implements automated quality assurance through GitHub Actions workflows that ensure code quality and reliability.

### CI/CD Workflow Architecture

```mermaid
graph TB
    subgraph "GitHub Actions Workflows"
        CMD_CHECK[".github/workflows/R-CMD-check.yaml<br/>Package validation"]
        COVERAGE[".github/workflows/test-coverage.yaml<br/>Code coverage analysis"]
        PKGDOWN[".github/workflows/pkgdown.yaml<br/>Documentation site"]
    end
    
    subgraph "Execution Matrix"
        UBUNTU["ubuntu-latest<br/>R release version"]
        R_VERSION["R version matrix<br/>Configurable versions"]
    end
    
    subgraph "Coverage Analysis"
        COVR["covr::package_coverage()<br/>Coverage calculation"]
        CODECOV["codecov/codecov-action@v4<br/>Upload to codecov.io"]
        COBERTURA["cobertura.xml<br/>Coverage report"]
    end
    
    subgraph "Documentation Build"
        PKGDOWN_BUILD["pkgdown::build_site_github_pages()<br/>Site generation"]
        GH_PAGES["GitHub Pages deployment<br/>docs/ folder"]
    end
    
    CMD_CHECK --> UBUNTU
    CMD_CHECK --> R_VERSION
    
    COVERAGE --> COVR
    COVR --> COBERTURA
    COBERTURA --> CODECOV
    
    PKGDOWN --> PKGDOWN_BUILD
    PKGDOWN_BUILD --> GH_PAGES
```

Sources: [.github/workflows/R-CMD-check.yaml:11-46](), [.github/workflows/test-coverage.yaml:14-63](), [.github/workflows/pkgdown.yaml:16-49]()

### Coverage Configuration

The package maintains strict code coverage standards through [codecov.yml:3-14](), with auto-targeting and 1% threshold tolerance for both project and patch coverage.

## Package Data Management

### Internal Data Objects

The package stores critical configuration data in `R/sysdata.rda`, which contains:

| Object | Type | Purpose |
|--------|------|---------|
| `formats` | `tibble` | Variable type to estimate mappings |
| `estimatesFunc` | `character vector` | Unweighted statistical functions |
| `estimatesFuncWeights` | `character vector` | Weighted statistical functions |
| `namesTable` | `tibble` | OMOP CDM table configurations |
| `formatsOld` | `tibble` | Legacy format definitions |

### Data Generation Process

The [extras/addData.R]() script orchestrates the creation of internal data objects:

1. **Configuration Loading**: Reads CSV files from `extras/` directory
2. **Data Transformation**: Processes raw configurations into runtime objects
3. **Function Registry Creation**: Builds statistical function mappings
4. **Internal Data Export**: Uses `usethis::use_data()` to create `sysdata.rda`

Sources: [extras/addData.R:1-78](), [R/sysdata.rda]()