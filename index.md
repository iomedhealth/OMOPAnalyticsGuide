---
title: Home
layout: home
---

# OMOP Analytics Workflow Documentation

A comprehensive documentation site introducing the analytics workflow for the
Observational Medical Outcomes Partnership (OMOP) Common Data Model

## Overview

This repository contains educational materials and documentation for conducting
real-world evidence studies using the OMOP CDM format. The site introduces a
complete analytics ecosystem of R packages designed for observational health
data analysis.

## Core Analytics Workflow

The OMOP analytics workflow follows a standardized pipeline for real-world
evidence studies. The workflow transforms raw OMOP CDM data into validated
research results through standardized phases that build upon each other.

### Foundation Packages
- **CDMConnector**: Database connectivity and CDM object management
- **OmopSketch**: Database characterization and profiling
- **CodelistGenerator**: Medical concept definition and code mapping

### Cohort Management
- **CohortConstructor**: Patient population definition and inclusion criteria
- **PhenotypeR**: Cohort validation and diagnostic assessment
- **CohortCharacteristics**: Population characterization and baseline analysis

### Specialized Analytics
- **DrugUtilisation**: Drug utilization studies and medication patterns
- **IncidencePrevalence**: Epidemiological rate estimation
- **CohortSurvival**: Time-to-event and survival analysis

This diagram represents the five-phase pipeline used in for Real World Evidence
Generation with the R package ecosystem for conducting studies with OMOP Common
Data Model databases

```mermaid
flowchart TD
    subgraph "Phase 1: Data Connection & Exploration"
        A["OMOP CDM Database"] --> B["cdmFromCon()"]
        B --> C["summariseOmopSnapshot()"]
        C --> D["summariseClinicalRecords()"]
    end

    subgraph "Phase 2: Concept & Population Definition"
        D --> E["getDrugIngredientCodes()"]
        D --> F["getCandidateCodes()"]
        E --> G["conceptCohort()"]
        F --> G
        G --> H["phenotypeR validation"]
    end

    subgraph "Phase 3: Population Analysis"
        H --> I["summariseCharacteristics()"]
        I --> J["summariseCohortAttrition()"]
    end

    subgraph "Phase 4: Specialized Studies"
        J --> K["summariseIncidencePrevalence()"]
        J --> L["summariseDrugUtilisation()"]
        J --> M["summariseSurvival()"]
    end

    subgraph "Phase 5: Results & Validation"
        K --> N["summarised_result objects"]
        L --> N
        M --> N
        N --> O["tableCharacteristics()"]
        N --> P["plotCharacteristics()"]
    end

    style B fill:#e1f5fe
    style G fill:#e8f5e8
    style I fill:#f3e5f5
    style N fill:#fff3e0
```


