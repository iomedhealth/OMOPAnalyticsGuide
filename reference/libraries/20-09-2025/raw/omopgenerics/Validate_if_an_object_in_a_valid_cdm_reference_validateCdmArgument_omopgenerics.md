# Validate if an object in a valid cdm_reference. — validateCdmArgument • omopgenerics

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



# Validate if an object in a valid cdm_reference.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateCdmArgument.Rd`

Validate if an object in a valid cdm_reference.

## Usage
    
    
    validateCdmArgument(
      cdm,
      checkOverlapObservation = FALSE,
      checkStartBeforeEndObservation = FALSE,
      checkPlausibleObservationDates = FALSE,
      checkPerson = FALSE,
      requiredTables = [character](https://rdrr.io/r/base/character.html)(),
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

cdm
    

A cdm_reference object

checkOverlapObservation
    

TRUE to perform check on no overlap observation period

checkStartBeforeEndObservation
    

TRUE to perform check on correct observational start and end date

checkPlausibleObservationDates
    

TRUE to perform check that there are no implausible observation period start dates (before 1800-01-01) or end dates (after the current date)

checkPerson
    

TRUE to perform check on person id in all clinical table are in person table

requiredTables
    

Name of tables that are required to be part of the cdm_reference object.

validation
    

How to perform validation: "error", "warning".

call
    

A call argument to pass to cli functions.

## Value

A cdm_reference object

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
    
    validateCdmArgument(cdm)
    #> 
    #> ── # OMOP CDM reference (local) of mock ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
