---
layout: page
title: DrugUtilisation
parent: R Package Reference
nav_order: 8
---

# DrugUtilisation

Specialized package for medication exposure studies and drug utilization patterns.

## Focus Areas:

- Medication adherence analysis
- Drug exposure patterns
- Prescription analytics
- Integration with Darwin-EU catalogue

## Key Functions and Parameters

### Drug Cohort Construction

The `conceptCohort()` function creates drug cohorts from OMOP concept sets, with `collapseCohorts()` using the `gapEra` parameter to concatenate records separated by specified days.

`gapEra`: Number of days between two continuous exposures to be considered in the same era. Records with fewer days between them will be concatenated.

### Inclusion Criteria Application Order

DrugUtilisation enforces a specific order for inclusion criteria application due to non-commutative operations:

1.  **Prior washout or first entry** : `requirePriorDrugWashout()` or `requireIsFirstDrugEntry()`
2.  **Prior observation** : `requirePriorObservation()`
3.  **Date range restriction** : `requireInDateRange()`

### Analysis Functions

| Function | Purpose | Key Parameters |
| --- | --- | --- |
| `summariseDrugUtilisation()`| Drug usage metrics| `ingredientConceptId`, `gapEra`, `numberExposures`, `daysExposed`, `cumulativeQuantity` |
| `summariseIndication()`| Mutually exclusive indications| `indicationWindow`, `unknownIndicationTable` |
| `summariseProportionOfPatientsCovered()`| Treatment persistence| `followUpDays` |
| `summariseDrugRestart()`| Drug switching and restart patterns| `switchCohortTable`, `followUpDays`, `restrictToFirstDiscontinuation` |
