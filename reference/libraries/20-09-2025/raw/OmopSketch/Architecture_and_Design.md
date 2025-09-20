# Page: Architecture and Design

# Architecture and Design

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [NAMESPACE](NAMESPACE)
- [NEWS.md](NEWS.md)
- [R/documentationHelper.R](R/documentationHelper.R)
- [_pkgdown.yml](_pkgdown.yml)
- [man/interval.Rd](man/interval.Rd)
- [man/summariseInObservation.Rd](man/summariseInObservation.Rd)

</details>



## Purpose and Scope

This document describes the architectural structure, design principles, and patterns of the OmopSketch package. OmopSketch provides a framework for characterizing and summarizing OMOP (Observational Medical Outcomes Partnership) Common Data Model (CDM) databases. For specific information about individual functions, see [Core Summarization Functions](#3) and related pages.

## System Architecture Overview

OmopSketch follows a consistent architectural pattern that transforms OMOP CDM database data into standardized summaries, visualizations, and tables.

### High-Level Architecture Diagram

```mermaid
graph TD
    A["OMOP CDM Database"] --> B["CDM Reference Object"]
    B --> C["Summarization Functions"]
    C --> D["summarised_result Object"]
    D --> E["Visualization Functions"]
    D --> F["Table Functions"]
    E --> G["ggplot Objects"]
    F --> H["Formatted Tables"]
    H --> H1["gt"]
    H --> H2["flextable"]
    H --> H3["datatable"]
    H --> H4["reactable"]
```

Sources: [NAMESPACE:3-29](), [DESCRIPTION:64-78]()

## Core Components

The OmopSketch package organizes its functionality into several core components:

```mermaid
graph TD
    A["OmopSketch"] --> B["Summarization Functions"]
    A --> C["Visualization Functions"]
    A --> D["Table Generation Functions"]
    A --> E["Database Characterization"]
    A --> F["Mock Data Generation"]
    
    B --> B1["summariseOmopSnapshot()"]
    B --> B2["summariseClinicalRecords()"]
    B --> B3["summariseRecordCount()"]
    B --> B4["summariseObservationPeriod()"]
    B --> B5["summariseInObservation()"]
    B --> B6["summariseConceptCounts()"]
    B --> B7["summariseMissingData()"]
    
    C --> C1["plotRecordCount()"]
    C --> C2["plotObservationPeriod()"]
    C --> C3["plotInObservation()"]
    C --> C4["plotConceptSetCounts()"]
    
    D --> D1["tableOmopSnapshot()"]
    D --> D2["tableClinicalRecords()"]
    D --> D3["tableRecordCount()"]
    D --> D4["tableObservationPeriod()"]
    D --> D5["tableInObservation()"]
    D --> D6["tableConceptIdCounts()"]
    D --> D7["tableMissingData()"]
    
    E --> E1["databaseCharacteristics()"]
    
    F --> F1["mockOmopSketch()"]
```

Sources: [NAMESPACE:3-29](), [_pkgdown.yml:13-52]()

## Design Patterns and Principles

### Consistent Function Naming Pattern

OmopSketch implements a systematic naming convention:

| Prefix | Purpose | Examples |
|--------|---------|----------|
| `summarise` | Data extraction and processing | `summariseClinicalRecords()`, `summariseObservationPeriod()` |
| `plot` | Visualization creation | `plotRecordCount()`, `plotInObservation()` |
| `table` | Table formatting | `tableClinicalRecords()`, `tableConceptIdCounts()` |

Each function name follows the pattern: `<action><Domain>`, where domain refers to the specific OMOP CDM data area.

Sources: [NAMESPACE:3-29]()

### Standard Data Flow Pattern

For each data domain, OmopSketch implements a consistent processing pattern:

```mermaid
graph TD
    subgraph "Consistent Pattern Across Domains"
        A["CDM Reference"] --> B["summarise* Function"]
        B --> C["summarised_result Object"]
        C --> D["plot* Function"]
        C --> E["table* Function"]
        D --> F["ggplot Visualization"]
        E --> G["Formatted Table"]
    end
```

This consistent pattern enables users to quickly understand how to work with different OMOP CDM data domains.

Sources: [NAMESPACE:3-29](), [_pkgdown.yml:13-52]()

### Common Parameter System

OmopSketch functions share standardized parameters across many functions:

```mermaid
graph TD
    A["Common Parameters"] --> B["interval"]
    A --> C["dateRange"]
    A --> D["ageGroup"]
    A --> E["sex"]
    A --> F["output"]
    
    B --> B1["'overall'"]
    B --> B2["'years'"]
    B --> B3["'quarters'"]
    B --> B4["'months'"]
    
    C --> C1["Two-date vector defining study period"]
    
    D --> D2["List of age group definitions"]
    
    E --> E1["Boolean for sex stratification"]
    
    F --> F1["'person'"]
    F --> F2["'record'"]
    F --> F3["'person-days'"]
    F --> F4["'sex'"]
    F --> F5["'age'"]
```

Sources: [man/interval.Rd:7-8](), [man/summariseInObservation.Rd:17-36](), [R/documentationHelper.R:3-22]()

## Data Flow Implementation

### Summarization Layer

The summarization functions form the core of OmopSketch's functionality. These functions extract data from OMOP CDM tables, process it according to specified parameters, and return standardized results.

```mermaid
graph LR
    A["OMOP CDM Database"] --> B["CDM Reference Object"]
    B --> C["Summarization Functions"]
    C --> D["summarised_result Object"]
```

The `summarised_result` object is a standardized structure from the `omopgenerics` package that serves as the common interface between summarization and presentation layers.

Sources: [NAMESPACE:30-36](), [DESCRIPTION:72]()

### Stratification System

OmopSketch provides flexible data stratification options:

```mermaid
graph TD
    A["summariseInObservation()"] --> B{"Stratification Parameters"}
    
    B --> C["interval"]
    B --> D["output"]
    B --> E["ageGroup"]
    B --> F["sex"]
    B --> G["dateRange"]
    
    C --> C1["Time period stratification"]
    D --> D1["Output type selection"]
    E --> E1["Age group stratification"]
    F --> F1["Sex stratification"]
    G --> G1["Date range filtering"]
```

This parameterization system is consistently implemented across summarization functions, allowing for flexible data exploration.

Sources: [man/summariseInObservation.Rd:8-15]()

## Integration: Database Characterization

The `databaseCharacteristics()` function brings together multiple summarization functions to provide a comprehensive database overview:

```mermaid
graph TD
    A["databaseCharacteristics()"] --> B["CDM Snapshot"]
    A --> C["Population Characteristics"]
    A --> D["Missing Data"]
    A --> E["Concept Counts"]
    A --> F["Clinical Records"]
    A --> G["Record Counts"]
    A --> H["Observation Periods"]
    
    B --> B1["summariseOmopSnapshot()"]
    C --> C1["CohortCharacteristics Package"]
    D --> D1["summariseMissingData()"]
    E --> E1["summariseConceptIdCounts()"]
    F --> F1["summariseClinicalRecords()"]
    G --> G1["summariseRecordCount()"]
    H --> H1["summariseObservationPeriod()"]
    H --> H2["summariseInObservation()"]
```

Sources: [NAMESPACE:4](), [NEWS.md:3-6](), [_pkgdown.yml:49-52]()

## Package Dependencies

OmopSketch relies on several key packages to provide its functionality:

| Dependency Type | Packages |
| --------------- | -------- |
| Core Data Handling | CDMConnector, omopgenerics, PatientProfiles, dplyr, tidyr |
| Visualization | ggplot2, visOmopResults |
| Table Generation | gt, flextable, reactable, DT |
| Database Connectivity | DBI, duckdb, odbc, RPostgres |
| Testing | omock, testthat |

Sources: [DESCRIPTION:39-78]()

## Testing Infrastructure

OmopSketch includes the `mockOmopSketch()` function for generating synthetic OMOP CDM data for testing and demonstration purposes:

```mermaid
graph LR
    A["mockOmopSketch()"] --> B["Mock CDM Reference Object"]
    B --> C["Test Summarization Functions"]
    B --> D["Test Visualization Functions"]
    B --> E["Test Table Functions"]
```

Sources: [NAMESPACE:7](), [_pkgdown.yml:45-48](), [man/summariseInObservation.Rd:48]()

## Version Control and Enhancement

OmopSketch employs an iterative development approach, with version numbers following semantic versioning principles. The package is regularly updated with new features and bug fixes, as shown in the NEWS.md file.

Recent enhancements include:
- Addition of databaseCharacteristics() function
- Expanded output options in summariseInObservation()
- Table generation improvements for various data domains

Sources: [NEWS.md:1-32](), [DESCRIPTION:3]()