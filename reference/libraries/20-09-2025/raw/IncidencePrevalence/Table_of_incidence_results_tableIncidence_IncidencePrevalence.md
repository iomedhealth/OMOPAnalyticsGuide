# Table of incidence results — tableIncidence • IncidencePrevalence

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

# Table of incidence results

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`tableIncidence.Rd`

Table of incidence results

## Usage
    
    
    tableIncidence(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("estimate_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
      settingsColumn = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"),
      hide = [c](https://rdrr.io/r/base/c.html)("denominator_cohort_name", "analysis_interval"),
      style = "default",
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

Incidence results

type
    

Type of table. Can be "gt", "flextable", or "tibble"

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "denominator_cohort_name", "outcome_cohort_name", "incidence_start_date", "incidence_end_date", "estimate_name", variables in the `strata_name` column, and any of the settings columns specified in `settingsColumn` argument. The header can also include other names to use as overall header labels

groupColumn
    

Variables to use as group labels. Allowed columns are the same as in `header`

settingsColumn
    

Variables from the settings attribute to display in the table

hide
    

Table columns to exclude, options are the ones described in `header`

style
    

A style supported by visOmopResults::visOmopTable()

.options
    

Table options to apply

## Value

Table of results

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 3 sec
    inc <- [estimateIncidence](estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    tableIncidence(inc)
    
    
    
    
      Incidence start date
          | Incidence end date
          | Denominator age group
          | Denominator sex
          | 
            Estimate name
          
          
    ---|---|---|---|---  
    Denominator (N)
          | Person-years
          | Outcome (N)
          | Incidence 100,000 person-years [95% CI]
          
    mock; cohort_1
          
    2008-01-01
    | 2008-12-31
    | 0 to 150
    | Both
    | 42
    | 33.05
    | 9
    | 27,230.64 (12,451.58 -
          51,692.24)  
    2009-01-01
    | 2009-12-31
    | 0 to 150
    | Both
    | 38
    | 28.74
    | 13
    | 45,229.98 (24,083.06 -
          77,344.64)  
    2010-01-01
    | 2010-12-31
    | 0 to 150
    | Both
    | 25
    | 19.69
    | 8
    | 40,623.57 (17,538.38 -
          80,044.63)  
    2011-01-01
    | 2011-12-31
    | 0 to 150
    | Both
    | 17
    | 11.57
    | 7
    | 60,485.61 (24,318.35 -
          124,623.48)  
    2012-01-01
    | 2012-12-31
    | 0 to 150
    | Both
    | 10
    | 9.86
    | 1
    | 10,137.88 (256.67 -
          56,484.62)  
    2013-01-01
    | 2013-12-31
    | 0 to 150
    | Both
    | 9
    | 8.74
    | 1
    | 11,446.89 (289.81 -
          63,777.97)  
    2014-01-01
    | 2014-12-31
    | 0 to 150
    | Both
    | 8
    | 6.36
    | 2
    | 31,461.38 (3,810.12 -
          113,649.33)  
    2015-01-01
    | 2015-12-31
    | 0 to 150
    | Both
    | 6
    | 3.86
    | 4
    | 103,761.35 (28,271.47 -
          265,670.26)  
    2016-01-01
    | 2016-12-31
    | 0 to 150
    | Both
    | 2
    | 1.11
    | 1
    | 90,415.91 (2,289.13 -
          503,765.22)  
      
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
