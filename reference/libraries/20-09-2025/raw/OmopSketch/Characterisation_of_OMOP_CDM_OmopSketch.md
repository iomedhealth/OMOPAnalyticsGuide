# Characterisation of OMOP CDM • OmopSketch

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

# Characterisation of OMOP CDM

Source: [`vignettes/characterisation.Rmd`](https://github.com/OHDSI/OmopSketch/blob/main/vignettes/characterisation.Rmd)

`characterisation.Rmd`

## Introduction

In this vignette, we explore how _OmopSketch_ functions can serve as a valuable tool for characterising databases containing electronic health records mapped to the OMOP Common Data Model.

### Create a mock cdm

Let’s see an example of its functionalities. To start with, we will load essential packages and connect to a test CDM using the Eunomia dataset.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    
    # Connect to Eunomia database
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchema = "main", writeSchema = "main", cdmName = "Eunomia"
    )
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of Eunomia ────────────────────────────────────
    #> • omop tables: care_site, cdm_source, concept, concept_ancestor, concept_class,
    #> concept_relationship, concept_synonym, condition_era, condition_occurrence,
    #> cost, death, device_exposure, domain, dose_era, drug_era, drug_exposure,
    #> drug_strength, fact_relationship, location, measurement, metadata, note,
    #> note_nlp, observation, observation_period, payer_plan_period, person,
    #> procedure_occurrence, provider, relationship, source_to_concept_map, specimen,
    #> visit_detail, visit_occurrence, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

## Snapshot

Let’s start by using the `[summariseOmopSnapshot()](../reference/summariseOmopSnapshot.html)` function to summarise the available metadata of the cdm_reference object, including the vocabulary version and the time span covered by the `observation_period` table
    
    
    snapshot <- [summariseOmopSnapshot](../reference/summariseOmopSnapshot.html)(cdm)
    snapshot |>
      [tableOmopSnapshot](../reference/tableOmopSnapshot.html)()

Estimate |  Database name  
---|---  
Eunomia  
General  
Snapshot date | 2025-09-08  
Person count | 2,694  
Vocabulary version | v5.0 18-JAN-19  
Cdm  
Source name | Synthea synthetic health database  
Version | 5.3  
Holder name | OHDSI Community  
Release date | 2019-05-25  
Description | SyntheaTM is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.  
Documentation reference | https://synthetichealth.github.io/synthea/  
Observation period  
N | 2,694  
Start date | 1908-09-22  
End date | 2019-07-03  
Cdm source  
Type | duckdb  
Package | Unknown  
Length | 0  
Class1 | cdm_source  
Class2 | db_cdm  
Mode | list  
  
## Clinical tables characterisation

Next, we define the tables of interest, specify the study period, and determine whether to stratify the analysis by sex, age groups, or time intervals.
    
    
    tableName <- [c](https://rdrr.io/r/base/c.html)(
    "visit_occurrence", "condition_occurrence", "drug_exposure", "procedure_occurrence",
      "device_exposure", "measurement", "observation", "death"
    )
    
    dateRange <- [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2012-01-01", NA))
    
    sex <- TRUE
    
    ageGroup <- [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 59), [c](https://rdrr.io/r/base/c.html)(60, Inf))
    
    interval <- "years"

### Missing values

We can now use the `[summariseMissingData()](../reference/summariseMissingData.html)` function to assess the presence of missing values in the tables.
    
    
    result_missingData <- [summariseMissingData](../reference/summariseMissingData.html)(cdm,
      omopTableName = tableName,
      sex = sex,
      ageGroup = ageGroup,
      interval = interval,
      dateRange = dateRange
    )
    result_missingData |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 26,710
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "Eunomia", "Eunomia", "Eunomia", "Eunomia", "Eunomia"…
    #> $ group_name       <chr> "omop_table", "omop_table", "omop_table", "omop_table…
    #> $ group_level      <chr> "visit_occurrence", "visit_occurrence", "visit_occurr…
    #> $ strata_name      <chr> "overall", "age_group", "age_group", "sex", "sex", "o…
    #> $ strata_level     <chr> "overall", "0 to 59", "60 or above", "Female", "Male"…
    #> $ variable_name    <chr> "Column name", "Column name", "Column name", "Column …
    #> $ variable_level   <chr> "visit_occurrence_id", "visit_occurrence_id", "visit_…
    #> $ estimate_name    <chr> "na_count", "na_count", "na_count", "na_count", "na_c…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

### Clinical tables overview

The function `sumamriseClinicalRecords()` provides key insights into the clinical tables content, including the number of records, number of subjects, portion of records in observation, and the number of distinct domains and concepts.
    
    
    result_clinicalRecords <- [summariseClinicalRecords](../reference/summariseClinicalRecords.html)(cdm,
      omopTableName = tableName,
      sex = sex,
      ageGroup = ageGroup,
      dateRange = dateRange
    )
    #> ℹ Adding variables of interest to visit_occurrence.
    #> ℹ Summarising records per person in visit_occurrence.
    #> ℹ Summarising records in observation in visit_occurrence.
    #> ℹ Summarising records with start before birth date in visit_occurrence.
    #> ℹ Summarising records with end date before start date in visit_occurrence.
    #> ℹ Summarising domains in visit_occurrence.
    #> ℹ Summarising standard concepts in visit_occurrence.
    #> ℹ Summarising source vocabularies in visit_occurrence.
    #> ℹ Summarising concept types in visit_occurrence.
    #> ℹ Summarising missing data in visit_occurrence.
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
    #> ℹ Adding variables of interest to procedure_occurrence.
    #> ℹ Summarising records per person in procedure_occurrence.
    #> ℹ Summarising records in observation in procedure_occurrence.
    #> ℹ Summarising records with start before birth date in procedure_occurrence.
    #> ℹ Summarising records with end date before start date in procedure_occurrence.
    #> ℹ Summarising domains in procedure_occurrence.
    #> ℹ Summarising standard concepts in procedure_occurrence.
    #> ℹ Summarising source vocabularies in procedure_occurrence.
    #> ℹ Summarising concept types in procedure_occurrence.
    #> ℹ Summarising missing data in procedure_occurrence.
    #> ℹ Adding variables of interest to measurement.
    #> ℹ Summarising records per person in measurement.
    #> ℹ Summarising records in observation in measurement.
    #> ℹ Summarising records with start before birth date in measurement.
    #> ℹ Summarising records with end date before start date in measurement.
    #> ℹ Summarising domains in measurement.
    #> ℹ Summarising standard concepts in measurement.
    #> ℹ Summarising source vocabularies in measurement.
    #> ℹ Summarising concept types in measurement.
    #> ℹ Summarising missing data in measurement.
    #> ℹ Adding variables of interest to observation.
    #> ℹ Summarising records per person in observation.
    #> ℹ Summarising records in observation in observation.
    #> ℹ Summarising records with start before birth date in observation.
    #> ℹ Summarising records with end date before start date in observation.
    #> ℹ Summarising domains in observation.
    #> ℹ Summarising standard concepts in observation.
    #> ℹ Summarising source vocabularies in observation.
    #> ℹ Summarising concept types in observation.
    #> ℹ Summarising missing data in observation.
    result_clinicalRecords |> [tableClinicalRecords](../reference/tableClinicalRecords.html)()

Variable name | Variable level | Estimate name |  Database name  
---|---|---|---  
Eunomia  
visit_occurrence; overall; overall  
Number records | - | N | 163.00  
Number subjects | - | N (%) | 160 (5.94%)  
Records per person | - | Mean (SD) | 0.06 (0.24)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 163 (100.00%)  
Domain | - | N (%) | 163 (100.00%)  
Source vocabulary | No matching concept | N (%) | 163 (100.00%)  
Standard concept | - | N (%) | 163 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 163 (100.00%)  
Start date before birth date | - | N (%) | 0 (0.00%)  
End date before start date | - | N (%) | 0 (0.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 163 (100.00%)  
| Admitting source value | N missing data (%) | 163 (100.00%)  
| Care site id | N missing data (%) | 163 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 163 (100.00%)  
| Discharge to source value | N missing data (%) | 163 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 163 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 163 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
visit_occurrence; 0 to 59; overall  
Number records | - | N | 131.00  
Number subjects | - | N (%) | 130 (4.83%)  
Records per person | - | Mean (SD) | 0.05 (0.22)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 131 (100.00%)  
Domain | - | N (%) | 131 (100.00%)  
Source vocabulary | No matching concept | N (%) | 131 (100.00%)  
Standard concept | - | N (%) | 131 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 131 (100.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 131 (100.00%)  
| Admitting source value | N missing data (%) | 131 (100.00%)  
| Care site id | N missing data (%) | 131 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 131 (100.00%)  
| Discharge to source value | N missing data (%) | 131 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 131 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 131 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
visit_occurrence; 60 or above; overall  
Number records | - | N | 32.00  
Number subjects | - | N (%) | 30 (2.61%)  
Records per person | - | Mean (SD) | 0.03 (0.17)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 32 (100.00%)  
Domain | - | N (%) | 32 (100.00%)  
Source vocabulary | No matching concept | N (%) | 32 (100.00%)  
Standard concept | - | N (%) | 32 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 32 (100.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 32 (100.00%)  
| Admitting source value | N missing data (%) | 32 (100.00%)  
| Care site id | N missing data (%) | 32 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 32 (100.00%)  
| Discharge to source value | N missing data (%) | 32 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 32 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 32 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
visit_occurrence; overall; Female  
Number records | - | N | 85.00  
Number subjects | - | N (%) | 83 (6.05%)  
Records per person | - | Mean (SD) | 0.06 (0.25)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 85 (100.00%)  
Domain | - | N (%) | 85 (100.00%)  
Source vocabulary | No matching concept | N (%) | 85 (100.00%)  
Standard concept | - | N (%) | 85 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 85 (100.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 85 (100.00%)  
| Admitting source value | N missing data (%) | 85 (100.00%)  
| Care site id | N missing data (%) | 85 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 85 (100.00%)  
| Discharge to source value | N missing data (%) | 85 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 85 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 85 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
visit_occurrence; overall; Male  
Number records | - | N | 78.00  
Number subjects | - | N (%) | 77 (5.83%)  
Records per person | - | Mean (SD) | 0.06 (0.24)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 78 (100.00%)  
Domain | - | N (%) | 78 (100.00%)  
Source vocabulary | No matching concept | N (%) | 78 (100.00%)  
Standard concept | - | N (%) | 78 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 78 (100.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 78 (100.00%)  
| Admitting source value | N missing data (%) | 78 (100.00%)  
| Care site id | N missing data (%) | 78 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 78 (100.00%)  
| Discharge to source value | N missing data (%) | 78 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 78 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 78 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
visit_occurrence; 0 to 59; Female  
Number records | - | N | 67.00  
Number subjects | - | N (%) | 66 (4.81%)  
Records per person | - | Mean (SD) | 0.05 (0.22)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 67 (100.00%)  
Domain | - | N (%) | 67 (100.00%)  
Source vocabulary | No matching concept | N (%) | 67 (100.00%)  
Standard concept | - | N (%) | 67 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 67 (100.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 67 (100.00%)  
| Admitting source value | N missing data (%) | 67 (100.00%)  
| Care site id | N missing data (%) | 67 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 67 (100.00%)  
| Discharge to source value | N missing data (%) | 67 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 67 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 67 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
visit_occurrence; 0 to 59; Male  
Number records | - | N | 64.00  
Number subjects | - | N (%) | 64 (4.84%)  
Records per person | - | Mean (SD) | 0.05 (0.21)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 1.00]  
In observation | Yes | N (%) | 64 (100.00%)  
Domain | - | N (%) | 64 (100.00%)  
Source vocabulary | No matching concept | N (%) | 64 (100.00%)  
Standard concept | - | N (%) | 64 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 64 (100.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 64 (100.00%)  
| Admitting source value | N missing data (%) | 64 (100.00%)  
| Care site id | N missing data (%) | 64 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 64 (100.00%)  
| Discharge to source value | N missing data (%) | 64 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 64 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 64 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
visit_occurrence; 60 or above; Female  
Number records | - | N | 18.00  
Number subjects | - | N (%) | 17 (2.94%)  
Records per person | - | Mean (SD) | 0.03 (0.18)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 18 (100.00%)  
Domain | - | N (%) | 18 (100.00%)  
Source vocabulary | No matching concept | N (%) | 18 (100.00%)  
Standard concept | - | N (%) | 18 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 18 (100.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 18 (100.00%)  
| Admitting source value | N missing data (%) | 18 (100.00%)  
| Care site id | N missing data (%) | 18 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 18 (100.00%)  
| Discharge to source value | N missing data (%) | 18 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 18 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 18 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
visit_occurrence; 60 or above; Male  
Number records | - | N | 14.00  
Number subjects | - | N (%) | 13 (2.28%)  
Records per person | - | Mean (SD) | 0.02 (0.17)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 14 (100.00%)  
Domain | - | N (%) | 14 (100.00%)  
Source vocabulary | No matching concept | N (%) | 14 (100.00%)  
Standard concept | - | N (%) | 14 (100.00%)  
Type concept id | Visit derived from encounter on claim | N (%) | 14 (100.00%)  
Column name | Admitting source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 14 (100.00%)  
| Admitting source value | N missing data (%) | 14 (100.00%)  
| Care site id | N missing data (%) | 14 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Discharge to concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 14 (100.00%)  
| Discharge to source value | N missing data (%) | 14 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Preceding visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 14 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit end date | N missing data (%) | 0 (0.00%)  
| Visit end datetime | N missing data (%) | 0 (0.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Visit source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 14 (100.00%)  
| Visit source value | N missing data (%) | 0 (0.00%)  
| Visit start date | N missing data (%) | 0 (0.00%)  
| Visit start datetime | N missing data (%) | 0 (0.00%)  
| Visit type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; overall; overall  
Number records | - | N | 7,234.00  
Number subjects | - | N (%) | 2,372 (88.05%)  
Records per person | - | Mean (SD) | 2.69 (1.89)  
|  | Median [Q25 - Q75] | 2.00 [1.00 - 4.00]  
|  | Range [min to max] | [0.00 to 12.00]  
In observation | No | N (%) | 445 (6.15%)  
| Yes | N (%) | 6,789 (93.85%)  
Domain | Condition | N (%) | 7,141 (98.71%)  
| - | N (%) | 93 (1.29%)  
Source vocabulary | No matching concept | N (%) | 93 (1.29%)  
| Snomed | N (%) | 7,141 (98.71%)  
Standard concept | S | N (%) | 7,141 (98.71%)  
| - | N (%) | 93 (1.29%)  
Type concept id | Ehr encounter diagnosis | N (%) | 7,234 (100.00%)  
Start date before birth date | - | N (%) | 0 (0.00%)  
End date before start date | - | N (%) | 0 (0.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 1,406 (19.44%)  
| Condition end datetime | N missing data (%) | 1,406 (19.44%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 7,234 (100.00%)  
| Condition status source value | N missing data (%) | 7,234 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 7,234 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 7,234 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 7,234 (100.00%)  
| Visit occurrence id | N missing data (%) | 8 (0.11%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; 0 to 59; overall  
Number records | - | N | 4,960.00  
Number subjects | - | N (%) | 1,643 (60.99%)  
Records per person | - | Mean (SD) | 1.84 (2.04)  
|  | Median [Q25 - Q75] | 1.00 [0.00 - 3.00]  
|  | Range [min to max] | [0.00 to 12.00]  
In observation | No | N (%) | 318 (6.41%)  
| Yes | N (%) | 4,642 (93.59%)  
Domain | Condition | N (%) | 4,869 (98.17%)  
| - | N (%) | 91 (1.83%)  
Source vocabulary | No matching concept | N (%) | 91 (1.83%)  
| Snomed | N (%) | 4,869 (98.17%)  
Standard concept | S | N (%) | 4,869 (98.17%)  
| - | N (%) | 91 (1.83%)  
Type concept id | Ehr encounter diagnosis | N (%) | 4,960 (100.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 1,084 (21.85%)  
| Condition end datetime | N missing data (%) | 1,084 (21.85%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,960 (100.00%)  
| Condition status source value | N missing data (%) | 4,960 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 4,960 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 4,960 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,960 (100.00%)  
| Visit occurrence id | N missing data (%) | 8 (0.16%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; 60 or above; overall  
Number records | - | N | 2,274.00  
Number subjects | - | N (%) | 880 (76.59%)  
Records per person | - | Mean (SD) | 1.98 (1.72)  
|  | Median [Q25 - Q75] | 2.00 [1.00 - 3.00]  
|  | Range [min to max] | [0.00 to 9.00]  
In observation | No | N (%) | 127 (5.58%)  
| Yes | N (%) | 2,147 (94.42%)  
Domain | Condition | N (%) | 2,272 (99.91%)  
| - | N (%) | 2 (0.09%)  
Source vocabulary | No matching concept | N (%) | 2 (0.09%)  
| Snomed | N (%) | 2,272 (99.91%)  
Standard concept | S | N (%) | 2,272 (99.91%)  
| - | N (%) | 2 (0.09%)  
Type concept id | Ehr encounter diagnosis | N (%) | 2,274 (100.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 322 (14.16%)  
| Condition end datetime | N missing data (%) | 322 (14.16%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,274 (100.00%)  
| Condition status source value | N missing data (%) | 2,274 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 2,274 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 2,274 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,274 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; overall; Female  
Number records | - | N | 3,712.00  
Number subjects | - | N (%) | 1,203 (87.62%)  
Records per person | - | Mean (SD) | 2.70 (1.88)  
|  | Median [Q25 - Q75] | 3.00 [1.00 - 4.00]  
|  | Range [min to max] | [0.00 to 10.00]  
In observation | No | N (%) | 224 (6.03%)  
| Yes | N (%) | 3,488 (93.97%)  
Domain | Condition | N (%) | 3,669 (98.84%)  
| - | N (%) | 43 (1.16%)  
Source vocabulary | No matching concept | N (%) | 43 (1.16%)  
| Snomed | N (%) | 3,669 (98.84%)  
Standard concept | S | N (%) | 3,669 (98.84%)  
| - | N (%) | 43 (1.16%)  
Type concept id | Ehr encounter diagnosis | N (%) | 3,712 (100.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 705 (18.99%)  
| Condition end datetime | N missing data (%) | 705 (18.99%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 3,712 (100.00%)  
| Condition status source value | N missing data (%) | 3,712 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 3,712 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 3,712 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 3,712 (100.00%)  
| Visit occurrence id | N missing data (%) | 5 (0.13%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; overall; Male  
Number records | - | N | 3,522.00  
Number subjects | - | N (%) | 1,169 (88.49%)  
Records per person | - | Mean (SD) | 2.67 (1.90)  
|  | Median [Q25 - Q75] | 2.00 [1.00 - 4.00]  
|  | Range [min to max] | [0.00 to 12.00]  
In observation | No | N (%) | 221 (6.27%)  
| Yes | N (%) | 3,301 (93.73%)  
Domain | Condition | N (%) | 3,472 (98.58%)  
| - | N (%) | 50 (1.42%)  
Source vocabulary | No matching concept | N (%) | 50 (1.42%)  
| Snomed | N (%) | 3,472 (98.58%)  
Standard concept | S | N (%) | 3,472 (98.58%)  
| - | N (%) | 50 (1.42%)  
Type concept id | Ehr encounter diagnosis | N (%) | 3,522 (100.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 701 (19.90%)  
| Condition end datetime | N missing data (%) | 701 (19.90%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 3,522 (100.00%)  
| Condition status source value | N missing data (%) | 3,522 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 3,522 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 3,522 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 3,522 (100.00%)  
| Visit occurrence id | N missing data (%) | 3 (0.09%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; 0 to 59; Female  
Number records | - | N | 2,569.00  
Number subjects | - | N (%) | 843 (61.40%)  
Records per person | - | Mean (SD) | 1.87 (2.02)  
|  | Median [Q25 - Q75] | 1.00 [0.00 - 3.00]  
|  | Range [min to max] | [0.00 to 10.00]  
In observation | No | N (%) | 160 (6.23%)  
| Yes | N (%) | 2,409 (93.77%)  
Domain | Condition | N (%) | 2,527 (98.37%)  
| - | N (%) | 42 (1.63%)  
Source vocabulary | No matching concept | N (%) | 42 (1.63%)  
| Snomed | N (%) | 2,527 (98.37%)  
Standard concept | S | N (%) | 2,527 (98.37%)  
| - | N (%) | 42 (1.63%)  
Type concept id | Ehr encounter diagnosis | N (%) | 2,569 (100.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 567 (22.07%)  
| Condition end datetime | N missing data (%) | 567 (22.07%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,569 (100.00%)  
| Condition status source value | N missing data (%) | 2,569 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 2,569 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 2,569 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,569 (100.00%)  
| Visit occurrence id | N missing data (%) | 5 (0.19%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; 0 to 59; Male  
Number records | - | N | 2,391.00  
Number subjects | - | N (%) | 800 (60.56%)  
Records per person | - | Mean (SD) | 1.81 (2.05)  
|  | Median [Q25 - Q75] | 1.00 [0.00 - 3.00]  
|  | Range [min to max] | [0.00 to 12.00]  
In observation | No | N (%) | 158 (6.61%)  
| Yes | N (%) | 2,233 (93.39%)  
Domain | Condition | N (%) | 2,342 (97.95%)  
| - | N (%) | 49 (2.05%)  
Source vocabulary | No matching concept | N (%) | 49 (2.05%)  
| Snomed | N (%) | 2,342 (97.95%)  
Standard concept | S | N (%) | 2,342 (97.95%)  
| - | N (%) | 49 (2.05%)  
Type concept id | Ehr encounter diagnosis | N (%) | 2,391 (100.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 517 (21.62%)  
| Condition end datetime | N missing data (%) | 517 (21.62%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,391 (100.00%)  
| Condition status source value | N missing data (%) | 2,391 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 2,391 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 2,391 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,391 (100.00%)  
| Visit occurrence id | N missing data (%) | 3 (0.13%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; 60 or above; Female  
Number records | - | N | 1,143.00  
Number subjects | - | N (%) | 436 (75.30%)  
Records per person | - | Mean (SD) | 1.97 (1.76)  
|  | Median [Q25 - Q75] | 2.00 [1.00 - 3.00]  
|  | Range [min to max] | [0.00 to 9.00]  
In observation | No | N (%) | 64 (5.60%)  
| Yes | N (%) | 1,079 (94.40%)  
Domain | Condition | N (%) | 1,142 (99.91%)  
| - | N (%) | 1 (0.09%)  
Source vocabulary | No matching concept | N (%) | 1 (0.09%)  
| Snomed | N (%) | 1,142 (99.91%)  
Standard concept | S | N (%) | 1,142 (99.91%)  
| - | N (%) | 1 (0.09%)  
Type concept id | Ehr encounter diagnosis | N (%) | 1,143 (100.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 138 (12.07%)  
| Condition end datetime | N missing data (%) | 138 (12.07%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,143 (100.00%)  
| Condition status source value | N missing data (%) | 1,143 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 1,143 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 1,143 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,143 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
condition_occurrence; 60 or above; Male  
Number records | - | N | 1,131.00  
Number subjects | - | N (%) | 444 (77.89%)  
Records per person | - | Mean (SD) | 1.98 (1.67)  
|  | Median [Q25 - Q75] | 2.00 [1.00 - 3.00]  
|  | Range [min to max] | [0.00 to 9.00]  
In observation | No | N (%) | 63 (5.57%)  
| Yes | N (%) | 1,068 (94.43%)  
Domain | Condition | N (%) | 1,130 (99.91%)  
| - | N (%) | 1 (0.09%)  
Source vocabulary | No matching concept | N (%) | 1 (0.09%)  
| Snomed | N (%) | 1,130 (99.91%)  
Standard concept | S | N (%) | 1,130 (99.91%)  
| - | N (%) | 1 (0.09%)  
Type concept id | Ehr encounter diagnosis | N (%) | 1,131 (100.00%)  
Column name | Condition concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition end date | N missing data (%) | 184 (16.27%)  
| Condition end datetime | N missing data (%) | 184 (16.27%)  
| Condition occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Condition source value | N missing data (%) | 0 (0.00%)  
| Condition start date | N missing data (%) | 0 (0.00%)  
| Condition start datetime | N missing data (%) | 0 (0.00%)  
| Condition status concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,131 (100.00%)  
| Condition status source value | N missing data (%) | 1,131 (100.00%)  
| Condition type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 1,131 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Stop reason | N missing data (%) | 1,131 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,131 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; overall; overall  
Number records | - | N | 8,899.00  
Number subjects | - | N (%) | 2,446 (90.79%)  
Records per person | - | Mean (SD) | 3.30 (2.03)  
|  | Median [Q25 - Q75] | 3.00 [2.00 - 4.00]  
|  | Range [min to max] | [0.00 to 16.00]  
In observation | No | N (%) | 247 (2.78%)  
| Yes | N (%) | 8,652 (97.22%)  
Domain | Drug | N (%) | 8,400 (94.39%)  
| - | N (%) | 499 (5.61%)  
Source vocabulary | Cvx | N (%) | 4,475 (50.29%)  
| No matching concept | N (%) | 499 (5.61%)  
| Rxnorm | N (%) | 3,925 (44.11%)  
Standard concept | S | N (%) | 8,400 (94.39%)  
| - | N (%) | 499 (5.61%)  
Type concept id | Dispensed in outpatient office | N (%) | 4,475 (50.29%)  
| Prescription written | N (%) | 4,424 (49.71%)  
Start date before birth date | - | N (%) | 0 (0.00%)  
End date before start date | - | N (%) | 0 (0.00%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 8,897 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 8,897 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 8,897 (100.00%)  
| Route source value | N missing data (%) | 8,897 (100.00%)  
| Sig | N missing data (%) | 8,897 (100.00%)  
| Stop reason | N missing data (%) | 8,897 (100.00%)  
| Verbatim end date | N missing data (%) | 1,187 (13.34%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 8,897 (100.00%)  
| Visit occurrence id | N missing data (%) | 66 (0.74%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; 0 to 59; overall  
Number records | - | N | 5,949.00  
Number subjects | - | N (%) | 1,617 (60.02%)  
Records per person | - | Mean (SD) | 2.21 (2.27)  
|  | Median [Q25 - Q75] | 2.00 [0.00 - 4.00]  
|  | Range [min to max] | [0.00 to 16.00]  
In observation | No | N (%) | 186 (3.13%)  
| Yes | N (%) | 5,763 (96.87%)  
Domain | Drug | N (%) | 5,452 (91.65%)  
| - | N (%) | 497 (8.35%)  
Source vocabulary | Cvx | N (%) | 3,120 (52.45%)  
| No matching concept | N (%) | 497 (8.35%)  
| Rxnorm | N (%) | 2,332 (39.20%)  
Standard concept | S | N (%) | 5,452 (91.65%)  
| - | N (%) | 497 (8.35%)  
Type concept id | Dispensed in outpatient office | N (%) | 3,120 (52.45%)  
| Prescription written | N (%) | 2,829 (47.55%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 5,949 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 5,949 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 5,949 (100.00%)  
| Route source value | N missing data (%) | 5,949 (100.00%)  
| Sig | N missing data (%) | 5,949 (100.00%)  
| Stop reason | N missing data (%) | 5,949 (100.00%)  
| Verbatim end date | N missing data (%) | 711 (11.95%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 5,949 (100.00%)  
| Visit occurrence id | N missing data (%) | 52 (0.87%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; 60 or above; overall  
Number records | - | N | 2,950.00  
Number subjects | - | N (%) | 955 (83.12%)  
Records per person | - | Mean (SD) | 2.57 (2.10)  
|  | Median [Q25 - Q75] | 2.00 [1.00 - 4.00]  
|  | Range [min to max] | [0.00 to 14.00]  
In observation | No | N (%) | 61 (2.07%)  
| Yes | N (%) | 2,889 (97.93%)  
Domain | Drug | N (%) | 2,948 (99.93%)  
| - | N (%) | 2 (0.07%)  
Source vocabulary | Cvx | N (%) | 1,355 (45.93%)  
| No matching concept | N (%) | 2 (0.07%)  
| Rxnorm | N (%) | 1,593 (54.00%)  
Standard concept | S | N (%) | 2,948 (99.93%)  
| - | N (%) | 2 (0.07%)  
Type concept id | Dispensed in outpatient office | N (%) | 1,355 (45.93%)  
| Prescription written | N (%) | 1,595 (54.07%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 2,948 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,948 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,948 (100.00%)  
| Route source value | N missing data (%) | 2,948 (100.00%)  
| Sig | N missing data (%) | 2,948 (100.00%)  
| Stop reason | N missing data (%) | 2,948 (100.00%)  
| Verbatim end date | N missing data (%) | 476 (16.15%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,948 (100.00%)  
| Visit occurrence id | N missing data (%) | 14 (0.47%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; overall; Female  
Number records | - | N | 4,495.00  
Number subjects | - | N (%) | 1,241 (90.39%)  
Records per person | - | Mean (SD) | 3.27 (2.03)  
|  | Median [Q25 - Q75] | 3.00 [2.00 - 4.00]  
|  | Range [min to max] | [0.00 to 16.00]  
In observation | No | N (%) | 121 (2.69%)  
| Yes | N (%) | 4,374 (97.31%)  
Domain | Drug | N (%) | 4,227 (94.04%)  
| - | N (%) | 268 (5.96%)  
Source vocabulary | Cvx | N (%) | 2,290 (50.95%)  
| No matching concept | N (%) | 268 (5.96%)  
| Rxnorm | N (%) | 1,937 (43.09%)  
Standard concept | S | N (%) | 4,227 (94.04%)  
| - | N (%) | 268 (5.96%)  
Type concept id | Dispensed in outpatient office | N (%) | 2,290 (50.95%)  
| Prescription written | N (%) | 2,205 (49.05%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 4,495 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,495 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,495 (100.00%)  
| Route source value | N missing data (%) | 4,495 (100.00%)  
| Sig | N missing data (%) | 4,495 (100.00%)  
| Stop reason | N missing data (%) | 4,495 (100.00%)  
| Verbatim end date | N missing data (%) | 531 (11.81%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,495 (100.00%)  
| Visit occurrence id | N missing data (%) | 36 (0.80%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; overall; Male  
Number records | - | N | 4,404.00  
Number subjects | - | N (%) | 1,205 (91.22%)  
Records per person | - | Mean (SD) | 3.33 (2.03)  
|  | Median [Q25 - Q75] | 3.00 [2.00 - 5.00]  
|  | Range [min to max] | [0.00 to 14.00]  
In observation | No | N (%) | 126 (2.86%)  
| Yes | N (%) | 4,278 (97.14%)  
Domain | Drug | N (%) | 4,173 (94.75%)  
| - | N (%) | 231 (5.25%)  
Source vocabulary | Cvx | N (%) | 2,185 (49.61%)  
| No matching concept | N (%) | 231 (5.25%)  
| Rxnorm | N (%) | 1,988 (45.14%)  
Standard concept | S | N (%) | 4,173 (94.75%)  
| - | N (%) | 231 (5.25%)  
Type concept id | Dispensed in outpatient office | N (%) | 2,185 (49.61%)  
| Prescription written | N (%) | 2,219 (50.39%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 4,402 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,402 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,402 (100.00%)  
| Route source value | N missing data (%) | 4,402 (100.00%)  
| Sig | N missing data (%) | 4,402 (100.00%)  
| Stop reason | N missing data (%) | 4,402 (100.00%)  
| Verbatim end date | N missing data (%) | 656 (14.90%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,402 (100.00%)  
| Visit occurrence id | N missing data (%) | 30 (0.68%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; 0 to 59; Female  
Number records | - | N | 3,120.00  
Number subjects | - | N (%) | 823 (59.94%)  
Records per person | - | Mean (SD) | 2.27 (2.32)  
|  | Median [Q25 - Q75] | 2.00 [0.00 - 4.00]  
|  | Range [min to max] | [0.00 to 16.00]  
In observation | No | N (%) | 93 (2.98%)  
| Yes | N (%) | 3,027 (97.02%)  
Domain | Drug | N (%) | 2,853 (91.44%)  
| - | N (%) | 267 (8.56%)  
Source vocabulary | Cvx | N (%) | 1,620 (51.92%)  
| No matching concept | N (%) | 267 (8.56%)  
| Rxnorm | N (%) | 1,233 (39.52%)  
Standard concept | S | N (%) | 2,853 (91.44%)  
| - | N (%) | 267 (8.56%)  
Type concept id | Dispensed in outpatient office | N (%) | 1,620 (51.92%)  
| Prescription written | N (%) | 1,500 (48.08%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 3,120 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 3,120 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 3,120 (100.00%)  
| Route source value | N missing data (%) | 3,120 (100.00%)  
| Sig | N missing data (%) | 3,120 (100.00%)  
| Stop reason | N missing data (%) | 3,120 (100.00%)  
| Verbatim end date | N missing data (%) | 345 (11.06%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 3,120 (100.00%)  
| Visit occurrence id | N missing data (%) | 31 (0.99%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; 0 to 59; Male  
Number records | - | N | 2,829.00  
Number subjects | - | N (%) | 794 (60.11%)  
Records per person | - | Mean (SD) | 2.14 (2.22)  
|  | Median [Q25 - Q75] | 2.00 [0.00 - 4.00]  
|  | Range [min to max] | [0.00 to 12.00]  
In observation | No | N (%) | 93 (3.29%)  
| Yes | N (%) | 2,736 (96.71%)  
Domain | Drug | N (%) | 2,599 (91.87%)  
| - | N (%) | 230 (8.13%)  
Source vocabulary | Cvx | N (%) | 1,500 (53.02%)  
| No matching concept | N (%) | 230 (8.13%)  
| Rxnorm | N (%) | 1,099 (38.85%)  
Standard concept | S | N (%) | 2,599 (91.87%)  
| - | N (%) | 230 (8.13%)  
Type concept id | Dispensed in outpatient office | N (%) | 1,500 (53.02%)  
| Prescription written | N (%) | 1,329 (46.98%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 2,829 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,829 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,829 (100.00%)  
| Route source value | N missing data (%) | 2,829 (100.00%)  
| Sig | N missing data (%) | 2,829 (100.00%)  
| Stop reason | N missing data (%) | 2,829 (100.00%)  
| Verbatim end date | N missing data (%) | 366 (12.94%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,829 (100.00%)  
| Visit occurrence id | N missing data (%) | 21 (0.74%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; 60 or above; Female  
Number records | - | N | 1,375.00  
Number subjects | - | N (%) | 476 (82.21%)  
Records per person | - | Mean (SD) | 2.37 (1.98)  
|  | Median [Q25 - Q75] | 2.00 [1.00 - 4.00]  
|  | Range [min to max] | [0.00 to 14.00]  
In observation | No | N (%) | 28 (2.04%)  
| Yes | N (%) | 1,347 (97.96%)  
Domain | Drug | N (%) | 1,374 (99.93%)  
| - | N (%) | 1 (0.07%)  
Source vocabulary | Cvx | N (%) | 670 (48.73%)  
| No matching concept | N (%) | 1 (0.07%)  
| Rxnorm | N (%) | 704 (51.20%)  
Standard concept | S | N (%) | 1,374 (99.93%)  
| - | N (%) | 1 (0.07%)  
Type concept id | Dispensed in outpatient office | N (%) | 670 (48.73%)  
| Prescription written | N (%) | 705 (51.27%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 1,375 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,375 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,375 (100.00%)  
| Route source value | N missing data (%) | 1,375 (100.00%)  
| Sig | N missing data (%) | 1,375 (100.00%)  
| Stop reason | N missing data (%) | 1,375 (100.00%)  
| Verbatim end date | N missing data (%) | 186 (13.53%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,375 (100.00%)  
| Visit occurrence id | N missing data (%) | 5 (0.36%)  
|  | N zeros (%) | 0 (0.00%)  
drug_exposure; 60 or above; Male  
Number records | - | N | 1,575.00  
Number subjects | - | N (%) | 479 (84.04%)  
Records per person | - | Mean (SD) | 2.76 (2.20)  
|  | Median [Q25 - Q75] | 2.50 [1.00 - 4.00]  
|  | Range [min to max] | [0.00 to 13.00]  
In observation | No | N (%) | 33 (2.10%)  
| Yes | N (%) | 1,542 (97.90%)  
Domain | Drug | N (%) | 1,574 (99.94%)  
| - | N (%) | 1 (0.06%)  
Source vocabulary | Cvx | N (%) | 685 (43.49%)  
| No matching concept | N (%) | 1 (0.06%)  
| Rxnorm | N (%) | 889 (56.44%)  
Standard concept | S | N (%) | 1,574 (99.94%)  
| - | N (%) | 1 (0.06%)  
Type concept id | Dispensed in outpatient office | N (%) | 685 (43.49%)  
| Prescription written | N (%) | 890 (56.51%)  
Column name | Days supply | N missing data (%) | 0 (0.00%)  
| Dose unit source value | N missing data (%) | 1,573 (100.00%)  
| Drug concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure end date | N missing data (%) | 0 (0.00%)  
| Drug exposure end datetime | N missing data (%) | 0 (0.00%)  
| Drug exposure id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug exposure start date | N missing data (%) | 0 (0.00%)  
| Drug exposure start datetime | N missing data (%) | 0 (0.00%)  
| Drug source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Drug source value | N missing data (%) | 0 (0.00%)  
| Drug type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Lot number | N missing data (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,573 (100.00%)  
| Quantity | N missing data (%) | 0 (0.00%)  
| Refills | N missing data (%) | 0 (0.00%)  
| Route concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,573 (100.00%)  
| Route source value | N missing data (%) | 1,573 (100.00%)  
| Sig | N missing data (%) | 1,573 (100.00%)  
| Stop reason | N missing data (%) | 1,573 (100.00%)  
| Verbatim end date | N missing data (%) | 290 (18.44%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,573 (100.00%)  
| Visit occurrence id | N missing data (%) | 9 (0.57%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; overall; overall  
Number records | - | N | 2,807.00  
Number subjects | - | N (%) | 969 (35.97%)  
Records per person | - | Mean (SD) | 1.04 (2.53)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 1.00]  
|  | Range [min to max] | [0.00 to 58.00]  
In observation | No | N (%) | 6 (0.21%)  
| Yes | N (%) | 2,801 (99.79%)  
Domain | Procedure | N (%) | 2,807 (100.00%)  
Source vocabulary | Snomed | N (%) | 2,807 (100.00%)  
Standard concept | S | N (%) | 2,807 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 2,807 (100.00%)  
Start date before birth date | - | N (%) | 0 (0.00%)  
End date before start date | - | N (%) | 0 (0.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,807 (100.00%)  
| Modifier source value | N missing data (%) | 2,807 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 2,807 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 2,807 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,807 (100.00%)  
| Visit occurrence id | N missing data (%) | 26 (0.93%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; 0 to 59; overall  
Number records | - | N | 1,162.00  
Number subjects | - | N (%) | 543 (20.16%)  
Records per person | - | Mean (SD) | 0.43 (1.78)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 58.00]  
In observation | No | N (%) | 2 (0.17%)  
| Yes | N (%) | 1,160 (99.83%)  
Domain | Procedure | N (%) | 1,162 (100.00%)  
Source vocabulary | Snomed | N (%) | 1,162 (100.00%)  
Standard concept | S | N (%) | 1,162 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 1,162 (100.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,162 (100.00%)  
| Modifier source value | N missing data (%) | 1,162 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 1,162 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 1,162 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,162 (100.00%)  
| Visit occurrence id | N missing data (%) | 2 (0.17%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; 60 or above; overall  
Number records | - | N | 1,645.00  
Number subjects | - | N (%) | 460 (40.03%)  
Records per person | - | Mean (SD) | 1.43 (2.66)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 2.00]  
|  | Range [min to max] | [0.00 to 17.00]  
In observation | No | N (%) | 4 (0.24%)  
| Yes | N (%) | 1,641 (99.76%)  
Domain | Procedure | N (%) | 1,645 (100.00%)  
Source vocabulary | Snomed | N (%) | 1,645 (100.00%)  
Standard concept | S | N (%) | 1,645 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 1,645 (100.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,645 (100.00%)  
| Modifier source value | N missing data (%) | 1,645 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 1,645 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 1,645 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,645 (100.00%)  
| Visit occurrence id | N missing data (%) | 24 (1.46%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; overall; Female  
Number records | - | N | 1,377.00  
Number subjects | - | N (%) | 476 (34.67%)  
Records per person | - | Mean (SD) | 1.00 (2.32)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 1.00]  
|  | Range [min to max] | [0.00 to 37.00]  
In observation | No | N (%) | 2 (0.15%)  
| Yes | N (%) | 1,375 (99.85%)  
Domain | Procedure | N (%) | 1,377 (100.00%)  
Source vocabulary | Snomed | N (%) | 1,377 (100.00%)  
Standard concept | S | N (%) | 1,377 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 1,377 (100.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,377 (100.00%)  
| Modifier source value | N missing data (%) | 1,377 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 1,377 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 1,377 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,377 (100.00%)  
| Visit occurrence id | N missing data (%) | 12 (0.87%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; overall; Male  
Number records | - | N | 1,430.00  
Number subjects | - | N (%) | 493 (37.32%)  
Records per person | - | Mean (SD) | 1.08 (2.72)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 1.00]  
|  | Range [min to max] | [0.00 to 58.00]  
In observation | No | N (%) | 4 (0.28%)  
| Yes | N (%) | 1,426 (99.72%)  
Domain | Procedure | N (%) | 1,430 (100.00%)  
Source vocabulary | Snomed | N (%) | 1,430 (100.00%)  
Standard concept | S | N (%) | 1,430 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 1,430 (100.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,430 (100.00%)  
| Modifier source value | N missing data (%) | 1,430 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 1,430 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 1,430 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,430 (100.00%)  
| Visit occurrence id | N missing data (%) | 14 (0.98%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; 0 to 59; Female  
Number records | - | N | 580.00  
Number subjects | - | N (%) | 268 (19.52%)  
Records per person | - | Mean (SD) | 0.42 (1.55)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 37.00]  
In observation | Yes | N (%) | 580 (100.00%)  
Domain | Procedure | N (%) | 580 (100.00%)  
Source vocabulary | Snomed | N (%) | 580 (100.00%)  
Standard concept | S | N (%) | 580 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 580 (100.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 580 (100.00%)  
| Modifier source value | N missing data (%) | 580 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 580 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 580 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 580 (100.00%)  
| Visit occurrence id | N missing data (%) | 1 (0.17%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; 0 to 59; Male  
Number records | - | N | 582.00  
Number subjects | - | N (%) | 275 (20.82%)  
Records per person | - | Mean (SD) | 0.44 (2.00)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 58.00]  
In observation | No | N (%) | 2 (0.34%)  
| Yes | N (%) | 580 (99.66%)  
Domain | Procedure | N (%) | 582 (100.00%)  
Source vocabulary | Snomed | N (%) | 582 (100.00%)  
Standard concept | S | N (%) | 582 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 582 (100.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 582 (100.00%)  
| Modifier source value | N missing data (%) | 582 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 582 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 582 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 582 (100.00%)  
| Visit occurrence id | N missing data (%) | 1 (0.17%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; 60 or above; Female  
Number records | - | N | 797.00  
Number subjects | - | N (%) | 225 (38.86%)  
Records per person | - | Mean (SD) | 1.38 (2.58)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 2.00]  
|  | Range [min to max] | [0.00 to 16.00]  
In observation | No | N (%) | 2 (0.25%)  
| Yes | N (%) | 795 (99.75%)  
Domain | Procedure | N (%) | 797 (100.00%)  
Source vocabulary | Snomed | N (%) | 797 (100.00%)  
Standard concept | S | N (%) | 797 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 797 (100.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 797 (100.00%)  
| Modifier source value | N missing data (%) | 797 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 797 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 797 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 797 (100.00%)  
| Visit occurrence id | N missing data (%) | 11 (1.38%)  
|  | N zeros (%) | 0 (0.00%)  
procedure_occurrence; 60 or above; Male  
Number records | - | N | 848.00  
Number subjects | - | N (%) | 235 (41.23%)  
Records per person | - | Mean (SD) | 1.49 (2.74)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 2.00]  
|  | Range [min to max] | [0.00 to 17.00]  
In observation | No | N (%) | 2 (0.24%)  
| Yes | N (%) | 846 (99.76%)  
Domain | Procedure | N (%) | 848 (100.00%)  
Source vocabulary | Snomed | N (%) | 848 (100.00%)  
Standard concept | S | N (%) | 848 (100.00%)  
Type concept id | Ehr order list entry | N (%) | 848 (100.00%)  
Column name | Modifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 848 (100.00%)  
| Modifier source value | N missing data (%) | 848 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure date | N missing data (%) | 0 (0.00%)  
| Procedure datetime | N missing data (%) | 0 (0.00%)  
| Procedure occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Procedure source value | N missing data (%) | 0 (0.00%)  
| Procedure type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 848 (100.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Quantity | N missing data (%) | 848 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 848 (100.00%)  
| Visit occurrence id | N missing data (%) | 13 (1.53%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; overall; overall  
Number records | - | N | 4,335.00  
Number subjects | - | N (%) | 1,453 (53.93%)  
Records per person | - | Mean (SD) | 1.61 (3.82)  
|  | Median [Q25 - Q75] | 1.00 [0.00 - 2.00]  
|  | Range [min to max] | [0.00 to 65.00]  
In observation | Yes | N (%) | 4,335 (100.00%)  
Domain | Measurement | N (%) | 4,335 (100.00%)  
Source vocabulary | Loinc | N (%) | 2,899 (66.87%)  
| Snomed | N (%) | 1,436 (33.13%)  
Standard concept | S | N (%) | 4,335 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 4,335 (100.00%)  
Start date before birth date | - | N (%) | 0 (0.00%)  
End date before start date | - | N (%) | 0 (0.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,335 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,335 (100.00%)  
| Range high | N missing data (%) | 4,335 (100.00%)  
| Range low | N missing data (%) | 4,335 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,335 (100.00%)  
| Unit source value | N missing data (%) | 4,335 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,335 (100.00%)  
| Value as number | N missing data (%) | 4,335 (100.00%)  
| Value source value | N missing data (%) | 4,335 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 4,335 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; 0 to 59; overall  
Number records | - | N | 2,492.00  
Number subjects | - | N (%) | 941 (34.93%)  
Records per person | - | Mean (SD) | 0.92 (2.61)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 1.00]  
|  | Range [min to max] | [0.00 to 52.00]  
In observation | Yes | N (%) | 2,492 (100.00%)  
Domain | Measurement | N (%) | 2,492 (100.00%)  
Source vocabulary | Loinc | N (%) | 1,623 (65.13%)  
| Snomed | N (%) | 869 (34.87%)  
Standard concept | S | N (%) | 2,492 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 2,492 (100.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,492 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,492 (100.00%)  
| Range high | N missing data (%) | 2,492 (100.00%)  
| Range low | N missing data (%) | 2,492 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,492 (100.00%)  
| Unit source value | N missing data (%) | 2,492 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,492 (100.00%)  
| Value as number | N missing data (%) | 2,492 (100.00%)  
| Value source value | N missing data (%) | 2,492 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,492 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; 60 or above; overall  
Number records | - | N | 1,843.00  
Number subjects | - | N (%) | 567 (49.35%)  
Records per person | - | Mean (SD) | 1.60 (4.06)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 1.00]  
|  | Range [min to max] | [0.00 to 63.00]  
In observation | Yes | N (%) | 1,843 (100.00%)  
Domain | Measurement | N (%) | 1,843 (100.00%)  
Source vocabulary | Loinc | N (%) | 1,276 (69.23%)  
| Snomed | N (%) | 567 (30.77%)  
Standard concept | S | N (%) | 1,843 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 1,843 (100.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,843 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,843 (100.00%)  
| Range high | N missing data (%) | 1,843 (100.00%)  
| Range low | N missing data (%) | 1,843 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,843 (100.00%)  
| Unit source value | N missing data (%) | 1,843 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,843 (100.00%)  
| Value as number | N missing data (%) | 1,843 (100.00%)  
| Value source value | N missing data (%) | 1,843 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,843 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; overall; Female  
Number records | - | N | 2,352.00  
Number subjects | - | N (%) | 760 (55.35%)  
Records per person | - | Mean (SD) | 1.71 (3.90)  
|  | Median [Q25 - Q75] | 1.00 [0.00 - 2.00]  
|  | Range [min to max] | [0.00 to 63.00]  
In observation | Yes | N (%) | 2,352 (100.00%)  
Domain | Measurement | N (%) | 2,352 (100.00%)  
Source vocabulary | Loinc | N (%) | 1,558 (66.24%)  
| Snomed | N (%) | 794 (33.76%)  
Standard concept | S | N (%) | 2,352 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 2,352 (100.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,352 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,352 (100.00%)  
| Range high | N missing data (%) | 2,352 (100.00%)  
| Range low | N missing data (%) | 2,352 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,352 (100.00%)  
| Unit source value | N missing data (%) | 2,352 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,352 (100.00%)  
| Value as number | N missing data (%) | 2,352 (100.00%)  
| Value source value | N missing data (%) | 2,352 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 2,352 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; overall; Male  
Number records | - | N | 1,983.00  
Number subjects | - | N (%) | 693 (52.46%)  
Records per person | - | Mean (SD) | 1.50 (3.74)  
|  | Median [Q25 - Q75] | 1.00 [0.00 - 2.00]  
|  | Range [min to max] | [0.00 to 65.00]  
In observation | Yes | N (%) | 1,983 (100.00%)  
Domain | Measurement | N (%) | 1,983 (100.00%)  
Source vocabulary | Loinc | N (%) | 1,341 (67.62%)  
| Snomed | N (%) | 642 (32.38%)  
Standard concept | S | N (%) | 1,983 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 1,983 (100.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,983 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,983 (100.00%)  
| Range high | N missing data (%) | 1,983 (100.00%)  
| Range low | N missing data (%) | 1,983 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,983 (100.00%)  
| Unit source value | N missing data (%) | 1,983 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,983 (100.00%)  
| Value as number | N missing data (%) | 1,983 (100.00%)  
| Value source value | N missing data (%) | 1,983 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,983 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; 0 to 59; Female  
Number records | - | N | 1,323.00  
Number subjects | - | N (%) | 499 (36.34%)  
Records per person | - | Mean (SD) | 0.96 (2.44)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 1.00]  
|  | Range [min to max] | [0.00 to 32.00]  
In observation | Yes | N (%) | 1,323 (100.00%)  
Domain | Measurement | N (%) | 1,323 (100.00%)  
Source vocabulary | Loinc | N (%) | 850 (64.25%)  
| Snomed | N (%) | 473 (35.75%)  
Standard concept | S | N (%) | 1,323 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 1,323 (100.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,323 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,323 (100.00%)  
| Range high | N missing data (%) | 1,323 (100.00%)  
| Range low | N missing data (%) | 1,323 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,323 (100.00%)  
| Unit source value | N missing data (%) | 1,323 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,323 (100.00%)  
| Value as number | N missing data (%) | 1,323 (100.00%)  
| Value source value | N missing data (%) | 1,323 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,323 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; 0 to 59; Male  
Number records | - | N | 1,169.00  
Number subjects | - | N (%) | 442 (33.46%)  
Records per person | - | Mean (SD) | 0.88 (2.77)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 1.00]  
|  | Range [min to max] | [0.00 to 52.00]  
In observation | Yes | N (%) | 1,169 (100.00%)  
Domain | Measurement | N (%) | 1,169 (100.00%)  
Source vocabulary | Loinc | N (%) | 773 (66.12%)  
| Snomed | N (%) | 396 (33.88%)  
Standard concept | S | N (%) | 1,169 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 1,169 (100.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,169 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,169 (100.00%)  
| Range high | N missing data (%) | 1,169 (100.00%)  
| Range low | N missing data (%) | 1,169 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,169 (100.00%)  
| Unit source value | N missing data (%) | 1,169 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,169 (100.00%)  
| Value as number | N missing data (%) | 1,169 (100.00%)  
| Value source value | N missing data (%) | 1,169 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,169 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; 60 or above; Female  
Number records | - | N | 1,029.00  
Number subjects | - | N (%) | 294 (50.78%)  
Records per person | - | Mean (SD) | 1.78 (4.59)  
|  | Median [Q25 - Q75] | 1.00 [0.00 - 2.00]  
|  | Range [min to max] | [0.00 to 63.00]  
In observation | Yes | N (%) | 1,029 (100.00%)  
Domain | Measurement | N (%) | 1,029 (100.00%)  
Source vocabulary | Loinc | N (%) | 708 (68.80%)  
| Snomed | N (%) | 321 (31.20%)  
Standard concept | S | N (%) | 1,029 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 1,029 (100.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,029 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,029 (100.00%)  
| Range high | N missing data (%) | 1,029 (100.00%)  
| Range low | N missing data (%) | 1,029 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,029 (100.00%)  
| Unit source value | N missing data (%) | 1,029 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,029 (100.00%)  
| Value as number | N missing data (%) | 1,029 (100.00%)  
| Value source value | N missing data (%) | 1,029 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 1,029 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
measurement; 60 or above; Male  
Number records | - | N | 814.00  
Number subjects | - | N (%) | 273 (47.89%)  
Records per person | - | Mean (SD) | 1.43 (3.45)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 1.00]  
|  | Range [min to max] | [0.00 to 36.00]  
In observation | Yes | N (%) | 814 (100.00%)  
Domain | Measurement | N (%) | 814 (100.00%)  
Source vocabulary | Loinc | N (%) | 568 (69.78%)  
| Snomed | N (%) | 246 (30.22%)  
Standard concept | S | N (%) | 814 (100.00%)  
Type concept id | Test ordered through ehr | N (%) | 814 (100.00%)  
Column name | Measurement concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement date | N missing data (%) | 0 (0.00%)  
| Measurement datetime | N missing data (%) | 0 (0.00%)  
| Measurement id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Measurement source value | N missing data (%) | 0 (0.00%)  
| Measurement time | N missing data (%) | 0 (0.00%)  
| Measurement type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Operator concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 814 (100.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 814 (100.00%)  
| Range high | N missing data (%) | 814 (100.00%)  
| Range low | N missing data (%) | 814 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 814 (100.00%)  
| Unit source value | N missing data (%) | 814 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 814 (100.00%)  
| Value as number | N missing data (%) | 814 (100.00%)  
| Value source value | N missing data (%) | 814 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 814 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; overall; overall  
Number records | - | N | 56.00  
Number subjects | - | N (%) | 55 (2.04%)  
Records per person | - | Mean (SD) | 0.02 (0.15)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 56 (100.00%)  
Domain | Observation | N (%) | 56 (100.00%)  
Source vocabulary | Snomed | N (%) | 56 (100.00%)  
Standard concept | S | N (%) | 56 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 56 (100.00%)  
Start date before birth date | - | N (%) | 0 (0.00%)  
End date before start date | - | N (%) | 0 (0.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 56 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 56 (100.00%)  
| Qualifier source value | N missing data (%) | 56 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 56 (100.00%)  
| Unit source value | N missing data (%) | 56 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 56 (100.00%)  
| Value as number | N missing data (%) | 56 (100.00%)  
| Value as string | N missing data (%) | 56 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 56 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; 0 to 59; overall  
Number records | - | N | 31.00  
Number subjects | - | N (%) | 31 (1.15%)  
Records per person | - | Mean (SD) | 0.01 (0.11)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 1.00]  
In observation | Yes | N (%) | 31 (100.00%)  
Domain | Observation | N (%) | 31 (100.00%)  
Source vocabulary | Snomed | N (%) | 31 (100.00%)  
Standard concept | S | N (%) | 31 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 31 (100.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 31 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 31 (100.00%)  
| Qualifier source value | N missing data (%) | 31 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 31 (100.00%)  
| Unit source value | N missing data (%) | 31 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 31 (100.00%)  
| Value as number | N missing data (%) | 31 (100.00%)  
| Value as string | N missing data (%) | 31 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 31 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; 60 or above; overall  
Number records | - | N | 25.00  
Number subjects | - | N (%) | 24 (2.09%)  
Records per person | - | Mean (SD) | 0.02 (0.15)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 25 (100.00%)  
Domain | Observation | N (%) | 25 (100.00%)  
Source vocabulary | Snomed | N (%) | 25 (100.00%)  
Standard concept | S | N (%) | 25 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 25 (100.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 25 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 25 (100.00%)  
| Qualifier source value | N missing data (%) | 25 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 25 (100.00%)  
| Unit source value | N missing data (%) | 25 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 25 (100.00%)  
| Value as number | N missing data (%) | 25 (100.00%)  
| Value as string | N missing data (%) | 25 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 25 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; overall; Female  
Number records | - | N | 21.00  
Number subjects | - | N (%) | 20 (1.46%)  
Records per person | - | Mean (SD) | 0.02 (0.13)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 21 (100.00%)  
Domain | Observation | N (%) | 21 (100.00%)  
Source vocabulary | Snomed | N (%) | 21 (100.00%)  
Standard concept | S | N (%) | 21 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 21 (100.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 21 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 21 (100.00%)  
| Qualifier source value | N missing data (%) | 21 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 21 (100.00%)  
| Unit source value | N missing data (%) | 21 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 21 (100.00%)  
| Value as number | N missing data (%) | 21 (100.00%)  
| Value as string | N missing data (%) | 21 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 21 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; overall; Male  
Number records | - | N | 35.00  
Number subjects | - | N (%) | 35 (2.65%)  
Records per person | - | Mean (SD) | 0.03 (0.16)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 1.00]  
In observation | Yes | N (%) | 35 (100.00%)  
Domain | Observation | N (%) | 35 (100.00%)  
Source vocabulary | Snomed | N (%) | 35 (100.00%)  
Standard concept | S | N (%) | 35 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 35 (100.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 35 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 35 (100.00%)  
| Qualifier source value | N missing data (%) | 35 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 35 (100.00%)  
| Unit source value | N missing data (%) | 35 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 35 (100.00%)  
| Value as number | N missing data (%) | 35 (100.00%)  
| Value as string | N missing data (%) | 35 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 35 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; 0 to 59; Female  
Number records | - | N | 12.00  
Number subjects | - | N (%) | 12 (0.87%)  
Records per person | - | Mean (SD) | 0.01 (0.09)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 1.00]  
In observation | Yes | N (%) | 12 (100.00%)  
Domain | Observation | N (%) | 12 (100.00%)  
Source vocabulary | Snomed | N (%) | 12 (100.00%)  
Standard concept | S | N (%) | 12 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 12 (100.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 12 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 12 (100.00%)  
| Qualifier source value | N missing data (%) | 12 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 12 (100.00%)  
| Unit source value | N missing data (%) | 12 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 12 (100.00%)  
| Value as number | N missing data (%) | 12 (100.00%)  
| Value as string | N missing data (%) | 12 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 12 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; 0 to 59; Male  
Number records | - | N | 19.00  
Number subjects | - | N (%) | 19 (1.44%)  
Records per person | - | Mean (SD) | 0.01 (0.12)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 1.00]  
In observation | Yes | N (%) | 19 (100.00%)  
Domain | Observation | N (%) | 19 (100.00%)  
Source vocabulary | Snomed | N (%) | 19 (100.00%)  
Standard concept | S | N (%) | 19 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 19 (100.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 19 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 19 (100.00%)  
| Qualifier source value | N missing data (%) | 19 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 19 (100.00%)  
| Unit source value | N missing data (%) | 19 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 19 (100.00%)  
| Value as number | N missing data (%) | 19 (100.00%)  
| Value as string | N missing data (%) | 19 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 19 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; 60 or above; Female  
Number records | - | N | 9.00  
Number subjects | - | N (%) | 8 (1.38%)  
Records per person | - | Mean (SD) | 0.02 (0.14)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 2.00]  
In observation | Yes | N (%) | 9 (100.00%)  
Domain | Observation | N (%) | 9 (100.00%)  
Source vocabulary | Snomed | N (%) | 9 (100.00%)  
Standard concept | S | N (%) | 9 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 9 (100.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 9 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 9 (100.00%)  
| Qualifier source value | N missing data (%) | 9 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 9 (100.00%)  
| Unit source value | N missing data (%) | 9 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 9 (100.00%)  
| Value as number | N missing data (%) | 9 (100.00%)  
| Value as string | N missing data (%) | 9 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 9 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
observation; 60 or above; Male  
Number records | - | N | 16.00  
Number subjects | - | N (%) | 16 (2.81%)  
Records per person | - | Mean (SD) | 0.03 (0.17)  
|  | Median [Q25 - Q75] | 0.00 [0.00 - 0.00]  
|  | Range [min to max] | [0.00 to 1.00]  
In observation | Yes | N (%) | 16 (100.00%)  
Domain | Observation | N (%) | 16 (100.00%)  
Source vocabulary | Snomed | N (%) | 16 (100.00%)  
Standard concept | S | N (%) | 16 (100.00%)  
Type concept id | Problem list from ehr | N (%) | 16 (100.00%)  
Column name | Observation concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation date | N missing data (%) | 0 (0.00%)  
| Observation datetime | N missing data (%) | 0 (0.00%)  
| Observation id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Observation source value | N missing data (%) | 0 (0.00%)  
| Observation type concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Person id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
| Provider id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 16 (100.00%)  
| Qualifier concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 16 (100.00%)  
| Qualifier source value | N missing data (%) | 16 (100.00%)  
| Unit concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 16 (100.00%)  
| Unit source value | N missing data (%) | 16 (100.00%)  
| Value as concept id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 16 (100.00%)  
| Value as number | N missing data (%) | 16 (100.00%)  
| Value as string | N missing data (%) | 16 (100.00%)  
| Visit detail id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 16 (100.00%)  
| Visit occurrence id | N missing data (%) | 0 (0.00%)  
|  | N zeros (%) | 0 (0.00%)  
  
### Records in observation

We can retrieve the number of records in observation for each table using the `[summariseRecordCount()](../reference/summariseRecordCount.html)` function.
    
    
    result_recordCounts <- [summariseRecordCount](../reference/summariseRecordCount.html)(cdm,
      tableName,
      sex = sex,
      ageGroup = ageGroup,
      interval = interval,
      dateRange = dateRange
    )
    result_recordCounts |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(group_level [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("drug_exposure", "condition_occurrence")) |>
      [plotRecordCount](../reference/plotRecordCount.html)(
        colour = "omop_table",
        facet = [c](https://rdrr.io/r/base/c.html)("sex", "age_group")
      )

![](characterisation_files/figure-html/unnamed-chunk-7-1.png)

### Concept id counts

We can then use the `[summariseConceptIdCounts()](../reference/summariseConceptIdCounts.html)` function to compute the record counts for each concept_id present in the analysed OMOP tables.
    
    
    result_conceptIdCount <- OmopSketch::[summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm,
      omopTableName = tableName,
      sex = sex,
      ageGroup = ageGroup,
      interval = interval,
      dateRange = dateRange
    )
    result_conceptIdCount |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 10,614
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "Eunomia", "Eunomia", "Eunomia", "Eunomia", "Eunomia"…
    #> $ group_name       <chr> "omop_table", "omop_table", "omop_table", "omop_table…
    #> $ group_level      <chr> "visit_occurrence", "visit_occurrence", "visit_occurr…
    #> $ strata_name      <chr> "overall", "age_group", "age_group", "sex", "sex", "o…
    #> $ strata_level     <chr> "overall", "0 to 59", "60 or above", "Female", "Male"…
    #> $ variable_name    <chr> "Inpatient Visit", "Inpatient Visit", "Inpatient Visi…
    #> $ variable_level   <chr> "9201", "9201", "9201", "9201", "9201", "9201", "9201…
    #> $ estimate_name    <chr> "count_records", "count_records", "count_records", "c…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "163", "131", "32", "85", "78", "17", "20", "9", "19"…
    #> $ additional_name  <chr> "source_concept_id &&& source_concept_name", "source_…
    #> $ additional_level <chr> "0 &&& No matching concept", "0 &&& No matching conce…

## Observation period characterisation

`OmopSketch` can also provide an overview of the `observation_period` table.

### Subjects in observation

The `[summariseInObservation()](../reference/summariseInObservation.html)` function calculates the number of subjects and the distribution of person-days in observation across specific time intervals.
    
    
    
    result_inObservation <-[summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period,
                                                  output = [c](https://rdrr.io/r/base/c.html)("record","person-days"),
                                                  interval = interval,
                                                  sex = sex,
                                                  ageGroup = ageGroup,
                                                  dateRange = dateRange) 
    
    result_inObservation |>    
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Person-days") |>
      [plotInObservation](../reference/plotInObservation.html)(colour = "sex", 
                        facet = "age_group")

![](characterisation_files/figure-html/unnamed-chunk-9-1.png)
    
    
    
    
    result_inObservation |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Person-days") |>
      [plotInObservation](../reference/plotInObservation.html)(
        colour = "sex",
        facet = "age_group"
      )

![](characterisation_files/figure-html/unnamed-chunk-9-2.png)

### Observation periods

From the `observation_table`, we can extract information on the duration of observation periods, the time until the next observation period, and the number of subjects in each ordinal observation period (1st, 2nd, etc.). This can be done using the `[summariseObservationPeriod()](../reference/summariseObservationPeriod.html)` function.
    
    
    result_observationPeriod <- [summariseObservationPeriod](../reference/summariseObservationPeriod.html)(cdm$observation_period,
      sex = sex,
      ageGroup = ageGroup,
      dateRange = dateRange
    )
    #> ℹ retrieving cdm object from cdm_table.
    
    result_observationPeriod |>
      [plotObservationPeriod](../reference/plotObservationPeriod.html)(
        variableName = "Duration in days",
        plotType = "boxplot",
        colour = "sex",
        facet = "age_group"
      )

![](characterisation_files/figure-html/unnamed-chunk-10-1.png)

Finally, disconnect from the cdm
    
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)

The results of the characterisation using `OmopSketch` can be further explored through the ShinyApp at <https://dpa-pde-oxford.shinyapps.io/OmopSketch-vignette/>

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
