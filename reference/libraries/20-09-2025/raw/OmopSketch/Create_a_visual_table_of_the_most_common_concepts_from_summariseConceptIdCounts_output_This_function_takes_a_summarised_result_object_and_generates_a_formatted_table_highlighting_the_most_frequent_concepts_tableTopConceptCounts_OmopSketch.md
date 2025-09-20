# Create a visual table of the most common concepts from summariseConceptIdCounts() output. This function takes a summarised_result object and generates a formatted table highlighting the most frequent concepts. — tableTopConceptCounts • OmopSketch

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

# Create a visual table of the most common concepts from `summariseConceptIdCounts()` output. This function takes a `summarised_result` object and generates a formatted table highlighting the most frequent concepts.

Source: [`R/tableTopConceptCounts.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/tableTopConceptCounts.R)

`tableTopConceptCounts.Rd`

Create a visual table of the most common concepts from `[summariseConceptIdCounts()](summariseConceptIdCounts.html)` output. This function takes a `summarised_result` object and generates a formatted table highlighting the most frequent concepts.

## Usage
    
    
    tableTopConceptCounts(
      result,
      top = 10,
      countBy = NULL,
      type = "gt",
      style = "default"
    )

## Arguments

result
    

A `summarised_result` object, typically returned by `[summariseConceptIdCounts()](summariseConceptIdCounts.html)`.

top
    

Integer. The number of top concepts to display. Defaults to `10`.

countBy
    

Either 'person' or 'record'. If NULL whatever is in the data is used.

type
    

Character. The output table format. Defaults to `"gt"`. Use `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)` to see all supported formats.

style
    

Named list that specifies how to style the different parts of the gt or flextable table generated. Accepted style entries are: title, subtitle, header, header_name, header_level, column_name, group_label, and body. Alternatively, use "default" to get visOmopResults style, or NULL for gt/flextable style. Keep in mind that styling code is different for gt and flextable. Additionally, "datatable" and "reactable" have their own style functions. To see style options for each table type use `[visOmopResults::tableStyle()](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.html)`

## Value

A formatted table object displaying the top concepts from the summarised data.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    result <- [summariseConceptIdCounts](summariseConceptIdCounts.html)(cdm = cdm, omopTableName = "condition_occurrence")
    
    tableTopConceptCounts(result = result, top = 5)
    
    
    
    
      Top
          | 
            Cdm name
          
          
    ---|---  
    Synthea
          
    condition_occurrence
          
    1
    | Standard: Viral sinusitis (40481087)   
     Source: Viral sinusitis (40481087)   
     17268  
    2
    | Standard: Acute viral pharyngitis (4112343)   
     Source: Acute viral pharyngitis (4112343)   
     10217  
    3
    | Standard: Acute bronchitis (260139)   
     Source: Acute bronchitis (260139)   
     8184  
    4
    | Standard: Otitis media (372328)   
     Source: Otitis media (372328)   
     3605  
    5
    | Standard: Streptococcal sore throat (28060)   
     Source: Streptococcal sore throat (28060)   
     2656  
      
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
