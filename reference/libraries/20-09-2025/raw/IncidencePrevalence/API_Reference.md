# Page: API Reference

# API Reference

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.gitignore](.gitignore)
- [R/dateUtilities.R](R/dateUtilities.R)
- [_pkgdown.yml](_pkgdown.yml)
- [man/estimatePeriodPrevalence.Rd](man/estimatePeriodPrevalence.Rd)
- [man/estimatePointPrevalence.Rd](man/estimatePointPrevalence.Rd)

</details>



This page provides comprehensive documentation of all public functions, data structures, and interfaces provided by the IncidencePrevalence package. The API is organized into three main categories: core analysis functions for estimating incidence and prevalence, visualization and reporting functions, and utility functions for data management and validation.

For detailed implementation guides and usage examples, see [Getting Started](#2), [Incidence Analysis](#5), and [Prevalence Analysis](#6). For information about the underlying concepts and data structures, see [Core Concepts](#3).

## Function Categories Overview

The IncidencePrevalence package API is structured around epidemiological analysis workflows, with functions grouped by their role in the analysis pipeline:

```mermaid
graph TB
    subgraph "Input Data"
        CDM["cdm (CDM Reference)"]
        OUTCOME["outcomeTable (Cohort Table)"]
    end
    
    subgraph "Cohort Generation"
        DENOM_GEN["generateDenominatorCohortSet()"]
        TARGET_GEN["generateTargetDenominatorCohortSet()"]
    end
    
    subgraph "Core Analysis"
        EST_INC["estimateIncidence()"]
        EST_POINT["estimatePointPrevalence()"]
        EST_PERIOD["estimatePeriodPrevalence()"]
    end
    
    subgraph "Result Processing"
        AS_INC["asIncidenceResult()"]
        AS_PREV["asPrevalenceResult()"]
    end
    
    subgraph "Visualization"
        PLOT_INC["plotIncidence()"]
        PLOT_PREV["plotPrevalence()"]
        PLOT_POP_INC["plotIncidencePopulation()"]
        PLOT_POP_PREV["plotPrevalencePopulation()"]
    end
    
    subgraph "Reporting"
        TABLE_INC["tableIncidence()"]
        TABLE_PREV["tablePrevalence()"]
        OPT_INC["optionsTableIncidence()"]
        OPT_PREV["optionsTablePrevalence()"]
    end
    
    subgraph "Utilities"
        MOCK["mockIncidencePrevalence()"]
        BENCH["benchmarkIncidencePrevalence()"]
        AVAIL_INC["availableIncidenceGrouping()"]
        AVAIL_PREV["availablePrevalenceGrouping()"]
    end
    
    CDM --> DENOM_GEN
    CDM --> TARGET_GEN
    CDM --> EST_INC
    CDM --> EST_POINT
    CDM --> EST_PERIOD
    
    DENOM_GEN --> EST_INC
    DENOM_GEN --> EST_POINT
    DENOM_GEN --> EST_PERIOD
    
    TARGET_GEN --> EST_INC
    
    OUTCOME --> EST_INC
    OUTCOME --> EST_POINT
    OUTCOME --> EST_PERIOD
    
    EST_INC --> AS_INC
    EST_POINT --> AS_PREV
    EST_PERIOD --> AS_PREV
    
    AS_INC --> PLOT_INC
    AS_INC --> TABLE_INC
    AS_PREV --> PLOT_PREV
    AS_PREV --> TABLE_PREV
```

*Sources: [_pkgdown.yml:6-30]()*

## Function Signature Patterns

IncidencePrevalence functions follow consistent parameter patterns based on OMOP CDM conventions:

```mermaid
graph LR
    subgraph "Common Parameters"
        CDM_PARAM["cdm: CDM Reference Object"]
        DENOM_TABLE["denominatorTable: Cohort Table Name"]
        OUTCOME_TABLE["outcomeTable: Cohort Table Name"]
        COHORT_IDS["cohortId: Numeric or Character Vector"]
        STRATA["strata: Named List"]
        INTERVAL["interval: Character Vector"]
    end
    
    subgraph "Analysis-Specific"
        WASHOUT["washoutPeriod: Numeric"]
        REPEAT_EVENTS["repeatEvents: Logical"]
        TIME_POINT["timePoint: Character"]
        FULL_CONTRIB["fullContribution: Logical"]
        COMPLETE_INT["completeDatabaseIntervals: Logical"]
    end
    
    subgraph "Return Types"
        SUMMARISED_RESULT["summarised_result Object"]
        INCIDENCE_RESULT["incidence_result Object"]
        PREVALENCE_RESULT["prevalence_result Object"]
    end
    
    CDM_PARAM --> SUMMARISED_RESULT
    DENOM_TABLE --> SUMMARISED_RESULT
    OUTCOME_TABLE --> SUMMARISED_RESULT
    COHORT_IDS --> SUMMARISED_RESULT
    STRATA --> SUMMARISED_RESULT
    INTERVAL --> SUMMARISED_RESULT
    
    WASHOUT --> INCIDENCE_RESULT
    REPEAT_EVENTS --> INCIDENCE_RESULT
    TIME_POINT --> PREVALENCE_RESULT
    FULL_CONTRIB --> PREVALENCE_RESULT
    COMPLETE_INT --> PREVALENCE_RESULT
```

*Sources: [man/estimatePointPrevalence.Rd:6-18](), [man/estimatePeriodPrevalence.Rd:6-19]()*

## Core Analysis Functions

### Cohort Generation Functions

| Function | Purpose | Key Parameters | Return Type |
|----------|---------|----------------|-------------|
| `generateDenominatorCohortSet()` | Create denominator population cohorts | `cdm`, `cohortDateRange`, `ageGroup`, `sex` | CDM with denominator table |
| `generateTargetDenominatorCohortSet()` | Create target-specific denominator cohorts | `cdm`, `targetCohortTable`, `targetCohortId` | CDM with target denominator table |

### Incidence Estimation Functions

| Function | Purpose | Key Parameters | Return Type |
|----------|---------|----------------|-------------|
| `estimateIncidence()` | Calculate incidence rates | `washoutPeriod`, `repeatEvents`, `censorOnOutcome` | `incidence_result` |

### Prevalence Estimation Functions

| Function | Purpose | Key Parameters | Return Type |
|----------|---------|----------------|-------------|
| `estimatePointPrevalence()` | Calculate point prevalence | `timePoint`, `interval` | `prevalence_result` |
| `estimatePeriodPrevalence()` | Calculate period prevalence | `fullContribution`, `completeDatabaseIntervals` | `prevalence_result` |

*Sources: [_pkgdown.yml:7-15]()*

## Visualization and Reporting Functions

### Plotting Functions

The plotting system provides consistent visualization across analysis types:

```mermaid
graph TB
    subgraph "Plot Data Flow"
        RESULT_OBJ["summarised_result Object"]
        PLOT_FUNC["Plot Functions"]
        GGPLOT_OBJ["ggplot2 Object"]
    end
    
    subgraph "Plot Function Types"
        PLOT_INC_FUNC["plotIncidence()"]
        PLOT_PREV_FUNC["plotPrevalence()"]
        PLOT_POP_INC_FUNC["plotIncidencePopulation()"]
        PLOT_POP_PREV_FUNC["plotPrevalencePopulation()"]
    end
    
    subgraph "Customization"
        RIBBON["ribbon: Logical"]
        FACET["facet: Character Vector"]
        COLOUR["colour: Character Vector"]
        SMOOTH["smooth: Logical"]
    end
    
    RESULT_OBJ --> PLOT_FUNC
    PLOT_FUNC --> GGPLOT_OBJ
    
    PLOT_INC_FUNC --> PLOT_FUNC
    PLOT_PREV_FUNC --> PLOT_FUNC
    PLOT_POP_INC_FUNC --> PLOT_FUNC
    PLOT_POP_PREV_FUNC --> PLOT_FUNC
    
    RIBBON --> PLOT_FUNC
    FACET --> PLOT_FUNC
    COLOUR --> PLOT_FUNC
    SMOOTH --> PLOT_FUNC
```

### Table Generation Functions

| Function | Purpose | Key Parameters | Return Type |
|----------|---------|----------------|-------------|
| `tableIncidence()` | Format incidence results as tables | `type`, `header`, `splitStrata` | Formatted table object |
| `tablePrevalence()` | Format prevalence results as tables | `type`, `header`, `splitStrata` | Formatted table object |
| `optionsTableIncidence()` | Get table formatting options for incidence | None | List of options |
| `optionsTablePrevalence()` | Get table formatting options for prevalence | None | List of options |

*Sources: [_pkgdown.yml:19-24]()*

## Utility Functions

### Data Management

| Function | Purpose | Parameters | Return Type |
|----------|---------|------------|-------------|
| `mockIncidencePrevalence()` | Generate mock OMOP CDM data | `sampleSize`, `seed`, `earliestObservationStartDate` | CDM reference object |
| `asIncidenceResult()` | Convert to incidence result format | `x` | `incidence_result` |
| `asPrevalenceResult()` | Convert to prevalence result format | `x` | `prevalence_result` |

### Analysis Support

| Function | Purpose | Parameters | Return Type |
|----------|---------|------------|-------------|
| `availableIncidenceGrouping()` | Get available grouping variables for incidence | `result` | Character vector |
| `availablePrevalenceGrouping()` | Get available grouping variables for prevalence | `result` | Character vector |
| `benchmarkIncidencePrevalence()` | Performance benchmarking | `cdm`, `config` | Benchmark results |

*Sources: [_pkgdown.yml:25-30]()*

## Internal Utility Functions

The package includes several internal utility functions for date manipulation and query generation:

### Date Utilities

```mermaid
graph LR
    subgraph "Date Manipulation Functions"
        ADD_DAYS["addDaysQuery()"]
        MINUS_DAYS["minusDaysQuery()"]
        REDUNDANT["redundant_fun()"]
    end
    
    subgraph "Parameters"
        CDM_REF["cdm: CDM Reference"]
        VARIABLE["variable: Character"]
        NUMBER["number: Integer"]
        TYPE["type: 'day' or 'year'"]
        NAME_STYLE["name_style: Character"]
    end
    
    subgraph "Query Generation"
        GLUE_EXPR["glue::glue() Expression"]
        PARSE_EXPR["rlang::parse_exprs()"]
        CLOCK_FUNC["clock::add_days() / clock::add_years()"]
    end
    
    CDM_REF --> ADD_DAYS
    VARIABLE --> ADD_DAYS
    NUMBER --> ADD_DAYS
    TYPE --> ADD_DAYS
    NAME_STYLE --> ADD_DAYS
    
    CDM_REF --> MINUS_DAYS
    VARIABLE --> MINUS_DAYS
    NUMBER --> MINUS_DAYS
    TYPE --> MINUS_DAYS
    
    ADD_DAYS --> GLUE_EXPR
    MINUS_DAYS --> GLUE_EXPR
    GLUE_EXPR --> PARSE_EXPR
    PARSE_EXPR --> CLOCK_FUNC
```

The `addDaysQuery()` and `minusDaysQuery()` functions generate database-specific SQL expressions for date arithmetic, handling differences between database backends like Spark which requires special handling for year arithmetic.

*Sources: [R/dateUtilities.R:16-95]()*

## Parameter Validation

All public functions include comprehensive parameter validation following omopgenerics standards. Common validation patterns include:

- CDM reference object validation
- Cohort table existence checks  
- Parameter type and range validation
- Database compatibility checks
- Strata variable validation

The validation system ensures early error detection and provides clear error messages to guide users toward correct parameter usage.

For detailed information about specific function parameters and validation rules, see [Input Validation System](#8.1). For implementation details of individual functions, see [Main Analysis Functions](#9.1), [Visualization and Table Functions](#9.2), and [Utility and Helper Functions](#9.3).

*Sources: [_pkgdown.yml:1-31](), [man/estimatePointPrevalence.Rd:1-72](), [man/estimatePeriodPrevalence.Rd:1-88]()*