# A tidy implementation of the summarised_characteristics object. — asSurvivalResult • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# A tidy implementation of the summarised_characteristics object.

`asSurvivalResult.Rd`

A tidy implementation of the summarised_characteristics object.

## Usage
    
    
    asSurvivalResult(result)

## Arguments

result
    

A summarised_characteristics object.

## Value

A tibble with a tidy version of the summarised_characteristics object.

## Examples
    
    
    # \donttest{
    cdm <- [mockMGUS2cdm](mockMGUS2cdm.html)()
    surv <- [estimateSingleEventSurvival](estimateSingleEventSurvival.html)(
      cdm = cdm,
      targetCohortTable = "mgus_diagnosis",
      targetCohortId = 1,
      outcomeCohortTable = "death_cohort",
      outcomeCohortId = 1,
      eventGap = 7
    ) [%>%](pipe.html)
      asSurvivalResult()
    #> - Getting survival for target cohort 'mgus_diagnosis' and outcome cohort
    #> 'death_cohort'
    #> Getting overall estimates
    #> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
    #> `minimum_survival_days` casted to character.
    # }
    
    

## On this page

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
