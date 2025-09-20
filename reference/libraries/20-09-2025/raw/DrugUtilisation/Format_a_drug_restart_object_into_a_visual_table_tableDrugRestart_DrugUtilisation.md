# Format a drug_restart object into a visual table. — tableDrugRestart • DrugUtilisation

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

# Format a drug_restart object into a visual table.

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableDrugRestart.Rd`

Format a drug_restart object into a visual table.

## Usage
    
    
    tableDrugRestart(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      groupColumn = "variable_name",
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("censor_date", "restrict_to_first_discontinuation", "follow_up_days",
        "cohort_table_name", "incident", "switch_cohort_table"),
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

A table with a formatted version of summariseDrugRestart() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    conceptlist <- [list](https://rdrr.io/r/base/list.html)(acetaminophen = 1125360, metformin = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327))
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "switch_cohort",
                                            conceptSet = conceptlist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$cohort1 |>
      [summariseDrugRestart](summariseDrugRestart.html)(switchCohortTable = "switch_cohort")
    
    tableDrugRestart(result)
    #> Warning: cdm_name, cohort_name, variable_name, follow_up_days, censor_date,
    #> cohort_table_name, incident, restrict_to_first_discontinuation, and
    #> switch_cohort_table are missing in `columnOrder`, will be added last.
    
    
    
    
      
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
          
    Drug restart till end of observation
          
    restart
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    switch
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    restart and switch
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    untreated
    | N (%)
    | 3 (100.00 %)
    | 3 (100.00 %)
    | 4 (100.00 %)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
