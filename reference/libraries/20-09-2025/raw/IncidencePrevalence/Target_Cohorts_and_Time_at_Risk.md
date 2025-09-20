# Page: Target Cohorts and Time-at-Risk

# Target Cohorts and Time-at-Risk

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/generateDenominatorCohortSet.R](R/generateDenominatorCohortSet.R)
- [tests/testthat/test-generateDenominatorCohortSet.R](tests/testthat/test-generateDenominatorCohortSet.R)
- [vignettes/a02_Creating_denominator_populations.Rmd](vignettes/a02_Creating_denominator_populations.Rmd)

</details>



This document covers the creation of denominator cohorts that are constrained by existing target cohorts and the specification of time-at-risk windows. This functionality allows for more precise population definitions where individuals only contribute observation time when they are members of a specific target cohort and within defined time windows relative to their target cohort entry.

For basic denominator cohort creation without target constraints, see [Denominator Cohort Creation](#4.1). For population filtering and attrition concepts, see [Population Filtering and Attrition](#4.3).

## Target Cohort Constraints

Target cohorts provide a mechanism to restrict denominator populations to individuals who are members of pre-existing cohorts during specific time periods. This is implemented through the `generateTargetDenominatorCohortSet()` function, which constrains the standard denominator logic by requiring individuals to be present in a target cohort table.

### Target Cohort Data Flow

```mermaid
flowchart TD
    A["targetCohortTable"] --> B["generateTargetDenominatorCohortSet()"]
    C["targetCohortId"] --> B
    D["observation_period"] --> E["fetchDenominatorCohortSet()"]
    F["person"] --> E
    B --> E
    E --> G["getDenominatorCohorts()"]
    G --> H["Target cohort intersection"]
    H --> I["Time-at-risk application"]
    I --> J["Final denominator cohorts"]
    
    K["ageGroup"] --> B
    L["sex"] --> B
    M["daysPriorObservation"] --> B
    N["timeAtRisk"] --> B
    O["requirementsAtEntry"] --> B
```

**Sources:** [R/generateDenominatorCohortSet.R:87-175]()

The target cohort constrains individuals in two ways:
1. **Temporal constraint**: Individuals only contribute time when they are active members of the target cohort
2. **Population constraint**: Only individuals who appear in the target cohort are considered for inclusion

### Requirements at Entry vs Any Time

The `requirementsAtEntry` parameter controls when demographic and observation requirements must be satisfied:

```mermaid
graph LR
    A["Target Cohort Entry"] --> B{requirementsAtEntry}
    B -->|TRUE| C["Requirements must be met at target start date"]
    B -->|FALSE| D["Requirements can be met any time during target period"]
    C --> E["Cohort start = target start (if requirements met)"]
    D --> F["Cohort start = later of target start or requirement satisfaction"]
```

**Sources:** [R/generateDenominatorCohortSet.R:125-127](), [R/generateDenominatorCohortSet.R:622-652]()

## Time-at-Risk Windows

Time-at-risk windows define specific periods relative to target cohort entry during which individuals can contribute observation time. This allows for analyses focused on particular risk periods following an index event.

### Time-at-Risk Specification

The `timeAtRisk` parameter accepts either a single vector or list of vectors specifying time windows:

| Format | Example | Meaning |
|--------|---------|---------|
| `c(start, end)` | `c(0, 30)` | 0 to 30 days after target entry |
| `c(start, Inf)` | `c(365, Inf)` | 365 days after target entry onwards |
| `list(c(s1,e1), c(s2,e2))` | `list(c(0,30), c(31,90))` | Multiple non-overlapping windows |

### Time-at-Risk Processing Logic

```mermaid
sequenceDiagram
    participant TC as Target Cohort
    participant TAR as Time-at-Risk Processor
    participant DC as Denominator Cohort
    
    TC->>TAR: Target start/end dates
    TAR->>TAR: Calculate TAR start = target_start + timeAtRiskStart
    TAR->>TAR: Calculate TAR end = target_start + timeAtRiskEnd
    TAR->>DC: Update cohort_start_date = max(cohort_start, TAR_start)
    TAR->>DC: Update cohort_end_date = min(cohort_end, TAR_end)
    DC->>DC: Filter cohort_start_date <= cohort_end_date
```

**Sources:** [R/generateDenominatorCohortSet.R:197-252]()

### Multiple Time-at-Risk Windows

When multiple time-at-risk windows are specified, the function creates separate cohorts for each window:

```mermaid
graph TD
    A["timeAtRisk = list(c(0,30), c(31,90), c(91,365))"] --> B["Split into separate processing"]
    B --> C["Cohort 1: Days 0-30"]
    B --> D["Cohort 2: Days 31-90"] 
    B --> E["Cohort 3: Days 91-365"]
    C --> F["Union all cohorts"]
    D --> F
    E --> F
    F --> G["Final cohort table with time_at_risk metadata"]
```

**Sources:** [R/generateDenominatorCohortSet.R:177-304]()

## Technical Implementation

### Core Function Signatures

The main function signature for target-based denominator generation:

```
generateTargetDenominatorCohortSet(
  cdm,
  name,
  targetCohortTable,
  targetCohortId = NULL,
  cohortDateRange = as.Date(c(NA, NA)),
  timeAtRisk = c(0, Inf),
  ageGroup = list(c(0, 150)),
  sex = "Both",
  daysPriorObservation = 0,
  requirementsAtEntry = TRUE,
  requirementInteractions = TRUE
)
```

**Sources:** [R/generateDenominatorCohortSet.R:148-158]()

### Internal Processing Architecture

```mermaid
flowchart TD
    A["generateTargetDenominatorCohortSet()"] --> B["fetchDenominatorCohortSet()"]
    B --> C["checkInputGenerateDCS()"]
    B --> D["buildPopSpecs()"]
    B --> E["fetchSingleTargetDenominatorCohortSet()"]
    E --> F["getDenominatorCohorts()"]
    F --> G["Target cohort filtering"]
    G --> H["Demographics filtering"]
    H --> I["unionCohorts()"]
    
    J["Time-at-risk processing"] --> K["Split by timeAtRisk windows"]
    K --> L["Update entry/exit dates"]
    L --> M["Filter valid time periods"]
    M --> N["Combine with cohort attributes"]
```

**Sources:** [R/generateDenominatorCohortSet.R:163-175](), [R/generateDenominatorCohortSet.R:309-472]()

### Date Calculation Logic

Time-at-risk dates are calculated using database-native date arithmetic:

```mermaid
graph LR
    A["target_cohort_start_date"] --> B["+ timeAtRiskStart days"]
    B --> C["cohort_start_date"]
    A --> D["+ timeAtRiskEnd days"] 
    D --> E["tar_end_date"]
    E --> F["min(cohort_end_date, tar_end_date)"]
    F --> G["Final cohort_end_date"]
```

The implementation uses `CDMConnector::dateadd()` for database-portable date arithmetic.

**Sources:** [R/generateDenominatorCohortSet.R:213-241]()

## Cohort Metadata and Attrition

### Settings and Attributes

Target denominator cohorts include additional metadata in their settings:

| Column | Description |
|--------|-------------|
| `target_cohort_definition_id` | ID from the target cohort table |
| `target_cohort_name` | Name from the target cohort table |
| `time_at_risk` | Time window specification (e.g., "0 to 30") |
| `requirements_at_entry` | Whether requirements applied at entry |

**Sources:** [R/generateDenominatorCohortSet.R:710-724]()

### Attrition Tracking

The attrition table tracks population reduction through several steps:

1. Initial database population
2. Valid observation periods  
3. Age and sex criteria
4. Prior observation requirements
5. Target cohort membership
6. Time-at-risk window constraints

**Sources:** [R/generateDenominatorCohortSet.R:294-296](), [R/generateDenominatorCohortSet.R:657-663]()

## Usage Patterns

### Basic Target Cohort Usage

```r
# Constrain to members of target cohort ID 1
cdm <- generateTargetDenominatorCohortSet(
  cdm = cdm,
  name = "denominator", 
  targetCohortTable = "drug_exposure_cohort",
  targetCohortId = 1
)
```

### Time-at-Risk Window Usage

```r
# Multiple risk windows
cdm <- generateTargetDenominatorCohortSet(
  cdm = cdm,
  name = "denominator",
  targetCohortTable = "treatment_cohort", 
  timeAtRisk = list(c(0, 30), c(31, 90), c(91, 365))
)
```

### Flexible Requirement Timing

```r
# Allow requirement satisfaction after target entry
cdm <- generateTargetDenominatorCohortSet(
  cdm = cdm,
  name = "denominator",
  targetCohortTable = "index_cohort",
  ageGroup = list(c(18, 65)),
  daysPriorObservation = 365,
  requirementsAtEntry = FALSE
)
```

**Sources:** [tests/testthat/test-generateDenominatorCohortSet.R:121-147](), [tests/testthat/test-generateDenominatorCohortSet.R:1830-1983]()