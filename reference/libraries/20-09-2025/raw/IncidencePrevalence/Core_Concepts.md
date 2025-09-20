# Page: Core Concepts

# Core Concepts

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/generateDenominatorCohortSet.R](R/generateDenominatorCohortSet.R)
- [README.Rmd](README.Rmd)
- [README.md](README.md)
- [vignettes/a02_Creating_denominator_populations.Rmd](vignettes/a02_Creating_denominator_populations.Rmd)

</details>



This page covers the fundamental epidemiological and technical concepts that underpin the IncidencePrevalence package. It explains how the package integrates with OMOP CDM data, the core concepts of cohorts and populations, and the differences between incidence and prevalence analyses.

For specific implementation details about cohort generation, see [Cohort Generation](#4). For detailed analysis procedures, see [Incidence Analysis](#5) and [Prevalence Analysis](#6).

## OMOP CDM Foundation

The IncidencePrevalence package is built specifically to work with data in the OMOP Common Data Model (CDM) format. The package integrates seamlessly with the OMOP ecosystem through standardized interfaces and data structures.

### CDM Data Flow Architecture

```mermaid
flowchart TD
    subgraph "OMOP CDM Tables"
        Person["person"]
        ObsPeriod["observation_period"]
        CondOcc["condition_occurrence"]
        DrugExp["drug_exposure"]
    end
    
    subgraph "CDMConnector Integration"
        CDMRef["cdm reference object"]
        DBConn["Database Connection"]
    end
    
    subgraph "IncidencePrevalence Core"
        GenDenom["generateDenominatorCohortSet()"]
        GenTarget["generateTargetDenominatorCohortSet()"]
        EstInc["estimateIncidence()"]
        EstPrev["estimatePrevalence()"]
    end
    
    subgraph "Cohort Tables"
        DenomCohort["Denominator Cohorts"]
        OutcomeCohort["Outcome Cohorts"]
    end
    
    subgraph "Results"
        IncResults["Incidence Results"]
        PrevResults["Prevalence Results"]
    end
    
    Person --> CDMRef
    ObsPeriod --> CDMRef
    CondOcc --> CDMRef
    DrugExp --> CDMRef
    
    CDMRef --> GenDenom
    CDMRef --> GenTarget
    
    GenDenom --> DenomCohort
    GenTarget --> DenomCohort
    
    DenomCohort --> EstInc
    DenomCohort --> EstPrev
    OutcomeCohort --> EstInc
    OutcomeCohort --> EstPrev
    
    EstInc --> IncResults
    EstPrev --> PrevResults
    
    DBConn --> CDMRef
```

The package expects data to follow OMOP CDM conventions, with standard table structures and relationships. Key OMOP tables used include:

| Table | Purpose | Key Fields |
|-------|---------|------------|
| `person` | Individual demographics | `person_id`, `gender_concept_id`, `year_of_birth` |
| `observation_period` | Time periods of data availability | `person_id`, `observation_period_start_date`, `observation_period_end_date` |
| `condition_occurrence` | Medical conditions/events | `person_id`, `condition_start_date`, `condition_concept_id` |
| `drug_exposure` | Medication exposures | `person_id`, `drug_exposure_start_date`, `drug_concept_id` |

Sources: [README.md:41-70](), [vignettes/a02_Creating_denominator_populations.Rmd:47-50]()

## Cohorts and Populations

The fundamental building blocks of epidemiological analysis in this package are **denominator cohorts** and **outcome cohorts**. Understanding their relationship is crucial for proper analysis.

### Denominator vs Outcome Cohorts

```mermaid
graph TB
    subgraph "Population Definitions"
        DenomPop["Denominator Population<br/>Population at Risk"]
        OutcomePop["Outcome Population<br/>Population with Events"]
    end
    
    subgraph "Cohort Generation Functions"
        GenDCS["generateDenominatorCohortSet()"]
        GenTDCS["generateTargetDenominatorCohortSet()"]
        External["External Cohort Definition<br/>(e.g., ATLAS, Capr)"]
    end
    
    subgraph "Cohort Tables"
        DenomTable["Denominator Cohort Table<br/>- cohort_definition_id<br/>- subject_id<br/>- cohort_start_date<br/>- cohort_end_date"]
        OutcomeTable["Outcome Cohort Table<br/>- cohort_definition_id<br/>- subject_id<br/>- cohort_start_date<br/>- cohort_end_date"]
    end
    
    subgraph "Analysis Functions"
        Analysis["estimateIncidence()<br/>estimatePrevalence()"]
    end
    
    DenomPop --> GenDCS
    DenomPop --> GenTDCS
    OutcomePop --> External
    
    GenDCS --> DenomTable
    GenTDCS --> DenomTable
    External --> OutcomeTable
    
    DenomTable --> Analysis
    OutcomeTable --> Analysis
```

**Denominator Cohorts** represent the population at risk - individuals who could potentially experience the outcome of interest. These are generated using package functions and define:
- Who is eligible for analysis
- When they enter and exit the analysis period
- Population stratification (age, sex, etc.)

**Outcome Cohorts** represent individuals who experience the event of interest. These are typically defined outside the package using tools like ATLAS or Capr, and define:
- What constitutes an "event"
- When the event occurred
- Event-specific criteria

Sources: [R/generateDenominatorCohortSet.R:17-24](), [vignettes/a02_Creating_denominator_populations.Rmd:23-36]()

### Cohort Entry and Exit Logic

The package implements sophisticated logic for determining when individuals enter and exit denominator cohorts:

```mermaid
flowchart TD
    subgraph "Entry Criteria (Latest of)"
        StudyStart["Study Start Date"]
        PriorObs["Date + daysPriorObservation"]
        MinAge["Date Reaching Minimum Age"]
    end
    
    subgraph "Exit Criteria (Earliest of)"
        StudyEnd["Study End Date"]
        ObsEnd["Observation Period End"]
        MaxAge["Date Reaching Maximum Age + 1"]
    end
    
    subgraph "Individual Timeline"
        Entry["Cohort Entry"]
        Exit["Cohort Exit"]
        TimeAtRisk["Time at Risk Period"]
    end
    
    StudyStart --> Entry
    PriorObs --> Entry
    MinAge --> Entry
    
    StudyEnd --> Exit
    ObsEnd --> Exit
    MaxAge --> Exit
    
    Entry --> TimeAtRisk
    TimeAtRisk --> Exit
```

This logic is implemented in the `fetchDenominatorCohortSet()` function, which determines eligibility based on multiple criteria:

| Criteria | Description | Parameter |
|----------|-------------|-----------|
| Study Period | Overall analysis timeframe | `cohortDateRange` |
| Prior Observation | Required database history | `daysPriorObservation` |
| Age Requirements | Minimum and maximum age | `ageGroup` |
| Sex Requirements | Male, Female, or Both | `sex` |

Sources: [vignettes/a02_Creating_denominator_populations.Rmd:25-36](), [R/generateDenominatorCohortSet.R:309-472]()

### Time-at-Risk Windows

For analyses with target cohorts, the package supports time-at-risk windows that define specific periods relative to target cohort entry:

```mermaid
gantt
    title Time-at-Risk Window Examples
    dateFormat X
    axisFormat %s
    
    section Target Cohort
    Target Entry    :0, 1
    
    section Time-at-Risk Windows
    0 to 30 days    :0, 30
    31 to 90 days   :30, 90
    0 to Inf        :0, 365
```

Time-at-risk windows are specified using the `timeAtRisk` parameter in `generateTargetDenominatorCohortSet()`:
- `c(0, 30)` - First 30 days after target entry
- `c(31, 90)` - Days 31-90 after target entry  
- `c(0, Inf)` - All time after target entry

Sources: [R/generateDenominatorCohortSet.R:109-116](), [R/generateDenominatorCohortSet.R:197-251]()

## Analysis Types: Incidence vs Prevalence

The package supports two fundamental epidemiological measures, each answering different research questions:

### Conceptual Differences

```mermaid
graph LR
    subgraph "Incidence Analysis"
        IncQuestion["Research Question:<br/>How often do new cases occur?"]
        IncMeasure["Measure:<br/>Rate of new events<br/>per person-time"]
        IncTime["Time Consideration:<br/>Longitudinal<br/>(events over time)"]
    end
    
    subgraph "Prevalence Analysis"
        PrevQuestion["Research Question:<br/>How common is the condition?"]
        PrevMeasure["Measure:<br/>Proportion of population<br/>with condition"]
        PrevTime["Time Consideration:<br/>Cross-sectional<br/>(point or period)"]
    end
    
    subgraph "Analysis Functions"
        EstInc["estimateIncidence()"]
        EstPP["estimatePointPrevalence()"]
        EstPeriod["estimatePeriodPrevalence()"]
    end
    
    IncQuestion --> EstInc
    PrevQuestion --> EstPP
    PrevQuestion --> EstPeriod
```

### Incidence Analysis Characteristics

**Incidence** measures the rate at which new cases occur in a population over time:

- **Focus**: New events only (first occurrence)
- **Denominator**: Person-time at risk
- **Washout periods**: Used to ensure "new" events
- **Repeated events**: Can be included with appropriate washout
- **Result units**: Events per person-year

Key parameters in `estimateIncidence()`:
- `outcomeWashout`: Minimum time between events
- `repeatedEvents`: Whether to include multiple events per person
- `completeDatabaseIntervals`: Require complete follow-up

### Prevalence Analysis Characteristics

**Prevalence** measures the proportion of a population that has a condition at a specific time or during a period:

**Point Prevalence**: Proportion with condition at a specific date
- **Focus**: Existing cases at timepoint
- **Denominator**: Population size at timepoint
- **Result units**: Proportion (0-1)

**Period Prevalence**: Proportion with condition during a time interval
- **Focus**: Anyone with condition during period
- **Denominator**: Population contributing to period
- **Result units**: Proportion (0-1)

Key parameters in prevalence functions:
- `timePoint`: For point prevalence ("start", "middle", "end")
- `fullContribution`: Require complete observation during period
- `completeDatabaseIntervals`: Require complete database coverage

Sources: [README.md:172-231](), [README.Rmd:122-163]()

## Temporal Logic and Analysis Windows

The package implements sophisticated temporal logic to handle different analysis scenarios:

### Analysis Interval Types

```mermaid
graph TB
    subgraph "Temporal Analysis Framework"
        Intervals["Analysis Intervals<br/>- years<br/>- months<br/>- quarters<br/>- overall"]
        
        Complete["completeDatabaseIntervals<br/>Require full DB coverage"]
        
        FullContrib["fullContribution<br/>Require full individual observation"]
    end
    
    subgraph "Time Window Applications"
        IncidenceTime["Incidence Analysis<br/>- Person-time calculation<br/>- Washout periods<br/>- Repeated event handling"]
        
        PrevalenceTime["Prevalence Analysis<br/>- Point-in-time assessment<br/>- Period coverage<br/>- Cross-sectional snapshots"]
    end
    
    Intervals --> IncidenceTime
    Intervals --> PrevalenceTime
    Complete --> IncidenceTime
    Complete --> PrevalenceTime
    FullContrib --> PrevalenceTime
```

### Key Temporal Concepts

| Concept | Description | Applied To |
|---------|-------------|------------|
| **Analysis Intervals** | Time periods for stratified analysis | Both incidence and prevalence |
| **Washout Periods** | Minimum time between events | Incidence only |
| **Complete Database Intervals** | Periods with full database coverage | Both |
| **Full Contribution** | Individuals observed for entire period | Prevalence only |
| **Time-at-Risk Windows** | Specific periods relative to target entry | Target-based analyses |

These temporal concepts ensure robust epidemiological analysis by handling common challenges like:
- Incomplete follow-up
- Database coverage gaps  
- Definition of "new" vs "existing" cases
- Population representativeness

Sources: [R/generateDenominatorCohortSet.R:109-116](), [vignettes/a02_Creating_denominator_populations.Rmd:55-69]()