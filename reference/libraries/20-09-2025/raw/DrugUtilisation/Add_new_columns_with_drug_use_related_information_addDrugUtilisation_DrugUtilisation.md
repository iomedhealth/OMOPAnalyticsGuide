# Add new columns with drug use related information — addDrugUtilisation • DrugUtilisation

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

# Add new columns with drug use related information

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addDrugUtilisation.Rd`

Add new columns with drug use related information

## Usage
    
    
    addDrugUtilisation(
      cohort,
      gapEra,
      conceptSet = NULL,
      ingredientConceptId = NULL,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      numberExposures = TRUE,
      numberEras = TRUE,
      daysExposed = TRUE,
      daysPrescribed = TRUE,
      timeToExposure = TRUE,
      initialExposureDuration = TRUE,
      initialQuantity = TRUE,
      cumulativeQuantity = TRUE,
      initialDailyDose = TRUE,
      cumulativeDose = TRUE,
      nameStyle = "{value}_{concept_name}_{ingredient}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

conceptSet
    

List of concepts to be included.

ingredientConceptId
    

Ingredient OMOP concept that we are interested for the study.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

numberEras
    

Whether to include 'number_eras' (number of continuous exposure episodes between indexDate and censorDate).

daysExposed
    

Whether to include 'days_exposed' (number of days that the individual is in a continuous exposure episode, including allowed treatment gaps, between indexDate and censorDate; sum of the length of the different drug eras).

daysPrescribed
    

Whether to include 'days_prescribed' (sum of the number of days for each prescription that contribute in the analysis).

timeToExposure
    

Whether to include 'time_to_exposure' (number of days between indexDate and the first episode).

initialExposureDuration
    

Whether to include 'initial_exposure_duration' (number of prescribed days of the first drug exposure record).

initialQuantity
    

Whether to include 'initial_quantity' (quantity of the first drug exposure record).

cumulativeQuantity
    

Whether to include 'cumulative_quantity' (sum of the quantity of the different exposures considered in the analysis).

initialDailyDose
    

Whether to include 'initial_daily_dose_{unit}' (daily dose of the first considered prescription).

cumulativeDose
    

Whether to include 'cumulative_dose_{unit}' (sum of the cumulative dose of the analysed drug exposure records).

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added columns.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    cdm$dus_cohort |>
      addDrugUtilisation(ingredientConceptId = 1125315, gapEra = 30) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 14
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id                                                <int> 1,…
    #> $ subject_id                                                          <int> 2,…
    #> $ cohort_start_date                                                   <date> 2…
    #> $ cohort_end_date                                                     <date> 2…
    #> $ number_exposures_ingredient_1125315_descendants                     <int> 1,…
    #> $ time_to_exposure_ingredient_1125315_descendants                     <int> 0,…
    #> $ cumulative_quantity_ingredient_1125315_descendants                  <dbl> 50…
    #> $ initial_quantity_ingredient_1125315_descendants                     <dbl> 50…
    #> $ initial_exposure_duration_ingredient_1125315_descendants            <int> 19…
    #> $ number_eras_ingredient_1125315_descendants                          <int> 1,…
    #> $ days_exposed_ingredient_1125315_descendants                         <int> 19…
    #> $ days_prescribed_ingredient_1125315_descendants                      <int> 19…
    #> $ cumulative_dose_milligram_ingredient_1125315_descendants_1125315    <dbl> 48…
    #> $ initial_daily_dose_milligram_ingredient_1125315_descendants_1125315 <dbl> 2.…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
