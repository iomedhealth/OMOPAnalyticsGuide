# Add a variable indicating individuals medications — addTreatment • DrugUtilisation

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

# Add a variable indicating individuals medications

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addIntersect.R)

`addTreatment.Rd`

Add a variable to a drug cohort indicating their presence of a medication cohort in a specified time window.

## Usage
    
    
    addTreatment(
      cohort,
      treatmentCohortName,
      treatmentCohortId = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      indexDate = "cohort_start_date",
      censorDate = NULL,
      mutuallyExclusive = TRUE,
      nameStyle = NULL,
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

treatmentCohortName
    

Name of treatment cohort table

treatmentCohortId
    

target cohort Id to add treatment

window
    

time window of interests.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

mutuallyExclusive
    

Whether to consider mutually exclusive categories (one column per window) or not (one column per window and treatment).

nameStyle
    

Name style for the treatment columns. By default: 'treatment_{window_name}' (mutuallyExclusive = TRUE), 'treatment_{window_name}_{cohort_name}' (mutuallyExclusive = FALSE).

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The original table with a variable added that summarises the individual´s indications.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)(numberIndividuals = 50)
    
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       name = "drug_cohort",
                                       ingredient = "acetaminophen")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       name = "treatments",
                                       ingredient = [c](https://rdrr.io/r/base/c.html)("metformin", "simvastatin"))
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$drug_cohort |>
      addTreatment("treatments", window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, 30), [c](https://rdrr.io/r/base/c.html)(31, 60))) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ Intersect with medications table (treatments).
    #> ℹ Collapse medications to mutually exclusive categories
    #> Rows: ??
    #> Columns: 7
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 33, 46, 16, 12, 14, 22, 31, 2, 6, 25, 3, 3, 15, 2…
    #> $ cohort_start_date    <date> 2022-01-15, 2009-12-04, 2020-08-07, 2006-08-15, …
    #> $ cohort_end_date      <date> 2022-05-03, 2013-02-02, 2021-05-01, 2009-05-02, …
    #> $ medication_0_to_0    <chr> "simvastatin", "metformin", "metformin", "simvast…
    #> $ medication_1_to_30   <chr> "simvastatin", "metformin", "metformin", "simvast…
    #> $ medication_31_to_60  <chr> "simvastatin", "metformin", "metformin", "simvast…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
