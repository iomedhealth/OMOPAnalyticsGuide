# Table of prevalence attrition results — tablePrevalenceAttrition • IncidencePrevalence

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Table of prevalence attrition results

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`tablePrevalenceAttrition.Rd`

Table of prevalence attrition results

## Usage
    
    
    tablePrevalenceAttrition(
      result,
      type = "gt",
      header = "variable_name",
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
      settingsColumn = NULL,
      hide = [c](https://rdrr.io/r/base/c.html)("denominator_cohort_name", "estimate_name", "reason_id", "variable_level"),
      style = "default"
    )

## Arguments

result
    

A summarised_result object. Output of summariseCohortAttrition().

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `colnames(omopgenerics::splitAll(result))`. Variables in `settingsColumn` are also allowed

groupColumn
    

Variables to use as group labels. Allowed columns are the same as in `header`

settingsColumn
    

Variables from the settings attribute to display in the table

hide
    

Table columns to exclude, options are the ones described in `header`

style
    

A style supported by visOmopResults::visOmopTable()

## Value

A visual table.

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    prev <- [estimatePointPrevalence](estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "months"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 1 secs
    tablePrevalenceAttrition(prev)
    
    
    
    
      Reason
          | 
            Variable name
          
          
    ---|---  
    Number records
          | Number subjects
          | Excluded records
          | Excluded subjects
          
    mock; cohort_1
          
    Starting population
    | 1,000
    | 1,000
    | -
    | -  
    Missing year of birth
    | 1,000
    | 1,000
    | 0
    | 0  
    Missing sex
    | 1,000
    | 1,000
    | 0
    | 0  
    Cannot satisfy age criteria during the study period based on year of birth
    | 1,000
    | 1,000
    | 0
    | 0  
    No observation time available during study period
    | 70
    | 70
    | 930
    | 930  
    Doesn't satisfy age criteria during the study period
    | 70
    | 70
    | 0
    | 0  
    Prior history requirement not fulfilled during study period
    | 70
    | 70
    | 0
    | 0  
    No observation time available after applying age, prior observation and, if applicable, target criteria
    | 70
    | 70
    | 0
    | 0  
    Starting analysis population
    | 70
    | 70
    | -
    | -  
    Not observed during the complete database interval
    | 70
    | 70
    | 0
    | 0  
    Do not satisfy full contribution requirement for an interval
    | 70
    | 70
    | 0
    | 0  
      
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
