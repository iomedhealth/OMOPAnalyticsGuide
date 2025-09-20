# Convert a table that is not a cdm_table but have the same original source to a cdm_table. This Table is not meant to be used to insert tables in the cdm, please use insertTable instead. — insertFromSource • omopgenerics

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



# Convert a table that is not a cdm_table but have the same original source to a cdm_table. This Table is not meant to be used to insert tables in the cdm, please use insertTable instead.

Source: [`R/methodInsertFromSource.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodInsertFromSource.R)

`insertFromSource.Rd`

[![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## Usage
    
    
    insertFromSource(cdm, value)

## Arguments

cdm
    

A cdm_reference object.

value
    

A table that shares source with the cdm_reference object.

## Value

A table in the cdm_reference environment

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
