# Package index • OmopSketch

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

# Package index

### Snapshots

Create snapshots of OMOP databases

`[summariseOmopSnapshot()](summariseOmopSnapshot.html)`
    Summarise a cdm_reference object creating a snapshot with the metadata of the cdm_reference object.

`[tableOmopSnapshot()](tableOmopSnapshot.html)`
    Create a visual table from a summarise_omop_snapshot result.

### Clinical Tables

Summarise and plot tables in the OMOP Common Data Model

`[summariseClinicalRecords()](summariseClinicalRecords.html)`
    Summarise an omop table from a cdm object. You will obtain information related to the number of records, number of subjects, whether the records are in observation, number of present domains, number of present concepts, missing data and inconsistencies in start date and end date

`[tableClinicalRecords()](tableClinicalRecords.html)`
    Create a visual table from a summariseClinicalRecord() output.

`[summariseMissingData()](summariseMissingData.html)`
    Summarise missing data in omop tables

`[tableMissingData()](tableMissingData.html)`
    Create a visual table from a summariseMissingData() result.

### Observation Periods

Summarise and plot the observation period table in the OMOP Common Data Model

`[summarisePerson()](summarisePerson.html)`
    Summarise the person table

`[tablePerson()](tablePerson.html)`
    Visualise the results of `[summarisePerson()](../reference/summarisePerson.html)` into a table

`[summariseObservationPeriod()](summariseObservationPeriod.html)`
    Summarise the observation period table getting some overall statistics in a summarised_result object.

`[plotObservationPeriod()](plotObservationPeriod.html)`
    Create a plot from the output of summariseObservationPeriod().

`[tableObservationPeriod()](tableObservationPeriod.html)`
    Create a visual table from a summariseObservationPeriod() result.

### Counts

Summarise concept code use in the OMOP Common Data Model

`[summariseConceptIdCounts()](summariseConceptIdCounts.html)`
    Summarise concept use in patient-level data. Only concepts recorded during observation period are counted.

`[tableConceptIdCounts()](tableConceptIdCounts.html)`
    Create a visual table from a summariseConceptIdCounts() result.

`[tableTopConceptCounts()](tableTopConceptCounts.html)`
    Create a visual table of the most common concepts from `[summariseConceptIdCounts()](../reference/summariseConceptIdCounts.html)` output. This function takes a `summarised_result` object and generates a formatted table highlighting the most frequent concepts.

### Temporal Trends

Summarise and plot temporal trends in tables in the OMOP Common Data Model

`[summariseTrend()](summariseTrend.html)`
    Summarise temporal trends in OMOP tables

`[tableTrend()](tableTrend.html)`
    Create a visual table from a summariseTrend() result.

`[plotTrend()](plotTrend.html)`
    Create a ggplot2 plot from the output of summariseTrend().

### Mock Database

Create a mock database to test the OmopSketch package

`[mockOmopSketch()](mockOmopSketch.html)`
    Creates a mock database to test OmopSketch package.

### Characterisation

Characterise the database

`[databaseCharacteristics()](databaseCharacteristics.html)`
    Summarise Database Characteristics for OMOP CDM

`[shinyCharacteristics()](shinyCharacteristics.html)`
    Generate an interactive Shiny application that visualises the results obtained from the `[databaseCharacteristics()](../reference/databaseCharacteristics.html)` function.

### Helper functions

Functions to help populate and summariseClinicalRecords()

`[clinicalTables()](clinicalTables.html)`
    Tables in the cdm_reference that contain clinical information

### Deprecated functions

These functions have been deprecated

`[summariseConceptCounts()](summariseConceptCounts.html)` deprecated
    Summarise concept counts in patient-level data. Only concepts recorded during observation period are counted.

`[summariseConceptSetCounts()](summariseConceptSetCounts.html)`
    Summarise concept counts in patient-level data. Only concepts recorded during observation period are counted.

`[plotConceptSetCounts()](plotConceptSetCounts.html)`
    Plot the concept counts of a summariseConceptSetCounts output.

`[summariseRecordCount()](summariseRecordCount.html)`
    Summarise record counts of an omop_table using a specific time interval. Only records that fall within the observation period are considered.

`[plotRecordCount()](plotRecordCount.html)`
    Create a ggplot of the records' count trend.

`[tableRecordCount()](tableRecordCount.html)`
    Create a visual table from a summariseRecordCount() result.

`[summariseInObservation()](summariseInObservation.html)`
    Summarise the number of people in observation during a specific interval of time.

`[plotInObservation()](plotInObservation.html)`
    Create a ggplot2 plot from the output of summariseInObservation().

`[tableInObservation()](tableInObservation.html)`
    Create a visual table from a summariseInObservation() result.

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
