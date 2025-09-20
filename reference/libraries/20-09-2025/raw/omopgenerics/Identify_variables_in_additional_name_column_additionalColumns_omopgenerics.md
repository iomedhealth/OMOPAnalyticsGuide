# Identify variables in additional_name column — additionalColumns • omopgenerics

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



# Identify variables in additional_name column

Source: [`R/columns.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/columns.R)

`additionalColumns.Rd`

Identifies and returns the unique values in additional_name column.

## Usage
    
    
    additionalColumns(result)

## Arguments

result
    

A tibble.

## Value

Unique values of the additional name column.

## Examples
    
    
    {
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
    
      x
    
      x |> additionalColumns()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> character(0)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
