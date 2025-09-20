# Tables in the cdm_reference that contain clinical information — clinicalTables • OmopSketch

Skip to contents

[OmopSketch](../index.html) 0.5.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Summarise clinical tables records](../articles/summarise_clinical_tables_records.html)
    * [Summarise concept id counts](../articles/summarise_concept_id_counts.html)
    * [Summarise observation period](../articles/summarise_observation_period.html)
    * [Characterisation of OMOP CDM](../articles/characterisation.html)
    * [Summarise missing data](../articles/missing_data.html)
    * [Summarise database characteristics](../articles/database_characteristics.html)
  * [Changelog](../news/index.html)
  * [Characterisation synthetic datasets](https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/)


  *   * [](https://github.com/OHDSI/OmopSketch/)



![](../logo.png)

# Tables in the cdm_reference that contain clinical information

Source: [`R/utilities.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/utilities.R)

`clinicalTables.Rd`

This function provides a list of allowed inputs for the `omopTableName` argument in `summariseClinicalRecords`

## Usage
    
    
    clinicalTables()

## Value

A character vector with table names

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    clinicalTables()
    #>  [1] "visit_occurrence"     "visit_detail"         "condition_occurrence"
    #>  [4] "drug_exposure"        "procedure_occurrence" "device_exposure"     
    #>  [7] "measurement"          "observation"          "death"               
    #> [10] "note"                 "specimen"             "payer_plan_period"   
    #> [13] "drug_era"             "dose_era"             "condition_era"       
    
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
