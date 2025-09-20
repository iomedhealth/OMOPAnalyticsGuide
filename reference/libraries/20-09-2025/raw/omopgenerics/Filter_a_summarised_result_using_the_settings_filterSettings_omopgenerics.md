# Filter a <summarised_result> using the settings — filterSettings • omopgenerics

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



# Filter a `<summarised_result>` using the settings

Source: [`R/filter.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/filter.R)

`filterSettings.Rd`

Filter a `<summarised_result>` using the settings

## Usage
    
    
    filterSettings(result, ...)

## Arguments

result
    

A `<summarised_result>` object.

...
    

Expressions that return a logical value (columns in settings are used to evaluate the expression), and are defined in terms of the variables in .data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.

## Value

A `<summarised_result>` object with only the result_id rows that fulfill the required specified settings.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
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
      [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
      ))
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 cprd     cohort_name my_cohort   sex         male        
    #> 2         2 eunomia  cohort_name my_cohort   sex         male        
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    x |> filterSettings(custom == "A")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 cprd     cohort_name my_cohort   sex         male        
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
