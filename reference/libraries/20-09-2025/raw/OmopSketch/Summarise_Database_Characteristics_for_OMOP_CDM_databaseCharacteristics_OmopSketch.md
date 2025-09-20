# Summarise Database Characteristics for OMOP CDM — databaseCharacteristics • OmopSketch

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

# Summarise Database Characteristics for OMOP CDM

Source: [`R/databaseCharacteristics.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/databaseCharacteristics.R)

`databaseCharacteristics.Rd`

Summarise Database Characteristics for OMOP CDM

## Usage
    
    
    databaseCharacteristics(
      cdm,
      omopTableName = [c](https://rdrr.io/r/base/c.html)("person", "visit_occurrence", "condition_occurrence",
        "drug_exposure", "procedure_occurrence", "device_exposure", "measurement",
        "observation", "death"),
      sex = FALSE,
      ageGroup = NULL,
      dateRange = NULL,
      interval = "overall",
      conceptIdCounts = FALSE,
      ...
    )

## Arguments

cdm
    

A `cdm_reference` object representing the Common Data Model (CDM) reference.

omopTableName
    

A character vector specifying the OMOP tables from the CDM to include in the analysis. If "person" is present, it will only be used for missing value summarisation.

sex
    

Logical; whether to stratify results by sex (`TRUE`) or not (`FALSE`).

ageGroup
    

A list of age groups to stratify the results by. Each element represents a specific age range.

dateRange
    

A vector of two dates defining the desired study period. Only the `start_date` column of the OMOP table is checked to ensure it falls within this range. If `dateRange` is `NULL`, no restriction is applied.

interval
    

Time interval to stratify by. It can either be "years", "quarters", "months" or "overall".

conceptIdCounts
    

Logical; whether to summarise concept ID counts (`TRUE`) or not (`FALSE`).

...
    

additional arguments passed to the OmopSketch functions that are used internally.

## Value

A `summarised_result` object containing the results of the characterisation.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 100)
    
    result <- databaseCharacteristics(cdm = cdm,
    omopTableName = [c](https://rdrr.io/r/base/c.html)("drug_exposure", "condition_occurrence"),
    sex = TRUE, ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0,50), [c](https://rdrr.io/r/base/c.html)(51,100)), interval = "years", conceptIdCounts = FALSE)
    #> The characterisation will focus on the following OMOP tables: drug_exposure and
    #> condition_occurrence
    #> → Getting cdm snapshot
    #> → Getting population characteristics
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> ✔ Cohort trimmed
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> Trim age
    #> ✔ Cohort trimmed
    #> ℹ adding demographics columns
    #> ℹ summarising data
    #> ℹ summarising cohort general_population
    #> ℹ summarising cohort age_group_0_50
    #> ℹ summarising cohort age_group_51_100
    #> ✔ summariseCharacteristics finished!
    #> → Summarising clinical records
    #> ℹ Adding variables of interest to drug_exposure.
    #> ℹ Summarising records per person in drug_exposure.
    #> ℹ Summarising records in observation in drug_exposure.
    #> ℹ Summarising records with start before birth date in drug_exposure.
    #> ℹ Summarising records with end date before start date in drug_exposure.
    #> ℹ Summarising domains in drug_exposure.
    #> ℹ Summarising standard concepts in drug_exposure.
    #> ℹ Summarising source vocabularies in drug_exposure.
    #> ℹ Summarising concept types in drug_exposure.
    #> ℹ Summarising missing data in drug_exposure.
    #> ℹ Adding variables of interest to condition_occurrence.
    #> ℹ Summarising records per person in condition_occurrence.
    #> ℹ Summarising records in observation in condition_occurrence.
    #> ℹ Summarising records with start before birth date in condition_occurrence.
    #> ℹ Summarising records with end date before start date in condition_occurrence.
    #> ℹ Summarising domains in condition_occurrence.
    #> ℹ Summarising standard concepts in condition_occurrence.
    #> ℹ Summarising source vocabularies in condition_occurrence.
    #> ℹ Summarising concept types in condition_occurrence.
    #> ℹ Summarising missing data in condition_occurrence.
    #> → Summarising observation period
    #> Warning: These columns contain missing values, which are not permitted:
    #> "period_type_concept_id"
    #> → Summarising trends: records, subjects, person-days, age and sex
    #> → The number of person-days is not computed for event tables
    #> ☺ Database characterisation finished. Code ran in 0 min and 54 sec
    #> ℹ 1 table created: "og_008_1757326711".
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
