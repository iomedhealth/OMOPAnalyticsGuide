# Bind two or more cohort tables — bind.cohort_table • omopgenerics

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



# Bind two or more cohort tables

Source: [`R/methodBind.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodBind.R)

`bind.cohort_table.Rd`

Bind two or more cohort tables

## Usage
    
    
    # S3 method for class 'cohort_table'
    [bind](bind.html)(..., name)

## Arguments

...
    

Generated cohort set objects to bind. At least two must be provided.

name
    

Name of the new generated cohort set.

## Value

The cdm object with a new generated cohort set containing all of the cohorts passed.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cohort1 <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = 1:3,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-05")
    )
    cohort2 <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(2, 2, 3, 3, 3),
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3, 1, 2),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-05")
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = cohort1, "cohort2" = cohort2)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> Warning: ! 2 casted column in cohort2 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    cdm <- [bind](bind.html)(cdm$cohort1, cdm$cohort2, name = "cohort3")
    [settings](settings.html)(cdm$cohort3)
    #> # A tibble: 3 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1   
    #> 2                    2 cohort_2   
    #> 3                    3 cohort_3   
    cdm$cohort3
    #> # A tibble: 8 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #> *                <int>      <int> <date>            <date>         
    #> 1                    1          1 2010-01-01        2010-01-05     
    #> 2                    1          2 2010-01-01        2010-01-05     
    #> 3                    1          3 2010-01-01        2010-01-05     
    #> 4                    2          1 2010-01-01        2010-01-05     
    #> 5                    2          2 2010-01-01        2010-01-05     
    #> 6                    3          3 2010-01-01        2010-01-05     
    #> 7                    3          1 2010-01-01        2010-01-05     
    #> 8                    3          2 2010-01-01        2010-01-05     
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
