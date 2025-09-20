# Page: Creating Tables

# Creating Tables

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/tables.R](R/tables.R)
- [tests/testthat/test-plotting.R](tests/testthat/test-plotting.R)
- [tests/testthat/test-tables.R](tests/testthat/test-tables.R)

</details>



This document covers the table generation functionality for incidence and prevalence analysis results in the IncidencePrevalence package. The system provides formatted tables in multiple output formats including GT, Flextable, and Tibble formats, with extensive customization options for headers, grouping, and styling.

For information about creating visualizations from results, see [Plotting Results](#7.1). For details about attrition-specific reporting, see [Attrition Reporting](#7.3).

## Table Generation System Architecture

The table generation system is built around the `visOmopResults` package integration and provides specialized formatting for epidemiological results.

```mermaid
graph TB
    subgraph "Input Sources"
        A["estimateIncidence()"]
        B["estimatePrevalence()"] 
        C["estimatePointPrevalence()"]
        D["estimatePeriodPrevalence()"]
    end
    
    subgraph "Core Table Functions"
        E["tableIncidence()"]
        F["tablePrevalence()"]
        G["tableIncidenceAttrition()"]
        H["tablePrevalenceAttrition()"]
    end
    
    subgraph "Internal Processing"
        I["tableInternal()"]
        J["defaultTableIncidencePrevalence()"]
        K["formatEstimateName"]
        L["visOmopResults::visOmopTable()"]
    end
    
    subgraph "Output Formats"
        M["GT Tables"]
        N["Flextable"]
        O["Tibble"]
    end
    
    subgraph "Configuration Systems"
        P["optionsTableIncidence()"]
        Q["optionsTablePrevalence()"]
        R["Header Configuration"]
        S["Grouping Configuration"]
    end
    
    A --> E
    B --> F
    C --> F
    D --> F
    
    A --> G
    B --> H
    C --> H
    D --> H
    
    E --> I
    F --> I
    G --> L
    H --> L
    
    I --> K
    I --> L
    K --> L
    
    L --> M
    L --> N
    L --> O
    
    P --> I
    Q --> I
    R --> L
    S --> L
```

Sources: [R/tables.R:1-426](), [tests/testthat/test-tables.R:1-177]()

## Main Table Functions

### Primary Table Functions

The package provides four main table generation functions, each specialized for different result types:

| Function | Purpose | Result Type Filter |
|----------|---------|-------------------|
| `tableIncidence()` | Format incidence analysis results | `result_type == "incidence"` |
| `tablePrevalence()` | Format prevalence analysis results | `result_type == "prevalence"` |
| `tableIncidenceAttrition()` | Format incidence attrition data | `result_type == "incidence_attrition"` |
| `tablePrevalenceAttrition()` | Format prevalence attrition data | `result_type == "prevalence_attrition"` |

### Function Signatures and Parameters

```mermaid
graph LR
    subgraph "tableIncidence() Parameters"
        A1["result"]
        A2["type = 'gt'"]
        A3["header = c('estimate_name')"]
        A4["groupColumn = c('cdm_name', 'outcome_cohort_name')"]
        A5["settingsColumn = c('denominator_age_group', 'denominator_sex')"]
        A6["hide = c('denominator_cohort_name', 'analysis_interval')"]
        A7["style = 'default'"]
        A8[".options = list()"]
    end
    
    subgraph "tablePrevalence() Parameters"
        B1["result"]
        B2["type = 'gt'"]
        B3["header = c('estimate_name')"]
        B4["groupColumn = c('cdm_name', 'outcome_cohort_name')"]
        B5["settingsColumn = c('denominator_age_group', 'denominator_sex')"]
        B6["hide = c('denominator_cohort_name', 'analysis_interval')"]
        B7["style = 'default'"]
        B8[".options = list()"]
    end
```

Sources: [R/tables.R:124-153](), [R/tables.R:56-84]()

## Table Configuration Options

### Output Format Types

The `type` parameter controls the output format:

- **`"gt"`** - Creates GT (Grammar of Tables) objects for HTML rendering
- **`"flextable"`** - Creates Flextable objects for Word/PowerPoint compatibility  
- **`"tibble"`** - Returns standard tibble data frames for programmatic use

### Header Configuration

The `header` parameter defines the hierarchical structure of table headers:

```mermaid
flowchart TD
    A["Header Configuration"] --> B["Available Variables"]
    B --> C["cdm_name"]
    B --> D["denominator_cohort_name"] 
    B --> E["outcome_cohort_name"]
    B --> F["incidence_start_date / prevalence_start_date"]
    B --> G["incidence_end_date / prevalence_end_date"]
    B --> H["estimate_name"]
    B --> I["strata_name variables"]
    B --> J["settingsColumn variables"]
    B --> K["custom header labels"]
    
    A --> L["Header Hierarchy"]
    L --> M["First element = topmost header"]
    L --> N["Order determines nesting level"]
    L --> O["Multiple elements create multi-level headers"]
```

Sources: [R/tables.R:21-27](), [R/tables.R:91-97]()

### Grouping and Column Management

| Parameter | Purpose | Example Values |
|-----------|---------|----------------|
| `groupColumn` | Variables for row grouping | `c("cdm_name", "outcome_cohort_name")` |
| `settingsColumn` | Settings attributes to display | `c("denominator_age_group", "denominator_sex")` |
| `hide` | Columns to exclude from output | `c("denominator_cohort_name", "analysis_interval")` |

## Estimate Name Formatting

### Incidence Table Formatting

The `tableIncidence()` function uses predefined estimate name formatting:

```mermaid
graph LR
    subgraph "Incidence Estimate Formatting"
        A["denominator_count"] --> A1["'Denominator (N)'"]
        B["person_years"] --> B1["'Person-years'"]  
        C["outcome_count"] --> C1["'Outcome (N)'"]
        D["incidence_100000_pys + CI"] --> D1["'Incidence 100,000 person-years [95% CI]'"]
    end
```

Sources: [R/tables.R:136-143]()

### Prevalence Table Formatting

The `tablePrevalence()` function uses its own formatting schema:

```mermaid
graph LR
    subgraph "Prevalence Estimate Formatting"
        A["denominator_count"] --> A1["'Denominator (N)'"]
        B["outcome_count"] --> B1["'Outcome (N)'"]
        C["prevalence + CI"] --> C1["'Prevalence [95% CI]'"]
    end
```

Sources: [R/tables.R:66-70]()

## Internal Processing Architecture

### Data Flow Through tableInternal()

```mermaid
sequenceDiagram
    participant User
    participant TableFunc as "tableIncidence()/tablePrevalence()"
    participant Internal as "tableInternal()"
    participant Validation as "Input Validation"
    participant Options as "defaultTableIncidencePrevalence()"
    participant VisOmop as "visOmopResults::visOmopTable()"
    
    User->>TableFunc: Call with parameters
    TableFunc->>Internal: Pass formatEstimateName & config
    Internal->>Validation: newSummarisedResult() & filterSettings()
    Validation-->>Internal: Validated result
    Internal->>Options: Get default .options
    Options-->>Internal: Merged options
    Internal->>VisOmop: visOmopTable() call
    VisOmop-->>Internal: Formatted table
    Internal-->>TableFunc: Return table
    TableFunc-->>User: Final table output
```

Sources: [R/tables.R:155-206]()

### Result Type Filtering

The system filters results by `result_type` to ensure appropriate data processing:

```mermaid
graph TB
    A["Input summarised_result"] --> B["omopgenerics::filterSettings()"]
    B --> C{"result_type check"}
    C -->|"incidence"| D["Process incidence data"]
    C -->|"prevalence"| E["Process prevalence data"] 
    C -->|"incidence_attrition"| F["Process incidence attrition"]
    C -->|"prevalence_attrition"| G["Process prevalence attrition"]
    C -->|"No matching type"| H["Return warning + empty table"]
    
    D --> I["Apply incidence formatting"]
    E --> J["Apply prevalence formatting"]
    F --> K["Apply attrition formatting"]
    G --> L["Apply attrition formatting"]
```

Sources: [R/tables.R:172-177](), [R/tables.R:309-317](), [R/tables.R:386-394]()

## Attrition Table Functions

### Attrition-Specific Processing

The attrition table functions handle specialized formatting for population attrition data:

```mermaid
graph LR
    subgraph "Attrition Table Features"
        A["variable_name formatting"] --> A1["stringr::str_to_sentence()"]
        A1 --> A2["gsub('_', ' ', variable_name)"]
        B["estimate formatting"] --> B1["'N' = '<count>'"]
        C["default hide columns"] --> C1["'reason_id', 'variable_level'"]
    end
```

Sources: [R/tables.R:320-321](), [R/tables.R:396-397](), [R/tables.R:325](), [R/tables.R:402]()

## Configuration Options and Defaults

### Options Functions

The package provides functions to retrieve default configuration options:

| Function | Purpose | Returns |
|----------|---------|---------|
| `optionsTableIncidence()` | Get incidence table defaults | Named list with `keepNotFormatted = FALSE` |
| `optionsTablePrevalence()` | Get prevalence table defaults | Named list with standard visOmopResults defaults |

### Option Merging Logic

```mermaid
flowchart TD
    A["User .options"] --> B["defaultTableIncidencePrevalence()"]
    C["visOmopResults::tableOptions()"] --> B
    D["Result Type Check"] --> B
    B --> E{"Is incidence?"}
    E -->|Yes| F["Set keepNotFormatted = FALSE"]
    E -->|No| G["Use standard defaults"]
    F --> H["Merge user options"]
    G --> H
    H --> I["Return final options"]
```

Sources: [R/tables.R:208-220](), [R/tables.R:238-240](), [R/tables.R:258-260]()

## Integration with visOmopResults

### visOmopTable() Integration

The table generation relies heavily on `visOmopResults::visOmopTable()` for core functionality:

```mermaid
graph TB
    subgraph "visOmopTable() Parameters"
        A["result = filtered_result"]
        B["estimateName = formatEstimateName"] 
        C["header = header"]
        D["groupColumn = groupColumn"]
        E["settingsColumn = settingsColumn"]
        F["type = type"]
        G["rename = c('Database name' = 'cdm_name')"]
        H["hide = hide + 'variable_name' + 'variable_level'"]
        I["style = style"]
        J[".options = merged_options"]
    end
    
    subgraph "Automatic Adjustments"
        K["Add 'variable_name', 'variable_level' to hide"]
        L["Filter 'outcome_cohort_name' from settingsColumn"]
        M["Convert groupColumn to list if needed"]
    end
    
    K --> H
    L --> E
    M --> D
```

Sources: [R/tables.R:194-205](), [R/tables.R:189-192]()

## Error Handling and Edge Cases

### Empty Result Handling

The system handles empty results gracefully:

```mermaid
flowchart TD
    A["Filter by result_type"] --> B{"nrow(result) == 0?"}
    B -->|Yes| C["cli::cli_warn()"]
    C --> D["Return visOmopTable() with empty result"]
    B -->|No| E["Continue normal processing"]
    
    F["emptyResultTable()"] --> G{"type check"}
    G -->|"gt"| H["gt::gt() with 'Table has no data'"]
    G -->|"flextable"| I["flextable::flextable() with message"]
    G -->|"tibble"| J["Empty tibble with message column"]
```

Sources: [R/tables.R:174-177](), [R/tables.R:314-317](), [R/tables.R:391-394](), [R/tables.R:415-425]()