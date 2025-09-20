# Create a plot from the output of summariseObservationPeriod(). — plotObservationPeriod • OmopSketch

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

# Create a plot from the output of summariseObservationPeriod().

Source: [`R/plotObservationPeriod.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/plotObservationPeriod.R)

`plotObservationPeriod.Rd`

Create a plot from the output of summariseObservationPeriod().

## Usage
    
    
    plotObservationPeriod(
      result,
      variableName = "Number subjects",
      plotType = "barplot",
      facet = NULL,
      colour = NULL,
      style = "default"
    )

## Arguments

result
    

A summarised_result object.

variableName
    

The variable to plot it can be: "number subjects", "records per person", "duration" or "days to next observation period".

plotType
    

The plot type, it can be: "barplot", "boxplot" or "densityplot".

facet
    

Columns to colour by. See possible columns to colour by with: `[visOmopResults::tidyColumns()](https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html)`.

colour
    

Columns to colour by. See possible columns to colour by with: `[visOmopResults::tidyColumns()](https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html)`.

style
    

Which style to apply to the plot, options are: "default", "darwin" and NULL (default ggplot style). Customised styles can be achieved by modifying the returned ggplot object.

## Value

A ggplot2 object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 100)
    
    result <- [summariseObservationPeriod](summariseObservationPeriod.html)(observationPeriod = cdm$observation_period)
    #> Warning: The `observationPeriod` argument of `summariseObservationPeriod()` is
    #> deprecated as of OmopSketch 0.5.1.
    #> ℹ Please use the `cdm` argument instead.
    #> ℹ retrieving cdm object from cdm_table.
    #> Warning: These columns contain missing values, which are not permitted:
    #> "period_type_concept_id"
    
    plotObservationPeriod(result = result,
        variableName = "Duration in days",
        plotType = "boxplot"
      )
    ![](plotObservationPeriod-1.png)
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
