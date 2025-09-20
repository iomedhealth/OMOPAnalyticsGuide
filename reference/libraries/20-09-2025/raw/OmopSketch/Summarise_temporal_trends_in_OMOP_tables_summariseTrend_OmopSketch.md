# Summarise temporal trends in OMOP tables — summariseTrend • OmopSketch

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

# Summarise temporal trends in OMOP tables

Source: [`R/summariseTrend.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summariseTrend.R)

`summariseTrend.Rd`

This function summarises temporal trends from OMOP CDM tables, considering only data within the observation period. It supports both event and episode tables and can report trends such as number of records, number of subjects, person-days, median age, and number of females.

## Usage
    
    
    summariseTrend(
      cdm,
      event = NULL,
      episode = NULL,
      output = "record",
      interval = "overall",
      ageGroup = NULL,
      sex = FALSE,
      dateRange = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object.

event
    

A character vector of OMOP table names to treat as event tables (uses only start date).

episode
    

A character vector of OMOP table names to treat as episode tables (uses start and end date).

output
    

A character vector indicating what to summarise. Options include `"record"` (default), `"person"`, `"person-days"`, `"age"`, `"sex"`. If included, the number of person-days is computed only for episode tables.

interval
    

Time granularity for trends. One of `"overall"` (default), `"years"`, `"quarters"`, or `"months"`.

ageGroup
    

A list of age groups to stratify results by.

sex
    

Logical. If `TRUE`, stratify results by sex.

dateRange
    

A vector of two dates defining the desired study period. If `dateRange` is `NULL`, no restriction is applied.

## Value

A summarised_result object.

## Details

  * **Event tables** : Records are included if their **start date** falls within the study period. Each record contributes to the time interval containing the start date.

  * **Episode tables** : Records are included if their **start or end date** overlaps with the study period. Records are **trimmed** to the date range, and contribute to **all** overlapping time intervals between start and end dates.




## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    
    summarisedResult <- summariseTrend(
      cdm = cdm,
      event = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "drug_exposure"),
      episode = "observation_period",
      interval = "years",
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<=20" = [c](https://rdrr.io/r/base/c.html)(0, 20), ">20" = [c](https://rdrr.io/r/base/c.html)(21, Inf)),
      sex = TRUE,
      dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1950-01-01", "2010-12-31"))
    )
    #> → The observation period in the cdm starts in 1956-03-24
    
    summarisedResult |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2,544
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,…
    #> $ cdm_name         <chr> "mockOmopSketch", "mockOmopSketch", "mockOmopSketch",…
    #> $ group_name       <chr> "omop_table", "omop_table", "omop_table", "omop_table…
    #> $ group_level      <chr> "condition_occurrence", "condition_occurrence", "cond…
    #> $ strata_name      <chr> "overall", "age_group", "sex", "sex &&& age_group", "…
    #> $ strata_level     <chr> "overall", "<=20", "Male", "Male &&& <=20", "overall"…
    #> $ variable_name    <chr> "Records in observation", "Records in observation", "…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "count", "count", "percentage", "pe…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "percenta…
    #> $ estimate_value   <chr> "20", "20", "20", "20", "0.35", "0.35", "0.35", "0.35…
    #> $ additional_name  <chr> "time_interval", "time_interval", "time_interval", "t…
    #> $ additional_level <chr> "1956-01-01 to 1956-12-31", "1956-01-01 to 1956-12-31…
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
