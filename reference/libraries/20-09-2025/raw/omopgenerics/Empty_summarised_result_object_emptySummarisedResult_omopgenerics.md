# Empty summarised_result object. — emptySummarisedResult • omopgenerics

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



# Empty `summarised_result` object.

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`emptySummarisedResult.Rd`

Empty `summarised_result` object.

## Usage
    
    
    emptySummarisedResult(settings = NULL)

## Arguments

settings
    

Tibble/data.frame with the settings of the empty summarised_result. It has to contain at least `result_id` column.

## Value

An empty `summarised_result` object.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    emptySummarisedResult()
    #> # A tibble: 0 × 13
    #> # ℹ 13 variables: result_id <int>, cdm_name <chr>, group_name <chr>,
    #> #   group_level <chr>, strata_name <chr>, strata_level <chr>,
    #> #   variable_name <chr>, variable_level <chr>, estimate_name <chr>,
    #> #   estimate_type <chr>, estimate_value <chr>, additional_name <chr>,
    #> #   additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
