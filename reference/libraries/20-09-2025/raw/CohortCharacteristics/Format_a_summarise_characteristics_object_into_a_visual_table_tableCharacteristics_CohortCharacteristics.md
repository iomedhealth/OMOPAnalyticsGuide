# Format a summarise_characteristics object into a visual table. — tableCharacteristics • CohortCharacteristics

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Format a summarise_characteristics object into a visual table.

Source: [`R/tableCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCharacteristics.R)

`tableCharacteristics.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCharacteristics(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [c](https://rdrr.io/r/base/c.html)([additionalColumns](https://darwin-eu.github.io/omopgenerics/reference/additionalColumns.html)(result), [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A formatted table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    result <- [summariseCharacteristics](summariseCharacteristics.html)(cdm$cohort1)
    #> ℹ adding demographics columns
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    
    tableCharacteristics(result)
    
    
    
    
      
          | 
            CDM name
          
          
    ---|---  
    
          | 
            PP_MOCK
          
          
    Variable name
          | Variable level
          | Estimate name
          | 
            Cohort name
          
          
    cohort_1
          | cohort_3
          
    Number records
    | -
    | N
    | 4
    | 6  
    Number subjects
    | -
    | N
    | 4
    | 6  
    Cohort start date
    | -
    | Median [Q25 - Q75]
    | 1965-10-09 [1954-06-28 - 1974-01-30]
    | 1939-05-27 [1920-10-18 - 1965-02-28]  
    
    | 
    | Range
    | 1935-04-26 to 1984-05-02
    | 1911-08-13 to 1979-06-02  
    Cohort end date
    | -
    | Median [Q25 - Q75]
    | 1967-10-04 [1957-02-14 - 1975-01-07]
    | 1942-07-08 [1927-02-12 - 1966-07-06]  
    
    | 
    | Range
    | 1937-08-11 to 1984-06-02
    | 1916-06-11 to 1980-06-06  
    Age
    | -
    | Median [Q25 - Q75]
    | 24 [15 - 28]
    | 13 [6 - 28]  
    
    | 
    | Mean (SD)
    | 20.25 (11.84)
    | 18.17 (15.89)  
    
    | 
    | Range
    | 4 to 30
    | 3 to 43  
    Sex
    | Female
    | N (%)
    | 1 (25.00%)
    | 3 (50.00%)  
    
    | Male
    | N (%)
    | 3 (75.00%)
    | 3 (50.00%)  
    Prior observation
    | -
    | Median [Q25 - Q75]
    | 8,864 [5,841 - 10,620]
    | 4,827 [2,644 - 10,284]  
    
    | 
    | Mean (SD)
    | 7,596.00 (4,343.80)
    | 6,828.33 (5,815.56)  
    
    | 
    | Range
    | 1,583 to 11,072
    | 1,320 to 15,977  
    Future observation
    | -
    | Median [Q25 - Q75]
    | 694 [435 - 1,141]
    | 3,946 [2,619 - 5,626]  
    
    | 
    | Mean (SD)
    | 881.50 (714.23)
    | 4,626.00 (3,087.41)  
    
    | 
    | Range
    | 260 to 1,878
    | 1,493 to 10,010  
    Days in cohort
    | -
    | Median [Q25 - Q75]
    | 643 [343 - 880]
    | 1,139 [551 - 1,620]  
    
    | 
    | Mean (SD)
    | 580.50 (433.92)
    | 1,231.83 (914.61)  
    
    | 
    | Range
    | 32 to 1,004
    | 263 to 2,714  
      
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
