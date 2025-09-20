# Changelog • CohortCharacteristics

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/NEWS.md)

## CohortCharacteristics 1.0.0

CRAN release: 2025-05-20

  * Stable release of the package



### New features

  * includeSource -> pair standard and source concepts in LSC by [@catalamarti](https://github.com/catalamarti) in [#329](https://github.com/darwin-eu/CohortCharacteristics/issues/329)
  * new function tableTopLargeScaleCharacteristics by [@catalamarti](https://github.com/catalamarti) in [#335](https://github.com/darwin-eu/CohortCharacteristics/issues/335)
  * refactor function tableLargeScaleCharacteristics by [@catalamarti](https://github.com/catalamarti) in [#335](https://github.com/darwin-eu/CohortCharacteristics/issues/335)
  * summariseCohortCodelist by [@catalamarti](https://github.com/catalamarti) in [#333](https://github.com/darwin-eu/CohortCharacteristics/issues/333)



### Minor fixes

  * fixes filter group by [@ilovemane](https://github.com/ilovemane) in [#313](https://github.com/darwin-eu/CohortCharacteristics/issues/313)
  * fixes tableintersect suppression problem by [@ilovemane](https://github.com/ilovemane) in [#311](https://github.com/darwin-eu/CohortCharacteristics/issues/311)
  * add .options for table functions by [@ilovemane](https://github.com/ilovemane) in [#319](https://github.com/darwin-eu/CohortCharacteristics/issues/319)
  * density plot for plotCharacteristics by [@ilovemane](https://github.com/ilovemane) in [#320](https://github.com/darwin-eu/CohortCharacteristics/issues/320)
  * use og functions instead of vor by [@catalamarti](https://github.com/catalamarti) in [#332](https://github.com/darwin-eu/CohortCharacteristics/issues/332)
  * improvement on vignettes. by [@ilovemane](https://github.com/ilovemane) in [#327](https://github.com/darwin-eu/CohortCharacteristics/issues/327)
  * Require-minimum-count-for-plot-timing by [@ilovemane](https://github.com/ilovemane) in [#318](https://github.com/darwin-eu/CohortCharacteristics/issues/318)
  * Fix suppressed count print by [@catalamarti](https://github.com/catalamarti) in [#334](https://github.com/darwin-eu/CohortCharacteristics/issues/334)



## CohortCharacteristics 0.5.1

CRAN release: 2025-03-27

  * Fix bug in plotCohortAttrition to not display NAs by [@martaalcalde](https://github.com/martaalcalde)
  * Throw error if cohort table is the input of plotCohortAttrition() by [@catalamarti](https://github.com/catalamarti)



## CohortCharacteristics 0.5.0

CRAN release: 2025-03-18

  * Update benchmarkCohortCharacteristics.R by [@cecicampanile](https://github.com/cecicampanile)
  * fix typo in tableLargeScaleCharacteristics by [@catalamarti](https://github.com/catalamarti)
  * fix typo in source_type by [@catalamarti](https://github.com/catalamarti)
  * `summariseCharacteristics` cohort by cohort by [@cecicampanile](https://github.com/cecicampanile)
  * Allow multiple cdm and cohorts in plotCohortAttrition + png format by [@catalamarti](https://github.com/catalamarti)
  * Stack bar in plotCohortOverlap by [@ilovemane](https://github.com/ilovemane)
  * variable_name as factor in plotCohortOverlap by [@catalamarti](https://github.com/catalamarti)
  * none -> unknown in summariseCharacteristics by [@catalamarti](https://github.com/catalamarti)
  * Add weights argument to `summariseCharacteristics` by [@catalamarti](https://github.com/catalamarti)
  * Use filterCohortId when needed by [@catalamarti](https://github.com/catalamarti)
  * Fix ’ character in plotCohortAttrition by [@catalamarti](https://github.com/catalamarti)
  * filter excludeCodes at the end by [@catalamarti](https://github.com/catalamarti)
  * use <minCellCount in tables by [@catalamarti](https://github.com/catalamarti)



## CohortCharacteristics 0.4.0

CRAN release: 2024-11-26

  * Update links darwin-eu-dev -> darwin-eu [@catalamarti](https://github.com/catalamarti)
  * Typo in plotCohortAttrition by [@martaalcalde](https://github.com/martaalcalde)
  * uniqueCombination parameter to work in a general way [@catalamarti](https://github.com/catalamarti)
  * minimum 5 days in x axis for density plots [@catalamarti](https://github.com/catalamarti)
  * improve documentation of minimumFrequency by [@catalamarti](https://github.com/catalamarti)
  * add show argument to plotCohortAttrition by [@catalamarti](https://github.com/catalamarti)
  * simplify code for overlap and fix edge case with 0 overlap by [@catalamarti](https://github.com/catalamarti)
  * arrange ageGroups by order that they are provided in summariseCharacteristics by [@catalamarti](https://github.com/catalamarti)
  * otherVariablesEstimates -> estimates in summariseCharacteristics by [@catalamarti](https://github.com/catalamarti)
  * add overlapBy argument to summariseCohortOverlap by [@catalamarti](https://github.com/catalamarti)
  * Compatibility with visOmopResults 0.5.0 and omopgenerics 0.4.0 by [@catalamarti](https://github.com/catalamarti)
  * add message if different pkg versions by [@catalamarti](https://github.com/catalamarti)
  * make sure settings are characters by [@catalamarti](https://github.com/catalamarti)
  * use requireEunomia and CDMConnector 1.6.0 by [@catalamarti](https://github.com/catalamarti)
  * add benchmark function by [@catalamarti](https://github.com/catalamarti)
  * Consistent documentation by [@catalamarti](https://github.com/catalamarti)
  * Use subjects only when overlapBy = “subject_id” by [@catalamarti](https://github.com/catalamarti)
  * add cohortId to LSC by [@catalamarti](https://github.com/catalamarti)



## CohortCharacteristics 0.3.0

CRAN release: 2024-10-01

  * **breaking change** Complete refactor of `table*` and `plot*` functions following visOmopResults 0.4.0 release.
  * `summarise*` functions output is always ordered in the same way.
  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
