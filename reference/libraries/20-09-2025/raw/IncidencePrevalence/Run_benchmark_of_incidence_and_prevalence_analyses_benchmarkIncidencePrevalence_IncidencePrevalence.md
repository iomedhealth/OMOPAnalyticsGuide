# Run benchmark of incidence and prevalence analyses — benchmarkIncidencePrevalence • IncidencePrevalence

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

# Run benchmark of incidence and prevalence analyses

Source: [`R/benchmarkIncidencePrevalence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/benchmarkIncidencePrevalence.R)

`benchmarkIncidencePrevalence.Rd`

Run benchmark of incidence and prevalence analyses

## Usage
    
    
    benchmarkIncidencePrevalence(cdm, analysisType = "all")

## Arguments

cdm
    

A CDM reference object

analysisType
    

A string of the following: "all", "only incidence", "only prevalence"

## Value

a tibble with time taken for different analyses

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(
      sampleSize = 100,
      earliestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      latestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      minDaysToObservationEnd = 364,
      maxDaysToObservationEnd = 364,
      outPre = 0.1
    )
    
    timings <- benchmarkIncidencePrevalence(cdm)
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 6 sec
    #> ℹ Getting prevalence for analysis 1 of 16
    #> ℹ Getting prevalence for analysis 2 of 16
    #> ℹ Getting prevalence for analysis 3 of 16
    #> ℹ Getting prevalence for analysis 4 of 16
    #> ℹ Getting prevalence for analysis 5 of 16
    #> ℹ Getting prevalence for analysis 6 of 16
    #> ℹ Getting prevalence for analysis 7 of 16
    #> ℹ Getting prevalence for analysis 8 of 16
    #> ℹ Getting prevalence for analysis 9 of 16
    #> ℹ Getting prevalence for analysis 10 of 16
    #> ℹ Getting prevalence for analysis 11 of 16
    #> ℹ Getting prevalence for analysis 12 of 16
    #> ℹ Getting prevalence for analysis 13 of 16
    #> ℹ Getting prevalence for analysis 14 of 16
    #> ℹ Getting prevalence for analysis 15 of 16
    #> ℹ Getting prevalence for analysis 16 of 16
    #> ✔ Time taken: 0 mins and 3 secs
    #> ℹ Getting prevalence for analysis 1 of 16
    #> ℹ Getting prevalence for analysis 2 of 16
    #> ℹ Getting prevalence for analysis 3 of 16
    #> ℹ Getting prevalence for analysis 4 of 16
    #> ℹ Getting prevalence for analysis 5 of 16
    #> ℹ Getting prevalence for analysis 6 of 16
    #> ℹ Getting prevalence for analysis 7 of 16
    #> ℹ Getting prevalence for analysis 8 of 16
    #> ℹ Getting prevalence for analysis 9 of 16
    #> ℹ Getting prevalence for analysis 10 of 16
    #> ℹ Getting prevalence for analysis 11 of 16
    #> ℹ Getting prevalence for analysis 12 of 16
    #> ℹ Getting prevalence for analysis 13 of 16
    #> ℹ Getting prevalence for analysis 14 of 16
    #> ℹ Getting prevalence for analysis 15 of 16
    #> ℹ Getting prevalence for analysis 16 of 16
    #> ✔ Time taken: 0 mins and 3 secs
    #> ℹ Getting incidence for analysis 1 of 16
    #> ℹ Getting incidence for analysis 2 of 16
    #> ℹ Getting incidence for analysis 3 of 16
    #> ℹ Getting incidence for analysis 4 of 16
    #> ℹ Getting incidence for analysis 5 of 16
    #> ℹ Getting incidence for analysis 6 of 16
    #> ℹ Getting incidence for analysis 7 of 16
    #> ℹ Getting incidence for analysis 8 of 16
    #> ℹ Getting incidence for analysis 9 of 16
    #> ℹ Getting incidence for analysis 10 of 16
    #> ℹ Getting incidence for analysis 11 of 16
    #> ℹ Getting incidence for analysis 12 of 16
    #> ℹ Getting incidence for analysis 13 of 16
    #> ℹ Getting incidence for analysis 14 of 16
    #> ℹ Getting incidence for analysis 15 of 16
    #> ℹ Getting incidence for analysis 16 of 16
    #> ✔ Overall time taken: 0 mins and 9 secs
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
