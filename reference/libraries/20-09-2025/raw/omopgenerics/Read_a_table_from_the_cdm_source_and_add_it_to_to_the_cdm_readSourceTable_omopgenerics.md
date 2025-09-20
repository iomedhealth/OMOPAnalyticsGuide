# Read a table from the cdm_source and add it to to the cdm. — readSourceTable • omopgenerics

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



# Read a table from the cdm_source and add it to to the cdm.

Source: [`R/methodReadSourceTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodReadSourceTable.R)

`readSourceTable.Rd`

Read a table from the cdm_source and add it to to the cdm.

## Usage
    
    
    readSourceTable(cdm, name)

## Arguments

cdm
    

A cdm reference.

name
    

Name of a table to read in the cdm_source space.

## Value

A cdm_reference with new table.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
