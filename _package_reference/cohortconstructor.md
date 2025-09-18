---
layout: page
title: CohortConstructor
parent: R Package Reference
nav_order: 4
---

# CohortConstructor

Builds and curates study cohorts using a pipeline approach with four main function categories.

## Base Cohort Functions

### Primary Constructors:

- `demographicsCohort(cdm, ageRange, sex, minPriorObservation)` - Create demographic-based cohorts
- `conceptCohort(cdm, conceptSet)` - Create concept-based cohorts from clinical codes
- `measurementCohort()` - Create cohorts based on measurement values
- `deathCohort()` - Create cohorts based on death records

## Requirement and Filtering Functions

### Demographic Requirements:

- `requireDemographics(ageRange, sex, minPriorObservation)` - Apply demographic restrictions
- `requireAge(ageRange)` - Require specific age ranges
- `requireSex(sex)` - Require specific sex
- `requirePriorObservation(days)` - Require minimum prior observation
- `requireFutureObservation(days)` - Require minimum future observation

### Entry/Record Requirements:

- `requireIsFirstEntry()` - Keep only first record per person
- `requireIsLastEntry()` - Keep only last record per person
- `requireIsEntry(number)` - Keep specific entry number

### Intersection Requirements:

- `requireCohortIntersect(targetCohortTable, window, intersections)` - Require presence/absence in other cohorts
- `requireConceptIntersect(conceptSet, window, intersections)` - Require presence/absence of concepts
- `requireTableIntersect(tableName, window, intersections)` - Require presence/absence in OMOP tables
- `requireInDateRange(dateRange)` - Restrict to specific date ranges

## Date Manipulation Functions

### Exit Date Functions:

- `exitAtObservationEnd()` - Set exit at observation period end
- `exitAtDeath(requireDeath)` - Set exit at death date
- `exitAtFirstDate()` - Set exit at first occurrence of events
- `exitAtLastDate()` - Set exit at last occurrence of events

### Entry Date Functions:

- `entryAtFirstDate()` - Set entry at first occurrence
- `entryAtLastDate()` - Set entry at last occurrence

### Trimming and Padding:

- `trimDemographics(ageRange, minPriorObservation)` - Trim dates to demographic requirements
- `trimToDateRange(dateRange)` - Trim to specific date range
- `padCohortDate()` - Add padding to cohort dates
- `padCohortStart(days)` - Add padding to start dates
- `padCohortEnd(days)` - Add padding to end dates

## Transformation and Combination Functions

### Cohort Splitting:

- `yearCohorts(years)` - Split cohorts by calendar years
- `stratifyCohorts()` - Create stratified cohorts

### Cohort Combination:

- `unionCohorts()` - Combine multiple cohorts with union logic
- `intersectCohorts()` - Create intersection of cohorts
- `collapseCohorts(gap)` - Collapse records within specified gap days

### Cohort Manipulation:

- `matchCohorts()` - Match cohorts based on criteria
- `subsetCohorts()` - Subset existing cohorts
- `sampleCohorts()` - Random sampling of cohorts
- `renameCohort()` - Rename cohort definitions
- `copyCohorts()` - Create copies of cohorts
