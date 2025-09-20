# Changelog • omopgenerics

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/NEWS.md)

## omopgenerics 1.3.1

CRAN release: 2025-09-18

  * The time a query takes to copute is included in log file by [@edward-burn](https://github.com/edward-burn) in [#737](https://github.com/darwin-eu/omopgenerics/issues/737)
  * Create emptyConceptSetExpression function by [@edward-burn](https://github.com/edward-burn) [#735](https://github.com/darwin-eu/omopgenerics/issues/735)
  * Empty codelist has class codelist by [@edward-burn](https://github.com/edward-burn) in [#734](https://github.com/darwin-eu/omopgenerics/issues/734)
  * Correct typo for condition_era_id by [@catalamarti](https://github.com/catalamarti) in [#727](https://github.com/darwin-eu/omopgenerics/issues/727)
  * Add … argument to insertTable by [@catalamarti](https://github.com/catalamarti) in [#725](https://github.com/darwin-eu/omopgenerics/issues/725)
  * observation_period and person are no longer required in the cdm object [@catalamarti](https://github.com/catalamarti) [#746](https://github.com/darwin-eu/omopgenerics/issues/746)
  * Create function `[omopDataFolder()](../reference/omopDataFolder.html)` for the management of OMOP related data [@catalamarti](https://github.com/catalamarti) [#747](https://github.com/darwin-eu/omopgenerics/issues/747)
  * Remove `tictoc` from suggests and use base R by [@catalamarti](https://github.com/catalamarti) [#748](https://github.com/darwin-eu/omopgenerics/issues/748)
  * Support end and start date for table payer_plan_period by [@catalamarti](https://github.com/catalamarti) [#749](https://github.com/darwin-eu/omopgenerics/issues/749)
  * validate cohortId in recordCohortAttrition by [@catalamarti](https://github.com/catalamarti) [#750](https://github.com/darwin-eu/omopgenerics/issues/750)
  * Add separate vignette for suppression by [@catalamarti](https://github.com/catalamarti) [#751](https://github.com/darwin-eu/omopgenerics/issues/751)
  * Depend on dbplyr 2.5.1 to be able to use the new translations of clock by [@catalamarti](https://github.com/catalamarti) [#754](https://github.com/darwin-eu/omopgenerics/issues/754)
  * Add methods to support local datasets by [@catalamarti](https://github.com/catalamarti) in [#757](https://github.com/darwin-eu/omopgenerics/issues/757)
  * Cast columns for local cdms by [@catalamarti](https://github.com/catalamarti) [#758](https://github.com/darwin-eu/omopgenerics/issues/758)



## omopgenerics 1.3.0

CRAN release: 2025-07-15

  * write method fro summary.cdm_source by [@catalamarti](https://github.com/catalamarti) in [#719](https://github.com/darwin-eu/omopgenerics/issues/719) [#720](https://github.com/darwin-eu/omopgenerics/issues/720)
  * Add query id in logging files by [@catalamarti](https://github.com/catalamarti) in [#716](https://github.com/darwin-eu/omopgenerics/issues/716)
  * Expanding omopgenerics vignette by [@catalamarti](https://github.com/catalamarti) in [#721](https://github.com/darwin-eu/omopgenerics/issues/721)
  * Indexes experimental functions by [@catalamarti](https://github.com/catalamarti) in [#722](https://github.com/darwin-eu/omopgenerics/issues/722) [#723](https://github.com/darwin-eu/omopgenerics/issues/723) [#724](https://github.com/darwin-eu/omopgenerics/issues/724)



## omopgenerics 1.2.0

CRAN release: 2025-05-19

  * Remove NA in estimates in transformToSummarisedResult by [@catalamarti](https://github.com/catalamarti) in [#702](https://github.com/darwin-eu/omopgenerics/issues/702)
  * Create logging functions by [@catalamarti](https://github.com/catalamarti) in [#700](https://github.com/darwin-eu/omopgenerics/issues/700)
  * Allow strata to be a character by [@catalamarti](https://github.com/catalamarti) in [#703](https://github.com/darwin-eu/omopgenerics/issues/703)
  * Remove settings that are NA after filterSettings by [@catalamarti](https://github.com/catalamarti) in [#704](https://github.com/darwin-eu/omopgenerics/issues/704)
  * `validateWindowArgument` force snake_case names by [@catalamarti](https://github.com/catalamarti) in [#711](https://github.com/darwin-eu/omopgenerics/issues/711)
  * Keep cohort_table class after collect by [@catalamarti](https://github.com/catalamarti) in [#710](https://github.com/darwin-eu/omopgenerics/issues/710)
  * `[dplyr::as_tibble](https://tibble.tidyverse.org/reference/as_tibble.html)` for codelist by [@catalamarti](https://github.com/catalamarti) in [#712](https://github.com/darwin-eu/omopgenerics/issues/712)
  * `type` -> `codelist_type` by [@catalamarti](https://github.com/catalamarti) in [#709](https://github.com/darwin-eu/omopgenerics/issues/709)



## omopgenerics 1.1.1

CRAN release: 2025-03-16

  * more general validation for cohorts by [@edward-burn](https://github.com/edward-burn) in [#692](https://github.com/darwin-eu/omopgenerics/issues/692)
  * change `grepl` to `[stringr::str_detect](https://stringr.tidyverse.org/reference/str_detect.html)` by [@catalamarti](https://github.com/catalamarti) in [#689](https://github.com/darwin-eu/omopgenerics/issues/689)
  * allow `[readr::guess_encoding](https://readr.tidyverse.org/reference/encoding.html)` to fail and default configuration by [@catalamarti](https://github.com/catalamarti) in [#685](https://github.com/darwin-eu/omopgenerics/issues/685)
  * keep codelist class when subsetting by [@catalamarti](https://github.com/catalamarti) in [#693](https://github.com/darwin-eu/omopgenerics/issues/693)
  * export summarised_results always as utf8 by [@catalamarti](https://github.com/catalamarti) in [#690](https://github.com/darwin-eu/omopgenerics/issues/690)
  * add option checkPermanentTable to `validateCohortArgument` by [@catalamarti](https://github.com/catalamarti) in [#694](https://github.com/darwin-eu/omopgenerics/issues/694)



## omopgenerics 1.1.0

CRAN release: 2025-02-25

  * more general cdm validation checks by [@edward-burn](https://github.com/edward-burn) in [#674](https://github.com/darwin-eu/omopgenerics/issues/674)
  * typo in validateConceptSet by [@catalamarti](https://github.com/catalamarti) in [#673](https://github.com/darwin-eu/omopgenerics/issues/673)
  * fix call argument by [@catalamarti](https://github.com/catalamarti) in [#677](https://github.com/darwin-eu/omopgenerics/issues/677)
  * fix tempdir(“…”) by [@catalamarti](https://github.com/catalamarti) in [#679](https://github.com/darwin-eu/omopgenerics/issues/679)
  * new function transformToSummarisedResult by [@catalamarti](https://github.com/catalamarti) in [#676](https://github.com/darwin-eu/omopgenerics/issues/676)



## omopgenerics 1.0.0

CRAN release: 2025-02-14

  * Stable release of the package.
  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
