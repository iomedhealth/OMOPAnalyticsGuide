# Format a summariseOverlapCohort result into a visual table. — tableCohortOverlap • CohortCharacteristics

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

# Format a summariseOverlapCohort result into a visual table.

Source: [`R/tableCohortOverlap.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCohortOverlap.R)

`tableCohortOverlap.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortOverlap(
      result,
      uniqueCombinations = TRUE,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("variable_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name"),
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

uniqueCombinations
    

Whether to restrict to unique reference and comparator comparisons.

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
    
    overlap <- [summariseCohortOverlap](summariseCohortOverlap.html)(cdm$cohort2)
    
    tableCohortOverlap(overlap)
    #> `result_id` is not present in result.
    
    
    
    
      Cohort name reference
          | Cohort name comparator
          | Estimate name
          | 
            Variable name
          
          
    ---|---|---|---  
    Only in reference cohort
          | In both cohorts
          | Only in comparator cohort
          
    PP_MOCK
          
    cohort_1
    | cohort_3
    | N (%)
    | 6 (60.00%)
    | 0 (0.00%)
    | 4 (40.00%)  
      
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
