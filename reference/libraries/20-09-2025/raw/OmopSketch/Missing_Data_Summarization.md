# Page: Missing Data Summarization

# Missing Data Summarization

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/summariseInternal.R](R/summariseInternal.R)
- [R/summariseMissingData.R](R/summariseMissingData.R)
- [man/summariseConceptIdCounts.Rd](man/summariseConceptIdCounts.Rd)
- [man/summariseMissingData.Rd](man/summariseMissingData.Rd)
- [man/tableMissingData.Rd](man/tableMissingData.Rd)
- [tests/testthat/test-summariseMissingData.R](tests/testthat/test-summariseMissingData.R)

</details>



## Purpose and Scope

This page documents the missing data summarization functionality within OmopSketch. The system identifies and quantifies missing (NULL) and zero values in OMOP CDM tables, providing a comprehensive overview of data quality and completeness. For information about other types of summarization, see [Core Summarization Functions](#3).

The missing data summarization functions detect:
1. NULL values in any column of specified OMOP tables
2. Zero values in ID columns (which typically should be non-zero)

Results can be stratified by sex, age groups, and time intervals to identify patterns in data quality across different segments of the database.

Sources: [R/summariseMissingData.R:1-15]()

## System Overview

The missing data summarization system follows the consistent pattern used throughout OmopSketch, with specialized functions for analyzing data quality across OMOP tables.

```mermaid
graph TD
    A["CDM Reference"] --> B["summariseMissingData()"]
    B --> C["summarised_result Object"]
    C --> D["tableMissingData()"]
    D --> E["Formatted Table (gt or flextable)"]
    
    subgraph "Input Parameters"
        F["omopTableName"]
        G["col (columns to check)"]
        H["stratification options (sex, ageGroup, interval)"]
        I["dateRange"]
        J["sample size"]
    end
    
    F --> B
    G --> B
    H --> B
    I --> B
    J --> B
```

Sources: [R/summariseMissingData.R:28-107](), [man/summariseMissingData.Rd:6-17]()

## Internal Workflow

The missing data summarization process involves several steps to analyze and quantify NULL and zero values while supporting flexible stratification options.

```mermaid
flowchart TD
    A["summariseMissingData()"] --> B{"Process person\ntable separately?"}
    B -->|Yes| C["Process person table\n(no age/interval stratification)"]
    B -->|No| D["Continue with other tables"]
    
    C --> E["summariseMissingDataFromTable()"]
    D --> F["For each OMOP table"]
    F --> E
    
    E --> G["Check if table is empty"]
    G --> H["Identify columns\nto summarize"]
    H --> I["Restrict to study period"]
    I --> J["Sample if needed"]
    J --> K["Add stratifications\n(sex, age, time interval)"]
    K --> L["summariseMissingInternal()"]
    
    L --> M["Count NAs in all columns"]
    L --> N["Count zeros in ID columns"]
    M --> O["Calculate percentages"]
    N --> O
    
    O --> P["Format results"]
    P --> Q["Check for required fields\nwith missing values"]
    Q --> R["Return formatted results"]

    C --> S["Combine results"]
    R --> S
    
    S --> T["Format as\nsummarised_result object"]
```

Sources: [R/summariseMissingData.R:147-205](), [R/summariseInternal.R:31-124]()

## Key Components

### Main Function: summariseMissingData

The `summariseMissingData()` function identifies and quantifies missing values in one or more OMOP tables. It accepts the following parameters:

| Parameter | Description | Default |
|-|-|-|
| cdm | A CDM reference object | Required |
| omopTableName | Character vector of table names to analyze | Required |
| col | Columns to check for missing values (NULL = all columns) | NULL |
| sex | Whether to stratify by sex | FALSE |
| interval | Time interval for stratification ("overall", "years", "quarters", "months") | "overall" |
| ageGroup | Age group ranges for stratification | NULL |
| sample | Maximum number of records to process | 1,000,000 |
| dateRange | Study period restriction (vector of start and end dates) | NULL |

Special processing applies to the person table, as it cannot be stratified by age groups or time intervals.

Sources: [R/summariseMissingData.R:28-48](), [man/summariseMissingData.Rd:19-43]()

### Internal Processing Functions

The system uses several internal functions to process the data:

1. `summariseMissingDataFromTable()`: Processes a single OMOP table
   - Identifies columns to analyze
   - Applies date range restrictions
   - Samples if needed
   - Adds stratifications
   - Calls internal summarization functions

2. `summariseMissingInternal()`: Performs the actual summarization
   - Counts NULL values in all specified columns
   - Counts zero values in ID columns
   - Calculates percentages of missing/zero values
   - Formats results consistently

3. `warningDataRequire()`: Checks for missing values in required fields
   - Validates if mandatory columns contain NULL values
   - Issues warnings for fields that should not be NULL

Sources: [R/summariseMissingData.R:109-131](), [R/summariseMissingData.R:132-142](), [R/summariseMissingData.R:147-205](), [R/summariseInternal.R:31-124]()

## Stratification System

The missing data summarization supports flexible stratification to analyze data completeness patterns across different dimensions:

```mermaid
graph TD
    A["Stratification Options"] --> B["Sex Stratification"]
    A --> C["Age Group Stratification"]
    A --> D["Time Interval Stratification"]
    
    B --> B1["Male"]
    B --> B2["Female"]
    B --> B3["None"]
    
    C --> C1["User-defined age ranges\n(e.g., 0-17, 18-65, 66+)"]
    
    D --> D1["overall"]
    D --> D2["years"]
    D --> D3["quarters"]
    D --> D4["months"]
    
    E["Example Strata Combination"] --> E1["Female, 18-65, 2020-Q1"]
    E --> E2["Male, 0-17, 2019"]
    E --> E3["Overall (no stratification)"]
```

Stratification is applied by joining with the person table to retrieve demographic information and calculating the appropriate interval based on dates.

Sources: [R/summariseInternal.R:142-206](), [R/summariseInternal.R:248-250]()

## Output Structure

The function returns a `summarised_result` object with the following structure:

| Column | Description |
|-|-|
| group_name | Name of the OMOP table |
| group_level | The specific OMOP table name |
| strata_name | Stratification variables used (sex, age_group) |
| strata_level | Specific strata values (e.g., "Female; 18-65") |
| variable_name | Column name being analyzed |
| variable_level | Always NA for missing data summarization |
| estimate_name | Type of estimate (na_count, na_percentage, zero_count, zero_percentage) |
| estimate_type | Data type of the estimate (integer or percentage) |
| estimate_value | The actual value |
| additional_name | Additional stratification (time_interval) |
| additional_level | Specific time interval value |

The results include both counts and percentages of NULL values for each column, as well as counts and percentages of zero values for ID columns.

Sources: [R/summariseMissingData.R:89-106]()

## Table Generation

The `tableMissingData()` function converts the summarized result into a formatted table:

```mermaid
graph LR
    A["summariseMissingData() Result"] --> B["tableMissingData()"]
    B --> C{"Output Type"}
    C -->|"type='gt'"| D["GT Table"]
    C -->|"type='flextable'"| E["Flextable"]
    
    subgraph "Table Structure"
        F["Column Names"]
        G["NA Counts"]
        H["NA Percentages"]
        I["Zero Counts (ID columns)"]
        J["Zero Percentages (ID columns)"]
    end
```

The table displays the percentage of missing values for each column, with separate sections for each OMOP table analyzed. Stratification variables (if used) organize the data into subgroups.

Sources: [man/tableMissingData.Rd:1-20]()

## Usage Examples

Basic usage to check missing data in condition and visit occurrence tables:

```r
cdm <- mockOmopSketch(numberIndividuals = 100)
result <- summariseMissingData(cdm = cdm, 
                              omopTableName = c("condition_occurrence", "visit_occurrence"))
```

Example with stratification by sex, age groups, and years:

```r
result <- summariseMissingData(
  cdm = cdm,
  omopTableName = c("drug_exposure", "condition_occurrence"),
  interval = "years",
  sex = TRUE,
  ageGroup = list(c(0, 17), c(18, 65), c(66, 100)),
  dateRange = as.Date(c("2012-01-01", "2018-01-01")),
  sample = 100000
)
```

Creating a formatted table from the results:

```r
table <- tableMissingData(result)
```

Sources: [R/summariseMissingData.R:20-27](), [tests/testthat/test-summariseMissingData.R:434-461]()

## Integration with Other Components

The missing data summarization functionality integrates with the broader OmopSketch framework:

```mermaid
graph TD
    A["databaseCharacteristics()"] --> B["summariseMissingData()"]
    
    C["OmopSketch Package"] --> D["Data Summarization"]
    D --> E["summariseMissingData()"]
    
    E --> F["summarised_result"]
    F --> G["tableMissingData()"]
    F --> H["Custom Analysis"]
    
    I["Other Summarization Functions"] -.-> J["Standard Result Format"]
    E -.-> J
```

The missing data summarization is typically one component of a comprehensive database characterization, often used alongside other summarization functions to provide a complete picture of data quality and completeness.

Sources: [tests/testthat/test-summariseMissingData.R:1-19]()

## Performance Considerations

For large databases, the sample parameter is important to limit processing time and memory usage. The default sample size of 1,000,000 records provides a balance between accuracy and performance.

The function uses database-side processing where possible, minimizing data transfer between the database and R. Temporary tables are created during processing but are properly cleaned up when the function completes.

Sources: [R/summariseMissingData.R:125-141](), [tests/testthat/test-summariseMissingData.R:428-456]()