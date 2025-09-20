# Add drug restart information as a column per follow-up period of interest. — addDrugRestart • DrugUtilisation

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

# Add drug restart information as a column per follow-up period of interest.

Source: [`R/summariseDrugRestart.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseDrugRestart.R)

`addDrugRestart.Rd`

Add drug restart information as a column per follow-up period of interest.

## Usage
    
    
    addDrugRestart(
      cohort,
      switchCohortTable,
      switchCohortId = NULL,
      followUpDays = Inf,
      censorDate = NULL,
      incident = TRUE,
      nameStyle = "drug_restart_{follow_up_days}"
    )

## Arguments

cohort
    

A cohort_table object.

switchCohortTable
    

A cohort table in the cdm that contains possible alternative treatments.

switchCohortId
    

The cohort ids to be used from switchCohortTable. If NULL all cohort definition ids are used.

followUpDays
    

A vector of number of days to follow up. It can be multiple values.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

incident
    

Whether the switch treatment has to be incident (start after discontinuation) or not (it can start before the discontinuation and last till after).

nameStyle
    

Character string to specify the nameStyle of the new columns.

## Value

The cohort table given with additional columns with information on the restart, switch and not exposed per follow-up period of interest.

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
    
    cdm$cohort1 |>
      addDrugRestart(switchCohortTable = "switch_cohort")
    #> # Source:   table<og_046_1751551185> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2         10 2007-02-09        2007-11-01     
    #>  2                    2          3 2011-06-01        2012-01-18     
    #>  3                    2          6 2020-08-14        2020-12-16     
    #>  4                    3          1 2012-09-30        2012-11-14     
    #>  5                    3          7 2008-10-22        2009-05-22     
    #>  6                    3          8 2021-08-28        2021-08-28     
    #>  7                    3          5 1985-08-28        2009-04-23     
    #>  8                    3          9 2017-06-09        2018-05-10     
    #>  9                    1          2 2020-05-11        2020-05-28     
    #> 10                    2          4 2022-05-25        2022-07-25     
    #> # ℹ 1 more variable: drug_restart_inf <chr>
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
