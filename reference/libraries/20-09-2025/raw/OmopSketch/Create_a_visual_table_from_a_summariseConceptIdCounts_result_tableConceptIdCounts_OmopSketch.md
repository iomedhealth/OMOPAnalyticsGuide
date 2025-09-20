# Create a visual table from a summariseConceptIdCounts() result. — tableConceptIdCounts • OmopSketch

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

# Create a visual table from a summariseConceptIdCounts() result.

Source: [`R/tableConceptIdCounts.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/tableConceptIdCounts.R)

`tableConceptIdCounts.Rd`

Create a visual table from a summariseConceptIdCounts() result.

## Usage
    
    
    tableConceptIdCounts(result, display = "overall", type = "reactable")

## Arguments

result
    

A summarised_result object.

display
    

A character string indicating which subset of the data to display. Options are:

  * `"overall"`: Show all source and standard concepts.

  * `"standard"`: Show only standard concepts.

  * `"source"`: Show only source codes.

  * `"missing standard"`: Show only source codes that are missing a mapped standard concept.



type
    

Type of formatting output table, either "reactable" or "datatable".

## Value

A reactable or datatable object with the summarised data.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    result <- [summariseConceptIdCounts](summariseConceptIdCounts.html)(cdm = cdm, omopTableName = "condition_occurrence")
    tableConceptIdCounts(result = result, display = "standard")
    
    
    
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
