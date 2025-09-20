# Plot the results of summariseDrugUtilisation — plotDrugUtilisation • DrugUtilisation

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

# Plot the results of `summariseDrugUtilisation`

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotDrugUtilisation.Rd`

Plot the results of `summariseDrugUtilisation`

## Usage
    
    
    plotDrugUtilisation(
      result,
      variable = "number exposures",
      plotType = "barplot",
      facet = [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result),
      colour = "cohort_name"
    )

## Arguments

result
    

A summarised_result object.

variable
    

Variable to plot. See `unique(result$variable_name)` for options.

plotType
    

Must be a choice between: 'scatterplot', 'barplot', 'densityplot', and 'boxplot'.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot2 object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)(numberIndividuals = 100)
    codes <- [list](https://rdrr.io/r/base/list.html)(aceta = [c](https://rdrr.io/r/base/c.html)(1125315, 1125360, 2905077, 43135274))
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "cohort",
                                            conceptSet = codes)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$cohort |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [summariseDrugUtilisation](summariseDrugUtilisation.html)(
        strata = "sex",
        ingredientConceptId = 1125315,
        estimates = [c](https://rdrr.io/r/base/c.html)("min", "q25", "median", "q75", "max", "density")
      )
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(estimate_name == "median") |>
      plotDrugUtilisation(
        variable = "days prescribed",
        plotType = "barplot"
      )
    ![](plotDrugUtilisation-1.png)
    
    result |>
      plotDrugUtilisation(
        variable = "days exposed",
        facet = cohort_name ~ cdm_name,
        colour = "sex",
        plotType = "boxplot"
      )
    ![](plotDrugUtilisation-2.png)
    
    result |>
      plotDrugUtilisation(
        variable = "cumulative dose milligram",
        plotType = "densityplot",
        facet = "cohort_name",
        colour = "sex"
      )
    ![](plotDrugUtilisation-3.png)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
