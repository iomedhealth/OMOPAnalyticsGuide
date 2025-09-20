# Available columns to use in facet and colour arguments in plot functions. — availablePlotColumns • CohortCharacteristics

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Available columns to use in `facet` and `colour` arguments in plot functions.

Source: [`R/table.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/table.R)

`availablePlotColumns.Rd`

Available columns to use in `facet` and `colour` arguments in plot functions.

## Usage
    
    
    availablePlotColumns(result)

## Arguments

result
    

A summarised_result object.

## Value

Character vector with the available columns.

## Examples
    
    
    {
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    result <- [summariseCharacteristics](summariseCharacteristics.html)(cdm$cohort1)
    
    availablePlotColumns(result)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    }
    #> ℹ adding demographics columns
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
