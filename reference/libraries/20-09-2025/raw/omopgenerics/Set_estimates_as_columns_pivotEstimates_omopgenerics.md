# Set estimates as columns — pivotEstimates • omopgenerics

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



# Set estimates as columns

Source: [`R/pivot.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/pivot.R)

`pivotEstimates.Rd`

Pivot the estimates as new columns in result table.

## Usage
    
    
    pivotEstimates(result, pivotEstimatesBy = "estimate_name", nameStyle = NULL)

## Arguments

result
    

A `<summarised_result>`.

pivotEstimatesBy
    

Names from which pivot wider the estimate values. If NULL the table will not be pivotted.

nameStyle
    

Name style (glue package specifications) to customise names when pivotting estimates. If NULL standard tidyr::pivot_wider formatting will be used.

## Value

A tibble.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = 1L,
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)()
    
      x |>
        pivotEstimates()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 11
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 cprd     cohort_name my_cohort   sex         male        
    #> 2         1 eunomia  cohort_name my_cohort   sex         male        
    #> # ℹ 5 more variables: variable_name <chr>, variable_level <chr>,
    #> #   additional_name <chr>, additional_level <chr>, count <dbl>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
