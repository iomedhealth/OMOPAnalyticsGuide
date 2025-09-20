# Page: Result Objects and Standards

# Result Objects and Standards

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [MD5](MD5)
- [NAMESPACE](NAMESPACE)

</details>



This document explains the standardized result objects produced by CohortCharacteristics analysis functions and the data standards that govern their structure and content. All analysis functions in the package follow the omopgenerics framework to ensure consistent output formats that can be seamlessly processed by visualization and table generation functions.

For information about the input data requirements and validation, see [Data Input and Validation](#2.1). For details about specific analysis workflows, see [Analysis Domains](#3).

## Summarised Result Object Framework

CohortCharacteristics follows the `omopgenerics` standard for result objects, where all analysis functions return `summarised_result` objects. This standardization ensures that results from different analysis types can be processed uniformly by downstream visualization and table functions.

```mermaid
graph TD
    subgraph "Analysis Functions"
        SC["summariseCharacteristics()"]
        SCA["summariseCohortAttrition()"]
        SCO["summariseCohortOverlap()"]
        SCT["summariseCohortTiming()"]
        SLSC["summariseLargeScaleCharacteristics()"]
    end
    
    subgraph "Standardized Output"
        SR["summarised_result object<br/>- result_id<br/>- cdm_name<br/>- group_name<br/>- group_level<br/>- strata_name<br/>- strata_level<br/>- variable_name<br/>- variable_level<br/>- estimate_name<br/>- estimate_type<br/>- estimate_value<br/>- additional_name<br/>- additional_level"]
        SETTINGS["settings attribute<br/>- function parameters<br/>- analysis metadata"]
    end
    
    subgraph "Processing Functions"
        PLOT["plotXXX() functions"]
        TABLE["tableXXX() functions"]
        UTILS["utility functions<br/>- settings()<br/>- suppress()<br/>- tidy()"]
    end
    
    SC --> SR
    SCA --> SR
    SCO --> SR
    SCT --> SR
    SLSC --> SR
    
    SR --> SETTINGS
    SR --> PLOT
    SR --> TABLE
    SR --> UTILS
```

Sources: [NAMESPACE:43-52](), [R/reexports.R]()

## Result Object Structure

The `summarised_result` object is a tibble with a standardized column structure that accommodates results from all analysis types. Each row represents a single estimate with associated grouping and stratification information.

### Core Columns

| Column | Type | Description |
|--------|------|-------------|
| `result_id` | integer | Unique identifier for the analysis run |
| `cdm_name` | character | Name of the CDM database |
| `group_name` | character | Grouping variable names (e.g., "cohort_name") |
| `group_level` | character | Grouping variable values |
| `strata_name` | character | Stratification variable names |
| `strata_level` | character | Stratification variable values |
| `variable_name` | character | Analysis variable name |
| `variable_level` | character | Analysis variable level/category |
| `estimate_name` | character | Type of estimate (e.g., "count", "percentage") |
| `estimate_type` | character | Data type of estimate ("numeric", "integer", "character") |
| `estimate_value` | character | The actual estimate value as character |
| `additional_name` | character | Additional metadata names |
| `additional_level` | character | Additional metadata values |

```mermaid
graph LR
    subgraph "Result Row Structure"
        ID["result_id: 1"]
        CDM["cdm_name: 'mock'"]
        GN["group_name: 'cohort_name'"]
        GL["group_level: 'cohort1'"]
        SN["strata_name: 'age_group &&& sex'"]
        SL["strata_level: '18 to 65 &&& Female'"]
        VN["variable_name: 'number subjects'"]
        VL["variable_level: NA"]
        EN["estimate_name: 'count'"]
        ET["estimate_type: 'integer'"]
        EV["estimate_value: '1234'"]
        AN["additional_name: 'window_name'"]
        AL["additional_level: '-365 to 0'"]
    end
```

Sources: [R/documentationHelpers.R](), [man/resultDoc.Rd]()

## Settings and Metadata Management

Each `summarised_result` object includes a `settings` attribute that stores the parameters and metadata from the analysis function call. This ensures reproducibility and provides context for interpreting results.

### Settings Structure

```mermaid
graph TB
    subgraph "Settings Components"
        RS["result_id"]
        RT["result_type"]
        PKG["package_name"]
        PV["package_version"]
        
        subgraph "Function Parameters"
            CP["cohortId"]
            WIN["windows"]
            AGE["ageGroup"]
            SEX["sex"]
            MIN["minCellCount"]
            OTHER["other function-specific parameters"]
        end
        
        subgraph "Analysis Context"
            AT["analysis_time"]
            DB["database_info"]
            VER["cdm_version"]
        end
    end
    
    RS --> RT
    RT --> PKG
    PKG --> PV
    PV --> CP
    CP --> WIN
    WIN --> AGE
    AGE --> SEX
    SEX --> MIN
    MIN --> OTHER
    OTHER --> AT
    AT --> DB
    DB --> VER
```

### Working with Settings

The package provides utility functions for accessing and manipulating settings:

- `settings()`: Extract settings from a `summarised_result` object
- `settingsColumns()`: Get column names that contain settings information  
- `groupColumns()`: Get column names used for grouping
- `strataColumns()`: Get column names used for stratification
- `additionalColumns()`: Get column names containing additional metadata

Sources: [NAMESPACE:48-52](), [R/reexports.R]()

## Result Standardization Across Analysis Types

Different analysis functions produce results with consistent structure but domain-specific content. The standardization occurs through common patterns in variable naming and estimate types.

### Analysis-Specific Result Patterns

```mermaid
graph TD
    subgraph "Characteristics Analysis"
        CHAR_VAR["variable_name:<br/>- 'Age'<br/>- 'Sex'<br/>- 'Prior observation'<br/>- intersection variables"]
        CHAR_EST["estimate_name:<br/>- 'count'<br/>- 'percentage'<br/>- 'mean'<br/>- 'sd'<br/>- 'median'<br/>- 'q25', 'q75'"]
    end
    
    subgraph "Attrition Analysis"
        ATTR_VAR["variable_name:<br/>- 'number_records'<br/>- 'number_subjects'<br/>- 'reason_id'<br/>- 'reason'"]
        ATTR_EST["estimate_name:<br/>- 'count'<br/>- 'percentage'"]
    end
    
    subgraph "Overlap Analysis"
        OVER_VAR["variable_name:<br/>- 'number_subjects'<br/>- cohort combinations"]
        OVER_EST["estimate_name:<br/>- 'count'<br/>- 'percentage'"]
    end
    
    subgraph "Timing Analysis"
        TIME_VAR["variable_name:<br/>- 'time_to_cohort'<br/>- timing statistics"]
        TIME_EST["estimate_name:<br/>- 'count'<br/>- 'median'<br/>- 'q25', 'q75'<br/>- 'min', 'max'"]
    end
    
    subgraph "Large Scale Analysis"
        LSC_VAR["variable_name:<br/>- concept names<br/>- concept frequencies"]
        LSC_EST["estimate_name:<br/>- 'count'<br/>- 'percentage'"]
    end
```

Sources: [R/summariseCharacteristics.R](), [R/summariseCohortAttrition.R](), [R/summariseCohortOverlap.R](), [R/summariseCohortTiming.R](), [R/summariseLargeScaleCharacteristics.R]()

## Result Processing and Manipulation

The package provides several functions for working with `summarised_result` objects, all re-exported from `omopgenerics` to maintain consistency with the broader OMOP ecosystem.

### Key Processing Functions

| Function | Purpose | Usage |
|----------|---------|-------|
| `bind()` | Combine multiple result objects | Merge results from different analyses |
| `suppress()` | Apply minimum cell count suppression | Hide results below threshold |
| `tidy()` | Clean and standardize results | Prepare for visualization/tables |
| `exportSummarisedResult()` | Export to file formats | Save results to CSV, JSON, etc. |
| `importSummarisedResult()` | Import from file formats | Load previously saved results |

### Result Validation and Quality Control

```mermaid
graph LR
    subgraph "Validation Pipeline"
        INPUT["Raw Analysis Results"]
        VALIDATE["omopgenerics validation<br/>- column structure<br/>- data types<br/>- required fields"]
        SUPPRESS["suppress()<br/>- minimum cell counts<br/>- privacy protection"]
        TIDY["tidy()<br/>- standardize formats<br/>- clean missing values"]
        OUTPUT["Validated summarised_result"]
    end
    
    INPUT --> VALIDATE
    VALIDATE --> SUPPRESS
    SUPPRESS --> TIDY
    TIDY --> OUTPUT
```

Sources: [NAMESPACE:43-52](), [R/reexports.R]()

## Integration with Visualization and Tables

The standardized result structure enables seamless integration with plotting and table functions. Each visualization or table function can rely on the consistent column structure to extract the necessary data for rendering.

```mermaid
graph TB
    subgraph "Result Object Flow"
        SR["summarised_result object"]
        SETTINGS_ATTR["settings attribute"]
        
        subgraph "Column Extraction"
            GROUP_COL["groupColumns()"]
            STRATA_COL["strataColumns()"] 
            ADD_COL["additionalColumns()"]
            AVAIL_PLOT["availablePlotColumns()"]
            AVAIL_TABLE["availableTableColumns()"]
        end
        
        subgraph "Output Generation"
            PLOT_FUNCS["plotXXX() functions"]
            TABLE_FUNCS["tableXXX() functions"]
        end
    end
    
    SR --> GROUP_COL
    SR --> STRATA_COL
    SR --> ADD_COL
    SETTINGS_ATTR --> AVAIL_PLOT
    SETTINGS_ATTR --> AVAIL_TABLE
    
    GROUP_COL --> PLOT_FUNCS
    STRATA_COL --> PLOT_FUNCS
    ADD_COL --> PLOT_FUNCS
    AVAIL_PLOT --> PLOT_FUNCS
    
    GROUP_COL --> TABLE_FUNCS
    STRATA_COL --> TABLE_FUNCS
    ADD_COL --> TABLE_FUNCS
    AVAIL_TABLE --> TABLE_FUNCS
```

Sources: [NAMESPACE:3-5](), [R/plot.R](), [R/table.R](), [man/availablePlotColumns.Rd](), [man/availableTableColumns.Rd]()