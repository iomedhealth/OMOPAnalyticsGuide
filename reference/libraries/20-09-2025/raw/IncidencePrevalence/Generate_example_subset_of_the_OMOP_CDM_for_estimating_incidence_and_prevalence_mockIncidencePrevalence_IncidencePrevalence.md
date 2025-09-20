# Generate example subset of the OMOP CDM for estimating incidence and prevalence — mockIncidencePrevalence • IncidencePrevalence

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

# Generate example subset of the OMOP CDM for estimating incidence and prevalence

Source: [`R/mockIncidencePrevalence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/mockIncidencePrevalence.R)

`mockIncidencePrevalence.Rd`

Generate example subset of the OMOP CDM for estimating incidence and prevalence

## Usage
    
    
    mockIncidencePrevalence(
      personTable = NULL,
      observationPeriodTable = NULL,
      targetCohortTable = NULL,
      outcomeTable = NULL,
      censorTable = NULL,
      sampleSize = 1,
      outPre = 1,
      seed = 444,
      earliestDateOfBirth = NULL,
      latestDateOfBirth = NULL,
      earliestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
      latestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      minDaysToObservationEnd = 1,
      maxDaysToObservationEnd = 4380,
      minOutcomeDays = 1,
      maxOutcomeDays = 10,
      maxOutcomes = 1
    )

## Arguments

personTable
    

A tibble in the format of the person table.

observationPeriodTable
    

A tibble in the format of the observation period table.

targetCohortTable
    

A tibble in the format of a cohort table which can be used for stratification

outcomeTable
    

A tibble in the format of a cohort table which can be used for outcomes

censorTable
    

A tibble in the format of a cohort table which can be used for censoring

sampleSize
    

The number of unique patients.

outPre
    

The fraction of patients with an event.

seed
    

The seed for simulating the data set. Use the same seed to get same data set.

earliestDateOfBirth
    

The earliest date of birth of a patient in person table.

latestDateOfBirth
    

The latest date of birth of a patient in person table.

earliestObservationStartDate
    

The earliest observation start date for patient format.

latestObservationStartDate
    

The latest observation start date for patient format.

minDaysToObservationEnd
    

The minimum number of days of the observational integer.

maxDaysToObservationEnd
    

The maximum number of days of the observation period integer.

minOutcomeDays
    

The minimum number of days of the outcome period default set to 1.

maxOutcomeDays
    

The maximum number of days of the outcome period default set to 10.

maxOutcomes
    

The maximum possible number of outcomes per person can have default set to 1.

## Value

A cdm reference to a duckdb database with mock data.

## Examples
    
    
    # \donttest{
    cdm <- mockIncidencePrevalence(sampleSize = 100)
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock ───────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: censor, outcome, target
    #> • achilles tables: -
    #> • other tables: -
    # }
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
