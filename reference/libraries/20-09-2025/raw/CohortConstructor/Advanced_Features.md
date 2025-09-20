# Page: Advanced Features

# Advanced Features

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/matchCohorts.R](R/matchCohorts.R)
- [R/sysdata.rda](R/sysdata.rda)
- [data-raw/getBenchmarkResults.R](data-raw/getBenchmarkResults.R)
- [data/benchmarkData.rda](data/benchmarkData.rda)
- [tests/testthat/test-matchCohorts.R](tests/testthat/test-matchCohorts.R)
- [vignettes/a11_benchmark.Rmd](vignettes/a11_benchmark.Rmd)

</details>



This document covers specialized functionality in CohortConstructor that goes beyond basic cohort building and manipulation. These advanced features enable sophisticated research designs and performance optimization for complex analytical workflows.

For basic cohort building operations, see [Core Cohort Building](#3). For standard cohort manipulation, see [Cohort Manipulation Operations](#4).

## Cohort Matching

The `matchCohorts` function provides a sophisticated system for generating matched control cohorts based on demographic characteristics. This functionality enables creation of balanced comparison groups for observational studies by matching individuals on sex, year of birth, and other criteria.

### Matching Architecture

```mermaid
flowchart TD
    subgraph "Input"
        TargetCohort["Target Cohort"]
        MatchCriteria["Matching Criteria<br/>matchSex, matchYearOfBirth, ratio"]
    end
    
    subgraph "Matching Process"
        ValidateInput["validateCohortArgument<br/>validateCdmArgument"]
        CreateTarget["subsetCohorts<br/>→ target cohort"]
        CreateControls["getNewCohort<br/>→ control pool"]
        ExcludeCases["excludeCases<br/>→ anti_join"]
        AddMatchCols["addMatchCols<br/>→ person demographics"]
        ExcludeNoMatch["excludeNoMatchedIndividuals<br/>→ inner_join groups"]
        InfiniteMatch["infiniteMatching<br/>→ addRandPairId"]
        ObservationFilter["observationControl<br/>observationTarget"]
        CheckRatio["checkRatio<br/>→ limit matches per target"]
    end
    
    subgraph "Output"
        SampledCohort["Target Cohort<br/>(cohort_name_sampled)"]
        MatchedCohort["Matched Controls<br/>(cohort_name_matched)"]
        CombinedResult["Combined Cohort Table"]
    end
    
    TargetCohort --> ValidateInput
    MatchCriteria --> ValidateInput
    ValidateInput --> CreateTarget
    CreateTarget --> CreateControls
    CreateControls --> ExcludeCases
    ExcludeCases --> AddMatchCols
    AddMatchCols --> ExcludeNoMatch
    ExcludeNoMatch --> InfiniteMatch
    InfiniteMatch --> ObservationFilter
    ObservationFilter --> CheckRatio
    CheckRatio --> SampledCohort
    CheckRatio --> MatchedCohort
    SampledCohort --> CombinedResult
    MatchedCohort --> CombinedResult
```

### Matching Implementation Details

The matching process creates two distinct cohort populations from the original target cohort:

| Cohort Type | Naming Convention | Description |
|-------------|------------------|-------------|
| Target (Sampled) | `{original_name}_sampled` | Subset of original cohort that could be matched |
| Control (Matched) | `{original_name}_matched` | Matched individuals from database population |

The `matchCohorts` function supports several key parameters:

- `matchSex`: Boolean flag to match on gender_concept_id from person table
- `matchYearOfBirth`: Boolean flag to match on year_of_birth from person table  
- `ratio`: Numeric value controlling number of controls per target (supports `Inf` for all available matches)
- `keepOriginalCohorts`: Boolean to retain original cohort definitions in output

**Sources:** [R/matchCohorts.R:1-442](), [tests/testthat/test-matchCohorts.R:1-355]()

### Matching Algorithm Flow

```mermaid
sequenceDiagram
    participant MC as matchCohorts
    participant GNC as getNewCohort
    participant EC as excludeCases
    participant GMC as getMatchCols
    participant ENMI as excludeNoMatchedIndividuals
    participant IM as infiniteMatching
    participant CR as checkRatio
    
    MC->>GNC: Create control pool from person + observation_period
    GNC-->>MC: All eligible individuals as potential controls
    
    MC->>EC: Remove target individuals from control pool
    EC-->>MC: Controls excluding cases (anti_join)
    
    MC->>GMC: Determine matching columns
    GMC-->>MC: Match columns array (gender_concept_id, year_of_birth)
    
    MC->>ENMI: Filter to matchable groups only
    ENMI-->>MC: Target and control cohorts with valid matches
    
    MC->>IM: Perform random matching with pair assignment
    IM-->>MC: Matched pairs with cluster_id assignments
    
    MC->>CR: Apply ratio constraints
    CR-->>MC: Final matched cohorts respecting ratio limits
```

The matching algorithm uses several sophisticated techniques:

1. **Random Pairing**: `addRandPairId` assigns random IDs for fair matching within demographic groups
2. **Cluster Assignment**: `clusterId` creates unique cluster identifiers for matched pairs
3. **Observation Period Filtering**: Ensures controls are in observation during target index dates
4. **Ratio Management**: Supports 1:N matching with configurable ratios including infinite matching

**Sources:** [R/matchCohorts.R:201-441](), [R/matchCohorts.R:354-392]()

## Performance Benchmarking

The `benchmarkCohortConstructor` function provides comprehensive performance testing capabilities, comparing CohortConstructor against the established CIRCE/ATLAS cohort generation system across multiple databases and cohort complexity levels.

### Benchmarking Architecture

```mermaid
graph TB
    subgraph "Benchmark Framework"
        BCF["benchmarkCohortConstructor<br/>function"]
        Config["Benchmark Configuration<br/>runCIRCE, runCohortConstructorDefinition<br/>runCohortConstructorDomain"]
    end
    
    subgraph "Test Cohorts"
        PhenoLib["OHDSI Phenotype Library<br/>9 cohort definitions"]
        COVID["COVID-19 stratifications<br/>age groups × sex"]
        AtlasJSON["ATLAS JSON definitions"]
        CCDefinitions["CohortConstructor equivalents"]
    end
    
    subgraph "Execution Strategies"
        ByDef["By Definition<br/>Individual cohort creation"]
        ByDomain["By Domain<br/>Batch processing approach"]
        CIRCE["CIRCE Execution<br/>via CodelistGenerator"]
    end
    
    subgraph "Performance Metrics"
        ExecTime["Execution Time<br/>tic/toc measurements"]
        CohortOverlap["Cohort Overlap Analysis<br/>agreement validation"]
        ResourceUsage["Database Query Patterns"]
    end
    
    subgraph "Database Targets"
        CPRD["CPRD Gold/Aurum<br/>PostgreSQL/SQL Server"]
        Coriva["Estonia National Health<br/>PostgreSQL"]
        OHDSIMock["OHDSI SQL Server<br/>Mock dataset"]
        Eunomia["DuckDB<br/>Test environment"]
    end
    
    BCF --> Config
    Config --> PhenoLib
    PhenoLib --> COVID
    COVID --> AtlasJSON
    COVID --> CCDefinitions
    
    BCF --> ByDef
    BCF --> ByDomain
    BCF --> CIRCE
    
    ByDef --> ExecTime
    ByDomain --> ExecTime
    CIRCE --> ExecTime
    
    ExecTime --> CohortOverlap
    CohortOverlap --> ResourceUsage
    
    BCF --> CPRD
    BCF --> Coriva
    BCF --> OHDSIMock
    BCF --> Eunomia
```

### Benchmark Test Suite

The benchmarking system evaluates CohortConstructor performance using nine cohorts from the OHDSI Phenotype Library:

| Cohort | OHDSI ID | Complexity Features |
|--------|----------|-------------------|
| COVID-19 | 56 | Multiple concept domains, stratifications |
| Inpatient hospitalisation | 23 | Visit-based criteria |
| Beta blockers in hypertension | 1049 | Nested cohort design |
| Transverse myelitis | 63 | Rare condition identification |
| Major non-cardiac surgery | 1289 | Procedure-based definition |
| Asthma without COPD | 27 | Exclusion criteria logic |
| Endometriosis procedure | 722 | Gender-specific procedures |
| Fluoroquinolone users | 1043 | Drug exposure patterns |
| Acquired neutropenia | 213 | Laboratory-based criteria |

**Sources:** [vignettes/a11_benchmark.Rmd:142-144](), [data-raw/getBenchmarkResults.R:96-101]()

### Comparison Methodology

```mermaid
flowchart LR
    subgraph "CIRCE Approach"
        AtlasGUI["ATLAS GUI<br/>Cohort Definition"]
        CIRCEJson["CIRCE JSON<br/>Specification"]
        SQLGen["SQL Generation<br/>Complex queries"]
        IndividualExec["Individual Execution<br/>Per cohort"]
    end
    
    subgraph "CohortConstructor Approaches"
        CCByDef["By Definition<br/>Equivalent to CIRCE"]
        CCByDomain["By Domain<br/>Batch processing"]
        SharedQueries["Shared Base Queries<br/>Minimized redundancy"]
    end
    
    subgraph "Performance Analysis"
        TimeComparison["Execution Time<br/>Minutes per cohort"]
        OverlapAnalysis["Patient Overlap<br/>Agreement validation"]
        ScalabilityTest["Database Scalability<br/>Multiple OMOP instances"]
    end
    
    AtlasGUI --> CIRCEJson
    CIRCEJson --> SQLGen
    SQLGen --> IndividualExec
    
    CCByDef --> SharedQueries
    CCByDomain --> SharedQueries
    
    IndividualExec --> TimeComparison
    CCByDef --> TimeComparison
    CCByDomain --> TimeComparison
    
    TimeComparison --> OverlapAnalysis
    OverlapAnalysis --> ScalabilityTest
```

The benchmarking framework tests three distinct approaches:

1. **CIRCE Baseline**: Traditional approach using ATLAS-generated JSON definitions executed via `CodelistGenerator`
2. **CohortConstructor by Definition**: Equivalent approach creating each cohort independently
3. **CohortConstructor by Domain**: Optimized approach creating all cohorts together, minimizing database queries

Key performance metrics include:
- Total execution time per approach
- Per-cohort timing breakdowns
- Patient overlap analysis for validation
- Database-specific scalability patterns

**Sources:** [vignettes/a11_benchmark.Rmd:208-214](), [vignettes/a11_benchmark.Rmd:276-278]()

### Benchmark Data Processing

The benchmark results undergo sophisticated processing for analysis:

```mermaid
graph TD
    subgraph "Data Collection"
        ZipFiles["Benchmark Result Zips<br/>Per database execution"]
        CSVExtract["CSV Extraction<br/>readData function"]
        ResultPatterns["Result Patterns<br/>time, comparison, details, omop"]
    end
    
    subgraph "Data Processing Pipeline"
        MergeData["mergeData<br/>Pattern-based aggregation"]
        UpdateCDM["updateCDMname<br/>Database name standardization"]
        UpdateResultType["updateResultType<br/>Result type harmonization"]
    end
    
    subgraph "Analysis Outputs"
        TimeDefinition["time_definition<br/>Per-cohort timing"]
        TimeDomain["time_domain<br/>Aggregate approach timing"]
        TimeStrata["time_strata<br/>Stratification timing"]
        Comparison["comparison<br/>Overlap analysis"]
        Details["details<br/>Cohort counts"]
        OMOP["omop<br/>Database characteristics"]
    end
    
    ZipFiles --> CSVExtract
    CSVExtract --> ResultPatterns
    ResultPatterns --> MergeData
    MergeData --> UpdateCDM
    UpdateCDM --> UpdateResultType
    
    UpdateResultType --> TimeDefinition
    UpdateResultType --> TimeDomain
    UpdateResultType --> TimeStrata
    UpdateResultType --> Comparison
    UpdateResultType --> Details
    UpdateResultType --> OMOP
```

The data processing pipeline handles multiple database results and standardizes naming conventions for cross-database comparison. Results are stored in the `benchmarkData` object with separate components for different analysis perspectives.

**Sources:** [data-raw/getBenchmarkResults.R:9-89](), [data-raw/getBenchmarkResults.R:102-230]()