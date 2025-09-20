# Page: Cohort Generation

# Cohort Generation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/generateDenominatorCohortSet.R](R/generateDenominatorCohortSet.R)
- [tests/testthat/test-generateDenominatorCohortSet.R](tests/testthat/test-generateDenominatorCohortSet.R)
- [vignettes/a02_Creating_denominator_populations.Rmd](vignettes/a02_Creating_denominator_populations.Rmd)

</details>



## Purpose and Scope

Cohort generation is the foundational step for all incidence and prevalence analyses in the IncidencePrevalence package. This system creates denominator populations that define the eligible study population and time-at-risk periods for epidemiological analyses. The cohort generation system handles demographic filtering, temporal constraints, observation requirements, and optional target cohort restrictions.

For information about using generated cohorts in analyses, see [Incidence Analysis](#5) and [Prevalence Analysis](#6). For details about input validation and error handling, see [Input Validation System](#8.1).

## System Overview

The cohort generation system provides two primary functions for creating denominator cohorts:

### Core Functions Architecture

```mermaid
graph TD
    subgraph "Public API"
        GDC["generateDenominatorCohortSet()"]
        GTDC["generateTargetDenominatorCohortSet()"]
    end
    
    subgraph "Internal Implementation" 
        FDC["fetchDenominatorCohortSet()"]
        FSTDC["fetchSingleTargetDenominatorCohortSet()"]
        GDenomCohorts["getDenominatorCohorts()"]
    end
    
    subgraph "Helper Functions"
        CGDR["getCohortDateRange()"]
        BPS["buildPopSpecs()"]
        UC["unionCohorts()"]
        UpdateC["updateCohort()"]
    end
    
    subgraph "Validation"
        CheckInput["checkInputGenerateDCS()"]
    end
    
    GDC --> CheckInput
    GTDC --> CheckInput
    CheckInput --> FDC
    FDC --> FSTDC
    FSTDC --> GDenomCohorts
    FDC --> CGDR
    FDC --> BPS
    FDC --> UC
    FDC --> UpdateC
    GTDC --> FDC
```

Sources: [R/generateDenominatorCohortSet.R:65-85](), [R/generateDenominatorCohortSet.R:148-175](), [R/generateDenominatorCohortSet.R:309-472]()

## Denominator Cohort Creation

### Basic Denominator Cohorts

The `generateDenominatorCohortSet()` function creates cohorts based on demographic and temporal criteria without target cohort constraints. Individuals enter cohorts on the latest of: study start date, age eligibility date, or sufficient prior observation date. They exit on the earliest of: study end date, observation period end, or age ineligibility date.

### Cohort Entry and Exit Logic

```mermaid
flowchart TD
    Start["Person in Database"] --> CheckObs["Has Observation Period?"]
    CheckObs -->|No| Exclude1["Exclude"]
    CheckObs -->|Yes| CheckAge["Meets Age Criteria?"]
    CheckAge -->|No| Exclude2["Exclude"]
    CheckAge -->|Yes| CheckSex["Meets Sex Criteria?"]
    CheckSex -->|No| Exclude3["Exclude"]
    CheckSex -->|Yes| CheckPriorObs["Has Sufficient Prior Observation?"]
    CheckPriorObs -->|No| Exclude4["Exclude"]
    CheckPriorObs -->|Yes| CheckStudyPeriod["In Study Period?"]
    CheckStudyPeriod -->|No| Exclude5["Exclude"]
    CheckStudyPeriod -->|Yes| Include["Include in Cohort"]
    
    Include --> DefineEntry["Entry Date = MAX(study_start, age_eligible_date, prior_obs_date)"]
    DefineEntry --> DefineExit["Exit Date = MIN(study_end, obs_period_end, age_ineligible_date)"]
    DefineExit --> ValidPeriod["Entry <= Exit?"]
    ValidPeriod -->|No| Exclude6["Exclude"]
    ValidPeriod -->|Yes| FinalCohort["Final Cohort Entry"]
```

Sources: [R/generateDenominatorCohortSet.R:590-694](), [vignettes/a02_Creating_denominator_populations.Rmd:25-36]()

### Function Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `cdm` | CDM reference | OMOP CDM database connection |
| `name` | character | Name for cohort table (must be snake_case) |
| `cohortDateRange` | Date vector | Study start and end dates |
| `ageGroup` | list | Age ranges as list of c(min, max) pairs |
| `sex` | character | "Male", "Female", "Both", or combinations |
| `daysPriorObservation` | numeric | Required prior observation days |
| `requirementInteractions` | logical | Create all combinations vs. sequential |

Sources: [R/generateDenominatorCohortSet.R:25-50]()

## Target-Based Cohort Creation  

### Target Cohort Integration

The `generateTargetDenominatorCohortSet()` function creates cohorts constrained by an existing target cohort. Individuals can only contribute time when they are active members of the specified target cohort.

### Target Cohort Data Flow

```mermaid
flowchart TD
    subgraph "Input Data"
        CDM["CDM Reference"]
        TargetTable["Target Cohort Table"]
        Params["Demographics & Temporal Parameters"]
    end
    
    subgraph "Processing Steps"
        ValidateTarget["Validate Target Cohort"]
        GetTargetIds["Get Target Cohort IDs"]
        JoinTarget["Join Demographics with Target"]
        ApplyTAR["Apply Time-at-Risk Windows"]
    end
    
    subgraph "Requirement Application"
        CheckReqsAtEntry["requirementsAtEntry = TRUE?"]
        ApplyAtIndex["Apply Requirements at Target Start"]
        ApplyAnytime["Apply Requirements Anytime in Target Period"]
    end
    
    subgraph "Output"
        FinalCohorts["Final Target-Constrained Cohorts"]
        TARCohorts["Multiple Time-at-Risk Cohorts"]
    end
    
    CDM --> ValidateTarget
    TargetTable --> ValidateTarget
    Params --> ValidateTarget
    ValidateTarget --> GetTargetIds
    GetTargetIds --> JoinTarget
    JoinTarget --> CheckReqsAtEntry
    CheckReqsAtEntry -->|Yes| ApplyAtIndex
    CheckReqsAtEntry -->|No| ApplyAnytime
    ApplyAtIndex --> ApplyTAR
    ApplyAnytime --> ApplyTAR
    ApplyTAR --> FinalCohorts
    ApplyTAR --> TARCohorts
```

Sources: [R/generateDenominatorCohortSet.R:148-175](), [R/generateDenominatorCohortSet.R:622-653]()

### Time-at-Risk Windows

Target cohorts support time-at-risk (TAR) windows that define specific periods relative to target cohort entry for analysis:

```mermaid
timeline
    title Time-at-Risk Window Example
    
    section Target Cohort Entry
        Day 0 : Target Start
    
    section TAR Window [30, 90]
        Day 30 : TAR Start
        Day 90 : TAR End
    
    section Analysis Period
        Day 30-90 : Contributing Time
```

Sources: [R/generateDenominatorCohortSet.R:177-304](), [tests/testthat/test-generateDenominatorCohortSet.R:1788-2015]()

## Internal Architecture

### Population Specification Building

The system uses `buildPopSpecs()` to create combinations of demographic criteria:

```mermaid
graph LR
    subgraph "Input Parameters"
        AgeGroups["ageGroup: list(c(0,17), c(18,65))"]
        SexOptions["sex: c('Male', 'Female', 'Both')"] 
        PriorObs["daysPriorObservation: c(0, 365)"]
        ReqInt["requirementInteractions: TRUE/FALSE"]
    end
    
    subgraph "Population Specifications"
        PopSpecs["buildPopSpecs()"]
    end
    
    subgraph "Output Combinations"
        Combo1["Age: 0-17, Sex: Male, Prior: 0"]
        Combo2["Age: 0-17, Sex: Male, Prior: 365"]
        Combo3["Age: 0-17, Sex: Female, Prior: 0"]
        ComboEtc["... (all combinations)"]
    end
    
    AgeGroups --> PopSpecs
    SexOptions --> PopSpecs  
    PriorObs --> PopSpecs
    ReqInt --> PopSpecs
    PopSpecs --> Combo1
    PopSpecs --> Combo2
    PopSpecs --> Combo3
    PopSpecs --> ComboEtc
```

Sources: [R/generateDenominatorCohortSet.R:761-799](), [R/generateDenominatorCohortSet.R:351-392]()

### Cohort Union Process

For large numbers of cohorts, the system implements batched processing via `unionCohorts()`:

```mermaid
flowchart TD
    IndividualCohorts["Individual Cohort Results"] --> CheckCount{">=10 Cohorts?"}
    CheckCount -->|Yes| CreateBatches["Split into Batches of 10"]
    CheckCount -->|No| DirectUnion["Direct Union"]
    CreateBatches --> ProcessBatches["Process Each Batch"]
    ProcessBatches --> UnionBatches["Union Batch Results"] 
    UnionBatches --> CombineAttributes["Combine cohort_set, cohort_count, cohort_attrition"]
    DirectUnion --> CombineAttributes
    CombineAttributes --> FinalTable["Final Cohort Table"]
```

Sources: [R/generateDenominatorCohortSet.R:804-947](), [R/generateDenominatorCohortSet.R:820-842]()

## Configuration Options

### Requirement Interactions

The `requirementInteractions` parameter controls how demographic criteria combinations are generated:

| Setting | Behavior | Example Output |
|---------|----------|----------------|
| `TRUE` | All combinations | 2 ages × 2 sexes × 2 prior obs = 8 cohorts |
| `FALSE` | Sequential addition | 2 ages + 2 sexes + 2 prior obs = 6 cohorts |

### Requirements at Entry

For target cohorts, `requirementsAtEntry` determines when demographic criteria must be satisfied:

| Setting | Behavior |
|---------|----------|
| `TRUE` | Must satisfy all criteria at target cohort start date |
| `FALSE` | Can satisfy criteria anytime during target cohort period |

Sources: [R/generateDenominatorCohortSet.R:46-49](), [R/generateDenominatorCohortSet.R:125-127](), [tests/testthat/test-generateDenominatorCohortSet.R:990-1196]()

## Output Structure

### Cohort Table Schema

Generated cohort tables follow the OMOP cohort structure with additional metadata:

| Column | Type | Description |
|--------|------|-------------|
| `cohort_definition_id` | integer | Unique cohort identifier |
| `subject_id` | integer | Person identifier |
| `cohort_start_date` | date | Cohort entry date |
| `cohort_end_date` | date | Cohort exit date |

### Metadata Attributes

Cohort tables include standardized metadata accessible via `omopgenerics` functions:

```mermaid
graph LR
    subgraph "Cohort Table Attributes"
        CohortSet["cohort_set: Demographics & Parameters"]
        CohortCount["cohort_count: Record & Subject Counts"]
        CohortAttrition["cohort_attrition: Exclusion Tracking"]
    end
    
    subgraph "Access Functions"
        SettingsFunc["settings(cohort_table)"]
        CountFunc["cohortCount(cohort_table)"]
        AttritionFunc["attrition(cohort_table)"]
    end
    
    CohortSet --> SettingsFunc
    CohortCount --> CountFunc
    CohortAttrition --> AttritionFunc
```

Sources: [R/generateDenominatorCohortSet.R:453-458](), [R/generateDenominatorCohortSet.R:710-735](), [tests/testthat/test-generateDenominatorCohortSet.R:407-423]()