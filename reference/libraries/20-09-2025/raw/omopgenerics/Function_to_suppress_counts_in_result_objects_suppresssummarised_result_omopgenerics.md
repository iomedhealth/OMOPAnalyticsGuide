# Function to suppress counts in result objects — suppress.summarised_result • omopgenerics

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



# Function to suppress counts in result objects

Source: [`R/methodSuppress.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodSuppress.R)

`suppress.summarised_result.Rd`

Function to suppress counts in result objects

## Usage
    
    
    # S3 method for class 'summarised_result'
    [suppress](suppress.html)(result, minCellCount = 5)

## Arguments

result
    

summarised_result object.

minCellCount
    

Minimum count of records to report results.

## Value

summarised_result with suppressed counts.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    my_result <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = "1",
      "cdm_name" = "mock",
      "result_type" = "summarised_characteristics",
      "package_name" = "omopgenerics",
      "package_version" = [as.character](https://rdrr.io/r/base/character.html)(utils::[packageVersion](https://rdrr.io/r/utils/packageDescription.html)("omopgenerics")),
      "group_name" = "overall",
      "group_level" = "overall",
      "strata_name" = [c](https://rdrr.io/r/base/c.html)([rep](https://rdrr.io/r/base/rep.html)("overall", 6), [rep](https://rdrr.io/r/base/rep.html)("sex", 3)),
      "strata_level" = [c](https://rdrr.io/r/base/c.html)([rep](https://rdrr.io/r/base/rep.html)("overall", 6), "male", "female", "female"),
      "variable_name" = [c](https://rdrr.io/r/base/c.html)(
        "number records", "age_group", "age_group",
        "age_group", "age_group", "my_variable", "number records", "age_group",
        "age_group"
      ),
      "variable_level" = [c](https://rdrr.io/r/base/c.html)(
        NA, "<50", "<50", ">=50", ">=50", NA, NA,
        "<50", "<50"
      ),
      "estimate_name" = [c](https://rdrr.io/r/base/c.html)(
        "count", "count", "percentage", "count", "percentage",
        "random", "count", "count", "percentage"
      ),
      "estimate_type" = [c](https://rdrr.io/r/base/c.html)(
        "integer", "integer", "percentage", "integer",
        "percentage", "numeric", "integer", "integer", "percentage"
      ),
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("10", "5", "50", "3", "30", "1", "3", "12", "6"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    )
    my_result <- [newSummarisedResult](newSummarisedResult.html)(my_result)
    #> ! `result_type`, `package_name`, and `package_version` moved to settings. This
    #>   is not recommended as settings should be explicitly provided.
    #> ℹ NOTE that this can cause problems with settings.
    my_result |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 9
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ group_level      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "age_group", "age_group", "age_grou…
    #> $ variable_level   <chr> NA, "<50", "<50", ">=50", ">=50", NA, NA, "<50", "<50"
    #> $ estimate_name    <chr> "count", "count", "percentage", "count", "percentage"…
    #> $ estimate_type    <chr> "integer", "integer", "percentage", "integer", "perce…
    #> $ estimate_value   <chr> "10", "5", "50", "3", "30", "1", "3", "12", "6"
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    my_result <- [suppress](suppress.html)(my_result, minCellCount = 5)
    my_result |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 9
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ group_level      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "age_group", "age_group", "age_grou…
    #> $ variable_level   <chr> NA, "<50", "<50", ">=50", ">=50", NA, NA, "<50", "<50"
    #> $ estimate_name    <chr> "count", "count", "percentage", "count", "percentage"…
    #> $ estimate_type    <chr> "integer", "integer", "percentage", "integer", "perce…
    #> $ estimate_value   <chr> "10", "5", "50", "-", "-", "1", "-", "12", "6"
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
