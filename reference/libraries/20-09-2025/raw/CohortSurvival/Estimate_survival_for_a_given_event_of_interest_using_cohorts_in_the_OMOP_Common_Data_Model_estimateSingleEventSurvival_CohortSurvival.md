# Estimate survival for a given event of interest using cohorts in the OMOP Common Data Model — estimateSingleEventSurvival • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Estimate survival for a given event of interest using cohorts in the OMOP Common Data Model

`estimateSingleEventSurvival.Rd`

Estimate survival for a given event of interest using cohorts in the OMOP Common Data Model

## Usage
    
    
    estimateSingleEventSurvival(
      cdm,
      targetCohortTable,
      outcomeCohortTable,
      targetCohortId = NULL,
      outcomeCohortId = NULL,
      outcomeDateVariable = "cohort_start_date",
      outcomeWashout = Inf,
      censorOnCohortExit = FALSE,
      censorOnDate = NULL,
      followUpDays = Inf,
      strata = NULL,
      eventGap = 30,
      estimateGap = 1,
      restrictedMeanFollowUp = NULL,
      minimumSurvivalDays = 1
    )

## Arguments

cdm
    

CDM reference

targetCohortTable
    

targetCohortTable

outcomeCohortTable
    

The outcome cohort table of interest.

targetCohortId
    

Target cohorts to include. It can either be a cohort_definition_id value or a cohort_name. Multiple ids are allowed.

outcomeCohortId
    

Outcome cohorts to include. It can either be a cohort_definition_id value or a cohort_name. Multiple ids are allowed.

outcomeDateVariable
    

Variable containing date of outcome event

outcomeWashout
    

Washout time in days for the outcome

censorOnCohortExit
    

If TRUE, an individual's follow up will be censored at their cohort exit

censorOnDate
    

if not NULL, an individual's follow up will be censored at the given date

followUpDays
    

Number of days to follow up individuals (lower bound 1, upper bound Inf)

strata
    

strata

eventGap
    

Days between time points for which to report survival events, which are grouped into the specified intervals.

estimateGap
    

Days between time points for which to report survival estimates. First day will be day zero with risk estimates provided for times up to the end of follow-up, with a gap in days equivalent to eventGap.

restrictedMeanFollowUp
    

number of days of follow-up to take into account when calculating restricted mean for all cohorts

minimumSurvivalDays
    

Minimum number of days required for the main cohort to have survived

## Value

tibble with survival information for desired cohort, including: time, people at risk, survival probability, cumulative incidence, 95 CIs, strata and outcome. A tibble with the number of events is outputted as an attribute of the output

## Examples
    
    
    # \donttest{
    cdm <- [mockMGUS2cdm](mockMGUS2cdm.html)()
    #> ■■■■■■■■■■■■■■■■■■■■■■■■■         80% | ETA:  1s
    surv <- estimateSingleEventSurvival(
      cdm = cdm,
      targetCohortTable = "mgus_diagnosis",
      targetCohortId = 1,
      outcomeCohortTable = "death_cohort",
      outcomeCohortId = 1,
      eventGap = 7
    )
    #> - Getting survival for target cohort 'mgus_diagnosis' and outcome cohort
    #> 'death_cohort'
    #> Getting overall estimates
    #> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
    #> `minimum_survival_days` casted to character.
    # }
    
    

## On this page

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
