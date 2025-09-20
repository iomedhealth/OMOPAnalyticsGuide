# Format a summarise_characteristics object into a visual table. — tableCohortCount • CohortCharacteristics

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

Source: [`R/tableCohortCount.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCohortCount.R)

`tableCohortCount.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortCount(
      result,
      type = "gt",
      header = "cohort_name",
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
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
    
    result <- [summariseCohortCount](summariseCohortCount.html)(cdm$cohort1)
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    
    tableCohortCount(result)
    
    
    
    
      CDM name
          | Variable name
          | Estimate name
          | 
            Cohort name
          
          
    ---|---|---|---  
    cohort_1
          | cohort_3
          
    PP_MOCK
    | Number records
    | N
    | 5
    | 5  
    
    | Number subjects
    | N
    | 5
    | 5  
      
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
