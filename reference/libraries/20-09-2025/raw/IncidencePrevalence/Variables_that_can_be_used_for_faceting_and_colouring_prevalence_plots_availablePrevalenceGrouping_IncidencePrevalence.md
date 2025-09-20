# Variables that can be used for faceting and colouring prevalence plots — availablePrevalenceGrouping • IncidencePrevalence

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

# Variables that can be used for faceting and colouring prevalence plots

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`availablePrevalenceGrouping.Rd`

Variables that can be used for faceting and colouring prevalence plots

## Usage
    
    
    availablePrevalenceGrouping(result, varying = FALSE)

## Arguments

result
    

Prevalence results

varying
    

If FALSE, only variables with non-unique values will be returned, otherwise all available variables will be returned

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2014-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 3 sec
    prev <- [estimatePointPrevalence](estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 0 secs
    availablePrevalenceGrouping(prev)
    #> character(0)
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
