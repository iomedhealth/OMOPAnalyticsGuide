# Generate a set of drug cohorts based on given concepts — generateDrugUtilisationCohortSet • DrugUtilisation

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

# Generate a set of drug cohorts based on given concepts

Source: [`R/generateDrugUtilisationCohortSet.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/generateDrugUtilisationCohortSet.R)

`generateDrugUtilisationCohortSet.Rd`

Adds a new cohort table to the cdm reference with individuals who have drug exposure records with the specified concepts. Cohort start and end dates will be based on drug record start and end dates, respectively. Records that overlap or have fewer days between them than the specified gap era will be concatenated into a single cohort entry.

## Usage
    
    
    generateDrugUtilisationCohortSet(
      cdm,
      name,
      conceptSet,
      gapEra = 1,
      subsetCohort = NULL,
      subsetCohortId = NULL,
      numberExposures = FALSE,
      daysPrescribed = FALSE
    )

## Arguments

cdm
    

A `cdm_reference` object.

name
    

Name of the new cohort table, it must be a length 1 character vector.

conceptSet
    

List of concepts to be included.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

subsetCohort
    

Cohort table to subset.

subsetCohortId
    

Cohort id to subset.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

daysPrescribed
    

Whether to include 'days_prescribed' (number of days prescribed used to create each era).

## Value

The function returns the cdm reference provided with the addition of the new cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    druglist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm,
                                       name = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "metformin"),
                                       nameStyle = "{concept_name}")
    
    cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                            name = "drug_cohorts",
                                            conceptSet = druglist,
                                            gapEra = 30,
                                            numberExposures = TRUE,
                                            daysPrescribed = TRUE)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 30 days.
    
    cdm$drug_cohorts |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 2, 2, 2, 1, 1
    #> $ subject_id           <int> 9, 4, 5, 2, 3, 6, 6, 8, 1, 1, 1, 7, 4, 4, 3, 10
    #> $ cohort_start_date    <date> 2019-07-31, 1984-05-28, 2002-03-31, 2019-05-16, 2…
    #> $ cohort_end_date      <date> 2019-08-11, 1990-05-25, 2002-12-03, 2019-08-10, 2…
    #> $ number_exposures     <int> 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 3, 2, 1, 1, 1
    #> $ days_prescribed      <int> 12, 2272, 248, 87, 94, 1358, 321, 292, 2098, 423…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
