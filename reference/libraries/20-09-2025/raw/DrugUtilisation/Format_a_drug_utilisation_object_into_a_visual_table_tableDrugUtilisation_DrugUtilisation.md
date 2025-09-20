# Format a drug_utilisation object into a visual table. — tableDrugUtilisation • DrugUtilisation

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

# Format a drug_utilisation object into a visual table.

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableDrugUtilisation.Rd`

Format a drug_utilisation object into a visual table.

## Usage
    
    
    tableDrugUtilisation(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cohort_name", [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result)),
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", "censor_date", "cohort_table_name", "gap_era", "index_date",
        "restrict_incident"),
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

A table with a formatted version of summariseIndication() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    drugUse <- cdm$dus_cohort |>
      [summariseDrugUtilisation](summariseDrugUtilisation.html)(ingredientConceptId = 1125315)
    
    tableDrugUtilisation(drugUse)
    #> Warning: cdm_name, cohort_name, variable_level, censor_date, cohort_table_name, gap_era,
    #> index_date, and restrict_incident are missing in `columnOrder`, will be added
    #> last.
    
    
    
    
      Concept set
          | Ingredient
          | Variable name
          | Estimate name
          | 
            CDM name
          
          
    ---|---|---|---|---  
    DUS MOCK
          
    161_acetaminophen
          
    overall
    | overall
    | number records
    | N
    | 9  
    
    | 
    | number subjects
    | N
    | 6  
    ingredient_1125315_descendants
    | overall
    | number exposures
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 1.00 (0.00)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 1 (1 - 1)  
    
    | 
    | time to exposure
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 0.00 (0.00)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 0 (0 - 0)  
    
    | 
    | cumulative quantity
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 32.78 (35.28)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 10.00 (5.00 - 50.00)  
    
    | 
    | initial quantity
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 32.78 (35.28)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 10.00 (5.00 - 50.00)  
    
    | 
    | initial exposure duration
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 67.33 (62.45)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 45 (35 - 62)  
    
    | 
    | number eras
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 1.00 (0.00)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 1 (1 - 1)  
    
    | 
    | days exposed
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 67.33 (62.45)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 45 (35 - 62)  
    
    | 
    | days prescribed
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 67.33 (62.45)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 45 (35 - 62)  
    
    | acetaminophen
    | cumulative dose milligram
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 198,222.22 (257,150.63)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 50,000.00 (2,000.00 - 432,000.00)  
    
    | 
    | initial daily dose milligram
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 4,317.24 (5,436.40)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 1,428.57 (55.56 - 7,148.94)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
