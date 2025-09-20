# Summarise the person table — summarisePerson • OmopSketch

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

# Summarise the person table

Source: [`R/summarisePerson.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summarisePerson.R)

`summarisePerson.Rd`

Summarise the person table

## Usage
    
    
    summarisePerson(cdm)

## Arguments

cdm
    

A cdm_reference object.

## Value

A summarised_result object with the summary of the person table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 100)
    
    result <- summarisePerson(cdm = cdm)
    
    result |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 61
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mockOmopSketch", "mockOmopSketch", "mockOmopSketch",…
    #> $ group_name       <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ group_level      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Number subjects", "Number subjects not in observatio…
    #> $ variable_level   <chr> NA, NA, NA, "Female", "Female", "Male", "Male", "None…
    #> $ estimate_name    <chr> "count", "count", "percentage", "count", "percentage"…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "integer", "numeric"…
    #> $ estimate_value   <chr> "100", "0", "0", "51", "51", "49", "49", "0", "0", "1…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
