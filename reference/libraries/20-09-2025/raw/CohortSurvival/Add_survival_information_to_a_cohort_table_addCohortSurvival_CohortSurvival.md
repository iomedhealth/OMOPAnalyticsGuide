# Add survival information to a cohort table — addCohortSurvival • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Add survival information to a cohort table

`addCohortSurvival.Rd`

Add survival information to a cohort table

## Usage
    
    
    addCohortSurvival(
      x,
      cdm,
      outcomeCohortTable,
      outcomeCohortId = 1,
      outcomeDateVariable = "cohort_start_date",
      outcomeWashout = Inf,
      censorOnCohortExit = FALSE,
      censorOnDate = NULL,
      followUpDays = Inf,
      name = NULL
    )

## Arguments

x
    

cohort table to add survival information

cdm
    

CDM reference

outcomeCohortTable
    

The outcome cohort table of interest.

outcomeCohortId
    

ID of event cohorts to include. Only one outcome (and so one ID) can be considered.

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

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

Two additional columns will be added to x. The "time" column will contain number of days to censoring. The "status" column will indicate whether the patient had the event (value: 1), or did not have the event (value: 0)

## Examples
    
    
    # \donttest{
    
    cdm <- [mockMGUS2cdm](mockMGUS2cdm.html)()
    cdm$mgus_diagnosis <- cdm$mgus_diagnosis [%>%](pipe.html)
      addCohortSurvival(
        cdm = cdm,
        outcomeCohortTable = "death_cohort",
        outcomeCohortId = 1
      )
      # }
    
    

## On this page

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
