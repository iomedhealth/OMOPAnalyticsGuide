# Page: Incidence vs Prevalence

# Incidence vs Prevalence

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [vignettes/a04_Calculating_prevalence.Rmd](vignettes/a04_Calculating_prevalence.Rmd)
- [vignettes/a05_Calculating_incidence.Rmd](vignettes/a05_Calculating_incidence.Rmd)

</details>



## Purpose and Scope

This document explains the fundamental differences between incidence and prevalence measures in epidemiological analysis, their conceptual foundations, and their implementation in the IncidencePrevalence package. It covers when to use each measure, key parameters that affect calculations, and how they are implemented through the package's core functions.

For detailed implementation guides, see [Incidence Analysis](#5) and [Prevalence Analysis](#6). For information about cohort generation that supports both measures, see [Cohorts and Populations](#3.2).

## Conceptual Differences

**Incidence** measures the rate at which new events occur in a population over time, focusing on transitions from a non-diseased to diseased state. **Prevalence** measures the proportion of a population that has a condition at a specific point in time or during a period, regardless of when the condition started.

### Temporal Perspective

```mermaid
timeline
    title "Incidence vs Prevalence: Temporal View"
    
    section Population Entry
        Start : "Person enters study"
        
    section Incidence Focus
        Event : "NEW occurrence detected"
             : "Counts toward incidence"
        
    section Prevalence Focus  
        Snapshot : "Point in time assessment"
                 : "Existing condition counts"
        Period : "Duration assessment"
               : "Any presence during interval"
```

**Sources:** [vignettes/a04_Calculating_prevalence.Rmd:27-29](), [vignettes/a05_Calculating_incidence.Rmd:28-28]()

### Mathematical Foundation

```mermaid
graph TB
    subgraph "Incidence Calculation"
        A["New Events"] --> C["Incidence Rate"]
        B["Person-Time at Risk"] --> C
        C --> D["Events per Person-Year"]
    end
    
    subgraph "Prevalence Calculation"  
        E["Existing Cases"] --> G["Prevalence Proportion"]
        F["Population at Risk"] --> G
        G --> H["Proportion (0-1) or Percentage"]
    end
    
    subgraph "Key Difference"
        I["Incidence: Dynamic (Rate)"]
        J["Prevalence: Static (Proportion)"]
    end
```

**Sources:** [vignettes/a04_Calculating_prevalence.Rmd:27-29](), [vignettes/a05_Calculating_incidence.Rmd:28-28]()

## When to Use Each Measure

| **Use Incidence When** | **Use Prevalence When** |
|------------------------|-------------------------|
| Studying disease onset or first occurrence | Assessing disease burden in population |
| Evaluating risk factors for new events | Planning healthcare resource allocation |
| Measuring intervention effectiveness for prevention | Understanding current health status |
| Analyzing time-to-event outcomes | Describing epidemiological patterns |
| Following cohorts longitudinally | Cross-sectional health assessments |

### Decision Framework

```mermaid
flowchart TD
    A["Research Question"] --> B{"Focus on NEW events?"}
    B -->|Yes| C["Use Incidence"]
    B -->|No| D{"Focus on EXISTING conditions?"}
    D -->|Yes| E["Use Prevalence"]
    D -->|No| F["Consider both measures"]
    
    C --> G["estimateIncidence()"]
    E --> H{"Point in time?"}
    H -->|Yes| I["estimatePointPrevalence()"]
    H -->|No| J["estimatePeriodPrevalence()"]
    
    F --> K["Comprehensive Analysis"]
    K --> G
    K --> H
```

**Sources:** [vignettes/a04_Calculating_prevalence.Rmd:44-45](), [vignettes/a05_Calculating_incidence.Rmd:73-73]()

## Implementation Overview

### Core Function Mapping

```mermaid
graph LR
    subgraph "Incidence Analysis"
        A["estimateIncidence()"] --> B["getIncidence()"]
        A --> C["outcomeWashout parameter"]
        A --> D["repeatedEvents parameter"] 
        A --> E["censorTable parameter"]
    end
    
    subgraph "Prevalence Analysis"
        F["estimatePointPrevalence()"] --> G["getPrevalence()"]
        F --> H["timePoint parameter"]
        I["estimatePeriodPrevalence()"] --> G
        I --> J["fullContribution parameter"]
    end
    
    subgraph "Common Infrastructure"
        K["generateDenominatorCohortSet()"] --> A
        K --> F  
        K --> I
        L["interval parameter"] --> A
        L --> F
        L --> I
    end
```

**Sources:** [vignettes/a05_Calculating_incidence.Rmd:105-112](), [vignettes/a04_Calculating_prevalence.Rmd:76-81](), [vignettes/a04_Calculating_prevalence.Rmd:134-139]()

## Point vs Period Prevalence

### Conceptual Distinction

**Point Prevalence** assesses the proportion of people with a condition at a specific moment in time. **Period Prevalence** assesses the proportion who had the condition at any time during a specified interval.

```mermaid
gantt
    title Point vs Period Prevalence Example
    dateFormat X
    axisFormat %d
    
    section Person 1
    Condition Present :milestone, 5, 0d
    
    section Person 2  
    Condition Period :active, 2, 8
    
    section Person 3
    No Condition :1, 10
    
    section Point Prevalence
    Assessment Point :milestone, point, 5, 0d
    
    section Period Prevalence
    Assessment Period :active, period, 3, 5
```

### Implementation Parameters

| Parameter | Function | Purpose | Default |
|-----------|----------|---------|---------|
| `timePoint` | `estimatePointPrevalence()` | When to assess within interval | `"start"` |
| `fullContribution` | `estimatePeriodPrevalence()` | Require full period observation | `TRUE` |
| `interval` | Both functions | Time granularity | `"years"` |

**Sources:** [vignettes/a04_Calculating_prevalence.Rmd:114-123](), [vignettes/a04_Calculating_prevalence.Rmd:163-172]()

### TimePoint Options

```mermaid
graph TD
    A["interval: 'Years'"] --> B["2023-01-01 to 2023-12-31"]
    B --> C["timePoint: 'start'"] 
    B --> D["timePoint: 'middle'"]
    B --> E["timePoint: 'end'"]
    
    C --> F["Assess on 2023-01-01"]
    D --> G["Assess on 2023-07-01"]  
    E --> H["Assess on 2023-12-31"]
```

**Sources:** [vignettes/a04_Calculating_prevalence.Rmd:117-123]()

## Incidence-Specific Considerations

### Outcome Washout

The `outcomeWashout` parameter defines the period after an outcome ends before a person can contribute time at risk again.

```mermaid
graph LR
    A["outcomeWashout = 0"] --> B["No washout period"]
    C["outcomeWashout = 180"] --> D["180 days washout"]
    E["outcomeWashout = Inf"] --> F["All prior history washout"]
    
    subgraph "Impact on Analysis"
        G["More events captured"] --> B
        H["Moderate event capture"] --> D  
        I["Incident events only"] --> F
    end
```

**Sources:** [vignettes/a05_Calculating_incidence.Rmd:134-143](), [vignettes/a05_Calculating_incidence.Rmd:151-159]()

### Repeated Events

The `repeatedEvents` parameter controls whether individuals can contribute multiple events during the study period.

| Setting | Behavior | Use Case |
|---------|----------|----------|
| `FALSE` | First event only | Studying disease onset |
| `TRUE` | Multiple events allowed | Studying recurrent conditions |

```mermaid
graph TD
    A["repeatedEvents = FALSE"] --> B["Person stops contributing after first event"]
    C["repeatedEvents = TRUE"] --> D["Person continues contributing after washout"]
    
    E["Example: Heart Attack Study"] --> A
    F["Example: Infection Study"] --> C
```

**Sources:** [vignettes/a05_Calculating_incidence.Rmd:168-177]()

### Censoring Events

The `censorTable` parameter allows specification of events that should end follow-up time.

```mermaid
sequenceDiagram
    participant P as "Person"
    participant S as "Study Period"
    participant O as "Outcome Events"
    participant C as "Censoring Event"
    
    P->>S: Enters study
    P->>O: At risk for outcome
    P->>C: Censoring event occurs
    Note over P,O: Follow-up ends
    C-->>O: No more outcomes counted
```

**Sources:** [vignettes/a05_Calculating_incidence.Rmd:185-195]()

## Comparative Analysis Workflow

### Function Call Patterns

```mermaid
sequenceDiagram
    participant User
    participant CDM as "CDM Reference"
    participant DenomGen as "generateDenominatorCohortSet"
    participant IncEst as "estimateIncidence"
    participant PrevEst as "estimatePointPrevalence/estimatePeriodPrevalence"
    participant Results as "Analysis Results"
    
    User->>CDM: Setup database connection
    User->>DenomGen: Create denominator cohorts
    DenomGen->>CDM: Query population data
    CDM-->>DenomGen: Return cohort definitions
    
    alt Incidence Analysis
        User->>IncEst: outcomeWashout, repeatedEvents
        IncEst->>CDM: Calculate person-time
        CDM-->>Results: Incidence rates
    else Prevalence Analysis  
        User->>PrevEst: timePoint, fullContribution
        PrevEst->>CDM: Calculate proportions
        CDM-->>Results: Prevalence estimates
    end
```

### Parameter Decision Matrix

| Research Question | Measure | Key Parameters | Function |
|-------------------|---------|----------------|----------|
| "How often do people develop diabetes?" | Incidence | `outcomeWashout=Inf, repeatedEvents=FALSE` | `estimateIncidence()` |
| "How many people have diabetes now?" | Point Prevalence | `timePoint="start"` | `estimatePointPrevalence()` |
| "How many people had diabetes this year?" | Period Prevalence | `fullContribution=TRUE` | `estimatePeriodPrevalence()` |
| "How often do infections recur?" | Incidence | `outcomeWashout=30, repeatedEvents=TRUE` | `estimateIncidence()` |

**Sources:** [vignettes/a05_Calculating_incidence.Rmd:105-112](), [vignettes/a04_Calculating_prevalence.Rmd:76-81](), [vignettes/a04_Calculating_prevalence.Rmd:134-139]()