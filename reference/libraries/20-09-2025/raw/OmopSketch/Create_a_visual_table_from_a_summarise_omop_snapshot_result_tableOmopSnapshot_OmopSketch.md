# Create a visual table from a summarise_omop_snapshot result. — tableOmopSnapshot • OmopSketch

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

# Create a visual table from a summarise_omop_snapshot result.

Source: [`R/tableOmopSnapshot.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/tableOmopSnapshot.R)

`tableOmopSnapshot.Rd`

Create a visual table from a summarise_omop_snapshot result.

## Usage
    
    
    tableOmopSnapshot(result, type = "gt", style = "default")

## Arguments

result
    

Output from summariseOmopSnapshot().

type
    

Type of formatting output table. See `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)` for allowed options. Default is `"gt"`.

style
    

Named list that specifies how to style the different parts of the gt or flextable table generated. Accepted style entries are: title, subtitle, header, header_name, header_level, column_name, group_label, and body. Alternatively, use "default" to get visOmopResults style, or NULL for gt/flextable style. Keep in mind that styling code is different for gt and flextable. Additionally, "datatable" and "reactable" have their own style functions. To see style options for each table type use `[visOmopResults::tableStyle()](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.html)`

## Value

A formatted table object with the summarised data.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 10)
    
    result <- [summariseOmopSnapshot](summariseOmopSnapshot.html)(cdm = cdm)
    
    tableOmopSnapshot(result = result)
    
    
    
    
      Estimate
          | 
            Database name
          
          
    ---|---  
    mockOmopSketch
          
    General
          
    Snapshot date
    | 2025-09-08  
    Person count
    | 10  
    Vocabulary version
    | v5.0 18-JAN-19  
    Cdm
          
    Source name
    | eunomia  
    Version
    | 5.3  
    Holder name
    | -  
    Release date
    | -  
    Description
    | -  
    Documentation reference
    | -  
    Observation period
          
    N
    | 10  
    Start date
    | 1973-05-14  
    End date
    | 2019-06-07  
    Cdm source
          
    Type
    | duckdb  
    Package
    | Unknown  
    Length
    | 0  
    Class1
    | cdm_source  
    Class2
    | db_cdm  
    Mode
    | list  
      
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
