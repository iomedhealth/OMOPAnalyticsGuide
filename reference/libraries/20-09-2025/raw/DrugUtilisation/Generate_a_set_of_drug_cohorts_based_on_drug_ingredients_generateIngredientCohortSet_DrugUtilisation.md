# Generate a set of drug cohorts based on drug ingredients — generateIngredientCohortSet • DrugUtilisation

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

# Generate a set of drug cohorts based on drug ingredients

Source: [`R/generateIngredientCohortSet.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/generateIngredientCohortSet.R)

`generateIngredientCohortSet.Rd`

Adds a new cohort table to the cdm reference with individuals who have drug exposure records with the specified drug ingredient. Cohort start and end dates will be based on drug record start and end dates, respectively. Records that overlap or have fewer days between them than the specified gap era will be concatenated into a single cohort entry.

## Usage
    
    
    generateIngredientCohortSet(
      cdm,
      name,
      ingredient = NULL,
      gapEra = 1,
      subsetCohort = NULL,
      subsetCohortId = NULL,
      numberExposures = FALSE,
      daysPrescribed = FALSE,
      ...
    )

## Arguments

cdm
    

A `cdm_reference` object.

name
    

Name of the new cohort table, it must be a length 1 character vector.

ingredient
    

Accepts both vectors and named lists of ingredient names. For a vector input, e.g., c("acetaminophen", "codeine"), it generates a cohort table with descendant concept codes for each ingredient, assigning unique cohort_definition_id. For a named list input, e.g., list( "test_1" = c("simvastatin", "acetaminophen"), "test_2" = "metformin"), it produces a cohort table based on the structure of the input, where each name leads to a combined set of descendant concept codes for the specified ingredients, creating distinct cohort_definition_id for each named group.

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

...
    

Arguments to be passed to `[CodelistGenerator::getDrugIngredientCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)`.

## Value

The function returns the cdm reference provided with the addition of the new cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm <- generateIngredientCohortSet(cdm = cdm,
                                       ingredient = "acetaminophen",
                                       name = "acetaminophen")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$acetaminophen |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1
    #> $ subject_id           <int> 1, 3, 10, 5, 4, 6, 2
    #> $ cohort_start_date    <date> 2021-08-16, 2007-08-11, 2019-01-10, 2009-11-01, 2…
    #> $ cohort_end_date      <date> 2021-09-15, 2013-10-24, 2020-12-07, 2011-06-22, 2…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
