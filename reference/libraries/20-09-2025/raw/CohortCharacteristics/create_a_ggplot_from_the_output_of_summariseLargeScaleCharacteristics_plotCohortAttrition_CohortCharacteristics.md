# create a ggplot from the output of summariseLargeScaleCharacteristics. — plotCohortAttrition • CohortCharacteristics

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

# create a ggplot from the output of summariseLargeScaleCharacteristics.

Source: [`R/plotCohortAttrition.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCohortAttrition.R)

`plotCohortAttrition.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCohortAttrition(
      result,
      show = [c](https://rdrr.io/r/base/c.html)("subjects", "records"),
      type = "htmlwidget",
      cohortId = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

result
    

A summarised_result object.

show
    

Which variables to show in the attrition plot, it can be 'subjects', 'records' or both.

type
    

type of the output, it can either be: 'htmlwidget', 'png', or 'DiagrammeR'.

cohortId
    

deprecated.

## Value

A `grViz` visualisation.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    #> 
    #> Attaching package: ‘omopgenerics’
    #> The following object is masked from ‘package:stats’:
    #> 
    #>     filter
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)(numberIndividuals = 1000)
    
    cdm[["cohort1"]] <- cdm[["cohort1"]] |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(year(cohort_start_date) >= 2000) |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to cohort_start_date >= 2000") |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(year(cohort_end_date) < 2020) |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to cohort_end_date < 2020") |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "cohort1")
    
    result <- [summariseCohortAttrition](summariseCohortAttrition.html)(cdm$cohort1)
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(group_level == "cohort_2") |>
      plotCohortAttrition()
    
    
    
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
