# Generate a plot visualisation (ggplot2) from the output of summariseIndication — plotIndication • DrugUtilisation

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

# Generate a plot visualisation (ggplot2) from the output of summariseIndication

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotIndication.Rd`

Generate a plot visualisation (ggplot2) from the output of summariseIndication

## Usage
    
    
    plotIndication(
      result,
      facet = cdm_name + cohort_name ~ window_name,
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

A ggplot2 object

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    indications <- [list](https://rdrr.io/r/base/list.html)(headache = 378253, asthma = 317009)
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                                    conceptSet = indications,
                                    name = "indication_cohorts")
    
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       name = "drug_cohort",
                                       ingredient = "acetaminophen")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$drug_cohort |>
      [summariseIndication](summariseIndication.html)(
        indicationCohortName = "indication_cohorts",
        unknownIndicationTable = "condition_occurrence",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, 0), [c](https://rdrr.io/r/base/c.html)(-365, 0))
      )
    #> ℹ Intersect with indications table (indication_cohorts)
    #> ℹ Summarising indications.
    
    plotIndication(result)
    ![](plotIndication-1.png)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
