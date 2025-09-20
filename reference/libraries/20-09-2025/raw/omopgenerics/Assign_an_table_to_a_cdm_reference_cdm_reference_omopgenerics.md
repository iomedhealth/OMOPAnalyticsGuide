# Assign an table to a cdm reference. — $<-.cdm_reference • omopgenerics

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



# Assign an table to a cdm reference.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cash-set-.cdm_reference.Rd`

Assign an table to a cdm reference.

## Usage
    
    
    # S3 method for class 'cdm_reference'
    cdm$name <- value

## Arguments

cdm
    

A cdm reference.

name
    

Name where to assign the new table.

value
    

Table with the same source than the cdm object.

## Value

The cdm reference.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdm$person
    #> # A tibble: 3 × 5
    #>   person_id gender_concept_id year_of_birth race_concept_id ethnicity_concept_id
    #>       <int>             <int>         <int>           <int>                <int>
    #> 1         1                 0          1990               0                    0
    #> 2         2                 0          1990               0                    0
    #> 3         3                 0          1990               0                    0
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
