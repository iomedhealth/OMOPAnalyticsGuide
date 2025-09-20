# This function is used to summarise treatments received — summariseTreatment • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# This function is used to summarise treatments received

Source: [`R/summariseIntersect.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseIntersect.R)

`summariseTreatment.Rd`

This function is used to summarise treatments received

## Usage
    
    
    summariseTreatment(
      cohort,
      window,
      treatmentCohortName,
      cohortId = NULL,
      treatmentCohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      indexDate = "cohort_start_date",
      censorDate = NULL,
      mutuallyExclusive = FALSE
    )

## Arguments

cohort
    

A cohort_table object.

window
    

Time window over which to summarise the treatments.

treatmentCohortName
    

Name of a cohort in the cdm that contains the treatments of interest.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

treatmentCohortId
    

Cohort definition id of interest from treatmentCohortName.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

mutuallyExclusive
    

Whether to include mutually exclusive treatments or not.

## Value

A summary of treatments stratified by cohort_name and strata_name

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    cdm$cohort1 |>
      summariseTreatment(
        treatmentCohortName = "cohort2",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 30), [c](https://rdrr.io/r/base/c.html)(31, 365))
      )
    #> ℹ Intersect with medications table (cohort2)
    #> ℹ Summarising medications.
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
