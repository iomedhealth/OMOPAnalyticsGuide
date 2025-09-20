# Summarise missing data in omop tables — summariseMissingData • OmopSketch

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

# Summarise missing data in omop tables

Source: [`R/summariseMissingData.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summariseMissingData.R)

`summariseMissingData.Rd`

Summarise missing data in omop tables

## Usage
    
    
    summariseMissingData(
      cdm,
      omopTableName,
      col = NULL,
      sex = FALSE,
      year = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)(),
      interval = "overall",
      ageGroup = NULL,
      sample = 1e+06,
      dateRange = NULL
    )

## Arguments

cdm
    

A cdm object

omopTableName
    

A character vector of the names of the tables to summarise in the cdm object.

col
    

A character vector of column names to check for missing values. If `NULL`, all columns in the specified tables are checked. Default is `NULL`.

sex
    

TRUE or FALSE. If TRUE code use will be summarised by sex.

year
    

deprecated

interval
    

Time interval to stratify by. It can either be "years", "quarters", "months" or "overall".

ageGroup
    

A list of ageGroup vectors of length two. Code use will be thus summarised by age groups.

sample
    

An integer to sample the table to only that number of records. If NULL no sample is done.

dateRange
    

A vector of two dates defining the desired study period. Only the `start_date` column of the OMOP table is checked to ensure it falls within this range. If `dateRange` is `NULL`, no restriction is applied.

## Value

A summarised_result object with results overall and, if specified, by strata.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 100)
    
    result <- summariseMissingData (cdm = cdm,
    omopTableName = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "visit_occurrence"),
    sample = 10000)
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
