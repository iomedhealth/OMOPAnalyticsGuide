# Page: Cohort Intersection

# Cohort Intersection

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/addCohortIntersect.R](R/addCohortIntersect.R)
- [man/addCohortIntersectCount.Rd](man/addCohortIntersectCount.Rd)
- [man/addCohortIntersectDate.Rd](man/addCohortIntersectDate.Rd)
- [man/addCohortIntersectDays.Rd](man/addCohortIntersectDays.Rd)
- [man/addCohortIntersectFlag.Rd](man/addCohortIntersectFlag.Rd)
- [tests/testthat/test-addCohortIntersect.R](tests/testthat/test-addCohortIntersect.R)

</details>



The Cohort Intersection system enables analysis of temporal relationships and overlaps between different patient cohorts in OMOP CDM data. This functionality allows researchers to identify when patients from one cohort appear in another cohort, count occurrences, and calculate temporal distances between cohort entries.

For concept-based intersections with OMOP vocabularies, see [Concept Intersection](#3.1.2). For intersections with standard OMOP tables like drug_exposure or condition_occurrence, see [Table Intersection](#3.1.3).

## Function Architecture

The cohort intersection system provides four primary functions that share a common underlying architecture through the core `.addIntersect` function.

```mermaid
flowchart TB
    subgraph "Public API Functions"
        FLAG["addCohortIntersectFlag()"]
        COUNT["addCohortIntersectCount()"]
        DAYS["addCohortIntersectDays()"]
        DATE["addCohortIntersectDate()"]
    end
    
    subgraph "Core Processing"
        CHECK["checkCohortNames()"]
        ADDINTERSECT[".addIntersect()"]
    end
    
    subgraph "Input Sources"
        SOURCE_COHORT["Source Cohort Table"]
        TARGET_COHORT["Target Cohort Table"]
        CDM["CDM Reference"]
    end
    
    subgraph "Output Types"
        BINARY_OUTPUT["Binary Flag (0/1)"]
        COUNT_OUTPUT["Count (Integer)"]
        DAYS_OUTPUT["Days (Integer)"]
        DATE_OUTPUT["Date (Date)"]
    end
    
    SOURCE_COHORT --> FLAG
    TARGET_COHORT --> FLAG
    CDM --> FLAG
    
    SOURCE_COHORT --> COUNT
    TARGET_COHORT --> COUNT
    CDM --> COUNT
    
    SOURCE_COHORT --> DAYS
    TARGET_COHORT --> DAYS
    CDM --> DAYS
    
    SOURCE_COHORT --> DATE
    TARGET_COHORT --> DATE
    CDM --> DATE
    
    FLAG --> CHECK
    COUNT --> CHECK
    DAYS --> CHECK
    DATE --> CHECK
    
    CHECK --> ADDINTERSECT
    
    ADDINTERSECT --> BINARY_OUTPUT
    ADDINTERSECT --> COUNT_OUTPUT
    ADDINTERSECT --> DAYS_OUTPUT
    ADDINTERSECT --> DATE_OUTPUT
```

Sources: [R/addCohortIntersect.R:49-294](), [tests/testthat/test-addCohortIntersect.R:1-1011]()

## Core Functions

### addCohortIntersectFlag

Creates binary columns (0/1) indicating whether patients from the source cohort intersect with target cohorts within specified time windows. Supports overlap detection using both `targetStartDate` and `targetEndDate` parameters.

**Key Parameters:**
- `targetCohortTable`: Name of the cohort table to check for intersections
- `targetCohortId`: Vector of cohort definition IDs to include (NULL for all)
- `window`: Time windows as list of vectors, e.g., `list(c(0, Inf))`
- `targetStartDate` / `targetEndDate`: Define overlap periods in target cohort

Sources: [R/addCohortIntersect.R:49-82](), [tests/testthat/test-addCohortIntersect.R:508-597]()

### addCohortIntersectCount

Returns integer counts of how many target cohort entries intersect within each time window. Useful for analyzing frequency of co-occurring conditions or treatments.

Sources: [R/addCohortIntersect.R:118-151](), [tests/testthat/test-addCohortIntersect.R:397-506]()

### addCohortIntersectDays

Calculates the number of days between the `indexDate` in the source table and the `targetDate` in the target cohort. Supports `order` parameter to select "first" or "last" occurrence when multiple records exist.

**Distinct Parameters:**
- `targetDate`: Single date column (either "cohort_start_date" or "cohort_end_date")
- `order`: "first" or "last" when multiple records exist in time window
- `window`: Single time window as vector, e.g., `c(0, Inf)`

Sources: [R/addCohortIntersect.R:188-222](), [tests/testthat/test-addCohortIntersect.R:73-182]()

### addCohortIntersectDate

Returns the actual dates of target cohort entries that intersect within the specified time windows. Like `addCohortIntersectDays`, supports `order` parameter for selecting specific occurrences.

Sources: [R/addCohortIntersect.R:259-293](), [tests/testthat/test-addCohortIntersect.R:73-182]()

## Temporal Window System

The cohort intersection functions use different window specifications depending on the type of analysis:

```mermaid
flowchart LR
    subgraph "Flag and Count Functions"
        OVERLAP_WINDOWS["window = list(c(0, Inf), c(-30, 30))"]
    end
    
    subgraph "Days and Date Functions"
        SINGLE_WINDOWS["window = c(0, Inf)"]
    end
    
    subgraph "Window Interpretation"
        INDEX_DATE["Index Date"]
        BEFORE["Before Index (Negative)"]
        AFTER["After Index (Positive)"]
        SAME_DAY["Same Day (0, 0)"]
    end
    
    OVERLAP_WINDOWS --> INDEX_DATE
    SINGLE_WINDOWS --> INDEX_DATE
    
    INDEX_DATE --> BEFORE
    INDEX_DATE --> AFTER
    INDEX_DATE --> SAME_DAY
    
    subgraph "Special Values"
        INF_PAST["c(-Inf, 0): All Past"]
        INF_FUTURE["c(0, Inf): All Future"]
        INF_ALL["c(-Inf, Inf): All Time"]
    end
```

**Window Examples:**
- `c(0, Inf)`: From index date to future
- `c(-30, 30)`: 30 days before to 30 days after index
- `c(-Inf, 0)`: All time before index date
- `list(c(0, 0), c(1, 30))`: Same day AND 1-30 days after

Sources: [tests/testthat/test-addCohortIntersect.R:34-68](), [tests/testthat/test-addCohortIntersect.R:786-835]()

## Multiple Cohort Entries Handling

When patients have multiple entries in either source or target cohorts, each record is processed independently:

```mermaid
flowchart TB
    subgraph "Source Cohort (Multiple Entries)"
        P1E1["Patient 1: Entry 2010-03-01"]
        P1E2["Patient 1: Entry 2012-03-01"]
        P2E1["Patient 2: Entry 2011-02-01"]
    end
    
    subgraph "Target Cohort Events"
        T1["2010-03-03"]
        T2["2010-03-15"]
        T3["2012-03-25"]
        T4["2013-01-03"]
    end
    
    subgraph "Window Processing (0-100 days)"
        W1["Window: [2010-03-01, 2010-06-09]"]
        W2["Window: [2012-03-01, 2012-06-09]"]
        W3["Window: [2011-02-01, 2011-05-12]"]
    end
    
    P1E1 --> W1
    P1E2 --> W2
    P2E1 --> W3
    
    T1 --> W1
    T2 --> W1
    T3 --> W2
    T4 --> W3
    
    subgraph "Results"
        R1["P1E1: First = 2 days (2010-03-03)"]
        R2["P1E2: First = 24 days (2012-03-25)"]
        R3["P2E1: No intersection"]
    end
    
    W1 --> R1
    W2 --> R2
    W3 --> R3
```

Sources: [tests/testthat/test-addCohortIntersect.R:184-274]()

## Output Naming System

Column names are generated using the `nameStyle` parameter with template variables:

**Default Pattern:** `{cohort_name}_{window_name}`

**Template Variables:**
- `{cohort_name}`: Target cohort name or "cohort_X" format
- `{window_name}`: Formatted window like "0_to_inf" or "minf_to_0"
- `{value}`: Function type ("flag", "count", "days", "date")

**Examples:**
- `"cohort_1_0_to_inf"` (default)
- `"study_{cohort_name}"` (custom)
- `"{value}_{cohort_name}_{window_name}"` (detailed)

Sources: [tests/testthat/test-addCohortIntersect.R:276-350](), [R/addCohortIntersect.R:57-58]()

## Censoring Functionality

The `censorDate` parameter allows limiting intersection detection to specific time periods:

```mermaid
flowchart LR
    subgraph "Censoring Options"
        NO_CENSOR["censorDate = NULL"]
        FIXED_CENSOR["censorDate = as.Date('2020-12-31')"]
        COLUMN_CENSOR["censorDate = 'cohort_end_date'"]
    end
    
    subgraph "Effect on Analysis"
        ALL_TIME["Analyze full time period"]
        FIXED_CUTOFF["Stop analysis at fixed date"]
        INDIVIDUAL_CUTOFF["Stop analysis at patient-specific date"]
    end
    
    NO_CENSOR --> ALL_TIME
    FIXED_CENSOR --> FIXED_CUTOFF
    COLUMN_CENSOR --> INDIVIDUAL_CUTOFF
```

When censoring is applied, events occurring after the censor date are ignored, and results may be `NA` if no valid intersections exist within the censored period.

Sources: [tests/testthat/test-addCohortIntersect.R:659-731](), [R/addCohortIntersect.R:24-25]()

## Error Handling

The system validates inputs and provides specific error messages for common issues:

**Validation Checks:**
- Target cohort table must exist in CDM
- Window start must be ≤ window end
- `censorDate` must be date type or valid column name
- `nameStyle` must include required template variables

**Edge Cases:**
- Empty intersections return appropriate defaults (0, NA, etc.)
- Multiple measurement results trigger duplicate detection warnings
- Non-existent cohort IDs are handled gracefully

Sources: [tests/testthat/test-addCohortIntersect.R:352-395](), [tests/testthat/test-addCohortIntersect.R:953-1010]()