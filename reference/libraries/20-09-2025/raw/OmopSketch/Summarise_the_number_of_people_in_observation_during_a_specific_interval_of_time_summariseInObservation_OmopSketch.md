# Summarise the number of people in observation during a specific interval of time. — summariseInObservation • OmopSketch

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

# Summarise the number of people in observation during a specific interval of time.

Source: [`R/summariseInObservation.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summariseInObservation.R)

`summariseInObservation.Rd`

Summarise the number of people in observation during a specific interval of time.

## Usage
    
    
    summariseInObservation(
      observationPeriod,
      interval = "overall",
      output = "record",
      ageGroup = NULL,
      sex = FALSE,
      dateRange = NULL
    )

## Arguments

observationPeriod
    

An observation_period omop table. It must be part of a cdm_reference object.

interval
    

Time interval to stratify by. It can either be "years", "quarters", "months" or "overall".

output
    

Output format. It can be either the number of records ("record") that are in observation in the specific interval of time, the number of person-days ("person-days"), the number of subjects ("person"), the number of females ("sex") or the median age of population in observation ("age").

ageGroup
    

A list of age groups to stratify results by.

sex
    

Boolean variable. Whether to stratify by sex (TRUE) or not (FALSE). For output = "sex" this stratification is not applied.

dateRange
    

A vector of two dates defining the desired study period. Only the `start_date` column of the OMOP table is checked to ensure it falls within this range. If `dateRange` is `NULL`, no restriction is applied.

## Value

A summarised_result object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    
    result <- summariseInObservation(
      observationPeriod = cdm$observation_period,
      interval = "months",
      output = [c](https://rdrr.io/r/base/c.html)("person-days", "record"),
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<=60" = [c](https://rdrr.io/r/base/c.html)(0, 60), ">60" = [c](https://rdrr.io/r/base/c.html)(61, Inf)),
      sex = TRUE
    )
    
    result |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 18,828
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mockOmopSketch", "mockOmopSketch", "mockOmopSketch",…
    #> $ group_name       <chr> "omop_table", "omop_table", "omop_table", "omop_table…
    #> $ group_level      <chr> "observation_period", "observation_period", "observat…
    #> $ strata_name      <chr> "overall", "sex", "age_group", "sex &&& age_group", "…
    #> $ strata_level     <chr> "overall", "Male", "<=60", "Male &&& <=60", "overall"…
    #> $ variable_name    <chr> "Records in observation", "Records in observation", "…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "1", "1", "1", "1", "8", "8", "8", "8", "1.00", "1.00…
    #> $ additional_name  <chr> "time_interval", "time_interval", "time_interval", "t…
    #> $ additional_level <chr> "1957-11-01 to 1957-11-30", "1957-11-01 to 1957-11-30…
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
