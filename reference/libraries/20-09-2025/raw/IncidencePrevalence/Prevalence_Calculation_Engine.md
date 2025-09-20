# Page: Prevalence Calculation Engine

# Prevalence Calculation Engine

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/estimatePrevalence.R](R/estimatePrevalence.R)
- [R/getPrevalence.R](R/getPrevalence.R)

</details>



This document covers the technical implementation of the prevalence calculation engine, specifically the `getPrevalence` function and its supporting logic. This engine performs the core computational work for both point and period prevalence estimation.

For information about the differences between point and period prevalence types, see [Point vs Period Prevalence](#6.1). For details about configuration parameters like `fullContribution` and `timePoint`, see [Configuration Options](#6.3).

## Overview

The prevalence calculation engine is the core computational component that transforms denominator and outcome cohorts into prevalence estimates across specified time intervals. The engine handles complex logic for population filtering, time period processing, stratification, and confidence interval calculation.

```mermaid
graph TD
    subgraph "High-Level API"
        A["estimatePointPrevalence"]
        B["estimatePeriodPrevalence"]
        C["estimatePrevalence"]
    end
    
    subgraph "Input Processing"
        D["checkInputEstimatePrevalence"]
        E["Input Validation"]
        F["Study Specifications"]
    end
    
    subgraph "Core Calculation Engine"
        G["getPrevalence"]
        H["Population Filtering"]
        I["Time Period Processing"]
        J["Prevalence Calculation"]
    end
    
    subgraph "Supporting Functions"
        K["getStudyDays"]
        L["getStratifiedPrevalenceResult"]
        M["recordAttrition"]
        N["binomialCiWilson"]
    end
    
    subgraph "Result Processing"
        O["Confidence Intervals"]
        P["Result Formatting"]
        Q["Attrition Tracking"]
    end
    
    A --> C
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    G --> I
    G --> J
    G --> K
    G --> L
    G --> M
    J --> N
    H --> O
    I --> O
    J --> O
    O --> P
    M --> Q
```

Sources: [R/estimatePrevalence.R:59-91](), [R/estimatePrevalence.R:148-174](), [R/estimatePrevalence.R:176-539](), [R/getPrevalence.R:17-359]()

## Core Calculation Algorithm

The `getPrevalence` function implements the main calculation algorithm through several distinct phases:

### Data Preparation Phase

The engine begins by joining denominator and outcome cohorts and collecting the data locally for processing:

```mermaid
graph LR
    subgraph "Data Sources"
        A["cdm[[denominatorTable]]"]
        B["cdm[[outcomeTable]]"]
    end
    
    subgraph "Join Process"
        C["Filter denominatorCohortId"]
        D["Filter outcomeCohortId"] 
        E["Left Join by subject_id"]
        F["Rename outcome dates"]
    end
    
    subgraph "Local Processing"
        G["dplyr::collect()"]
        H["studyPop"]
    end
    
    A --> C
    B --> D
    C --> E
    D --> E
    E --> F
    F --> G
    G --> H
```

The join operation creates a unified dataset where each row represents a denominator cohort entry with associated outcome information if present.

Sources: [R/getPrevalence.R:38-61]()

### Time Period Generation

The engine generates study periods based on the requested intervals using the `getStudyDays` helper function:

| Interval Type | Processing Logic | Time Point Handling |
|---------------|------------------|-------------------|
| `weeks` | ISO week boundaries | Start/end of week based on `timePoint` |
| `months` | Calendar month boundaries | Start/end of month based on `timePoint` |
| `quarters` | Calendar quarter boundaries | Start/end of quarter based on `timePoint` |
| `years` | Calendar year boundaries | Start/end of year based on `timePoint` |
| `overall` | Full study period | From min start to max end date |

Sources: [R/getPrevalence.R:77-148]()

## Population Filtering Logic

The engine applies multiple filtering steps to ensure the analysis population meets the specified criteria:

```mermaid
graph TD
    subgraph "Initial Population"
        A["studyPop from cohort join"]
    end
    
    subgraph "Database Interval Filtering"
        B["Filter by minStartDate"]
        C["Filter by maxStartDate"]
        D["recordAttrition reason 12"]
    end
    
    subgraph "Full Contribution Filtering"
        E{fullContribution == TRUE?}
        F["Check presence for entire period"]
        G["Check presence for any day"]
        H["recordAttrition reason 13/14"]
    end
    
    subgraph "Time-Specific Filtering"
        I["Per-period population"]
        J["Apply workingStart/workingEnd"]
        K["Adjust individual dates"]
    end
    
    A --> B
    B --> C
    C --> D
    D --> E
    E -->|Yes| F
    E -->|No| G
    F --> H
    G --> H
    H --> I
    I --> J
    J --> K
```

### Full Contribution Logic

The `fullContribution` parameter controls how strictly individuals must be present during time periods:

- **`fullContribution = TRUE`**: Individuals must be present for the entire time interval
- **`fullContribution = FALSE`**: Individuals need only contribute at least one day to the interval

Sources: [R/getPrevalence.R:175-231](), [R/getPrevalence.R:243-261]()

## Prevalence Calculation Process

For each time period and stratification level, the engine calculates prevalence using different logic based on the analysis level:

### Person-Level Analysis

```mermaid
graph LR
    subgraph "Person Level Calculation"
        A["workingPop"]
        B["Count distinct subject_id"]
        C["Count subjects with outcome"]
        D["denominator_count"]
        E["outcome_count"]
    end
    
    subgraph "Outcome Detection Logic"
        F["!is.na(outcome_start_date)"]
        G["outcome_start_date <= cohort_end_date"]
        H["outcome_end_date >= cohort_start_date"]
        I["Outcome present in period"]
    end
    
    A --> B
    A --> C
    B --> D
    C --> E
    C --> F
    F --> G
    G --> H
    H --> I
    I --> E
```

### Record-Level Analysis

For record-level analysis, the engine counts cohort entries rather than unique individuals:

```mermaid
graph LR
    subgraph "Record Level Calculation"
        A["workingPop"]
        B["Select subject_id + cohort_start_date"]
        C["Count distinct records"]
        D["denominator_count"]
        E["outcome_count per record"]
    end
    
    A --> B
    B --> C
    C --> D
    B --> E
```

Sources: [R/getPrevalence.R:283-311]()

## Stratification Handling

The engine supports stratified analysis through the `getStratifiedPrevalenceResult` function:

```mermaid
graph TD
    subgraph "Stratification Process"
        A["workingPop"]
        B["Group by strata variables"]
        C["Calculate counts per stratum"]
        D["Unite strata columns"]
    end
    
    subgraph "Strata Integration"
        E["Overall results"]
        F["Stratified results"]
        G["Combined output"]
    end
    
    A --> B
    B --> C
    C --> D
    E --> G
    F --> G
    D --> F
```

The stratification logic maintains the same outcome detection criteria but applies them within each stratum group.

Sources: [R/getPrevalence.R:326-342](), [R/getPrevalence.R:361-401]()

## Result Aggregation and Confidence Intervals

After collecting prevalence estimates across all time periods, the engine aggregates results and calculates confidence intervals:

### Wilson Score Confidence Intervals

The engine uses the Wilson score method for calculating 95% confidence intervals:

```mermaid
graph LR
    subgraph "Confidence Interval Calculation"
        A["outcome_count (x)"]
        B["denominator_count (n)"]
        C["binomialCiWilson function"]
        D["Wilson score formula"]
        E["95% CI bounds"]
    end
    
    A --> C
    B --> C
    C --> D
    D --> E
```

The Wilson score method is preferred over normal approximation as it provides better coverage for small samples and extreme prevalence values.

Sources: [R/estimatePrevalence.R:406-412](), [R/estimatePrevalence.R:541-552]()

## Attrition Tracking

Throughout the calculation process, the engine maintains detailed attrition records using standardized reason codes:

| Reason ID | Description | Applied When |
|-----------|-------------|--------------|
| 11 | Starting analysis population | Initial population |
| 12 | Not observed during complete database interval | Database interval filtering |
| 13 | Do not satisfy full contribution requirement | `fullContribution = TRUE` |
| 14 | Do not satisfy full contribution requirement | `fullContribution = FALSE` |

The attrition tracking enables users to understand how population filters affect their analysis.

Sources: [R/getPrevalence.R:63-68](), [R/getPrevalence.R:191-231]()

## Performance Considerations

The engine includes several optimizations for handling large datasets:

1. **Local Collection**: Data is collected once and processed locally to minimize database queries
2. **Vectorized Operations**: Uses vectorized date comparisons and filtering
3. **Efficient Grouping**: Stratification uses efficient dplyr grouping operations
4. **Parallel Processing**: Multiple analysis specifications can be processed in parallel

The engine provides progress indicators for long-running analyses and reports total execution time upon completion.

Sources: [R/getPrevalence.R:60-61](), [R/estimatePrevalence.R:296-323](), [R/estimatePrevalence.R:533-536]()