# Create a visual table from a summariseMissingData() result. — tableMissingData • OmopSketch

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

# Create a visual table from a summariseMissingData() result.

Source: [`R/tableMissingData.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/tableMissingData.R)

`tableMissingData.Rd`

Create a visual table from a summariseMissingData() result.

## Usage
    
    
    tableMissingData(result, type = "gt", style = "default")

## Arguments

result
    

A summarised_result object.

type
    

Type of formatting output table. See `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)` for allowed options. Default is `"gt"`.

style
    

Named list that specifies how to style the different parts of the gt or flextable table generated. Accepted style entries are: title, subtitle, header, header_name, header_level, column_name, group_label, and body. Alternatively, use "default" to get visOmopResults style, or NULL for gt/flextable style. Keep in mind that styling code is different for gt and flextable. Additionally, "datatable" and "reactable" have their own style functions. To see style options for each table type use `[visOmopResults::tableStyle()](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.html)`

## Value

A formatted table object with the summarised data.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 100)
    
    result <- [summariseMissingData](summariseMissingData.html)(cdm = cdm,
    omopTableName = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "visit_occurrence"))
    
    tableMissingData(result = result)
    
    
    
    
      Column name
          | Estimate name
          | 
            Database name
          
          
    ---|---|---  
    mockOmopSketch
          
    condition_occurrence
          
    condition_occurrence_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    person_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    condition_concept_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    condition_start_date
    | N missing data (%)
    | 0 (0.00%)  
    condition_start_datetime
    | N missing data (%)
    | 8,400 (100.00%)  
    condition_end_date
    | N missing data (%)
    | 0 (0.00%)  
    condition_end_datetime
    | N missing data (%)
    | 8,400 (100.00%)  
    condition_type_concept_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    condition_status_concept_id
    | N missing data (%)
    | 8,400 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    stop_reason
    | N missing data (%)
    | 8,400 (100.00%)  
    provider_id
    | N missing data (%)
    | 8,400 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    visit_occurrence_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    visit_detail_id
    | N missing data (%)
    | 8,400 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    condition_source_value
    | N missing data (%)
    | 8,400 (100.00%)  
    condition_source_concept_id
    | N missing data (%)
    | 8,400 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    condition_status_source_value
    | N missing data (%)
    | 8,400 (100.00%)  
    visit_occurrence
          
    visit_occurrence_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    person_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    visit_concept_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    visit_start_date
    | N missing data (%)
    | 0 (0.00%)  
    visit_start_datetime
    | N missing data (%)
    | 37,311 (100.00%)  
    visit_end_date
    | N missing data (%)
    | 0 (0.00%)  
    visit_end_datetime
    | N missing data (%)
    | 37,311 (100.00%)  
    visit_type_concept_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    provider_id
    | N missing data (%)
    | 37,311 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    care_site_id
    | N missing data (%)
    | 37,311 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    visit_source_value
    | N missing data (%)
    | 37,311 (100.00%)  
    visit_source_concept_id
    | N missing data (%)
    | 37,311 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    admitting_source_concept_id
    | N missing data (%)
    | 37,311 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    admitting_source_value
    | N missing data (%)
    | 37,311 (100.00%)  
    discharge_to_concept_id
    | N missing data (%)
    | 37,311 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
    discharge_to_source_value
    | N missing data (%)
    | 37,311 (100.00%)  
    preceding_visit_occurrence_id
    | N missing data (%)
    | 37,311 (100.00%)  
    
    | N zeros (%)
    | 0 (0.00%)  
      
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
