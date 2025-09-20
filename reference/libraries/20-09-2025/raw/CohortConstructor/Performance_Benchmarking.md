# Page: Performance Benchmarking

# Performance Benchmarking

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.Rbuildignore](.Rbuildignore)
- [.gitignore](.gitignore)
- [R/data.R](R/data.R)
- [R/sysdata.rda](R/sysdata.rda)
- [cran-comments.md](cran-comments.md)
- [data-raw/getBenchmarkResults.R](data-raw/getBenchmarkResults.R)
- [data/benchmarkData.rda](data/benchmarkData.rda)
- [man/benchmarkData.Rd](man/benchmarkData.Rd)
- [vignettes/a11_benchmark.Rmd](vignettes/a11_benchmark.Rmd)

</details>



## Purpose and Scope

The Performance Benchmarking system provides tools and datasets for comparing CohortConstructor's performance against existing cohort generation tools, primarily CIRCE (used by ATLAS). This system enables systematic evaluation of computational efficiency, result accuracy, and scalability across different database platforms and cohort complexity levels.

For information about the core cohort building functions being benchmarked, see [Core Cohort Building](#3). For details about cohort manipulation operations, see [Cohort Manipulation Operations](#4).

## Benchmarking Overview

CohortConstructor's benchmarking system tests performance using real-world phenotypes from the OHDSI Phenotype Library, comparing three distinct approaches to cohort generation:

```mermaid
graph TB
    subgraph "Benchmark Approaches"
        CIRCE["CIRCE/ATLAS<br/>(Traditional)"]
        CCDef["CohortConstructor<br/>By Definition"]
        CCDom["CohortConstructor<br/>By Domain"]
    end
    
    subgraph "Test Scenarios"
        Pheno["9 OHDSI Phenotypes<br/>- COVID-19<br/>- Asthma without COPD<br/>- Beta blockers nested<br/>- And 6 others"]
        Strata["Cohort Stratifications<br/>- Age groups<br/>- Sex categories<br/>- Combined strata"]
    end
    
    subgraph "Measured Metrics"
        Time["Execution Time"]
        Overlap["Patient Overlap"]
        Counts["Cohort Counts"]
        Agreement["Result Agreement"]
    end
    
    CIRCE --> Time
    CCDef --> Time
    CCDom --> Time
    
    Pheno --> CIRCE
    Pheno --> CCDef
    Pheno --> CCDom
    
    Strata --> CIRCE
    Strata --> CCDom
    
    Time --> Agreement
    Overlap --> Agreement
    Counts --> Agreement
```

**Sources:** [vignettes/a11_benchmark.Rmd:80-86](), [vignettes/a11_benchmark.Rmd:143-146]()

## Benchmark Function and Execution

The `benchmarkCohortConstructor()` function provides the primary interface for running performance comparisons:

```mermaid
graph LR
    subgraph "Function Parameters"
        CDM["cdm<br/>(CDM Reference)"]
        RunC["runCIRCE<br/>(Boolean)"]
        RunDef["runCohortConstructorDefinition<br/>(Boolean)"]
        RunDom["runCohortConstructorDomain<br/>(Boolean)"]
    end
    
    subgraph "Execution Flow"
        Setup["Setup Test Environment"]
        CIRCE_Exec["Execute CIRCE Cohorts"]
        CC_Def_Exec["Execute CC by Definition"]
        CC_Dom_Exec["Execute CC by Domain"]
        Measure["Measure Performance"]
        Compare["Generate Comparisons"]
    end
    
    subgraph "Output Results"
        TimeData["Timing Data"]
        OverlapData["Overlap Analysis"]
        CountData["Cohort Counts"]
        MetricsData["Performance Metrics"]
    end
    
    CDM --> Setup
    RunC --> CIRCE_Exec
    RunDef --> CC_Def_Exec
    RunDom --> CC_Dom_Exec
    
    Setup --> CIRCE_Exec
    CIRCE_Exec --> CC_Def_Exec
    CC_Def_Exec --> CC_Dom_Exec
    CC_Dom_Exec --> Measure
    
    Measure --> Compare
    Compare --> TimeData
    Compare --> OverlapData
    Compare --> CountData
    Compare --> MetricsData
```

**Sources:** [vignettes/a11_benchmark.Rmd:104-112]()

## Benchmark Dataset Structure

The package includes pre-computed benchmark results in the `benchmarkData` object, which contains multiple result types:

```mermaid
graph TB
    subgraph "benchmarkData Components"
        OMOP["omop<br/>Table Record Counts"]
        Details["details<br/>Cohort Count Details"]
        TimeDef["time_definition<br/>Individual Cohort Times"]
        TimeDom["time_domain<br/>Bulk Processing Times"]
        TimeStrata["time_strata<br/>Stratification Times"]
        Comparison["comparison<br/>Patient Overlap Analysis"]
        SQLIdx["sql_indexes<br/>Database Index Info"]
    end
    
    subgraph "Database Coverage"
        CPRD_Gold["CPRD Gold<br/>(PostgreSQL)"]
        CPRD_Aurum["CPRD Aurum<br/>(SQL Server)"]
        Coriva["Coriva<br/>(PostgreSQL)"]
        OHDSI_SQL["OHDSI SQL Server<br/>(SQL Server)"]
    end
    
    subgraph "Processing Pipeline"
        Raw["Raw Benchmark Results<br/>(ZIP files)"]
        Process["Data Processing<br/>getBenchmarkResults.R"]
        Format["Formatted Results<br/>benchmarkData.rda"]
    end
    
    Raw --> Process
    Process --> Format
    Format --> OMOP
    Format --> Details
    Format --> TimeDef
    Format --> TimeDom
    Format --> TimeStrata
    Format --> Comparison
    Format --> SQLIdx
    
    CPRD_Gold --> Raw
    CPRD_Aurum --> Raw
    Coriva --> Raw
    OHDSI_SQL --> Raw
```

**Sources:** [data-raw/getBenchmarkResults.R:96-101](), [data-raw/getBenchmarkResults.R:104-231](), [R/data.R:1-4]()

## Performance Comparison Approaches

The benchmarking system evaluates three distinct methodologies for cohort generation:

### CIRCE Approach
- Traditional OHDSI method using JSON cohort definitions
- Each cohort built independently via separate SQL queries
- Typically generates complex, nested SQL statements
- Used as the baseline for comparison

### CohortConstructor By Definition
- Each phenotype built separately using CohortConstructor functions
- Mirrors CIRCE's independent cohort approach
- Tests direct functional equivalence

### CohortConstructor By Domain
- All phenotypes built together in a single pipeline
- Leverages shared base cohorts and efficient table access
- Represents CohortConstructor's optimized approach

```mermaid
graph TD
    subgraph "CIRCE Method"
        C1["COVID-19 JSON"] --> CS1["SQL Query 1"]
        C2["Asthma JSON"] --> CS2["SQL Query 2"]  
        C3["Beta Blockers JSON"] --> CS3["SQL Query 3"]
        CN["... N more JSONs"] --> CSN["SQL Query N"]
    end
    
    subgraph "CC By Definition"
        CC1["conceptCohort()"] --> CCS1["Cohort 1"]
        CC2["conceptCohort()"] --> CCS2["Cohort 2"]
        CC3["conceptCohort()"] --> CCS3["Cohort 3"]
        CCN["... N more calls"] --> CCSN["Cohort N"]
    end
    
    subgraph "CC By Domain"
        Base["Base Cohorts<br/>- Drug concepts<br/>- Condition concepts<br/>- Procedure concepts"]
        Filter["Apply Requirements<br/>- Demographics<br/>- Date ranges<br/>- Intersections"]
        Output["All Target Cohorts"]
        
        Base --> Filter
        Filter --> Output
    end
```

**Sources:** [vignettes/a11_benchmark.Rmd:207-214](), [vignettes/a11_benchmark.Rmd:216-218]()

## Database Test Coverage

The benchmark evaluates performance across multiple real-world database environments:

| Database | Platform | Size | Management System |
|----------|----------|------|------------------|
| CPRD Gold | UK Primary Care | 100,000 patients | PostgreSQL |
| CPRD Aurum | UK Primary Care | Full dataset | SQL Server |
| Coriva | Estonian National Health | 400,000 patients | PostgreSQL |
| OHDSI SQL Server | Mock OMOP Dataset | Test dataset | SQL Server |

```mermaid
graph TB
    subgraph "Database Environments"
        PG1["CPRD Gold<br/>PostgreSQL<br/>100K patients"]
        SS1["CPRD Aurum<br/>SQL Server<br/>Full dataset"] 
        PG2["Coriva<br/>PostgreSQL<br/>400K patients"]
        SS2["OHDSI SQL<br/>SQL Server<br/>Test dataset"]
    end
    
    subgraph "OMOP Tables Tested"
        Person["person"]
        ObsPeriod["observation_period"]
        DrugExp["drug_exposure"]
        CondOcc["condition_occurrence"]
        ProcOcc["procedure_occurrence"]
        Visit["visit_occurrence"]
        Measurement["measurement"]
        Observation["observation"]
    end
    
    subgraph "Benchmark Metrics"
        ExecTime["Execution Time<br/>(minutes)"]
        PatientOverlap["Patient Overlap<br/>(percentage)"]
        CohortCounts["Cohort Counts<br/>(records/subjects)"]
        IndexPerf["Index Performance<br/>(SQL optimization)"]
    end
    
    PG1 --> ExecTime
    SS1 --> ExecTime
    PG2 --> ExecTime
    SS2 --> ExecTime
    
    Person --> PatientOverlap
    ObsPeriod --> PatientOverlap
    DrugExp --> PatientOverlap
    
    ExecTime --> IndexPerf
    PatientOverlap --> IndexPerf
    CohortCounts --> IndexPerf
```

**Sources:** [vignettes/a11_benchmark.Rmd:118-128](), [data-raw/getBenchmarkResults.R:105-117]()

## Results Processing and Analysis

The benchmark data processing pipeline transforms raw timing and comparison results into structured analysis datasets:

```mermaid
graph LR
    subgraph "Raw Data Sources"
        ZIP1["time.zip"]
        ZIP2["comparison.zip"]
        ZIP3["details.zip"]
        ZIP4["omop.zip"]
        ZIP5["index_counts.zip"]
        ZIP6["sql_indexes.zip"]
    end
    
    subgraph "Processing Functions"
        ReadData["readData()"]
        ReadFiles["readFiles()"]
        MergeData["mergeData()"]
        UpdateCDM["updateCDMname()"]
        UpdateType["updateResultType()"]
    end
    
    subgraph "Formatted Outputs"
        TimeDefinition["time_definition<br/>Individual cohort times"]
        TimeDomain["time_domain<br/>Bulk processing times"]
        TimeStrata["time_strata<br/>Stratification times"]
        ComparisonData["comparison<br/>Patient overlap analysis"]
        DetailsData["details<br/>Cohort count details"]
        OMOPData["omop<br/>Table record counts"]
    end
    
    ZIP1 --> ReadData
    ZIP2 --> ReadData
    ZIP3 --> ReadData
    ZIP4 --> ReadData
    ZIP5 --> ReadData
    ZIP6 --> ReadData
    
    ReadData --> ReadFiles
    ReadFiles --> MergeData
    MergeData --> UpdateCDM
    UpdateCDM --> UpdateType
    
    UpdateType --> TimeDefinition
    UpdateType --> TimeDomain
    UpdateType --> TimeStrata
    UpdateType --> ComparisonData
    UpdateType --> DetailsData
    UpdateType --> OMOPData
```

**Sources:** [data-raw/getBenchmarkResults.R:9-89](), [data-raw/getBenchmarkResults.R:158-207]()

## Cohort Stratification Testing

The benchmark includes specialized testing for cohort stratification performance, where cohorts are subdivided by demographic characteristics:

```mermaid
graph TB
    subgraph "Stratification Test Setup"
        BaseCOVID["COVID-19 Base Cohort"]
        AgeStrata["Age Group Strata<br/>- 0-17 years<br/>- 18-64 years<br/>- 65+ years"]
        SexStrata["Sex Strata<br/>- Male<br/>- Female"]
        Combined["Combined Strata<br/>Age × Sex groups"]
    end
    
    subgraph "CIRCE Approach"
        JSON1["COVID-19 Male 0-17 JSON"]
        JSON2["COVID-19 Female 0-17 JSON"]
        JSON3["COVID-19 Male 18-64 JSON"]
        JSONN["... N more JSONs"]
        
        JSON1 --> SQLGen1["Generate SQL 1"]
        JSON2 --> SQLGen2["Generate SQL 2"] 
        JSON3 --> SQLGen3["Generate SQL 3"]
        JSONN --> SQLGenN["Generate SQL N"]
    end
    
    subgraph "CohortConstructor Approach"
        CreateBase["Create Base COVID-19"]
        ApplyStrata["stratifyCohorts()<br/>by age and sex"]
        
        CreateBase --> ApplyStrata
        ApplyStrata --> StratifiedOutput["All Strata Generated"]
    end
    
    BaseCOVID --> AgeStrata
    BaseCOVID --> SexStrata
    AgeStrata --> Combined
    SexStrata --> Combined
    
    Combined --> JSON1
    Combined --> JSON2
    Combined --> JSON3
    Combined --> JSONN
    
    Combined --> CreateBase
```

**Sources:** [vignettes/a11_benchmark.Rmd:290-300](), [data-raw/getBenchmarkResults.R:201-207]()