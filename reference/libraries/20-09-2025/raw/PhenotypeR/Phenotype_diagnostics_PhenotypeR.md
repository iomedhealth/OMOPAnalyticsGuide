# Phenotype diagnostics • PhenotypeR

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Phenotype diagnostics

`a01_PhenotypeDiagnostics.Rmd`

## Introduction: Run PhenotypeDiagnostics

In this vignette, we are going to present how to run `PhenotypeDiagnostics()`. We are going to use the following packages and mock data:
    
    
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    cdm

Note that we have included [achilles tables](https://github.com/OHDSI/Achilles) in our cdm reference, which will be used to speed up some of the analyses.

## Create a cohort

First, we are going to use the package [CohortConstructor](https://ohdsi.github.io/CohortConstructor/) to generate three cohorts of _warfarin_ , _acetaminophen_ and _morphine_ users.
    
    
    # Create a codelist
    codes <- [list](https://rdrr.io/r/base/list.html)("warfarin" = [c](https://rdrr.io/r/base/c.html)(1310149, 40163554),
                  "acetaminophen" = [c](https://rdrr.io/r/base/c.html)(1125315, 1127078, 1127433, 40229134, 40231925, 40162522, 19133768),
                  "morphine" = [c](https://rdrr.io/r/base/c.html)(1110410, 35605858, 40169988))
    
    # Instantiate cohorts with CohortConstructor
    cdm$my_cohort <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
                                   conceptSet = codes, 
                                   exit = "event_end_date",
                                   overlap = "merge",
                                   name = "my_cohort")

## Run PhenotypeDiagnostics

Now we will proceed to run `phenotypeDiagnotics()`. This function will run the following analyses:

  * **Database diagnostics** : This includes information about the size of the data, the time period covered, the number of people in the data, and other meta-data of the CDM object. See [Database diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a03_DatabaseDiagnostics.html) for more details.
  * **Codelist diagnostics** : This includes information on the concepts included in our cohorts’ codelist. See [Codelist diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a04_CodelistDiagnostics.html) for further details.
  * **Cohort diagnostics** : This summarises the characteristics of our cohorts, as well as comparing them to age and sex matched controls from the database.. See [Cohort diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a05_CohortDiagnostics.html) for further details.
  * **Population diagnostics** : Calculates the frequency of our study cohorts in the database in terms of their incidence rates and prevalence. See [Population diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a07_PopulationDiagnostics.html) for further details.



We can specify which analysis we want to perform by setting to TRUE or FALSE each one of the corresponding arguments:
    
    
    result <- phenotypeDiagnostics(
      cohort = cdm$my_cohort, 
      databaseDiagnostics = TRUE, 
      codelistDiagnostics = TRUE, 
      cohortDiagnostics   = TRUE, 
      match = TRUE,
      matchedSample = 1000
      populationDiagnostics = TRUE,
      populationSample = 1e+06,
      populationDateRange = as.Date(c(NA, NA))
      )
    result |> glimpse()

Notice that we have three additional arguments:

  * `populationSample`: It allows to specify a number of people that randomly will be extracted from the CDM to perform the **Population diagnostics** analysis. If NULL, all the participants in the CDM will be included. It helps to reduce the computational time. This is particularly useful when outcomes of interest are relatively common, but when they are rarer we may wish to maximise statistical power and calculate estimates for the dataset as a whole in which case we would set this argument to NULL.
  * `populationDateRange`: We can use it to specify the time period when we want to perform our **Population diagnostics** analysis.
  * `match`: If set to TRUE, our study cohorts will be matched with people with similar age and sex in the database, and will perform a large-scale characterisation on our original cohort, the sampled cohort (those participants from our cohort that have found a match) and the matched cohort. If set to FALSE, cohortDiagnostics will only be performed on our original cohorts.
  * `matchedSample`: Similar to populationSample, this arguments subsets a random sample of people from our cohort and performs the matched analysis on this sample. If we have very large cohorts we can use this to save computational time.



## Save the results

To save the results, we can use [exportSummarisedResult](https://darwin-eu.github.io/omopgenerics/reference/exportSummarisedResult.html) function from [omopgenerics](https://darwin-eu.github.io/omopgenerics/index.html) R Package:
    
    
    [exportSummarisedResult](https://darwin-eu.github.io/omopgenerics/reference/exportSummarisedResult.html)(result, directory = here::[here](https://here.r-lib.org/reference/here.html)(), minCellCount = 5)

## Visualisation of the results

Once we get our **Phenotype diagnostics** result, we can use `shinyDiagnostics` to easily create a shiny app and visualise our results:
    
    
    result <- [shinyDiagnostics](../reference/shinyDiagnostics.html)(result,
                               directory = [tempdir](https://rdrr.io/r/base/tempfile.html)(),
                               minCellCount = 5, 
                               open = TRUE)

Notice that we have specified the minimum number of counts (`minCellCount`) for suppression to be shown in the shiny app, and also that we want the shiny to be launched in a new R session (`open`). You can see the shiny app generated for this example in [here](https://dpa-pde-oxford.shinyapps.io/Readme_PhenotypeR/).See [Shiny diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a02_ShinyDiagnostics.html) for a full explanation of the shiny app.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
