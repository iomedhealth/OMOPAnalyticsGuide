# Create a visual table from a summariseObservationPeriod() result. — tableObservationPeriod • OmopSketch

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

# Create a visual table from a summariseObservationPeriod() result.

Source: [`R/tableObservationPeriod.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/tableObservationPeriod.R)

`tableObservationPeriod.Rd`

Create a visual table from a summariseObservationPeriod() result.

## Usage
    
    
    tableObservationPeriod(result, type = "gt", style = "default")

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
    
    result <- [summariseObservationPeriod](summariseObservationPeriod.html)(observationPeriod = cdm$observation_period)
    #> ℹ retrieving cdm object from cdm_table.
    #> Warning: These columns contain missing values, which are not permitted:
    #> "period_type_concept_id"
    
    tableObservationPeriod(result = result)
    
    
    
    
      Observation period ordinal
          | Variable name
          | Variable level
          | Estimate name
          | 
            CDM name
          
          
    ---|---|---|---|---  
    mockOmopSketch
          
    all
    | Records per person
    | -
    | mean (sd)
    | 1.00 (0.00)  
    
    | 
    | 
    | median [Q25 - Q75]
    | 1 [1 - 1]  
    
    | Duration in days
    | -
    | mean (sd)
    | 4,013.18 (4,033.02)  
    
    | 
    | 
    | median [Q25 - Q75]
    | 2,950 [1,276 - 5,222]  
    
    | Number records
    | -
    | N
    | 100  
    
    | Number subjects
    | -
    | N
    | 100  
    
    | Type concept id
    | Unknown type concept: NA
    | N (%)
    | 100 (100.00%)  
    
    | Subjects not in person table
    | -
    | N (%)
    | 0 (0.00%)  
    
    | End date before start date
    | -
    | N (%)
    | 0 (0.00%)  
    
    | Start date before birth date
    | -
    | N (%)
    | 0 (0.00%)  
    
    | Column name
    | observation_period_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | 
    | 
    | N zeros (%)
    | 0 (0.00%)  
    
    | 
    | person_id
    | N missing data (%)
    | 0 (0.00%)  
    
    | 
    | 
    | N zeros (%)
    | 0 (0.00%)  
    
    | 
    | observation_period_start_date
    | N missing data (%)
    | 0 (0.00%)  
    
    | 
    | observation_period_end_date
    | N missing data (%)
    | 0 (0.00%)  
    
    | 
    | period_type_concept_id
    | N missing data (%)
    | 100 (100.00%)  
    
    | 
    | 
    | N zeros (%)
    | 0 (0.00%)  
    1st
    | Duration in days
    | -
    | mean (sd)
    | 4,013.18 (4,033.02)  
    
    | 
    | 
    | median [Q25 - Q75]
    | 2,950 [1,276 - 5,222]  
    
    | Number subjects
    | -
    | N
    | 100  
      
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
