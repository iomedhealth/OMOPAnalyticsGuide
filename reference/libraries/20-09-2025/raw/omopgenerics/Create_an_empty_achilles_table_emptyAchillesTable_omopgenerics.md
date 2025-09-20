# Create an empty achilles table — emptyAchillesTable • omopgenerics

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



# Create an empty achilles table

Source: [`R/classAchillesTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classAchillesTable.R)

`emptyAchillesTable.Rd`

Create an empty achilles table

## Usage
    
    
    emptyAchillesTable(cdm, name)

## Arguments

cdm
    

A cdm_reference to create the table.

name
    

Name of the table to create.

## Value

The cdm_reference with an achilles empty table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    cdm <- [emptyCdmReference](emptyCdmReference.html)("my_example_cdm")
    emptyAchillesTable(cdm = cdm, name = "achilles_results")
    #> 
    #> ── # OMOP CDM reference (local) of my_example_cdm ──────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: achilles_results
    #> • other tables: -
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
