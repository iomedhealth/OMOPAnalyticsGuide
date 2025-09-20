# Page: Overview

# Overview

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [README.Rmd](README.Rmd)
- [README.md](README.md)

</details>



This document provides a comprehensive overview of the IncidencePrevalence R package, which implements epidemiological analysis capabilities for calculating population-level incidence rates and prevalence using data structured according to the OMOP Common Data Model (CDM). The package serves as a specialized tool for observational health data research, providing standardized methods for cohort-based analysis.

For detailed information about specific analysis types, see [Incidence Analysis](#5) and [Prevalence Analysis](#6). For implementation details of core calculation methods, see [Core Concepts](#3). For information about result visualization and reporting capabilities, see [Visualization and Reporting](#7).

## Package Purpose and Capabilities

The IncidencePrevalence package provides a comprehensive framework for conducting epidemiological analyses on OMOP CDM data. The package implements standardized approaches for calculating incidence rates, point prevalence, and period prevalence across stratified populations.

**Core Analysis Types:**
- **Incidence Rate Estimation**: Time-to-event analysis with support for repeated events, washout periods, and censoring
- **Point Prevalence**: Cross-sectional prevalence at specific time points  
- **Period Prevalence**: Prevalence over defined time intervals with flexible contribution requirements

**Key Features:**
- Integration with OMOP CDM ecosystem through `CDMConnector` and `omopgenerics`
- Flexible denominator cohort generation with age, sex, and observation period stratification
- Comprehensive input validation and error handling
- Standardized result formats compatible with other OMOP tools
- Built-in visualization and table generation capabilities

Sources: [DESCRIPTION:1-72](), [README.md:9-24]()

## High-Level System Architecture

The following diagram illustrates the overall architecture and key components of the IncidencePrevalence package:

**IncidencePrevalence Package Architecture**

```mermaid
graph TB
    subgraph "External_Dependencies" ["External Dependencies"]
        OMOP_CDM[("OMOP CDM Database")]
        CDMConnector["CDMConnector"]
        omopgenerics["omopgenerics"]
        PatientProfiles["PatientProfiles"]
    end
    
    subgraph "IncidencePrevalence_Package" ["IncidencePrevalence Package"]
        subgraph "Data_Layer" ["Data Access & Validation"]
            mockIncidencePrevalence["mockIncidencePrevalence"]
            input_validation["Input Validation System"]
            date_utilities["Date Utilities"]
        end
        
        subgraph "Cohort_Generation" ["Cohort Generation"]
            generateDenominatorCohortSet["generateDenominatorCohortSet"]
            generateTargetDenominatorCohortSet["generateTargetDenominatorCohortSet"]
        end
        
        subgraph "Core_Analytics" ["Core Analytics Engine"]
            getIncidence["getIncidence"]
            getPrevalence["getPrevalence"]
        end
        
        subgraph "High_Level_API" ["High-Level Analysis API"]
            estimateIncidence["estimateIncidence"]
            estimatePointPrevalence["estimatePointPrevalence"]
            estimatePeriodPrevalence["estimatePeriodPrevalence"]
        end
        
        subgraph "Output_System" ["Output & Visualization"]
            plotIncidence["plotIncidence"]
            plotPrevalence["plotPrevalence"]
            tableIncidence["tableIncidence"]
            tablePrevalence["tablePrevalence"]
        end
    end
    
    OMOP_CDM --> CDMConnector
    CDMConnector --> generateDenominatorCohortSet
    CDMConnector --> generateTargetDenominatorCohortSet
    
    omopgenerics --> input_validation
    PatientProfiles --> generateDenominatorCohortSet
    
    mockIncidencePrevalence --> generateDenominatorCohortSet
    input_validation --> estimateIncidence
    input_validation --> estimatePointPrevalence
    input_validation --> estimatePeriodPrevalence
    
    generateDenominatorCohortSet --> getIncidence
    generateDenominatorCohortSet --> getPrevalence
    generateTargetDenominatorCohortSet --> getIncidence
    
    date_utilities --> getIncidence
    date_utilities --> getPrevalence
    
    getIncidence --> estimateIncidence
    getPrevalence --> estimatePointPrevalence
    getPrevalence --> estimatePeriodPrevalence
    
    estimateIncidence --> plotIncidence
    estimateIncidence --> tableIncidence
    estimatePointPrevalence --> plotPrevalence
    estimatePointPrevalence --> tablePrevalence
    estimatePeriodPrevalence --> plotPrevalence
    estimatePeriodPrevalence --> tablePrevalence
```

Sources: [DESCRIPTION:31-43](), [README.md:47-81]()

## Main Analysis Workflow

The following diagram shows the typical workflow for conducting epidemiological analyses using the package:

**Analysis Workflow and Data Flow**

```mermaid
flowchart TD
    subgraph "Data_Setup" ["Data Setup"]
        CDM_Connection[("CDM Database\nConnection")]
        Mock_Data["mockIncidencePrevalence()"]
        Outcome_Cohort[("Existing Outcome\nCohort")]
    end
    
    subgraph "Cohort_Generation_Phase" ["Cohort Generation Phase"]
        generateDenominatorCohortSet_call["generateDenominatorCohortSet(\nageGroup, sex,\ndaysPriorObservation,\ncohortDateRange)"]
        Denominator_Cohorts[("Generated Denominator\nCohorts")]
    end
    
    subgraph "Analysis_Configuration" ["Analysis Configuration"]
        Analysis_Type{"Analysis Type"}
        Incidence_Config["Incidence Parameters:\nrepeatedEvents,\noutcomeWashout,\ncompleteDatabaseIntervals"]
        Prevalence_Config["Prevalence Parameters:\ntimePoint,\nfullContribution,\ncompleteDatabaseIntervals"]
    end
    
    subgraph "Core_Computation" ["Core Computation"]
        estimateIncidence_call["estimateIncidence()"]
        estimatePointPrevalence_call["estimatePointPrevalence()"]
        estimatePeriodPrevalence_call["estimatePeriodPrevalence()"]
    end
    
    subgraph "Results_Processing" ["Results Processing"]
        summarised_result[("summarised_result\nObject")]
        Confidence_Intervals["Confidence Intervals\nCalculation"]
        Attrition_Tracking["Population Attrition\nTracking"]
    end
    
    subgraph "Output_Generation" ["Output Generation"]
        plotIncidence_call["plotIncidence()"]
        plotPrevalence_call["plotPrevalence()"]
        tableIncidence_call["tableIncidence()"]
        tablePrevalence_call["tablePrevalence()"]
    end
    
    CDM_Connection --> generateDenominatorCohortSet_call
    Mock_Data --> generateDenominatorCohortSet_call
    generateDenominatorCohortSet_call --> Denominator_Cohorts
    
    Denominator_Cohorts --> Analysis_Type
    Outcome_Cohort --> Analysis_Type
    
    Analysis_Type -->|"Incidence Analysis"| Incidence_Config
    Analysis_Type -->|"Point Prevalence"| Prevalence_Config
    Analysis_Type -->|"Period Prevalence"| Prevalence_Config
    
    Incidence_Config --> estimateIncidence_call
    Prevalence_Config --> estimatePointPrevalence_call
    Prevalence_Config --> estimatePeriodPrevalence_call
    
    estimateIncidence_call --> summarised_result
    estimatePointPrevalence_call --> summarised_result
    estimatePeriodPrevalence_call --> summarised_result
    
    summarised_result --> Confidence_Intervals
    summarised_result --> Attrition_Tracking
    
    Confidence_Intervals --> plotIncidence_call
    Confidence_Intervals --> plotPrevalence_call
    Confidence_Intervals --> tableIncidence_call
    Confidence_Intervals --> tablePrevalence_call
```

Sources: [README.md:84-163](), [README.Rmd:85-163]()

## Key Integration Points and Dependencies

The package integrates extensively with the OMOP CDM ecosystem and R data science tools through well-defined interfaces:

| Component | Purpose | Key Functions |
|-----------|---------|---------------|
| **CDMConnector** | Database abstraction and CDM validation | `cdmFromCon()`, table references |
| **omopgenerics** | Standardized result formats and validation | `summarised_result` objects, `settings()` |
| **PatientProfiles** | Patient data extraction and profiling | Demographic and observation period queries |
| **dplyr/tidyr** | Data manipulation and transformation | SQL generation, data processing pipelines |
| **ggplot2** | Base visualization framework | Plot generation through `plotIncidence()`/`plotPrevalence()` |
| **visOmopResults** | OMOP-specific visualization extensions | Enhanced plotting and table formatting |

**Database Backend Support:**
- PostgreSQL via `RPostgres`
- DuckDB for in-memory analysis
- SQL Server and other ODBC-compatible databases
- Database-agnostic SQL generation through `CDMConnector`

Sources: [DESCRIPTION:31-64]()

## Result Formats and Output Standards

All analysis functions return standardized `summarised_result` objects that comply with `omopgenerics` specifications. These objects contain:

**Core Result Structure:**
- **Estimates**: Calculated rates, proportions, and counts
- **Confidence Intervals**: 95% confidence bounds using appropriate statistical methods
- **Stratification Variables**: Age groups, sex, calendar periods
- **Metadata**: Analysis parameters, cohort definitions, database characteristics
- **Attrition Information**: Population filtering steps and exclusion counts

**Supported Output Formats:**
- Interactive plots via `plotIncidence()` and `plotPrevalence()`
- Formatted tables through `tableIncidence()` and `tablePrevalence()`
- Raw data export for custom analysis
- Integration with `visOmopResults` for enhanced reporting

The standardized format ensures interoperability with other OMOP CDM analysis tools and supports reproducible research workflows.

Sources: [README.md:184-231](), [README.Rmd:125-163]()