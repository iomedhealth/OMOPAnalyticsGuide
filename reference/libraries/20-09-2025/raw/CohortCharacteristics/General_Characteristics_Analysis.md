# Page: General Characteristics Analysis

# General Characteristics Analysis

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/summariseCharacteristics.R](R/summariseCharacteristics.R)
- [inst/doc/summarise_characteristics.html](inst/doc/summarise_characteristics.html)

</details>



General characteristics analysis provides comprehensive demographic and clinical profiling of cohorts in OMOP CDM databases. This analysis domain focuses on summarizing patient-level attributes, temporal relationships, and intersections with other clinical events to create detailed cohort profiles.

This document covers the `summariseCharacteristics` function and its associated visualization and table generation capabilities. For cohort attrition tracking, see [Cohort Attrition Analysis](#3.2). For subject overlap between cohorts, see [Cohort Overlap Analysis](#3.3).

## Core Analysis Workflow

General characteristics analysis follows the package's three-tier architecture pattern, providing a complete pipeline from data summarization to formatted output.

```mermaid
flowchart TD
    INPUT["cohort_table"]
    SUMMARISE["summariseCharacteristics()"]
    RESULT["summarised_result object"]
    PLOT["plotCharacteristics()"]
    TABLE["tableCharacteristics()"]
    VIZ["ggplot2 visualizations"]
    FORMATTED["Formatted tables (gt, flextable, etc.)"]
    
    INPUT --> SUMMARISE
    SUMMARISE --> RESULT
    RESULT --> PLOT
    RESULT --> TABLE
    PLOT --> VIZ
    TABLE --> FORMATTED
    
    SUMMARISE -.->|"Parameters"| PARAMS["demographics = TRUE<br/>counts = TRUE<br/>ageGroup = list()<br/>strata = list()<br/>*Intersect* = list()"]
```

The analysis begins with a cohort table and produces standardized `summarised_result` objects that can be visualized or formatted into tables. The `summariseCharacteristics` function serves as the primary entry point, accepting extensive configuration through its parameters.

Sources: [R/summariseCharacteristics.R:98-495](), [inst/doc/summarise_characteristics.html:394-495]()

## Analysis Capabilities

General characteristics analysis supports five major categories of patient profiling, each configurable through specific function parameters.

```mermaid
graph TB
    subgraph "Demographics Analysis"
        DEMO["demographics = TRUE"]
        AGE_GROUP["ageGroup = list(c(0,49), c(50,Inf))"]
        DEMO_VARS["Age, Sex, Prior/Future Observation<br/>Cohort Start/End Dates<br/>Days in Cohort"]
    end
    
    subgraph "Table Intersections"
        TABLE_FLAG["tableIntersectFlag"]
        TABLE_COUNT["tableIntersectCount"] 
        TABLE_DATE["tableIntersectDate"]
        TABLE_DAYS["tableIntersectDays"]
    end
    
    subgraph "Cohort Intersections"
        COHORT_FLAG["cohortIntersectFlag"]
        COHORT_COUNT["cohortIntersectCount"]
        COHORT_DATE["cohortIntersectDate"] 
        COHORT_DAYS["cohortIntersectDays"]
    end
    
    subgraph "Concept Intersections"
        CONCEPT_FLAG["conceptIntersectFlag"]
        CONCEPT_COUNT["conceptIntersectCount"]
        CONCEPT_DATE["conceptIntersectDate"]
        CONCEPT_DAYS["conceptIntersectDays"]
    end
    
    subgraph "Custom Analysis"
        OTHER_VARS["otherVariables = character()"]
        COUNTS["counts = TRUE"]
        STRATA["strata = list()"]
        ESTIMATES["estimates = list()"]
    end
    
    DEMO --> DEMO_VARS
    AGE_GROUP --> DEMO_VARS
```

### Demographics and Basic Characteristics

The `demographics = TRUE` parameter enables automatic inclusion of standard patient demographics through integration with `PatientProfiles::addDemographics`. This includes age, sex, prior observation time, future observation time, and cohort duration calculations.

### Intersection Analysis

Intersection parameters follow a consistent naming pattern: `{type}Intersect{value}` where `type` is "table", "cohort", or "concept" and `value` is "Flag", "Count", "Date", or "Days". Each intersection type analyzes relationships between the target cohort and other clinical entities within specified time windows.

Sources: [R/summariseCharacteristics.R:228-300](), [R/summariseCharacteristics.R:302-390]()

## Parameter Architecture and Data Flow

The function processes multiple parameter categories through a systematic pipeline that enriches the cohort table with additional variables before summarization.

```mermaid
flowchart LR
    subgraph "Input Validation"
        COHORT_ARG["validateCohortArgument()"]
        STRATA_ARG["validateStrataArgument()"]
        AGE_ARG["validateAgeGroupArgument()"]
    end
    
    subgraph "Variable Addition Pipeline"
        ADD_DEMO["PatientProfiles::addDemographics()"]
        ADD_INTERSECT["PatientProfiles::add*Intersect*()"]
        VARIABLE_TYPES["PatientProfiles::variableTypes()"]
    end
    
    subgraph "Summarization Engine"
        SUMMARISE_RESULT["PatientProfiles::summariseResult()"]
        VARIABLE_ESTIMATES["variablesEstimates()"]
    end
    
    subgraph "Output Processing"
        RENAME_VARS["Variable renaming via dic"]
        ORDER_RESULTS["getCombinations() ordering"]
        SR_OBJECT["newSummarisedResult()"]
    end
    
    COHORT_ARG --> ADD_DEMO
    STRATA_ARG --> SUMMARISE_RESULT
    AGE_ARG --> ADD_DEMO
    ADD_DEMO --> ADD_INTERSECT
    ADD_INTERSECT --> VARIABLE_TYPES
    VARIABLE_TYPES --> VARIABLE_ESTIMATES
    VARIABLE_ESTIMATES --> SUMMARISE_RESULT
    SUMMARISE_RESULT --> RENAME_VARS
    RENAME_VARS --> ORDER_RESULTS
    ORDER_RESULTS --> SR_OBJECT
```

The function maintains a data dictionary (`dic`) to track variable transformations and uses `uniqueVariableName()` to generate temporary column names during processing. This approach allows complex variable additions without naming conflicts.

Sources: [R/summariseCharacteristics.R:121-155](), [R/summariseCharacteristics.R:221-227](), [R/summariseCharacteristics.R:512-521]()

## Intersection Processing Architecture

Intersection parameters use a dynamic function calling approach where parameter names directly map to `PatientProfiles` functions, enabling flexible clinical event analysis.

```mermaid
graph TD
    subgraph "Intersection Types"
        TABLE["tableIntersect*"]
        COHORT["cohortIntersect*"] 
        CONCEPT["conceptIntersect*"]
    end
    
    subgraph "Function Mapping"
        PARSE["eval(parse(text = funName))"]
        FUNNAME["paste0('PatientProfiles::add', toupper(substr(intersect, 1, 1)), substr(intersect, 2, nchar(intersect)))"]
    end
    
    subgraph "Value Types"
        FLAG["Flag → binary variables"]
        COUNT["Count → numeric variables"] 
        DATE["Date → date variables"]
        DAYS["Days → numeric variables"]
    end
    
    subgraph "Dictionary Updates"
        DIC_UPDATE["dic union_all addDic"]
        SHORT_NAMES["uniqueVariableName()"]
        VARIABLE_UPDATE["updateVariables()"]
    end
    
    TABLE --> PARSE
    COHORT --> PARSE
    CONCEPT --> PARSE
    PARSE --> FUNNAME
    
    FLAG --> DIC_UPDATE
    COUNT --> DIC_UPDATE
    DATE --> DIC_UPDATE
    DAYS --> DIC_UPDATE
    
    DIC_UPDATE --> SHORT_NAMES
    SHORT_NAMES --> VARIABLE_UPDATE
```

Each intersection generates temporary variable names through `uniqueVariableName()` and updates the data dictionary with metadata including table names, time windows, and value types. The `getValue()` and `getType()` helper functions parse parameter names to determine the appropriate `PatientProfiles` function to call.

Sources: [R/summariseCharacteristics.R:309-390](), [R/summariseCharacteristics.R:522-532]()

## Estimates and Variable Type System

The function supports customizable statistical estimates based on variable types, with defaults provided for each data type category.

| Variable Type | Default Estimates |
|---------------|-------------------|
| `date` | min, q25, median, q75, max |
| `numeric` | min, q25, median, q75, max, mean, sd |
| `integer` | min, q25, median, q75, max, mean, sd |
| `categorical` | count, percentage |
| `binary` | count, percentage |

The `variablesEstimates()` function manages estimate assignment, allowing custom estimates through the `estimates` parameter while providing sensible defaults. Variable types are determined through `PatientProfiles::variableTypes()` for user-provided variables and explicitly assigned for generated intersection variables.

Sources: [R/summariseCharacteristics.R:561-618](), [R/summariseCharacteristics.R:392-402]()

## Output Structure and Ordering

Results follow the standardized `summarised_result` format with systematic ordering based on cohort names, strata combinations, and variable hierarchies.

```mermaid
flowchart TD
    subgraph "Result Ordering Pipeline"
        COMBINATIONS["getCombinations()"]
        STRATA_COMBO["getStratas(cohort, strata)"]
        AGE_ARRANGE["arrangeAgeGroup()"]
        ORDER_ID["order_id assignment"]
    end
    
    subgraph "Variable Renaming"
        DIC_JOIN["left_join with dic"]
        NAME_TRANSFORM["str_to_sentence(gsub('_', ' ', x))"]
        UNITE_ADDITIONAL["uniteAdditional()"]
    end
    
    subgraph "Final Structure" 
        SR_SETTINGS["srSet metadata"]
        NEW_SR["newSummarisedResult()"]
    end
    
    COMBINATIONS --> STRATA_COMBO
    STRATA_COMBO --> AGE_ARRANGE  
    AGE_ARRANGE --> ORDER_ID
    ORDER_ID --> DIC_JOIN
    DIC_JOIN --> NAME_TRANSFORM
    NAME_TRANSFORM --> UNITE_ADDITIONAL
    UNITE_ADDITIONAL --> NEW_SR
    SR_SETTINGS --> NEW_SR
```

Age group variables receive special ordering treatment through `arrangeAgeGroup()` to ensure logical progression of age categories. Variable names are transformed from snake_case to sentence case for improved readability in outputs.

Sources: [R/summariseCharacteristics.R:438-494](), [R/summariseCharacteristics.R:542-560]()