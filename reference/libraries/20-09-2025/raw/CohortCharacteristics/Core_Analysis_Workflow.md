# Page: Core Analysis Workflow

# Core Analysis Workflow

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [MD5](MD5)
- [NAMESPACE](NAMESPACE)

</details>



This document explains the fundamental three-tier analysis pattern (`summarise` → `plot` → `table`) that forms the core workflow of the CohortCharacteristics package, along with the standardized result objects that enable consistent data processing and output generation.

For information about specific analysis types and their implementations, see [Analysis Domains](#3). For details about data input requirements and validation processes, see [Data Input and Validation](#2.1). For comprehensive coverage of result object structures and standards, see [Result Objects and Standards](#2.2).

## Three-Tier Analysis Architecture

The CohortCharacteristics package implements a consistent three-tier pattern across all analysis types. This architecture ensures standardized processing, flexible output generation, and seamless integration with the OMOP ecosystem.

### Architecture Overview

```mermaid
flowchart TD
    subgraph "Data Layer"
        CDM["OMOP CDM Database"]
        COHORT["Cohort Tables<br/>(cohort_table objects)"]
    end
    
    subgraph "Tier 1: Summarise Functions"
        SC["summariseCharacteristics()"]
        SCA["summariseCohortAttrition()"]
        SCO["summariseCohortOverlap()"]
        SCT["summariseCohortTiming()"]
        SLSC["summariseLargeScaleCharacteristics()"]
    end
    
    subgraph "Standardized Results"
        SR["summarised_result objects<br/>(omopgenerics standard)"]
        SETTINGS["Result settings & metadata"]
    end
    
    subgraph "Tier 2: Plot Functions"
        PC["plotCharacteristics()"]
        PCA["plotCohortAttrition()"]
        PCO["plotCohortOverlap()"]
        PCT["plotCohortTiming()"]
        PLSC["plotLargeScaleCharacteristics()"]
    end
    
    subgraph "Tier 3: Table Functions"
        TC["tableCharacteristics()"]
        TCA["tableCohortAttrition()"]
        TCO["tableCohortOverlap()"]
        TCT["tableCohortTiming()"]
        TLSC["tableLargeScaleCharacteristics()"]
    end
    
    subgraph "Output Formats"
        PLOTS["ggplot2, plotly<br/>DiagrammeR objects"]
        TABLES["gt, flextable<br/>reactable, DT objects"]
    end
    
    CDM --> SC
    CDM --> SCA
    CDM --> SCO
    CDM --> SCT
    CDM --> SLSC
    
    COHORT --> SC
    COHORT --> SCA
    COHORT --> SCO
    COHORT --> SCT
    COHORT --> SLSC
    
    SC --> SR
    SCA --> SR
    SCO --> SR
    SCT --> SR
    SLSC --> SR
    
    SR --> PC
    SR --> PCA
    SR --> PCO
    SR --> PCT
    SR --> PLSC
    
    SR --> TC
    SR --> TCA
    SR --> TCO
    SR --> TCT
    SR --> TLSC
    
    PC --> PLOTS
    PCA --> PLOTS
    PCO --> PLOTS
    PCT --> PLOTS
    PLSC --> PLOTS
    
    TC --> TABLES
    TCA --> TABLES
    TCO --> TABLES
    TCT --> TABLES
    TLSC --> TABLES
```

*Sources: [NAMESPACE:23-38](), [R/summariseCharacteristics.R](), [R/plotCharacteristics.R](), [R/tableCharacteristics.R]()*

## Function Naming Conventions and Pattern

The package follows a strict naming convention that makes the workflow predictable and discoverable:

| Pattern | Function Examples | Purpose |
|---------|------------------|---------|
| `summarise*()` | `summariseCharacteristics()`, `summariseCohortAttrition()` | Generate standardized statistical summaries |
| `plot*()` | `plotCharacteristics()`, `plotCohortAttrition()` | Create visualizations from summarised results |
| `table*()` | `tableCharacteristics()`, `tableCohortAttrition()` | Format results as interactive/static tables |

### Core Workflow Pattern

```mermaid
sequenceDiagram
    participant User
    participant Summarise as "summarise*() Functions"
    participant Results as "summarised_result Objects"
    participant Plot as "plot*() Functions"
    participant Table as "table*() Functions"
    participant Output as "Visualization/Table Output"
    
    User->>Summarise: "cohort_table + parameters"
    Summarise->>Results: "Generate standardized results"
    Note over Results: "omopgenerics::summarised_result<br/>with settings & metadata"
    
    alt Visualization Path
        User->>Plot: "summarised_result object"
        Plot->>Output: "ggplot2/plotly object"
    else Table Path
        User->>Table: "summarised_result object"
        Table->>Output: "formatted table object"
    end
    
    Note over User,Output: "Both paths use same standardized<br/>result objects for consistency"
```

*Sources: [NAMESPACE:3-38](), [R/checks.R](), [R/utilities.R]()*

## Standardized Result Objects

All `summarise*()` functions generate `summarised_result` objects that conform to the `omopgenerics` standard. This ensures consistent data structures across all analysis types and enables seamless interoperability.

### Result Object Structure

| Component | Description | Source |
|-----------|-------------|---------|
| `result_id` | Unique identifier for each analysis run | Generated automatically |
| `cdm_name` | Source database identifier | From CDM connection |
| `group_name` | Grouping variable name | User-specified or default |
| `group_level` | Specific group values | Derived from data |
| `strata_name` | Stratification variable name | User-specified |
| `strata_level` | Specific strata values | Derived from data |
| `variable_name` | Analysis variable name | Function-specific |
| `variable_level` | Variable category/value | Context-dependent |
| `estimate_name` | Type of estimate (count, percentage, etc.) | Analysis-specific |
| `estimate_type` | Data type of estimate | Standardized types |
| `estimate_value` | Computed result value | Numeric or character |
| `additional_name` | Extra classification dimension | Function-specific |
| `additional_level` | Values for additional dimension | Context-dependent |

### Settings and Metadata

Each result object includes comprehensive settings that enable reproducibility and proper interpretation:

```mermaid
graph LR
    subgraph "Result Settings"
        PACKAGE["package_name: 'CohortCharacteristics'"]
        VERSION["package_version: current version"]
        RESULT_TYPE["result_type: analysis-specific"]
    end
    
    subgraph "Analysis Settings"
        COHORT_ID["cohort_id: target cohorts"]
        STRATA["strata_list: stratification variables"]
        MIN_CELL["min_cell_count: suppression threshold"]
        ESTIMATES["estimates: requested statistics"]
    end
    
    subgraph "Technical Settings"
        TABLE_NAME["cohort_table_name: source table"]
        CDM_NAME["cdm_name: database identifier"]
        TIMING["analysis_timestamp: execution time"]
    end
    
    PACKAGE --> COHORT_ID
    VERSION --> STRATA
    RESULT_TYPE --> MIN_CELL
```

*Sources: [R/summariseCharacteristics.R](), [R/summariseCohortAttrition.R](), [R/documentationHelpers.R]()*

## Workflow Integration Points

The core workflow integrates with several external systems and standards:

### External Dependencies Integration

| Integration Point | Purpose | Implementation |
|------------------|---------|----------------|
| `omopgenerics` | Result standardization and validation | All `summarise*()` functions return `summarised_result` objects |
| `PatientProfiles` | Patient-level data enrichment | Used for demographic and intersection analysis |
| `visOmopResults` | Visualization standards | Provides base plotting and table formatting |
| `CDMConnector` | Database connectivity | Handles OMOP CDM database connections |

### Analysis Type Coverage

The three-tier pattern is implemented consistently across all analysis domains:

| Analysis Domain | Summarise Function | Plot Function | Table Function |
|----------------|-------------------|---------------|----------------|
| General Characteristics | `summariseCharacteristics()` | `plotCharacteristics()` | `tableCharacteristics()` |
| Cohort Attrition | `summariseCohortAttrition()` | `plotCohortAttrition()` | `tableCohortAttrition()` |
| Cohort Overlap | `summariseCohortOverlap()` | `plotCohortOverlap()` | `tableCohortOverlap()` |
| Cohort Timing | `summariseCohortTiming()` | `plotCohortTiming()` | `tableCohortTiming()` |
| Large Scale Characteristics | `summariseLargeScaleCharacteristics()` | `plotLargeScaleCharacteristics()` | `tableLargeScaleCharacteristics()` |

*Sources: [NAMESPACE:23-37](), [R/CohortCharacteristics-package.R](), [DESCRIPTION]()*

## Error Handling and Validation

The workflow includes comprehensive validation at each tier to ensure data integrity and meaningful error messages:

### Input Validation Points

```mermaid
flowchart TD
    INPUT["User Input"] --> CHECK1["Cohort Table Validation"]
    CHECK1 --> CHECK2["Parameter Validation"]
    CHECK2 --> CHECK3["CDM Connection Check"]
    CHECK3 --> PROCESS["Processing Pipeline"]
    
    CHECK1 -.- FAIL1["Invalid cohort_table structure"]
    CHECK2 -.- FAIL2["Invalid parameters or settings"]
    CHECK3 -.- FAIL3["Database connectivity issues"]
    
    PROCESS --> RESULT["summarised_result Generation"]
    RESULT --> CHECK4["Result Validation"]
    CHECK4 --> OUTPUT["Plot/Table Generation"]
    
    CHECK4 -.- FAIL4["Malformed result object"]
```

*Sources: [R/checks.R](), [R/utilities.R](), test files in [tests/testthat/]()*