# Print a codelist with details — print.codelist_with_details • omopgenerics

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



# Print a codelist with details

Source: [`R/classCodelistWithDetails.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCodelistWithDetails.R)

`print.codelist_with_details.Rd`

Print a codelist with details

## Usage
    
    
    # S3 method for class 'codelist_with_details'
    [print](https://rdrr.io/r/base/print.html)(x, ...)

## Arguments

x
    

A codelist with details

...
    

Included for compatibility with generic. Not used.

## Value

Invisibly returns the input

## Examples
    
    
    codes <- [list](https://rdrr.io/r/base/list.html)("disease X" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3),
      other = [c](https://rdrr.io/r/base/c.html)("a", "b", "c")
    ))
    codes <- [newCodelistWithDetails](newCodelistWithDetails.html)(codes)
    [print](https://rdrr.io/r/base/print.html)(codes)
    #> 
    #> ── 1 codelist with details ─────────────────────────────────────────────────────
    #> 
    #> - disease X (3 codes)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
