# Get the cohort name of a certain cohort definition id — getCohortName • omopgenerics

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



# Get the cohort name of a certain cohort definition id

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`getCohortName.Rd`

Get the cohort name of a certain cohort definition id

## Usage
    
    
    getCohortName(cohort, cohortId = NULL)

## Arguments

cohort
    

A cohort_table object.

cohortId
    

Cohort definition id of interest. If NULL all cohort ids are shown.

## Value

Cohort names

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
