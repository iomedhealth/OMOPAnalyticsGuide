# Create a visual table from the output of summariseCohortAttrition. — tableCohortAttrition • CohortCharacteristics

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

# Create a visual table from the output of summariseCohortAttrition.

Source: [`R/tableCohortAttrition.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCohortAttrition.R)

`tableCohortAttrition.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortAttrition(
      result,
      type = "gt",
      header = "variable_name",
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", "reason_id", "estimate_name", [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
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
    
    result <- [summariseCohortAttrition](summariseCohortAttrition.html)(cdm$cohort2)
    
    tableCohortAttrition(result)
    
    
    
    
      Reason
          | 
            Variable name
          
          
    ---|---  
    number_records
          | number_subjects
          | excluded_records
          | excluded_subjects
          
    PP_MOCK; cohort_1
          
    Initial qualifying events
    | 4
    | 4
    | 0
    | 0  
    PP_MOCK; cohort_2
          
    Initial qualifying events
    | 5
    | 5
    | 0
    | 0  
    PP_MOCK; cohort_3
          
    Initial qualifying events
    | 1
    | 1
    | 0
    | 0  
      
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
