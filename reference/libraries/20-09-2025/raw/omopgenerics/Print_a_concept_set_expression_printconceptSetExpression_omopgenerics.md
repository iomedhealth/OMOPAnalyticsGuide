# Print a concept set expression — print.conceptSetExpression • omopgenerics

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



# Print a concept set expression

Source: [`R/classConceptSetExpression.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classConceptSetExpression.R)

`print.conceptSetExpression.Rd`

Print a concept set expression

## Usage
    
    
    # S3 method for class 'conceptSetExpression'
    [print](https://rdrr.io/r/base/print.html)(x, ...)

## Arguments

x
    

A concept set expression

...
    

Included for compatibility with generic. Not used.

## Value

Invisibly returns the input

## Examples
    
    
    asthma_cs <- [list](https://rdrr.io/r/base/list.html)(
      "asthma_narrow" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = 1,
        "excluded" = FALSE,
        "descendants" = TRUE,
        "mapped" = FALSE
      ),
      "asthma_broad" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(1, 2),
        "excluded" = FALSE,
        "descendants" = TRUE,
        "mapped" = FALSE
      )
    )
    asthma_cs <- [newConceptSetExpression](newConceptSetExpression.html)(asthma_cs)
    [print](https://rdrr.io/r/base/print.html)(asthma_cs)
    #> 
    #> ── 2 concept set expressions ───────────────────────────────────────────────────
    #> 
    #> - asthma_broad (2 concept criteria)
    #> - asthma_narrow (1 concept criteria)
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
