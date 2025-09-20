# Summarise record counts of an omop_table using a specific time interval. Only records that fall within the observation period are considered. — summariseRecordCount • OmopSketch

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

# Summarise record counts of an omop_table using a specific time interval. Only records that fall within the observation period are considered.

Source: [`R/summariseRecordCount.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summariseRecordCount.R)

`summariseRecordCount.Rd`

Summarise record counts of an omop_table using a specific time interval. Only records that fall within the observation period are considered.

## Usage
    
    
    summariseRecordCount(
      cdm,
      omopTableName,
      interval = "overall",
      ageGroup = NULL,
      sex = FALSE,
      sample = NULL,
      dateRange = NULL
    )

## Arguments

cdm
    

A cdm_reference object.

omopTableName
    

A character vector of omop tables from the cdm.

interval
    

Time interval to stratify by. It can either be "years", "quarters", "months" or "overall".

ageGroup
    

A list of age groups to stratify results by.

sex
    

Whether to stratify by sex (TRUE) or not (FALSE).

sample
    

An integer to sample the tables to only that number of records. If NULL no sample is done.

dateRange
    

A vector of two dates defining the desired study period. Only the `start_date` column of the OMOP table is checked to ensure it falls within this range. If `dateRange` is `NULL`, no restriction is applied.

## Value

A summarised_result object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    
    summarisedResult <- summariseRecordCount(
      cdm = cdm,
      omopTableName = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "drug_exposure"),
      interval = "years",
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<=20" = [c](https://rdrr.io/r/base/c.html)(0, 20), ">20" = [c](https://rdrr.io/r/base/c.html)(21, Inf)),
      sex = TRUE
    )
    
    summarisedResult |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2,060
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mockOmopSketch", "mockOmopSketch", "mockOmopSketch",…
    #> $ group_name       <chr> "omop_table", "omop_table", "omop_table", "omop_table…
    #> $ group_level      <chr> "drug_exposure", "drug_exposure", "drug_exposure", "d…
    #> $ strata_name      <chr> "overall", "sex", "age_group", "sex &&& age_group", "…
    #> $ strata_level     <chr> "overall", "Female", "<=20", "Female &&& <=20", "over…
    #> $ variable_name    <chr> "Records in observation", "Records in observation", "…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "count", "count", "percentage", "pe…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "percenta…
    #> $ estimate_value   <chr> "2", "2", "2", "2", "0.01", "0.01", "0.01", "0.01", "…
    #> $ additional_name  <chr> "time_interval", "time_interval", "time_interval", "t…
    #> $ additional_level <chr> "1957-01-01 to 1957-12-31", "1957-01-01 to 1957-12-31…
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
