# Page: Data Categorization

# Data Categorization

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/addCategories.R](R/addCategories.R)
- [man/addCategories.Rd](man/addCategories.Rd)
- [tests/testthat/test-addCategories.R](tests/testthat/test-addCategories.R)

</details>



## Purpose and Scope

The Data Categorization system provides functionality for converting continuous numeric and date variables into discrete categorical variables for analysis within OMOP CDM tables. This system is primarily implemented through the `addCategories` function, which transforms quantitative data into meaningful groups based on user-defined ranges and criteria.

This page covers the categorization of variables into predefined groups. For statistical summarization of categorized data, see [Data Summarization](#3.2). For demographic-specific categorization like age groups, see [Patient Demographics](#2.1).

## Core Architecture

The data categorization system is built around a single primary function that handles multiple data types and configuration options through a unified interface.

### System Components

```mermaid
graph TD
    subgraph "Input Processing"
        INPUT_TABLE["CDM Table (x)"]
        VARIABLE_SPEC["Variable Specification"]
        CATEGORY_DEF["Category Definitions"]
    end
    
    subgraph "addCategories Function"
        VALIDATION["Input Validation<br/>omopgenerics::assertClass<br/>validateColumn"]
        TYPE_DETECTION["Variable Type Detection<br/>dplyr::type_sum"]
        CATEGORY_PROCESSING["Category Processing<br/>categoryTibble creation"]
        OVERLAP_DETECTION["Overlap Detection<br/>detectOverlap"]
        QUERY_GENERATION["SQL Query Generation<br/>dplyr::case_when"]
    end
    
    subgraph "Output"
        CATEGORIZED_TABLE["Enhanced CDM Table<br/>+ Categorical Columns"]
    end
    
    INPUT_TABLE --> VALIDATION
    VARIABLE_SPEC --> VALIDATION
    CATEGORY_DEF --> VALIDATION
    
    VALIDATION --> TYPE_DETECTION
    TYPE_DETECTION --> CATEGORY_PROCESSING
    CATEGORY_PROCESSING --> OVERLAP_DETECTION
    OVERLAP_DETECTION --> QUERY_GENERATION
    
    QUERY_GENERATION --> CATEGORIZED_TABLE
```

Sources: [R/addCategories.R:48-174]()

## Category Definition System

Categories are defined using a hierarchical list structure where each category group contains named ranges with lower and upper bounds.

### Category Structure

```mermaid
graph LR
    subgraph "Category Input Format"
        CATEGORIES["categories parameter"]
        
        subgraph "Category Group Level"
            GROUP1["age_group"]
            GROUP2["severity_group"]
        end
        
        subgraph "Category Range Level"
            RANGE1["'0 to 39' = c(0, 39)"]
            RANGE2["'40 to 79' = c(40, 79)"]
            RANGE3["'mild' = c(1, 3)"]
            RANGE4["'severe' = c(4, 10)"]
        end
    end
    
    CATEGORIES --> GROUP1
    CATEGORIES --> GROUP2
    GROUP1 --> RANGE1
    GROUP1 --> RANGE2
    GROUP2 --> RANGE3
    GROUP2 --> RANGE4
```

### Category Validation and Processing

The system performs comprehensive validation of category definitions:

| Validation Check | Function | Purpose |
|------------------|----------|---------|
| Duplicate Names | [R/addCategories.R:65-68]() | Prevents naming conflicts |
| Bound Consistency | [R/addCategories.R:115-117]() | Ensures lower ≤ upper |
| Range Length | [R/addCategories.R:109-112]() | Validates two-element ranges |
| Column Conflicts | [R/addCategories.R:74]() | Prevents overwriting existing columns |

Sources: [R/addCategories.R:103-139]()

## Variable Type Handling

The system supports both numeric and date variables with specialized processing for each type.

### Date Variable Processing

```mermaid
flowchart TD
    subgraph "Date Processing Pipeline"
        DATE_INPUT["Date Variable Input"]
        TYPE_CHECK["Type Detection<br/>dplyr::type_sum"]
        DATE_CONVERSION["Date to Numeric Conversion<br/>CDMConnector::datediff"]
        CATEGORY_APPLY["Apply Numeric Categorization"]
        CLEANUP["Remove Temporary Columns"]
    end
    
    DATE_INPUT --> TYPE_CHECK
    TYPE_CHECK -->|"date"| DATE_CONVERSION
    DATE_CONVERSION --> CATEGORY_APPLY
    CATEGORY_APPLY --> CLEANUP
```

The date processing mechanism converts dates to numeric values representing days since a reference date, applies numeric categorization logic, then cleans up temporary columns.

Sources: [R/addCategories.R:85-100](), [R/addCategories.R:165-168]()

## Overlap Management

The system provides sophisticated handling of overlapping category ranges through automatic detection and resolution.

### Overlap Detection Algorithm

```mermaid
graph TB
    subgraph "detectOverlap Function"
        INPUT_GROUPS["Category Groups"]
        CREATE_TIBBLE["Create Range Tibble<br/>min/max pairs"]
        LEAD_CALCULATION["Calculate next_min<br/>dplyr::lead"]
        OVERLAP_CHECK["Check Overlap Condition<br/>next_min <= max"]
        RETURN_RESULT["Return Boolean"]
    end
    
    INPUT_GROUPS --> CREATE_TIBBLE
    CREATE_TIBBLE --> LEAD_CALCULATION
    LEAD_CALCULATION --> OVERLAP_CHECK
    OVERLAP_CHECK --> RETURN_RESULT
```

### Overlap Resolution Strategies

| Strategy | Parameter | Behavior |
|----------|-----------|----------|
| Strict Non-Overlap | `overlap = FALSE` | Error on detection |
| Automatic Resolution | `overlap = TRUE` | Create combined categories |
| Boundary Inclusion | `includeLowerBound`, `includeUpperBound` | Control boundary handling |

Sources: [R/addCategories.R:175-185](), [R/addCategories.R:202-223]()

## Query Generation and Execution

The categorization logic is implemented through dynamic SQL query generation using `dplyr::case_when` statements.

### Condition Generation

```mermaid
flowchart LR
    subgraph "condition Function Logic"
        BOUNDS_INPUT["Lower/Upper Bounds"]
        
        subgraph "Condition Types"
            BOTH_NA["Both NA: 'TRUE'"]
            LOWER_NA["Lower NA: variable <= upper"]
            UPPER_NA["Upper NA: lower <= variable"]
            BOTH_SET["Both Set: lower <= variable <= upper"]
        end
        
        SQL_FRAGMENT["Generated SQL Fragment"]
    end
    
    BOUNDS_INPUT --> BOTH_NA
    BOUNDS_INPUT --> LOWER_NA
    BOUNDS_INPUT --> UPPER_NA
    BOUNDS_INPUT --> BOTH_SET
    
    BOTH_NA --> SQL_FRAGMENT
    LOWER_NA --> SQL_FRAGMENT
    UPPER_NA --> SQL_FRAGMENT
    BOTH_SET --> SQL_FRAGMENT
```

The `condition` function handles various boundary scenarios including infinite values and missing bounds, generating appropriate SQL conditions for each case.

Sources: [R/addCategories.R:186-201](), [R/addCategories.R:142-164]()

## Missing Value Handling

The system provides flexible handling of values that don't fall into any defined category.

### Missing Value Options

| Parameter Value | Behavior | Use Case |
|-----------------|----------|----------|
| `"None"` (default) | Assign string "None" | Standard categorical analysis |
| `NA_character_` | Preserve as missing | Statistical procedures requiring NA |
| Custom string | User-defined label | Domain-specific labeling |

Sources: [R/addCategories.R:79-83](), [R/addCategories.R:154-156]()

## Category Name Generation

The system automatically generates descriptive names for categories when not explicitly provided.

### Automatic Naming Logic

```mermaid
graph TD
    subgraph "categoryName Function"
        INPUT_BOUNDS["Lower/Upper Bounds"]
        
        subgraph "Naming Rules"
            BOTH_NA["Both Infinite: 'any'"]
            LOWER_INF["Lower Infinite: 'X or below'"]
            UPPER_INF["Upper Infinite: 'X or above'"]
            BOTH_FINITE["Both Finite: 'X to Y'"]
        end
        
        DATE_FORMAT["Date Formatting<br/>as.Date conversion"]
        FINAL_NAME["Category Label"]
    end
    
    INPUT_BOUNDS --> BOTH_NA
    INPUT_BOUNDS --> LOWER_INF
    INPUT_BOUNDS --> UPPER_INF
    INPUT_BOUNDS --> BOTH_FINITE
    
    BOTH_NA --> DATE_FORMAT
    LOWER_INF --> DATE_FORMAT
    UPPER_INF --> DATE_FORMAT
    BOTH_FINITE --> DATE_FORMAT
    
    DATE_FORMAT --> FINAL_NAME
```

Sources: [R/addCategories.R:224-244](), [R/addCategories.R:124-127]()

## Integration Points

The categorization system integrates with other PatientProfiles components through standardized interfaces.

### System Dependencies

| Component | Relationship | Purpose |
|-----------|--------------|---------|
| `omopgenerics` | Input validation | CDM table validation and column checks |
| `CDMConnector` | Date processing | Database-specific date operations |
| `dplyr` | Query execution | SQL generation and table manipulation |
| Demographics functions | Data pipeline | Provides variables for categorization |

### Testing Infrastructure

The system includes comprehensive test coverage for various scenarios:

- Basic categorization functionality
- Overlap detection and resolution
- Infinite bound handling
- Date variable processing
- Missing value management
- Category naming

Sources: [tests/testthat/test-addCategories.R:1-171]()