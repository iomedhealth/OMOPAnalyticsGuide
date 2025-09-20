# Page: Cohort Overlap Analysis

# Cohort Overlap Analysis

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/summariseCohortOverlap.R](R/summariseCohortOverlap.R)
- [inst/doc/summarise_cohort_overlap.html](inst/doc/summarise_cohort_overlap.html)

</details>



Cohort overlap analysis examines the intersection of subjects (or records) between different cohorts within a cohort table. This analysis quantifies how many subjects appear in multiple cohorts, providing insights into cohort composition and potential patient pathway overlaps.

For information about cohort attrition analysis, see [3.2](#3.2). For cohort timing analysis between entry dates, see [3.4](#3.4).

## Purpose and Workflow

The cohort overlap analysis follows the standard three-tier pattern: `summariseCohortOverlap()` generates standardized overlap statistics, which can then be visualized with plotting functions or formatted into tables. The analysis calculates both absolute counts and percentages for subjects appearing exclusively in each cohort versus those appearing in both cohorts.

```mermaid
flowchart TD
    CT["cohort_table"] --> SCO["summariseCohortOverlap()"]
    SCO --> SR["summarised_result"]
    SR --> PL["plotCohortOverlap()"]
    SR --> TB["tableCohortOverlap()"]
    
    subgraph "Input Parameters"
        CID["cohortId"]
        ST["strata"]
        OB["overlapBy"]
    end
    
    CID --> SCO
    ST --> SCO
    OB --> SCO
    
    subgraph "Output Categories"
        REF["Only in reference cohort"]
        COMP["Only in comparator cohort"] 
        BOTH["In both cohorts"]
    end
    
    SR --> REF
    SR --> COMP
    SR --> BOTH
```

Sources: [R/summariseCohortOverlap.R:40-189]()

## Core Function Architecture

The `summariseCohortOverlap()` function implements a systematic approach to cohort intersection analysis through several key phases:

```mermaid
flowchart LR
    subgraph "Input Validation"
        IV1["validateCohortArgument()"]
        IV2["validateCohortIdArgument()"]  
        IV3["validateStrataArgument()"]
    end
    
    subgraph "Data Preparation"
        DP1["addCohortName()"]
        DP2["filterCohortId()"]
        DP3["Create unique_id"]
    end
    
    subgraph "Overlap Calculation"
        OC1["Calculate individual cohort counts"]
        OC2["Calculate pairwise overlaps"]
        OC3["getOverlapEstimates()"]
    end
    
    subgraph "Result Formatting"
        RF1["newSummarisedResult()"]
        RF2["Standard metadata"]
    end
    
    IV1 --> DP1
    IV2 --> DP2
    IV3 --> DP3
    DP3 --> OC1
    OC1 --> OC2
    OC2 --> OC3
    OC3 --> RF1
    RF1 --> RF2
```

Sources: [R/summariseCohortOverlap.R:44-53](), [R/summariseCohortOverlap.R:69-74](), [R/summariseCohortOverlap.R:98-168]()

## Key Parameters and Configuration

### Record Identification Strategy

The `overlapBy` parameter determines how records are matched between cohorts. The default `"subject_id"` identifies unique subjects, but multiple columns can be specified for more granular record matching:

| Parameter | Type | Purpose | Default |
|-----------|------|---------|---------|
| `overlapBy` | `character` | Columns for record identification | `"subject_id"` |
| `cohortId` | `integer` | Specific cohorts to analyze | `NULL` (all) |
| `strata` | `list` | Stratification variables | `list()` |

The function handles multi-column `overlapBy` by creating a unique identifier when `length(overlapBy) > 1`, ensuring proper record matching across cohorts.

Sources: [R/summariseCohortOverlap.R:77-92](), [R/summariseCohortOverlap.R:94]()

## Overlap Calculation Algorithm

The core overlap calculation follows a systematic approach using SQL-based operations for scalability:

```mermaid
flowchart TB
    subgraph "Phase 1: Individual Counts"
        P1A["Group by cohort_name + strata"]
        P1B["Count distinct records per cohort"]
        P1C["Store as 'counts' table"]
    end
    
    subgraph "Phase 2: Pairwise Overlaps"
        P2A["Self-join cohort table"]
        P2B["Match on overlapBy + strata"]
        P2C["Group by reference + comparator"]
        P2D["Count overlapping records"]
    end
    
    subgraph "Phase 3: Complete Matrix"
        P3A["Expand grid all cohort pairs"]
        P3B["Left join with overlap counts"]
        P3C["Left join with individual counts"]
        P3D["Replace NA with 0"]
    end
    
    P1A --> P1B --> P1C
    P2A --> P2B --> P2C --> P2D
    P3A --> P3B --> P3C --> P3D
    P1C --> P3B
    P2D --> P3C
```

Sources: [R/summariseCohortOverlap.R:100-106](), [R/summariseCohortOverlap.R:115-127](), [R/summariseCohortOverlap.R:133-160]()

## Statistical Estimates Generation

The `getOverlapEstimates()` function transforms raw overlap counts into meaningful statistical measures:

```mermaid
flowchart LR
    subgraph "Input Counts"
        IC1["number_subjects_reference"]
        IC2["number_subjects_overlap"] 
        IC3["number_subjects_comparator"]
    end
    
    subgraph "Adjusted Counts"
        AC1["reference - overlap"]
        AC2["overlap (unchanged)"]
        AC3["comparator - overlap"]
    end
    
    subgraph "Output Estimates"
        OE1["Count estimates"]
        OE2["Percentage estimates"]
    end
    
    IC1 --> AC1
    IC2 --> AC2  
    IC3 --> AC3
    AC1 --> OE1
    AC2 --> OE1
    AC3 --> OE1
    OE1 --> OE2
```

The function generates both absolute counts and percentages, where percentages are calculated as proportions of the total unique subjects across both cohorts.

Sources: [R/summariseCohortOverlap.R:191-223](), [R/summariseCohortOverlap.R:194-197](), [R/summariseCohortOverlap.R:209-212]()

## Integration with Package Ecosystem

### Data Dependencies

The overlap analysis relies on key package components for data validation and processing:

- `omopgenerics::validateCohortArgument()` - Ensures proper cohort table structure
- `PatientProfiles::addCohortName()` - Enriches data with human-readable cohort names
- `PatientProfiles::filterCohortId()` - Applies cohort filtering consistently

### Output Standardization

Results conform to the `summarised_result` standard used throughout the package:

```mermaid
flowchart LR
    subgraph "Result Structure"
        RS1["result_id: 1L"]
        RS2["result_type: 'summarise_cohort_overlap'"]
        RS3["package_name: 'CohortCharacteristics'"]
        RS4["overlap_by: concatenated column names"]
    end
    
    subgraph "Variable Categories"
        VC1["'Only in reference cohort'"]
        VC2["'Only in comparator cohort'"]
        VC3["'In both cohorts'"]
    end
    
    subgraph "Estimate Types"
        ET1["count (integer)"]
        ET2["percentage (percentage)"]
    end
    
    RS1 --> VC1
    RS2 --> VC2
    RS3 --> VC3
    RS4 --> ET1
    VC1 --> ET1
    VC2 --> ET1
    VC3 --> ET2
```

Sources: [R/summariseCohortOverlap.R:177-183](), [R/summariseCohortOverlap.R:170-176]()

## Performance and Scalability Considerations

The function implements several optimization strategies for large datasets:

- **Temporary Table Management**: Creates temporary tables using `omopgenerics::uniqueTableName()` and properly cleans them up
- **Lazy Evaluation**: Uses `dplyr::compute()` to materialize intermediate results only when necessary  
- **Efficient Joins**: Performs overlap calculations using database-native join operations rather than R memory operations
- **Unique ID Generation**: Optimizes multi-column `overlapBy` scenarios by creating single-column identifiers

Sources: [R/summariseCohortOverlap.R:65](), [R/summariseCohortOverlap.R:74](), [R/summariseCohortOverlap.R:185-186]()