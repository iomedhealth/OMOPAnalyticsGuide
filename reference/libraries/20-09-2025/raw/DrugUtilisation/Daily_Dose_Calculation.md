# Page: Daily Dose Calculation

# Daily Dose Calculation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/dailyDose.R](R/dailyDose.R)
- [R/pattern.R](R/pattern.R)
- [R/sysdata.rda](R/sysdata.rda)
- [data-raw/internalData.R](data-raw/internalData.R)
- [extras/addInternalData.R](extras/addInternalData.R)
- [inst/pattern_assessment_for_dose_final.csv](inst/pattern_assessment_for_dose_final.csv)
- [man/patternTable.Rd](man/patternTable.Rd)
- [tests/testthat/test-dailyDose.R](tests/testthat/test-dailyDose.R)
- [vignettes/daily_dose_calculation.Rmd](vignettes/daily_dose_calculation.Rmd)
- [vignettes/drug_utilisation.Rmd](vignettes/drug_utilisation.Rmd)
- [vignettes/summarise_treatments.Rmd](vignettes/summarise_treatments.Rmd)

</details>



This section covers the comprehensive daily dose calculation system in the DrugUtilisation package. The system calculates standardized daily doses for drug ingredients using OMOP CDM drug strength patterns and formula-based approaches. For drug utilization analysis that incorporates daily dose, see [Drug Utilisation Analysis](#5). For general cohort management, see [Cohort Management](#4).

## System Overview

The daily dose calculation system operates at the ingredient level, transforming OMOP CDM drug exposure records into standardized daily dose measurements. The system uses a pattern-matching approach to identify appropriate calculation formulas based on drug strength table characteristics.

```mermaid
graph TB
    subgraph "Input Data"
        A["drug_exposure table"]
        B["drug_strength table"] 
        C["concept_ancestor table"]
        D["ingredient_concept_id"]
    end
    
    subgraph "Pattern Processing"
        E["drugStrengthPattern()"]
        F["Pattern Identification"]
        G["Formula Assignment"]
    end
    
    subgraph "Calculation Pipeline"
        H["standardUnits()"]
        I["applyFormula()"]
        J["Daily Dose Result"]
    end
    
    subgraph "Coverage Analysis"
        K["summariseDoseCoverage()"]
        L["patternTable()"]
    end
    
    A --> E
    B --> E
    C --> E
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    I --> J
    
    J --> K
    F --> L
```

**Daily Dose Calculation Flow**

Sources: [R/dailyDose.R:17-61](), [R/pattern.R:18-88](), [vignettes/daily_dose_calculation.Rmd:23-142]()

## Pattern-Based Formula Selection

The system identifies 128 distinct patterns from combinations of six drug strength variables, with 41 viable patterns covering 84% of drug-ingredient relationships. These patterns map to four calculation formulas.

```mermaid
graph LR
    subgraph "Drug Strength Variables"
        A1["amount_value"]
        A2["amount_unit_concept_id"]
        A3["numerator_value"]
        A4["numerator_unit_concept_id"]
        A5["denominator_value"] 
        A6["denominator_unit_concept_id"]
    end
    
    subgraph "Pattern Classification"
        B1["amount_numeric"]
        B2["numerator_numeric"]
        B3["denominator_numeric"]
        B4["Pattern ID"]
    end
    
    subgraph "Formula Assignment"
        C1["time based with denominator"]
        C2["time based no denominator"]
        C3["fixed amount formulation"]
        C4["concentration formulation"]
    end
    
    A1 --> B1
    A2 --> B1
    A3 --> B2
    A4 --> B2
    A5 --> B3
    A6 --> B3
    
    B1 --> B4
    B2 --> B4
    B3 --> B4
    
    B4 --> C1
    B4 --> C2
    B4 --> C3
    B4 --> C4
```

**Pattern to Formula Mapping Process**

| Pattern Type | Coverage | Formula | Key Variables |
|--------------|----------|---------|---------------|
| Time based with denominator | 8,044 (<1%) | `24 * numerator / denominator` (if >24h) or `numerator` (if ≤24h) | numerator_value, denominator_value |
| Time based no denominator | 5,611 (<1%) | `24 * numerator` | numerator_value |
| Fixed amount formulation | 1,102,435 (37%) | `quantity * amount / days_exposed` | amount_value, quantity |
| Concentration formulation | 1,398,518 (47%) | `quantity * numerator / days_exposed` | numerator_value, quantity |

Sources: [R/pattern.R:40-58](), [data-raw/internalData.R:94-99](), [inst/pattern_assessment_for_dose_final.csv:1-43]()

## Core Calculation Functions

### Pattern Identification

The `drugStrengthPattern()` function creates the foundation for dose calculations by linking drug concepts to their strength patterns and assigned formulas.

```mermaid
graph TD
    A["drugStrengthPattern()"] --> B["Filter by ingredientConceptId"]
    B --> C["Add Pattern Information"]
    C --> D["Join with patterns table"]
    D --> E["Select Required Columns"]
    
    E --> F["pattern_id"]
    E --> G["formula_name"]
    E --> H["unit"]
    E --> I["strength values"]
```

**Pattern Identification Process**

Sources: [R/pattern.R:18-88]()

### Unit Standardization

The `standardUnits()` function converts units to standard forms before formula application:

- Milligrams (9655) → Grams (÷1000)
- Liters (8519) → Milliliters (×1000)  
- Mega-international units (9439) → International units (÷1,000,000)

Sources: [R/dailyDose.R:182-202]()

### Formula Application

The `applyFormula()` function implements the four calculation formulas with comprehensive validation:

```mermaid
graph TD
    A["applyFormula()"] --> B{"Check Invalid Values"}
    B -->|"quantity ≤ 0"| C["Return NA"]
    B -->|"days_exposed ≤ 0"| C
    B -->|"strength values ≤ 0"| C
    
    B -->|"Valid"| D{"Formula Type"}
    
    D -->|"concentration"| E["numerator_value * quantity / days_exposed"]
    D -->|"fixed amount"| F["amount_value * quantity / days_exposed"]
    D -->|"time with denom"| G{"denominator > 24"}
    D -->|"time no denom"| H["numerator_value * 24"]
    
    G -->|"Yes"| I["numerator_value * 24 / denominator_value"]
    G -->|"No"| J["numerator_value"]
    
    E --> K["Daily Dose"]
    F --> K
    I --> K
    J --> K
    H --> K
```

**Formula Application Logic**

Sources: [R/dailyDose.R:203-232]()

## Implementation Architecture

### Main Daily Dose Addition

The `.addDailyDose()` function integrates all components to add daily dose information to drug exposure data:

```mermaid
graph LR
    subgraph "Input Processing"
        A["drugExposure table"]
        B["ingredientConceptId"]
        C["Calculate days_exposed"]
    end
    
    subgraph "Pattern Matching"
        D["drugStrengthPattern()"]
        E["Join by drug_concept_id"]
    end
    
    subgraph "Calculation"
        F["standardUnits()"]
        G["applyFormula()"]
        H["Select final columns"]
    end
    
    subgraph "Result Integration"
        I["Left join back to original"]
        J["Compute temporary table"]
        K["Return enhanced drugExposure"]
    end
    
    A --> C
    C --> E
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    A --> I
    I --> J
    J --> K
```

**Daily Dose Addition Workflow**

Sources: [R/dailyDose.R:17-61]()

### Pattern Analysis Functions

The system provides analysis tools for understanding pattern coverage:

| Function | Purpose | Key Output |
|----------|---------|------------|
| `patternTable()` | Analyze CDM pattern distribution | Pattern counts, validity assessment |
| `summariseDoseCoverage()` | Coverage statistics by ingredient | Missing dose rates, dose distributions |

Sources: [R/pattern.R:126-192](), [R/dailyDose.R:86-180]()

## Coverage Analysis System

### Dose Coverage Assessment

The `summariseDoseCoverage()` function provides comprehensive analysis of daily dose calculation coverage:

```mermaid
graph TD
    A["summariseDoseCoverage()"] --> B["Filter drug_exposure by ingredient"]
    B --> C["Join with drugStrengthPattern()"]
    C --> D["Apply standardUnits() & applyFormula()"]
    D --> E["Add route information"]
    E --> F["Sample if sampleSize specified"]
    F --> G["Summarise by strata"]
    
    subgraph "Stratification"
        H["Overall"]
        I["By unit"]
        J["By route + unit"]
        K["By route + unit + pattern"]
    end
    
    G --> H
    G --> I
    G --> J
    G --> K
    
    subgraph "Estimates"
        L["count_missing"]
        M["percentage_missing"]
        N["mean, median, quartiles"]
        O["standard deviation"]
    end
    
    H --> L
    I --> M
    J --> N
    K --> O
```

**Coverage Analysis Workflow**

The analysis includes route information through the `.addRoute()` function, which maps drug concepts to administration routes via dose form relationships.

Sources: [R/dailyDose.R:86-180](), [R/pattern.R:90-106]()

## Integration with Drug Utilization

Daily dose calculation integrates seamlessly with the broader drug utilization analysis system:

```mermaid
graph LR
    subgraph "Drug Utilization Functions"
        A["addDrugUtilisation()"]
        B["addInitialDailyDose()"]
        C["addCumulativeDose()"]
    end
    
    subgraph "Daily Dose System"
        D[".addDailyDose()"]
        E["Pattern Processing"]
        F["Formula Calculation"]
    end
    
    subgraph "Output Integration"
        G["Enhanced Drug Exposure"]
        H["Aggregated Results"]
        I["summarised_result objects"]
    end
    
    A --> D
    B --> D
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
```

**Integration with Drug Utilization Analysis**

The daily dose system supports both patient-level dose addition and aggregate dose summarization within the broader drug utilization framework. Daily dose calculations feed into comprehensive drug utilization metrics including initial doses, cumulative doses, and dose-based treatment characterization.

Sources: [R/dailyDose.R:17-61](), [vignettes/drug_utilisation.Rmd:134-139]()