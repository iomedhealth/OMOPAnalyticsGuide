# Page: Combining Cohorts

# Combining Cohorts

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/collapseCohorts.R](R/collapseCohorts.R)
- [R/exitAtDate.R](R/exitAtDate.R)
- [R/intersectCohorts.R](R/intersectCohorts.R)
- [R/unionCohorts.R](R/unionCohorts.R)
- [tests/testthat/test-collapseCohorts.R](tests/testthat/test-collapseCohorts.R)
- [tests/testthat/test-intersectCohorts.R](tests/testthat/test-intersectCohorts.R)
- [tests/testthat/test-measurementCohort.R](tests/testthat/test-measurementCohort.R)
- [tests/testthat/test-unionCohorts.R](tests/testthat/test-unionCohorts.R)
- [vignettes/a04_require_intersections.Rmd](vignettes/a04_require_intersections.Rmd)
- [vignettes/a06_concatanate_cohorts.Rmd](vignettes/a06_concatanate_cohorts.Rmd)
- [vignettes/a07_filter_cohorts.Rmd](vignettes/a07_filter_cohorts.Rmd)
- [vignettes/a08_split_cohorts.Rmd](vignettes/a08_split_cohorts.Rmd)

</details>



This section covers operations for combining multiple existing cohorts into new cohorts using union and intersection logic. These operations allow you to merge cohort entries based on whether individuals appear in either cohort (union) or both cohorts simultaneously (intersection).

For information about collapsing individual cohort entries within the same cohort, see [Collapsing and Sampling](#4.2). For stratifying cohorts into separate groups, see [Stratifying and Splitting Cohorts](#4.3).

## Overview

CohortConstructor provides two primary functions for combining cohorts:

- `unionCohorts()`: Creates cohorts containing individuals who appear in **any** of the specified cohorts
- `intersectCohorts()`: Creates cohorts containing individuals who appear in **all** of the specified cohorts simultaneously

Both functions handle overlapping time periods intelligently and can respect observation period boundaries to ensure data integrity.

## Union Operations

### Basic Union Logic

The `unionCohorts()` function combines cohort entries where individuals were in either of the specified cohorts. This creates a single cohort containing all unique time periods where an individual was in any of the source cohorts.

```mermaid
graph TD
    subgraph "Input Cohorts"
        C1[Cohort 1<br/>Subject A: 2020-01-01 to 2020-06-30<br/>Subject B: 2020-03-01 to 2020-05-31]
        C2[Cohort 2<br/>Subject A: 2020-04-01 to 2020-09-30<br/>Subject C: 2020-02-01 to 2020-04-30]
    end
    
    subgraph "Union Process"
        UP["unionCohorts()"]
        C1 --> UP
        C2 --> UP
    end
    
    subgraph "Output"
        UC[Union Cohort<br/>Subject A: 2020-01-01 to 2020-09-30<br/>Subject B: 2020-03-01 to 2020-05-31<br/>Subject C: 2020-02-01 to 2020-04-30]
    end
    
    UP --> UC
```

**Sources:** [R/unionCohorts.R:1-125](), [tests/testthat/test-unionCohorts.R:1-514]()

### Key Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `cohort` | Input cohort table | Required |
| `cohortId` | Specific cohort IDs to combine | `NULL` (all cohorts) |
| `gap` | Days between periods to consider as continuous | `0` |
| `cohortName` | Name for the resulting cohort | Auto-generated |
| `keepOriginalCohorts` | Whether to preserve original cohorts | `FALSE` |

**Sources:** [R/unionCohorts.R:31-37]()

### Gap Handling

The `gap` parameter controls how overlapping or nearby cohort entries are merged:

```mermaid
graph TD
    subgraph "Gap = 0 (No Gap)"
        G0A["Entry 1: 2020-01-01 to 2020-01-15"]
        G0B["Entry 2: 2020-01-20 to 2020-01-30"]
        G0C["Result: Two separate entries"]
        G0A --> G0C
        G0B --> G0C
    end
    
    subgraph "Gap = 5 (5-day Gap)"
        G5A["Entry 1: 2020-01-01 to 2020-01-15"]
        G5B["Entry 2: 2020-01-20 to 2020-01-30"]
        G5C["Result: 2020-01-01 to 2020-01-30"]
        G5A --> G5C
        G5B --> G5C
    end
```

**Sources:** [R/unionCohorts.R:80-82](), [R/intersectCohorts.R:341-410]()

## Intersection Operations

### Basic Intersection Logic

The `intersectCohorts()` function identifies time periods when individuals were simultaneously present in all specified cohorts. Only overlapping time periods are retained in the result.

```mermaid
graph TD
    subgraph "Input Cohorts"
        IC1[Cohort 1<br/>Subject A: 2020-01-01 to 2020-06-30]
        IC2[Cohort 2<br/>Subject A: 2020-04-01 to 2020-09-30]
    end
    
    subgraph "Intersection Process"
        IP["intersectCohorts()"]
        SO["splitOverlap()"]
        IC1 --> IP
        IC2 --> IP
        IP --> SO
    end
    
    subgraph "Output"
        IRC[Intersection Cohort<br/>Subject A: 2020-04-01 to 2020-06-30]
    end
    
    SO --> IRC
```

**Sources:** [R/intersectCohorts.R:1-234](), [tests/testthat/test-intersectCohorts.R:1-742]()

### Non-Overlapping Cohorts

The `returnNonOverlappingCohorts` parameter creates mutually exclusive cohorts showing periods when individuals were in only one of the source cohorts:

```mermaid
graph TD
    subgraph "Original Cohorts"
        OC1["Cohort A: 2020-01-01 to 2020-06-30"]
        OC2["Cohort B: 2020-04-01 to 2020-09-30"]
    end
    
    subgraph "Non-Overlapping Results"
        NOC1["only_in_cohort_a<br/>2020-01-01 to 2020-03-31<br/>2020-07-01 to 2020-06-30"]
        NOC2["only_in_cohort_b<br/>2020-07-01 to 2020-09-30"]
        NOC3["cohort_a_cohort_b<br/>2020-04-01 to 2020-06-30"]
    end
    
    OC1 --> NOC1
    OC1 --> NOC3
    OC2 --> NOC2
    OC2 --> NOC3
```

**Sources:** [R/intersectCohorts.R:110-121](), [tests/testthat/test-intersectCohorts.R:289-395]()

## Data Flow and Implementation

### Core Processing Pipeline

```mermaid
flowchart TD
    subgraph "Input Validation"
        IV1["validateCohortArgument()"]
        IV2["validateCohortIdArgument()"]
        IV3["Validate gap parameter"]
    end
    
    subgraph "Cohort Processing"
        CP1["copyCohorts()"]
        CP2["getObservationPeriodId()"]
        CP3["joinOverlap() / splitOverlap()"]
        CP4["Filter by observation periods"]
    end
    
    subgraph "Result Generation"
        RG1["Create new cohort settings"]
        RG2["Generate attrition records"]
        RG3["Preserve codelist attributes"]
        RG4["Add database indexes"]
    end
    
    IV1 --> CP1
    IV2 --> CP1
    IV3 --> CP1
    CP1 --> CP2
    CP2 --> CP3
    CP3 --> CP4
    CP4 --> RG1
    RG1 --> RG2
    RG2 --> RG3
    RG3 --> RG4
```

**Sources:** [R/unionCohorts.R:38-123](), [R/intersectCohorts.R:42-233]()

### Observation Period Handling

Both functions respect observation period boundaries to ensure cohort entries don't span periods when individuals weren't being observed:

```mermaid
graph TD
    subgraph "Subject with Multiple Observation Periods"
        OP1["Obs Period 1: 2020-01-01 to 2020-06-30"]
        OP2["Obs Period 2: 2021-01-01 to 2021-12-31"]
    end
    
    subgraph "Cohort Entries"
        CE1["Entry 1: 2020-05-01 to 2020-05-15"]
        CE2["Entry 2: 2021-03-01 to 2021-03-15"]
    end
    
    subgraph "Gap Processing"
        GP["Gap = 365 days"]
        NM["Entries NOT merged<br/>(different observation periods)"]
    end
    
    OP1 --> CE1
    OP2 --> CE2
    CE1 --> GP
    CE2 --> GP
    GP --> NM
```

**Sources:** [tests/testthat/test-intersectCohorts.R:606-661](), [tests/testthat/test-unionCohorts.R:463-514]()

## Helper Functions

### splitOverlap()

Used by `intersectCohorts()` to create non-overlapping time periods:

- Splits all cohort entries into distinct, non-overlapping segments
- Each segment is tagged with which original cohorts it belongs to
- Enables precise intersection calculations

**Sources:** [R/intersectCohorts.R:249-325]()

### joinOverlap()

Used by both functions to merge overlapping periods with gap consideration:

- Combines adjacent or overlapping periods within the specified gap
- Respects observation period boundaries
- Handles infinite gaps by merging all periods for each subject

**Sources:** [R/intersectCohorts.R:341-410]()

### getObservationPeriodId()

Adds observation period context to cohort entries to ensure proper boundary handling during combination operations.

**Sources:** [R/unionCohorts.R:79](), [R/intersectCohorts.R:140]()

## Attrition and Metadata

Both combination functions maintain comprehensive tracking:

- **Attrition records**: Track how many individuals and records are affected by the combination
- **Cohort settings**: Preserve or create new cohort definitions with appropriate names
- **Codelist attributes**: Maintain concept set information from source cohorts when applicable

The functions automatically generate meaningful cohort names (e.g., "cohort_1_cohort_2" for unions, "only_in_cohort_1" for non-overlapping intersections) and record the specific parameters used in the combination process.

**Sources:** [R/unionCohorts.R:61-65](), [R/intersectCohorts.R:158-194]()