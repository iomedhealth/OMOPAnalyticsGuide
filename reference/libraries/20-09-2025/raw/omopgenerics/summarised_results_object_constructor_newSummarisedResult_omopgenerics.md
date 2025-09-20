# 'summarised_results' object constructor — newSummarisedResult • omopgenerics

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



# 'summarised_results' object constructor

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`newSummarisedResult.Rd`

'summarised_results' object constructor

## Usage
    
    
    newSummarisedResult(x, settings = [attr](https://rdrr.io/r/base/attr.html)(x, "settings"))

## Arguments

x
    

Table.

settings
    

Settings for the summarised_result object.

## Value

A `summarised_result` object

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "cprd",
      "group_name" = "cohort_name",
      "group_level" = "acetaminophen",
      "strata_name" = "sex &&& age_group",
      "strata_level" = [c](https://rdrr.io/r/base/c.html)("male &&& <40", "male &&& >=40"),
      "variable_name" = "number_subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("5", "15"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      newSummarisedResult()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name  group_level   strata_name       strata_level 
    #>       <int> <chr>    <chr>       <chr>         <chr>             <chr>        
    #> 1         1 cprd     cohort_name acetaminophen sex &&& age_group male &&& <40 
    #> 2         1 cprd     cohort_name acetaminophen sex &&& age_group male &&& >=40
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    [settings](settings.html)(x)
    #> # A tibble: 1 × 8
    #>   result_id result_type package_name package_version group     strata additional
    #>       <int> <chr>       <chr>        <chr>           <chr>     <chr>  <chr>     
    #> 1         1 ""          ""           ""              cohort_n… sex &… ""        
    #> # ℹ 1 more variable: min_cell_count <chr>
    [summary](https://rdrr.io/r/base/summary.html)(x)
    #> A summarised_result object with 2 rows, 1 different result_id, 1 different cdm
    #> names, and 7 settings.
    #> CDM names: cprd.
    #> Settings: result_type, package_name, package_version, group, strata,
    #> additional, and min_cell_count.
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "cprd",
      "group_name" = "cohort_name",
      "group_level" = "acetaminophen",
      "strata_name" = "sex &&& age_group",
      "strata_level" = [c](https://rdrr.io/r/base/c.html)("male &&& <40", "male &&& >=40"),
      "variable_name" = "number_subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("5", "15"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      newSummarisedResult(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L, result_type = "custom_summary", mock = TRUE, value = 5
      ))
    #> `package_name` and `package_version` added to settings.
    #> `mock` and `value` casted to character.
    
    x
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name  group_level   strata_name       strata_level 
    #>       <int> <chr>    <chr>       <chr>         <chr>             <chr>        
    #> 1         1 cprd     cohort_name acetaminophen sex &&& age_group male &&& <40 
    #> 2         1 cprd     cohort_name acetaminophen sex &&& age_group male &&& >=40
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    [settings](settings.html)(x)
    #> # A tibble: 1 × 10
    #>   result_id result_type    package_name package_version group  strata additional
    #>       <int> <chr>          <chr>        <chr>           <chr>  <chr>  <chr>     
    #> 1         1 custom_summary ""           ""              cohor… sex &… ""        
    #> # ℹ 3 more variables: min_cell_count <chr>, mock <chr>, value <chr>
    [summary](https://rdrr.io/r/base/summary.html)(x)
    #> A summarised_result object with 2 rows, 1 different result_id, 1 different cdm
    #> names, and 9 settings.
    #> CDM names: cprd.
    #> Settings: result_type, package_name, package_version, group, strata,
    #> additional, min_cell_count, mock, and value.
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
