# Check whether a cohort table satisfies requirements — checkCohortRequirements • omopgenerics

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



# Check whether a cohort table satisfies requirements

Source: [`R/classCohortTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCohortTable.R)

`checkCohortRequirements.Rd`

[![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## Usage
    
    
    checkCohortRequirements(
      cohort,
      checkEndAfterStart = TRUE,
      checkOverlappingEntries = TRUE,
      checkMissingValues = TRUE,
      checkInObservation = TRUE,
      type = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

cohort
    

`cohort_table` object.

checkEndAfterStart
    

If TRUE a check that all cohort end dates come on or after cohort start date will be performed.

checkOverlappingEntries
    

If TRUE a check that no individuals have overlapping cohort entries will be performed.

checkMissingValues
    

If TRUE a check that there are no missing values in required fields will be performed.

checkInObservation
    

If TRUE a check that cohort entries are within the individuals observation periods will be performed.

type
    

Can be either "error" or "warning". If "error" any check failure will result in an error, whereas if "warning" any check failure will result in a warning.

call
    

The call for which to return the error message.

## Value

An error will be returned if any of the selected checks fail.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
