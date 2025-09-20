# Validate an omop_table — validateOmopTable • omopgenerics

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



# Validate an omop_table

Source: [`R/classOmopTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classOmopTable.R)

`validateOmopTable.Rd`

Validate an omop_table

## Usage
    
    
    validateOmopTable(
      omopTable,
      version = NULL,
      cast = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

omopTable
    

An omop_table to check.

version
    

The version of the cdm.

cast
    

Whether to cast columns to the correct type.

call
    

Call argument that will be passed to `cli` error message.

## Value

An omop_table object.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
