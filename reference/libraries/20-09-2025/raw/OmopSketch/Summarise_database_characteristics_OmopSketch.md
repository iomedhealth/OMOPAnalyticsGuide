# Summarise database characteristics • OmopSketch

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

# Summarise database characteristics

Source: [`vignettes/database_characteristics.Rmd`](https://github.com/OHDSI/OmopSketch/blob/main/vignettes/database_characteristics.Rmd)

`database_characteristics.Rmd`

## Introduction

In this vignette, we explore how the _OmopSketch_ function `[databaseCharacteristics()](../reference/databaseCharacteristics.html)` and `[shinyCharacteristics()](../reference/shinyCharacteristics.html)` can serve as a valuable tool for characterising databases containing electronic health records mapped to the OMOP Common Data Model.

### Create a mock cdm

We begin by loading the necessary packages and creating a mock CDM using the `[mockOmopSketch()](../reference/mockOmopSketch.html)` function:
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](../reference/mockOmopSketch.html)()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mockOmopSketch ─────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, condition_occurrence, death, device_exposure, drug_exposure,
    #> drug_strength, measurement, observation, observation_period, person,
    #> procedure_occurrence, visit_occurrence, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

## Summarise database characteristics

The `[databaseCharacteristics()](../reference/databaseCharacteristics.html)` function provides a comprehensive summary of the CDM, returning a [summarised result](https://darwin-eu-dev.github.io/omopgenerics/articles/summarised_result.html) that includes:

  * A general database snapshot, using `[summariseOmopSnapshot()](../reference/summariseOmopSnapshot.html)`

  * A characterisation of the population in observation, built using the [CohortConstructor](https://ohdsi.github.io/CohortConstructor/) and [CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/) packages

  * A summary of the observation period table using `[summariseObservationPeriod()](../reference/summariseObservationPeriod.html)` and `[summariseInObservation()](../reference/summariseInObservation.html)`

  * A data quality assessment of the clinical tables using `[summariseMissingData()](../reference/summariseMissingData.html)`

  * A characterisation of the clinical tables with `[summariseClinicalRecords()](../reference/summariseClinicalRecords.html)` and `[summariseRecordCount()](../reference/summariseRecordCount.html)`



    
    
    result <- [databaseCharacteristics](../reference/databaseCharacteristics.html)(cdm)

### Selecting tables to characterise

By default, the following OMOP tables are included in the characterisation: _person_ , _observation_period_ , _visit_occurrence_ , _condition_occurrence_ , _drug_exposure_ , _procedure_occurrence_ , _device_exposure_ , _measurement_ , _observation_ , _death_.

You can customise which tables to include in the analysis by specifying them with the `omopTableName` argument.
    
    
    result <- [databaseCharacteristics](../reference/databaseCharacteristics.html)(cdm, omopTableName = [c](https://rdrr.io/r/base/c.html)("drug_exposure", "condition_occurrence"))

### Stratifying by Sex

To stratify the characterisation results by sex, set the `sex` argument to `TRUE`:
    
    
    result <- [databaseCharacteristics](../reference/databaseCharacteristics.html)(cdm, omopTableName = [c](https://rdrr.io/r/base/c.html)("drug_exposure", "condition_occurrence"),
                                      sex = TRUE)

### Stratifying by Age Group

You can choose to characterise the data stratifying by age group by creating a list defining the age groups you want to use.
    
    
    result <- [databaseCharacteristics](../reference/databaseCharacteristics.html)(cdm, omopTableName = [c](https://rdrr.io/r/base/c.html)("drug_exposure", "condition_occurrence"),
                                      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0,50), [c](https://rdrr.io/r/base/c.html)(51,100)))

### Filtering by date range and time interval

Use the `dateRange` argument to limit the analysis to a specific period. Combine it with the `interval` argument to stratify results by time. Valid values for interval include “overall” (default), “years”, “quarters”, and “months”:
    
    
    result <- [databaseCharacteristics](../reference/databaseCharacteristics.html)(cdm,
                                     interval = "years",
                                     dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2018-12-31")))

### Including Concept Counts

To include concept counts in the characterisation, set `conceptIdCounts = TRUE`:
    
    
    result <- [databaseCharacteristics](../reference/databaseCharacteristics.html)(cdm,
                                      conceptIdCounts = TRUE)

## Visualise the characterisation results

To explore the characterisation results interactively, you can use the `[shinyCharacteristics()](../reference/shinyCharacteristics.html)` function. This function generates a Shiny application in the specified `directory`, allowing you to browse, filter, and visualise the results through an intuitive user interface.
    
    
    [shinyCharacteristics](../reference/shinyCharacteristics.html)(result = result, directory = "path/to/your/shiny")

### Customise the Shiny App

You can customise the title, logo, and theme of the Shiny app by setting the appropriate arguments:

  * `title`: The title displayed at the top of the app

  * `logo`: Path to a custom logo (must be in SVG format)

  * `theme`: A custom Bootstrap theme (e.g., using bslib::bs_theme())



    
    
    [shinyCharacteristics](../reference/shinyCharacteristics.html)(result = result, directory = "path/to/my/shiny",
                         title = "Characterisation of my data",
                         logo = "path/to/my/logo.svg",
                         theme = "bslib::bs_theme(bootswatch = 'flatly')")

An example of the Shiny application generated by `[shinyCharacteristics()](../reference/shinyCharacteristics.html)` can be explored [here](https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/), where the characterisation of several synthetic datasets is available.

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
