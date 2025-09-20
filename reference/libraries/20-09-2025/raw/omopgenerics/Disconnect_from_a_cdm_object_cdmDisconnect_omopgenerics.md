# Disconnect from a cdm object. — cdmDisconnect • omopgenerics

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



# Disconnect from a cdm object.

Source: [`R/methodCdmDisconnect.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodCdmDisconnect.R)

`cdmDisconnect.Rd`

Disconnect from a cdm object.

## Usage
    
    
    cdmDisconnect(cdm, ...)

## Arguments

cdm
    

A cdm reference or the source of a cdm reference.

...
    

Used for consistency.

## Value

TRUE if process wass successful. library(omopgenerics) library(dplyr, warn.conflicts = FALSE)

person <\- tibble( person_id = 1, gender_concept_id = 0, year_of_birth = 1990, race_concept_id = 0, ethnicity_concept_id = 0 ) observation_period <\- tibble( observation_period_id = 1, person_id = 1, observation_period_start_date = as.Date("2000-01-01"), observation_period_end_date = as.Date("2023-12-31"), period_type_concept_id = 0 ) cdm <\- cdmFromTables( tables = list("person" = person, "observation_period" = observation_period), cdmName = "mock" )

cdmDisconnect(cdm)

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
