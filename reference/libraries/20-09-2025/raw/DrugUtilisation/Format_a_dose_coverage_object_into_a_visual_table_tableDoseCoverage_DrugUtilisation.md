# Format a dose_coverage object into a visual table. — tableDoseCoverage • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# Format a dose_coverage object into a visual table.

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableDoseCoverage.Rd`

Format a dose_coverage object into a visual table.

## Usage
    
    
    tableDoseCoverage(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("variable_name", "estimate_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "ingredient_name"),
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", "sample_size"),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseDrugCoverage() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    result <- [summariseDoseCoverage](summariseDoseCoverage.html)(cdm, 1125315)
    #> ℹ The following estimates will be computed:
    #> • daily_dose: count_missing, percentage_missing, mean, sd, q25, median, q75
    #> ! Table is collected to memory as not all requested estimates are supported on
    #>   the database side
    #> → Start summary of data, at 2025-07-03 14:04:04.260479
    #> ✔ Summary finished, at 2025-07-03 14:04:04.691457
    
    tableDoseCoverage(result)
    #> Warning: cdm_name, ingredient_name, variable_name, variable_level, estimate_name, and
    #> sample_size are missing in `columnOrder`, will be added last.
    
    
    
    
      
          | 
            Variable name
          
          
    ---|---  
    
          | 
            number records
          
          | 
            Missing dose
          
          | 
            daily_dose
          
          
    Unit
          | Route
          | Pattern id
          | 
            Estimate name
          
          
    N
          | N (%)
          | Mean (SD)
          | Median (Q25 - Q75)
          
    DUS MOCK; acetaminophen
          
    overall
    | overall
    | overall
    | 7
    | 0 (0.00 %)
    | 69,701.82 (180,937.18)
    | 577.44 (23.98 - 3,640.00)  
    milligram
    | overall
    | overall
    | 7
    | 0 (0.00 %)
    | 69,701.82 (180,937.18)
    | 577.44 (23.98 - 3,640.00)  
    
    | oral
    | overall
    | 1
    | 0 (0.00 %)
    | -
    | 7.31 (7.31 - 7.31)  
    
    | topical
    | overall
    | 6
    | 0 (0.00 %)
    | 81,317.57 (195,326.75)
    | 928.72 (173.21 - 4,820.00)  
    
    | oral
    | 9
    | 1
    | 0 (0.00 %)
    | -
    | 7.31 (7.31 - 7.31)  
    
    | topical
    | 18
    | 3
    | 0 (0.00 %)
    | 160,619.15 (276,592.15)
    | 1,280.00 (928.72 - 240,640.00)  
    
    | 
    | 9
    | 3
    | 0 (0.00 %)
    | 2,015.99 (3,450.29)
    | 38.46 (23.98 - 3,019.23)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
