# Generate an interactive Shiny application that visualises the results obtained from the databaseCharacteristics() function. — shinyCharacteristics • OmopSketch

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

# Generate an interactive Shiny application that visualises the results obtained from the `databaseCharacteristics()` function.

Source: [`R/shinyCharacteristics.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/shinyCharacteristics.R)

`shinyCharacteristics.Rd`

Generate an interactive Shiny application that visualises the results obtained from the `[databaseCharacteristics()](databaseCharacteristics.html)` function.

## Usage
    
    
    shinyCharacteristics(
      result,
      directory,
      background = TRUE,
      title = "Database characterisation",
      logo = "ohdsi",
      theme = NULL
    )

## Arguments

result
    

A summarised_result object containing the results from the `[databaseCharacteristics()](databaseCharacteristics.html)` function. This object should include summaries of various OMOP CDM tables, such as population characteristics, clinical records, missing data, and more

directory
    

A character string specifying the directory where the application will be saved.

background
    

Background panel for the Shiny app. If set to `TRUE` (default), a standard background panel with a general description will be included. If set to `FALSE`, no background panel will be displayed. Alternatively, you can provide a file path (e.g., `"path/to/file.md"`) to include custom background content from a Markdown file.

title
    

Title of the shiny. Default is "Characterisation"

logo
    

Name of a logo or path to a logo. If NULL no logo is included. Only svg format allowed for the moment.

theme
    

A character string specifying the theme for the Shiny application. Default is `"bslib::bs_theme(bootswatch = 'flatly')"` to use the Flatly theme from the Bootswatch collection. You can customise this to use other themes.

## Value

This function invisibly returns NULL and generates a static Shiny app in the specified directory.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    res <- [databaseCharacteristics](databaseCharacteristics.html)(cdm = cdm)
    shinyCharacteristics(result = res, directory = here::[here](https://here.r-lib.org/reference/here.html)())
    } # }
    
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
