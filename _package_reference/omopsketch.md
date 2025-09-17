---
layout: page
title: OmopSketch
---

# OmopSketch

Provides comprehensive database characterization and quality assessment for OMOP CDM databases.

## Database Overview Functions

### Snapshot Analysis:

- `summariseOmopSnapshot(cdm)` - Generate real-time database overview including vocabulary version, table sizes, observation period span
- `tableOmopSnapshot(result, type)` - Format snapshot results into tables

## Observation Period Analysis

### Temporal Analysis:

- `summariseObservationPeriod(observationPeriod, sex)` - Analyze observation period characteristics including records per person, duration, gaps
- `summariseInObservation(observationPeriod, interval, output, ageGroup)` - Track trends over time intervals (years, quarters, months)
- `plotObservationPeriod(result, plotType, variableName, colour)` - Visualize observation period statistics
- `plotInObservation(result, colour, facet)` - Plot temporal trends

## Clinical Table Analysis

### Quality Assessment:

- `summariseMissingData(cdm, omopTableName, col, sample)` - Analyze missing data patterns and zero concept IDs
- `summariseClinicalRecords(cdm, omopTableName, recordsPerPerson, inObservation, standardConcept, sourceVocabulary, domainId, typeConcept)` - Comprehensive clinical table characterization
- `summariseRecordCount(cdm, omopTableName, interval, dateRange)` - Analyze record trends over time

### Concept Analysis:

- `summariseConceptIdCounts(cdm, omopTableName, countBy)` - Count records and subjects per concept ID
- `tableConceptIdCounts(result, display, type)` - Interactive tables of concept counts
- `tableTopConceptCounts(result, countBy, top, type)` - Display most frequent concepts

## Integrated Database Characterization

### Comprehensive Analysis:

- `databaseCharacteristics(cdm, omopTableName, sex, ageGroup, interval, dateRange, conceptIdCounts)` - Complete database characterization combining all analysis types
- `shinyCharacteristics(result, directory)` - Create interactive Shiny application for exploring results
