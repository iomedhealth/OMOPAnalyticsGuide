# Validate if a an object is a valid 'summarised_result' object. — validateResultArgument • omopgenerics

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



# Validate if a an object is a valid 'summarised_result' object.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateResultArgument.Rd`

Validate if a an object is a valid 'summarised_result' object.

## Usage
    
    
    validateResultArgument(
      result,
      checkNoDuplicates = FALSE,
      checkNameLevel = FALSE,
      checkSuppression = FALSE,
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

result
    

summarised_result object to validate.

checkNoDuplicates
    

Whether there are not allowed duplicates in the result object.

checkNameLevel
    

Whether the name-level paired columns are can be correctly split.

checkSuppression
    

Whether the suppression in the result object is well defined.

validation
    

Only error is supported at the moment.

call
    

parent.frame

## Value

summarise result object

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
    
    validateResultArgument(x)
    #> # A tibble: 3 × 13
    #>   result_id cdm_name group_name  group_level strata_name       strata_level   
    #>       <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #> 1         1 eunomia  cohort_name my_cohort   sex               Female         
    #> 2         1 eunomia  cohort_name my_cohort   sex &&& age_group Male &&& <40   
    #> 3         1 eunomia  cohort_name my_cohort   sex &&& year      Female &&& 2010
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
