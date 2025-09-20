# Page: Cohort Generation

# Cohort Generation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/mockCohort.R](R/mockCohort.R)
- [man/mockCohort.Rd](man/mockCohort.Rd)
- [man/mockObservationPeriod.Rd](man/mockObservationPeriod.Rd)
- [man/mockPerson.Rd](man/mockPerson.Rd)
- [tests/testthat/test-mockCohort.R](tests/testthat/test-mockCohort.R)
- [vignettes/a01_Creating_synthetic_clinical_tables.Rmd](vignettes/a01_Creating_synthetic_clinical_tables.Rmd)
- [vignettes/a02_Creating_synthetic_cohorts.Rmd](vignettes/a02_Creating_synthetic_cohorts.Rmd)
- [vignettes/a04_Building_a_bespoke_mock_cdm.Rmd](vignettes/a04_Building_a_bespoke_mock_cdm.Rmd)

</details>



This document covers the cohort generation functionality within the omock package, specifically the creation of synthetic cohorts for testing analytical workflows. Cohort generation creates patient groupings with defined start and end dates that conform to OMOP CDM cohort table standards.

For information about generating other clinical event tables like drug exposures or conditions, see [Clinical Event Tables](#3.2). For building CDM objects from custom tables that may include pre-defined cohorts, see [Building CDM from Custom Tables](#5.1).

## Overview

The cohort generation system provides functionality to create synthetic cohorts within existing CDM references. The primary function `mockCohort()` generates cohort tables containing patient groupings with realistic observation periods, supporting multiple cohorts with configurable properties.

```mermaid
flowchart TD
    subgraph "Input Requirements"
        A["CDM Reference<br/>(cdm_reference)"]
        B["Person Table<br/>(person)"] 
        C["Observation Period Table<br/>(observation_period)"]
    end
    
    subgraph "mockCohort Function"
        D["mockCohort()"]
        E["Input Validation<br/>(checkInput)"]
        F["Cohort ID Generation<br/>(seq_len)"]
        G["Subject Sampling<br/>(sample)"]
        H["Date Assignment<br/>(addCohortDates)"]
    end
    
    subgraph "Output Products"
        I["Cohort Table<br/>(cohort)"]
        J["Cohort Set Table<br/>(cohortSetTable)"]
        K["Updated CDM Reference<br/>(cdm_reference)"]
    end
    
    A --> D
    B --> D
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    H --> J
    I --> K
    J --> K
```

Sources: [R/mockCohort.R:1-228]()

## Core Function Architecture

The `mockCohort()` function operates as the primary interface for cohort generation, accepting a CDM reference and configuration parameters to produce synthetic cohort data.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `cdm` | cdm_reference | - | CDM object containing person and observation_period tables |
| `name` | character | "cohort" | Name of the cohort table to create |
| `numberCohorts` | integer | 1 | Number of distinct cohorts to generate |
| `cohortName` | character vector | "cohort_1", "cohort_2", ... | Names assigned to each cohort |
| `recordPerson` | integer/vector | 1 | Expected records per person per cohort |
| `seed` | integer | NULL | Random seed for reproducibility |

```mermaid
flowchart LR
    subgraph "mockCohort Parameters"
        P1["cdm<br/>(cdm_reference)"]
        P2["name<br/>(character)"]
        P3["numberCohorts<br/>(integer)"]
        P4["cohortName<br/>(character vector)"]
        P5["recordPerson<br/>(integer/vector)"]
        P6["seed<br/>(integer)"]
    end
    
    subgraph "Processing Steps"
        S1["checkInput()<br/>Validation"]
        S2["set.seed()<br/>Reproducibility"]
        S3["seq_len()<br/>Cohort IDs"]
        S4["sample()<br/>Subject Selection"]
        S5["addCohortDates()<br/>Date Generation"]
        S6["Overlap Resolution<br/>Date Adjustment"]
    end
    
    subgraph "Output Structure"
        O1["cohort_definition_id"]
        O2["subject_id"] 
        O3["cohort_start_date"]
        O4["cohort_end_date"]
    end
    
    P1 --> S1
    P2 --> S1
    P3 --> S3
    P4 --> S3
    P5 --> S4
    P6 --> S2
    
    S1 --> S2
    S2 --> S3
    S3 --> S4
    S4 --> S5
    S5 --> S6
    
    S6 --> O1
    S6 --> O2
    S6 --> O3
    S6 --> O4
```

Sources: [R/mockCohort.R:49-85](), [man/mockCohort.Rd:6-44]()

## Cohort Date Generation Process

The `addCohortDates()` helper function manages the assignment of cohort start and end dates within each patient's observation period constraints.

```mermaid
flowchart TD
    subgraph "Input Data"
        A["Subject IDs<br/>(subject_id)"]
        B["Observation Periods<br/>(observation_period)"]
    end
    
    subgraph "addCohortDates Function"
        C["obsDate2()<br/>Date Range Function"]
        D["runif()<br/>Random Generation"]
        E["Date Calculations<br/>(start + offset)"]
        F["Date Validation<br/>(pmax)"]
    end
    
    subgraph "Date Constraints"
        G["observation_period_start_date"]
        H["observation_period_end_date"]
        I["cohort_start_date ≤ cohort_end_date"]
        J["Dates within observation window"]
    end
    
    A --> C
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    F --> H
    F --> I
    F --> J
```

The date generation algorithm uses uniform random distribution to select start dates within observation periods, then generates end dates that fall between the start date and the observation period end:

Sources: [R/mockCohort.R:187-227]()

## Overlap Resolution and Data Quality

The cohort generation process includes sophisticated overlap resolution to ensure data quality and realistic cohort patterns.

```mermaid
flowchart TD
    subgraph "Raw Cohort Generation"
        A["Subject Sampling<br/>(sample with replacement)"]
        B["Date Assignment<br/>(addCohortDates)"]
        C["Initial Cohort Records"]
    end
    
    subgraph "Overlap Resolution Process"
        D["Sort by cohort_definition_id,<br/>subject_id, cohort_start_date"]
        E["Group by cohort_definition_id,<br/>subject_id"]
        F["Calculate next_observation<br/>(dplyr::lead)"]
        G["Adjust cohort_end_date<br/>(if_else logic)"]
        H["Remove invalid records<br/>(na.omit)"]
        I["Remove duplicates<br/>(distinct)"]
    end
    
    subgraph "Count Correction"
        J["Calculate target counts<br/>(numberRows / 1.2)"]
        K["Slice to target size<br/>(slice)"]
        L["Final cohort records"]
    end
    
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    I --> J
    J --> K
    K --> L
```

The overlap resolution ensures that within each cohort and subject combination, cohort periods do not overlap by adjusting end dates when necessary.

Sources: [R/mockCohort.R:118-165]()

## CDM Integration and Output Structure

The final integration step creates OMOP CDM-compliant cohort objects using the `omopgenerics` package standards.

```mermaid
flowchart LR
    subgraph "Processed Data"
        A["Cohort Records<br/>(tibble)"]
        B["Cohort Names<br/>(snakecase conversion)"]
    end
    
    subgraph "Metadata Creation"
        C["cohortSetTable<br/>(cohort_definition_id + cohort_name)"]
        D["cohortAttritionRef<br/>(from cohort attributes)"]
    end
    
    subgraph "CDM Integration"
        E["insertTable()<br/>(omopgenerics)"]
        F["newCohortTable()<br/>(omopgenerics)"]
        G["Updated CDM Reference"]
    end
    
    A --> E
    B --> C
    C --> F
    D --> F
    E --> F
    F --> G
```

The integration process creates both the main cohort table and the associated metadata tables required by OMOP CDM standards:

- **Cohort Table**: Contains `cohort_definition_id`, `subject_id`, `cohort_start_date`, `cohort_end_date`
- **Cohort Set Table**: Contains `cohort_definition_id` and `cohort_name` mappings
- **Cohort Attrition**: Tracks cohort creation metadata

Sources: [R/mockCohort.R:166-185]()

## Usage Examples and Testing

The cohort generation system supports multiple usage patterns, from simple single-cohort creation to complex multi-cohort scenarios.

**Basic Single Cohort**:
```r
cdm <- mockCdmReference() |>
  mockPerson(nPerson = 100) |>
  mockObservationPeriod() |>
  mockCohort()
```

**Multiple Named Cohorts**:
```r
cdm <- mockCdmReference() |>
  mockPerson(nPerson = 100) |>
  mockObservationPeriod() |>
  mockCohort(
    name = "omock_example",
    numberCohorts = 2,
    cohortName = c("omock_cohort_1", "omock_cohort_2")
  )
```

The testing suite validates functionality across multiple scales and configurations, including stress testing with up to 20,000 persons and seed-based reproducibility verification.

Sources: [vignettes/a02_Creating_synthetic_cohorts.Rmd:30-41](), [tests/testthat/test-mockCohort.R:1-74](), [man/mockCohort.Rd:57-69]()