# Bar plot of denominator counts, outcome counts, and person-time from incidence results — plotIncidencePopulation • IncidencePrevalence

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

# Bar plot of denominator counts, outcome counts, and person-time from incidence results

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`plotIncidencePopulation.Rd`

Bar plot of denominator counts, outcome counts, and person-time from incidence results

## Usage
    
    
    plotIncidencePopulation(
      result,
      x = "incidence_start_date",
      y = "denominator_count",
      facet = NULL,
      colour = NULL
    )

## Arguments

result
    

Incidence results

x
    

Variable to plot on x axis

y
    

Variable to plot on y axis.

facet
    

Variables to use for facets. To see available variables for facetting use the functions `[availableIncidenceGrouping()](availableIncidenceGrouping.html)`.

colour
    

Variables to use for colours. To see available variables for colouring use the function `[availableIncidenceGrouping()](availableIncidenceGrouping.html)`.

## Value

A ggplot object

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2014-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    inc <- [estimateIncidence](estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    plotIncidencePopulation(inc)
    ![](plotIncidencePopulation-1.png)
    # }
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
