# Changelog • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/NEWS.md)

## DrugUtilisation 1.0.4

CRAN release: 2025-07-02

  * Fix plotDrugUtilisation combining different cdm_name by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 1.0.3

CRAN release: 2025-06-03

  * Skip some tests for regression in duckdb by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 1.0.2

CRAN release: 2025-05-13

  * Add examples of atc and ingredient documentation by [@catalamarti](https://github.com/catalamarti)
  * Add summariseTreatment input information in vignette by [@KimLopezGuell](https://github.com/KimLopezGuell)
  * Drug restart documentation by [@KimLopezGuell](https://github.com/KimLopezGuell)
  * Add drug utilisation documentation by [@KimLopezGuell](https://github.com/KimLopezGuell)
  * Update equation daily dose vignette by [@KimLopezGuell](https://github.com/KimLopezGuell)
  * Compatibility with omopgenerics 1.2.0 by [@catalamarti](https://github.com/catalamarti)
  * Homogenise examples by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 1.0.1

CRAN release: 2025-04-15

  * lifecycle stable by [@catalamarti](https://github.com/catalamarti)
  * Correct settings to not be NA by [@catalamarti](https://github.com/catalamarti)
  * add .options argument by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 1.0.0

CRAN release: 2025-03-27

  * Stable release.
  * plotPPC between 0 and 100% by [@catalamarti](https://github.com/catalamarti)
  * add observation_period_id in erafy by [@catalamarti](https://github.com/catalamarti)
  * use window_name as factor in plotTreatment/Indication by [@catalamarti](https://github.com/catalamarti)
  * remove lifecycle tags 1.0.0 by [@catalamarti](https://github.com/catalamarti)
  * use mockDisconnect in all tests by [@catalamarti](https://github.com/catalamarti)
  * Change default of tables to hide all settings by [@catalamarti](https://github.com/catalamarti)
  * Test validateNameStyle by [@catalamarti](https://github.com/catalamarti)
  * update requirePriorDrugWashout to <= to align with IncidencePrevalence by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.8.3

CRAN release: 2025-03-20

  * Add +1L to initialExposureDuration to calculate duration as `end - start + 1` by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.8.2

CRAN release: 2025-01-16

  * Fix snowflake edge case with duplicated prescriptions by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.8.1

CRAN release: 2024-12-19

  * Arguments recorded in summarise* functions by [@catalamarti](https://github.com/catalamarti)
  * Improved performance of addIndication, addTreatment, summariseIndication, summariseTreatment by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.8.0

CRAN release: 2024-12-10

### New features

  * Add argument … to generateATC/IngredientCohortSet by [@catalamarti](https://github.com/catalamarti)
  * benchmarkDrugUtilisation to test all functions by [@MimiYuchenGuo](https://github.com/MimiYuchenGuo)
  * Add confidence intervals to PPC by [@catalamarti](https://github.com/catalamarti)
  * Export erafyCohort by [@catalamarti](https://github.com/catalamarti)
  * Add numberExposures and daysPrescribed to generate functions by [@catalamarti](https://github.com/catalamarti)
  * Add subsetCohort and subsetCohortId arguments to cohort creation functions by [@catalamarti](https://github.com/catalamarti)
  * New function: addDrugRestart by [@catalamarti](https://github.com/catalamarti)
  * Add initialExposureDuration by [@catalamarti](https://github.com/catalamarti)
  * add cohortId to summarise* functions by [@catalamarti](https://github.com/catalamarti)
  * addDaysPrescribed by [@catalamarti](https://github.com/catalamarti)
  * plotDrugUtilisation by [@catalamarti](https://github.com/catalamarti)



### Minor updates

  * Account for omopgenerics 0.4.0 by [@catalamarti](https://github.com/catalamarti)
  * Add messages about dropped records in cohort creation by [@catalamarti](https://github.com/catalamarti)
  * Refactor of table functions following visOmopResults 0.5.0 release by [@catalamart](https://github.com/catalamart)
  * Cast settings to characters by [@catalamarti](https://github.com/catalamarti)
  * checkVersion utility function for tables and plots by [@catalamarti](https://github.com/catalamarti)
  * Deprecation warnings to errors for deprecated arguments in geenrateDrugUtilisation by [@catalamarti](https://github.com/catalamarti)
  * Add message if too many indications by [@catalamarti](https://github.com/catalamarti)
  * not treated -> untreated by [@catalamarti](https://github.com/catalamarti)
  * warn overwrite columns by [@catalamarti](https://github.com/catalamarti)
  * Use omopgenerics assert function by [@catalamarti](https://github.com/catalamarti)
  * add documentation helpers for consistent argument documentation by [@catalamarti](https://github.com/catalamarti)
  * exposedTime -> daysExposed by [@catalamarti](https://github.com/catalamarti)
  * Fix cast warning in mock by [@catalamarti](https://github.com/catalamarti)
  * test addDaysPrescribed by [@catalamarti](https://github.com/catalamarti)
  * refactor plots to use visOmopResults plot tools by [@catalamarti](https://github.com/catalamarti)



### Bug fix

  * allow integer64 in sampleSize by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.7.0

CRAN release: 2024-07-29

  * Deprecate dose specific functions: `addDailyDose`, `addRoute`, `stratifyByUnit`.

  * Deprecate drug use functions: `addDrugUse`, `summariseDrugUse`.

  * Rename `dailyDoseCoverage` -> `summariseDoseCoverage`.

  * Refactor of `addIndication` to create a categorical variable per window.

  * New functionality `summariseProportionOfPatientsCovered`, `tableProportionOfPatientsCovered` and `plotProportionOfPatientsCovered`.

  * Create `require*` functions.

  * New functionality `summariseDrugRestart`, `tableDrugRestart` and `plotDrugRestart`.

  * New functionality `addDrugUtilisation`, `summariseDrugUtilisation` and `tableDrugUtilisation`




## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
