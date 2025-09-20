# Page: Observation Period Management

# Observation Period Management

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/addObservationPeriodId.R](R/addObservationPeriodId.R)
- [man/addObservationPeriodId.Rd](man/addObservationPeriodId.Rd)
- [man/addObservationPeriodIdQuery.Rd](man/addObservationPeriodIdQuery.Rd)
- [tests/testthat/test-addAttributes.R](tests/testthat/test-addAttributes.R)
- [tests/testthat/test-addFutureObservation.R](tests/testthat/test-addFutureObservation.R)
- [tests/testthat/test-addInObservation.R](tests/testthat/test-addInObservation.R)
- [tests/testthat/test-addObservationPeriodId.R](tests/testthat/test-addObservationPeriodId.R)
- [tests/testthat/test-addPriorObservation.R](tests/testthat/test-addPriorObservation.R)
- [tests/testthat/test-addSex.R](tests/testthat/test-addSex.R)

</details>



This document covers the specialized functions in PatientProfiles for working with observation periods and temporal constraints within OMOP CDM data. Observation periods define the time windows during which patients have data available in the database, and these functions provide tools for temporal calculations, validation, and constraints based on those periods.

For general demographic information including age calculation, see [Patient Demographics](#2.1). For broader temporal analysis using cohort intersections, see [Cohort Intersection](#3.1.1).

## Core Concepts

Observation periods in OMOP CDM represent time intervals during which a patient is actively observed and data is expected to be captured. Each person can have multiple, potentially overlapping observation periods. The observation period management functions in PatientProfiles provide four key capabilities:

- **Temporal validation**: Checking if events occur within observation periods
- **Prior observation calculation**: Computing time from observation start to an index date  
- **Future observation calculation**: Computing time from an index date to observation end
- **Period identification**: Determining which observation period contains a given date

## Function Overview

The observation period management system consists of four primary functions, each with corresponding query versions:

| Function | Purpose | Returns |
|----------|---------|---------|
| `addInObservation` | Validates if index date is within observation | Binary flag (0/1) |
| `addPriorObservation` | Calculates time before index date | Days or start date |
| `addFutureObservation` | Calculates time after index date | Days or end date |
| `addObservationPeriodId` | Identifies containing observation period | Ordinal period number |

## System Architecture

```mermaid
graph TB
    subgraph "OMOP CDM Core Tables"
        PERSON["person<br/>patient demographics"]
        OBS_PERIOD["observation_period<br/>temporal boundaries"]
    end
    
    subgraph "Input Data"
        COHORT_TABLES["Cohort Tables<br/>subject_id + dates"]
        CLINICAL_TABLES["Clinical Tables<br/>person_id + dates"]
    end
    
    subgraph "Observation Period Functions"
        ADD_IN_OBS["addInObservation<br/>temporal validation"]
        ADD_PRIOR["addPriorObservation<br/>history calculation"]
        ADD_FUTURE["addFutureObservation<br/>follow-up calculation"]
        ADD_OBS_ID["addObservationPeriodId<br/>period identification"]
    end
    
    subgraph "Query Versions"
        IN_OBS_QUERY["addInObservationQuery"]
        PRIOR_QUERY["addPriorObservationQuery"]
        FUTURE_QUERY["addFutureObservationQuery"]
        OBS_ID_QUERY["addObservationPeriodIdQuery"]
    end
    
    subgraph "Output"
        ENHANCED_TABLES["Enhanced Tables<br/>+ temporal columns"]
    end
    
    OBS_PERIOD --> ADD_IN_OBS
    OBS_PERIOD --> ADD_PRIOR
    OBS_PERIOD --> ADD_FUTURE
    OBS_PERIOD --> ADD_OBS_ID
    
    COHORT_TABLES --> ADD_IN_OBS
    COHORT_TABLES --> ADD_PRIOR
    COHORT_TABLES --> ADD_FUTURE
    COHORT_TABLES --> ADD_OBS_ID
    
    CLINICAL_TABLES --> ADD_IN_OBS
    CLINICAL_TABLES --> ADD_PRIOR
    CLINICAL_TABLES --> ADD_FUTURE
    CLINICAL_TABLES --> ADD_OBS_ID
    
    ADD_IN_OBS --> IN_OBS_QUERY
    ADD_PRIOR --> PRIOR_QUERY
    ADD_FUTURE --> FUTURE_QUERY
    ADD_OBS_ID --> OBS_ID_QUERY
    
    ADD_IN_OBS --> ENHANCED_TABLES
    ADD_PRIOR --> ENHANCED_TABLES
    ADD_FUTURE --> ENHANCED_TABLES
    ADD_OBS_ID --> ENHANCED_TABLES
```

Sources: [tests/testthat/test-addInObservation.R](), [tests/testthat/test-addFutureObservation.R](), [tests/testthat/test-addPriorObservation.R](), [R/addObservationPeriodId.R]()

## Temporal Validation with addInObservation

The `addInObservation` function determines whether an index date falls within an observation period, returning a binary flag. This is essential for ensuring temporal validity of analyses.

### Core Parameters

- `indexDate`: Column containing the date to validate (default: `"cohort_start_date"`)
- `window`: Time window around index date as `c(start, end)` in days
- `completeInterval`: Whether the entire window must be within observation period
- `nameStyle`: Custom name for output column (default: `"in_observation"`)

### Multiple Observation Periods

When patients have multiple observation periods, the function checks each period to find valid overlaps. The algorithm considers a date valid if it falls within any observation period that satisfies the window requirements.

```mermaid
flowchart LR
    subgraph "Patient Timeline"
        OBS1["Obs Period 1<br/>2010-2015"]
        GAP["Gap"]
        OBS2["Obs Period 2<br/>2019-2021"]
    end
    
    subgraph "Index Dates"
        DATE1["2012-02-01<br/>✓ Valid"]
        DATE2["2017-06-01<br/>✗ Invalid"]
        DATE3["2020-01-01<br/>✓ Valid"]
    end
    
    DATE1 --> OBS1
    DATE2 --> GAP
    DATE3 --> OBS2
```

Sources: [tests/testthat/test-addInObservation.R:59-167]()

## Prior Observation Calculation

The `addPriorObservation` function calculates the time between the start of the relevant observation period and the index date. This is crucial for understanding patient history and ensuring sufficient baseline periods.

### Key Features

- **Multi-period handling**: Uses the observation period containing the index date
- **Return types**: Days (numeric) or start date
- **Custom naming**: Configurable output column names

The function handles complex scenarios where patients have multiple observation periods by selecting the period that contains the index date.

```mermaid
graph LR
    subgraph "Timeline Calculation"
        OBS_START["observation_period_start_date<br/>2010-01-01"]
        INDEX_DATE["index_date<br/>2012-02-01"]
        CALC["prior_observation<br/>397 days"]
    end
    
    OBS_START -->|"time difference"| INDEX_DATE
    INDEX_DATE --> CALC
```

Sources: [tests/testthat/test-addPriorObservation.R:179-232]()

## Future Observation Calculation

The `addFutureObservation` function calculates available follow-up time from an index date to the end of the observation period. This is essential for survival analyses and ensuring adequate follow-up periods.

### Return Options

- `futureObservationType = "days"`: Numeric days until observation end
- `futureObservationType = "date"`: Actual observation period end date
- Custom column names via `futureObservationName` parameter

### Handling Edge Cases

The function returns `NA` when the index date falls outside any observation period, ensuring robust handling of temporal inconsistencies.

Sources: [tests/testthat/test-addFutureObservation.R:208-250](), [tests/testthat/test-addFutureObservation.R:252-315]()

## Observation Period Identification

The `addObservationPeriodId` function assigns ordinal numbers to observation periods and identifies which period contains a given date. This is particularly valuable when patients have multiple observation periods.

### Implementation Details

The function implements the core logic in `.addObservationPeriodIdQuery()` which:

1. Joins input table with `observation_period` table on person/subject ID
2. Filters to periods containing the index date
3. Assigns ordinal numbers using `row_number()` ordered by period start date
4. Returns `NA` for dates outside any observation period

```mermaid
sequenceDiagram
    participant INPUT as "Input Table"
    participant FUNC as "addObservationPeriodId"
    participant OBS as "observation_period"
    participant OUTPUT as "Enhanced Table"
    
    INPUT->>FUNC: "Table with index dates"
    FUNC->>OBS: "Join on person_id/subject_id"
    OBS->>FUNC: "Observation periods"
    FUNC->>FUNC: "Filter by date ranges"
    FUNC->>FUNC: "Assign ordinal numbers"
    FUNC->>OUTPUT: "Table + observation_period_id"
```

Sources: [R/addObservationPeriodId.R:90-141](), [tests/testthat/test-addObservationPeriodId.R:172-244]()

## Data Flow and Integration

The observation period management functions integrate seamlessly with the broader PatientProfiles ecosystem, supporting both cohort tables (with `subject_id`) and standard OMOP clinical tables (with `person_id`).

```mermaid
graph TD
    subgraph "Input Validation"
        VALIDATE_X["validateX()<br/>table validation"]
        VALIDATE_INDEX["validateIndexDate()<br/>column validation"]
        VALIDATE_PERSON["personVariable<br/>ID column detection"]
    end
    
    subgraph "Core Processing"
        JOIN_OBS["Join with<br/>observation_period"]
        TEMPORAL_CALC["Temporal<br/>Calculations"]
        ORDINAL_ASSIGN["Ordinal<br/>Assignment"]
    end
    
    subgraph "Output Processing"
        COMPUTE_TABLE["computeTable()<br/>materialization"]
        QUERY_ONLY["Query-only<br/>versions"]
    end
    
    VALIDATE_X --> VALIDATE_INDEX
    VALIDATE_INDEX --> VALIDATE_PERSON
    VALIDATE_PERSON --> JOIN_OBS
    JOIN_OBS --> TEMPORAL_CALC
    JOIN_OBS --> ORDINAL_ASSIGN
    TEMPORAL_CALC --> COMPUTE_TABLE
    ORDINAL_ASSIGN --> COMPUTE_TABLE
    TEMPORAL_CALC --> QUERY_ONLY
    ORDINAL_ASSIGN --> QUERY_ONLY
```

Sources: [R/addObservationPeriodId.R:39-55](), [tests/testthat/test-addInObservation.R:169-195]()

## Performance and Query Optimization

Each observation period function provides a corresponding `*Query()` version that constructs the query without immediate computation, enabling:

- **Deferred execution**: Query building without table creation
- **Pipeline optimization**: Chaining multiple operations before materialization  
- **Resource management**: Avoiding intermediate table creation

The query versions maintain identical functionality while providing greater control over when computations are executed.

Sources: [tests/testthat/test-addInObservation.R:169-195](), [tests/testthat/test-addObservationPeriodId.R:156-167]()