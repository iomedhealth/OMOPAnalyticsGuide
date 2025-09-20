# Drop a table from a cdm object. — dropSourceTable • omopgenerics

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



# Drop a table from a cdm object.

Source: [`R/methodDropSourceTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodDropSourceTable.R)

`dropSourceTable.Rd`

Drop a table from a cdm object.

## Usage
    
    
    dropSourceTable(cdm, name)

## Arguments

cdm
    

A cdm reference.

name
    

Name(s) of the table(s) to insert. Tidyselect statements are supported.

## Value

The table in the cdm reference.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
