# Table with survival summary — tableSurvival • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Table with survival summary

`tableSurvival.Rd`

Table with survival summary

## Usage
    
    
    tableSurvival(
      x,
      times = NULL,
      timeScale = "days",
      header = [c](https://rdrr.io/r/base/c.html)("estimate"),
      type = "gt",
      groupColumn = NULL,
      style = "default",
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

x
    

Result from estimateSingleEventSurvival or estimateCompetingRiskSurvival

times
    

Times at which to report survival in the summary table

timeScale
    

Time unit to report survival in: days, months or years

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

A tibble containing a summary of observed survival in the required units

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
    tableSurvival(surv, times = [c](https://rdrr.io/r/base/c.html)(50,100,365))
    
    
    
    
      CDM name
          | Target cohort
          | Outcome name
          | 
            Estimate name
          
          
    ---|---|---|---  
    Number records
          | Number events
          | Median survival (95% CI)
          | Restricted mean survival (95% CI)
          | 50 days survival estimate
          | 100 days survival estimate
          | 365 days survival estimate
          
    mock
    | mgus_diagnosis
    | death_cohort
    | 1,384
    | 963
    | 98.00 (92.00, 103.00)
    | 133.00 (124.00, 141.00)
    | 69.67 (67.28, 72.13)
    | 48.50 (45.87, 51.29)
    | 6.84 (3.36, 13.92)  
      
    # }
    

## On this page

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
