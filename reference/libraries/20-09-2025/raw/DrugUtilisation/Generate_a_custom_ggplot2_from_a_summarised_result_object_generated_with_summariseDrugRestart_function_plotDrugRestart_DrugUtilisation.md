# Generate a custom ggplot2 from a summarised_result object generated with summariseDrugRestart() function. — plotDrugRestart • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# Generate a custom ggplot2 from a summarised_result object generated with summariseDrugRestart() function.

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotDrugRestart.Rd`

Generate a custom ggplot2 from a summarised_result object generated with summariseDrugRestart() function.

## Usage
    
    
    plotDrugRestart(
      result,
      facet = cdm_name + cohort_name ~ follow_up_days,
      colour = "variable_level"
    )

## Arguments

result
    

A summarised_result object.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot2 object.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    conceptlist <- [list](https://rdrr.io/r/base/list.html)("a" = 1125360, "b" = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327))
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "switch_cohort",
                                            conceptSet = conceptlist)
    
    result <- cdm$cohort1 |>
      [summariseDrugRestart](summariseDrugRestart.html)(switchCohortTable = "switch_cohort")
    
    plotDrugRestart(result)
    } # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
