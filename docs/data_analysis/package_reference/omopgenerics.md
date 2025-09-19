---
layout: default
title: omopgenerics
parent: Package Reference
nav_order: 1
---

# [omopgenerics](https://darwin-eu.github.io/omopgenerics/)

The [`omopgenerics`](https://darwin-eu.github.io/omopgenerics/) package provides core data structures and generic functions that standardize how OMOP data is represented and manipulated across the ecosystem.

## Key Data Classes

- **`<cdm_reference>`**: Represents a connection to an OMOP CDM database.
- **`<cdm_table>`**: Individual tables within the CDM.
- **`<cohort_table>`**: Patient cohorts with required columns:
  - `cohort_definition_id` - Unique identifier for each cohort
  - `subject_id` - Unique patient identifier
  - `cohort_start_date` - Date when person enters cohort
  - `cohort_end_date` - Date when person exits cohort
- **`<summarised_result>`**: Standardized output format containing 13 columns for analysis results.

## Core Generic Functions

### Result Manipulation:

- `settings()` - Access cohort settings and metadata
- `attrition()` - Access cohort attrition information
- `cohortCount()` - Get cohort record and subject counts
- `splitGroup()`, `splitStrata()`, `splitAdditional()` - Split grouped columns
- `pivotEstimates()` - Pivot estimate columns to wide format
- `tidy()` - Convert to tidy format
- `filterStrata()` - Filter by strata conditions
