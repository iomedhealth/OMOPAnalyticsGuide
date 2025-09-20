# Concept sets • omopgenerics

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



# Concept sets

Source: [`vignettes/codelists.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/codelists.Rmd)

`codelists.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))

## Codelist

A concept set can be represented as either a codelist or a concept set expression. A codelist is a named list, with each item of the list containing specific concept IDs.
    
    
    condition_codes <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = [c](https://rdrr.io/r/base/c.html)(201820, 4087682, 3655269),
      "asthma" = 317009
    )
    condition_codes <- [newCodelist](../reference/newCodelist.html)(condition_codes)
    #> Warning: ! `codelist` casted to integers.
    
    condition_codes
    #> 
    #> - asthma (1 codes)
    #> - diabetes (3 codes)

A codelist must be named
    
    
    condition_codes <- [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(201820, 4087682, 3655269))
    [newCodelist](../reference/newCodelist.html)(condition_codes)
    #> Error in `newCodelist()`:
    #> ✖ `codelist` must be named.
    #> ! `codelist` must be a list with objects of class numeric, integer, and
    #>   integer64; it can not contain NA; it has to be named; it can not be NULL.

And a codelist cannot have missing values
    
    
    condition_codes <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = [c](https://rdrr.io/r/base/c.html)(201820, NA, 3655269),
      "asthma" = 317009
    )
    [newCodelist](../reference/newCodelist.html)(condition_codes)
    #> Warning: ! `codelist` casted to integers.
    #> Error in `validateCodelist()`:
    #> ✖ 1 codelist contain NA: `diabetes`.

## Concept set expression

A concept set expression provides a high-level definition of concepts that, when applied to a specific OMOP CDM vocabulary version (by making use of the concept hierarchies and relationships), will result in a codelist.
    
    
    condition_cs <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(201820, 4087682),
        "excluded" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE),
        "descendants" = [c](https://rdrr.io/r/base/c.html)(TRUE, FALSE),
        "mapped" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE)
      ),
      "asthma" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = 317009,
        "excluded" = FALSE,
        "descendants" = FALSE,
        "mapped" = FALSE
      )
    )
    condition_cs <- [newConceptSetExpression](../reference/newConceptSetExpression.html)(condition_cs)
    
    condition_cs
    #> 
    #> - asthma (1 concept criteria)
    #> - diabetes (2 concept criteria)

As with a codelist, a concept set expression must be a named list and cannot have missing elements.
    
    
    condition_cs <- [list](https://rdrr.io/r/base/list.html)(
      dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(201820, NA),
        "excluded" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE),
        "descendants" = [c](https://rdrr.io/r/base/c.html)(TRUE, FALSE),
        "mapped" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE)
      )
    )
    [newConceptSetExpression](../reference/newConceptSetExpression.html)(condition_cs)
    #> Error in `newConceptSetExpression()`:
    #> ✖ `x` must be named.
    #> ! `x` must be a list with objects of class tbl; it can not contain NA; it has
    #>   to be named; it can not be NULL.
    
    
    condition_cs <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(201820, NA),
        "excluded" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE),
        "descendants" = [c](https://rdrr.io/r/base/c.html)(TRUE, FALSE),
        "mapped" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE)
      ),
      "asthma" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = 317009,
        "excluded" = FALSE,
        "descendants" = FALSE,
        "mapped" = FALSE
      )
    )
    [newConceptSetExpression](../reference/newConceptSetExpression.html)(condition_cs)
    #> Error in `newConceptSetExpression()`:
    #> ✖ `x[[i]]$concept_id` contains NA in position 2.
    #> ! `x[[i]]$concept_id` must be an integerish numeric; it can not contain NA; it
    #>   can not be NULL.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
