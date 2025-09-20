# Summarise the observation period table getting some overall statistics in a summarised_result object. — summariseObservationPeriod • OmopSketch

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

# Summarise the observation period table getting some overall statistics in a summarised_result object.

Source: [`R/summariseObservationPeriod.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summariseObservationPeriod.R)

`summariseObservationPeriod.Rd`

Summarise the observation period table getting some overall statistics in a summarised_result object.

## Usage
    
    
    summariseObservationPeriod(
      cdm,
      estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd", "min", "q05", "q25", "median", "q75", "q95", "max",
        "density"),
      missingData = TRUE,
      quality = TRUE,
      byOrdinal = TRUE,
      ageGroup = NULL,
      sex = FALSE,
      dateRange = NULL,
      observationPeriod = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

cdm
    

A cdm_reference object.

estimates
    

Estimates to summarise the variables of interest ( `records per person`, `duration in days` and `days to next observation period`).

missingData
    

Logical. If `TRUE`, includes a summary of missing data for relevant fields.

quality
    

Logical. If `TRUE`, performs basic data quality checks, including:

  * Number of subjects not included in person table

  * Number of records with end date before start date

  * Number of records with start date before the person's birth date



byOrdinal
    

Boolean variable. Whether to stratify by the ordinal observation period (e.g., 1st, 2nd, etc.) (TRUE) or simply analyze overall data (FALSE)

ageGroup
    

A list of age groups to stratify results by.

sex
    

Boolean variable. Whether to stratify by sex (TRUE) or not (FALSE).

dateRange
    

A vector of two dates defining the desired study period. Only the `start_date` column of the OMOP table is checked to ensure it falls within this range. If `dateRange` is `NULL`, no restriction is applied.

observationPeriod
    

deprecated.

## Value

A summarised_result object with the summarised data.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 100)
    
    result <- summariseObservationPeriod(cdm = cdm)
    #> Warning: These columns contain missing values, which are not permitted:
    #> "period_type_concept_id"
    
    result |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3,126
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mockOmopSketch", "mockOmopSketch", "mockOmopSketch",…
    #> $ group_name       <chr> "observation_period_ordinal", "observation_period_ord…
    #> $ group_level      <chr> "all", "all", "all", "all", "all", "all", "all", "all…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Records per person", "Records per person", "Records …
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "mean", "sd", "min", "q05", "q25", "median", "q75", "…
    #> $ estimate_type    <chr> "numeric", "numeric", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "1", "0", "1", "1", "1", "1", "1", "1", "1", "3297.8"…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
