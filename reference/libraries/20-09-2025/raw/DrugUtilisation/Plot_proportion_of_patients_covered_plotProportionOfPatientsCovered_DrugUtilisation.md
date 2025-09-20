# Plot proportion of patients covered — plotProportionOfPatientsCovered • DrugUtilisation

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

# Plot proportion of patients covered

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotProportionOfPatientsCovered.Rd`

Plot proportion of patients covered

## Usage
    
    
    plotProportionOfPatientsCovered(
      result,
      facet = "cohort_name",
      colour = [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result),
      ribbon = TRUE
    )

## Arguments

result
    

A summarised_result object.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

ribbon
    

Whether to plot a ribbon with the confidence intervals.

## Value

Plot of proportion Of patients covered over time

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "my_cohort",
                                            conceptSet = [list](https://rdrr.io/r/base/list.html)(drug_of_interest = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327)))
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$my_cohort |>
      [summariseProportionOfPatientsCovered](summariseProportionOfPatientsCovered.html)(followUpDays = 365)
    #> Getting PPC for cohort drug_of_interest
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■■                     130 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    
    plotProportionOfPatientsCovered(result)
    ![](plotProportionOfPatientsCovered-1.png)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
