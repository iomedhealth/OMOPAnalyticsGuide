---
layout: default
title: CohortCharacteristics
parent: R Package Reference
nav_order: 5
---

# CohortCharacteristics

Characterizes and analyzes patient cohorts with comprehensive summary statistics and visualizations.

## Summary Functions

### Core Characterization:

- `summariseCharacteristics(strata, cohortId, ageGroup, tableIntersect, cohortIntersect, conceptIntersect)` - Generate comprehensive cohort characteristics
- `summariseLargeScaleCharacteristics(window, eventInWindow, minimumFrequency)` - Summarize all clinical events in time windows
- `summariseCohortTiming(restrictToFirstEntry)` - Analyze timing between cohort entries
- `summariseCohortOverlap()` - Analyze overlap between multiple cohorts
- `summariseCohortAttrition()` - Generate cohort attrition summaries

## Table Functions

### Formatted Output:

- `tableCharacteristics(result, header)` - Create formatted characteristic tables
- `tableLargeScaleCharacteristics(result)` - Format large-scale characteristic results
- `tableTopLargeScaleCharacteristics(result, topConcepts)` - Show top concepts from large-scale analysis
- `tableCohortOverlap(result)` - Format cohort overlap tables
- `tableCohortTiming(result, timeScale, uniqueCombinations)` - Format timing analysis tables
- `tableCohortAttrition(result)` - Format attrition tables

## Visualization Functions

### Plotting Capabilities:

- `plotCharacteristics(result, plotStyle, facet, colour)` - Create characteristic plots (boxplot, barplot)
- `plotCohortOverlap(result, uniqueCombinations)` - Visualize cohort overlaps
- `plotCohortTiming(result, plotType, timeScale, uniqueCombinations)` - Create timing plots (boxplot, densityplot)
- `plotCohortAttrition(result, type)` - Generate attrition flowcharts
