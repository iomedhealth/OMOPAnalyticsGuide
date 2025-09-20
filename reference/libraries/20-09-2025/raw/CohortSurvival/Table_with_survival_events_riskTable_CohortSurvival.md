# Table with survival events — riskTable • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Table with survival events

`riskTable.Rd`

Table with survival events

## Usage
    
    
    riskTable(
      x,
      eventGap = NULL,
      header = [c](https://rdrr.io/r/base/c.html)("estimate"),
      type = "gt",
      groupColumn = NULL,
      style = "default",
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

x
    

Result from estimateSingleEventSurvival or estimateCompetingRiskSurvival.

eventGap
    

Event gap defining the times at which to report the risk table information. Must be one of the eventGap inputs used for the estimation function. If NULL, all available are reported.

header
    

A vector containing which elements should go into the header. Allowed are: cdm_name, group, strata, additional, variable, estimate, and settings.

type
    

Type of desired formatted table, possibilities: "gt", "flextable", and "tibble".

groupColumn
    

Columns to use as group labels.

style
    

Named list that specifies how to style the different parts of the table generated. It can either be a pre-defined style ("default" or "darwin" - the latter just for gt and flextable), NULL to get the table default style, or custom. Keep in mind that styling code is different for all table styles. To see the different styles check visOmopResults::tableStyle().

.options
    

Named list with additional formatting options. CohortSurvival::optionsTableSurvival() shows allowed arguments and their default values.

## Value

A tibble containing the risk table information (n_risk, n_events, n_censor) for all times within the event gap specified.

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
    riskTable(surv)
    
    
    
    
      CDM name
          | Target cohort
          | Outcome name
          | Time
          | Event gap
          | 
            Estimate name
          
          
    ---|---|---|---|---|---  
    Number at risk
          | Number events
          | Number censored
          
    mock
    | mgus_diagnosis
    | death_cohort
    | 0
    | 30
    | 1,384
    | 0
    | 0  
    
    | 
    | 
    | 30
    | 30
    | 1,104
    | 285
    | 3  
    
    | 
    | 
    | 60
    | 30
    | 895
    | 182
    | 27  
    
    | 
    | 
    | 90
    | 30
    | 652
    | 167
    | 79  
    
    | 
    | 
    | 120
    | 30
    | 438
    | 131
    | 74  
    
    | 
    | 
    | 150
    | 30
    | 299
    | 86
    | 54  
    
    | 
    | 
    | 180
    | 30
    | 187
    | 57
    | 54  
    
    | 
    | 
    | 210
    | 30
    | 109
    | 20
    | 58  
    
    | 
    | 
    | 240
    | 30
    | 61
    | 15
    | 33  
    
    | 
    | 
    | 270
    | 30
    | 31
    | 11
    | 18  
    
    | 
    | 
    | 300
    | 30
    | 16
    | 4
    | 10  
    
    | 
    | 
    | 330
    | 30
    | 7
    | 3
    | 6  
    
    | 
    | 
    | 360
    | 30
    | 3
    | 1
    | 3  
    
    | 
    | 
    | 390
    | 30
    | 2
    | 0
    | 1  
    
    | 
    | 
    | 420
    | 30
    | 1
    | 0
    | 1  
    
    | 
    | 
    | 424
    | 30
    | 1
    | 1
    | 0  
      
    # }
    

## On this page

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
