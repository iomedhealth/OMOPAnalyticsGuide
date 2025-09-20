# Add a variable indicating individuals indications — addIndication • DrugUtilisation

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

# Add a variable indicating individuals indications

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addIntersect.R)

`addIndication.Rd`

Add a variable to a drug cohort indicating their presence in an indication cohort in a specified time window. If an individual is not in one of the indication cohorts, they will be considered to have an unknown indication if they are present in one of the specified OMOP CDM clinical tables. If they are neither in an indication cohort or a clinical table they will be considered as having no observed indication.

## Usage
    
    
    addIndication(
      cohort,
      indicationCohortName,
      indicationCohortId = NULL,
      indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      unknownIndicationTable = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      mutuallyExclusive = TRUE,
      nameStyle = NULL,
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

indicationCohortName
    

Name of indication cohort table

indicationCohortId
    

target cohort Id to add indication

indicationWindow
    

time window of interests

unknownIndicationTable
    

Tables to search unknown indications

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

mutuallyExclusive
    

Whether to consider mutually exclusive categories (one column per window) or not (one column per window and indication).

nameStyle
    

Name style for the indications. By default: 'indication_{window_name}' (mutuallyExclusive = TRUE), 'indication_{window_name}_{cohort_name}' (mutuallyExclusive = FALSE).

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The original table with a variable added that summarises the individual´s indications.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
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
    
    cdm$drug_cohort |>
      addIndication(
        indicationCohortName = "indication_cohorts",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
        unknownIndicationTable = "condition_occurrence"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ Intersect with indications table (indication_cohorts).
    #> ℹ Getting unknown indications from condition_occurrence.
    #> ℹ Collapse indications to mutually exclusive categories
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1
    #> $ subject_id           <int> 2, 3, 4, 6, 7, 9
    #> $ cohort_start_date    <date> 2006-05-13, 1987-08-06, 2010-08-05, 2020-10-14, 2…
    #> $ cohort_end_date      <date> 2008-06-29, 2001-06-07, 2010-10-28, 2021-05-26, 2…
    #> $ indication_0_to_0    <chr> "asthma", "none", "none", "headache", "none", "n…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
