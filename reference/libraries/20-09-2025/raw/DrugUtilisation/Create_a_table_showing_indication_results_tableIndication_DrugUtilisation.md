# Create a table showing indication results — tableIndication • DrugUtilisation

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

# Create a table showing indication results

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableIndication.Rd`

Create a table showing indication results

## Usage
    
    
    tableIndication(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name", [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result)),
      groupColumn = "variable_name",
      hide = [c](https://rdrr.io/r/base/c.html)("window_name", "mutually_exclusive", "unknown_indication_table",
        "censor_date", "cohort_table_name", "index_date", "indication_cohort_name"),
      type = "gt",
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseIndication() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    result <- cdm$cohort1 |>
      [summariseIndication](summariseIndication.html)(
        indicationCohortName = "cohort2",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-30, 0)),
        unknownIndicationTable = "condition_occurrence"
      )
    #> ℹ Intersect with indications table (cohort2)
    #> ℹ Summarising indications.
    
    tableIndication(result)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, indication_cohort_name, mutually_exclusive, and
    #> unknown_indication_table are missing in `columnOrder`, will be added last.
    
    
    
    
      
          | 
            CDM name
          
          
    ---|---  
    
          | 
            DUS MOCK
          
          
    Indication
          | Estimate name
          | 
            Cohort name
          
          
    cohort_1
          | cohort_2
          | cohort_3
          
    Indication from 30 days before to the index date
          
    cohort_1
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_2
    | N (%)
    | 2 (66.67 %)
    | 1 (33.33 %)
    | 1 (25.00 %)  
    cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_1 and cohort_2
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_1 and cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_2 and cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_1 and cohort_2 and cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    unknown
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    none
    | N (%)
    | 1 (33.33 %)
    | 2 (66.67 %)
    | 3 (75.00 %)  
    not in observation
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
