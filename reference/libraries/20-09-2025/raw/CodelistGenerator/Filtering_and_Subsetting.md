# Page: Filtering and Subsetting

# Filtering and Subsetting

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.github/workflows/R-CMD-check.yaml](.github/workflows/R-CMD-check.yaml)
- [.github/workflows/test-coverage.yaml](.github/workflows/test-coverage.yaml)
- [R/codesInUse.R](R/codesInUse.R)
- [R/subsetOnDomain.R](R/subsetOnDomain.R)
- [R/subsetOnDoseUnit.R](R/subsetOnDoseUnit.R)
- [man/codesInUse.Rd](man/codesInUse.Rd)
- [man/sourceCodesInUse.Rd](man/sourceCodesInUse.Rd)
- [man/stratifyByDoseUnit.Rd](man/stratifyByDoseUnit.Rd)
- [man/subsetOnDoseUnit.Rd](man/subsetOnDoseUnit.Rd)
- [tests/testthat/test-restrictToCodesInUse.R](tests/testthat/test-restrictToCodesInUse.R)

</details>



This document covers functions that filter codelists by removing unwanted concepts based on various criteria including domain, dose unit, route, or actual usage in patient data. These functions reduce the size of codelists by eliminating concepts that don't meet specified requirements.

For information about splitting codelists into multiple stratified groups, see [Stratification Functions](#4.1). For broader codelist manipulation approaches, see the parent section [Codelist Manipulation](#4).

## Overview

Filtering and subsetting functions in CodelistGenerator provide targeted reduction of codelist content based on specific criteria. These functions operate on existing codelists to produce refined versions that meet particular requirements.

The filtering functions fall into three main categories:

| Category | Purpose | Key Functions |
|----------|---------|---------------|
| Usage-based | Filter to codes actually used in patient records | `subsetToCodesInUse`, `codesInUse` |
| Domain-based | Filter by OMOP domain classification | `subsetOnDomain` |
| Drug attribute-based | Filter by pharmaceutical properties | `subsetOnDoseUnit` |

Sources: [R/codesInUse.R:17-87](), [R/subsetOnDomain.R:17-92](), [R/subsetOnDoseUnit.R:17-125]()

## Usage-Based Filtering Architecture

```mermaid
graph TB
    subgraph "Input_Codelists"
        CL["Codelist<br/>x = list(concept_ids)"]
    end
    
    subgraph "Achilles_Data_Source"
        AR["achilles_results"]
        ARA["achilles_analysis"] 
        ARD["achilles_results_dist"]
    end
    
    subgraph "Usage_Detection_Functions"
        CIU["codesInUse()"]
        SCIU["sourceCodesInUse()"]
        FACIU["fetchAchillesCodesInUse()"]
        FASCIU["fetchAchillesSourceCodesInUse()"]
    end
    
    subgraph "Filtering_Functions"
        STCIU["subsetToCodesInUse()"]
    end
    
    subgraph "Analysis_IDs"
        AID_401["401L - condition_occurrence"]
        AID_701["701L - drug_exposure"]
        AID_801["801L - observation"]
        AID_1801["1801L - measurement"]
        AID_201["201L - visit_occurrence"]
        AID_601["601L - procedure_occurrence"]
        AID_2101["2101L - device_exposure"]
    end
    
    AR --> CIU
    ARA --> CIU
    ARD --> CIU
    
    AR --> FACIU
    FACIU --> CIU
    
    AR --> FASCIU
    FASCIU --> SCIU
    
    AID_401 --> FACIU
    AID_701 --> FACIU
    AID_801 --> FACIU
    AID_1801 --> FACIU
    AID_201 --> FACIU
    AID_601 --> FACIU
    AID_2101 --> FACIU
    
    CL --> STCIU
    CIU --> STCIU
    
    STCIU --> CL_FILTERED["Filtered Codelist<br/>Only codes with usage >= minimumCount"]
```

The usage-based filtering system leverages Achilles analysis results to determine which concepts are actually present in patient records. The `fetchAchillesCodesInUse` function queries specific analysis IDs that correspond to different OMOP CDM tables.

Sources: [R/codesInUse.R:213-239](), [R/codesInUse.R:41-87]()

## Core Filtering Functions

### Usage-Based Filtering

The `subsetToCodesInUse` function filters codelists to retain only concepts that appear in patient records with sufficient frequency:

```mermaid
graph LR
    subgraph "Input_Parameters"
        X["x: list of concept_ids"]
        CDM["cdm: CDM reference"]
        MC["minimumCount: integer"]
        TBL["table: character vector"]
    end
    
    subgraph "Processing_Steps"
        VAL["Validation<br/>assertList, validateCdmArgument"]
        GET_CODES["codesInUse()<br/>Get used concept_ids"]
        INTERSECT["intersect()<br/>Filter each codelist"]
        DROP["vctrs::list_drop_empty()<br/>Remove empty lists"]
    end
    
    subgraph "Output"
        FILTERED["Filtered codelists<br/>Only codes in use"]
        EMPTY["emptyCodelist()<br/>If no codes found"]
    end
    
    X --> VAL
    CDM --> VAL
    MC --> VAL
    TBL --> VAL
    
    VAL --> GET_CODES
    CDM --> GET_CODES
    MC --> GET_CODES
    TBL --> GET_CODES
    
    GET_CODES --> INTERSECT
    X --> INTERSECT
    
    INTERSECT --> DROP
    DROP --> FILTERED
    DROP --> EMPTY
```

The function supports filtering across multiple OMOP CDM tables and respects minimum count thresholds for concept usage frequency.

Sources: [R/codesInUse.R:41-87](), [R/codesInUse.R:105-126]()

### Domain-Based Filtering

The `subsetOnDomain` function filters codelists based on OMOP domain classifications:

```mermaid
graph TB
    subgraph "Domain_Filtering_Process"
        INPUT["Input codelist<br/>x = list(concept_ids)"]
        TEMP_TABLE["Temporary table<br/>uniqueTableName() + uniqueId()"]
        JOIN_CONCEPT["JOIN with concept table<br/>Get domain_id"]
        APPLY_FILTER["Apply domain filter<br/>tolower(domain_id) %in% tolower(domain)"]
        NEGATE_CHECK{"negate = TRUE?"}
        INCLUDE["Include matching domains"]
        EXCLUDE["Exclude matching domains"]
        CLEANUP["CDMConnector::dropTable()"]
    end
    
    INPUT --> TEMP_TABLE
    TEMP_TABLE --> JOIN_CONCEPT
    JOIN_CONCEPT --> APPLY_FILTER
    APPLY_FILTER --> NEGATE_CHECK
    NEGATE_CHECK -->|FALSE| INCLUDE
    NEGATE_CHECK -->|TRUE| EXCLUDE
    INCLUDE --> CLEANUP
    EXCLUDE --> CLEANUP
```

The function creates temporary tables for efficient database operations and supports both inclusive and exclusive filtering through the `negate` parameter.

Sources: [R/subsetOnDomain.R:40-92]()

### Dose Unit Filtering

The `subsetOnDoseUnit` function filters drug codelists based on dose unit specifications:

```mermaid
graph TB
    subgraph "Dose_Unit_Processing"
        CODELIST["Input codelist"]
        CHECK_DETAILS{"codelist_with_details?"}
        EXTRACT["Extract concept_ids<br/>codelistFromCodelistWithDetails()"]
        DRUG_STRENGTH["drug_strength table"]
        CONCEPT_NAMES["concept table<br/>Get unit names"]
        
        subgraph "Unit_Matching"
            AMOUNT["amount_unit_concept_id<br/>→ amount_concept_name"]
            NUMERATOR["numerator_unit_concept_id<br/>→ numerator_concept_name"]
        end
        
        FILTER_LOGIC["Filter by dose unit<br/>tolower() comparison"]
        NEGATE_CHECK{"negate = TRUE?"}
        RESTORE_DETAILS["Restore original details<br/>if withDetails = TRUE"]
    end
    
    CODELIST --> CHECK_DETAILS
    CHECK_DETAILS -->|TRUE| EXTRACT
    CHECK_DETAILS -->|FALSE| DRUG_STRENGTH
    EXTRACT --> DRUG_STRENGTH
    
    DRUG_STRENGTH --> CONCEPT_NAMES
    CONCEPT_NAMES --> AMOUNT
    CONCEPT_NAMES --> NUMERATOR
    
    AMOUNT --> FILTER_LOGIC
    NUMERATOR --> FILTER_LOGIC
    FILTER_LOGIC --> NEGATE_CHECK
    NEGATE_CHECK --> RESTORE_DETAILS
```

The function supports both `codelist` and `codelist_with_details` formats and performs case-insensitive dose unit matching against both amount and numerator units.

Sources: [R/subsetOnDoseUnit.R:40-125]()

## Achilles Integration

The filtering system extensively uses Achilles analysis results to determine code usage patterns:

| Analysis ID | Table | Purpose |
|-------------|-------|---------|
| 401L | condition_occurrence | Standard condition concepts |
| 701L | drug_exposure | Standard drug concepts |
| 801L | observation | Standard observation concepts |
| 1801L | measurement | Standard measurement concepts |
| 201L | visit_occurrence | Standard visit concepts |
| 601L | procedure_occurrence | Standard procedure concepts |
| 2101L | device_exposure | Standard device concepts |
| 425L, 725L, 825L, etc. | Various | Source concept usage |

The `fetchAchillesCodesInUse` function queries these analysis IDs to retrieve concept usage statistics with configurable minimum count thresholds.

Sources: [R/codesInUse.R:213-261]()

## Data Flow and Integration

```mermaid
graph LR
    subgraph "CDM_Database"
        CONCEPT["concept table"]
        DRUG_STRENGTH["drug_strength table"]
        ACHILLES["achilles_results table"]
    end
    
    subgraph "Input_Codelists"
        REGULAR["Regular codelist"]
        WITH_DETAILS["codelist_with_details"]
    end
    
    subgraph "Filtering_Operations"
        DOMAIN_FILTER["subsetOnDomain()"]
        DOSE_FILTER["subsetOnDoseUnit()"]
        USAGE_FILTER["subsetToCodesInUse()"]
    end
    
    subgraph "Output_Products"
        FILTERED_CL["Filtered codelists"]
        EMPTY_CL["Empty codelists"]
    end
    
    CONCEPT --> DOMAIN_FILTER
    DRUG_STRENGTH --> DOSE_FILTER
    ACHILLES --> USAGE_FILTER
    
    REGULAR --> DOMAIN_FILTER
    REGULAR --> DOSE_FILTER
    REGULAR --> USAGE_FILTER
    
    WITH_DETAILS --> DOSE_FILTER
    
    DOMAIN_FILTER --> FILTERED_CL
    DOSE_FILTER --> FILTERED_CL
    USAGE_FILTER --> FILTERED_CL
    
    DOMAIN_FILTER --> EMPTY_CL
    DOSE_FILTER --> EMPTY_CL
    USAGE_FILTER --> EMPTY_CL
```

All filtering functions integrate with the OMOP CDM database structure and handle both regular codelists and enhanced `codelist_with_details` formats. The functions automatically manage temporary table creation and cleanup for efficient database operations.

Sources: [R/subsetOnDomain.R:50-88](), [R/subsetOnDoseUnit.R:65-121](), [R/codesInUse.R:61-85]()