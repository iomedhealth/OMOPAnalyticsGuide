# Create an achilles table from a cdm_table. — newAchillesTable • omopgenerics

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



# Create an achilles table from a cdm_table.

Source: [`R/classAchillesTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classAchillesTable.R)

`newAchillesTable.Rd`

Create an achilles table from a cdm_table.

## Usage
    
    
    newAchillesTable(table, version = "5.3", cast = FALSE)

## Arguments

table
    

A cdm_table.

version
    

version of the cdm.

cast
    

Whether to cast columns to the correct type.

## Value

An achilles_table object

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
