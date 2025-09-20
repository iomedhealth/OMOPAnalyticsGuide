# Page: Demographics-Based Cohorts

# Demographics-Based Cohorts

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/demographicsCohort.R](R/demographicsCohort.R)
- [R/utilities.R](R/utilities.R)
- [man/demographicsCohort.Rd](man/demographicsCohort.Rd)
- [vignettes/a00_introduction.Rmd](vignettes/a00_introduction.Rmd)
- [vignettes/a01_building_base_cohorts.Rmd](vignettes/a01_building_base_cohorts.Rmd)
- [vignettes/images/pipeline.png](vignettes/images/pipeline.png)

</details>



Demographics-based cohorts are created using patient characteristics such as age, sex, and observation period requirements. These cohorts define populations where individuals enter when they satisfy specified demographic criteria and exit when they no longer meet those criteria.

For concept-based cohorts using clinical codes, see [Concept-Based Cohorts](#3.1). For applying demographic requirements to existing cohorts, see [Demographic Requirements](#5.1).

## Overview

The `demographicsCohort()` function creates cohorts by combining observation periods with demographic criteria. Unlike other cohort types that are based on clinical events, demographic cohorts define populations purely based on patient characteristics and when those characteristics are satisfied during their observation time.

**Core Function Architecture**

```mermaid
graph LR
    demographicsCohort["demographicsCohort()"]
    observation_period[("observation_period")]
    person[("person")]
    base_cohort["Base Cohort"]
    trimDemographics["trimDemographics()"]
    final_cohort["Demographic Cohort"]
    
    observation_period --> demographicsCohort
    person --> demographicsCohort
    demographicsCohort --> base_cohort
    base_cohort --> trimDemographics
    trimDemographics --> final_cohort
```

Sources: [R/demographicsCohort.R:39-84]()

## Function Parameters and Behavior

The `demographicsCohort()` function accepts several key parameters that define the demographic criteria:

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `ageRange` | list or vector | Minimum and maximum age ranges | NULL |
| `sex` | character | "Both", "Male", or "Female" | NULL |
| `minPriorObservation` | numeric | Days of prior observation required | NULL |
| `.softValidation` | logical | Perform soft validation checks | TRUE |

**Multiple Cohort Creation**

The function supports creating multiple demographic cohorts simultaneously by providing lists or vectors for parameters:

- `ageRange = list(c(0, 17), c(18, 65), c(66, 120))` creates three age-based cohorts
- `sex = c("Female", "Male")` creates separate cohorts for each sex
- Multiple `minPriorObservation` values create cohorts with different observation requirements

Sources: [R/demographicsCohort.R:39-44](), [man/demographicsCohort.Rd:16-33]()

## Data Flow and Implementation

**Step 1: Base Cohort Creation**

```mermaid
graph TB
    subgraph "Initial Processing"
        obs_period[("observation_period")]
        person_table[("person")]
        join_op["Inner Join on person_id"]
    end
    
    subgraph "Base Cohort Structure"
        select_cols["Select and Rename:<br/>person_id → subject_id<br/>observation_period_start_date → cohort_start_date<br/>observation_period_end_date → cohort_end_date"]
        add_id["Add cohort_definition_id = 1L"]
        compute_base["Compute as temporary table"]
    end
    
    subgraph "Cohort Table Creation"
        newCohortTable["omopgenerics::newCohortTable()"]
        cohort_set["Create cohortSetRef with<br/>cohort_name = 'demographics'"]
    end
    
    obs_period --> join_op
    person_table --> join_op
    join_op --> select_cols
    select_cols --> add_id
    add_id --> compute_base
    compute_base --> newCohortTable
    cohort_set --> newCohortTable
```

**Step 2: Demographic Filtering**

The base cohort is then passed to `trimDemographics()` which applies the actual demographic criteria and creates multiple cohort definitions as needed.

Sources: [R/demographicsCohort.R:49-70]()

## Integration with trimDemographics

The `demographicsCohort()` function delegates the core demographic filtering logic to `trimDemographics()`:

```mermaid
graph LR
    subgraph "Input Parameters"
        ageRange_param["ageRange"]
        sex_param["sex"] 
        minPrior_param["minPriorObservation"]
    end
    
    subgraph "trimDemographics() Call"
        cohort_input["Base Cohort"]
        cohortId_null["cohortId = NULL"]
        name_param["name"]
        softValidation["(.softValidation)"]
    end
    
    subgraph "Output"
        filtered_cohort["Filtered Demographic Cohort"]
        multiple_definitions["Multiple cohort_definition_ids<br/>if multiple criteria specified"]
    end
    
    ageRange_param --> trimDemographics
    sex_param --> trimDemographics
    minPrior_param --> trimDemographics
    cohort_input --> trimDemographics
    cohortId_null --> trimDemographics
    name_param --> trimDemographics
    softValidation --> trimDemographics
    
    trimDemographics --> filtered_cohort
    trimDemographics --> multiple_definitions
```

This design allows `demographicsCohort()` to focus on creating the base cohort structure while `trimDemographics()` handles the complex logic of applying demographic criteria and creating multiple cohort definitions.

Sources: [R/demographicsCohort.R:72-80]()

## Common Use Cases

**Working Age Population**

Creating a cohort of individuals aged 18-65:
- Entry: 18th birthday or observation period start (whichever is later)
- Exit: Day before 66th birthday or observation period end (whichever is earlier)

**Sex-Stratified Analysis**

Creating separate cohorts for males and females within the same age range for comparative studies.

**Prior Observation Requirements**

Ensuring individuals have sufficient database history before cohort entry, commonly used for:
- Baseline characteristic assessment
- Washout period requirements
- Ensuring data completeness

**Multiple Demographic Strata**

Creating comprehensive demographic strata by combining age groups, sex, and observation requirements for population-based studies.

Sources: [vignettes/a01_building_base_cohorts.Rmd:129-183]()

## Cohort Metadata and Tracking

The function creates complete cohort metadata including:

- **Cohort Settings**: Records all demographic criteria applied
- **Attrition Records**: Tracks how many individuals meet each criterion
- **Cohort Definitions**: Creates separate definitions for each combination of criteria

This metadata enables full reproducibility and transparency in demographic cohort construction.

Sources: [vignettes/a01_building_base_cohorts.Rmd:138-141](), [vignettes/a01_building_base_cohorts.Rmd:164-167]()