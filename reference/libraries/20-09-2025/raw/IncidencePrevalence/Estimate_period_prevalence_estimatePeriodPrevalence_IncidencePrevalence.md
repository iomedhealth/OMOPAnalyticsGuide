# Estimate period prevalence — estimatePeriodPrevalence • IncidencePrevalence

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

# Estimate period prevalence

Source: [`R/estimatePrevalence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/estimatePrevalence.R)

`estimatePeriodPrevalence.Rd`

Estimate period prevalence

## Usage
    
    
    estimatePeriodPrevalence(
      cdm,
      denominatorTable,
      outcomeTable,
      denominatorCohortId = NULL,
      outcomeCohortId = NULL,
      interval = "years",
      completeDatabaseIntervals = TRUE,
      fullContribution = FALSE,
      level = "person",
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

denominatorCohortId
    

The cohort definition ids or the cohort names of the denominator cohorts of interest. If NULL all cohorts will be considered in the analysis.

outcomeCohortId
    

The cohort definition ids or the cohort names of the outcome cohorts of interest. If NULL all cohorts will be considered in the analysis.

interval
    

Time intervals over which period prevalence is estimated. This can be "weeks", "months", "quarters", "years", or "overall". ISO weeks will be used for weeks. Calendar months, quarters, or years can be used as the period. If more than one option is chosen then results will be estimated for each chosen interval.

completeDatabaseIntervals
    

TRUE/ FALSE. Where TRUE, prevalence will only be estimated for those intervals where the database captures all the interval (based on the earliest and latest observation period start dates, respectively).

fullContribution
    

TRUE/ FALSE. Where TRUE, individuals will only be included if they in the database for the entire interval of interest. If FALSE they are only required to present for one day of the interval in order to contribute.

level
    

Can be "person" or "record". When estimating at the record level, each span of time contributed in the denominator will be considered separately (e.g. so as to estimate prevalence at the episode level). When estimating at the person level, multiple entries for a person will be considered together.

strata
    

Variables added to the denominator cohort table for which to stratify estimates.

includeOverallStrata
    

Whether to include an overall result as well as strata specific results (when strata has been specified).

## Value

Period prevalence estimates

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    estimatePeriodPrevalence(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "months"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 1 secs
    #> # A tibble: 644 × 13
    #>    result_id cdm_name group_name            group_level strata_name strata_level
    #>        <int> <chr>    <chr>                 <chr>       <chr>       <chr>       
    #>  1         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  2         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  3         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  4         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  5         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  6         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  7         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  8         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  9         1 mock     denominator_cohort_n… denominato… overall     overall     
    #> 10         1 mock     denominator_cohort_n… denominato… overall     overall     
    #> # ℹ 634 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
