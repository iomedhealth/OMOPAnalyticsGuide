# Get the cohort definition id of a certain name — getCohortId • omopgenerics

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



# Get the cohort definition id of a certain name

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`getCohortId.Rd`

Get the cohort definition id of a certain name

## Usage
    
    
    getCohortId(cohort, cohortName = NULL)

## Arguments

cohort
    

A cohort_table object.

cohortName
    

Names of the cohort of interest. If NULL all cohort names are shown.

## Value

Cohort definition ids

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
