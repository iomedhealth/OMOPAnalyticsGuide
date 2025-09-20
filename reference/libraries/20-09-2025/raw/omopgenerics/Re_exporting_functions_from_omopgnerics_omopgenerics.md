# Re-exporting functions from omopgnerics • omopgenerics

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



# Re-exporting functions from omopgnerics

Source: [`vignettes/reexport.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/reexport.Rmd)

`reexport.Rmd`

## Introduction

**omopgenerics** is a package that is meant to be invisible for the user and it should be only developer focused package. This means that the typical user of the omopverse packages should never need to import directly it. This means that the functions needed to be used by the user they need to be reexported in other packages.

## Methods

If a package defined an implementation for a desired method (attrition, settings, …), this function should be reexported there.

## CDM reference

If a package has a function to create a `cdm_reference` object, this package should re-export several functions.

  1. To access the `cdm_reference` attributes:


  * `[cdmSource()](../reference/cdmSource.html)`

  * `[cdmVersion()](../reference/cdmVersion.html)`

  * `[cdmName()](../reference/cdmName.html)`



  2. To access the `cdm_table` attributes:


  * `[tableSource()](../reference/tableSource.html)`

  * `[tableName()](../reference/tableName.html)`

  * `[cdmReference()](../reference/cdmReference.html)`



  3. To insert and drop tables using the cdm object:


  * `[insertTable()](../reference/insertTable.html)`

  * `[dropSourceTable()](../reference/dropSourceTable.html)`

  * `listSourceTable()`

  * `[readSourceTable()](../reference/readSourceTable.html)`



  4. Helpers to create appropriate cdm tables:


  * `[omopColumns()](../reference/omopColumns.html)`

  * `[omopTables()](../reference/omopTables.html)`

  * `[cohortColumns()](../reference/cohortColumns.html)`

  * `[cohortTables()](../reference/cohortTables.html)`

  * `[achillesColumns()](../reference/achillesColumns.html)`

  * `[achillesTables()](../reference/achillesTables.html)`




## Cohorts

If a package has a function to create a `cohort_table` object, this package should re-export the following functions:

  * `[settings()](../reference/settings.html)`

  * `[attrition()](../reference/attrition.html)`

  * `[cohortCount()](../reference/cohortCount.html)`

  * `[cohortCodelist()](../reference/cohortCodelist.html)`

  * `[bind()](../reference/bind.html)`




## Summarised result

If a package has a function to create an `summarised_result` object, this package should re-export the following functions:

  * `[suppress()](../reference/suppress.html)`

  * `[bind()](../reference/bind.html)`

  * `[settings()](../reference/settings.html)`

  * `[exportSummarisedResult()](../reference/exportSummarisedResult.html)`

  * `[importSummarisedResult()](../reference/importSummarisedResult.html)`

  * `[groupColumns()](../reference/groupColumns.html)`

  * `[strataColumns()](../reference/strataColumns.html)`

  * `[additionalColumns()](../reference/additionalColumns.html)`




## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
