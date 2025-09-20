# Summary a cdm reference — summary.cdm_reference • omopgenerics

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



# Summary a cdm reference

Source: [`R/summary.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/summary.R)

`summary.cdm_reference.Rd`

Summary a cdm reference

## Usage
    
    
    # S3 method for class 'cdm_reference'
    [summary](https://rdrr.io/r/base/summary.html)(object, ...)

## Arguments

object
    

A cdm reference object.

...
    

For compatibility (not used).

## Value

A summarised_result object with a summary of the data contained in the cdm.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm)
    #> # A tibble: 13 × 13
    #>    result_id cdm_name group_name group_level strata_name strata_level
    #>        <int> <chr>    <chr>      <chr>       <chr>       <chr>       
    #>  1         1 test     overall    overall     overall     overall     
    #>  2         1 test     overall    overall     overall     overall     
    #>  3         1 test     overall    overall     overall     overall     
    #>  4         1 test     overall    overall     overall     overall     
    #>  5         1 test     overall    overall     overall     overall     
    #>  6         1 test     overall    overall     overall     overall     
    #>  7         1 test     overall    overall     overall     overall     
    #>  8         1 test     overall    overall     overall     overall     
    #>  9         1 test     overall    overall     overall     overall     
    #> 10         1 test     overall    overall     overall     overall     
    #> 11         1 test     overall    overall     overall     overall     
    #> 12         1 test     overall    overall     overall     overall     
    #> 13         1 test     overall    overall     overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
