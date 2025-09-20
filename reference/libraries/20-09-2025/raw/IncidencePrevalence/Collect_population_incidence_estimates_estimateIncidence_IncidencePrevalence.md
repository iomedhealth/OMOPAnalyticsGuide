# Collect population incidence estimates — estimateIncidence • IncidencePrevalence

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Collect population incidence estimates

Source: [`R/estimateIncidence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/estimateIncidence.R)

`estimateIncidence.Rd`

Collect population incidence estimates

## Usage
    
    
    estimateIncidence(
      cdm,
      denominatorTable,
      outcomeTable,
      censorTable = NULL,
      denominatorCohortId = NULL,
      outcomeCohortId = NULL,
      censorCohortId = NULL,
      interval = "years",
      completeDatabaseIntervals = TRUE,
      outcomeWashout = Inf,
      repeatedEvents = FALSE,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      includeOverallStrata = TRUE
    )

## Arguments

cdm
    

A CDM reference object

denominatorTable
    

A cohort table with a set of denominator cohorts (for example, created using the `[generateDenominatorCohortSet()](generateDenominatorCohortSet.html)` function).

outcomeTable
    

A cohort table in the cdm reference containing a set of outcome cohorts.

censorTable
    

A cohort table in the cdm reference containing a cohort to be used for censoring. Individuals will stop contributing time at risk from the date of their first record in the censor cohort. If they appear in the censor cohort before entering the denominator cohort they will be excluded. The censor cohort can only contain one record per individual.

denominatorCohortId
    

The cohort definition ids or the cohort names of the denominator cohorts of interest. If NULL all cohorts will be considered in the analysis.

outcomeCohortId
    

The cohort definition ids or the cohort names of the outcome cohorts of interest. If NULL all cohorts will be considered in the analysis.

censorCohortId
    

The cohort definition id or the cohort name of the cohort to be used for censoring. Must be specified if there are multiple cohorts in the censor table.

interval
    

Time intervals over which incidence is estimated. Can be "weeks", "months", "quarters", "years", or "overall". ISO weeks will be used for weeks. Calendar months, quarters, or years can be used, or an overall estimate for the entire time period observed (from earliest cohort start to last cohort end) can also be estimated. If more than one option is chosen then results will be estimated for each chosen interval.

completeDatabaseIntervals
    

TRUE/ FALSE. Where TRUE, incidence will only be estimated for those intervals where the denominator cohort captures all the interval.

outcomeWashout
    

The number of days used for a 'washout' period between the end of one outcome and an individual starting to contribute time at risk. If Inf, no time can be contributed after an event has occurred.

repeatedEvents
    

TRUE/ FALSE. If TRUE, an individual will be able to contribute multiple events during the study period (time while they are present in an outcome cohort and any subsequent washout will be excluded). If FALSE, an individual will only contribute time up to their first event.

strata
    

Variables added to the denominator cohort table for which to stratify estimates.

includeOverallStrata
    

Whether to include an overall result as well as strata specific results (when strata has been specified).

## Value

Incidence estimates

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 3 sec
    inc <- estimateIncidence(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
