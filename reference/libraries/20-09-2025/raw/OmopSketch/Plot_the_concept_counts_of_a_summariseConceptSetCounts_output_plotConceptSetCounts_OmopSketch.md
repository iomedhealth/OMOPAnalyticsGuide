# Plot the concept counts of a summariseConceptSetCounts output. — plotConceptSetCounts • OmopSketch

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

# Plot the concept counts of a summariseConceptSetCounts output.

Source: [`R/plotConceptSetCounts.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/plotConceptSetCounts.R)

`plotConceptSetCounts.Rd`

Plot the concept counts of a summariseConceptSetCounts output.

## Usage
    
    
    plotConceptSetCounts(result, facet = NULL, colour = NULL)

## Arguments

result
    

A summarised_result object (output of summariseConceptSetCounts).

facet
    

Columns to face by. Formula format can be provided. See possible columns to face by with: `[visOmopResults::tidyColumns()](https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html)`.

colour
    

Columns to colour by. See possible columns to colour by with: `[visOmopResults::tidyColumns()](https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html)`.

## Value

A ggplot2 object showing the concept counts.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: ‘dplyr’
    #> The following objects are masked from ‘package:stats’:
    #> 
    #>     filter, lag
    #> The following objects are masked from ‘package:base’:
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    
    result <- [summariseConceptSetCounts](summariseConceptSetCounts.html)(
      cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "asthma" = [c](https://rdrr.io/r/base/c.html)(4051466, 317009) ,
        "rhinitis" = [c](https://rdrr.io/r/base/c.html)(4280726, 4048171, 40486433)
      )
    )
    #> Warning: `summariseConceptSetCounts()` was deprecated in OmopSketch 0.5.0.
    #> Warning: ! `codelist` casted to integers.
    #> ℹ Searching concepts from domain condition in condition_occurrence.
    #> ℹ Counting concepts
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Number subjects") |>
      plotConceptSetCounts(facet = "codelist_name", colour = "standard_concept_name")
    #> Warning: `plotConceptSetCounts()` was deprecated in OmopSketch 0.5.0.
    ![](plotConceptSetCounts-1.png)
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
