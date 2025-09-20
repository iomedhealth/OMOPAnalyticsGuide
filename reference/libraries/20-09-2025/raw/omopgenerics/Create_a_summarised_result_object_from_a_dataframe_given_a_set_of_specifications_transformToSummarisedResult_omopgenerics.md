# Create a <summarised_result> object from a data.frame, given a set of specifications. — transformToSummarisedResult • omopgenerics

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



# Create a <summarised_result> object from a data.frame, given a set of specifications.

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`transformToSummarisedResult.Rd`

Create a <summarised_result> object from a data.frame, given a set of specifications.

## Usage
    
    
    transformToSummarisedResult(
      x,
      group = [character](https://rdrr.io/r/base/character.html)(),
      strata = [character](https://rdrr.io/r/base/character.html)(),
      additional = [character](https://rdrr.io/r/base/character.html)(),
      estimates = [character](https://rdrr.io/r/base/character.html)(),
      settings = [character](https://rdrr.io/r/base/character.html)()
    )

## Arguments

x
    

A data.frame.

group
    

Columns in x to be used in group_name-group_level formatting.

strata
    

Columns in x to be used in strata_name-strata_level formatting.

additional
    

Columns in x to be used in additional_name-additional_level formatting.

estimates
    

Columns in x to be formatted into: estimate_name-estimate_type-estimate_value.

settings
    

Columns in x thta form the settings of the <summarised_result> object.

## Value

A <summarised_result> object.

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_name = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
      variable_name = "age",
      mean = [c](https://rdrr.io/r/base/c.html)(50, 45.3),
      median = [c](https://rdrr.io/r/base/c.html)(55L, 44L)
    )
    
    transformToSummarisedResult(
      x = x,
      group = [c](https://rdrr.io/r/base/c.html)("cohort_name"),
      estimates = [c](https://rdrr.io/r/base/c.html)("mean", "median")
    )
    #> ℹ Column `cdm_name` created as 'unknown' as not present in x.
    #> ℹ Column `variable_level` created as 'overall' as not present in x.
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 4 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 unknown  cohort_name cohort1     overall     overall     
    #> 2         1 unknown  cohort_name cohort1     overall     overall     
    #> 3         1 unknown  cohort_name cohort2     overall     overall     
    #> 4         1 unknown  cohort_name cohort2     overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
