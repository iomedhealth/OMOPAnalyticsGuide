# Creating drug cohorts • DrugUtilisation

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

# Creating drug cohorts

Source: [`vignettes/create_cohorts.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/create_cohorts.Rmd)

`create_cohorts.Rmd`

## Introduction

In this vignette we will introduce how to create a drug users cohorts. A cohort is a set of people that satisfy a certain inclusion criteria during a certain time frame. The cohort object is defined in : `[vignette("cdm_reference", package = "omopgenerics")](https://darwin-eu.github.io/omopgenerics/articles/cdm_reference.html)`.

The function `generateDrugUtilisationCohortSet` is used to generate cohorts of drug users based on the `drug_exposure` table and a conceptSet.

These cohorts can be subsetted to the exposures of interest applying the different inclusion criteria:

  * Require that entries are in a certain date range `[requireDrugInDateRange()](../reference/requireDrugInDateRange.html)`.

  * Subset to the first entry `[requireIsFirstDrugEntry()](../reference/requireIsFirstDrugEntry.html)`.

  * Require a certain time in observation before the entries `[requireObservationBeforeDrug()](../reference/requireObservationBeforeDrug.html)`.

  * Require a certain time before exposure `[requirePriorDrugWashout()](../reference/requirePriorDrugWashout.html)`.




## Creating a `cdm_reference` object

The first thing that we need is a `cdm_reference` object to our OMOP CDM instance. You can learn how to create cdm references using CDMConnector here: `[vignette("a04_DBI_connection_examples", package = "CDMConnector")](https://darwin-eu.github.io/CDMConnector/articles/a04_DBI_connection_examples.html)`.

The DrugUtilisation packages contains some mock data that can be useful to test the package:
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividuals = 100, seed = 1)
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of DUS MOCK ───────────────────────────────────
    #> • omop tables: person, observation_period, concept, concept_ancestor,
    #> drug_strength, concept_relationship, drug_exposure, condition_occurrence,
    #> observation, visit_occurrence
    #> • cohort tables: cohort1, cohort2
    #> • achilles tables: -
    #> • other tables: -

## Create a drug users cohort

To create a basic drug users cohort we need two things:

  * A conceptSet: will determine which concepts we will use.
  * A gapEra: will determine how we will collapse those exposures.



### Creating a conceptSet

There are three possible forms of a conceptSet:

  * A named list of concept ids


    
    
    conceptSet <- [list](https://rdrr.io/r/base/list.html)(acetaminophen = [c](https://rdrr.io/r/base/c.html)(1, 2, 3))
    conceptSet
    #> $acetaminophen
    #> [1] 1 2 3

  * A `codelist` object, see `[vignette("codelists", package = "omopgenerics")](https://darwin-eu.github.io/omopgenerics/articles/codelists.html)`


    
    
    conceptSet <- [list](https://rdrr.io/r/base/list.html)(acetaminophen = [c](https://rdrr.io/r/base/c.html)(1, 2, 3)) |> omopgenerics::[newCodelist](https://darwin-eu.github.io/omopgenerics/reference/newCodelist.html)()
    #> Warning: ! `codelist` casted to integers.
    conceptSet
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (3 codes)
    conceptSet$acetaminophen
    #> [1] 1 2 3

  * A `conceptSetExpression` object, see `[vignette("codelists", package = "omopgenerics")](https://darwin-eu.github.io/omopgenerics/articles/codelists.html)`


    
    
    conceptSet <- [list](https://rdrr.io/r/base/list.html)(acetaminophen = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = 1125315,
      excluded = FALSE,
      descendants = TRUE,
      mapped = FALSE
    )) |>
      omopgenerics::[newConceptSetExpression](https://darwin-eu.github.io/omopgenerics/reference/newConceptSetExpression.html)()
    conceptSet
    #> 
    #> ── 1 conceptSetExpression ──────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (1 concept criteria)
    conceptSet$acetaminophen
    #> # A tibble: 1 × 4
    #>   concept_id excluded descendants mapped
    #>        <int> <lgl>    <lgl>       <lgl> 
    #> 1    1125315 FALSE    TRUE        FALSE

The package [CodelistGenerator](https://cran.r-project.org/package=CodelistGenerator) can be very useful to create conceptSet.
    
    
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))

For example we can create a conceptSet based in an ingredient with `[getDrugIngredientCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)`:
    
    
    codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    codes[["161_acetaminophen"]]
    #> [1]  1125315  1125360  2905077 43135274

We could also use the function `[codesFromConceptSet()](https://darwin-eu.github.io/CodelistGenerator/reference/codesFromConceptSet.html)` to read a concept set from a json file:
    
    
    codes <- [codesFromConceptSet](https://darwin-eu.github.io/CodelistGenerator/reference/codesFromConceptSet.html)(path = [system.file](https://rdrr.io/r/base/system.file.html)("acetaminophen.json", package = "DrugUtilisation"), cdm = cdm)
    codes
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (4 codes)

### The gapEra parameter

The `gapEra` parameter is used to join exposures into episodes, let’s say for example we have an individual with 4 drug exposures that we are interested in. The first two overlap each other, then there is a gap of 29 days and two consecutive exposures:

![](create_cohorts_files/figure-html/unnamed-chunk-9-1.png)

If we would create the episode with **gapEra = 0** , we would have 3 resultant episodes, the first two that overlap would be joined in a single episode, but then the other two would be independent:
    
    
    #> # A tibble: 3 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-02-15     
    #> 2                    1          1 2020-03-15        2020-04-19     
    #> 3                    1          1 2020-04-20        2020-05-15

![](create_cohorts_files/figure-html/unnamed-chunk-10-1.png)

If, instead we would use a **gapEra = 1** , we would have 2 resultant episodes, the first two that overlap would be joined in a single episode (as before), now the two consecutive exposures would be joined in a single episode:
    
    
    #> # A tibble: 2 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-02-15     
    #> 2                    1          1 2020-03-15        2020-05-15

![](create_cohorts_files/figure-html/unnamed-chunk-11-1.png)

The result would be the same for any value between 1 and 28 (**gapEra ∈\in [1, 28]**).

Whereas, if we would use a **gapEra = 29** all the records would be collapsed into a single episode:
    
    
    #> # A tibble: 1 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-05-15

![](create_cohorts_files/figure-html/unnamed-chunk-12-1.png)

### Create your cohort

We will then create now a cohort with all the drug users of acetaminophen with a gapEra of 30 days.
    
    
    codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    [names](https://rdrr.io/r/base/names.html)(codes) <- "acetaminophen"
    cdm <- [generateDrugUtilisationCohortSet](../reference/generateDrugUtilisationCohortSet.html)(cdm = cdm, name = "acetaminophen_cohort", conceptSet = codes, gapEra = 30)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 30 days.
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of DUS MOCK ───────────────────────────────────
    #> • omop tables: person, observation_period, concept, concept_ancestor,
    #> drug_strength, concept_relationship, drug_exposure, condition_occurrence,
    #> observation, visit_occurrence
    #> • cohort tables: cohort1, cohort2, acetaminophen_cohort
    #> • achilles tables: -
    #> • other tables: -

NOTE that the `name` argument is used to create the new table in the cdm object. For database backends this is the name of the table that will be created.

We can compare what we see with what we would expect; if we look at the individual with more records we can see how all of them are joined into a single exposure as the records overlap each other:
    
    
    cdm$drug_exposure |>
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(drug_concept_id [%in%](https://rdrr.io/r/base/match.html) !!codes$acetaminophen & person_id == 69)
    #> # Source:   SQL [?? x 23]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>   drug_exposure_id person_id drug_concept_id drug_exposure_start_date
    #>              <int>     <int>           <int> <date>                  
    #> 1              201        69         2905077 2002-01-29              
    #> 2              203        69         2905077 2001-04-23              
    #> 3              204        69        43135274 2003-10-16              
    #> 4              205        69         2905077 2001-03-04              
    #> # ℹ 19 more variables: drug_exposure_end_date <date>,
    #> #   drug_type_concept_id <int>, quantity <dbl>,
    #> #   drug_exposure_start_datetime <date>, drug_exposure_end_datetime <date>,
    #> #   verbatim_end_date <date>, stop_reason <chr>, refills <int>,
    #> #   days_supply <int>, sig <chr>, route_concept_id <int>, lot_number <chr>,
    #> #   provider_id <int>, visit_occurrence_id <int>, visit_detail_id <int>,
    #> #   drug_source_value <chr>, drug_source_concept_id <int>, …
    
    
    cdm$acetaminophen_cohort |>
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 69)
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1         69 2001-03-04        2004-06-02

In this case gapEra did not have a big impact as we can see in the attrition:
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             71              62         1 Initial qualify…
    #> 2                    1             70              62         2 Collapse record…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

We can see this particular case of this individual:
    
    
    cdm$drug_exposure |>
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(drug_concept_id [%in%](https://rdrr.io/r/base/match.html) !!codes$acetaminophen & person_id == 50)
    #> # Source:   SQL [?? x 23]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>   drug_exposure_id person_id drug_concept_id drug_exposure_start_date
    #>              <int>     <int>           <int> <date>                  
    #> 1              143        50         1125360 2017-04-14              
    #> 2              144        50        43135274 2017-04-01              
    #> # ℹ 19 more variables: drug_exposure_end_date <date>,
    #> #   drug_type_concept_id <int>, quantity <dbl>,
    #> #   drug_exposure_start_datetime <date>, drug_exposure_end_datetime <date>,
    #> #   verbatim_end_date <date>, stop_reason <chr>, refills <int>,
    #> #   days_supply <int>, sig <chr>, route_concept_id <int>, lot_number <chr>,
    #> #   provider_id <int>, visit_occurrence_id <int>, visit_detail_id <int>,
    #> #   drug_source_value <chr>, drug_source_concept_id <int>, …

In this case we have 3 exposures separated by 3 days, so if we use the 30 days gap both exposures are joined into a single episode, whereas if we would use a gapEra smaller than 3 we would consider them as different episodes.
    
    
    cdm$acetaminophen_cohort |>
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 50)
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1         50 2017-04-01        2017-04-23

We can access the other cohort attributes using the adequate functions. In settings we can see that the gapEra used is recorded or with cohortCodelist we can see which was the codelist used to create the cohort.
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id cohort_name   gap_era
    #>                  <int> <chr>         <chr>  
    #> 1                    1 acetaminophen 30
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             70              62
    [cohortCodelist](https://darwin-eu.github.io/omopgenerics/reference/cohortCodelist.html)(cdm$acetaminophen_cohort, cohortId = 1)
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (4 codes)

### Analogous functions

The function `[generateDrugUtilisationCohortSet()](../reference/generateDrugUtilisationCohortSet.html)` has two analogous functions:

  * `[generateAtcCohortSet()](../reference/generateAtcCohortSet.html)` to generate cohorts using ATC labels.
  * `[generateIngredientCohortSet()](../reference/generateIngredientCohortSet.html)` to generate cohorts using ingredients names.



Both functions allow to create cohorts and have all the same arguments than `[generateDrugUtilisationCohortSet()](../reference/generateDrugUtilisationCohortSet.html)` the main difference is that instead of the `conceptSet` argument we have the `atcName` argument and the `ingredient` argument. Also both functions have the `...` argument that is used by `[CodelistGenerator::getATCCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getATCCodes.html)` and `[CodelistGenerator::getDrugIngredientCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)` respectively.

Let’s see two simple examples, we can generate the ‘alimentary tract and metabolism’ (ATC code) cohort with:
    
    
    cdm <- [generateAtcCohortSet](../reference/generateAtcCohortSet.html)(
      cdm = cdm,
      atcName = "alimentary tract and metabolism",
      name = "atc_cohort"
    )
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> Warning: cohort_name must be snake case and have less than 100 characters, the following
    #> cohorts will be renamed:
    #> • alimentary tract and metabolism -> alimentary_tract_and_metabolism
    #> ℹ Collapsing records with gapEra = 1 days.
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$atc_cohort)
    #> # A tibble: 1 × 8
    #>   cohort_definition_id cohort_name             gap_era level dose_form dose_unit
    #>                  <int> <chr>                   <chr>   <chr> <chr>     <chr>    
    #> 1                    1 alimentary_tract_and_m… 1       ATC … ""        ""       
    #> # ℹ 2 more variables: route_category <chr>, atc_name <chr>

And the ‘simvastatin’ and ‘metformin’ cohorts, restricting to products with only one ingredient:
    
    
    cdm <- [generateIngredientCohortSet](../reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      ingredient = [c](https://rdrr.io/r/base/c.html)('simvastatin', 'metformin'),
      name = "ingredient_cohort",
      ingredientRange = [c](https://rdrr.io/r/base/c.html)(1, 1)
    )
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$ingredient_cohort)
    #> # A tibble: 2 × 8
    #>   cohort_definition_id cohort_name gap_era dose_form dose_unit route_category
    #>                  <int> <chr>       <chr>   <chr>     <chr>     <chr>         
    #> 1                    1 metformin   1       ""        ""        ""            
    #> 2                    2 simvastatin 1       ""        ""        ""            
    #> # ℹ 2 more variables: ingredient_range <chr>, ingredient_name <chr>

## Apply inclusion criteria to drug cohorts

Once we have created our base cohort using a conceptSet and a gapEra we can apply different restrictions:

  * require a prior unexposed time: `[requirePriorDrugWashout()](../reference/requirePriorDrugWashout.html)`
  * require that it is the first entry: `[requireIsFirstDrugEntry()](../reference/requireIsFirstDrugEntry.html)`
  * require a prior observation in the cdm: `[requireObservationBeforeDrug()](../reference/requireObservationBeforeDrug.html)`
  * require that date are within a certain interval: `[requireDrugInDateRange()](../reference/requireDrugInDateRange.html)`



###  `requirePriorDrugWashout()`

To require that the cohort entries (drug episodes) are incident we would usually define a time (`days`) where the individual is not exposed to the drug. This can be achieved using `[requirePriorDrugWashout()](../reference/requirePriorDrugWashout.html)` function. In this example we would restrict to individuals with 365 days of no exposure:
    
    
    cdm$acetaminophen_cohort <- cdm$acetaminophen_cohort |>
      [requirePriorDrugWashout](../reference/requirePriorDrugWashout.html)(days = 365)

The result will be a cohort with the individuals that fulfill the criteria:
    
    
    cdm$acetaminophen_cohort
    #> # Source:   table<acetaminophen_cohort> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          9 2016-03-17        2016-09-02     
    #>  2                    1         42 2002-09-15        2007-12-19     
    #>  3                    1         77 1966-09-15        1966-12-27     
    #>  4                    1         33 2021-02-12        2021-02-14     
    #>  5                    1         23 2003-10-29        2003-11-27     
    #>  6                    1         14 1990-04-27        1990-05-12     
    #>  7                    1         47 1963-12-22        1965-09-16     
    #>  8                    1         57 2020-04-17        2020-11-19     
    #>  9                    1         39 2022-02-09        2022-06-11     
    #> 10                    1         98 2020-03-14        2020-08-14     
    #> # ℹ more rows

This would also get recorded in the attrition, counts and settings.

In the settings a new column with the specified parameter used:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id cohort_name   gap_era prior_use_washout
    #>                  <int> <chr>         <chr>   <chr>            
    #> 1                    1 acetaminophen 30      365

The counts will be updated:
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             66              62

And the attrition will have a new line:
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 3 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             71              62         1 Initial qualify…
    #> 2                    1             70              62         2 Collapse record…
    #> 3                    1             66              62         3 require prior u…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

The `name` argument can be used to put the result into a different table in our cdm (by default the function updates the current cohort table). Whereas the `cohortId` argument is used to apply this criteria to only a restricted set of cohorts (by default the same criteria is applied to all the cohort records). To show this in an example we will create two cohorts (metformin and simvastatin) inside a table named `my_cohort` and then apply the inclusion criteria to only one of them (simvastatin) and save the result to a table named: `my_new_cohort`
    
    
    codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = [c](https://rdrr.io/r/base/c.html)("metformin", "simvastatin"))
    cdm <- [generateDrugUtilisationCohortSet](../reference/generateDrugUtilisationCohortSet.html)(cdm = cdm, name = "my_cohort", conceptSet = codes, gapEra = 30)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 30 days.
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of DUS MOCK ───────────────────────────────────
    #> • omop tables: person, observation_period, concept, concept_ancestor,
    #> drug_strength, concept_relationship, drug_exposure, condition_occurrence,
    #> observation, visit_occurrence
    #> • cohort tables: cohort1, cohort2, acetaminophen_cohort, atc_cohort,
    #> ingredient_cohort, my_cohort
    #> • achilles tables: -
    #> • other tables: -
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$my_cohort)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id cohort_name       gap_era
    #>                  <int> <chr>             <chr>  
    #> 1                    1 36567_simvastatin 30     
    #> 2                    2 6809_metformin    30
    cdm$my_new_cohort <- cdm$my_cohort |>
      [requirePriorDrugWashout](../reference/requirePriorDrugWashout.html)(days = 365, cohortId = 2, name = "my_new_cohort")
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of DUS MOCK ───────────────────────────────────
    #> • omop tables: person, observation_period, concept, concept_ancestor,
    #> drug_strength, concept_relationship, drug_exposure, condition_occurrence,
    #> observation, visit_occurrence
    #> • cohort tables: cohort1, cohort2, acetaminophen_cohort, atc_cohort,
    #> ingredient_cohort, my_cohort, my_new_cohort
    #> • achilles tables: -
    #> • other tables: -
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$my_new_cohort)
    #> # A tibble: 5 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             53              48         1 Initial qualify…
    #> 2                    1             51              48         2 Collapse record…
    #> 3                    2             55              48         1 Initial qualify…
    #> 4                    2             52              48         2 Collapse record…
    #> 5                    2             51              48         3 require prior u…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

###  `requireIsFirstDrugEntry()`

To require that the cohort entry (drug episodes) is the first one of the available ones we can use the `[requireIsFirstDrugEntry()](../reference/requireIsFirstDrugEntry.html)` function. See example:
    
    
    cdm$acetaminophen_cohort <- cdm$acetaminophen_cohort |>
      [requireIsFirstDrugEntry](../reference/requireIsFirstDrugEntry.html)()

The result will be a cohort with the individuals that fulfill the criteria:
    
    
    cdm$acetaminophen_cohort
    #> # Source:   table<acetaminophen_cohort> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         14 1990-04-27        1990-05-12     
    #>  2                    1         23 2003-10-29        2003-11-27     
    #>  3                    1         25 2020-01-04        2020-02-05     
    #>  4                    1         48 1972-04-14        1972-12-18     
    #>  5                    1         69 2001-03-04        2004-06-02     
    #>  6                    1         74 1973-02-24        1974-05-06     
    #>  7                    1         81 1995-09-13        1997-11-17     
    #>  8                    1         93 2014-01-09        2016-06-21     
    #>  9                    1         42 2002-09-15        2007-12-19     
    #> 10                    1         39 2022-02-09        2022-06-11     
    #> # ℹ more rows

This would also get recorded in the attrition, counts and settings on top of the already exiting ones.

In the settings a new column with the specified parameter used:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 5
    #>   cohort_definition_id cohort_name   gap_era prior_use_washout limit      
    #>                  <int> <chr>         <chr>   <chr>             <chr>      
    #> 1                    1 acetaminophen 30      365               first_entry

The counts will be updated:
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             62              62

And the attrition will have a new line:
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 4 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             71              62         1 Initial qualify…
    #> 2                    1             70              62         2 Collapse record…
    #> 3                    1             66              62         3 require prior u…
    #> 4                    1             62              62         4 require is the …
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

###  `requireObservationBeforeDrug()`

To require that a cohort entry (drug episodes) has a certain time of prior observation we can use the `[requireObservationBeforeDrug()](../reference/requireObservationBeforeDrug.html)` function. See example:
    
    
    cdm$acetaminophen_cohort <- cdm$acetaminophen_cohort |>
      [requireObservationBeforeDrug](../reference/requireObservationBeforeDrug.html)(days = 365)

The result will be a cohort with the individuals that fulfill the criteria:
    
    
    cdm$acetaminophen_cohort
    #> # Source:   table<acetaminophen_cohort> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          3 1996-09-13        2008-07-15     
    #>  2                    1          7 1969-09-09        1970-02-14     
    #>  3                    1          8 2019-09-14        2020-12-31     
    #>  4                    1         14 1990-04-27        1990-05-12     
    #>  5                    1         17 2000-08-24        2003-02-19     
    #>  6                    1         23 2003-10-29        2003-11-27     
    #>  7                    1         26 2015-07-22        2020-07-18     
    #>  8                    1         29 2020-12-08        2021-01-09     
    #>  9                    1         35 2005-11-10        2006-09-09     
    #> 10                    1         36 2018-06-17        2018-10-24     
    #> # ℹ more rows

This would also get recorded in the attrition, counts and settings on top of the already exiting ones.

In the settings a new column with the specified parameter used:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 6
    #>   cohort_definition_id cohort_name   gap_era prior_use_washout limit      
    #>                  <int> <chr>         <chr>   <chr>             <chr>      
    #> 1                    1 acetaminophen 30      365               first_entry
    #> # ℹ 1 more variable: prior_drug_observation <chr>

The counts will be updated:
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             33              33

And the attrition will have a new line:
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 5 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             71              62         1 Initial qualify…
    #> 2                    1             70              62         2 Collapse record…
    #> 3                    1             66              62         3 require prior u…
    #> 4                    1             62              62         4 require is the …
    #> 5                    1             33              33         5 require prior o…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

###  `requireDrugInDateRange()`

To require that a cohort entry (drug episodes) has a certain date within an specific range we can use the `[requireDrugInDateRange()](../reference/requireDrugInDateRange.html)` function. In general you would like to apply this restriction to the incident date (cohort_start_date), but the function is flexible and you can use it to restrict to any other date. See example:
    
    
    cdm$acetaminophen_cohort <- cdm$acetaminophen_cohort |>
      [requireDrugInDateRange](../reference/requireDrugInDateRange.html)(
        indexDate = "cohort_start_date",
        dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-01-01", "2020-12-31"))
      )

The result will be a cohort with the individuals that fulfill the criteria:
    
    
    cdm$acetaminophen_cohort
    #> # Source:   table<acetaminophen_cohort> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          8 2019-09-14        2020-12-31     
    #>  2                    1         17 2000-08-24        2003-02-19     
    #>  3                    1         23 2003-10-29        2003-11-27     
    #>  4                    1         26 2015-07-22        2020-07-18     
    #>  5                    1         29 2020-12-08        2021-01-09     
    #>  6                    1         35 2005-11-10        2006-09-09     
    #>  7                    1         36 2018-06-17        2018-10-24     
    #>  8                    1         40 2018-11-15        2020-03-07     
    #>  9                    1         42 2002-09-15        2007-12-19     
    #> 10                    1         44 2017-01-01        2018-03-30     
    #> # ℹ more rows

This would also get recorded in the attrition, counts and settings on top of the already exiting ones.

In the settings a new column with the specified parameter used:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 6
    #>   cohort_definition_id cohort_name   gap_era prior_use_washout limit      
    #>                  <int> <chr>         <chr>   <chr>             <chr>      
    #> 1                    1 acetaminophen 30      365               first_entry
    #> # ℹ 1 more variable: prior_drug_observation <chr>

The counts will be updated:
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             24              24

And the attrition will have a new line:
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$acetaminophen_cohort)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             71              62         1 Initial qualify…
    #> 2                    1             70              62         2 Collapse record…
    #> 3                    1             66              62         3 require prior u…
    #> 4                    1             62              62         4 require is the …
    #> 5                    1             33              33         5 require prior o…
    #> 6                    1             24              24         6 require cohort_…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

If you just want to restrict on the lower or upper bound you can just leave the other element as NA and then no condition will be applied, see for example:
    
    
    cdm$my_new_cohort <- cdm$my_new_cohort |>
      [requireDrugInDateRange](../reference/requireDrugInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, "2010-12-31")))
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$my_new_cohort)
    #> # A tibble: 7 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             53              48         1 Initial qualify…
    #> 2                    1             51              48         2 Collapse record…
    #> 3                    1             18              18         3 require cohort_…
    #> 4                    2             55              48         1 Initial qualify…
    #> 5                    2             52              48         2 Collapse record…
    #> 6                    2             51              48         3 require prior u…
    #> 7                    2             23              21         4 require cohort_…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

## The order matters

It is very important to know that the different restrictions are not commutable operations and that different order can lead to different results. Let’s see the following example where we have an individual with 4 cohort entries:

![](create_cohorts_files/figure-html/unnamed-chunk-44-1.png)

In this case we will see the result of combining in different ways 4 inclusion criteria:

  * **first** : `[requireIsFirstDrugEntry()](../reference/requireIsFirstDrugEntry.html)`
  * **washout** : `requirePriorDrugWashout(days = 365)`
  * **minObs** : `requireObservationBeforeDrug(days = 365)`
  * **2011-2012** `requireDrugInDateRange(dateRange = as.Date(c("2011-01-01", "2012-12-31)))`



### first and washout

If we would apply the initially the **first** requirement and then the **washout** one we would end with only the first record:

![](create_cohorts_files/figure-html/unnamed-chunk-45-1.png)

Whereas if we would apply initially the **washout** criteria and then the **first** one the resulting exposure would be the fourth one:

![](create_cohorts_files/figure-html/unnamed-chunk-46-1.png)

### first and minObs

If we would apply the initially the **first** requirement and then the **minObs** one we would end with no record in the cohort:

![](create_cohorts_files/figure-html/unnamed-chunk-47-1.png)

Whereas if we would apply initially the **minObs** criteria and then the **first** one there would be an exposure selected, the second one:

![](create_cohorts_files/figure-html/unnamed-chunk-48-1.png)

### first and 2011-2012

If we would apply the initially the **first** requirement and then the **2011-2012** one we would end with no record in the cohort:

![](create_cohorts_files/figure-html/unnamed-chunk-49-1.png)

Whereas if we would apply initially the **2011-2012** criteria and then the **first** one there would be an exposure selected, the second one:

![](create_cohorts_files/figure-html/unnamed-chunk-50-1.png)

### washout and minObs

If we would apply the initially the **washout** requirement and then the **minObs** one we would end with only the last record selected:

![](create_cohorts_files/figure-html/unnamed-chunk-51-1.png)

Whereas if we would apply initially the **minObs** criteria and then the **washout** one the second and the fourth exposures are the ones that would be selected:

![](create_cohorts_files/figure-html/unnamed-chunk-52-1.png)

### washout and 2011-2012

If we would apply initially the **washout** requirement and then the **2011-2012** one no record would be selected:

![](create_cohorts_files/figure-html/unnamed-chunk-53-1.png)

Whereas if we would apply initially the **2011-2012** criteria and then the **washout** one the second record would be included:

![](create_cohorts_files/figure-html/unnamed-chunk-54-1.png)

### minObs and 2011-2012

Finally `requireObservationBeforeDrug` and `requireDrugInDateRange` will always be commutable operations so the other of this two will always be the same.

### Recommended order

Having all this into account the recommended order to apply criteria would be:

  1. Require a prior drug washout or require first drug entry (particular case).

  2. Require a prior observation before the drug episode.

  3. Require the drugs to be in a certain date range.




Although this is the recommended order, your study design may have a different required specification, for example you may be interested on the first exposure that fulfills some criteria. Thus making applying the require first drug entry at the end.

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
