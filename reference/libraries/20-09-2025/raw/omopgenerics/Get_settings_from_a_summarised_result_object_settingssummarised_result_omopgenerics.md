# Get settings from a summarised_result object. — settings.summarised_result • omopgenerics

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



# Get settings from a summarised_result object.

Source: [`R/methodSettings.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodSettings.R)

`settings.summarised_result.Rd`

Get settings from a summarised_result object.

## Usage
    
    
    # S3 method for class 'summarised_result'
    [settings](settings.html)(x)

## Arguments

x
    

A summarised_result object.

## Value

A table with the settings.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
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
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2012-01-01")
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("my_cohort" = cohort)
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
    #> Warning: ! 2 casted column in my_cohort as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    result <- [summary](https://rdrr.io/r/base/summary.html)(cdm$my_cohort)
    #> `cohort_definition_id` casted to character.
    #> `cohort_definition_id` casted to character.
    
    [settings](settings.html)(result)
    #> # A tibble: 2 × 10
    #>   result_id result_type     package_name package_version group strata additional
    #>       <int> <chr>           <chr>        <chr>           <chr> <chr>  <chr>     
    #> 1         1 cohort_count    omopgenerics 1.3.1           coho… ""     ""        
    #> 2         2 cohort_attriti… omopgenerics 1.3.1           coho… "reas… "reason_i…
    #> # ℹ 3 more variables: min_cell_count <chr>, cohort_definition_id <chr>,
    #> #   table_name <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
