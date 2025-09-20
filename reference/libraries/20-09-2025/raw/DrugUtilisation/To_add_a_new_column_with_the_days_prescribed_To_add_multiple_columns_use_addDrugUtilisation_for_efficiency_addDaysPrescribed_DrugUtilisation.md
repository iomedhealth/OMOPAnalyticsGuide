# To add a new column with the days prescribed. To add multiple columns use addDrugUtilisation() for efficiency. — addDaysPrescribed • DrugUtilisation

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

# To add a new column with the days prescribed. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addDaysPrescribed.Rd`

To add a new column with the days prescribed. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addDaysPrescribed(
      cohort,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "days_prescribed_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

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
      addDaysPrescribed(conceptSet = codelist) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id              <int> 1, 1, 1, 1, 1, 1
    #> $ subject_id                        <int> 2, 10, 10, 4, 6, 5
    #> $ cohort_start_date                 <date> 2022-02-05, 2011-03-09, 2015-08-17, …
    #> $ cohort_end_date                   <date> 2022-02-25, 2015-02-22, 2016-02-21, …
    #> $ days_prescribed_161_acetaminophen <int> 21, 1447, 189, 10, 2079, 866
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
