# Turn a <summarised_result> object into a tidy tibble — tidy.summarised_result • omopgenerics

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



# Turn a `<summarised_result>` object into a tidy tibble

Source: [`R/methodTidy.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodTidy.R)

`tidy.summarised_result.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) Provides tools for obtaining a tidy version of a `<summarised_result>` object. This tidy version will include the settings as columns, `estimate_value` will be pivotted into columns using `estimate_name` as names, and group, strata, and additional will be splitted.

## Usage
    
    
    # S3 method for class 'summarised_result'
    [tidy](https://generics.r-lib.org/reference/tidy.html)(x, ...)

## Arguments

x
    

A `<summarised_result>`.

...
    

For compatibility (not used).

## Value

A tibble.

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
    
      x |> [tidy](https://generics.r-lib.org/reference/tidy.html)()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 7
    #>   cdm_name cohort_name sex   variable_name variable_level count custom
    #>   <chr>    <chr>       <chr> <chr>         <chr>          <dbl> <chr> 
    #> 1 cprd     my_cohort   male  Age group     10 to 50           5 A     
    #> 2 eunomia  my_cohort   male  Age group     10 to 50           5 B     
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
