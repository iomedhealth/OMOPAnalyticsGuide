# Summarise the indications of individuals in a drug cohort — summariseIndication • DrugUtilisation

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

# Summarise the indications of individuals in a drug cohort

Source: [`R/summariseIntersect.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseIntersect.R)

`summariseIndication.Rd`

Summarise the observed indications of patients in a drug cohort based on their presence in an indication cohort in a specified time window. If an individual is not in one of the indication cohorts, they will be considered to have an unknown indication if they are present in one of the specified OMOP CDM clinical tables. Otherwise, if they are neither in an indication cohort or a clinical table they will be considered as having no observed indication.

## Usage
    
    
    summariseIndication(
      cohort,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      indicationCohortName,
      cohortId = NULL,
      indicationCohortId = NULL,
      indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      unknownIndicationTable = NULL,
      indexDate = "cohort_start_date",
      mutuallyExclusive = TRUE,
      censorDate = NULL
    )

## Arguments

cohort
    

A cohort_table object.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

indicationCohortName
    

Name of the cohort table with potential indications.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

indicationCohortId
    

The target cohort ID to add indication. If NULL all cohorts will be considered.

indicationWindow
    

The time window over which to identify indications.

unknownIndicationTable
    

Tables in the OMOP CDM to search for unknown indications.

indexDate
    

Name of a column that indicates the date to start the analysis.

mutuallyExclusive
    

Whether to report indications as mutually exclusive or report them as independent results.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

## Value

A summarised result

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
      summariseIndication(
        indicationCohortName = "indication_cohorts",
        unknownIndicationTable = "condition_occurrence",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, 0))
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ Intersect with indications table (indication_cohorts)
    #> ℹ Summarising indications.
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Indication any time before or on index date", "Indic…
    #> $ variable_level   <chr> "asthma", "asthma", "headache", "headache", "asthma a…
    #> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
    #> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
    #> $ estimate_value   <chr> "1", "12.5", "0", "0", "2", "25", "2", "25", "3", "37…
    #> $ additional_name  <chr> "window_name", "window_name", "window_name", "window_…
    #> $ additional_level <chr> "-inf to 0", "-inf to 0", "-inf to 0", "-inf to 0", "…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
