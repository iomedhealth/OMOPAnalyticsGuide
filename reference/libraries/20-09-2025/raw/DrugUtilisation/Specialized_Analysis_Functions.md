# Page: Specialized Analysis Functions

# Specialized Analysis Functions

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [man/addIndication.Rd](man/addIndication.Rd)
- [man/summariseIndication.Rd](man/summariseIndication.Rd)
- [tests/testthat/test-indication.R](tests/testthat/test-indication.R)
- [tests/testthat/test-summariseTreatment.R](tests/testthat/test-summariseTreatment.R)

</details>



This document covers advanced analysis capabilities in the DrugUtilisation package for specific research questions beyond basic drug utilization metrics. These specialized functions enable investigation of drug indications, treatment patterns, restart behaviors, and patient coverage over time.

For basic drug utilization analysis (exposures, eras, doses), see [Drug Utilisation Analysis](#5). For cohort generation and filtering, see [Cohort Management](#4).

## Purpose and Scope

The specialized analysis functions extend the core drug utilization capabilities to address complex research questions:

- **Indication Analysis**: Determine medical reasons for drug use by linking to indication cohorts or clinical events
- **Treatment Analysis**: Analyze concurrent treatments and treatment sequences within specified time windows  
- **Drug Restart Analysis**: Track discontinuation and restart patterns with detailed follow-up
- **Patient Coverage Analysis**: Calculate proportion of patients covered over time for adherence assessment

These functions follow consistent patterns with `add*` functions for patient-level data enrichment and `summarise*` functions for population-level aggregation.

## Core Analysis Components

The specialized analysis system operates on refined cohorts and produces standardized results through modular analysis components:

```mermaid
graph TB
    subgraph "Input Data Sources"
        COHORT["cohort_table<br/>Drug cohorts"]
        IND_COHORT["indication cohorts<br/>Medical conditions"]
        TREAT_COHORT["treatment cohorts<br/>Concurrent drugs"]
        CLINICAL["clinical tables<br/>condition_occurrence<br/>drug_exposure<br/>observation"]
    end
    
    subgraph "Specialized Analysis Functions"
        ADD_IND["addIndication()<br/>Patient-level indications"]
        SUM_IND["summariseIndication()<br/>Indication summaries"]
        ADD_TREAT["addTreatment()<br/>Patient-level treatments"]
        SUM_TREAT["summariseTreatment()<br/>Treatment summaries"]
        ADD_RESTART["addDrugRestart()<br/>Patient-level restarts"]
        SUM_RESTART["summariseDrugRestart()<br/>Restart summaries"]
        SUM_COVERAGE["summariseProportionOfPatientsCovered()<br/>Coverage over time"]
    end
    
    subgraph "Analysis Parameters"
        WINDOWS["Time windows<br/>indicationWindow<br/>treatmentWindow"]
        INDEX["Index dates<br/>cohort_start_date<br/>custom dates"]
        EXCLUSIVE["Mutual exclusivity<br/>mutuallyExclusive"]
        STRATA["Stratification<br/>age_group, sex, etc"]
    end
    
    subgraph "Output Structures"
        ENRICHED["Enriched cohort_table<br/>Additional columns"]
        SUMMARY["summarised_result<br/>Population statistics"]
    end
    
    COHORT --> ADD_IND
    COHORT --> ADD_TREAT
    COHORT --> ADD_RESTART
    COHORT --> SUM_COVERAGE
    
    IND_COHORT --> ADD_IND
    TREAT_COHORT --> ADD_TREAT
    CLINICAL --> ADD_IND
    
    WINDOWS --> ADD_IND
    WINDOWS --> ADD_TREAT
    WINDOWS --> ADD_RESTART
    
    INDEX --> ADD_IND
    INDEX --> ADD_TREAT
    INDEX --> ADD_RESTART
    
    EXCLUSIVE --> ADD_IND
    EXCLUSIVE --> ADD_TREAT
    
    ADD_IND --> SUM_IND
    ADD_TREAT --> SUM_TREAT
    ADD_RESTART --> SUM_RESTART
    
    ADD_IND --> ENRICHED
    ADD_TREAT --> ENRICHED
    ADD_RESTART --> ENRICHED
    
    SUM_IND --> SUMMARY
    SUM_TREAT --> SUMMARY
    SUM_RESTART --> SUMMARY
    SUM_COVERAGE --> SUMMARY
    
    STRATA --> SUM_IND
    STRATA --> SUM_TREAT
    STRATA --> SUM_RESTART
    STRATA --> SUM_COVERAGE
```

Sources: [tests/testthat/test-indication.R:1-677](), [tests/testthat/test-summariseTreatment.R:1-71](), [man/addIndication.Rd:1-86](), [man/summariseIndication.Rd:1-88]()

## Function Pattern Architecture

All specialized analysis functions follow a consistent dual-pattern architecture with patient-level and population-level functions:

```mermaid
graph LR
    subgraph "Patient-Level Functions (add*)"
        ADD_PATTERN["add* Functions<br/>Input: cohort_table<br/>Output: enriched cohort_table"]
        ADD_IND_FUNC["addIndication()"]
        ADD_TREAT_FUNC["addTreatment()"]
        ADD_RESTART_FUNC["addDrugRestart()"]
    end
    
    subgraph "Population-Level Functions (summarise*)"
        SUM_PATTERN["summarise* Functions<br/>Input: cohort_table<br/>Output: summarised_result"]
        SUM_IND_FUNC["summariseIndication()"]
        SUM_TREAT_FUNC["summariseTreatment()"]
        SUM_RESTART_FUNC["summariseDrugRestart()"]
        SUM_COV_FUNC["summariseProportionOfPatientsCovered()"]
    end
    
    subgraph "Common Parameters"
        COHORT_PARAM["cohortId<br/>Target cohort selection"]
        WINDOW_PARAM["Window parameters<br/>indicationWindow<br/>treatmentWindow"]
        INDEX_PARAM["indexDate<br/>cohort_start_date (default)"]
        CENSOR_PARAM["censorDate<br/>Analysis end date"]
        MUTUAL_PARAM["mutuallyExclusive<br/>Category handling"]
        STRATA_PARAM["strata<br/>Stratification variables"]
    end
    
    ADD_PATTERN --> ADD_IND_FUNC
    ADD_PATTERN --> ADD_TREAT_FUNC
    ADD_PATTERN --> ADD_RESTART_FUNC
    
    SUM_PATTERN --> SUM_IND_FUNC
    SUM_PATTERN --> SUM_TREAT_FUNC
    SUM_PATTERN --> SUM_RESTART_FUNC
    SUM_PATTERN --> SUM_COV_FUNC
    
    COHORT_PARAM --> ADD_PATTERN
    COHORT_PARAM --> SUM_PATTERN
    
    WINDOW_PARAM --> ADD_PATTERN
    WINDOW_PARAM --> SUM_PATTERN
    
    INDEX_PARAM --> ADD_PATTERN
    INDEX_PARAM --> SUM_PATTERN
    
    CENSOR_PARAM --> ADD_PATTERN
    CENSOR_PARAM --> SUM_PATTERN
    
    MUTUAL_PARAM --> ADD_PATTERN
    
    STRATA_PARAM --> SUM_PATTERN
```

Sources: [man/addIndication.Rd:6-18](), [man/summariseIndication.Rd:6-18](), [tests/testthat/test-indication.R:65-100](), [tests/testthat/test-summariseTreatment.R:4-13]()

## Integration with Analysis Pipeline

The specialized analysis functions integrate seamlessly with the core DrugUtilisation pipeline, operating on refined cohorts and producing standardized outputs:

```mermaid
graph TB
    subgraph "Upstream Pipeline"
        COHORT_GEN["Cohort Generation<br/>generateDrugUtilisationCohortSet<br/>generateIngredientCohortSet"]
        COHORT_FILTER["Cohort Filtering<br/>requirePriorDrugWashout<br/>requireIsFirstDrugEntry"]
        REFINED_COHORT["Refined cohort_table<br/>Ready for analysis"]
    end
    
    subgraph "Specialized Analysis Layer"
        INDICATION_FLOW["Indication Analysis<br/>addIndication() → summariseIndication()"]
        TREATMENT_FLOW["Treatment Analysis<br/>addTreatment() → summariseTreatment()"]
        RESTART_FLOW["Restart Analysis<br/>addDrugRestart() → summariseDrugRestart()"]
        COVERAGE_FLOW["Coverage Analysis<br/>summariseProportionOfPatientsCovered()"]
    end
    
    subgraph "External Cohorts"
        IND_COHORTS["Indication Cohorts<br/>generateConceptCohortSet"]
        TREAT_COHORTS["Treatment Cohorts<br/>generateDrugUtilisationCohortSet"]
    end
    
    subgraph "Standardized Output"
        SUMMARY_RESULT["summarised_result objects<br/>Standard format for all analyses"]
        TABLE_OUTPUT["Table Generation<br/>tableIndication()<br/>tableTreatment()"]
        PLOT_OUTPUT["Plot Generation<br/>plotIndication()<br/>plotTreatment()"]
    end
    
    COHORT_GEN --> COHORT_FILTER
    COHORT_FILTER --> REFINED_COHORT
    
    REFINED_COHORT --> INDICATION_FLOW
    REFINED_COHORT --> TREATMENT_FLOW
    REFINED_COHORT --> RESTART_FLOW
    REFINED_COHORT --> COVERAGE_FLOW
    
    IND_COHORTS --> INDICATION_FLOW
    TREAT_COHORTS --> TREATMENT_FLOW
    
    INDICATION_FLOW --> SUMMARY_RESULT
    TREATMENT_FLOW --> SUMMARY_RESULT
    RESTART_FLOW --> SUMMARY_RESULT
    COVERAGE_FLOW --> SUMMARY_RESULT
    
    SUMMARY_RESULT --> TABLE_OUTPUT
    SUMMARY_RESULT --> PLOT_OUTPUT
```

Sources: [tests/testthat/test-indication.R:606-612](), [tests/testthat/test-summariseTreatment.R:15-26](), [man/summariseIndication.Rd:49-60]()

## Key Analysis Parameters

The specialized analysis functions share common parameter patterns that control their behavior:

| Parameter | Description | Functions | Example Values |
|-----------|-------------|-----------|----------------|
| `indicationWindow` | Time window for indication search | `addIndication`, `summariseIndication` | `list(c(0, 0), c(-30, 0), c(-Inf, 0))` |
| `treatmentWindow` | Time window for treatment analysis | `addTreatment`, `summariseTreatment` | `list(c(0, 30), c(31, 365))` |
| `unknownIndicationTable` | Clinical tables for unknown indications | `addIndication`, `summariseIndication` | `"condition_occurrence"` |
| `mutuallyExclusive` | Category exclusivity handling | `addIndication`, `addTreatment` | `TRUE` (default), `FALSE` |
| `indexDate` | Reference date for analysis | All functions | `"cohort_start_date"` (default) |
| `censorDate` | Analysis end date | All functions | `"cohort_end_date"`, custom column |
| `strata` | Stratification variables | `summarise*` functions | `list("age_group", "sex")` |

Sources: [man/addIndication.Rd:20-47](), [man/summariseIndication.Rd:20-47](), [tests/testthat/test-indication.R:313-325](), [tests/testthat/test-summariseTreatment.R:35-45]()

## Detailed Analysis Documentation

For comprehensive documentation of each specialized analysis type:

- **[Indication Analysis](#6.1)**: Medical indication identification using cohorts and clinical tables
- **[Treatment Analysis](#6.2)**: Concurrent treatment patterns and sequences  
- **[Drug Restart Analysis](#6.3)**: Discontinuation and restart pattern tracking
- **[Patient Coverage Analysis](#6.4)**: Treatment persistence and adherence assessment

Each subsection provides detailed parameter explanations, usage examples, and interpretation guidelines for the respective analysis type.