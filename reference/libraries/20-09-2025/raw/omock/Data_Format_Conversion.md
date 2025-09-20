# Page: Data Format Conversion

# Data Format Conversion

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.Rbuildignore](.Rbuildignore)
- [.gitignore](.gitignore)
- [Datasets/convertDatasetsToCsv.R](Datasets/convertDatasetsToCsv.R)
- [R/mockDatasets.R](R/mockDatasets.R)
- [R/sysdata.rda](R/sysdata.rda)
- [data-raw/default/concept.csv](data-raw/default/concept.csv)
- [data-raw/default/conceptAncestor.csv](data-raw/default/conceptAncestor.csv)
- [data-raw/default/conceptRelationship.csv](data-raw/default/conceptRelationship.csv)
- [data-raw/default/conceptSynonym.csv](data-raw/default/conceptSynonym.csv)
- [data-raw/default/drugStrength.csv](data-raw/default/drugStrength.csv)
- [data-raw/internalData.R](data-raw/internalData.R)
- [man/availableMockDatasets.Rd](man/availableMockDatasets.Rd)

</details>



This document covers the data format conversion system in omock, focusing on converting between Parquet and CSV formats and managing local data storage for mock datasets. This system enables the package to work with externally hosted datasets that are distributed in Parquet format but need to be processed locally.

For information about working with predefined datasets and their management, see [Predefined Datasets](#4.1). For broader dataset management concepts, see [Dataset Management System](#4).

## Overview

The omock package handles datasets that are stored remotely in Parquet format but need to be converted and processed locally. The conversion system manages the download, format transformation, and local caching of these datasets to support CDM object creation.

## Core Conversion Functions

The primary conversion logic is implemented through several key functions that handle different aspects of the format conversion process:

### Reading and Processing Tables

The `readTables()` function handles the core table reading and processing logic:

```mermaid
graph TD
    A[readTables] --> B["List .parquet files"]
    B --> C["Extract table names"]
    C --> D["Read with arrow::read_parquet"]
    D --> E[castColumns]
    E --> F["Return processed tables"]
    
    G["tmpFolder path"] --> A
    H["CDM version"] --> A
    I["vocab flag"] --> A
```

**readTables Function Workflow**
Sources: [R/mockDatasets.R:88-105]()

### Column Type Casting

The `castColumns()` function ensures data types match OMOP CDM specifications:

```mermaid
graph LR
    A[castColumns] --> B["Get OMOP table fields"]
    B --> C["Filter matching columns"] 
    C --> D["Apply type conversions"]
    D --> E["Return typed data"]
    
    F["Raw data"] --> A
    G["Table name"] --> A
    H["CDM version"] --> A
```

**Column Casting Process**
Sources: [R/mockDatasets.R:378-402]()

## Format Conversion Architecture

The system implements a multi-stage conversion process that handles the transformation from remote Parquet files to locally processed CSV data:

```mermaid
flowchart TD
    A["Remote Parquet Files"] --> B[downloadMockDataset]
    B --> C["Local ZIP Storage"]
    C --> D["Temporary Extraction"]
    D --> E[readTables]
    E --> F["arrow::read_parquet"]
    F --> G[castColumns]
    G --> H["OMOP Type Conversion"]
    H --> I["Processed Tables"]
    I --> J[mockCdmFromDataset]
    
    K["mockDatasetsFolder()"] --> C
    L["omopgenerics::omopTableFields()"] --> G
```

**Data Format Conversion Flow**
Sources: [R/mockDatasets.R:19-87](), [R/mockDatasets.R:88-105](), [R/mockDatasets.R:378-402]()

## Dataset Conversion Script

The package includes a dedicated conversion script for processing multiple datasets:

```mermaid
graph TD
    A[convertDatasetsToCsv.R] --> B["Download ZIP files"]
    B --> C["Extract Parquet files"]
    C --> D["DuckDB Connection"]
    D --> E["Convert to CSV"]
    E --> F["Write CSV files"]
    F --> G["Re-zip as CSV"]
    G --> H["Clean up files"]
    
    I["Dataset URLs"] --> A
    J["Datasets/ directory"] --> A
```

**Bulk Conversion Process**
Sources: [Datasets/convertDatasetsToCsv.R:29-66]()

## Data Type Handling

The conversion system handles multiple OMOP CDM data types through the `castColumns()` function:

| OMOP Type | R Function | Description |
|-----------|------------|-------------|
| `varchar` | `as.character` | String/text fields |
| `integer` | `as.integer` | Whole numbers |
| `datetime` | `as.POSIXct` | Timestamps |
| `date` | `as.Date` | Date values |
| `float` | `as.numeric` | Decimal numbers |
| `logical` | `as.logical` | Boolean values |

Sources: [R/mockDatasets.R:378-402]()

## Local Storage Management

The conversion system integrates with the local storage management through several key components:

```mermaid
graph LR
    A[mockDatasetsFolder] --> B["MOCK_DATASETS_FOLDER env var"]
    B --> C["Local ZIP Storage"]
    C --> D[isMockDatasetDownloaded]
    D --> E[datasetAvailable]
    E --> F["Temporary Extraction"]
    F --> G[readTables]
    
    H["User Path"] --> A
    I["Temp Directory Fallback"] --> A
```

**Storage Management Integration**
Sources: [R/mockDatasets.R:312-340](), [R/mockDatasets.R:342-352](), [R/mockDatasets.R:252-259]()

## Vocabulary Table Filtering

The system includes specialized handling for vocabulary-only datasets through the `filterToVocab()` function:

```mermaid
graph TD
    A[filterToVocab] --> B["Target vocabulary tables"]
    B --> C["cdm_source, concept, vocabulary"]
    C --> D["concept_relationship, concept_synonym"]
    D --> E["concept_ancestor, drug_strength"]
    E --> F["Filter file paths"]
    F --> G["Return vocabulary subset"]
    
    H["All Parquet paths"] --> A
```

**Vocabulary Filtering Process**
Sources: [R/mockDatasets.R:404-424]()

## Integration with CDM Creation

The format conversion system directly supports CDM object creation through the `mockCdmFromDataset()` workflow:

```mermaid
sequenceDiagram
    participant U as User
    participant M as mockCdmFromDataset
    participant D as datasetAvailable
    participant R as readTables
    participant C as castColumns
    participant O as omopgenerics::cdmFromTables
    
    U->>M: datasetName
    M->>D: Check/download dataset
    D-->>M: Local ZIP path
    M->>M: Extract to temp folder
    M->>R: Read Parquet files
    R->>C: Cast column types
    C-->>R: Typed tables
    R-->>M: Processed tables
    M->>O: Create CDM object
    O-->>M: CDM reference
    M-->>U: Final CDM
```

**CDM Creation Integration**
Sources: [R/mockDatasets.R:19-87](), [R/mockDatasets.R:88-105]()