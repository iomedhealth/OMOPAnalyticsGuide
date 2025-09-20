# Plot incidence results — plotIncidence • IncidencePrevalence

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

# Plot incidence results

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`plotIncidence.Rd`

Plot incidence results

## Usage
    
    
    plotIncidence(
      result,
      x = "incidence_start_date",
      y = "incidence_100000_pys",
      line = FALSE,
      point = TRUE,
      ribbon = FALSE,
      ymin = "incidence_100000_pys_95CI_lower",
      ymax = "incidence_100000_pys_95CI_upper",
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

line
    

Whether to plot a line using `geom_line`

point
    

Whether to plot points using `geom_point`

ribbon
    

Whether to plot a ribbon using `geom_ribbon`

ymin
    

Lower limit of error bars, if provided is plot using `geom_errorbar`

ymax
    

Upper limit of error bars, if provided is plot using `geom_errorbar`

facet
    

Variables to use for facets. To see available variables for facetting use the function `[availableIncidenceGrouping()](availableIncidenceGrouping.html)`.

colour
    

Variables to use for colours. To see available variables for colouring use the function `[availableIncidenceGrouping()](availableIncidenceGrouping.html)`.

## Value

A ggplot with the incidence results plotted

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
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
    plotIncidence(inc)
    ![](plotIncidence-1.png)
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
