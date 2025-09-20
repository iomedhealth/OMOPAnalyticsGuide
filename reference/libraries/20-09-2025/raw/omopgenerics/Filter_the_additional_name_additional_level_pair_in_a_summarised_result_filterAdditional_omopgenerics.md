# Filter the additional_name-additional_level pair in a summarised_result — filterAdditional • omopgenerics

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



# Filter the additional_name-additional_level pair in a summarised_result

Source: [`R/filter.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/filter.R)

`filterAdditional.Rd`

Filter the additional_name-additional_level pair in a summarised_result

## Usage
    
    
    filterAdditional(result, ...)

## Arguments

result
    

A `<summarised_result>` object.

...
    

Expressions that return a logical value (`[additionalColumns()](additionalColumns.html)` are used to evaluate the expression), and are defined in terms of the variables in .data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.

## Value

A `<summarised_result>` object with only the rows that fulfill the required specified additional.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "eunomia",
      "group_name" = "cohort_name",
      "group_level" = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2", "cohort3"),
      "strata_name" = "sex",
      "strata_level" = "Female",
      "variable_name" = "number subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("100", "44", "14"),
      "additional_name" = [c](https://rdrr.io/r/base/c.html)("year", "time_step", "year &&& time_step"),
      "additional_level" = [c](https://rdrr.io/r/base/c.html)("2010", "4", "2015 &&& 5")
    ) |>
      [newSummarisedResult](newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x |>
      filterAdditional(year == "2010")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 eunomia  cohort_name cohort1     sex         Female      
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
