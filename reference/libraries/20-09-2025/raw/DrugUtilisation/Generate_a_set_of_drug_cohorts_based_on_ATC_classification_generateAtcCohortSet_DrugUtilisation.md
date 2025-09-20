# Generate a set of drug cohorts based on ATC classification — generateAtcCohortSet • DrugUtilisation

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

# Generate a set of drug cohorts based on ATC classification

Source: [`R/generateAtcCohortSet.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/generateAtcCohortSet.R)

`generateAtcCohortSet.Rd`

Adds a new cohort table to the cdm reference with individuals who have drug exposure records that belong to the specified Anatomical Therapeutic Chemical (ATC) classification. Cohort start and end dates will be based on drug record start and end dates, respectively. Records that overlap or have fewer days between them than the specified gap era will be concatenated into a single cohort entry.

## Usage
    
    
    generateAtcCohortSet(
      cdm,
      name,
      atcName = NULL,
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

atcName
    

Names of ATC classification of interest.

gapEra
    

Number of days between two continuous exposures to be considered in the same era. Records that have fewer days between them than this gap will be concatenated into the same cohort record.

subsetCohort
    

Cohort table to subset.

subsetCohortId
    

Cohort id to subset.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

daysPrescribed
    

Whether to include 'days_prescribed' (number of days prescribed used to create each era).

...
    

Arguments to be passed to `[CodelistGenerator::getATCCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getATCCodes.html)`.

## Value

The function returns the cdm reference provided with the addition of the new cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm <- generateAtcCohortSet(cdm = cdm,
                                atcName = "alimentary tract and metabolism",
                                name = "drugs")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> Warning: cohort_name must be snake case and have less than 100 characters, the following
    #> cohorts will be renamed:
    #> • alimentary tract and metabolism -> alimentary_tract_and_metabolism
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$drugs |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 
    #> $ subject_id           <int> 
    #> $ cohort_start_date    <date> 
    #> $ cohort_end_date      <date> 
    #> $ number_exposures     <int> 
    #> $ days_prescribed      <int> 
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
