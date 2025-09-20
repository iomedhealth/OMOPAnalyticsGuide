# Table of prevalence results — tablePrevalence • IncidencePrevalence

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

# Table of prevalence results

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`tablePrevalence.Rd`

Table of prevalence results

## Usage
    
    
    tablePrevalence(
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
    

Prevalence results

type
    

Type of table. Can be "gt", "flextable", or "tibble"

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "denominator_cohort_name", "outcome_cohort_name", "prevalence_start_date", "prevalence_end_date", "estimate_name", variables in the `strata_name` column, and any of the settings columns specified in `settingsColumn` argument. The header can also include other names to use as overall header labels

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

Table of prevalence results

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
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
    tablePrevalence(prev)
    
    
    
    
      Prevalence start date
          | Prevalence end date
          | Denominator age group
          | Denominator sex
          | 
            Estimate name
          
          
    ---|---|---|---|---  
    Denominator (N)
          | Outcome (N)
          | Prevalence [95% CI]
          
    mock; cohort_1
          
    2008-01-01
    | 2008-01-01
    | 0 to 150
    | Both
    | 55
    | 0
    | 0.00 (0.00 - 0.07)  
    2008-02-01
    | 2008-02-01
    | 0 to 150
    | Both
    | 55
    | 0
    | 0.00 (0.00 - 0.07)  
    2008-03-01
    | 2008-03-01
    | 0 to 150
    | Both
    | 55
    | 0
    | 0.00 (0.00 - 0.07)  
    2008-04-01
    | 2008-04-01
    | 0 to 150
    | Both
    | 56
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-05-01
    | 2008-05-01
    | 0 to 150
    | Both
    | 57
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-06-01
    | 2008-06-01
    | 0 to 150
    | Both
    | 57
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-07-01
    | 2008-07-01
    | 0 to 150
    | Both
    | 57
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-08-01
    | 2008-08-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-09-01
    | 2008-09-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-10-01
    | 2008-10-01
    | 0 to 150
    | Both
    | 59
    | 1
    | 0.02 (0.00 - 0.09)  
    2008-11-01
    | 2008-11-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-12-01
    | 2008-12-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-01-01
    | 2009-01-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-02-01
    | 2009-02-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-03-01
    | 2009-03-01
    | 0 to 150
    | Both
    | 56
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-04-01
    | 2009-04-01
    | 0 to 150
    | Both
    | 56
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-05-01
    | 2009-05-01
    | 0 to 150
    | Both
    | 54
    | 0
    | 0.00 (0.00 - 0.07)  
    2009-06-01
    | 2009-06-01
    | 0 to 150
    | Both
    | 54
    | 0
    | 0.00 (0.00 - 0.07)  
    2009-07-01
    | 2009-07-01
    | 0 to 150
    | Both
    | 54
    | 1
    | 0.02 (0.00 - 0.10)  
    2009-08-01
    | 2009-08-01
    | 0 to 150
    | Both
    | 54
    | 2
    | 0.04 (0.01 - 0.13)  
    2009-09-01
    | 2009-09-01
    | 0 to 150
    | Both
    | 53
    | 0
    | 0.00 (0.00 - 0.07)  
    2009-10-01
    | 2009-10-01
    | 0 to 150
    | Both
    | 52
    | 0
    | 0.00 (0.00 - 0.07)  
    2009-11-01
    | 2009-11-01
    | 0 to 150
    | Both
    | 51
    | 1
    | 0.02 (0.00 - 0.10)  
    2009-12-01
    | 2009-12-01
    | 0 to 150
    | Both
    | 53
    | 0
    | 0.00 (0.00 - 0.07)  
    2010-01-01
    | 2010-01-01
    | 0 to 150
    | Both
    | 52
    | 1
    | 0.02 (0.00 - 0.10)  
    2010-02-01
    | 2010-02-01
    | 0 to 150
    | Both
    | 52
    | 0
    | 0.00 (0.00 - 0.07)  
    2010-03-01
    | 2010-03-01
    | 0 to 150
    | Both
    | 49
    | 0
    | 0.00 (0.00 - 0.07)  
    2010-04-01
    | 2010-04-01
    | 0 to 150
    | Both
    | 46
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-05-01
    | 2010-05-01
    | 0 to 150
    | Both
    | 44
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-06-01
    | 2010-06-01
    | 0 to 150
    | Both
    | 44
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-07-01
    | 2010-07-01
    | 0 to 150
    | Both
    | 43
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-08-01
    | 2010-08-01
    | 0 to 150
    | Both
    | 42
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-09-01
    | 2010-09-01
    | 0 to 150
    | Both
    | 41
    | 1
    | 0.02 (0.00 - 0.13)  
    2010-10-01
    | 2010-10-01
    | 0 to 150
    | Both
    | 41
    | 1
    | 0.02 (0.00 - 0.13)  
    2010-11-01
    | 2010-11-01
    | 0 to 150
    | Both
    | 41
    | 0
    | 0.00 (0.00 - 0.09)  
    2010-12-01
    | 2010-12-01
    | 0 to 150
    | Both
    | 41
    | 0
    | 0.00 (0.00 - 0.09)  
    2011-01-01
    | 2011-01-01
    | 0 to 150
    | Both
    | 41
    | 0
    | 0.00 (0.00 - 0.09)  
    2011-02-01
    | 2011-02-01
    | 0 to 150
    | Both
    | 39
    | 1
    | 0.03 (0.00 - 0.13)  
    2011-03-01
    | 2011-03-01
    | 0 to 150
    | Both
    | 39
    | 1
    | 0.03 (0.00 - 0.13)  
    2011-04-01
    | 2011-04-01
    | 0 to 150
    | Both
    | 37
    | 0
    | 0.00 (0.00 - 0.09)  
    2011-05-01
    | 2011-05-01
    | 0 to 150
    | Both
    | 36
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-06-01
    | 2011-06-01
    | 0 to 150
    | Both
    | 36
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-07-01
    | 2011-07-01
    | 0 to 150
    | Both
    | 36
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-08-01
    | 2011-08-01
    | 0 to 150
    | Both
    | 35
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-09-01
    | 2011-09-01
    | 0 to 150
    | Both
    | 35
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-10-01
    | 2011-10-01
    | 0 to 150
    | Both
    | 35
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-11-01
    | 2011-11-01
    | 0 to 150
    | Both
    | 33
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-12-01
    | 2011-12-01
    | 0 to 150
    | Both
    | 33
    | 0
    | 0.00 (0.00 - 0.10)  
    2012-01-01
    | 2012-01-01
    | 0 to 150
    | Both
    | 32
    | 0
    | 0.00 (0.00 - 0.11)  
    2012-02-01
    | 2012-02-01
    | 0 to 150
    | Both
    | 31
    | 0
    | 0.00 (0.00 - 0.11)  
    2012-03-01
    | 2012-03-01
    | 0 to 150
    | Both
    | 31
    | 0
    | 0.00 (0.00 - 0.11)  
    2012-04-01
    | 2012-04-01
    | 0 to 150
    | Both
    | 29
    | 0
    | 0.00 (0.00 - 0.12)  
    2012-05-01
    | 2012-05-01
    | 0 to 150
    | Both
    | 28
    | 0
    | 0.00 (0.00 - 0.12)  
    2012-06-01
    | 2012-06-01
    | 0 to 150
    | Both
    | 27
    | 0
    | 0.00 (0.00 - 0.12)  
    2012-07-01
    | 2012-07-01
    | 0 to 150
    | Both
    | 26
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-08-01
    | 2012-08-01
    | 0 to 150
    | Both
    | 26
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-09-01
    | 2012-09-01
    | 0 to 150
    | Both
    | 26
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-10-01
    | 2012-10-01
    | 0 to 150
    | Both
    | 26
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-11-01
    | 2012-11-01
    | 0 to 150
    | Both
    | 25
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-12-01
    | 2012-12-01
    | 0 to 150
    | Both
    | 25
    | 0
    | 0.00 (0.00 - 0.13)  
    2013-01-01
    | 2013-01-01
    | 0 to 150
    | Both
    | 25
    | 0
    | 0.00 (0.00 - 0.13)  
    2013-02-01
    | 2013-02-01
    | 0 to 150
    | Both
    | 24
    | 0
    | 0.00 (0.00 - 0.14)  
    2013-03-01
    | 2013-03-01
    | 0 to 150
    | Both
    | 23
    | 0
    | 0.00 (0.00 - 0.14)  
    2013-04-01
    | 2013-04-01
    | 0 to 150
    | Both
    | 22
    | 0
    | 0.00 (0.00 - 0.15)  
    2013-05-01
    | 2013-05-01
    | 0 to 150
    | Both
    | 21
    | 0
    | 0.00 (0.00 - 0.15)  
    2013-06-01
    | 2013-06-01
    | 0 to 150
    | Both
    | 21
    | 0
    | 0.00 (0.00 - 0.15)  
    2013-07-01
    | 2013-07-01
    | 0 to 150
    | Both
    | 20
    | 0
    | 0.00 (0.00 - 0.16)  
    2013-08-01
    | 2013-08-01
    | 0 to 150
    | Both
    | 20
    | 0
    | 0.00 (0.00 - 0.16)  
    2013-09-01
    | 2013-09-01
    | 0 to 150
    | Both
    | 20
    | 0
    | 0.00 (0.00 - 0.16)  
    2013-10-01
    | 2013-10-01
    | 0 to 150
    | Both
    | 18
    | 1
    | 0.06 (0.01 - 0.26)  
    2013-11-01
    | 2013-11-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2013-12-01
    | 2013-12-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-01-01
    | 2014-01-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-02-01
    | 2014-02-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-03-01
    | 2014-03-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-04-01
    | 2014-04-01
    | 0 to 150
    | Both
    | 18
    | 1
    | 0.06 (0.01 - 0.26)  
    2014-05-01
    | 2014-05-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-06-01
    | 2014-06-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-07-01
    | 2014-07-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-08-01
    | 2014-08-01
    | 0 to 150
    | Both
    | 17
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-09-01
    | 2014-09-01
    | 0 to 150
    | Both
    | 17
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-10-01
    | 2014-10-01
    | 0 to 150
    | Both
    | 17
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-11-01
    | 2014-11-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2014-12-01
    | 2014-12-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-01-01
    | 2015-01-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-02-01
    | 2015-02-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-03-01
    | 2015-03-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-04-01
    | 2015-04-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-05-01
    | 2015-05-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-06-01
    | 2015-06-01
    | 0 to 150
    | Both
    | 16
    | 1
    | 0.06 (0.01 - 0.28)  
    2015-07-01
    | 2015-07-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-08-01
    | 2015-08-01
    | 0 to 150
    | Both
    | 15
    | 0
    | 0.00 (0.00 - 0.20)  
    2015-09-01
    | 2015-09-01
    | 0 to 150
    | Both
    | 15
    | 0
    | 0.00 (0.00 - 0.20)  
    2015-10-01
    | 2015-10-01
    | 0 to 150
    | Both
    | 15
    | 0
    | 0.00 (0.00 - 0.20)  
    2015-11-01
    | 2015-11-01
    | 0 to 150
    | Both
    | 15
    | 0
    | 0.00 (0.00 - 0.20)  
    2015-12-01
    | 2015-12-01
    | 0 to 150
    | Both
    | 14
    | 0
    | 0.00 (0.00 - 0.22)  
    2016-01-01
    | 2016-01-01
    | 0 to 150
    | Both
    | 14
    | 0
    | 0.00 (0.00 - 0.22)  
    2016-02-01
    | 2016-02-01
    | 0 to 150
    | Both
    | 13
    | 0
    | 0.00 (0.00 - 0.23)  
    2016-03-01
    | 2016-03-01
    | 0 to 150
    | Both
    | 11
    | 0
    | 0.00 (0.00 - 0.26)  
    2016-04-01
    | 2016-04-01
    | 0 to 150
    | Both
    | 11
    | 0
    | 0.00 (0.00 - 0.26)  
    2016-05-01
    | 2016-05-01
    | 0 to 150
    | Both
    | 10
    | 0
    | 0.00 (0.00 - 0.28)  
    2016-06-01
    | 2016-06-01
    | 0 to 150
    | Both
    | 10
    | 0
    | 0.00 (0.00 - 0.28)  
    2016-07-01
    | 2016-07-01
    | 0 to 150
    | Both
    | 10
    | 0
    | 0.00 (0.00 - 0.28)  
    2016-08-01
    | 2016-08-01
    | 0 to 150
    | Both
    | 10
    | 0
    | 0.00 (0.00 - 0.28)  
    2016-09-01
    | 2016-09-01
    | 0 to 150
    | Both
    | 9
    | 0
    | 0.00 (0.00 - 0.30)  
    2016-10-01
    | 2016-10-01
    | 0 to 150
    | Both
    | 8
    | 0
    | 0.00 (0.00 - 0.32)  
    2016-11-01
    | 2016-11-01
    | 0 to 150
    | Both
    | 8
    | 0
    | 0.00 (0.00 - 0.32)  
    2016-12-01
    | 2016-12-01
    | 0 to 150
    | Both
    | 8
    | 0
    | 0.00 (0.00 - 0.32)  
    2017-01-01
    | 2017-01-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-02-01
    | 2017-02-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-03-01
    | 2017-03-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-04-01
    | 2017-04-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-05-01
    | 2017-05-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-06-01
    | 2017-06-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-07-01
    | 2017-07-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-08-01
    | 2017-08-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-09-01
    | 2017-09-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-10-01
    | 2017-10-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-11-01
    | 2017-11-01
    | 0 to 150
    | Both
    | 6
    | 0
    | 0.00 (0.00 - 0.39)  
    2017-12-01
    | 2017-12-01
    | 0 to 150
    | Both
    | 6
    | 0
    | 0.00 (0.00 - 0.39)  
    2018-01-01
    | 2018-01-01
    | 0 to 150
    | Both
    | 6
    | 0
    | 0.00 (0.00 - 0.39)  
      
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
