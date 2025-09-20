# Print a codelist — print.codelist • omopgenerics

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



# Print a codelist

Source: [`R/classCodelist.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCodelist.R)

`print.codelist.Rd`

Print a codelist

## Usage
    
    
    # S3 method for class 'codelist'
    [print](https://rdrr.io/r/base/print.html)(x, ...)

## Arguments

x
    

A codelist

...
    

Included for compatibility with generic. Not used.

## Value

Invisibly returns the input

## Examples
    
    
    codes <- [list](https://rdrr.io/r/base/list.html)("disease X" = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), "disease Y" = [c](https://rdrr.io/r/base/c.html)(4, 5))
    codes <- [newCodelist](newCodelist.html)(codes)
    #> Warning: ! `codelist` casted to integers.
    [print](https://rdrr.io/r/base/print.html)(codes)
    #> 
    #> ── 2 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - disease X (3 codes)
    #> - disease Y (2 codes)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
