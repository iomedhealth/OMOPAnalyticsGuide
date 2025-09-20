# Validate a cohort table input. — validateCohortArgument • omopgenerics

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



# Validate a cohort table input.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateCohortArgument.Rd`

Validate a cohort table input.

## Usage
    
    
    validateCohortArgument(
      cohort,
      checkEndAfterStart = FALSE,
      checkOverlappingEntries = FALSE,
      checkMissingValues = FALSE,
      checkInObservation = FALSE,
      checkAttributes = FALSE,
      checkPermanentTable = FALSE,
      dropExtraColumns = FALSE,
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

cohort
    

Object to be validated as a valid cohort input.

checkEndAfterStart
    

If TRUE a check that all cohort end dates come on or after cohort start date will be performed.

checkOverlappingEntries
    

If TRUE a check that no individuals have overlapping cohort entries will be performed.

checkMissingValues
    

If TRUE a check that there are no missing values in required fields will be performed.

checkInObservation
    

If TRUE a check that cohort entries are within the individuals observation periods will be performed.

checkAttributes
    

Whether to check if attributes are present and populated correctly.

checkPermanentTable
    

Whether to check if the table has to be a permanent table.

dropExtraColumns
    

Whether to drop extra columns that are not the required ones.

validation
    

How to perform validation: "error", "warning".

call
    

A call argument to pass to cli functions.

## Examples
    
    
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
       cohortTables = [list](https://rdrr.io/r/base/list.html)(
        cohort = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          cohort_definition_id = 1L,
          subject_id = 1L,
          cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
          cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2021-02-10")
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
    
    validateCohortArgument(cdm$cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2021-02-10     
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
