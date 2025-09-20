# cohort_table objects constructor. — newCohortTable • omopgenerics

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



# `cohort_table` objects constructor.

Source: [`R/classCohortTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCohortTable.R)

`newCohortTable.Rd`

`cohort_table` objects constructor.

## Usage
    
    
    newCohortTable(
      table,
      cohortSetRef = [attr](https://rdrr.io/r/base/attr.html)(table, "cohort_set"),
      cohortAttritionRef = [attr](https://rdrr.io/r/base/attr.html)(table, "cohort_attrition"),
      cohortCodelistRef = [attr](https://rdrr.io/r/base/attr.html)(table, "cohort_codelist"),
      .softValidation = FALSE
    )

## Arguments

table
    

cdm_table object with at least: cohort_definition_id, subject_id, cohort_start_date, cohort_end_date.

cohortSetRef
    

Table with at least: cohort_definition_id, cohort_name

cohortAttritionRef
    

Table with at least: cohort_definition_id, number_subjects, number_records, reason_id, reason, excluded_subjects, excluded_records.

cohortCodelistRef
    

Table with at least: cohort_definition_id, codelist_name, concept_id and codelist_type.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort_table object

## Examples
    
    
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
    cohort1 <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = person,
        "observation_period" = observation_period,
        "cohort1" = cohort1
      ),
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
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of test ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: cohort1
    cdm$cohort1 <- newCohortTable(table = cdm$cohort1)
    #> Warning: ! 2 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of test ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: cohort1
    #> • achilles tables: -
    #> • other tables: -
    [settings](settings.html)(cdm$cohort1)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1   
    [attrition](attrition.html)(cdm$cohort1)
    #> # A tibble: 1 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [cohortCount](cohortCount.html)(cdm$cohort1)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
