# Restrict the cdm object to a subset of tables. — cdmSelect • omopgenerics

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



# Restrict the cdm object to a subset of tables.

Source: [`R/cdmSelect.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/cdmSelect.R)

`cdmSelect.Rd`

Restrict the cdm object to a subset of tables.

## Usage
    
    
    cdmSelect(cdm, ...)

## Arguments

cdm
    

A cdm_reference object.

...
    

Selection of tables to use, it supports tidyselect expressions.

## Value

A cdm_reference with only the specified tables.

## Examples
    
    
    cdm <- [emptyCdmReference](emptyCdmReference.html)("my cdm")
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of my cdm ──────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    cdm |>
      cdmSelect("person")
    #> 
    #> ── # OMOP CDM reference (local) of my cdm ──────────────────────────────────────
    #> • omop tables: person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
