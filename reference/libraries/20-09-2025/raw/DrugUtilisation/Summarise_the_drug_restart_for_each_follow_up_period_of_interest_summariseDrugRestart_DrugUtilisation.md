# Summarise the drug restart for each follow-up period of interest. — summariseDrugRestart • DrugUtilisation

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

# Summarise the drug restart for each follow-up period of interest.

Source: [`R/summariseDrugRestart.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseDrugRestart.R)

`summariseDrugRestart.Rd`

Summarise the drug restart for each follow-up period of interest.

## Usage
    
    
    summariseDrugRestart(
      cohort,
      cohortId = NULL,
      switchCohortTable,
      switchCohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      followUpDays = Inf,
      censorDate = NULL,
      incident = TRUE,
      restrictToFirstDiscontinuation = TRUE
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

switchCohortTable
    

A cohort table in the cdm that contains possible alternative treatments.

switchCohortId
    

The cohort ids to be used from switchCohortTable. If NULL all cohort definition ids are used.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

followUpDays
    

A vector of number of days to follow up. It can be multiple values.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

incident
    

Whether the switch treatment has to be incident (start after discontinuation) or not (it can start before the discontinuation and last till after).

restrictToFirstDiscontinuation
    

Whether to consider only the first discontinuation episode or all of them.

## Value

A summarised_result object with the percentages of restart, switch and not exposed per follow-up period given.

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
      summariseDrugRestart(switchCohortTable = "switch_cohort")
    
    [tableDrugRestart](tableDrugRestart.html)(result)
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
    | 1 (33.33 %)
    | 0 (0.00 %)  
    restart and switch
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    untreated
    | N (%)
    | 2 (100.00 %)
    | 2 (66.67 %)
    | 5 (100.00 %)  
      
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
