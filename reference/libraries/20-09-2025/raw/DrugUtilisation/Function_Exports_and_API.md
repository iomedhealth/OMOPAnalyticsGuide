# Page: Function Exports and API

# Function Exports and API

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [man/reexports.Rd](man/reexports.Rd)

</details>



This document provides a comprehensive reference for the DrugUtilisation package's public API, including all exported functions, package dependencies, and the overall interface structure. This serves as a technical reference for developers integrating with the package and understanding its external interface.

For information about specific analysis workflows, see [Drug Utilisation Analysis](#5), [Specialized Analysis Functions](#6), and [Output and Visualization](#8). For details about the internal package structure and development tools, see [Testing and Mock Data](#9.2) and [Documentation and CI/CD](#9.3).

## Package Exports Overview

The DrugUtilisation package exports 57 functions organized into distinct functional categories that follow a consistent naming pattern and workflow design. The API is built around a cohort-centric approach where functions are categorized by their primary purpose in the drug utilization analysis pipeline.

### Function Categories

```mermaid
graph TB
    subgraph "Cohort Generation"
        generate1["generateDrugUtilisationCohortSet"]
        generate2["generateIngredientCohortSet"] 
        generate3["generateAtcCohortSet"]
    end
    
    subgraph "Cohort Refinement"
        require1["requirePriorDrugWashout"]
        require2["requireIsFirstDrugEntry"]
        require3["requireObservationBeforeDrug"]
        require4["requireDrugInDateRange"]
    end
    
    subgraph "Patient-Level Analysis (add*)"
        add1["addDrugUtilisation"]
        add2["addIndication"]
        add3["addTreatment"]
        add4["addDrugRestart"]
        add5["addCumulativeDose"]
        add6["addDaysExposed"]
        add7["addNumberEras"]
    end
    
    subgraph "Aggregate Analysis (summarise*)"
        summ1["summariseDrugUtilisation"]
        summ2["summariseIndication"]
        summ3["summariseTreatment"]
        summ4["summariseDrugRestart"]
        summ5["summariseDoseCoverage"]
    end
    
    subgraph "Output Generation"
        table1["tableDrugUtilisation"]
        plot1["plotDrugUtilisation"]
        table2["tableIndication"]
        plot2["plotIndication"]
    end
    
    subgraph "Utilities & Development"
        util1["mockDrugUtilisation"]
        util2["benchmarkDrugUtilisation"]
        util3["bind"]
        util4["suppress"]
        util5["erafyCohort"]
    end
    
    generate1 --> require1
    require1 --> add1
    add1 --> summ1
    summ1 --> table1
    summ1 --> plot1
```

Sources: [NAMESPACE:3-59]()

## Core Function Categories

### Cohort Generation Functions

The package exports four primary cohort generation functions that create the foundation for all downstream analysis:

| Function | Purpose | Primary Use Case |
|----------|---------|------------------|
| `generateDrugUtilisationCohortSet` | Creates cohorts from drug concept sets | Main entry point for drug cohort creation |
| `generateIngredientCohortSet` | Creates ingredient-based cohorts | Analysis by drug ingredient |
| `generateAtcCohortSet` | Creates ATC code-based cohorts | Therapeutic class analysis |

Sources: [NAMESPACE:26-28]()

### Patient-Level Analysis Functions (add*)

The `add*` family of functions enriches cohort tables with patient-level drug utilization metrics:

```mermaid
graph LR
    subgraph "Core Metrics"
        add1["addDrugUtilisation"]
        add2["addDaysExposed"]
        add3["addDaysPrescribed"]
        add4["addNumberEras"]
        add5["addNumberExposures"]
    end
    
    subgraph "Dose & Quantity"
        add6["addCumulativeDose"]
        add7["addCumulativeQuantity"]
        add8["addInitialDailyDose"]
        add9["addInitialQuantity"]
        add10["addInitialExposureDuration"]
    end
    
    subgraph "Specialized Analysis"
        add11["addIndication"]
        add12["addTreatment"]
        add13["addDrugRestart"]
        add14["addTimeToExposure"]
    end
    
    add1 --> add2
    add1 --> add3
    add1 --> add4
    add1 --> add5
```

Sources: [NAMESPACE:3-16]()

### Aggregate Analysis Functions (summarise*)

The `summarise*` family produces `summarised_result` objects with population-level statistics:

| Function | Output Type | Key Metrics |
|----------|-------------|-------------|
| `summariseDrugUtilisation` | summarised_result | Exposure counts, duration statistics |
| `summariseIndication` | summarised_result | Indication prevalence, unknown indications |
| `summariseTreatment` | summarised_result | Treatment patterns, concurrent use |
| `summariseDrugRestart` | summarised_result | Restart rates, time to restart |
| `summariseDoseCoverage` | summarised_result | Dose calculation coverage |
| `summariseProportionOfPatientsCovered` | summarised_result | Patient coverage over time |

Sources: [NAMESPACE:46-51]()

### Output Generation Functions

Table and plot generation functions follow consistent naming patterns:

```mermaid
graph TB
    subgraph "Table Functions (table*)"
        table1["tableDrugUtilisation"]
        table2["tableIndication"]
        table3["tableTreatment"]
        table4["tableDrugRestart"]
        table5["tableDoseCoverage"]
        table6["tableProportionOfPatientsCovered"]
    end
    
    subgraph "Plot Functions (plot*)"
        plot1["plotDrugUtilisation"]
        plot2["plotIndication"]
        plot3["plotTreatment"]
        plot4["plotDrugRestart"]
        plot5["plotProportionOfPatientsCovered"]
    end
    
    subgraph "Input: summarised_result objects"
        result1["summarised_result"]
    end
    
    result1 --> table1
    result1 --> table2
    result1 --> table3
    result1 --> table4
    result1 --> table5
    result1 --> table6
    
    result1 --> plot1
    result1 --> plot2
    result1 --> plot3
    result1 --> plot4
    result1 --> plot5
```

Sources: [NAMESPACE:34-38, 53-58]()

## Package Dependencies and Imports

### External Package Dependencies

The DrugUtilisation package imports functions from several key packages in the DARWIN EU ecosystem and broader R ecosystem:

```mermaid
graph TB
    subgraph "DrugUtilisation Package"
        MAIN["DrugUtilisation Functions"]
    end
    
    subgraph "DARWIN EU Ecosystem"
        OMOP["omopgenerics<br/>13 imported functions"]
        PP["PatientProfiles<br/>mockDisconnect"]
    end
    
    subgraph "Core R Packages"
        DPLYR["dplyr<br/>%>% pipe operator"]
        RLANG["rlang<br/>4 programming utilities"]
    end
    
    OMOP --> MAIN
    PP --> MAIN
    DPLYR --> MAIN
    RLANG --> MAIN
```

Sources: [NAMESPACE:60-78]()

### Imported Functions by Package

#### omopgenerics Imports

The package heavily relies on `omopgenerics` for standardized OMOP operations:

| Function | Purpose |
|----------|---------|
| `additionalColumns`, `groupColumns`, `strataColumns`, `settingsColumns` | Column management utilities |
| `cohortCodelist`, `cohortCount`, `attrition`, `settings` | Cohort metadata functions |
| `bind`, `suppress`, `tidy` | Result manipulation |
| `exportSummarisedResult`, `importSummarisedResult` | Result serialization |

Sources: [NAMESPACE:62-74]()

#### rlang Programming Utilities

Essential programming utilities from `rlang`:

| Symbol | Purpose |
|--------|---------|
| `%||%` | Null-coalescing operator |
| `:=` | Dynamic name assignment |
| `.data`, `.env` | Data masking utilities |

Sources: [NAMESPACE:75-78]()

## Re-exported Functions

The package re-exports 13 functions from other packages to provide a unified interface without requiring users to load multiple packages:

### omopgenerics Re-exports

```mermaid
graph LR
    subgraph "User Code"
        USER["DrugUtilisation::function()"]
    end
    
    subgraph "DrugUtilisation Package"
        REEXPORT["Re-exported Functions"]
    end
    
    subgraph "Source Packages"
        OMOP["omopgenerics::function()"]
        PP["PatientProfiles::mockDisconnect()"]
    end
    
    USER --> REEXPORT
    REEXPORT --> OMOP
    REEXPORT --> PP
```

The re-exported functions include:
- **Metadata access**: `cohortCount`, `settings`, `attrition`, `cohortCodelist`
- **Result manipulation**: `bind`, `suppress`, `tidy` 
- **Column utilities**: `groupColumns`, `strataColumns`, `additionalColumns`, `settingsColumns`
- **Data exchange**: `exportSummarisedResult`, `importSummarisedResult`
- **Development utilities**: `mockDisconnect`

Sources: [NAMESPACE:17-18, 20-25, 31, 43-45, 52, 59](), [man/reexports.Rd:6-19, 27-30]()

## API Design Patterns

### Naming Conventions

The package follows consistent naming patterns that reflect the function's role in the analysis pipeline:

| Pattern | Purpose | Examples |
|---------|---------|----------|
| `generate*` | Create cohorts from concept sets | `generateDrugUtilisationCohortSet` |
| `require*` | Apply inclusion/exclusion criteria | `requirePriorDrugWashout` |
| `add*` | Add patient-level metrics to cohorts | `addDrugUtilisation` |
| `summarise*` | Create population-level summaries | `summariseDrugUtilisation` |
| `table*` | Generate formatted tables | `tableDrugUtilisation` |
| `plot*` | Generate visualizations | `plotDrugUtilisation` |

### Function Return Types

The package API follows a consistent pattern for return types:

```mermaid
graph TB
    subgraph "Input Types"
        CDM["cdm_reference"]
        COHORT["cohort_table"]
        RESULT["summarised_result"]
    end
    
    subgraph "Function Categories"
        GEN["generate* functions"]
        REQ["require* functions"]
        ADD["add* functions"]
        SUM["summarise* functions"]
        TAB["table* functions"]
        PLOT["plot* functions"]
    end
    
    subgraph "Output Types"
        COHORT_OUT["cohort_table"]
        RESULT_OUT["summarised_result"]
        TABLE_OUT["gt_tbl / flextable"]
        PLOT_OUT["ggplot"]
    end
    
    CDM --> GEN
    COHORT --> REQ
    COHORT --> ADD
    COHORT --> SUM
    RESULT --> TAB
    RESULT --> PLOT
    
    GEN --> COHORT_OUT
    REQ --> COHORT_OUT
    ADD --> COHORT_OUT
    SUM --> RESULT_OUT
    TAB --> TABLE_OUT
    PLOT --> PLOT_OUT
```

Sources: [NAMESPACE:3-59]()

## Utility and Development Functions

### Development and Testing Functions

| Function | Purpose |
|----------|---------|
| `mockDrugUtilisation` | Generate mock CDM database for testing |
| `benchmarkDrugUtilisation` | Performance benchmarking utilities |
| `patternTable` | Drug strength pattern reference |

### Data Processing Utilities

| Function | Purpose |
|----------|---------|
| `erafyCohort` | Convert cohort exposures to eras |
| `cohortGapEra` | Handle gap calculations in eras |

Sources: [NAMESPACE:19, 24, 32-33]()