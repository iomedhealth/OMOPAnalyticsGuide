# Filter the group_name-group_level pair in a summarised_result — filterGroup • omopgenerics

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



# Filter the group_name-group_level pair in a summarised_result

Source: [`R/filter.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/filter.R)

`filterGroup.Rd`

Filter the group_name-group_level pair in a summarised_result

## Usage
    
    
    filterGroup(result, ...)

## Arguments

result
    

A `<summarised_result>` object.

...
    

Expressions that return a logical value (`[groupColumns()](groupColumns.html)` are used to evaluate the expression), and are defined in terms of the variables in .data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.

## Value

A `<summarised_result>` object with only the rows that fulfill the required specified group.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "eunomia",
      "group_name" = [c](https://rdrr.io/r/base/c.html)("cohort_name", "age_group &&& cohort_name", "age_group"),
      "group_level" = [c](https://rdrr.io/r/base/c.html)("my_cohort", ">40 &&& second_cohort", "<40"),
      "strata_name" = "sex",
      "strata_level" = "Female",
      "variable_name" = "number subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("100", "44", "14"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      [newSummarisedResult](newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x |>
      filterGroup(cohort_name == "second_cohort")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name             group_level strata_name strata_level
    #>       <int> <chr>    <chr>                  <chr>       <chr>       <chr>       
    #> 1         1 eunomia  age_group &&& cohort_… >40 &&& se… sex         Female      
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
