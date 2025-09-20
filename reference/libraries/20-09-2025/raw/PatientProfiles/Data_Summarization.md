# Page: Data Summarization

# Data Summarization

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/formats.R](R/formats.R)
- [R/summariseResult.R](R/summariseResult.R)
- [R/sysdata.rda](R/sysdata.rda)
- [extras/addData.R](extras/addData.R)
- [extras/formats.csv](extras/formats.csv)
- [extras/formats_old.csv](extras/formats_old.csv)
- [tests/testthat/test-format.R](tests/testthat/test-format.R)
- [tests/testthat/test-summariseResult.R](tests/testthat/test-summariseResult.R)

</details>



The Data Summarization system provides comprehensive statistical analysis capabilities for patient data within the OMOP CDM framework. This system transforms raw patient tables into structured statistical summaries with support for grouping, stratification, and multiple estimate types. The core functionality centers around the `summariseResult()` function, which produces standardized `summarised_result` objects containing statistical estimates across different variable types.

For data categorization functionality, see [Data Categorization](#3.3). For intersection-based analysis, see [Data Intersection System](#3.1). For variable type definitions used in development, see [Variable Types and Statistical Estimates](#5.1).

## Core Architecture

The summarization system follows a multi-layered architecture that processes input tables through variable classification, statistical computation, and result formatting stages.

### System Overview

```mermaid
graph TB
    subgraph "Input Layer"
        INPUT_TABLE["Input Table<br/>CDM or Local Data"]
        USER_CONFIG["User Configuration<br/>groups, strata, variables, estimates"]
    end
    
    subgraph "Processing Core"
        VALIDATION["Input Validation<br/>checkTable, checkStrata"]
        VAR_CLASSIFY["Variable Classification<br/>variableTypes()"]
        ESTIMATE_VALIDATE["Estimate Validation<br/>checkVariablesFunctions()"]
    end
    
    subgraph "Computation Engine"
        SUMMARISE_INTERNAL["summariseInternal()"]
        COUNT_SUBJECTS["countSubjects()"]
        SUMMARISE_NUMERIC["summariseNumeric()"]
        SUMMARISE_BINARY["summariseBinary()"]
        SUMMARISE_CATEGORIES["summariseCategories()"]
        SUMMARISE_MISSINGS["summariseMissings()"]
    end
    
    subgraph "Output Layer"
        RESULT_FORMATTING["Result Formatting<br/>omopgenerics::newSummarisedResult()"]
        SUMMARISED_RESULT["summarised_result Object"]
    end
    
    INPUT_TABLE --> VALIDATION
    USER_CONFIG --> VALIDATION
    VALIDATION --> VAR_CLASSIFY
    VAR_CLASSIFY --> ESTIMATE_VALIDATE
    ESTIMATE_VALIDATE --> SUMMARISE_INTERNAL
    
    SUMMARISE_INTERNAL --> COUNT_SUBJECTS
    SUMMARISE_INTERNAL --> SUMMARISE_NUMERIC
    SUMMARISE_INTERNAL --> SUMMARISE_BINARY
    SUMMARISE_INTERNAL --> SUMMARISE_CATEGORIES
    SUMMARISE_INTERNAL --> SUMMARISE_MISSINGS
    
    COUNT_SUBJECTS --> RESULT_FORMATTING
    SUMMARISE_NUMERIC --> RESULT_FORMATTING
    SUMMARISE_BINARY --> RESULT_FORMATTING
    SUMMARISE_CATEGORIES --> RESULT_FORMATTING
    SUMMARISE_MISSINGS --> RESULT_FORMATTING
    
    RESULT_FORMATTING --> SUMMARISED_RESULT
```

Sources: [R/summariseResult.R:52-237](), [R/summariseResult.R:239-307]()

### Main Function Signature

The primary interface is the `summariseResult()` function with comprehensive configuration options:

| Parameter | Type | Description |
|-----------|------|-------------|
| `table` | Table | Input data (CDM table or local data frame) |
| `group` | List | Grouping variables for analysis |
| `includeOverallGroup` | Boolean | Include overall group results |
| `strata` | List | Stratification variables |
| `includeOverallStrata` | Boolean | Include overall strata results |
| `variables` | List/NULL | Variables to summarize (NULL = all non-ID columns) |
| `estimates` | List | Statistical estimates to compute |
| `counts` | Boolean | Whether to compute record/subject counts |
| `weights` | String/NULL | Column name for weighted estimates |

Sources: [R/summariseResult.R:52-60]()

## Variable Type Classification System

The summarization system uses a sophisticated variable type classification to determine appropriate statistical estimates for each column.

### Variable Type Hierarchy

```mermaid
graph TB
    subgraph "Variable Classification Process"
        INPUT_COL["Input Column"]
        TYPE_DETECT["dplyr::type_sum()"]
        ASSERT_CLASS["assertClassification()"]
    end
    
    subgraph "Supported Types"
        NUMERIC["numeric<br/>dbl, drtn"]
        INTEGER["integer<br/>int, int64"]
        DATE["date<br/>date, dttm"]
        CATEGORICAL["categorical<br/>chr, fct, ord"]
        LOGICAL["logical<br/>lgl"]
    end
    
    subgraph "Estimate Compatibility"
        NUM_EST["Numeric Estimates<br/>mean, sd, median, qXX<br/>min, max, sum, density"]
        INT_EST["Integer Estimates<br/>mean, sd, median, qXX<br/>min, max, sum, count, percentage"]
        DATE_EST["Date Estimates<br/>mean, sd, median, qXX<br/>min, max, density"]
        CAT_EST["Categorical Estimates<br/>count, percentage"]
        LOG_EST["Logical Estimates<br/>count, percentage"]
    end
    
    INPUT_COL --> TYPE_DETECT
    TYPE_DETECT --> ASSERT_CLASS
    
    ASSERT_CLASS --> NUMERIC
    ASSERT_CLASS --> INTEGER
    ASSERT_CLASS --> DATE
    ASSERT_CLASS --> CATEGORICAL
    ASSERT_CLASS --> LOGICAL
    
    NUMERIC --> NUM_EST
    INTEGER --> INT_EST
    DATE --> DATE_EST
    CATEGORICAL --> CAT_EST
    LOGICAL --> LOG_EST
```

Sources: [R/formats.R:37-58](), [R/formats.R:61-75]()

### Available Estimates by Type

The system maintains a comprehensive mapping of valid estimates for each variable type through the `availableEstimates()` function:

| Variable Type | Core Estimates | Special Features |
|---------------|----------------|------------------|
| **numeric** | mean, sd, median, qXX, min, max, sum | density plots, missing counts |
| **integer** | mean, sd, median, qXX, min, max, sum | binary detection (0/1), count/percentage |
| **date** | mean, sd, median, qXX, min, max | density plots, date formatting |
| **categorical** | count, percentage | level-wise statistics |
| **logical** | count, percentage | TRUE/FALSE counting |

Sources: [R/formats.R:97-146](), [extras/addData.R:9-15]()

## Statistical Computation Engine

The system processes different variable types through specialized computation functions, each optimized for specific statistical patterns.

### Computation Flow by Variable Type

```mermaid
flowchart LR
    subgraph "Input Processing"
        GROUPED_TABLE["Grouped Table<br/>by strata_id"]
        FUNCTIONS_MAP["functions<br/>variable_name -> estimate_name"]
    end
    
    subgraph "Computation Branches"
        NUMERIC_COMP["summariseNumeric()<br/>Quantiles, Moments, Density"]
        BINARY_COMP["summariseBinary()<br/>Count/Percentage for 0/1"]
        CATEGORY_COMP["summariseCategories()<br/>Level Counts/Percentages"]
        MISSING_COMP["summariseMissings()<br/>NA Count/Percentage"]
        COUNT_COMP["countSubjects()<br/>Record/Subject Counts"]
    end
    
    subgraph "Special Processing"
        DENSITY["densityResult()<br/>512-point density estimation"]
        WEIGHTS["Weight Support<br/>Hmisc::wtd.* functions"]
        COLLECT["Database Collection<br/>for complex estimates"]
    end
    
    GROUPED_TABLE --> NUMERIC_COMP
    GROUPED_TABLE --> BINARY_COMP
    GROUPED_TABLE --> CATEGORY_COMP
    GROUPED_TABLE --> MISSING_COMP
    GROUPED_TABLE --> COUNT_COMP
    
    FUNCTIONS_MAP --> NUMERIC_COMP
    FUNCTIONS_MAP --> BINARY_COMP
    FUNCTIONS_MAP --> CATEGORY_COMP
    FUNCTIONS_MAP --> MISSING_COMP
    
    NUMERIC_COMP --> DENSITY
    NUMERIC_COMP --> WEIGHTS
    BINARY_COMP --> WEIGHTS
    CATEGORY_COMP --> WEIGHTS
    
    NUMERIC_COMP --> COLLECT
```

Sources: [R/summariseResult.R:366-448](), [R/summariseResult.R:517-612](), [R/summariseResult.R:614-662]()

### Numeric Estimation Functions

The system uses predefined function mappings for statistical estimates, supporting both standard and weighted computations:

| Estimate | Standard Function | Weighted Function |
|----------|-------------------|-------------------|
| `mean` | `base::mean(x, na.rm = TRUE)` | `Hmisc::wtd.mean(x, weights, na.rm = TRUE)` |
| `median` | `stats::median(x, na.rm = TRUE)` | `Hmisc::wtd.quantile(x, weights, probs = 0.5)` |
| `sd` | `stats::sd(x, na.rm = TRUE)` | `sqrt(Hmisc::wtd.var(x, weights))` |
| `qXX` | `stats::quantile(x, 0.XX)` | `Hmisc::wtd.quantile(x, weights, probs = 0.XX)` |

Sources: [extras/addData.R:55-76]()

## Grouping and Stratification

The system supports hierarchical analysis through group and strata specifications, enabling complex multi-dimensional statistical breakdowns.

### Group-Strata Processing Architecture

```mermaid
graph TB
    subgraph "Configuration Input"
        GROUP_LIST["group = list(c('age_group', 'sex'))"]
        STRATA_LIST["strata = list('cohort_name')"]
        OVERALL_FLAGS["includeOverallGroup/Strata"]
    end
    
    subgraph "Processing Logic"
        CORRECT_STRATA["correctStrata()<br/>Add 'overall' combinations"]
        STRATA_GROUP["strataGroup<br/>Unique combinations table"]
        STRATA_ID["strata_id<br/>Row number assignment"]
    end
    
    subgraph "Result Structure"
        GROUP_COLS["group_name, group_level<br/>omopgenerics::uniteGroup()"]
        STRATA_COLS["strata_name, strata_level<br/>omopgenerics::uniteStrata()"]
        COMBINED_RESULTS["Combined Results<br/>All group-strata combinations"]
    end
    
    GROUP_LIST --> CORRECT_STRATA
    STRATA_LIST --> CORRECT_STRATA
    OVERALL_FLAGS --> CORRECT_STRATA
    
    CORRECT_STRATA --> STRATA_GROUP
    STRATA_GROUP --> STRATA_ID
    
    STRATA_ID --> GROUP_COLS
    STRATA_ID --> STRATA_COLS
    
    GROUP_COLS --> COMBINED_RESULTS
    STRATA_COLS --> COMBINED_RESULTS
```

Sources: [R/summariseResult.R:245-276](), [R/summariseResult.R:168-169]()

### Processing Loop Structure

The system processes all group-strata combinations systematically with progress tracking:

```mermaid
sequenceDiagram
    participant Main as summariseResult()
    participant Loop as Processing Loop
    participant Internal as summariseInternal()
    participant Progress as Progress Bar
    
    Main->>Progress: Initialize progress bar (nt combinations)
    Main->>Loop: For each group in groups
    Loop->>Loop: For each strata in stratas
    Loop->>Internal: Call summariseInternal(table, groupk, stratak)
    Internal-->>Loop: Return results for combination
    Loop->>Progress: Update progress (+1)
    Loop-->>Main: Accumulate results
    Main->>Main: Bind all results
```

Sources: [R/summariseResult.R:172-211]()

## Output Format and Structure

The system produces standardized `summarised_result` objects conforming to the `omopgenerics` package specifications.

### Result Schema

| Column | Description | Example Values |
|--------|-------------|----------------|
| `result_id` | Analysis identifier | `1` |
| `cdm_name` | CDM database name | `"mock"`, `"unknown"` |
| `group_name` | Grouping variable name | `"overall"`, `"age_group &&& sex"` |
| `group_level` | Grouping variable level | `"overall"`, `"18 to 65 &&& Female"` |
| `strata_name` | Stratification variable name | `"overall"`, `"cohort_name"` |
| `strata_level` | Stratification variable level | `"overall"`, `"cases"` |
| `variable_name` | Statistical variable name | `"age"`, `"number_records"` |
| `variable_level` | Variable level (categories) | `NA`, `"Male"`, `"density_001"` |
| `estimate_name` | Statistical estimate type | `"mean"`, `"count"`, `"percentage"` |
| `estimate_type` | Result data type | `"numeric"`, `"integer"`, `"percentage"` |
| `estimate_value` | Statistical result | `"45.2"`, `"150"`, `"23.5"` |
| `additional_name` | Additional grouping | `"overall"` |
| `additional_level` | Additional level | `"overall"` |

Sources: [R/summariseResult.R:218-234]()

### Settings Metadata

Each result includes comprehensive metadata about the analysis configuration:

| Setting | Description |
|---------|-------------|
| `result_type` | Always `"summarise_table"` |
| `package_name` | Always `"PatientProfiles"` |
| `package_version` | Version of PatientProfiles used |
| `weights` | Weight column name or `NULL` |

Sources: [R/summariseResult.R:227-233]()

## Performance and Database Optimization

The system includes sophisticated performance optimizations for both database and memory-based processing.

### Database vs Memory Processing

```mermaid
flowchart TD
    subgraph "Processing Decision Logic"
        CHECK_ESTIMATES["Check Required Estimates"]
        DETECT_DB_TYPE["Detect Database Type<br/>sourceType()"]
        COLLECT_FLAG["Set collectFlag"]
    end
    
    subgraph "Database Processing"
        DB_COMPATIBLE["Database-Compatible<br/>min, max, count, sum<br/>basic aggregations"]
        SQL_SERVER["SQL Server<br/>No quantile support"]
        OTHER_DB["Other Databases<br/>Limited quantile support"]
    end
    
    subgraph "Memory Processing"
        COLLECT_TABLE["collect() table"]
        COMPLEX_EST["Complex Estimates<br/>quantiles, median, density<br/>weighted statistics"]
        R_PROCESSING["R-based computation"]
    end
    
    CHECK_ESTIMATES --> DETECT_DB_TYPE
    DETECT_DB_TYPE --> COLLECT_FLAG
    
    COLLECT_FLAG --> DB_COMPATIBLE
    COLLECT_FLAG --> COLLECT_TABLE
    
    DB_COMPATIBLE --> SQL_SERVER
    DB_COMPATIBLE --> OTHER_DB
    
    COLLECT_TABLE --> COMPLEX_EST
    COMPLEX_EST --> R_PROCESSING
```

Sources: [R/summariseResult.R:136-154]()

### Optimization Strategies

The system employs several optimization techniques:

1. **Selective Column Processing**: Only required columns are selected for processing
2. **Progressive Collection**: Tables are collected only when necessary for complex estimates
3. **Batch Processing**: Multiple estimates computed in single database queries
4. **Type Conversion**: Dates and logicals converted to integers for database compatibility
5. **Memory Management**: Large tables processed in chunks when possible

Sources: [R/summariseResult.R:128-134](), [R/summariseResult.R:157-165]()

## Density Estimation

The system includes specialized functionality for generating density distributions of numeric variables.

### Density Computation Process

```mermaid
graph LR
    subgraph "Input Processing"
        NUMERIC_VAR["Numeric Variable"]
        WEIGHT_COL["Optional Weights"]
    end
    
    subgraph "Density Calculation"
        FILTER_NA["Filter NA values"]
        DENSITY_FUNC["stats::density(x, n=512)"]
        WEIGHTED_DENSITY["stats::density(x, weights=w)"]
    end
    
    subgraph "Output Format"
        DENSITY_X["density_x<br/>512 x-coordinates"]
        DENSITY_Y["density_y<br/>512 y-coordinates"]
        VARIABLE_LEVELS["variable_level<br/>density_001 to density_512"]
    end
    
    NUMERIC_VAR --> FILTER_NA
    WEIGHT_COL --> WEIGHTED_DENSITY
    FILTER_NA --> DENSITY_FUNC
    FILTER_NA --> WEIGHTED_DENSITY
    
    DENSITY_FUNC --> DENSITY_X
    WEIGHTED_DENSITY --> DENSITY_X
    DENSITY_FUNC --> DENSITY_Y
    WEIGHTED_DENSITY --> DENSITY_Y
    
    DENSITY_X --> VARIABLE_LEVELS
    DENSITY_Y --> VARIABLE_LEVELS
```

Sources: [R/summariseResult.R:478-515](), [R/summariseResult.R:419-445]()

The density estimation produces 512 coordinate pairs representing the probability density function, enabling detailed distribution analysis and visualization of patient characteristics.