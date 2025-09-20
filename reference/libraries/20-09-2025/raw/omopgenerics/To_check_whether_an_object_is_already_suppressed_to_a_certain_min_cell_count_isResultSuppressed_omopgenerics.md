# To check whether an object is already suppressed to a certain min cell count. — isResultSuppressed • omopgenerics

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



# To check whether an object is already suppressed to a certain min cell count.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`isResultSuppressed.Rd`

To check whether an object is already suppressed to a certain min cell count.

## Usage
    
    
    isResultSuppressed(result, minCellCount = 5)

## Arguments

result
    

The suppressed result to check

minCellCount
    

Minimum count of records used when suppressing

## Value

Warning or message with check result

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "eunomia",
      "group_name" = "cohort_name",
      "group_level" = "my_cohort",
      "strata_name" = [c](https://rdrr.io/r/base/c.html)("sex", "sex &&& age_group", "sex &&& year"),
      "strata_level" = [c](https://rdrr.io/r/base/c.html)("Female", "Male &&& <40", "Female &&& 2010"),
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
    
    isResultSuppressed(x)
    #> Warning: ✖ 1 set (3 rows) not suppressed.
    #> [1] FALSE
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
