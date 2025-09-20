# Page: Cohort Manipulation Operations

# Cohort Manipulation Operations

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/collapseCohorts.R](R/collapseCohorts.R)
- [R/exitAtDate.R](R/exitAtDate.R)
- [R/intersectCohorts.R](R/intersectCohorts.R)
- [R/stratifyCohorts.R](R/stratifyCohorts.R)
- [R/unionCohorts.R](R/unionCohorts.R)
- [R/yearCohorts.R](R/yearCohorts.R)
- [man/stratifyCohorts.Rd](man/stratifyCohorts.Rd)
- [man/yearCohorts.Rd](man/yearCohorts.Rd)
- [tests/testthat/test-collapseCohorts.R](tests/testthat/test-collapseCohorts.R)
- [tests/testthat/test-intersectCohorts.R](tests/testthat/test-intersectCohorts.R)
- [tests/testthat/test-measurementCohort.R](tests/testthat/test-measurementCohort.R)
- [tests/testthat/test-stratifyCohorts.R](tests/testthat/test-stratifyCohorts.R)
- [tests/testthat/test-unionCohorts.R](tests/testthat/test-unionCohorts.R)

</details>



This page covers the operations available for transforming and combining existing cohorts in CohortConstructor. These functions take one or more cohort tables as input and produce new cohort tables with modified structure, membership, or temporal boundaries.

Cohort manipulation operations are distinct from cohort building operations (see [Core Cohort Building](#3)) which create base cohorts from OMOP CDM data, and from requirement filters (see [Applying Requirements and Filters](#5)) which remove individuals based on specific criteria. For specialized date modification operations, see [Date and Time Operations](#6).

## Operation Categories

Cohort manipulation operations fall into four main categories:

### Combining Operations
- **Union**: Create cohorts where individuals are in *any* of the input cohorts
- **Intersection**: Create cohorts where individuals are in *all* of the input cohorts

### Temporal Operations  
- **Collapse**: Merge adjacent or nearby cohort entries for the same individual
- **Date Modification**: Adjust cohort start/end dates based on observation periods or death

### Splitting Operations
- **Stratification**: Split cohorts by demographic or clinical characteristics  
- **Temporal Splitting**: Split cohorts by time periods (e.g., by year)

### Sampling Operations
- **Random Sampling**: Select random subsets of cohort individuals
- **Matching**: Create matched control cohorts

## Core Function Overview

```mermaid
graph TB
    Input["Input Cohort(s)"] --> Combine["Combining Operations"]
    Input --> Temporal["Temporal Operations"] 
    Input --> Split["Splitting Operations"]
    Input --> Sample["Sampling Operations"]
    
    Combine --> unionCohorts["unionCohorts()"]
    Combine --> intersectCohorts["intersectCohorts()"]
    
    Temporal --> collapseCohorts["collapseCohorts()"]
    Temporal --> exitAtDeath["exitAtDeath()"]
    Temporal --> exitAtObservationEnd["exitAtObservationEnd()"]
    
    Split --> stratifyCohorts["stratifyCohorts()"]
    Split --> yearCohorts["yearCohorts()"]
    
    Sample --> sampleCohorts["sampleCohorts()"]
    Sample --> matchCohorts["matchCohorts()"]
    
    unionCohorts --> Output["Modified Cohort Table"]
    intersectCohorts --> Output
    collapseCohorts --> Output
    exitAtDeath --> Output
    exitAtObservationEnd --> Output
    stratifyCohorts --> Output
    yearCohorts --> Output
    sampleCohorts --> Output
    matchCohorts --> Output
```

Sources: [R/unionCohorts.R:31-124](), [R/intersectCohorts.R:36-234](), [R/collapseCohorts.R:17-95](), [R/stratifyCohorts.R:38-185](), [R/yearCohorts.R:25-206](), [R/exitAtDate.R:32-244]()

## Data Flow Architecture

### Cohort Combination Flow

```mermaid
graph LR
    CohortA["Cohort A<br/>cohort_definition_id: 1"] --> Intersect["intersectCohorts()"]
    CohortB["Cohort B<br/>cohort_definition_id: 2"] --> Intersect
    CohortA --> Union["unionCohorts()"]
    CohortB --> Union
    
    Intersect --> IntersectResult["Intersection Cohort<br/>Where A AND B overlap"]
    Union --> UnionResult["Union Cohort<br/>Where A OR B present"]
    
    subgraph "Gap Processing"
        GapParam["gap parameter"] --> splitOverlap["splitOverlap()"]
        splitOverlap --> joinOverlap["joinOverlap()"]
    end
    
    Intersect --> GapParam
    Union --> GapParam
```

Sources: [R/intersectCohorts.R:73-83](), [R/unionCohorts.R:75-87](), [R/intersectCohorts.R:249-325](), [R/intersectCohorts.R:341-410]()

### Temporal Manipulation Flow

```mermaid
graph TD
    InputCohort["Input Cohort<br/>Multiple entries per subject"] --> gapCheck{"Gap Parameter"}
    
    gapCheck -->|"gap = 0"| NoChange["No temporal merging"]
    gapCheck -->|"gap > 0"| JoinOverlap["joinOverlap()<br/>Merge entries within gap"]
    gapCheck -->|"gap = Inf"| JoinAll["joinAll()<br/>Merge all entries per subject"]
    
    JoinOverlap --> ObsPeriod["getObservationPeriodId()<br/>Respect observation boundaries"]
    JoinAll --> ObsPeriod
    
    ObsPeriod --> OutputCohort["Collapsed Cohort<br/>Fewer, longer entries"]
    NoChange --> OutputCohort
```

Sources: [R/collapseCohorts.R:46-68](), [R/intersectCohorts.R:341-410](), [R/intersectCohorts.R:424-443]()

## Common Parameters and Patterns

### Standard Parameters

| Parameter | Type | Purpose | Used In |
|-----------|------|---------|---------|
| `cohort` | cohort_table | Input cohort table | All functions |
| `cohortId` | vector | Which cohorts to operate on | All functions |
| `name` | character | Output table name | All functions |
| `gap` | numeric | Days between entries to consider connected | `unionCohorts`, `intersectCohorts`, `collapseCohorts` |
| `keepOriginalCohorts` | logical | Preserve input cohorts in output | `unionCohorts`, `intersectCohorts` |

### Gap Processing Logic

The `gap` parameter is central to temporal operations:

```mermaid
graph LR
    Entry1["Cohort Entry 1<br/>End: 2020-01-10"] --> GapCalc["Gap Calculation"]
    Entry2["Cohort Entry 2<br/>Start: 2020-01-15"] --> GapCalc
    
    GapCalc --> GapSize["Gap = 5 days"]
    
    GapSize --> Decision{"gap >= 5?"}
    Decision -->|Yes| Merge["Merge entries<br/>2020-01-01 to 2020-01-20"]
    Decision -->|No| Separate["Keep separate entries"]
```

Sources: [R/intersectCohorts.R:73-74](), [R/unionCohorts.R:80-82](), [R/collapseCohorts.R:46-68]()

## Operation Workflows

### Multi-Step Cohort Processing

```mermaid
graph TB
    BaseCohorts["Base Cohorts<br/>from conceptCohort()"] --> AddStrata["Add stratification variables<br/>via PatientProfiles"]
    
    AddStrata --> Stratify["stratifyCohorts()<br/>Split by demographics"]
    Stratify --> YearSplit["yearCohorts()<br/>Split by time periods"]
    
    YearSplit --> Combine["intersectCohorts()<br/>Find overlapping periods"]
    Combine --> Collapse["collapseCohorts()<br/>Merge adjacent entries"]
    
    Collapse --> FinalCohorts["Final Analysis Cohorts"]
    
    subgraph "Metadata Preservation"
        Settings["cohort_set"]
        Attrition["cohort_attrition"] 
        Codelist["cohort_codelist"]
    end
    
    BaseCohorts --> Settings
    Stratify --> Settings
    YearSplit --> Settings
    Combine --> Settings
    Collapse --> Settings
```

Sources: [R/stratifyCohorts.R:116-149](), [R/yearCohorts.R:84-122](), [R/intersectCohorts.R:148-223](), [R/collapseCohorts.R:76-82]()

### Internal Processing Pipeline

```mermaid
graph LR
    Input["Input Validation"] --> TempTables["Create Temporary Tables"]
    TempTables --> Filter["filterCohortInternal()"]
    
    Filter --> NewCohort["Process Modified Cohorts"]
    Filter --> Unchanged["Preserve Unchanged Cohorts"]
    
    NewCohort --> ObsPeriods["Add Observation Period IDs"]
    ObsPeriods --> JoinLogic["Apply Join Logic"]
    
    JoinLogic --> Union["Union with Unchanged"]
    Unchanged --> Union
    
    Union --> Metadata["Update Metadata"]
    Metadata --> Indexes["Add Database Indexes"]
    Indexes --> Cleanup["Drop Temporary Tables"]
```

Sources: [R/collapseCohorts.R:39-84](), [R/intersectCohorts.R:57-71](), [R/stratifyCohorts.R:118-174]()

## Advanced Features

### Non-Overlapping Cohorts

The `intersectCohorts()` function can create mutually exclusive cohorts using `returnNonOverlappingCohorts = TRUE`:

```mermaid
graph TD
    InputA["Cohort A"] --> Process["intersectCohorts()<br/>returnNonOverlappingCohorts = TRUE"]
    InputB["Cohort B"] --> Process
    
    Process --> OnlyA["only_in_cohort_1<br/>Periods only in A"]
    Process --> OnlyB["only_in_cohort_2<br/>Periods only in B"]  
    Process --> Both["cohort_1_cohort_2<br/>Periods in both A and B"]
```

Sources: [R/intersectCohorts.R:110-120](), [R/intersectCohorts.R:169-194](), [tests/testthat/test-intersectCohorts.R:289-395]()

### Stratification with Multiple Variables

The `stratifyCohorts()` function supports complex stratification patterns:

```mermaid
graph LR
    InputCohort["Base Cohort<br/>+ sex, age_group, blood_type"] --> StrataSpec["strata = list(<br/>  'sex',<br/>  c('age_group', 'blood_type')<br/>)"]
    
    StrataSpec --> SingleStrata["Sex-based cohorts:<br/>cohort_1_female<br/>cohort_1_male"]
    StrataSpec --> MultiStrata["Combined strata:<br/>cohort_1_adult_a<br/>cohort_1_adult_b<br/>cohort_1_child_a<br/>..."]
```

Sources: [R/stratifyCohorts.R:116-149](), [R/stratifyCohorts.R:187-211](), [tests/testthat/test-stratifyCohorts.R:51-70]()

## Integration Points

Cohort manipulation operations integrate with the broader CohortConstructor ecosystem:

- **Input**: Cohorts created by [Core Cohort Building](#3) operations
- **Preprocessing**: Often used with [Applying Requirements and Filters](#5) 
- **Date Operations**: Integrated with [Date and Time Operations](#6)
- **Output**: Analysis-ready cohorts with preserved metadata

For detailed information on specific operation types:
- Set operations: [Combining Cohorts](#4.1)
- Temporal merging: [Collapsing and Sampling](#4.2)  
- Demographic splitting: [Stratifying and Splitting Cohorts](#4.3)

Sources: [R/intersectCohorts.R:1-556](), [R/unionCohorts.R:1-125](), [R/collapseCohorts.R:1-96](), [R/stratifyCohorts.R:1-256](), [R/yearCohorts.R:1-207](), [R/exitAtDate.R:1-246]()