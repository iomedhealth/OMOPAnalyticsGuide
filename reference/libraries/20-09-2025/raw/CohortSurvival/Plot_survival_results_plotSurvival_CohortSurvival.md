# Plot survival results — plotSurvival • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Plot survival results

`plotSurvival.Rd`

Plot survival results

## Usage
    
    
    plotSurvival(
      result,
      ribbon = TRUE,
      facet = NULL,
      colour = NULL,
      cumulativeFailure = FALSE,
      riskTable = FALSE,
      riskInterval = 30,
      logLog = FALSE,
      timeScale = "days"
    )

## Arguments

result
    

Survival results

ribbon
    

If TRUE, the plot will join points using a ribbon

facet
    

Variables to use for facets

colour
    

Variables to use for colours

cumulativeFailure
    

whether to plot the cumulative failure probability instead of the survival probability

riskTable
    

Whether to print risk table below the plot

riskInterval
    

Interval of time to print risk table below the plot

logLog
    

If TRUE, the survival probabilities are transformed using the log-log formula

timeScale
    

The scale of time in the x-axis. Can be "days", "months", or "years"

## Value

A plot of survival probabilities over time

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
    plotSurvival(surv)
    ![](plotSurvival-1.png)
    # }
    
    

## On this page

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
