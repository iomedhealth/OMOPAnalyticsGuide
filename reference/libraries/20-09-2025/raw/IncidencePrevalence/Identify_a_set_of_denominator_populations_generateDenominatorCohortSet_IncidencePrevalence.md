# Identify a set of denominator populations — generateDenominatorCohortSet • IncidencePrevalence

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

# Identify a set of denominator populations

Source: [`R/generateDenominatorCohortSet.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/generateDenominatorCohortSet.R)

`generateDenominatorCohortSet.Rd`

`generateDenominatorCohortSet()` creates a set of cohorts that can be used for the denominator population in analyses of incidence, using `[estimateIncidence()](estimateIncidence.html)`, or prevalence, using `[estimatePointPrevalence()](estimatePointPrevalence.html)` or `[estimatePeriodPrevalence()](estimatePeriodPrevalence.html)`.

## Usage
    
    
    generateDenominatorCohortSet(
      cdm,
      name,
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA)),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0,
      requirementInteractions = TRUE
    )

## Arguments

cdm
    

A CDM reference object

name
    

Name of the cohort table to be created. Note if a table already exists with this name in the database (give the prefix being used for the cdm reference) it will be overwritten.

cohortDateRange
    

Two dates. The first indicating the earliest cohort start date and the second indicating the latest possible cohort end date. If NULL or the first date is set as missing, the earliest observation_start_date in the observation_period table will be used for the former. If NULL or the second date is set as missing, the latest observation_end_date in the observation_period table will be used for the latter.

ageGroup
    

A list of age groups for which cohorts will be generated. A value of `list(c(0,17), c(18,30))` would, for example, lead to the creation of cohorts for those aged from 0 to 17, and from 18 to 30. In this example an individual turning 18 during the time period would appear in both cohorts (leaving the first cohort the day before their 18th birthday and entering the second from the day of their 18th birthday).

sex
    

Sex of the cohorts. This can be one or more of: `"Male"`, `"Female"`, or `"Both"`.

daysPriorObservation
    

The number of days of prior observation observed in the database required for an individual to start contributing time in a cohort.

requirementInteractions
    

If TRUE, cohorts will be created for all combinations of ageGroup, sex, and daysPriorObservation. If FALSE, only the first value specified for the other factors will be used. Consequently, order of values matters when requirementInteractions is FALSE.

## Value

A cdm reference

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- generateDenominatorCohortSet(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2008-01-01", "2020-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 3 sec
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock ───────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: censor, denominator, outcome, target
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
