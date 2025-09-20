# Create a ggplot2 plot from the output of summariseInObservation(). — plotInObservation • OmopSketch

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

# Create a ggplot2 plot from the output of summariseInObservation().

Source: [`R/plotInObservation.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/plotInObservation.R)

`plotInObservation.Rd`

Create a ggplot2 plot from the output of summariseInObservation().

## Usage
    
    
    plotInObservation(result, facet = NULL, colour = NULL)

## Arguments

result
    

A summarised_result object (output of summariseInObservation).

facet
    

Columns to face by. Formula format can be provided. See possible columns to face by with: `[visOmopResults::tidyColumns()](https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html)`.

colour
    

Columns to colour by. See possible columns to colour by with: `[visOmopResults::tidyColumns()](https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html)`.

## Value

A ggplot showing the table counts

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    
    result <- [summariseInObservation](summariseInObservation.html)(
      observationPeriod = cdm$observation_period,
      output = [c](https://rdrr.io/r/base/c.html)("person-days","record"),
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<=40" = [c](https://rdrr.io/r/base/c.html)(0, 40), ">40" = [c](https://rdrr.io/r/base/c.html)(41, Inf)),
      sex = TRUE
    )
    #> Warning: `summariseInObservation()` was deprecated in OmopSketch 1.0.0.
    #> ℹ Please use `summariseTrend()` instead.
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Person-days") |>
      plotInObservation(facet = "sex", colour = "age_group")
    #> Warning: `plotInObservation()` was deprecated in OmopSketch 1.0.0.
    #> ℹ Please use `plotTrend()` instead.
    ![](plotInObservation-1.png)
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
