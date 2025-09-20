# Erafy a cohort_table collapsing records separated gapEra days or less. — erafyCohort • DrugUtilisation

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

# Erafy a cohort_table collapsing records separated gapEra days or less.

Source: [`R/erafyCohort.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/erafyCohort.R)

`erafyCohort.Rd`

Erafy a cohort_table collapsing records separated gapEra days or less.

## Usage
    
    
    erafyCohort(
      cohort,
      gapEra,
      cohortId = NULL,
      nameStyle = "{cohort_name}_{gap_era}",
      name = omopgenerics::[tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort_table object.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

nameStyle
    

String to create the new names of cohorts. Must contain '{cohort_name}' if more than one cohort is present and '{gap_era}' if more than one gapEra is provided.

name
    

Name of the new cohort table, it must be a length 1 character vector.

## Value

A cohort_table object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm$cohort2 <- cdm$cohort1 |>
      erafyCohort(gapEra = 30, name = "cohort2")
    
    cdm$cohort2
    #> # Source:   table<cohort2> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          3 2007-06-02        2010-01-09     
    #>  2                    2          6 2022-05-22        2022-06-24     
    #>  3                    2          5 2020-11-19        2020-12-09     
    #>  4                    2          1 2018-01-01        2018-04-13     
    #>  5                    1          9 1996-07-08        2011-06-17     
    #>  6                    2          2 2013-01-11        2013-03-19     
    #>  7                    2         10 2001-09-26        2003-09-30     
    #>  8                    2          8 1984-01-05        1984-01-10     
    #>  9                    3          4 2012-06-19        2012-10-10     
    #> 10                    3          7 2007-06-07        2007-08-01     
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id cohort_name gap_era
    #>                  <int> <chr>       <chr>  
    #> 1                    1 cohort_1_30 30     
    #> 2                    2 cohort_2_30 30     
    #> 3                    3 cohort_3_30 30     
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
