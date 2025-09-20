# Status of the indexes — statusIndexes • omopgenerics

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



# Status of the indexes

Source: [`R/indexes.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/indexes.R)

`statusIndexes.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    statusIndexes(cdm, name = NULL)

## Arguments

cdm
    

A cdm_reference object.

name
    

Name(s) of the cdm tables.

## Value

A tibble with 3 columns: `table_class` class of the table, `table_name` name of the table, `index` index definition, and `index_status` status of the index, either: 'missing', 'extra', 'present'.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
