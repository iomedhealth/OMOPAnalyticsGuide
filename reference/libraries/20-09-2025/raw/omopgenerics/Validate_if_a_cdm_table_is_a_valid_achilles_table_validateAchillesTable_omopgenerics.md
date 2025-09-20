# Validate if a cdm_table is a valid achilles table. — validateAchillesTable • omopgenerics

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



# Validate if a cdm_table is a valid achilles table.

Source: [`R/classAchillesTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classAchillesTable.R)

`validateAchillesTable.Rd`

Validate if a cdm_table is a valid achilles table.

## Usage
    
    
    validateAchillesTable(
      table,
      version = NULL,
      cast = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

table
    

A cdm_table to validate.

version
    

The cdm vocabulary version.

cast
    

Whether to cast columns to required type.

call
    

Passed to cli call.

## Value

invisible achilles table

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
