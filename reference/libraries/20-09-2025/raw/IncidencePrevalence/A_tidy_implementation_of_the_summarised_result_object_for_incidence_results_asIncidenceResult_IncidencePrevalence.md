# A tidy implementation of the summarised_result object for incidence results. — asIncidenceResult • IncidencePrevalence

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

# A tidy implementation of the summarised_result object for incidence results.

Source: [`R/tidyResults.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tidyResults.R)

`asIncidenceResult.Rd`

A tidy implementation of the summarised_result object for incidence results.

## Usage
    
    
    asIncidenceResult(result, metadata = FALSE)

## Arguments

result
    

A summarised_result object created by the IncidencePrevalence package.

metadata
    

If TRUE additional metadata columns will be included in the result.

## Value

A tibble with a tidy version of the summarised_result object.

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)()
    inc <- [estimateIncidence](estimateIncidence.html)(cdm, "target", "outcome")
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    tidy_inc <- asIncidenceResult(inc)
    # }
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
