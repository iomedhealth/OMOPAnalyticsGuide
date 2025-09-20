# Phenotype expectations • PhenotypeR

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * ###### Main functionality

    * [PhenotypeDiagnostics](../articles/PhenotypeDiagnostics.html)
    * [PhenotypeExpectations](../articles/PhenotypeExpectations.html)
    * [ShinyDiagnostics](../articles/ShinyDiagnostics.html)
    * * * *

    * ###### Individual functions

    * [DatabaseDiagnostics](../articles/DatabaseDiagnostics.html)
    * [CodelistDiagnostics](../articles/CodelistDiagnostics.html)
    * [CohortDiagnostics](../articles/CohortDiagnostics.html)
    * [PopulationDisgnostics](../articles/PopulationDisgnostics.html)
  * [PhenotypeR shiny App](https://dpa-pde-oxford.shinyapps.io/PhenotypeRShiny/)


  * [](https://github.com/OHDSI/PhenotypeR)



![](../logo.png)

# Phenotype expectations

`phenotypeExpectations.Rmd`

## Comparing phenotype diagnostic results against expectations

We use PhenotypeR to help assess the research readiness of a set of study cohorts. To help make such assessments it can help to have an explicit set of expectations to compare our results. For example, is the age of our study cohort similar to what would be expected? Is the proportion of the cohort that is male vs female similar to what would be expected based on what we know about the phenotype of interest?

### Custom expectations

We can define a set of custom expectations. So that we can visualise these easily using the `[tableCohortExpectations()](../reference/tableCohortExpectations.html)` function, we will create a tibble with the following columns: name (cohort name), estimate (the estimate of interest), value (our expectation on the value we should see in our results). As an example, say we have one cohort called “knee_osteoarthritis” and another called “knee_replacement”. We could create expectations about median age of the cohort and the proportion that is male like so.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    knee_oa <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(cohort_name = "knee_osteoarthritis",
                      estimate = [c](https://rdrr.io/r/base/c.html)("Median age", "Proportion male"),
                      value = [c](https://rdrr.io/r/base/c.html)("60 to 65", "45%"),
                      source = "Clinician")
    knee_replacement <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(cohort_name = "knee_replacement",
                               estimate = [c](https://rdrr.io/r/base/c.html)("Median age", "Proportion male"),
                               value = [c](https://rdrr.io/r/base/c.html)("65 to 70", "50%"),
                               source = "Clinician")
    
    expectations <- [bind_rows](https://dplyr.tidyverse.org/reference/bind_rows.html)(knee_oa, knee_replacement)

Now we have our structured expectaitions, we can quickly create a summary of them. We’ll see in the next vignette how we can then also include them in our shiny app.
    
    
    [tableCohortExpectations](../reference/tableCohortExpectations.html)(expectations)

### LLM based expectations via ellmer

The custom expectations created above might be based on our (or a friendly colleagues’) clinical knowledge. This though will have required access to the requisite clinical knowledge and, especially if we have many cohorts and/ or start considering the many different estimates that are generated, will have been rather time-consuming.

To speed up the process we can use an LLM to help us generate our expectations. We could use this to create a custom set like above. But PhenotypeR also provides the `[getCohortExpectations()](../reference/getCohortExpectations.html)` which will generate a set of expectations using an LLM available via the ellmer R package.

Here for example we’ll use Google Gemini to populate our expectations. Notice that you may need first to create a Gemini API to run the example. You can do that following this link: <https://aistudio.google.com/app/apikey>.

And adding the API in your R environment:
    
    
    usethis::[edit_r_environ](https://usethis.r-lib.org/reference/edit.html)()
    
    # Add your API in your R environment:
    GEMINI_API_KEY = "your API"
    
    # Restrart R
    
    
    [library](https://rdrr.io/r/base/library.html)([ellmer](https://ellmer.tidyverse.org))
    
    chat <- [chat_google_gemini](https://ellmer.tidyverse.org/reference/chat_google_gemini.html)()
    
    [getCohortExpectations](../reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = [c](https://rdrr.io/r/base/c.html)("ankle sprain", "prostate cancer", "morphine")) |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

Instead of passing our cohort names, we could instead pass our results set from `[phenotypeDiagnostics()](../reference/phenotypeDiagnostics.html)` instead. In this case we’ll automatically get expectations for each of the study cohorts in our results.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
        con = con, cdmSchema = "main", writeSchema = "main", cdmName = "Eunomia"
      )
    
    codes <- [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151,
                  "prostate_cancer" = 4163261,
                  "morphine" = [c](https://rdrr.io/r/base/c.html)(1110410L, 35605858L, 40169988L))
    
    cdm$my_cohort <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
                                     conceptSet = codes,
                                     exit = "event_end_date",
                                     name = "my_cohort")
    
    diag_results <- [phenotypeDiagnostics](../reference/phenotypeDiagnostics.html)(cdm$my_cohort)
    
    [getCohortExpectations](../reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = diag_results) |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

It is important to note the importance of a descriptive cohort name. These are the names passed to the LLM and so the more informative the name, the better we can expect the LLM to do.

It should also go without saying that we should not treat the output of the LLM as the unequivocal truth. While LLM expectations may well prove an important starting point, clinical judgement and knowledge of the data source at hand will still be vital in appropriately interpretting our results.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
