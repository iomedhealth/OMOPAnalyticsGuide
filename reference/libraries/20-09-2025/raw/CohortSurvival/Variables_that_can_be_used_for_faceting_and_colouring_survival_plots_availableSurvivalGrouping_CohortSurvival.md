# Variables that can be used for faceting and colouring survival plots — availableSurvivalGrouping • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Variables that can be used for faceting and colouring survival plots

`availableSurvivalGrouping.Rd`

Variables that can be used for faceting and colouring survival plots

## Usage
    
    
    availableSurvivalGrouping(result, varying = FALSE)

## Arguments

result
    

Survival results

varying
    

If FALSE (default), only variables with non-unique values will be returned, otherwise all available variables will be returned.

## Examples
    
    
    # \donttest{
    cdm <- [mockMGUS2cdm](mockMGUS2cdm.html)()
    surv <- [estimateSingleEventSurvival](estimateSingleEventSurvival.html)(cdm,
                                        targetCohortTable = "mgus_diagnosis",
                                        outcomeCohortTable = "death_cohort")
    #> - Getting survival for target cohort 'mgus_diagnosis' and outcome cohort
    #> 'death_cohort'
    #> Getting overall estimates
    #> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
    #> `minimum_survival_days` casted to character.
    availableSurvivalGrouping(surv)
    #> [1] "time"                "estimate"            "estimate_95CI_lower"
    #> [4] "estimate_95CI_upper"
    # }
    

## On this page

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
