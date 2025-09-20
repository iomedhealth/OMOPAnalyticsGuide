# Visualise the results of summarisePerson() into a table — tablePerson • OmopSketch

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

# Visualise the results of `summarisePerson()` into a table

Source: [`R/summarisePerson.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summarisePerson.R)

`tablePerson.Rd`

Visualise the results of `[summarisePerson()](summarisePerson.html)` into a table

## Usage
    
    
    tablePerson(result, type = "gt")

## Arguments

result
    

A summarised_result object created by `[summarisePerson()](summarisePerson.html)`.

type
    

One of the supported visualisation formats (see `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`).

## Value

A table visualisation.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 100)
    
    result <- [summarisePerson](summarisePerson.html)(cdm = cdm)
    
    tablePerson(result = result)
    
    
    
    
      Variable name
          | Variable level
          | Estimate name
          | 
            CDM name
          
          
    ---|---|---|---  
    mockOmopSketch
          
    Number subjects
    | -
    | N
    | 100  
    Number subjects not in observation
    | -
    | N (%)
    | 0 (0.00%)  
    Sex
    | Female
    | N (%)
    | 57 (57.00%)  
    
    | Male
    | N (%)
    | 43 (43.00%)  
    
    | None
    | N (%)
    | 0 (0.00%)  
    Sex source
    | Missing
    | N (%)
    | 100 (100.00%)  
    Race
    | Missing
    | N (%)
    | 100 (100.00%)  
    Race source
    | Missing
    | N (%)
    | 100 (100.00%)  
    Ethnicity
    | Missing
    | N (%)
    | 100 (100.00%)  
    Ethnicity source
    | Missing
    | N (%)
    | 100 (100.00%)  
    Year of birth
    | -
    | Missing N (%)
    | 0 (0.00%)  
    
    | 
    | Median [Q25 - Q75]
    | 1,976 [1,958 - 1,989]  
    
    | 
    | Q05 - Q95
    | 1,951 - 1,997  
    
    | 
    | Range
    | 1,950 to 2,000  
    Month of birth
    | -
    | Missing N (%)
    | 0 (0.00%)  
    
    | 
    | Median [Q25 - Q75]
    | 6 [3 - 10]  
    
    | 
    | Q05 - Q95
    | 1 - 12  
    
    | 
    | Range
    | 1 to 12  
    Day of birth
    | -
    | Missing N (%)
    | 0 (0.00%)  
    
    | 
    | Median [Q25 - Q75]
    | 16 [8 - 24]  
    
    | 
    | Q05 - Q95
    | 2 - 30  
    
    | 
    | Range
    | 1 to 31  
    Location
    | -
    | Zeros N (%)
    | 0 (0.00%)  
    
    | 
    | Missing N (%)
    | 100 (100.00%)  
    
    | 
    | Distinct values
    | 1  
    Provider
    | -
    | Zeros N (%)
    | 0 (0.00%)  
    
    | 
    | Missing N (%)
    | 100 (100.00%)  
    
    | 
    | Distinct values
    | 1  
    Care site
    | -
    | Zeros N (%)
    | 0 (0.00%)  
    
    | 
    | Missing N (%)
    | 100 (100.00%)  
    
    | 
    | Distinct values
    | 1  
      
    # }
    
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
