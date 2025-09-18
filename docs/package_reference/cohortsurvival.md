---
layout: default
title: CohortSurvival
parent: R Package Reference
nav_order: 9
---

# CohortSurvival

Provides survival analysis capabilities for time-to-event studies using OMOP CDM cohorts.

## Capabilities:

- Time-to-event analysis
- Survival curve generation
- Cox proportional hazards modeling
- Integration with cohort tables

## Core Function Parameters

### `estimateSingleEventSurvival()`

| Parameter | Purpose | Default |
| --- | --- | --- |
| `targetCohortTable`| Cohort table name for analysis population| Required |
| `outcomeCohortTable`| Cohort table name for outcome events| Required |
| `outcomeDateVariable`| Date variable for outcome ("cohort_start_date" or "cohort_end_date")| "cohort_start_date" |
| `outcomeWashout`| Days of washout for outcome events| Inf |
| `censorOnCohortExit`| Whether to censor at cohort exit| FALSE |
| `followUpDays`| Maximum follow-up period| Inf |
| `eventGap`| Days for event aggregation| 30 |
| `strata`| List of stratification variables| NULL |

### Visualization Functions

- `plotSurvival()`: Produces Kaplan-Meier curves with options for `ribbon`, `facet`, `colour`, `cumulativeFailure`, and `riskTable`
- `riskTable()`: Displays number at risk, events, and censored by time intervals
- `tableSurvival()`: Summarizes survival estimates at specified time points
