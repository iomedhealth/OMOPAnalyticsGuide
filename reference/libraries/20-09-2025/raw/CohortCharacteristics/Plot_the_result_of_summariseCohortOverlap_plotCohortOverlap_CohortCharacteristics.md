# Plot the result of summariseCohortOverlap. — plotCohortOverlap • CohortCharacteristics

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

# Plot the result of summariseCohortOverlap.

Source: [`R/plotCohortOverlap.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCohortOverlap.R)

`plotCohortOverlap.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCohortOverlap(
      result,
      uniqueCombinations = TRUE,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name_reference"),
      colour = "variable_name",
      .options = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

result
    

A summarised_result object.

uniqueCombinations
    

Whether to restrict to unique reference and comparator comparisons.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

.options
    

deprecated.

## Value

A ggplot.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    overlap <- [summariseCohortOverlap](summariseCohortOverlap.html)(cdm$cohort2)
    
    plotCohortOverlap(overlap, uniqueCombinations = FALSE)
    ![](plotCohortOverlap-1.png)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
