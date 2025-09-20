# Format a summarised_treatment result into a visual table. — tableTreatment • DrugUtilisation

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

# Format a summarised_treatment result into a visual table.

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableTreatment.Rd`

Format a summarised_treatment result into a visual table.

## Usage
    
    
    tableTreatment(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      groupColumn = "variable_name",
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("window_name", "mutually_exclusive", "censor_date", "cohort_table_name",
        "index_date", "treatment_cohort_name"),
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

A table with a formatted version of summariseTreatment() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    result <- cdm$cohort1 |>
      [summariseTreatment](summariseTreatment.html)(
        treatmentCohortName = "cohort2",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 30), [c](https://rdrr.io/r/base/c.html)(31, 365))
      )
    #> ℹ Intersect with medications table (cohort2)
    #> ℹ Summarising medications.
    
    tableTreatment(result)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
    #> are missing in `columnOrder`, will be added last.
    
    
    
    
      
          | 
            CDM name
          
          
    ---|---  
    
          | 
            DUS MOCK
          
          
    Treatment
          | Estimate name
          | 
            Cohort name
          
          
    cohort_1
          | cohort_2
          | cohort_3
          
    Medication from index date to 30 days after
          
    cohort_1
    | N (%)
    | 0 (0.00 %)
    | 1 (100.00 %)
    | 0 (0.00 %)  
    cohort_2
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 1 (16.67 %)  
    cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 2 (33.33 %)  
    untreated
    | N (%)
    | 3 (100.00 %)
    | 0 (0.00 %)
    | 3 (50.00 %)  
    not in observation
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    Medication from 31 days after to 365 days after the index date
          
    cohort_1
    | N (%)
    | 0 (0.00 %)
    | 1 (100.00 %)
    | 0 (0.00 %)  
    cohort_2
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 1 (16.67 %)  
    cohort_3
    | N (%)
    | 1 (33.33 %)
    | 0 (0.00 %)
    | 2 (33.33 %)  
    untreated
    | N (%)
    | 2 (66.67 %)
    | 0 (0.00 %)
    | 3 (50.00 %)  
    not in observation
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
