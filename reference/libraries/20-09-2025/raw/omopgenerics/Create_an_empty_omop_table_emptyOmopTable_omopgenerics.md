# Create an empty omop table — emptyOmopTable • omopgenerics

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



# Create an empty omop table

Source: [`R/classOmopTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classOmopTable.R)

`emptyOmopTable.Rd`

Create an empty omop table

## Usage
    
    
    emptyOmopTable(cdm, name)

## Arguments

cdm
    

A cdm_reference to create the table.

name
    

Name of the table to create.

## Value

The cdm_reference with an empty cohort table

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    person <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
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
    
    cdm <- emptyOmopTable(cdm, "drug_exposure")
    
    cdm$drug_exposure
    #> # A tibble: 0 × 23
    #> # ℹ 23 variables: drug_exposure_id <int>, person_id <int>,
    #> #   drug_concept_id <int>, drug_exposure_start_date <date>,
    #> #   drug_exposure_start_datetime <date>, drug_exposure_end_date <date>,
    #> #   drug_exposure_end_datetime <date>, verbatim_end_date <date>,
    #> #   drug_type_concept_id <int>, stop_reason <chr>, refills <int>,
    #> #   quantity <dbl>, days_supply <int>, sig <chr>, route_concept_id <int>,
    #> #   lot_number <chr>, provider_id <int>, visit_occurrence_id <int>, …
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
