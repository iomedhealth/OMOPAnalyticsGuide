# Page: Drug-Specific Code Generation

# Drug-Specific Code Generation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [CRAN-SUBMISSION](CRAN-SUBMISSION)
- [R/drugCodes.R](R/drugCodes.R)
- [R/getRoutes.R](R/getRoutes.R)
- [R/stratifyByRoute.R](R/stratifyByRoute.R)
- [R/subsetOnRouteCategory.R](R/subsetOnRouteCategory.R)
- [man/CodelistGenerator-package.Rd](man/CodelistGenerator-package.Rd)
- [man/getATCCodes.Rd](man/getATCCodes.Rd)
- [man/getDrugIngredientCodes.Rd](man/getDrugIngredientCodes.Rd)
- [tests/testthat/test-dbms.R](tests/testthat/test-dbms.R)
- [tests/testthat/test-drugCodes.R](tests/testthat/test-drugCodes.R)

</details>



This page documents the drug-specific code generation functionality in CodelistGenerator, covering the generation of drug ingredient codes, ATC (Anatomical Therapeutic Chemical) classification codes, and drug-related filtering and stratification capabilities. These functions provide specialized tools for working with pharmaceutical concepts in OMOP CDM vocabularies.

For general concept searching across all domains, see [Candidate Code Search](#2.1). For ICD-10 and other non-drug vocabularies, see [ICD-10 and Other Standards](#2.3).

## Core Drug Functions Overview

The drug-specific functionality is centered around two primary generation functions and several supporting utilities for filtering and stratification:

```mermaid
graph TD
    subgraph "Input Types"
        IN1["Drug Ingredient Names<br/>e.g., 'metformin', 'adalimumab'"]
        IN2["Drug Ingredient IDs<br/>e.g., 1503297, 1125315"]
        IN3["ATC Names<br/>e.g., 'Alimentary Tract and Metabolism'"]
        IN4["ATC Levels<br/>e.g., 'ATC 1st', 'ATC 2nd'"]
    end
    
    subgraph "Core Generation Functions"
        GDI["getDrugIngredientCodes()"]
        GATC["getATCCodes()"]
    end
    
    subgraph "Filter Parameters"
        DF["doseForm"]
        DU["doseUnit"] 
        RC["routeCategory"]
        IR["ingredientRange"]
    end
    
    subgraph "Supporting Functions"
        GRC["getRouteCategories()"]
        SRC["subsetOnRouteCategory()"]
        STRC["stratifyByRouteCategory()"]
        SDU["subsetOnDoseUnit()"]
        STDU["stratifyByDoseUnit()"]
    end
    
    subgraph "Output Types"
        CL["codelist"]
        CLD["codelist_with_details"]
    end
    
    IN1 --> GDI
    IN2 --> GDI
    IN3 --> GATC
    IN4 --> GATC
    
    DF --> GDI
    DU --> GDI
    RC --> GDI
    IR --> GDI
    
    DF --> GATC
    DU --> GATC  
    RC --> GATC
    
    GDI --> CL
    GDI --> CLD
    GATC --> CL
    GATC --> CLD
    
    GRC --> RC
    SRC --> CL
    STRC --> CL
    SDU --> CL
    STDU --> CL
```

**Sources:** [R/drugCodes.R:39-148](), [R/drugCodes.R:173-299](), [R/getRoutes.R:39-68](), [R/stratifyByRoute.R:37-141](), [R/subsetOnRouteCategory.R:40-116]()

## ATC Code Generation

The `getATCCodes()` function generates codelists based on Anatomical Therapeutic Chemical (ATC) classification codes, which provide a hierarchical classification system for drugs.

### Function Signature and Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `cdm` | cdm_reference | OMOP CDM database connection | Required |
| `level` | character | ATC classification level | `"ATC 1st"`, `"ATC 2nd"` |
| `name` | character | ATC group name to search | `"Alimentary Tract and Metabolism"` |
| `nameStyle` | character | Output naming pattern | `"{concept_code}_{concept_name}"` |
| `doseForm` | character | Dose form filter | `"injection"`, `"tablet"` |
| `doseUnit` | character | Dose unit filter | `"milligram"`, `"microgram"` |
| `routeCategory` | character | Route category filter | `"oral"`, `"injectable"` |
| `type` | character | Output format | `"codelist"`, `"codelist_with_details"` |

### Implementation Flow

```mermaid
graph TD
    START["getATCCodes() called"]
    VALID["Input validation<br/>omopgenerics::validateCdmArgument()"]
    FILTER1["Filter concept table<br/>vocabulary_id == 'ATC'<br/>concept_class_id %in% level"]
    FILTER2["Apply name filter if provided<br/>tidyWords() matching"]
    BATCH["fetchBatchedDescendants()<br/>batchSize = 500"]
    RESHAPE["Reshape ancestor data<br/>tidyr::separate_wider_delim()"]
    JOIN["Join with ATC concepts<br/>Apply nameStyle formatting"]
    SPLIT["Split by name factor<br/>Create codelist structure"]
    ROUTE["Apply routeCategory filter<br/>subsetOnRouteCategory()"]
    DOSE["Apply doseUnit filter<br/>subsetOnDoseUnit()"]
    RETURN["Return formatted codelist"]
    
    START --> VALID
    VALID --> FILTER1
    FILTER1 --> FILTER2
    FILTER2 --> BATCH
    BATCH --> RESHAPE
    RESHAPE --> JOIN
    JOIN --> SPLIT
    SPLIT --> ROUTE
    ROUTE --> DOSE
    DOSE --> RETURN
```

**Sources:** [R/drugCodes.R:39-148](), [R/drugCodes.R:311-341]()

## Drug Ingredient Code Generation

The `getDrugIngredientCodes()` function is the primary tool for generating codelists based on drug ingredients, supporting both name-based and concept ID-based searches.

### Input Flexibility

The function accepts multiple input formats for specifying ingredients:

| Input Type | Example | Usage |
|------------|---------|--------|
| Character names | `c("metformin", "adalimumab")` | Most common approach |
| Numeric concept IDs | `c(1503297, 1125315)` | Direct concept ID specification |
| Mixed inputs | Not supported | Use one type per call |

### Ingredient Range Filtering

The `ingredientRange` parameter controls the number of active ingredients in returned drug concepts:

| Range | Description | Use Case |
|-------|-------------|----------|
| `c(1, 1)` | Monotherapy only | Single-ingredient drugs |
| `c(2, Inf)` | Combination therapy | Multi-ingredient formulations |
| `c(1, Inf)` | All drugs (default) | No ingredient count restriction |

### Processing Pipeline

```mermaid
graph TD
    INPUT["Input: name or concept_id"]
    VALIDATE["Validation<br/>checkNameStyle()<br/>assertNumeric()"]
    FILTER_ING["Filter ingredient concepts<br/>standard_concept == 'S'<br/>concept_class_id == 'Ingredient'"]
    APPLY_NAME["filterIngredientConcepts()<br/>Name or ID matching"]
    BATCH_DESC["fetchBatchedDescendants()<br/>Progress bar tracking"]
    INGREDIENT_FILTER["Apply ingredientRange<br/>Filter by drug complexity"]
    RESHAPE_DATA["Reshape ancestor relationships<br/>separate_wider_delim() + pivot_longer()"]
    NAME_FORMAT["Apply nameStyle formatting<br/>glue::glue() templating"]
    TYPE_SPLIT["Split by output type<br/>codelist vs codelist_with_details"]
    FILTER_ROUTE["Apply route filtering<br/>subsetOnRouteCategory()"]
    FILTER_DOSE["Apply dose filtering<br/>subsetOnDoseUnit()"]
    RESULT["Return formatted result"]
    
    INPUT --> VALIDATE
    VALIDATE --> FILTER_ING
    FILTER_ING --> APPLY_NAME
    APPLY_NAME --> BATCH_DESC
    BATCH_DESC --> INGREDIENT_FILTER
    INGREDIENT_FILTER --> RESHAPE_DATA
    RESHAPE_DATA --> NAME_FORMAT
    NAME_FORMAT --> TYPE_SPLIT
    TYPE_SPLIT --> FILTER_ROUTE
    FILTER_ROUTE --> FILTER_DOSE
    FILTER_DOSE --> RESULT
```

**Sources:** [R/drugCodes.R:173-299](), [R/drugCodes.R:301-309]()

## Route Category Management

Route categories classify drugs by their administration route based on dose form mappings. The system uses a predefined lookup table `doseFormToRoute` to categorize concepts.

### Available Route Functions

| Function | Purpose | Return Type |
|----------|---------|-------------|
| `getRouteCategories()` | List available routes in database | character vector |
| `subsetOnRouteCategory()` | Filter codelist by route | codelist |
| `stratifyByRouteCategory()` | Split codelist by route | named codelist |

### Route Classification Process

```mermaid
graph TD
    CONCEPT["Drug Concepts"]
    REL["concept_relationship table<br/>relationship_id == 'RxNorm has dose form'"]
    LOOKUP["doseFormToRoute lookup table"]
    CLASSIFY["Route classification<br/>NA -> 'unclassified_route'"]
    RESULT["Categorized concepts"]
    
    CONCEPT --> REL
    REL --> LOOKUP
    LOOKUP --> CLASSIFY
    CLASSIFY --> RESULT
    
    subgraph "Route Categories (Examples)"
        ORAL["oral"]
        INJECT["injectable"] 
        TOPICAL["topical"]
        UNCLASS["unclassified_route"]
    end
```

### Route Stratification Example

The `stratifyByRouteCategory()` function transforms a single codelist into multiple route-specific codelists:

```
Input:  list("drug_name" = c(1001, 1002, 1003))
Output: list(
  "drug_name_oral" = c(1001, 1003),
  "drug_name_injectable" = c(1002)
)
```

**Sources:** [R/getRoutes.R:39-68](), [R/stratifyByRoute.R:37-141](), [R/subsetOnRouteCategory.R:40-116]()

## Dose Form and Unit Filtering

Both ATC and ingredient code generation support filtering by dose forms and units, enabling precise therapeutic focus.

### Dose Form Integration

Dose forms are linked to drug concepts via the `concept_relationship` table using the `"RxNorm has dose form"` relationship. Common dose forms include:

- `"injection"`
- `"tablet"` 
- `"capsule"`
- `"topical"`

### Filtering Workflow

The dose form and unit filtering occurs at two stages:

1. **During Generation**: Applied in `fetchBatchedDescendants()` via the `doseForm` parameter
2. **Post-Generation**: Applied via `subsetOnDoseUnit()` and `subsetOnRouteCategory()`

**Sources:** [R/drugCodes.R:311-341](), [tests/testthat/test-drugCodes.R:77-90]()

## Implementation Details

### Batched Processing

Large concept sets are processed in batches to prevent memory issues:

```mermaid
graph LR
    CONCEPTS["Large concept set<br/>e.g., 2000 ingredients"]
    SPLIT["split(codes, ceiling(seq_along(codes) / 500))"]
    BATCH1["Batch 1: concepts 1-500"]
    BATCH2["Batch 2: concepts 501-1000"] 
    BATCH3["Batch 3: concepts 1001-1500"]
    BATCH4["Batch 4: concepts 1501-2000"]
    PROGRESS["cli::cli_progress_bar()"]
    COMBINE["dplyr::bind_rows()"]
    
    CONCEPTS --> SPLIT
    SPLIT --> BATCH1
    SPLIT --> BATCH2
    SPLIT --> BATCH3
    SPLIT --> BATCH4
    BATCH1 --> PROGRESS
    BATCH2 --> PROGRESS
    BATCH3 --> PROGRESS
    BATCH4 --> PROGRESS
    PROGRESS --> COMBINE
```

### Name Style Templating

The `nameStyle` parameter uses `glue::glue()` templating with available fields:

| Template | Example Output | Source Field |
|----------|----------------|--------------|
| `{concept_name}` | `"metformin"` | concept.concept_name |
| `{concept_code}` | `"6809"` | concept.concept_code |
| `{concept_id}` | `"1503297"` | concept.concept_id |
| `{concept_code}_{concept_name}` | `"6809_metformin"` | Combined fields |

**Sources:** [R/drugCodes.R:311-341](), [R/drugCodes.R:262-267]()

## Database Integration

The drug-specific functions integrate with multiple OMOP CDM tables and work across different database backends.

### Required OMOP Tables

| Table | Purpose | Key Relationships |
|-------|---------|-------------------|
| `concept` | Core concept definitions | Standard concepts, vocabularies |
| `concept_ancestor` | Hierarchical relationships | Descendant lookups |
| `concept_relationship` | Concept mappings | Dose form relationships |
| `drug_strength` | Dosage information | Ingredient strength data |

### Multi-Database Testing

The functionality is tested across multiple database platforms:

| Backend | Test Coverage | Connection Method |
|---------|---------------|-------------------|
| PostgreSQL | Full integration tests | `RPostgres::Postgres()` |
| Redshift | Full integration tests | `RPostgres::Redshift()` |
| Snowflake | Core functionality tests | `odbc::odbc()` |
| SQL Server | Full integration tests | `odbc::odbc()` |
| DuckDB | Development/testing | `duckdb::duckdb()` |

**Sources:** [tests/testthat/test-dbms.R:50-69](), [tests/testthat/test-dbms.R:208-210](), [tests/testthat/test-dbms.R:360-361](), [tests/testthat/test-dbms.R:513-514]()