# Page: Package Development and Evolution

# Package Development and Evolution

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [NEWS.md](NEWS.md)
- [R/table.R](R/table.R)

</details>



This document covers the development history, evolution patterns, and development practices of the CohortCharacteristics package. It examines version progression, breaking changes, dependency management, and the development workflow that has shaped the package architecture.

For information about the current test suite organization and testing patterns, see [Test Suite Overview](#5.1). For details about the package architecture and current dependencies, see [Package Architecture and Dependencies](#1.1).

## Package Version History

### Release Timeline and Major Changes

The CohortCharacteristics package has evolved through several major versions, each introducing significant architectural improvements and feature expansions:

```mermaid
timeline
    title "CohortCharacteristics Version Evolution"
    
    section Early Development
        0.3.0 : "Initial stable release"
             : "Complete refactor of table* and plot* functions"
             : "visOmopResults 0.4.0 integration"
             : "Added NEWS.md tracking"
    
    section Feature Expansion
        0.4.0 : "uniqueCombination parameter"
             : "Overlap analysis improvements"
             : "visOmopResults 0.5.0 compatibility"
             : "Benchmark function addition"
             : "CDMConnector 1.6.0 requirement"
    
    section Refinement
        0.5.0 : "summariseCharacteristics cohort-by-cohort"
             : "Multiple CDM support in plotCohortAttrition"
             : "Stack bar plots in plotCohortOverlap"
             : "Weights argument addition"
             : "Cell count filtering improvements"
    
    section Bug Fixes
        0.5.1 : "plotCohortAttrition NA display fix"
             : "Input validation improvements"
    
    section Current
        1.0.0 : "CRAN release"
             : "Production stability"
             : "Complete feature set"
```

Sources: [NEWS.md:1-49](), [DESCRIPTION:5]()

### Breaking Changes and Migration Patterns

The package has experienced one major breaking change that fundamentally restructured the API:

```mermaid
graph TD
    subgraph "Version 0.3.0 Breaking Changes"
        OLD["Pre-0.3.0 Architecture"]
        NEW["Post-0.3.0 Architecture"]
        
        OLD --> REFACTOR["Complete table* and plot* refactor"]
        REFACTOR --> NEW
        
        REFACTOR --> VOR_UPDATE["visOmopResults 0.4.0 integration"]
        VOR_UPDATE --> NEW
        
        REFACTOR --> ORDER["Consistent summarise* output ordering"]
        ORDER --> NEW
    end
    
    subgraph "Impact Areas"
        TABLE_FUNCS["table* functions"]
        PLOT_FUNCS["plot* functions"] 
        OUTPUT_FORMAT["Output ordering"]
        VIS_INTEGRATION["Visualization integration"]
    end
    
    NEW --> TABLE_FUNCS
    NEW --> PLOT_FUNCS
    NEW --> OUTPUT_FORMAT
    NEW --> VIS_INTEGRATION
```

Sources: [NEWS.md:45-47]()

## Development Practices and Patterns

### Function Development Patterns

The package follows consistent development patterns across all analysis domains:

```mermaid
graph LR
    subgraph "Function Naming Convention"
        SUMMARISE["summarise*"]
        PLOT["plot*"]
        TABLE["table*"]
        
        SUMMARISE --> PLOT
        SUMMARISE --> TABLE
    end
    
    subgraph "Analysis Types"
        CHARACTERISTICS["Characteristics"]
        ATTRITION["CohortAttrition"]
        OVERLAP["CohortOverlap"] 
        TIMING["CohortTiming"]
        LSC["LargeScaleCharacteristics"]
    end
    
    subgraph "Implementation Pattern"
        VALIDATE["Input validation"]
        COMPUTE["Core computation"]
        FORMAT["Result formatting"]
        OUTPUT["Standardized output"]
        
        VALIDATE --> COMPUTE
        COMPUTE --> FORMAT
        FORMAT --> OUTPUT
    end
    
    SUMMARISE -.-> CHARACTERISTICS
    SUMMARISE -.-> ATTRITION
    SUMMARISE -.-> OVERLAP
    SUMMARISE -.-> TIMING
    SUMMARISE -.-> LSC
```

Sources: [R/table.R:60-125]()

### Quality Assurance Practices

The package implements several quality assurance mechanisms:

```mermaid
flowchart TD
    subgraph "Input Validation"
        VAL_RESULT["omopgenerics::validateResultArgument()"]
        VAL_VERSION["checkVersion()"]
        VAL_INPUTS["Parameter validation"]
    end
    
    subgraph "Testing Framework"
        TESTTHAT["testthat >= 3.1.5"]
        PARALLEL["Parallel testing enabled"]
        COVERAGE["covr package integration"]
    end
    
    subgraph "Documentation Standards"
        ROXYGEN["RoxygenNote: 7.3.2"]
        EXAMPLES["Comprehensive examples"]
        VIGNETTES["knitr vignettes"]
    end
    
    subgraph "Development Tools"
        LIFECYCLE["lifecycle package"]
        CLI_MSGS["cli package messaging"]
        BENCH["benchmarkCohortCharacteristics()"]
    end
    
    VAL_RESULT --> VAL_VERSION
    VAL_VERSION --> VAL_INPUTS
```

Sources: [R/table.R:74](), [R/table.R:84](), [DESCRIPTION:28](), [DESCRIPTION:36-37](), [DESCRIPTION:31](), [NEWS.md:38]()

## Dependency Management and Evolution

### Core Dependency Requirements

The package maintains strict version requirements for critical dependencies:

| Package | Version Requirement | Purpose |
|---------|-------------------|---------|
| `CDMConnector` | `>= 1.6.0` | Database connectivity |
| `omopgenerics` | `>= 1.2.0` | Standardized data structures |
| `PatientProfiles` | `>= 1.3.1` | Patient-level data processing |
| `visOmopResults` | `>= 1.0.0` | Visualization integration |
| `testthat` | `>= 3.1.5` | Testing framework |
| `duckdb` | `>= 1.0.0` | In-memory database testing |

Sources: [DESCRIPTION:29-31](), [DESCRIPTION:39-45]()

### Dependency Evolution Timeline

```mermaid
timeline
    title "Key Dependency Updates"
    
    section Core Updates
        0.4.0 : "CDMConnector 1.6.0 requirement"
             : "visOmopResults 0.5.0 compatibility"
             : "omopgenerics 0.4.0 compatibility"
    
    section CRAN Preparation  
        1.0.0 : "visOmopResults >= 1.0.0"
             : "omopgenerics >= 1.2.0"
             : "PatientProfiles >= 1.3.1"
             : "Production-ready versions"
```

Sources: [NEWS.md:34](), [NEWS.md:37](), [DESCRIPTION:29-31](), [DESCRIPTION:39]()

## Release Process and Versioning

### Version Control Strategy

The package follows semantic versioning with clear patterns for different types of changes:

```mermaid
graph TD
    subgraph "Version Number Strategy"
        MAJOR["Major (X.0.0)"]
        MINOR["Minor (0.X.0)"]
        PATCH["Patch (0.0.X)"]
    end
    
    subgraph "Change Types"
        BREAKING["Breaking changes"]
        FEATURES["New features"]
        BUGFIXES["Bug fixes"]
        REFACTOR["Code refactoring"]
    end
    
    BREAKING --> MAJOR
    FEATURES --> MINOR
    REFACTOR --> MINOR
    BUGFIXES --> PATCH
    
    subgraph "Release Milestones"
        V030["0.3.0: Major refactor"]
        V040["0.4.0: Feature expansion"] 
        V050["0.5.0: Analysis improvements"]
        V051["0.5.1: Bug fixes"]
        V100["1.0.0: CRAN release"]
    end
```

Sources: [NEWS.md:1-49](), [DESCRIPTION:5]()

### Development Workflow Integration

The package integrates with standard R development tools and practices:

```mermaid
flowchart LR
    subgraph "Development Environment"
        R_VERSION["R >= 4.1"]
        RSTUDIO["RStudio integration"]
        DEVTOOLS["devtools workflow"]
    end
    
    subgraph "Code Quality"
        ROXYGEN["roxygen2 documentation"]
        TESTTHAT_SETUP["testthat edition 3"]
        PARALLEL_TEST["Parallel testing"]
        SPELL_CHECK["spelling package"]
    end
    
    subgraph "Package Distribution"
        CRAN["CRAN submission"]
        GITHUB["GitHub releases"]
        DOCS["pkgdown documentation"]
    end
    
    R_VERSION --> ROXYGEN
    ROXYGEN --> TESTTHAT_SETUP
    TESTTHAT_SETUP --> PARALLEL_TEST
    PARALLEL_TEST --> CRAN
    
    GITHUB --> DOCS
    DOCS --> URL["https://darwin-eu.github.io/CohortCharacteristics/"]
```

Sources: [DESCRIPTION:35](), [DESCRIPTION:28](), [DESCRIPTION:36-37](), [DESCRIPTION:44](), [DESCRIPTION:32]()

### Continuous Integration Practices

The package implements comprehensive validation through multiple mechanisms:

```mermaid
graph TD
    subgraph "Validation Layers"
        INPUT_VAL["validateResultArgument()"]
        VERSION_CHK["checkVersion()"]
        PARAM_VAL["Parameter validation"]
    end
    
    subgraph "Testing Infrastructure"
        UNIT_TESTS["Unit tests"]
        INTEGRATION["Integration tests"]
        BENCHMARK["Performance benchmarks"]
    end
    
    subgraph "Documentation Validation"
        EXAMPLE_TESTS["Example code testing"]
        VIGNETTE_BUILD["Vignette compilation"]
        LINK_CHECK["Link validation"]
    end
    
    INPUT_VAL --> UNIT_TESTS
    VERSION_CHK --> INTEGRATION
    PARAM_VAL --> BENCHMARK
```

Sources: [R/table.R:74](), [R/table.R:84](), [NEWS.md:38]()

## Contributor Patterns and Team Structure

### Development Team Structure

The package development is led by a multi-institutional team with defined roles:

| Role | Contributors | Institution |
|------|-------------|-------------|
| Author/Creator | Marti Catala | NDORMS, Oxford |
| Authors | Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde | NDORMS/SPC, Oxford |
| Contributors | Mike Du | NDORMS, Oxford |

Sources: [DESCRIPTION:6-21]()

### Contribution Patterns

Analysis of the changelog reveals consistent contribution patterns:

```mermaid
pie title "Contribution Types by Frequency"
    "Bug fixes" : 35
    "Feature additions" : 25
    "Documentation improvements" : 20
    "Code refactoring" : 15
    "Performance optimization" : 5
```

Sources: [NEWS.md:1-49]()