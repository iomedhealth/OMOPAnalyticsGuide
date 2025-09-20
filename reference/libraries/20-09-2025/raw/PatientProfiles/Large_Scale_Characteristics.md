# Page: Large Scale Characteristics

# Large Scale Characteristics

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [extras/benchmark.R](extras/benchmark.R)

</details>



## Purpose and Scope

The Large Scale Characteristics system provides benchmarking and performance testing capabilities for patient characterization studies at scale within OMOP CDM databases. This module focuses on measuring execution performance and resource utilization when running characterization analyses across large patient cohorts with multiple temporal windows and stratification variables.

For basic patient characterization functions, see [Data Summarization](#3.2). For information about the underlying intersection system that powers these analyses, see [Data Intersection System](#3.1).

## Core Concepts

Large scale characteristics analysis involves systematically profiling patient cohorts across multiple clinical domains with temporal constraints. The system provides dedicated benchmarking infrastructure to measure performance characteristics of the `summariseLargeScaleCharacteristics` function under various computational loads.

### Temporal Window Analysis

The benchmarking framework tests performance across predefined temporal windows that represent clinically meaningful periods relative to an index event:

```mermaid
graph LR
    subgraph "Temporal Windows"
        A["c(-Inf, -366)"] --> B["c(-365, -31)"]
        B --> C["c(-30, -1)"] 
        C --> D["c(0, 0)"]
        D --> E["c(1, 30)"]
        E --> F["c(31, 365)"]
        F --> G["c(366, Inf)"]
    end
    
    subgraph "Clinical Interpretation"
        A2["Prior to 1 year before"]
        B2["1 year to 1 month before"]
        C2["30 days before"]
        D2["Index date"]
        E2["30 days after"]
        F2["1 month to 1 year after"]
        G2["Beyond 1 year after"]
    end
    
    A --> A2
    B --> B2
    C --> C2
    D --> D2
    E --> E2
    F --> F2
    G --> G2
```

Sources: [extras/benchmark.R:25-28]()

## Benchmarking Architecture

The benchmarking system is designed to measure performance across different analytical scenarios, from simple cohort characterization to complex stratified analyses.

### Database Connection Framework

```mermaid
graph TB
    subgraph "Database Infrastructure"
        ENV_VARS["Environment Variables<br/>DB_USER, DB_PASSWORD<br/>DB_PORT, DB_HOST"]
        POSTGRES["PostgreSQL Connection<br/>RPostgres::Postgres()"]
        CDM_CONN["CDM Connection<br/>cdmFromCon()"]
    end
    
    subgraph "Schema Configuration"
        CDM_SCHEMA["CDM Schema<br/>public_100k"]
        WRITE_SCHEMA["Write Schema<br/>results.lcwp1_"]
        COHORT_TABLES["Cohort Tables<br/>index"]
    end
    
    subgraph "Test Data Preparation"
        INDEX_COHORT["cdm$index<br/>Base Cohort"]
        INDEX_SEX["cdm$index_sex<br/>Cohort + Demographics"]
    end
    
    ENV_VARS --> POSTGRES
    POSTGRES --> CDM_CONN
    CDM_CONN --> CDM_SCHEMA
    CDM_CONN --> WRITE_SCHEMA
    CDM_CONN --> COHORT_TABLES
    
    CDM_SCHEMA --> INDEX_COHORT
    INDEX_COHORT --> INDEX_SEX
```

Sources: [extras/benchmark.R:5-23]()

### Performance Testing Scenarios

The benchmarking framework tests four distinct scenarios to measure computational complexity:

| Scenario | Cohort Type | Stratification | Tables | Purpose |
|----------|-------------|----------------|--------|---------|
| Basic | `cdm$index` | None | Default | Baseline performance |
| Stratified | `cdm$index_sex` | `list("sex")` | Default | Impact of stratification |
| Multi-table | `cdm$index` | None | `condition_occurrence`, `drug_exposure` | Table-specific analysis |
| Complex | `cdm$index_sex` | `list("sex")` | `condition_occurrence`, `drug_exposure` | Full complexity |

```mermaid
graph TD
    subgraph "Performance Test Matrix"
        BASIC["summariseLargeScaleCharacteristics<br/>cohort = cdm$index<br/>window = window"]
        STRATA["summariseLargeScaleCharacteristics<br/>cohort = cdm$index_sex<br/>strata = list('sex')<br/>window = window"]
        TABLES["DrugUtilisation::summariseLargeScaleCharacteristics<br/>cohort = cdm$index<br/>tablesToCharacterize = c('condition_occurrence', 'drug_exposure')"]
        COMPLEX["DrugUtilisation::summariseLargeScaleCharacteristics<br/>cohort = cdm$index_sex<br/>strata = list('sex')<br/>tablesToCharacterize = c('condition_occurrence', 'drug_exposure')"]
    end
    
    subgraph "Timing Framework"
        TIC_TOC["tictoc::tic()<br/>tictoc::toc()"]
    end
    
    BASIC --> TIC_TOC
    STRATA --> TIC_TOC
    TABLES --> TIC_TOC
    COMPLEX --> TIC_TOC
```

Sources: [extras/benchmark.R:34-48]()

## Performance Measurement Framework

The benchmarking implementation uses the `tictoc` package for precise execution timing across different analytical scenarios.

### Timing Implementation Pattern

Each performance test follows a consistent pattern:
1. Initialize timing with `tictoc::tic()`
2. Execute the `summariseLargeScaleCharacteristics` function
3. Capture execution time with `tictoc::toc()`

```mermaid
sequenceDiagram
    participant Benchmark as "Benchmark Script"
    participant TicToc as "tictoc Package"
    participant LSC as "summariseLargeScaleCharacteristics"
    participant CDM as "CDM Database"
    
    Benchmark->>TicToc: tic()
    Benchmark->>LSC: Execute function call
    LSC->>CDM: Query database tables
    CDM-->>LSC: Return results
    LSC-->>Benchmark: Complete analysis
    Benchmark->>TicToc: toc()
    TicToc-->>Benchmark: Return execution time
```

Sources: [extras/benchmark.R:34-48]()

## Data Preparation Workflow

### Demographics Enhancement

The benchmark script includes demographic enhancement as a preprocessing step:

```mermaid
graph LR
    subgraph "Data Preparation"
        BASE_COHORT["cdm$index<br/>Base Cohort"]
        ADD_SEX["addSex()"]
        ENHANCED_COHORT["cdm$index_sex<br/>Enhanced Cohort"]
    end
    
    subgraph "Benchmarking Scenarios"
        SCENARIO_1["Basic Analysis<br/>No Demographics"]
        SCENARIO_2["Stratified Analysis<br/>With Demographics"]
    end
    
    BASE_COHORT --> ADD_SEX
    ADD_SEX --> ENHANCED_COHORT
    
    BASE_COHORT --> SCENARIO_1
    ENHANCED_COHORT --> SCENARIO_2
```

Sources: [extras/benchmark.R:32]()

## Function Integration

The benchmarking framework integrates with two implementations of large scale characteristics:

### PatientProfiles Implementation
- Direct function call: `summariseLargeScaleCharacteristics()`
- Focuses on core functionality performance

### DrugUtilisation Package Implementation  
- Namespaced call: `DrugUtilisation::summariseLargeScaleCharacteristics()`
- Includes additional `tablesToCharacterize` parameter
- Tests performance with specific OMOP tables: `condition_occurrence`, `drug_exposure`

```mermaid
graph TB
    subgraph "Function Implementations"
        PP_FUNC["PatientProfiles::<br/>summariseLargeScaleCharacteristics"]
        DU_FUNC["DrugUtilisation::<br/>summariseLargeScaleCharacteristics"]
    end
    
    subgraph "Parameters"
        COHORT_PARAM["cohort"]
        STRATA_PARAM["strata"]
        WINDOW_PARAM["window"]
        TABLES_PARAM["tablesToCharacterize"]
    end
    
    subgraph "Test Scenarios"
        BASIC_TEST["Basic Performance"]
        STRATA_TEST["Stratified Performance"]
        TABLE_TEST["Multi-table Performance"]
        COMPLEX_TEST["Complex Performance"]
    end
    
    PP_FUNC --> BASIC_TEST
    PP_FUNC --> STRATA_TEST
    DU_FUNC --> TABLE_TEST
    DU_FUNC --> COMPLEX_TEST
    
    COHORT_PARAM --> PP_FUNC
    COHORT_PARAM --> DU_FUNC
    STRATA_PARAM --> DU_FUNC
    WINDOW_PARAM --> PP_FUNC
    WINDOW_PARAM --> DU_FUNC
    TABLES_PARAM --> DU_FUNC
```

Sources: [extras/benchmark.R:35-47]()

## Development Environment Integration

The benchmarking script integrates with the development environment through `devtools::load_all()`, enabling testing of the latest code changes without package reinstallation.

```mermaid
graph LR
    subgraph "Development Workflow"
        CODE_CHANGES["Code Changes"]
        LOAD_ALL["devtools::load_all()"]
        BENCHMARK["Benchmark Execution"]
        PERFORMANCE_DATA["Performance Results"]
    end
    
    CODE_CHANGES --> LOAD_ALL
    LOAD_ALL --> BENCHMARK
    BENCHMARK --> PERFORMANCE_DATA
```

Sources: [extras/benchmark.R:30]()