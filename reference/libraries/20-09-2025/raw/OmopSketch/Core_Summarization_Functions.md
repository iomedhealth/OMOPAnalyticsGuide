# Page: Core Summarization Functions

# Core Summarization Functions

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [NAMESPACE](NAMESPACE)
- [R/databaseCharacteristics.R](R/databaseCharacteristics.R)
- [man/databaseCharacteristics.Rd](man/databaseCharacteristics.Rd)
- [tests/testthat/test-databaseCharacteristics.R](tests/testthat/test-databaseCharacteristics.R)

</details>



## Purpose and Scope

This document provides a technical overview of the core summarization functions in the OmopSketch package. These functions extract and analyze data from Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM) databases, producing standardized outputs that can be used for visualization, tabulation, and comprehensive database characterization.

The core summarization functions serve as the foundation of the OmopSketch package, providing the raw data that visualization functions ([Visualization Functions](#4)) and table generation functions ([Table Generation Functions](#5)) use. For specific implementations of these functions focused on particular domains, see the detailed documentation in sections [3.1](#3.1) through [3.6](#3.6).

Sources: [NAMESPACE:12-21](), [DESCRIPTION:31-34]()

## Common Design Pattern

All core summarization functions follow a consistent design pattern:

```mermaid
flowchart LR
    A["CDM Reference"] --> B["summarise* Function"]
    B --> C["summarised_result"]
    C --> D["plot* Functions"]
    C --> E["table* Functions"]
```

Each function accepts a CDM reference (or a specific table from the CDM) as input, extracts and processes relevant data, and returns a standardized `summarised_result` object that can be used by downstream visualization and table functions.

Sources: [NAMESPACE:12-21](), [NAMESPACE:7-11](), [NAMESPACE:22-29]()

## Core Function Overview

The OmopSketch package provides the following core summarization functions:

| Function | Purpose | Primary Input |
|---|---|---|
| `summariseOmopSnapshot` | Provides basic database overview | CDM reference |
| `summariseClinicalRecords` | Summarizes clinical records across tables | CDM reference |
| `summariseRecordCount` | Counts records by various dimensions | CDM reference |
| `summariseObservationPeriod` | Analyzes observation period patterns | observation_period table |
| `summariseInObservation` | Analyzes data captured during observation | observation_period table |
| `summariseConceptCounts` | Summarizes concept usage (including ID counts and set counts) | CDM reference |
| `summariseMissingData` | Identifies missing data patterns | CDM reference |

Sources: [NAMESPACE:12-21]()

## Common Parameters

Most core summarization functions accept a common set of parameters for stratification and filtering:

```mermaid
graph TD
    subgraph "Common Parameters"
        A["sex: TRUE/FALSE"] --> F["Result"]
        B["ageGroup: list of age ranges"] --> F
        C["dateRange: study period"] --> F
        D["interval: overall/years/quarters/months"] --> F
        E["output: person/record/person-days"] --> F
    end
```

These parameters enable consistent filtering and stratification of results across different summarization functions.

Sources: [R/databaseCharacteristics.R:26-32]()

## Function Integration

The core summarization functions are designed to work both independently and together. The `databaseCharacteristics` function demonstrates how these functions can be combined to create a comprehensive database characterization:

```mermaid
graph TD
    A["databaseCharacteristics"] --> B["summariseOmopSnapshot"]
    A --> C["summariseMissingData"]
    A --> D["summariseConceptIdCounts (optional)"]
    A --> E["summariseClinicalRecords"]
    A --> F["summariseRecordCount"]
    A --> G["summariseInObservation"]
    A --> H["summariseObservationPeriod"]
    I["omopgenerics::bind"] --> J["Combined summarised_result"]
```

The results from each function are combined using the `bind` function to create a comprehensive `summarised_result` object.

Sources: [R/databaseCharacteristics.R:53-195]()

## Input and Output Types

```mermaid
classDiagram
    class CDM_Reference {
        +Tables tables
        +Connection connection
        +Schema schema
    }
    
    class summarise_Function {
        +process(data)
        +stratify(results)
        +aggregate(results)
    }
    
    class summarised_result {
        +result_id
        +result_type
        +package_name
        +package_version
        +estimate_name
        +estimate_type
        +estimate_value
        +additional_name
        +additional_level
        +strata_name
        +strata_level
    }
    
    CDM_Reference --> summarise_Function: input
    summarise_Function --> summarised_result: output
```

Each summarization function processes the input CDM data and generates a standardized `summarised_result` object that follows the structure defined in the `omopgenerics` package.

Sources: [NAMESPACE:12-21](), [NAMESPACE:30-40]()

## Data Flow

The following diagram illustrates the data flow through the core summarization functions:

```mermaid
flowchart LR
    subgraph "Input Sources"
        A1[(OMOP CDM Database)]
    end
    
    subgraph "Data Access Layer"
        B1[CDM Reference Object]
    end
    
    subgraph "Core Summarization Functions"
        C1["summariseOmopSnapshot"]
        C2["summariseClinicalRecords"]
        C3["summariseRecordCount"]
        C4["summariseObservationPeriod"]
        C5["summariseInObservation"]
        C6["summariseConceptCounts"]
        C7["summariseMissingData"]
    end
    
    subgraph "Standardized Output"
        D1[summarised_result]
    end
    
    subgraph "Downstream Operations"
        E1["Visualization (plot*)"]
        E2["Tabulation (table*)"]
        E3["Comprehensive Analysis (databaseCharacteristics)"]
        E4["Export/Import (export/importSummarisedResult)"]
    end
    
    A1 --> B1
    B1 --> C1 & C2 & C3 & C4 & C5 & C6 & C7
    C1 & C2 & C3 & C4 & C5 & C6 & C7 --> D1
    D1 --> E1 & E2 & E3 & E4
```

The core summarization functions extract data from the OMOP CDM database via the CDM reference object, process it according to their specific purposes, and produce standardized outputs that can be used by various downstream functions.

Sources: [R/databaseCharacteristics.R:34-216]()

## Usage in Database Characterization

The `databaseCharacteristics` function demonstrates how the core summarization functions can be used together to create a comprehensive database characterization:

```mermaid
sequenceDiagram
    participant User
    participant databaseCharacteristics
    participant Core as Core Summarization Functions
    participant Bind as omopgenerics::bind
    
    User->>databaseCharacteristics: Call with CDM reference
    databaseCharacteristics->>Core: summariseOmopSnapshot
    Core-->>databaseCharacteristics: snapshot results
    databaseCharacteristics->>Core: summariseMissingData
    Core-->>databaseCharacteristics: missing data results
    
    opt conceptIdCount = TRUE
        databaseCharacteristics->>Core: summariseConceptIdCounts
        Core-->>databaseCharacteristics: concept ID count results
    end
    
    databaseCharacteristics->>Core: summariseClinicalRecords
    Core-->>databaseCharacteristics: clinical records results
    databaseCharacteristics->>Core: summariseRecordCount
    Core-->>databaseCharacteristics: record count results
    databaseCharacteristics->>Core: summariseInObservation
    Core-->>databaseCharacteristics: in-observation results
    databaseCharacteristics->>Core: summariseObservationPeriod
    Core-->>databaseCharacteristics: observation period results
    
    databaseCharacteristics->>Bind: Combine all results
    Bind-->>databaseCharacteristics: Combined summarised_result
    databaseCharacteristics-->>User: Return combined results
```

This function provides a comprehensive characterization of the database by combining the results of multiple core summarization functions.

Sources: [R/databaseCharacteristics.R:22-218](), [tests/testthat/test-databaseCharacteristics.R:1-23]()

## Example Usage

Here's a simple example of how to use the core summarization functions:

```
# Connect to an OMOP CDM database
cdm <- connect_to_cdm_database()

# Get a snapshot of the database
snapshot <- summariseOmopSnapshot(cdm)

# Summarize clinical records with stratification
clinical_records <- summariseClinicalRecords(
  cdm,
  omopTableName = c("condition_occurrence", "drug_exposure"),
  sex = TRUE,
  ageGroup = list(c(0, 40), c(41, 65), c(66, Inf))
)

# Combine results
combined_results <- omopgenerics::bind(snapshot, clinical_records)

# Create tables and visualizations
tables <- tableClinicalRecords(clinical_records)
plots <- plotRecordCount(summariseRecordCount(cdm))
```

The core summarization functions can be used individually for targeted analysis or combined for comprehensive database characterization.

Sources: [tests/testthat/test-databaseCharacteristics.R:1-23]()