# Summarising treatment adherence • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# Summarising treatment adherence

Source: [`vignettes/treatment_discontinuation.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/treatment_discontinuation.Rmd)

`treatment_discontinuation.Rmd`

## Introduction

In this vignette we will go through two common approaches for assessing treatment adherence that can be performed after creating drug cohorts. The first approach is to assess time-to-discontinuation using survival methods, while the second is to estimate the proportion of patients covered.

## Adherence to amoxicillin

For example, let’s say we would like to study adherence among new users of amoxicillin over the first 90-days of use. For this we can first create our amoxicillin study cohort. Here we’ll use the synthetic Eunomia dataset to show how this could be done.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    db <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = db,
      cdmSchema = "main",
      writeSchema = "main",
      cdmName = "Eunomia"
    )
    
    cdm <- [generateIngredientCohortSet](../reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      name = "amoxicillin",
      ingredient = "amoxicillin",
      gapEra = 7
    )

### Time-to-discontinuation

We can estimate Kaplan-Meier survival curves we can use estimateSingleEventSurvival from the CohortSurvival package, with the follow-up beginning from an individual’s cohort start date and discontinuation occurring at their cohort end date. As the outcome washout is set to Inf we’ll only be considering the first cohort entry for an individual. It is important to note that because the survival analysis is focused on a single cohort entry, with the cohort end date taken to indicate treatment discontinuation, the gap era used above when creating the drug cohort can often have an important impact on the results.
    
    
    discontinuationSummary <- CohortSurvival::[estimateSingleEventSurvival](https://darwin-eu.github.io/CohortSurvival/reference/estimateSingleEventSurvival.html)(
      cdm = cdm,
      targetCohortTable = "amoxicillin",
      outcomeCohortTable = "amoxicillin",
      outcomeDateVariable = "cohort_end_date",
      outcomeWashout = Inf,
      followUpDays = 90,
      eventGap = 30
    )

We can plot our study result like so:
    
    
    #CohortSurvival::plotSurvival(discontinuationSummary)

Or we can similarly create a table summarising the result
    
    
    #CohortSurvival::tableSurvival(discontinuationSummary)

We can also easily stratify our results. Here we add patient demographics to our cohort table using the PatientProfiles packages and then stratify results by age group and sex.
    
    
    cdm$amoxicillin <- cdm$amoxicillin |>
      PatientProfiles::[addDemographics](https://darwin-eu.github.io/PatientProfiles/reference/addDemographics.html)(
        ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 40), [c](https://rdrr.io/r/base/c.html)(41, Inf)), name = "amoxicillin"
      )
    
    discontinuationSummary <- CohortSurvival::[estimateSingleEventSurvival](https://darwin-eu.github.io/CohortSurvival/reference/estimateSingleEventSurvival.html)(
      cdm = cdm,
      strata = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)("age_group"), [c](https://rdrr.io/r/base/c.html)("sex")),
      targetCohortTable = "amoxicillin",
      outcomeCohortTable = "amoxicillin",
      outcomeDateVariable = "cohort_end_date",
      followUpDays = 90,
      eventGap = 30
    )

Again we could present our results in a plot or a table.
    
    
    #CohortSurvival::plotSurvival(discontinuationSummary, facet = "strata_level")
    
    
    #CohortSurvival::tableSurvival(discontinuationSummary)

### Proportion of patients covered

Estimating the proportion of amoxicillin patients covered offers an alternative approach for describing treatment adherence. Here for each day following initiation (taken as the first cohort entry for an individual) we estimate the proportion of patients that have an ongoing cohort entry among those who are still in observation at that time. Unlike with the time-to-discontinuation approach shown above, estimating proportion of patients covered allows for individuals to have re-initiate the drug after some break. Consequently this method is typically far less sensitive to the choice of gap era used when creating the drug cohort.
    
    
    ppcSummary <- cdm$amoxicillin |>
      [summariseProportionOfPatientsCovered](../reference/summariseProportionOfPatientsCovered.html)(followUpDays = 90)

Like with our survival estimates, we can quickly create a plot of our results
    
    
    [plotProportionOfPatientsCovered](../reference/plotProportionOfPatientsCovered.html)(ppcSummary)

![](treatment_discontinuation_files/figure-html/unnamed-chunk-10-1.png)

Similarly, we can also stratify our results in a similar way.
    
    
    ppcSummary <- cdm$amoxicillin |>
      [summariseProportionOfPatientsCovered](../reference/summariseProportionOfPatientsCovered.html)(
        strata = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)("age_group"), [c](https://rdrr.io/r/base/c.html)("sex")),
        followUpDays = 90
      )
    
    
    [plotProportionOfPatientsCovered](../reference/plotProportionOfPatientsCovered.html)(ppcSummary, facet = [c](https://rdrr.io/r/base/c.html)("sex", "age_group"))

![](treatment_discontinuation_files/figure-html/unnamed-chunk-12-1.png)

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
