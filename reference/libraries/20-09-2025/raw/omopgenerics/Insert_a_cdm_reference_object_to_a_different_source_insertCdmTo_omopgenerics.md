# Insert a cdm_reference object to a different source. — insertCdmTo • omopgenerics

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



# Insert a cdm_reference object to a different source.

Source: [`R/methodInsertCdmTo.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodInsertCdmTo.R)

`insertCdmTo.Rd`

Insert a cdm_reference object to a different source.

## Usage
    
    
    insertCdmTo(cdm, to)

## Arguments

cdm
    

A cdm_reference, if not local it will be collected into memory.

to
    

A cdm_source or another cdm_reference, with a valid cdm_source.

## Value

The first cdm_reference object inserted to the source.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
