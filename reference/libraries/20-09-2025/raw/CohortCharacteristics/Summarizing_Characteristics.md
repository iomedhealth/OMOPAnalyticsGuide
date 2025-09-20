# Page: Summarizing Characteristics

# Summarizing Characteristics

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/summariseCharacteristics.R](R/summariseCharacteristics.R)
- [man/plotCohortAttrition.Rd](man/plotCohortAttrition.Rd)
- [man/summariseCharacteristics.Rd](man/summariseCharacteristics.Rd)
- [tests/testthat/test-summariseCharacteristics.R](tests/testthat/test-summariseCharacteristics.R)

</details>



This page documents the `summariseCharacteristics` function, which forms the core analysis engine for generating comprehensive statistical summaries of patient cohorts. This function implements the first stage of the package's three-tier analysis pattern (summarise → plot → table) and serves as the foundation for all subsequent visualization and reporting functionality.

For plotting these results, see [Plotting Characteristics](#3.1.2). For creating formatted tables, see [Characteristics Tables](#3.1.3).

## Function Overview

The `summariseCharacteristics` function analyzes cohort tables by computing statistical summaries across multiple variable types including demographics, intersections with other tables/cohorts/concepts, and custom variables. The function returns a standardized `summarised_result` object containing estimates organized by cohort, strata, and variable combinations.

## Core Function Architecture

```mermaid
flowchart TD
    subgraph "Input Layer"
        COHORT["cohort_table"]
        PARAMS["Function Parameters<br/>cohortId, strata, counts<br/>demographics, ageGroup<br/>intersect specifications"]
    end
    
    subgraph "Validation & Setup"
        VALIDATE["Input Validation<br/>validateCohortArgument<br/>validateCdmArgument<br/>validateStrataArgument"]
        SETTINGS["Result Settings<br/>srSet configuration<br/>package metadata"]
    end
    
    subgraph "Variable Processing"
        DEMO["Demographics Processing<br/>addDemographics<br/>age, sex, observation periods"]
        INTERSECT["Intersection Processing<br/>addTableIntersect*<br/>addCohortIntersect*<br/>addConceptIntersect*"]
        OTHER["Other Variables<br/>variableTypes analysis<br/>custom variable handling"]
        DICT["Variable Dictionary<br/>short_name mapping<br/>metadata tracking"]
    end
    
    subgraph "Summarization Engine"
        ESTIMATES["Estimate Assignment<br/>variablesEstimates<br/>default/custom estimates"]
        SUMMARISE["Statistical Computation<br/>summariseResult<br/>per-cohort processing"]
        FORMAT["Result Formatting<br/>variable renaming<br/>output structuring"]
    end
    
    subgraph "Output"
        RESULT["summarised_result<br/>standardized format<br/>settings metadata"]
    end
    
    COHORT --> VALIDATE
    PARAMS --> VALIDATE
    VALIDATE --> SETTINGS
    VALIDATE --> DEMO
    VALIDATE --> INTERSECT
    VALIDATE --> OTHER
    DEMO --> DICT
    INTERSECT --> DICT
    OTHER --> DICT
    DICT --> ESTIMATES
    ESTIMATES --> SUMMARISE
    SUMMARISE --> FORMAT
    FORMAT --> RESULT
    SETTINGS --> RESULT
```

**Sources:** [R/summariseCharacteristics.R:98-495]()

## Parameter Categories

The function accepts parameters organized into several functional categories:

| Category | Parameters | Purpose |
|----------|------------|---------|
| Core Control | `cohort`, `cohortId`, `strata` | Basic cohort selection and stratification |
| Basic Analysis | `counts`, `demographics`, `ageGroup` | Standard demographic and count summaries |
| Table Intersections | `tableIntersectFlag`, `tableIntersectCount`, `tableIntersectDate`, `tableIntersectDays` | Intersections with OMOP CDM tables |
| Cohort Intersections | `cohortIntersectFlag`, `cohortIntersectCount`, `cohortIntersectDate`, `cohortIntersectDays` | Intersections with other cohort tables |
| Concept Intersections | `conceptIntersectFlag`, `conceptIntersectCount`, `conceptIntersectDate`, `conceptIntersectDays` | Intersections with concept sets |
| Customization | `otherVariables`, `estimates`, `weights` | Custom variables and statistical specifications |

**Sources:** [R/summariseCharacteristics.R:98-119](), [man/summariseCharacteristics.Rd:32-100]()

## Intersection Processing Architecture

```mermaid
flowchart LR
    subgraph "Intersection Types"
        TABLE["Table Intersections<br/>tableIntersect*<br/>OMOP CDM tables"]
        COHORT["Cohort Intersections<br/>cohortIntersect*<br/>other cohort tables"]
        CONCEPT["Concept Intersections<br/>conceptIntersect*<br/>concept sets"]
    end
    
    subgraph "Intersection Values"
        FLAG["Flag (Binary)<br/>presence/absence"]
        COUNT["Count (Numeric)<br/>frequency counts"]
        DATE["Date<br/>temporal references"]
        DAYS["Days (Numeric)<br/>time differences"]
    end
    
    subgraph "PatientProfiles Functions"
        ADDTABLE["addTableIntersect*<br/>tableName, window"]
        ADDCOHORT["addCohortIntersect*<br/>targetCohortTable, window"]
        ADDCONCEPT["addConceptIntersect*<br/>conceptSet, window"]
    end
    
    subgraph "Processing Logic"
        LOOP["Intersection Loop<br/>for each intersect type<br/>for each specification"]
        VARS["Variable Registration<br/>uniqueVariableName<br/>dictionary updates"]
        CALL["Dynamic Function Call<br/>do.call(funName, val)"]
    end
    
    TABLE --> FLAG
    TABLE --> COUNT
    TABLE --> DATE
    TABLE --> DAYS
    COHORT --> FLAG
    COHORT --> COUNT
    COHORT --> DATE
    COHORT --> DAYS
    CONCEPT --> FLAG
    CONCEPT --> COUNT
    CONCEPT --> DATE
    CONCEPT --> DAYS
    
    FLAG --> ADDTABLE
    COUNT --> ADDTABLE
    DATE --> ADDTABLE
    DAYS --> ADDTABLE
    FLAG --> ADDCOHORT
    COUNT --> ADDCOHORT
    DATE --> ADDCOHORT
    DAYS --> ADDCOHORT
    FLAG --> ADDCONCEPT
    COUNT --> ADDCONCEPT
    DATE --> ADDCONCEPT
    DAYS --> ADDCONCEPT
    
    ADDTABLE --> LOOP
    ADDCOHORT --> LOOP
    ADDCONCEPT --> LOOP
    LOOP --> VARS
    VARS --> CALL
```

**Sources:** [R/summariseCharacteristics.R:302-389](), [R/summariseCharacteristics.R:522-541]()

## Variable Categorization System

The function implements a sophisticated variable type system that determines appropriate statistical estimates:

```mermaid
flowchart TD
    subgraph "Variable Type Detection"
        INPUT["Input Variables<br/>demographics, intersections<br/>otherVariables"]
        TYPES["variableTypes()<br/>PatientProfiles analysis"]
    end
    
    subgraph "Variable Categories"
        DATE["date<br/>cohort_start_date<br/>cohort_end_date<br/>intersection dates"]
        NUMERIC["numeric<br/>age, observation periods<br/>intersection counts/days"]
        INTEGER["integer<br/>integer-typed variables"]
        CATEGORICAL["categorical<br/>sex, age groups<br/>multi-level factors"]
        BINARY["binary<br/>intersection flags<br/>0/1 variables"]
        OTHER["other<br/>custom variables"]
    end
    
    subgraph "Default Estimates"
        DATE_EST["min, q25, median<br/>q75, max"]
        NUM_EST["min, q25, median<br/>q75, max, mean, sd"]
        INT_EST["min, q25, median<br/>q75, max, mean, sd"]
        CAT_EST["count, percentage"]
        BIN_EST["count, percentage"]
    end
    
    subgraph "Estimate Assignment"
        VAREST["variablesEstimates()<br/>custom + defaults<br/>variable mapping"]
        FINAL["Final Variables<br/>+ Estimates"]
    end
    
    INPUT --> TYPES
    TYPES --> DATE
    TYPES --> NUMERIC
    TYPES --> INTEGER
    TYPES --> CATEGORICAL
    TYPES --> BINARY
    TYPES --> OTHER
    
    DATE --> DATE_EST
    NUMERIC --> NUM_EST
    INTEGER --> INT_EST
    CATEGORICAL --> CAT_EST
    BINARY --> BIN_EST
    
    DATE_EST --> VAREST
    NUM_EST --> VAREST
    INT_EST --> VAREST
    CAT_EST --> VAREST
    BIN_EST --> VAREST
    
    VAREST --> FINAL
```

**Sources:** [R/summariseCharacteristics.R:392-402](), [R/summariseCharacteristics.R:561-618](), [R/summariseCharacteristics.R:593-599]()

## Demographics Processing Workflow

The demographics component adds standard patient characteristics using the PatientProfiles package:

```mermaid
flowchart LR
    subgraph "Demographics Configuration"
        DEMO_PARAMS["demographics = TRUE<br/>ageGroup specifications"]
        VAR_NAMES["Variable Names<br/>sex, age, priorObservation<br/>futureObservation, duration"]
    end
    
    subgraph "PatientProfiles Integration"
        ADD_DEMO["addDemographics()<br/>sex, age, observations<br/>ageGroup processing"]
        DURATION_CALC["Duration Calculation<br/>datediff + 1<br/>cohort_start to cohort_end"]
    end
    
    subgraph "Variable Registration"
        DEMO_DICT["Dictionary Updates<br/>short_name mappings<br/>new_variable_name"]
        VAR_TYPES["Variable Types<br/>date: cohort dates<br/>numeric: age, observations<br/>categorical: sex, age groups"]
    end
    
    DEMO_PARAMS --> ADD_DEMO
    VAR_NAMES --> ADD_DEMO
    ADD_DEMO --> DURATION_CALC
    DURATION_CALC --> DEMO_DICT
    DEMO_DICT --> VAR_TYPES
```

**Sources:** [R/summariseCharacteristics.R:228-300](), [R/summariseCharacteristics.R:282-299]()

## Result Processing and Output Structure

```mermaid
flowchart TD
    subgraph "Per-Cohort Processing"
        COHORT_LOOP["purrr::map(cohortId)<br/>individual cohort processing"]
        COLLECT["dplyr::collect()<br/>database materialization"]
        SUMMARISE_RESULT["summariseResult()<br/>statistical computation"]
    end
    
    subgraph "Result Assembly"
        BIND["omopgenerics::bind()<br/>combine cohort results"]
        CDM_NAME["cdm_name addition<br/>database identifier"]
        COMBINATIONS["getCombinations()<br/>ordering logic"]
    end
    
    subgraph "Variable Renaming"
        DICT_JOIN["Dictionary Join<br/>short_name → new_variable_name<br/>variable_level mapping"]
        SENTENCE_CASE["stringr::str_to_sentence<br/>underscore → space<br/>title case formatting"]
        UNITE_ADDITIONAL["uniteAdditional()<br/>additional columns<br/>metadata consolidation"]
    end
    
    subgraph "Final Output"
        RESULT_OBJ["newSummarisedResult<br/>standardized format<br/>settings attachment"]
    end
    
    COHORT_LOOP --> COLLECT
    COLLECT --> SUMMARISE_RESULT
    SUMMARISE_RESULT --> BIND
    BIND --> CDM_NAME
    CDM_NAME --> COMBINATIONS
    COMBINATIONS --> DICT_JOIN
    DICT_JOIN --> SENTENCE_CASE
    SENTENCE_CASE --> UNITE_ADDITIONAL
    UNITE_ADDITIONAL --> RESULT_OBJ
```

**Sources:** [R/summariseCharacteristics.R:409-434](), [R/summariseCharacteristics.R:437-494](), [R/summariseCharacteristics.R:462-490]()

## Integration Points

The function integrates tightly with several key package dependencies:

- **PatientProfiles**: Provides all `add*` functions for variable enrichment and the `summariseResult` engine
- **omopgenerics**: Supplies validation functions, result standardization, and CDM reference management  
- **CDMConnector**: Enables database connectivity and OMOP CDM table access
- **dplyr/tidyr**: Powers data manipulation and reshaping operations

The function serves as the primary entry point for characteristic analysis, with its output feeding directly into plotting and table generation functions in the package's three-tier architecture.

**Sources:** [R/summariseCharacteristics.R:121-146](), [R/summariseCharacteristics.R:420-430]()