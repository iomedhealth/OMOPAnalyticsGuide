# Content from https://darwin-eu.github.io/DrugUtilisation/


---

## Content from https://darwin-eu.github.io/DrugUtilisation/

Skip to contents

[DrugUtilisation](index.html) 1.0.4

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](articles/mock_data.html)
    * [Creating drug cohorts](articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](articles/indication.html)
    * [Daily dose calculation](articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](articles/drug_utilisation.html)
    * [Summarise treatments](articles/summarise_treatments.html)
    * [Summarising treatment adherence](articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](articles/drug_restart.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](logo.png)

# DrugUtilisation 

[![CRANstatus](https://www.r-pkg.org/badges/version/DrugUtilisation)](https://CRAN.R-project.org/package=DrugUtilisation) [![codecov.io](https://codecov.io/github/darwin-eu/DrugUtilisation/coverage.svg?branch=main)](https://app.codecov.io/github/darwin-eu/DrugUtilisation?branch=main) [![R-CMD-check](https://github.com/darwin-eu/DrugUtilisation/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/DrugUtilisation/actions) [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

## Package overview

DrugUtilisation contains functions to instantiate and characterise drug cohorts in data mapped to the OMOP Common Data Model. The package supports:

  * Creation of drug cohorts

  * Identification of indications for those in a drug cohort

  * Summarising drug utilisation among a cohort in terms of duration, quantity, and dose

  * Description of treatment adherence based on proportion of patients covered

  * Detailing treatment restart and switching after an initial treatment discontinuation




## Example usage

First, we need to create a cdm reference for the data we´ll be using. Here we generate an example with simulated data, but to see how you would set this up for your database please consult the CDMConnector package [connection examples](https://darwin-eu.github.io/CDMConnector/articles/a04_DBI_connection_examples.html).
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm <- [mockDrugUtilisation](reference/mockDrugUtilisation.html)(numberIndividual = 100)

### Create a cohort of acetaminophen users

To generate the cohort of acetaminophen users we will use `generateIngredientCohortSet`, concatenating any records with fewer than 7 days between them. We then filter our cohort records to only include the first record per person and require that they have at least 30 days observation in the database prior to their drug start date.
    
    
    cdm <- [generateIngredientCohortSet](reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      name = "dus_cohort",
      ingredient = "acetaminophen",
      gapEra = 7
    )
    cdm$dus_cohort |>
      [requireIsFirstDrugEntry](reference/requireIsFirstDrugEntry.html)() |>
      [requireObservationBeforeDrug](reference/requireObservationBeforeDrug.html)(days = 30)
    #> # Source:   table<dus_cohort> [?? x 4]
    #> # Database: DuckDB v1.2.0 [root@Darwin 24.4.0:R 4.4.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         19 2015-03-30        2015-08-24     
    #>  2                    1         24 2004-05-12        2005-10-17     
    #>  3                    1         27 2008-05-25        2010-11-30     
    #>  4                    1          3 2011-10-10        2014-04-19     
    #>  5                    1         47 2009-05-20        2013-10-09     
    #>  6                    1         51 2022-07-23        2022-07-24     
    #>  7                    1         73 2008-11-23        2012-08-16     
    #>  8                    1         31 2003-11-05        2005-03-24     
    #>  9                    1         17 2019-10-26        2020-12-19     
    #> 10                    1         28 1966-11-26        1967-03-31     
    #> # ℹ more rows

### Indications of acetaminophen users

Now we´ve created our cohort we could first summarise the indications of the cohort. These indications will always be cohorts, so we first need to create them. Here we create two indication cohorts, one for headache and the other for influenza.
    
    
    indications <- [list](https://rdrr.io/r/base/list.html)(headache = 378253, influenza = 4266367)
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm,
      conceptSet = indications,
      name = "indications_cohort"
    )

We can summarise the indication results using the `summariseIndication` function:
    
    
    indication_summary <- cdm$dus_cohort |>
      [summariseIndication](reference/summariseIndication.html)(
        indicationCohortName = "indications_cohort",
        unknownIndicationTable = "condition_occurrence",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-30, 0))
      )
    #> ℹ Intersect with indications table (indications_cohort)
    #> ℹ Summarising indications.
    indication_summary |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Indication from 30 days before to the index date", "…
    #> $ variable_level   <chr> "headache", "headache", "influenza", "influenza", "he…
    #> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
    #> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
    #> $ estimate_value   <chr> "9", "16.0714285714286", "7", "12.5", "6", "10.714285…
    #> $ additional_name  <chr> "window_name", "window_name", "window_name", "window_…
    #> $ additional_level <chr> "-30 to 0", "-30 to 0", "-30 to 0", "-30 to 0", "-30 …

### Drug use

We can quickly obtain a summary of drug utilisation among our cohort, with various measures calculated for a provided ingredient concept (in this case the concept for acetaminophen).
    
    
    drug_utilisation_summary <- cdm$dus_cohort |>
      [summariseDrugUtilisation](reference/summariseDrugUtilisation.html)(
        ingredientConceptId = 1125315,
        gapEra = 7
      )
    drug_utilisation_summary |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 72
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "number subjects", "number exposure…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "q25", "median", "q75", "mean", "sd…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "56", "56", "1", "1", "1", "1.21428571428571", "0.494…
    #> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
    #> $ additional_level <chr> "overall", "overall", "ingredient_1125315_descendants…
    [table](https://rdrr.io/r/base/table.html)(drug_utilisation_summary$variable_name)
    #> 
    #>    cumulative dose milligram          cumulative quantity 
    #>                            7                            7 
    #>                 days exposed              days prescribed 
    #>                            7                            7 
    #> initial daily dose milligram    initial exposure duration 
    #>                            7                            7 
    #>             initial quantity                  number eras 
    #>                            7                            7 
    #>             number exposures               number records 
    #>                            7                            1 
    #>              number subjects             time to exposure 
    #>                            1                            7

### Combine and share results

Now we can combine our results and suppress any counts less than 5 so that they are ready to be shared.
    
    
    results <- [bind](https://darwin-eu.github.io/omopgenerics/reference/bind.html)(
      indication_summary,
      drug_utilisation_summary
    ) |>
      [suppress](https://darwin-eu.github.io/omopgenerics/reference/suppress.html)(minCellCount = 5)
    results |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 84
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Indication from 30 days before to the index date", "…
    #> $ variable_level   <chr> "headache", "headache", "influenza", "influenza", "he…
    #> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
    #> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
    #> $ estimate_value   <chr> "9", "16.0714285714286", "7", "12.5", "6", "10.714285…
    #> $ additional_name  <chr> "window_name", "window_name", "window_name", "window_…
    #> $ additional_level <chr> "-30 to 0", "-30 to 0", "-30 to 0", "-30 to 0", "-30 …

## Further analyses

There are many more drug-related analyses that we could have done with this acetaminophen cohort using the DrugUtilisation package. Please see the package website for more details.

## Links

  * [View on CRAN](https://cloud.r-project.org/package=DrugUtilisation)
  * [Browse source code](https://github.com/darwin-eu/DrugUtilisation/)
  * [Report a bug](https://github.com/darwin-eu/DrugUtilisation/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing DrugUtilisation](authors.html#citation)



## Developers

  * Martí Català   
Author, maintainer  [](https://orcid.org/0000-0003-3308-9905)
  * Yuchen Guo   
Author  [](https://orcid.org/0000-0002-0847-4855)
  * Kim Lopez-Guell   
Author  [](https://orcid.org/0000-0002-8462-8668)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * Xihang Chen   
Author  [](https://orcid.org/0009-0001-8112-8959)
  * [More about authors...](authors.html)



Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/index.html

Skip to contents

[DrugUtilisation](index.html) 1.0.4

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](articles/mock_data.html)
    * [Creating drug cohorts](articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](articles/indication.html)
    * [Daily dose calculation](articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](articles/drug_utilisation.html)
    * [Summarise treatments](articles/summarise_treatments.html)
    * [Summarising treatment adherence](articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](articles/drug_restart.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](logo.png)

# DrugUtilisation 

[![CRANstatus](https://www.r-pkg.org/badges/version/DrugUtilisation)](https://CRAN.R-project.org/package=DrugUtilisation) [![codecov.io](https://codecov.io/github/darwin-eu/DrugUtilisation/coverage.svg?branch=main)](https://app.codecov.io/github/darwin-eu/DrugUtilisation?branch=main) [![R-CMD-check](https://github.com/darwin-eu/DrugUtilisation/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/DrugUtilisation/actions) [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

## Package overview

DrugUtilisation contains functions to instantiate and characterise drug cohorts in data mapped to the OMOP Common Data Model. The package supports:

  * Creation of drug cohorts

  * Identification of indications for those in a drug cohort

  * Summarising drug utilisation among a cohort in terms of duration, quantity, and dose

  * Description of treatment adherence based on proportion of patients covered

  * Detailing treatment restart and switching after an initial treatment discontinuation




## Example usage

First, we need to create a cdm reference for the data we´ll be using. Here we generate an example with simulated data, but to see how you would set this up for your database please consult the CDMConnector package [connection examples](https://darwin-eu.github.io/CDMConnector/articles/a04_DBI_connection_examples.html).
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm <- [mockDrugUtilisation](reference/mockDrugUtilisation.html)(numberIndividual = 100)

### Create a cohort of acetaminophen users

To generate the cohort of acetaminophen users we will use `generateIngredientCohortSet`, concatenating any records with fewer than 7 days between them. We then filter our cohort records to only include the first record per person and require that they have at least 30 days observation in the database prior to their drug start date.
    
    
    cdm <- [generateIngredientCohortSet](reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      name = "dus_cohort",
      ingredient = "acetaminophen",
      gapEra = 7
    )
    cdm$dus_cohort |>
      [requireIsFirstDrugEntry](reference/requireIsFirstDrugEntry.html)() |>
      [requireObservationBeforeDrug](reference/requireObservationBeforeDrug.html)(days = 30)
    #> # Source:   table<dus_cohort> [?? x 4]
    #> # Database: DuckDB v1.2.0 [root@Darwin 24.4.0:R 4.4.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         19 2015-03-30        2015-08-24     
    #>  2                    1         24 2004-05-12        2005-10-17     
    #>  3                    1         27 2008-05-25        2010-11-30     
    #>  4                    1          3 2011-10-10        2014-04-19     
    #>  5                    1         47 2009-05-20        2013-10-09     
    #>  6                    1         51 2022-07-23        2022-07-24     
    #>  7                    1         73 2008-11-23        2012-08-16     
    #>  8                    1         31 2003-11-05        2005-03-24     
    #>  9                    1         17 2019-10-26        2020-12-19     
    #> 10                    1         28 1966-11-26        1967-03-31     
    #> # ℹ more rows

### Indications of acetaminophen users

Now we´ve created our cohort we could first summarise the indications of the cohort. These indications will always be cohorts, so we first need to create them. Here we create two indication cohorts, one for headache and the other for influenza.
    
    
    indications <- [list](https://rdrr.io/r/base/list.html)(headache = 378253, influenza = 4266367)
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm,
      conceptSet = indications,
      name = "indications_cohort"
    )

We can summarise the indication results using the `summariseIndication` function:
    
    
    indication_summary <- cdm$dus_cohort |>
      [summariseIndication](reference/summariseIndication.html)(
        indicationCohortName = "indications_cohort",
        unknownIndicationTable = "condition_occurrence",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-30, 0))
      )
    #> ℹ Intersect with indications table (indications_cohort)
    #> ℹ Summarising indications.
    indication_summary |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Indication from 30 days before to the index date", "…
    #> $ variable_level   <chr> "headache", "headache", "influenza", "influenza", "he…
    #> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
    #> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
    #> $ estimate_value   <chr> "9", "16.0714285714286", "7", "12.5", "6", "10.714285…
    #> $ additional_name  <chr> "window_name", "window_name", "window_name", "window_…
    #> $ additional_level <chr> "-30 to 0", "-30 to 0", "-30 to 0", "-30 to 0", "-30 …

### Drug use

We can quickly obtain a summary of drug utilisation among our cohort, with various measures calculated for a provided ingredient concept (in this case the concept for acetaminophen).
    
    
    drug_utilisation_summary <- cdm$dus_cohort |>
      [summariseDrugUtilisation](reference/summariseDrugUtilisation.html)(
        ingredientConceptId = 1125315,
        gapEra = 7
      )
    drug_utilisation_summary |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 72
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "number subjects", "number exposure…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "q25", "median", "q75", "mean", "sd…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "56", "56", "1", "1", "1", "1.21428571428571", "0.494…
    #> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
    #> $ additional_level <chr> "overall", "overall", "ingredient_1125315_descendants…
    [table](https://rdrr.io/r/base/table.html)(drug_utilisation_summary$variable_name)
    #> 
    #>    cumulative dose milligram          cumulative quantity 
    #>                            7                            7 
    #>                 days exposed              days prescribed 
    #>                            7                            7 
    #> initial daily dose milligram    initial exposure duration 
    #>                            7                            7 
    #>             initial quantity                  number eras 
    #>                            7                            7 
    #>             number exposures               number records 
    #>                            7                            1 
    #>              number subjects             time to exposure 
    #>                            1                            7

### Combine and share results

Now we can combine our results and suppress any counts less than 5 so that they are ready to be shared.
    
    
    results <- [bind](https://darwin-eu.github.io/omopgenerics/reference/bind.html)(
      indication_summary,
      drug_utilisation_summary
    ) |>
      [suppress](https://darwin-eu.github.io/omopgenerics/reference/suppress.html)(minCellCount = 5)
    results |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 84
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Indication from 30 days before to the index date", "…
    #> $ variable_level   <chr> "headache", "headache", "influenza", "influenza", "he…
    #> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
    #> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
    #> $ estimate_value   <chr> "9", "16.0714285714286", "7", "12.5", "6", "10.714285…
    #> $ additional_name  <chr> "window_name", "window_name", "window_name", "window_…
    #> $ additional_level <chr> "-30 to 0", "-30 to 0", "-30 to 0", "-30 to 0", "-30 …

## Further analyses

There are many more drug-related analyses that we could have done with this acetaminophen cohort using the DrugUtilisation package. Please see the package website for more details.

## Links

  * [View on CRAN](https://cloud.r-project.org/package=DrugUtilisation)
  * [Browse source code](https://github.com/darwin-eu/DrugUtilisation/)
  * [Report a bug](https://github.com/darwin-eu/DrugUtilisation/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing DrugUtilisation](authors.html#citation)



## Developers

  * Martí Català   
Author, maintainer  [](https://orcid.org/0000-0003-3308-9905)
  * Yuchen Guo   
Author  [](https://orcid.org/0000-0002-0847-4855)
  * Kim Lopez-Guell   
Author  [](https://orcid.org/0000-0002-8462-8668)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * Xihang Chen   
Author  [](https://orcid.org/0009-0001-8112-8959)
  * [More about authors...](authors.html)



Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/index.html

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

# Package index

### Generate a set of drug cohorts

Generate a set of drug cohorts using given concepts or vocabulary hierarchies

`[generateDrugUtilisationCohortSet()](generateDrugUtilisationCohortSet.html)`
    Generate a set of drug cohorts based on given concepts

`[generateIngredientCohortSet()](generateIngredientCohortSet.html)`
    Generate a set of drug cohorts based on drug ingredients

`[generateAtcCohortSet()](generateAtcCohortSet.html)`
    Generate a set of drug cohorts based on ATC classification

`[erafyCohort()](erafyCohort.html)`
    Erafy a cohort_table collapsing records separated gapEra days or less.

`[cohortGapEra()](cohortGapEra.html)`
    Get the gapEra used to create a cohort

### Apply inclusion criteria to drug cohorts

Apply inclusion criteria that filter drug cohort entries based on specified rules.

`[requireDrugInDateRange()](requireDrugInDateRange.html)`
    Restrict cohort to only cohort records within a certain date range

`[requireIsFirstDrugEntry()](requireIsFirstDrugEntry.html)`
    Restrict cohort to only the first cohort record per subject

`[requireObservationBeforeDrug()](requireObservationBeforeDrug.html)`
    Restrict cohort to only cohort records with the given amount of prior observation time in the database

`[requirePriorDrugWashout()](requirePriorDrugWashout.html)`
    Restrict cohort to only cohort records with a given amount of time since the last cohort record ended

### Identify and summarise indications for patients in drug cohorts

Indications identified based on their presence in indication cohorts or OMOP CDM clinical tabes.

`[addIndication()](addIndication.html)`
    Add a variable indicating individuals indications

`[summariseIndication()](summariseIndication.html)`
    Summarise the indications of individuals in a drug cohort

`[tableIndication()](tableIndication.html)`
    Create a table showing indication results

`[plotIndication()](plotIndication.html)`
    Generate a plot visualisation (ggplot2) from the output of summariseIndication

### Drug use functions

Drug use functions are used to summarise and obtain the drug use information

`[addDrugUtilisation()](addDrugUtilisation.html)`
    Add new columns with drug use related information

`[summariseDrugUtilisation()](summariseDrugUtilisation.html)`
    This function is used to summarise the dose utilisation table over multiple cohorts.

`[tableDrugUtilisation()](tableDrugUtilisation.html)`
    Format a drug_utilisation object into a visual table.

`[plotDrugUtilisation()](plotDrugUtilisation.html)`
    Plot the results of `summariseDrugUtilisation`

### Drug use individual functions

Drug use functions can be used to add a single estimates

`[addNumberExposures()](addNumberExposures.html)`
    To add a new column with the number of exposures. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addNumberEras()](addNumberEras.html)`
    To add a new column with the number of eras. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addTimeToExposure()](addTimeToExposure.html)`
    To add a new column with the time to exposure. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addDaysExposed()](addDaysExposed.html)`
    To add a new column with the days exposed. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addDaysPrescribed()](addDaysPrescribed.html)`
    To add a new column with the days prescribed. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addInitialExposureDuration()](addInitialExposureDuration.html)`
    To add a new column with the duration of the first exposure. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addInitialQuantity()](addInitialQuantity.html)`
    To add a new column with the initial quantity. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addCumulativeQuantity()](addCumulativeQuantity.html)`
    To add a new column with the cumulative quantity. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addInitialDailyDose()](addInitialDailyDose.html)`
    To add a new column with the initial daily dose. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addCumulativeDose()](addCumulativeDose.html)`
    To add a new column with the cumulative dose. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

### Summarise treatment persistence using proportion of patients covered (PPC)

Summarise the proportion of patients in the drug cohort over time.

`[summariseProportionOfPatientsCovered()](summariseProportionOfPatientsCovered.html)`
    Summarise proportion Of patients covered

`[tableProportionOfPatientsCovered()](tableProportionOfPatientsCovered.html)`
    Create a table with proportion of patients covered results

`[plotProportionOfPatientsCovered()](plotProportionOfPatientsCovered.html)`
    Plot proportion of patients covered

### Summarise treatments during certain windows

Summarise the use of different treatments during certain windows

`[addTreatment()](addTreatment.html)`
    Add a variable indicating individuals medications

`[summariseTreatment()](summariseTreatment.html)`
    This function is used to summarise treatments received

`[tableTreatment()](tableTreatment.html)`
    Format a summarised_treatment result into a visual table.

`[plotTreatment()](plotTreatment.html)`
    Generate a custom ggplot2 from a summarised_result object generated with summariseTreatment function.

### Summarise treatment restart or switch during certain time

Summarise the restart of a treatment, or switch to another, during certain time

`[addDrugRestart()](addDrugRestart.html)`
    Add drug restart information as a column per follow-up period of interest.

`[summariseDrugRestart()](summariseDrugRestart.html)`
    Summarise the drug restart for each follow-up period of interest.

`[tableDrugRestart()](tableDrugRestart.html)`
    Format a drug_restart object into a visual table.

`[plotDrugRestart()](plotDrugRestart.html)`
    Generate a custom ggplot2 from a summarised_result object generated with summariseDrugRestart() function.

### Daily dose documentation

Functions to assess coverage for the diferent ingredients and document how daily dose is calculated

`[patternsWithFormula](patternsWithFormula.html)`
    Patterns valid to compute daily dose with the associated formula.

`[patternTable()](patternTable.html)`
    Function to create a tibble with the patterns from current drug strength table

`[summariseDoseCoverage()](summariseDoseCoverage.html)`
    Check coverage of daily dose computation in a sample of the cdm for selected concept sets and ingredient

`[tableDoseCoverage()](tableDoseCoverage.html)`
    Format a dose_coverage object into a visual table.

### Complementary functions

Complementary functions

`[benchmarkDrugUtilisation()](benchmarkDrugUtilisation.html)`
    Run benchmark of drug utilisation cohort generation

`[mockDrugUtilisation()](mockDrugUtilisation.html)`
    It creates a mock database for testing DrugUtilisation package

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/articles/mock_data.html

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

# Create mock data to test DrugUtilisation package

Source: [`vignettes/mock_data.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/mock_data.Rmd)

`mock_data.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))

## Introduction

In this vignette we will see how to use `[mockDrugUtilisation()](../reference/mockDrugUtilisation.html)` function to create mock data. This function is predominantly used in this package’s unit testing.

For example, one could use the default parameters to create a mock cdm reference like so:
    
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)()

This will then populate several omop tables (for example, `person`, `concept` and `visit_occurrence`) and two cohorts in the cdm reference.
    
    
    cdm$person |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 18
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    #> $ gender_concept_id           <int> 8507, 8507, 8532, 8507, 8507, 8532, 8507, …
    #> $ year_of_birth               <int> 2018, 1954, 1973, 1951, 2011, 2004, 1992, …
    #> $ day_of_birth                <int> 27, 3, 11, 17, 28, 10, 11, 5, 1, 12
    #> $ birth_datetime              <date> 2018-10-27, 1954-02-03, 1973-03-11, 1951-0…
    #> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ month_of_birth              <int> 10, 2, 3, 9, 8, 6, 6, 8, 8, 2
    #> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    
    cdm$person |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>       n
    #>   <dbl>
    #> 1    10
    
    
    cdm$concept |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 10
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ concept_id       <int> 8505, 8507, 8532, 8576, 8587, 8718, 9202, 9551, 9655,…
    #> $ concept_name     <chr> "hour", "MALE", "FEMALE", "milligram", "milliliter", …
    #> $ domain_id        <chr> "Unit", "Gender", "Gender", "Unit", "Unit", "Unit", "…
    #> $ vocabulary_id    <chr> "UCUM", "Gender", "Gender", "UCUM", "UCUM", "UCUM", "…
    #> $ concept_class_id <chr> "Unit", "Gender", "Gender", "Unit", "Unit", "Unit", "…
    #> $ standard_concept <chr> "S", "S", "S", "S", "S", "S", "S", "S", "S", NA, "S",…
    #> $ concept_code     <chr> "h", "M", "F", "mg", "mL", "[iU]", "OP", "10*-3.eq", …
    #> $ valid_start_date <date> 1-01-19, 1-01-19, 1-01-19, 1-01-19, 1-01-19, 1-01-19…
    #> $ valid_end_date   <date> 31-12-20, 31-12-20, 31-12-20, 31-12-20, 31-12-20, 31…
    #> $ invalid_reason   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    
    cdm$concept |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>       n
    #>   <dbl>
    #> 1    38
    
    
    cdm$visit_occurrence |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 17
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ visit_occurrence_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ person_id                     <int> 1, 2, 3, 3, 3, 3, 4, 4, 4, 6, 6, 6, 6, 7…
    #> $ visit_concept_id              <int> 9202, 9202, 9202, 9202, 9202, 9202, 9202…
    #> $ visit_start_date              <date> 2021-10-27, 1988-08-10, 1994-01-24, 199…
    #> $ visit_end_date                <date> 2021-12-16, 1991-08-30, 2001-10-12, 200…
    #> $ visit_type_concept_id         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    #> $ visit_start_datetime          <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    #> $ visit_end_datetime            <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    #> $ provider_id                   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ care_site_id                  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ visit_source_value            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ visit_source_concept_id       <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ admitting_source_concept_id   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ admitting_source_value        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ discharge_to_concept_id       <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ discharge_to_source_value     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ preceding_visit_occurrence_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    
    cdm$visit_occurrence |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>       n
    #>   <dbl>
    #> 1    48
    
    
    cdm$cohort1 |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 2, 1, 1, 3, 1, 1, 1, 2, 3, 2
    #> $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    #> $ cohort_start_date    <date> 2021-10-30, 2019-08-31, 1996-01-16, 2000-06-05, 2…
    #> $ cohort_end_date      <date> 2021-12-02, 2020-11-30, 1999-03-23, 2017-04-08, 2…
    
    cdm$cohort1 |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>       n
    #>   <dbl>
    #> 1    10
    
    
    cdm$cohort2 |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 3, 2, 2, 1, 2, 2, 1, 2, 2, 2
    #> $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    #> $ cohort_start_date    <date> 2021-11-15, 1988-12-24, 1990-10-29, 2004-09-25, 2…
    #> $ cohort_end_date      <date> 2021-11-24, 1993-03-08, 1993-09-13, 2013-08-10, 2…
    
    cdm$cohort2 |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>       n
    #>   <dbl>
    #> 1    10

### Setting seeds

The user can also set the seed to control the randomness within the data.
    
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(
      seed = 789
    )

We now observe that `cohort1` has been changed as a result of this seed:
    
    
    cdm$cohort1 |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 2, 1, 2, 1, 1, 3, 1, 3, 2, 1
    #> $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    #> $ cohort_start_date    <date> 2018-06-14, 2019-04-10, 2020-01-28, 2010-07-09, 2…
    #> $ cohort_end_date      <date> 2018-08-10, 2019-11-19, 2020-02-02, 2015-04-24, 2…

The users can then create mock data in two ways, one is to set the `numberIndividual` parameter and the other is to cusutomise the tables.

### Create mock data using numberIndividual parameter

An example of use is as follows:
    
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividual = 100)

This will ensure that each of `person`, `observation_period`, `cohort1` and `cohort2` will have 100 rows.
    
    
    cdm$person |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 18
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,…
    #> $ gender_concept_id           <int> 8507, 8507, 8507, 8507, 8507, 8507, 8532, …
    #> $ year_of_birth               <int> 1982, 1963, 1996, 1986, 1998, 1995, 1954, …
    #> $ day_of_birth                <int> 1, 24, 17, 4, 25, 9, 20, 4, 8, 22, 23, 5, …
    #> $ birth_datetime              <date> 1982-03-01, 1963-02-24, 1996-06-17, 1986-…
    #> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ month_of_birth              <int> 3, 2, 6, 12, 9, 5, 9, 11, 9, 7, 11, 7, 8, …
    #> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    
    
    cdm$person |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>       n
    #>   <dbl>
    #> 1   100

As a consequence of this, the number of rows for other tables such as `visit_occurrence`, `condition_occurrence` and `drug_strength` will have more rows compared to the mock data produced using default settings.
    
    
    cdm$visit_occurrence |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 17
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ visit_occurrence_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ person_id                     <int> 1, 1, 1, 2, 2, 2, 3, 4, 4, 4, 5, 5, 5, 5…
    #> $ visit_concept_id              <int> 9202, 9202, 9202, 9202, 9202, 9202, 9202…
    #> $ visit_start_date              <date> 2008-12-12, 2008-10-22, 2010-07-09, 201…
    #> $ visit_end_date                <date> 2008-12-30, 2011-01-16, 2010-07-23, 201…
    #> $ visit_type_concept_id         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    #> $ visit_start_datetime          <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    #> $ visit_end_datetime            <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    #> $ provider_id                   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ care_site_id                  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ visit_source_value            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ visit_source_concept_id       <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ admitting_source_concept_id   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ admitting_source_value        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ discharge_to_concept_id       <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ discharge_to_source_value     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    #> $ preceding_visit_occurrence_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    
    
    cdm$visit_occurrence |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>       n
    #>   <dbl>
    #> 1   498

### Creat mock data by customising tables

#### Customise omop tables

As we saw previously, the omop tables are automatically populated in `[mockDrugUtilisation()](../reference/mockDrugUtilisation.html)`. However, the user can customise these tables. For example, to customise `drug_exposure` table, one could do the following:
    
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(
      drug_exposure = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        drug_exposure_id = 1:3,
        person_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 1),
        drug_concept_id = [c](https://rdrr.io/r/base/c.html)(2, 3, 4),
        drug_exposure_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
          "2000-01-01", "2000-01-10", "2000-02-20"
        )),
        drug_exposure_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
          "2000-02-10", "2000-03-01", "2000-02-20"
        )),
        quantity = [c](https://rdrr.io/r/base/c.html)(41, 52, 1),
        drug_type_concept_id = 0
      )
    )
    
    
    cdm$drug_exposure |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 23
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ drug_exposure_id             <int> 1, 2, 3
    #> $ person_id                    <int> 1, 1, 1
    #> $ drug_concept_id              <int> 2, 3, 4
    #> $ drug_exposure_start_date     <date> 2000-01-01, 2000-01-10, 2000-02-20
    #> $ drug_exposure_end_date       <date> 2000-02-10, 2000-03-01, 2000-02-20
    #> $ quantity                     <dbl> 41, 52, 1
    #> $ drug_type_concept_id         <int> 0, 0, 0
    #> $ drug_exposure_start_datetime <date> NA, NA, NA
    #> $ drug_exposure_end_datetime   <date> NA, NA, NA
    #> $ verbatim_end_date            <date> NA, NA, NA
    #> $ stop_reason                  <chr> NA, NA, NA
    #> $ refills                      <int> NA, NA, NA
    #> $ days_supply                  <int> NA, NA, NA
    #> $ sig                          <chr> NA, NA, NA
    #> $ route_concept_id             <int> NA, NA, NA
    #> $ lot_number                   <chr> NA, NA, NA
    #> $ provider_id                  <int> NA, NA, NA
    #> $ visit_occurrence_id          <int> NA, NA, NA
    #> $ visit_detail_id              <int> NA, NA, NA
    #> $ drug_source_value            <chr> NA, NA, NA
    #> $ drug_source_concept_id       <int> NA, NA, NA
    #> $ route_source_value           <chr> NA, NA, NA
    #> $ dose_unit_source_value       <chr> NA, NA, NA

However, one needs to be vigilant that the customised omop table is implicitly dependent on other omop tables. For example, the `drug_exposure_start_date` of someone in the `drug_exposure` table should lie within that person’s `observation_period_start_date` and `observation_period_end_date`.

One could also modify other omop tables including `person`, `concept`, `concept_ancestor`, `drug_strength`, `observation_period`, `condition_occurrence`, `observation`, and `concept_relationship` in a similar fashion.

#### Customise cohorts

Similarly, cohort tables can also be customised.
    
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(
      observation_period = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        observation_period_id = 1,
        person_id = 1:2,
        observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
        observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2100-01-01"),
        period_type_concept_id = 0
      ),
      cohort1 = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = 1,
        subject_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 2),
        cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-01-01", "2001-01-01", "2000-01-01")),
        cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-03-01", "2001-03-01", "2000-03-01"))
      )
    )
    
    
    cdm$cohort1 |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <dbl> 1, 1, 1
    #> $ subject_id           <dbl> 1, 1, 2
    #> $ cohort_start_date    <date> 2000-01-01, 2001-01-01, 2000-01-01
    #> $ cohort_end_date      <date> 2000-03-01, 2001-03-01, 2000-03-01

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/articles/create_cohorts.html

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

---

## Content from https://darwin-eu.github.io/DrugUtilisation/articles/indication.html

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

# Identify and summarise indications among a drug cohort

Source: [`vignettes/indication.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/indication.Rmd)

`indication.Rmd`

## Introduction

In this vignette, we demonstrate the functionality provided by the DrugUtilisation package to help understand the indications of patients in a drug cohort.

The DrugUtilisation package is designed to work with data in the OMOP CDM format, so our first step is to create a reference to the data using the DBI and CDMConnector packages.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con,
      cdmSchema = "main",
      writeSchema = "main"
    )

### Create a drug utilisation cohort

We will use _acetaminophen_ as our example drug. We’ll start by creating a cohort of acetaminophen users. Here we’ll include all acetaminophen records using a gap era of 7 days, but as we’ve seen in the previous vignette we could have also applied various other inclusion criteria.
    
    
    cdm <- [generateIngredientCohortSet](../reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      name = "acetaminophen_users",
      ingredient = "acetaminophen",
      gapEra = 7
    )

Note that `addIndication` works with a cohort as input, in this example we will use drug cohorts created with `generateDrugUtilisationCohortSet` but the input cohorts can be generated using many other ways.

### Create a indication cohort

Next we will create a set of indication cohorts. In this case we will create cohorts for sinusitis and bronchitis using `[CDMConnector::generateConceptCohortSet()](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)`.
    
    
    indications <- [list](https://rdrr.io/r/base/list.html)(
      sinusitis = [c](https://rdrr.io/r/base/c.html)(257012, 4294548, 40481087),
      bronchitis = [c](https://rdrr.io/r/base/c.html)(260139, 258780)
    )
    
    cdm <- CDMConnector::[generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm, name = "indications_cohort", indications, end = 0
    )
    cdm

## Add indications with addIndication() function

Now that we have these two cohort tables, one with our drug cohort and another with our indications cohort, we can assess patient indications. For this we will specify a time window around the drug cohort start date for which we identify any intersection with the indication cohort. We can add this information as a new variable on our cohort table. This function will add a new column per window provided with the label of the indication.
    
    
    cdm[["acetaminophen_users"]] <- cdm[["acetaminophen_users"]] |>
      [addIndication](../reference/addIndication.html)(
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-30, 0)),
        indexDate = "cohort_start_date"
      )
    cdm[["acetaminophen_users"]] |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 2498, 2693, 3144, 3170, 3376, 3376, 3376, 3443, 3…
    #> $ cohort_start_date    <date> 1986-10-17, 2006-03-27, 1965-05-02, 1979-05-15, …
    #> $ cohort_end_date      <date> 1986-11-14, 2006-04-17, 1965-05-16, 1979-05-29, …
    #> $ indication_m30_to_0  <chr> "none", "none", "none", "none", "bronchitis", "no…

We can see that individuals are classified as having sinusistis (without bronchitis), bronchitis (without sinusitis), sinusitis and bronchitis, or no observed indication.
    
    
    cdm[["acetaminophen_users"]] |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_m30_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_m30_to_0          n
    #>   <chr>                    <dbl>
    #> 1 bronchitis                2527
    #> 2 sinusitis                   18
    #> 3 none                     11351
    #> 4 bronchitis and sinusitis     3

As well as the indication cohort table, we can also use the clinical tables in the OMOP CDM to identify other, unknown, indications. Here we consider anyone who is not in an indication cohort but has a record in the condition occurrence table to have an “unknown” indication. We can see that many of the people previously considered to have no indication are now considered as having an unknown indication as they have a condition occurrence record in the 30 days up to their drug initiation.
    
    
    cdm[["acetaminophen_users"]] |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(!"indication_m30_to_0") |>
      [addIndication](../reference/addIndication.html)(
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-30, 0)),
        unknownIndicationTable = "condition_occurrence"
      ) |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_m30_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_m30_to_0          n
    #>   <chr>                    <dbl>
    #> 1 bronchitis                2527
    #> 2 sinusitis                   18
    #> 3 unknown                  11344
    #> 4 bronchitis and sinusitis     3
    #> 5 none                         7

We can add indications for multiple time windows. Unsurprisingly we find more potential indications for wider windows (although this will likely increase our risk of false positives).
    
    
    cdm[["acetaminophen_users"]] <- cdm[["acetaminophen_users"]] |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(!"indication_m30_to_0") |>
      [addIndication](../reference/addIndication.html)(
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(-30, 0), [c](https://rdrr.io/r/base/c.html)(-365, 0)),
        unknownIndicationTable = "condition_occurrence"
      )
    cdm[["acetaminophen_users"]] |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_0_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_0_to_0     n
    #>   <chr>             <dbl>
    #> 1 unknown           11211
    #> 2 none                163
    #> 3 sinusitis             1
    #> 4 bronchitis         2524
    cdm[["acetaminophen_users"]] |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_m30_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_m30_to_0          n
    #>   <chr>                    <dbl>
    #> 1 bronchitis                2527
    #> 2 sinusitis                   18
    #> 3 unknown                  11344
    #> 4 none                         7
    #> 5 bronchitis and sinusitis     3
    cdm[["acetaminophen_users"]] |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_m365_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_m365_to_0         n
    #>   <chr>                    <dbl>
    #> 1 bronchitis                2615
    #> 2 sinusitis                  211
    #> 3 unknown                  10968
    #> 4 bronchitis and sinusitis   101
    #> 5 none                         4

### Summarise indications with summariseIndication()

Instead of adding variables with indications like above, we could instead obtain a general summary of observed indications. `summariseIndication` has similar arguments to `[addIndication()](../reference/addIndication.html)`, but returns a summary result of the indication.
    
    
    indicationSummary <- cdm[["acetaminophen_users"]] |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(!dplyr::[starts_with](https://tidyselect.r-lib.org/reference/starts_with.html)("indication")) |>
      [summariseIndication](../reference/summariseIndication.html)(
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(-30, 0), [c](https://rdrr.io/r/base/c.html)(-365, 0)),
        unknownIndicationTable = [c](https://rdrr.io/r/base/c.html)("condition_occurrence")
      )

We can then easily create a plot or a table of the results
    
    
    [tableIndication](../reference/tableIndication.html)(indicationSummary)

|  CDM name  
---|---  
|  Synthea  
Indication | Estimate name |  Cohort name  
acetaminophen  
Indication on index date  
bronchitis | N (%) | 2,524 (18.16 %)  
sinusitis | N (%) | 1 (0.01 %)  
bronchitis and sinusitis | N (%) | 0 (0.00 %)  
unknown | N (%) | 11,211 (80.66 %)  
none | N (%) | 163 (1.17 %)  
not in observation | N (%) | 0 (0.00 %)  
Indication from 30 days before to the index date  
bronchitis | N (%) | 2,527 (18.18 %)  
sinusitis | N (%) | 18 (0.13 %)  
bronchitis and sinusitis | N (%) | 3 (0.02 %)  
unknown | N (%) | 11,344 (81.62 %)  
none | N (%) | 7 (0.05 %)  
not in observation | N (%) | 0 (0.00 %)  
Indication from 365 days before to the index date  
bronchitis | N (%) | 2,615 (18.81 %)  
sinusitis | N (%) | 211 (1.52 %)  
bronchitis and sinusitis | N (%) | 101 (0.73 %)  
unknown | N (%) | 10,968 (78.91 %)  
none | N (%) | 4 (0.03 %)  
not in observation | N (%) | 0 (0.00 %)  
      
    
    [plotIndication](../reference/plotIndication.html)(indicationSummary)

![](indication_files/figure-html/unnamed-chunk-10-1.png)

As well as getting these overall results, we can also stratify the results by some variables of interest. For example, here we stratify our results by age groups and sex.
    
    
    indicationSummaryStratified <- cdm[["acetaminophen_users"]] |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(!dplyr::[starts_with](https://tidyselect.r-lib.org/reference/starts_with.html)("indication")) |>
      PatientProfiles::[addDemographics](https://darwin-eu.github.io/PatientProfiles/reference/addDemographics.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 19), [c](https://rdrr.io/r/base/c.html)(20, 150))) |>
      [summariseIndication](../reference/summariseIndication.html)(
        strata = [list](https://rdrr.io/r/base/list.html)("age_group", "sex"),
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(-30, 0), [c](https://rdrr.io/r/base/c.html)(-365, 0)),
        unknownIndicationTable = [c](https://rdrr.io/r/base/c.html)("condition_occurrence")
      )
    
    
    [tableIndication](../reference/tableIndication.html)(indicationSummaryStratified)

|  CDM name  
---|---  
|  Synthea  
|  Cohort name  
|  acetaminophen  
|  Age group  
|  overall |  0 to 19 |  20 to 150 |  overall  
Indication | Estimate name |  Sex  
overall | overall | overall | Female | Male  
Indication on index date  
bronchitis | N (%) | 2,524 (18.16 %) | 1,823 (29.90 %) | 701 (8.98 %) | 1,290 (18.42 %) | 1,234 (17.90 %)  
sinusitis | N (%) | 1 (0.01 %) | 1 (0.02 %) | 0 (0.00 %) | 0 (0.00 %) | 1 (0.01 %)  
bronchitis and sinusitis | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
unknown | N (%) | 11,211 (80.66 %) | 4,242 (69.59 %) | 6,969 (89.31 %) | 5,619 (80.23 %) | 5,592 (81.10 %)  
none | N (%) | 163 (1.17 %) | 30 (0.49 %) | 133 (1.70 %) | 95 (1.36 %) | 68 (0.99 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
Indication from 30 days before to the index date  
bronchitis | N (%) | 2,527 (18.18 %) | 1,826 (29.95 %) | 701 (8.98 %) | 1,291 (18.43 %) | 1,236 (17.93 %)  
sinusitis | N (%) | 18 (0.13 %) | 15 (0.25 %) | 3 (0.04 %) | 11 (0.16 %) | 7 (0.10 %)  
bronchitis and sinusitis | N (%) | 3 (0.02 %) | 2 (0.03 %) | 1 (0.01 %) | 1 (0.01 %) | 2 (0.03 %)  
unknown | N (%) | 11,344 (81.62 %) | 4,253 (69.77 %) | 7,091 (90.88 %) | 5,701 (81.40 %) | 5,643 (81.84 %)  
none | N (%) | 7 (0.05 %) | 0 (0.00 %) | 7 (0.09 %) | 0 (0.00 %) | 7 (0.10 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
Indication from 365 days before to the index date  
bronchitis | N (%) | 2,615 (18.81 %) | 1,883 (30.89 %) | 732 (9.38 %) | 1,353 (19.32 %) | 1,262 (18.30 %)  
sinusitis | N (%) | 211 (1.52 %) | 191 (3.13 %) | 20 (0.26 %) | 108 (1.54 %) | 103 (1.49 %)  
bronchitis and sinusitis | N (%) | 101 (0.73 %) | 96 (1.57 %) | 5 (0.06 %) | 39 (0.56 %) | 62 (0.90 %)  
unknown | N (%) | 10,968 (78.91 %) | 3,926 (64.40 %) | 7,042 (90.25 %) | 5,504 (78.58 %) | 5,464 (79.25 %)  
none | N (%) | 4 (0.03 %) | 0 (0.00 %) | 4 (0.05 %) | 0 (0.00 %) | 4 (0.06 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
      
    
    indicationSummaryStratified |>
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Indication on index date") |>
      [plotIndication](../reference/plotIndication.html)(
        facet = . ~ age_group + sex,
        colour = "variable_level"
      )

![](indication_files/figure-html/unnamed-chunk-13-1.png)

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/articles/daily_dose_calculation.html

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

# Daily dose calculation

Source: [`vignettes/daily_dose_calculation.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/daily_dose_calculation.Rmd)

`daily_dose_calculation.Rmd`

## Introduction

In this vignette is assessed how daily dose is calculated in the DrugUtilisation package. This function is used internally in `[addDrugUtilisation()](../reference/addDrugUtilisation.html)`.

### Daily dose

Daily dose is always computed at the ingredient level. So we can calculate the daily dose for each record in _drug exposure_ table for each given ingredient. Then the first step to calculate the daily dose for a given drug record and an ingredient concept id is to examine the relationship between drug concept id and ingredient concept id through the _drug strength_ table:
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividuals = 100, seed = 123456)
    cdm$drug_strength |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 12
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ drug_concept_id             <int> 1125315, 1125360, 1503297, 1503327, 150332…
    #> $ ingredient_concept_id       <int> 1125315, 1125315, 1503297, 1503297, 150329…
    #> $ amount_value                <dbl> NA, 5.0e+02, NA, 1.0e+03, 5.0e+02, NA, NA,…
    #> $ amount_unit_concept_id      <int> 8576, 8576, 8576, 8576, 8576, 8510, NA, NA…
    #> $ numerator_value             <dbl> NA, NA, NA, NA, NA, NA, 100, 300, NA, NA, …
    #> $ numerator_unit_concept_id   <int> NA, NA, NA, NA, NA, NA, 8510, 8510, NA, NA…
    #> $ denominator_value           <dbl> NA, NA, NA, NA, NA, NA, NA, 3, NA, NA, NA,…
    #> $ denominator_unit_concept_id <int> NA, NA, NA, NA, NA, NA, 8587, 8587, NA, NA…
    #> $ box_size                    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ valid_start_date            <date> 1-01-19, 1-01-19, 1-01-19, 1-01-19, 1-01-…
    #> $ valid_end_date              <date> 31-12-20, 31-12-20, 31-12-20, 31-12-20, 3…
    #> $ invalid_reason              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…

You can read the documentation of the _drug strength_ table and description of the different fields here: <https://www.ohdsi.org/web/wiki/doku.php?id=documentation:cdm:drug_strength>.

Not all drug concept ids and ingredient concept ids can be related, if no relation is found then daily dose is considered as `NA`.

Using vocabulary version: “v5.0 31-AUG-23” there exist 2,980,115 relationships between a drug concept id and an ingredient concept id. These relationships can be classified into **128** different patterns. Patterns are identified of combinations of 6 variables:

  * _amount_ : Whether the amount_value field is numeric or NA.
  * _amount_unit_ : The unit of the amount field.
  * _numerator_ : Whether the numerator_value field is numeric or NA.
  * _numerator_unit_ : The unit of the numerator field.
  * _denominator_ : Whether the denominator_value field is numeric or NA.
  * _denominator_unit_ : The unit of the denominator field.



These 128 combinations were analysed to see if they could be used to compute daily dose. **41 viable** patterns were identified, these patterns covered a total of 2,514,608 (84%) relationships between drug concept id and ingredient concept id. The patterns were classified into 4 different formulas:

  1. **Time based with denominator**



This formula was applied for the following 3 patterns that cover 8,044 (<1%) relationships:

pattern_id | amount | amount_unit | numerator | numerator_unit | denominator | denominator_unit  
---|---|---|---|---|---|---  
1 |  |  | number | microgram | number | hour  
2 |  |  | number | milligram | number | hour  
3 |  |  | number | unit | number | hour  
  
The formula in this case will be as follows:

if (denominator > 24)→daily dose=24⋅numeratordenominatorif (denominator≤24)→daily dose=numerator \begin{aligned} \text{if (denominator > 24)} &\rightarrow \text{daily dose} = 24 \cdot \frac{\text{numerator}}{\text{denominator}} \\\ \text{if (denominator} \leq 24) &\rightarrow \text{daily dose} = \text{numerator} \end{aligned} 

Note that daily dose has always unit associated in this case it will be determined by the `numerator_unit` field.

  2. **Time based no denominator**



This formula was applied for the following 2 patterns that cover 5,611 (<1%) relationships:

pattern_id | amount | amount_unit | numerator | numerator_unit | denominator | denominator_unit  
---|---|---|---|---|---|---  
4 |  |  | number | microgram |  | hour  
5 |  |  | number | milligram |  | hour  
  
The formula in this case will be as follows:

daily dose=24⋅numerator\begin{equation} \textrm{daily dose} = 24 \cdot numerator \end{equation}

In this case unit will be determined by the `numerator_unit` field.

  3. **Fixed amount formulation**



This formula was applied for the following 6 patterns that cover 1,102,435 (37%) relationships:

pattern_id | amount | amount_unit | numerator | numerator_unit | denominator | denominator_unit  
---|---|---|---|---|---|---  
6 | number | international unit |  |  |  |   
7 | number | microgram |  |  |  |   
8 | number | milliequivalent |  |  |  |   
9 | number | milligram |  |  |  |   
10 | number | milliliter |  |  |  |   
11 | number | unit |  |  |  |   
  
The formula in this case will be as follows:

daily dose=quantity⋅amountdaysexposed\begin{equation} \textrm{daily dose} = \frac{quantity \cdot amount}{days\: exposed} \end{equation}

In this case unit will be determined by the `amount_unit` field.

  4. **Concentration formulation**



This formula was applied for the following 30 patterns that cover 1,398,518 (47%) relationships:

pattern_id | amount | amount_unit | numerator | numerator_unit | denominator | denominator_unit  
---|---|---|---|---|---|---  
12 |  |  | number | international unit | number | milligram  
13 |  |  | number | international unit | number | milliliter  
14 |  |  | number | milliequivalent | number | milliliter  
15 |  |  | number | milligram | number | Actuation  
16 |  |  | number | milligram | number | liter  
17 |  |  | number | milligram | number | milligram  
18 |  |  | number | milligram | number | milliliter  
19 |  |  | number | milligram | number | square centimeter  
20 |  |  | number | milliliter | number | milligram  
21 |  |  | number | milliliter | number | milliliter  
22 |  |  | number | unit | number | Actuation  
23 |  |  | number | unit | number | milligram  
24 |  |  | number | unit | number | milliliter  
25 |  |  | number | unit | number | square centimeter  
26 |  |  | number | international unit |  | milligram  
27 |  |  | number | international unit |  | milliliter  
28 |  |  | number | mega-international unit |  | milliliter  
29 |  |  | number | milliequivalent |  | milligram  
30 |  |  | number | milliequivalent |  | milliliter  
31 |  |  | number | milligram |  | Actuation  
32 |  |  | number | milligram |  | liter  
33 |  |  | number | milligram |  | milligram  
34 |  |  | number | milligram |  | milliliter  
35 |  |  | number | milligram |  | square centimeter  
36 |  |  | number | milliliter |  | milligram  
37 |  |  | number | milliliter |  | milliliter  
38 |  |  | number | unit |  | Actuation  
39 |  |  | number | unit |  | milligram  
40 |  |  | number | unit |  | milliliter  
41 |  |  | number | unit |  | square centimeter  
  
The formula in this case will be as follows:

daily dose=quantity⋅numeratordaysexposed\begin{equation} \textrm{daily dose} = \frac{quantity \cdot numerator}{days\: exposed} \end{equation}

In this case unit will be determined by the `numerator_unit` field.

For formulas (3) and (4) quantity is obtained from the `quantity` column of the _drug exposure_ table and time exposed is obtained as the difference in days between `drug_exposure_start_date` and `drug_exposure_end_date` plus one.

The described formulas and patterns can be found in the exported `patternsWithFormula` data set:
    
    
    patternsWithFormula |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 41
    #> Columns: 9
    #> $ pattern_id       <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16…
    #> $ amount           <chr> NA, NA, NA, NA, NA, "number", "number", "number", "nu…
    #> $ amount_unit      <chr> NA, NA, NA, NA, NA, "international unit", "microgram"…
    #> $ numerator        <chr> "number", "number", "number", "number", "number", NA,…
    #> $ numerator_unit   <chr> "microgram", "milligram", "unit", "microgram", "milli…
    #> $ denominator      <chr> "number", "number", "number", NA, NA, NA, NA, NA, NA,…
    #> $ denominator_unit <chr> "hour", "hour", "hour", "hour", "hour", NA, NA, NA, N…
    #> $ formula_name     <chr> "time based with denominator", "time based with denom…
    #> $ formula          <chr> "if (denominator>24) {numerator * 24 / denominator} e…

The described formulas were validated into 5 different databases and the results were included in an article. Please refer to it for more details on dose calculations: [Calculating daily dose in the Observational Medical Outcomes Partnership Common Data Model](https://doi.org/10.1002/pds.5809).

### Finding out the pattern information using patternTable() function

The user could also find the patterns used in the `drug_strength` table. The output will also include a column of potentially valid and invalid combinations. The idea of a pattern to provide a platform to associate each drug in the `drug_strength` table with its constituent ingredients.
    
    
    [patternTable](../reference/patternTable.html)(cdm) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 5
    #> Columns: 12
    #> $ pattern_id                  <dbl> 9, 18, 24, 40, NA
    #> $ formula_name                <chr> "fixed amount formulation", "concentration…
    #> $ validity                    <chr> "pattern with formula", "pattern with form…
    #> $ number_concepts             <dbl> 7, 1, 1, 1, 4
    #> $ number_ingredients          <dbl> 4, 1, 1, 1, 4
    #> $ number_records              <dbl> 169, 34, 32, 35, 25
    #> $ amount_numeric              <dbl> 1, 0, 0, 0, NA
    #> $ amount_unit_concept_id      <dbl> 8576, NA, NA, NA, NA
    #> $ numerator_numeric           <dbl> 0, 1, 1, 1, NA
    #> $ numerator_unit_concept_id   <dbl> NA, 8576, 8510, 8510, NA
    #> $ denominator_numeric         <dbl> 0, 1, 1, 0, NA
    #> $ denominator_unit_concept_id <dbl> NA, 8587, 8587, 8587, NA

The output has three important columns, namely `number_concepts`, `number_ingredients` and `number_records`, which corresponds to count of distinct concepts in the patterns, count of distinct ingredients involved and overall count of records in the patterns respectively. The `pattern_id` column can be used to relate the patterns with the `patternsWithFormula` data set.

### Finding out the dose coverage using summariseDoseCoverage() function

This package also provides a functionality to check the coverage daily dose computation for chosen concept sets and ingredients. Let’s take _acetaminophen_ as an example.
    
    
    [summariseDoseCoverage](../reference/summariseDoseCoverage.html)(cdm = cdm, ingredientConceptId = 1125315) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 56
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "ingredient_name", "ingredient_name", "ingredient_nam…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "Missing dose", "Missing dose", "da…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count_missing", "percentage_missing", "mean…
    #> $ estimate_type    <chr> "integer", "integer", "percentage", "numeric", "numer…
    #> $ estimate_value   <chr> "78", "0", "0", "14949.800361887", "99310.1784420234"…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

The output will summarise the usage of _acetaminophen_ in the database. For example, overall there are 7878 records of _acetaminophen_ and for all of them daily dose can be calculated. By default the output will also include the mean, median, lower and upper quartiles and standard deviation of the daily dose of _acetaminophen_ calculated as explained above. The results will also be stratified by unit, route and pattern (which we saw in `patternsWithFormula` data set).

Different routes are documented in the **CodelistGenerator** package. Route is defined at the concept (`drug_concept_id`) level, there exist an equivalence between each concept and a route. You can stratify a codelist using the function: `[CodelistGenerator::stratifyByRouteCategory()](https://darwin-eu.github.io/CodelistGenerator/reference/stratifyByRouteCategory.html)`.

To better inspect the content of the output of `[summariseDoseCoverage()](../reference/summariseDoseCoverage.html)` we can create a gt table like so:
    
    
    coverageResult <- [summariseDoseCoverage](../reference/summariseDoseCoverage.html)(cdm = cdm, ingredientConceptId = 1125315)
    [tableDoseCoverage](../reference/tableDoseCoverage.html)(coverageResult)

|  Variable name  
---|---  
|  number records |  Missing dose |  daily_dose  
Unit | Route | Pattern id |  Estimate name  
N | N (%) | Mean (SD) | Median (Q25 - Q75)  
DUS MOCK; acetaminophen  
overall | overall | overall | 78 | 0 (0.00 %) | 14,949.80 (99,310.18) | 234.38 (19.68 - 1,264.66)  
milligram | overall | overall | 78 | 0 (0.00 %) | 14,949.80 (99,310.18) | 234.38 (19.68 - 1,264.66)  
| oral | overall | 18 | 0 (0.00 %) | 182.38 (294.08) | 41.03 (15.69 - 237.42)  
| topical | overall | 60 | 0 (0.00 %) | 19,380.03 (113,070.32) | 308.61 (28.48 - 1,962.38)  
| oral | 9 | 18 | 0 (0.00 %) | 182.38 (294.08) | 41.03 (15.69 - 237.42)  
| topical | 18 | 34 | 0 (0.00 %) | 32,837.73 (149,637.62) | 1,066.79 (243.71 - 4,339.96)  
|  | 9 | 26 | 0 (0.00 %) | 1,781.50 (6,876.01) | 49.95 (4.96 - 268.87)  
  
The user also has the freedom to customize the gt table output. For example the following will suppress the `cdmName`:
    
    
    [tableDoseCoverage](../reference/tableDoseCoverage.html)(coverageResult, groupColumn = "ingredient_name", hide = "cdm_name")

|  Variable name  
---|---  
|  number records |  Missing dose |  daily_dose  
Sample size | Unit | Route | Pattern id | Variable level |  Estimate name  
N | N (%) | Mean (SD) | Median (Q25 - Q75)  
acetaminophen  
Inf | overall | overall | overall | - | 78 | 0 (0.00 %) | 14,949.80 (99,310.18) | 234.38 (19.68 - 1,264.66)  
| milligram | overall | overall | - | 78 | 0 (0.00 %) | 14,949.80 (99,310.18) | 234.38 (19.68 - 1,264.66)  
|  | oral | overall | - | 18 | 0 (0.00 %) | 182.38 (294.08) | 41.03 (15.69 - 237.42)  
|  | topical | overall | - | 60 | 0 (0.00 %) | 19,380.03 (113,070.32) | 308.61 (28.48 - 1,962.38)  
|  | oral | 9 | - | 18 | 0 (0.00 %) | 182.38 (294.08) | 41.03 (15.69 - 237.42)  
|  | topical | 18 | - | 34 | 0 (0.00 %) | 32,837.73 (149,637.62) | 1,066.79 (243.71 - 4,339.96)  
|  |  | 9 | - | 26 | 0 (0.00 %) | 1,781.50 (6,876.01) | 49.95 (4.96 - 268.87)  
  
## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/articles/drug_utilisation.html

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

# Getting drug utilisation related information of subjects in a cohort

Source: [`vignettes/drug_utilisation.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/drug_utilisation.Rmd)

`drug_utilisation.Rmd`

## Introduction

The DrugUtilisation package includes a range of functions that add drug-related information of subjects in OMOP CDM tables and cohort tables. Essentially, there are two functionalities: `add` and `summarise`. While the first return patient-level information on drug usage, the second returns aggregate estimates of it. In this vignette, we will explore these functions and provide some examples for its usage.

## Set up

### Mock data

For this vignette we will use mock data contained in the DrugUtilisation package. This mock dataset contains cohorts, we will take “cohort1” as the cohort table of interest from which we want to study drug usage of acetaminophen.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividual = 200)
    cdm$cohort1 |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 3, 1, 1, 3, 3, 2, 1, 3, 2, 3, 3, 1, 2, 3, 2, 2, 1…
    #> $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15…
    #> $ cohort_start_date    <date> 2004-08-15, 2015-06-19, 2001-07-26, 2008-06-25, …
    #> $ cohort_end_date      <date> 2005-04-10, 2017-10-21, 2001-12-07, 2012-03-22, …

### Drug codes

Since we want to characterise _acetaminophen_ and _simvastatin_ usage for subjects in cohort1, we first have to get the codelist with CodelistGenerator:
    
    
    drugConcepts <- CodelistGenerator::[getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "simvastatin"))

## Add drug utilisation information

### addNumberExposures()

With the function **`[addNumberExposures()](../reference/addNumberExposures.html)`** we can get how many exposures to acetaminophen each patient in our cohort had during a certain time. There are 2 thing to keep in mind when using this function:

  * **Time period of interest:** The `indexDate` and `censorDate` arguments refer to the time-period in which we are interested to compute the number of exposure to acetaminophen. The refer to date columns in the cohort table, and by default this are “cohort_start_date” and “cohort_end_date” respectively.

  * **Incident or prevalent events?** Do we want to consider only those exposures to the drug of interest starting during the time-period (`restrictIncident = TRUE`), or do we also want to take into account those that started before but underwent for at least some time during the follow-up period considered (`restrictIncident = FALSE`)?




In what follows we add a column in the cohort table, with the number of incident exposures during the time patients are in the cohort:
    
    
    cohort <- [addNumberExposures](../reference/addNumberExposures.html)(
      cohort = cdm$cohort1, # cohort with the population of interest
      conceptSet = drugConcepts, # concepts of the drugs of interest
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "number_exposures_{concept_name}",
      name = NULL
    )
    
    cohort |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id               <int> 3, 2, 1, 2, 3, 1, 3, 2, 1, 2, 3, 1,…
    #> $ subject_id                         <int> 1, 6, 7, 9, 10, 12, 14, 15, 17, 20,…
    #> $ cohort_start_date                  <date> 2004-08-15, 2012-07-24, 2013-06-10…
    #> $ cohort_end_date                    <date> 2005-04-10, 2012-08-10, 2013-08-26…
    #> $ number_exposures_36567_simvastatin <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ number_exposures_161_acetaminophen <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…

### addNumberEras()

This function works like the previous one, but calculates the **number of eras** instead of exposures. The difference between these two is given by the `gapEra` argument: consecutive drug exposures separated by less than the days specified in `gapEra`, are collapsed together into the same era.

Next we compute the number of eras, considering a gap of 3 days.

Additionally, we use the argument `nameStyle` so the new columns are only identified by the concept name, instead of using the prefix “number_eras_” set by default.
    
    
    cohort <- [addNumberEras](../reference/addNumberEras.html)(
      cohort = cdm$cohort1, # cohort with the population of interest
      conceptSet = drugConcepts, # concepts of the drugs of interest
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      gapEra = 3,
      restrictIncident = TRUE,
      nameStyle = "{concept_name}",
      name = NULL
    )
    
    cohort |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 3, 2, 1, 2, 3, 1, 3, 2, 1, 2, 3, 1, 3, 3, 3, 1, 1…
    #> $ subject_id           <int> 1, 6, 7, 9, 10, 12, 14, 15, 17, 20, 21, 22, 23, 2…
    #> $ cohort_start_date    <date> 2004-08-15, 2012-07-24, 2013-06-10, 2017-11-04, …
    #> $ cohort_end_date      <date> 2005-04-10, 2012-08-10, 2013-08-26, 2018-02-24, …
    #> $ `36567_simvastatin`  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ `161_acetaminophen`  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…

### daysExposed

This argument set to TRUE will add a column specifying the time in days a person has been exposed to the drug of interest. Take note that `gapEra` and `restrictIncident` will be taken into account for this calculation:

  1. **Drug eras:** exposed time will be based on drug eras according to `gapEra`.

  2. **Incident exposures:** if `restrictIncident = TRUE`, exposed time will consider only those drug exposures starting after indexDate, while if `restrictIncident = FALSE`, exposures that started before indexDate and ended afterwards will also be taken into account.




The subfunction to get only this information is `[addDaysExposed()](../reference/addDaysExposed.html)`.

### daysPrescribed

Similarly to the previous one, this argument adds a column with the number of days the individual is prescribed with the drug of interest, if set to TRUE. This number is calculated by adding up the days for all prescriptions that contribute to the analysis. In this case, `restrictIncident` will influence the calculation as follows: if set to TRUE, drug prescriptions will only be counted if happening after index date; if FALSE, all prescriptions will contribute to the sum.

The subfunction to get only this information is `[addDaysPrescribed()](../reference/addDaysPrescribed.html)`.

### timeToExposure

If set to TRUE, a column will be added that shows the number of days until the first exposure occurring within the considered time window. Notice that the value of `restrictIncident` will be taken into account: if TRUE, the time to the first incident exposure during the time interval is measured; otherwise, exposures that start before the `indexDate` and end afterwards will be considered (in these cases, time to exposure is 0).

The subfunction to get only this information is `[addTimeToExposure()](../reference/addTimeToExposure.html)`.

### initialExposureDuration

This argument will add a column with information on the number of days of the first prescription of the drug. If `restrictIncident = TRUE`, this first drug exposure record after index date will be selected. Otherwise, the first record ever will be the one contributing this number.

The subfunction to get only this information is `[addInitialExposureDuration()](../reference/addInitialExposureDuration.html)`.

### initialQuantity and cumulativeQuantity

These, if TRUE, will add a column each specifying which was the initial quantity prescribed at the start of the first exposure considered (`initialQuantity`), and the cumulative quantity taken throughout the exposures in the considered time-window (`cumulativeQuantity`).

Quantities are measured at conceptSet level not ingredient. Notice that for both measures `restrictIncident` is considered, while `gapEra` is used for the `cumulative quantity`.

The subfunctions to get this information are `[addInitialQuantity()](../reference/addInitialQuantity.html)` and `[addCumulativeQuantity()](../reference/addCumulativeQuantity.html)` respectively.

### initialDailyDose and cumulativeDose

If `initialDailyDose` is TRUE, a column will be add specifying for each of the ingredients in a conceptSet which was the initial daily dose given. The `cumulativeDose` will measure for each ingredient the total dose taken throughout the exposures considered in the time-window. Recall that `restrictIncident` is considered in these calculations, and that the cumulative dose also considers `gapEra`.

The subfunctions to get this information are `[addInitialDailyDose()](../reference/addInitialDailyDose.html)` and `[addCumulativeDose()](../reference/addCumulativeDose.html)` respectively.

### addDrugUtilisation()

All the explained **`add`** functions are subfunctions of the more comprehensive **`[addDrugUtilisation()](../reference/addDrugUtilisation.html)`**. This broader function computes multiple drug utilization metrics.
    
    
    [addDrugUtilisation](../reference/addDrugUtilisation.html)(
      cohort,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      ingredientConceptId = NULL,
      conceptSet = NULL,
      restrictIncident = TRUE,
      gapEra = 1,
      numberExposures = TRUE,
      numberEras = TRUE,
      daysExposed = TRUE,
      daysPrescribed = TRUE,
      timeToExposure = TRUE,
      initialExposureDuration = TRUE,
      initialQuantity = TRUE,
      cumulativeQuantity = TRUE,
      initialDailyDose = TRUE,
      cumulativeDose = TRUE,
      nameStyle = "{value}_{concept_name}_{ingredient}",
      name = NULL
    )

  * Using `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` is recommended when multiple parameters are needed, as it is more computationally efficient than chaining the different subfunctions.

  * If `conceptSet` is NULL, it will be produced from descendants of given ingredients.

  * `nameStyle` argument allows customisation of the names of the new columns added by the function, following the glue package style.

  * By default it returns a temporal table, but if `name` is not NULL a permanent table with the defined name will be computed in the database.




### Use case

In what follows we create a permanent table “drug_utilisation_example” in the database with the information on dosage and quantity of the ingredients 1125315 (acetaminophen) and 1503297 (metformin). We are interested in exposures happening from cohort end date, until the end of the patient’s observation data. Additionally, we define an exposure era using a gap of 7 days, and we only consider incident exposures during that time.
    
    
    cdm$drug_utilisation_example <- cdm$cohort1 |>
      # add end of current observation date with the package PatientProfiels
      PatientProfiles::[addFutureObservation](https://darwin-eu.github.io/PatientProfiles/reference/addFutureObservation.html)(futureObservationType = "date") |>
      # add the targeted drug utilisation measures
      [addDrugUtilisation](../reference/addDrugUtilisation.html)(
        indexDate = "cohort_end_date",
        censorDate = "future_observation",
        ingredientConceptId = [c](https://rdrr.io/r/base/c.html)(1125315, 1503297),
        conceptSet = NULL,
        restrictIncident = TRUE,
        gapEra = 7,
        numberExposures = FALSE,
        numberEras = FALSE,
        daysExposed = FALSE,
        daysPrescribed = FALSE,
        timeToExposure = FALSE,
        initialExposureDuration = FALSE,
        initialQuantity = TRUE,
        cumulativeQuantity = TRUE,
        initialDailyDose = TRUE,
        cumulativeDose = TRUE,
        nameStyle = "{value}_{concept_name}_{ingredient}",
        name = "drug_utilisation_example"
      )
    
    cdm$drug_utilisation_example |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 13
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id                                                <int> 3,…
    #> $ subject_id                                                          <int> 1,…
    #> $ cohort_start_date                                                   <date> 2…
    #> $ cohort_end_date                                                     <date> 2…
    #> $ future_observation                                                  <date> 2…
    #> $ cumulative_quantity_ingredient_1503297_descendants                  <dbl> 0,…
    #> $ cumulative_quantity_ingredient_1125315_descendants                  <dbl> 0,…
    #> $ initial_quantity_ingredient_1503297_descendants                     <dbl> 0,…
    #> $ initial_quantity_ingredient_1125315_descendants                     <dbl> 0,…
    #> $ cumulative_dose_milligram_ingredient_1125315_descendants_1125315    <dbl> 0,…
    #> $ initial_daily_dose_milligram_ingredient_1125315_descendants_1125315 <dbl> 0,…
    #> $ cumulative_dose_milligram_ingredient_1503297_descendants_1503297    <dbl> 0,…
    #> $ initial_daily_dose_milligram_ingredient_1503297_descendants_1503297 <dbl> 0,…

## Summarise drug utilisation information

The information given by `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` or its sub-functions is at patient level. If we are interested in aggregated estimates for these measure we can use `[summariseDrugUtilisation()](../reference/summariseDrugUtilisation.html)`.

### summariseDrugUtilisation()

This function will provide the desired estimates (set in the argument `estimates`) of the targeted drug utilisation measures. Similar to `[addDrugUtilisation()](../reference/addDrugUtilisation.html)`, by setting TRUE or FALSE each of the drug utilisation measures, the user can choose which measures to obtain.
    
    
    duResults <- [summariseDrugUtilisation](../reference/summariseDrugUtilisation.html)(
      cohort = cdm$cohort1,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      estimates = [c](https://rdrr.io/r/base/c.html)(
        "q25", "median", "q75", "mean", "sd", "count_missing",
        "percentage_missing"
      ),
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      ingredientConceptId = [c](https://rdrr.io/r/base/c.html)(1125315, 1503297),
      conceptSet = NULL,
      restrictIncident = TRUE,
      gapEra = 7,
      numberExposures = TRUE,
      numberEras = TRUE,
      daysExposed = TRUE,
      daysPrescribed = TRUE,
      timeToExposure = TRUE,
      initialExposureDuration = TRUE,
      initialQuantity = TRUE,
      cumulativeQuantity = TRUE,
      initialDailyDose = TRUE,
      cumulativeDose = TRUE
    )
    
    duResults |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 426
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "number subjects", "number exposure…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "q25", "median", "q75", "mean", "sd…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "66", "66", "0", "0", "0", "0.196969696969697", "0.50…
    #> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
    #> $ additional_level <chr> "overall", "overall", "ingredient_1503297_descendants…

As seen below, the result of this function is a `summarised_result` object. For more information on these class of objects see `omopgenerics` package.

Additionally, the `strata` argument will provide the estimates for different stratifications defined by columns in the cohort. For instance, we can add a column indicating the sex, and another indicating if the subject is older than 50, and use those to stratify by sex and age, together and separately as follows:
    
    
    duResults <- cdm$cohort1 |>
      # add age and sex
      PatientProfiles::[addDemographics](https://darwin-eu.github.io/PatientProfiles/reference/addDemographics.html)(
        age = TRUE,
        ageGroup = [list](https://rdrr.io/r/base/list.html)("<=50" = [c](https://rdrr.io/r/base/c.html)(0, 50), ">50" = [c](https://rdrr.io/r/base/c.html)(51, 150)),
        sex = TRUE,
        priorObservation = FALSE,
        futureObservation = FALSE
      ) |>
      # drug utilisation
      [summariseDrugUtilisation](../reference/summariseDrugUtilisation.html)(
        strata = [list](https://rdrr.io/r/base/list.html)("age_group", "sex", [c](https://rdrr.io/r/base/c.html)("age_group", "sex")),
        estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd", "count_missing", "percentage_missing"),
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        ingredientConceptId = [c](https://rdrr.io/r/base/c.html)(1125315, 1503297),
        conceptSet = NULL,
        restrictIncident = TRUE,
        gapEra = 7,
        numberExposures = TRUE,
        numberEras = TRUE,
        daysExposed = TRUE,
        daysPrescribed = TRUE,
        timeToExposure = TRUE,
        initialExposureDuration = TRUE,
        initialQuantity = TRUE,
        cumulativeQuantity = TRUE,
        initialDailyDose = TRUE,
        cumulativeDose = TRUE
      )
    
    duResults |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,968
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "age_group", "age_group", "age_group", "age_group", "…
    #> $ strata_level     <chr> "<=50", "<=50", "<=50", "<=50", "<=50", "<=50", "<=50…
    #> $ variable_name    <chr> "number records", "number subjects", "number exposure…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "mean", "sd", "count_missing", "per…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "integer"…
    #> $ estimate_value   <chr> "63", "63", "0.158730158730159", "0.447442524921401",…
    #> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
    #> $ additional_level <chr> "overall", "overall", "ingredient_1503297_descendants…

The estimates obtained in this last part correspond to the mean (`mean`) and standard deviation (`sd`) of those that had information on dose and quantity, and the number (`count_missing`) (and percentage (`percentage_missing`)) of subjects with missing information.

### tableDrugUtilisation()

Results from `[summariseDrugUtilisation()](../reference/summariseDrugUtilisation.html)` can be nicely visualised in a tabular format using the function `[tableDrugUtilisation()](../reference/tableDrugUtilisation.html)`.
    
    
    [tableDrugUtilisation](../reference/tableDrugUtilisation.html)(duResults)
    #> Warning: cdm_name, cohort_name, age_group, sex, variable_level, censor_date,
    #> cohort_table_name, gap_era, index_date, and restrict_incident are missing in
    #> `columnOrder`, will be added last.
    #> ℹ <median> (<q25> - <q75>) has not been formatted.

Concept set | Ingredient | Variable name | Estimate name |  CDM name  
---|---|---|---|---  
DUS MOCK  
cohort_1; <=50; overall  
overall | overall | number records | N | 63  
|  | number subjects | N | 63  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.16 (0.45)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.16 (0.51)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 55 (87.30 %)  
|  |  | Mean (SD) | 800.62 (1,209.49)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 56 (88.89 %)  
|  |  | Mean (SD) | 108.71 (105.41)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.79 (17.21)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.59 (13.36)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.56 (11.06)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.16 (15.96)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 56 (88.89 %)  
|  |  | Mean (SD) | 170.00 (120.53)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 55 (87.30 %)  
|  |  | Mean (SD) | 500.25 (563.30)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.13 (0.34)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.43)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 54.08 (210.81)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 53.41 (333.70)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 56.22 (215.84)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 55.51 (335.44)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,599.55 (18,139.68)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 207.39 (1,574.38)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,430.17 (10,342.89)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 282.65 (1,900.60)  
cohort_1; >50; overall  
overall | overall | number records | N | 3  
|  | number subjects | N | 3  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.00 (1.00)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 1 (33.33 %)  
|  |  | Mean (SD) | 411.50 (309.01)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 3 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 23.67 (40.13)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 10.33 (17.04)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 3 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 1 (33.33 %)  
|  |  | Mean (SD) | 139.50 (58.69)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.00 (1.00)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 86.00 (128.73)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 86.00 (128.73)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,756.07 (9,863.94)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 29.32 (46.44)  
cohort_1; <=50; Female  
overall | overall | number records | N | 28  
|  | number subjects | N | 28  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.42)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.25 (0.65)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 26 (92.86 %)  
|  |  | Mean (SD) | 285.50 (38.89)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 23 (82.14 %)  
|  |  | Mean (SD) | 104.00 (126.39)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.32 (9.76)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.82 (19.20)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.86 (16.12)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.25 (4.64)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 23 (82.14 %)  
|  |  | Mean (SD) | 119.00 (100.79)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 26 (92.86 %)  
|  |  | Mean (SD) | 101.50 (112.43)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.07 (0.26)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.50)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.07 (59.71)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 17.71 (61.18)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 15.64 (78.57)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 22.43 (82.12)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,063.67 (22,769.17)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 465.44 (2,359.55)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1,853.87 (7,431.16)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 26.32 (128.89)  
cohort_1; <=50; Male  
overall | overall | number records | N | 35  
|  | number subjects | N | 35  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.47)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.09 (0.37)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 29 (82.86 %)  
|  |  | Mean (SD) | 972.33 (1,380.64)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 33 (94.29 %)  
|  |  | Mean (SD) | 120.50 (48.79)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.57 (21.13)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.00 (4.17)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.71 (3.01)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.29 (20.61)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 33 (94.29 %)  
|  |  | Mean (SD) | 297.50 (31.82)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 29 (82.86 %)  
|  |  | Mean (SD) | 633.17 (597.41)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.38)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.09 (0.37)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 87.69 (274.93)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 81.97 (445.20)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 88.69 (278.58)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 81.97 (445.20)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,428.25 (13,607.07)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.95 (3.95)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,691.21 (12,146.47)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 487.71 (2,544.90)  
cohort_1; >50; Female  
overall | overall | number records | N | 1  
|  | number subjects | N | 1  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 1 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 1 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
cohort_1; >50; Male  
overall | overall | number records | N | 2  
|  | number subjects | N | 2  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.71)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 1 (50.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 2 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.71)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.71)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 2 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 1 (50.00 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.71)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.00 (16.97)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.00 (16.97)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 61.22 (86.58)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.55 (3.61)  
cohort_1; overall; overall  
overall | overall | number records | N | 66  
|  | number subjects | N | 66  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.50)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.15 (0.50)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 56 (84.85 %)  
|  |  | Mean (SD) | 722.80 (1,084.12)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 59 (89.39 %)  
|  |  | Mean (SD) | 108.71 (105.41)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.61 (18.60)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.42 (13.07)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.44 (10.82)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.39 (15.91)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 59 (89.39 %)  
|  |  | Mean (SD) | 170.00 (120.53)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 56 (84.85 %)  
|  |  | Mean (SD) | 428.10 (519.91)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.43)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 55.53 (207.23)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 50.98 (326.10)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 57.58 (212.10)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 52.98 (327.81)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,435.93 (17,732.23)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 197.96 (1,538.24)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,535.89 (10,260.13)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 271.13 (1,857.00)  
cohort_1; overall; Female  
overall | overall | number records | N | 29  
|  | number subjects | N | 29  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.54)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.64)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 26 (89.66 %)  
|  |  | Mean (SD) | 400.33 (200.79)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 24 (82.76 %)  
|  |  | Mean (SD) | 104.00 (126.39)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.66 (15.81)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.59 (18.89)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.69 (15.85)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.24 (7.02)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 24 (82.76 %)  
|  |  | Mean (SD) | 119.00 (100.79)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 26 (89.66 %)  
|  |  | Mean (SD) | 128.00 (91.80)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.44)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.49)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 19.72 (71.67)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 17.10 (60.17)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 23.17 (87.16)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21.66 (80.75)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,889.06 (22,378.64)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 449.39 (2,318.64)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,381.18 (7,830.29)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 28.27 (127.00)  
cohort_1; overall; Male  
overall | overall | number records | N | 37  
|  | number subjects | N | 37  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.48)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.36)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 30 (81.08 %)  
|  |  | Mean (SD) | 861.00 (1,294.31)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 35 (94.59 %)  
|  |  | Mean (SD) | 120.50 (48.79)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.14 (20.62)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.95 (4.05)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.68 (2.93)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.86 (20.11)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 35 (94.59 %)  
|  |  | Mean (SD) | 297.50 (31.82)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 30 (81.08 %)  
|  |  | Mean (SD) | 556.71 (581.66)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.19 (0.40)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.36)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 83.59 (267.77)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 77.54 (433.06)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 84.54 (271.32)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 77.54 (433.06)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,297.00 (13,235.41)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.90 (3.85)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,440.94 (11,851.88)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 461.48 (2,475.70)  
cohort_2; <=50; overall  
overall | overall | number records | N | 51  
|  | number subjects | N | 51  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.49)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.47)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 46 (90.20 %)  
|  |  | Mean (SD) | 178.60 (255.32)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 40 (78.43 %)  
|  |  | Mean (SD) | 436.91 (723.62)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.41 (13.63)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.22 (19.40)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.43 (17.85)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.53 (11.97)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 40 (78.43 %)  
|  |  | Mean (SD) | 725.55 (1,102.02)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 46 (90.20 %)  
|  |  | Mean (SD) | 183.00 (168.31)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.10 (0.30)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21.47 (99.72)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 86.76 (379.84)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 33.39 (181.83)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 87.08 (379.81)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 25,634.49 (85,811.30)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,624.79 (15,813.75)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,083.35 (6,610.92)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 42.88 (236.52)  
cohort_2; <=50; Female  
overall | overall | number records | N | 27  
|  | number subjects | N | 27  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.32)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 24 (88.89 %)  
|  |  | Mean (SD) | 205.00 (329.31)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 21 (77.78 %)  
|  |  | Mean (SD) | 150.33 (220.69)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.81 (14.04)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.89 (19.38)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.89 (19.38)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.81 (14.04)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 21 (77.78 %)  
|  |  | Mean (SD) | 780.33 (1,277.84)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 24 (88.89 %)  
|  |  | Mean (SD) | 129.67 (103.18)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.32)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.85 (46.63)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 49.41 (240.14)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.85 (46.63)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 49.41 (240.14)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21,126.45 (71,475.11)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,868.94 (21,672.36)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,005.59 (5,919.70)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 69.68 (320.44)  
cohort_2; <=50; Male  
overall | overall | number records | N | 24  
|  | number subjects | N | 24  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.64)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.25 (0.53)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 22 (91.67 %)  
|  |  | Mean (SD) | 139.00 (196.58)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 19 (79.17 %)  
|  |  | Mean (SD) | 780.80 (988.51)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.96 (13.43)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.58 (19.83)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.92 (16.35)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.08 (9.20)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 19 (79.17 %)  
|  |  | Mean (SD) | 659.80 (992.52)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 22 (91.67 %)  
|  |  | Mean (SD) | 263.00 (265.87)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.28)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.41)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 31.17 (137.75)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 128.79 (494.95)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 56.50 (261.47)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 129.46 (494.84)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 30,706.03 (100,906.10)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 100.11 (349.98)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,170.83 (7,441.80)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.73 (61.20)  
cohort_2; overall; overall  
overall | overall | number records | N | 51  
|  | number subjects | N | 51  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.49)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.47)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 46 (90.20 %)  
|  |  | Mean (SD) | 178.60 (255.32)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 40 (78.43 %)  
|  |  | Mean (SD) | 436.91 (723.62)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.41 (13.63)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.22 (19.40)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.43 (17.85)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.53 (11.97)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 40 (78.43 %)  
|  |  | Mean (SD) | 725.55 (1,102.02)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 46 (90.20 %)  
|  |  | Mean (SD) | 183.00 (168.31)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.10 (0.30)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21.47 (99.72)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 86.76 (379.84)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 33.39 (181.83)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 87.08 (379.81)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 25,634.49 (85,811.30)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,624.79 (15,813.75)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,083.35 (6,610.92)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 42.88 (236.52)  
cohort_2; overall; Female  
overall | overall | number records | N | 27  
|  | number subjects | N | 27  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.32)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 24 (88.89 %)  
|  |  | Mean (SD) | 205.00 (329.31)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 21 (77.78 %)  
|  |  | Mean (SD) | 150.33 (220.69)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.81 (14.04)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.89 (19.38)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.89 (19.38)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.81 (14.04)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 21 (77.78 %)  
|  |  | Mean (SD) | 780.33 (1,277.84)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 24 (88.89 %)  
|  |  | Mean (SD) | 129.67 (103.18)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.32)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.85 (46.63)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 49.41 (240.14)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.85 (46.63)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 49.41 (240.14)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21,126.45 (71,475.11)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,868.94 (21,672.36)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,005.59 (5,919.70)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 69.68 (320.44)  
cohort_2; overall; Male  
overall | overall | number records | N | 24  
|  | number subjects | N | 24  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.64)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.25 (0.53)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 22 (91.67 %)  
|  |  | Mean (SD) | 139.00 (196.58)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 19 (79.17 %)  
|  |  | Mean (SD) | 780.80 (988.51)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.96 (13.43)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.58 (19.83)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.92 (16.35)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.08 (9.20)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 19 (79.17 %)  
|  |  | Mean (SD) | 659.80 (992.52)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 22 (91.67 %)  
|  |  | Mean (SD) | 263.00 (265.87)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.28)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.41)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 31.17 (137.75)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 128.79 (494.95)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 56.50 (261.47)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 129.46 (494.84)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 30,706.03 (100,906.10)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 100.11 (349.98)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,170.83 (7,441.80)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.73 (61.20)  
cohort_3; <=50; overall  
overall | overall | number records | N | 71  
|  | number subjects | N | 71  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.55)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.52)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 58 (81.69 %)  
|  |  | Mean (SD) | 1,281.31 (2,611.47)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 57 (80.28 %)  
|  |  | Mean (SD) | 812.64 (990.41)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.38 (21.92)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.83 (22.48)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.86 (14.04)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.59 (20.89)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 57 (80.28 %)  
|  |  | Mean (SD) | 549.86 (623.05)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 58 (81.69 %)  
|  |  | Mean (SD) | 604.00 (1,050.42)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.43)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.40)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 89.31 (329.54)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 89.37 (295.29)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 100.49 (379.93)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 94.63 (307.04)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12,536.55 (46,614.74)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 289.25 (1,215.14)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,384.64 (14,803.58)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 380.78 (1,901.85)  
cohort_3; >50; overall  
overall | overall | number records | N | 12  
|  | number subjects | N | 12  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.29)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.33 (0.65)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 11 (91.67 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 9 (75.00 %)  
|  |  | Mean (SD) | 78.67 (124.33)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.42 (1.44)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 15.92 (51.75)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.42 (25.85)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.42 (1.44)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 9 (75.00 %)  
|  |  | Mean (SD) | 297.33 (480.46)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 11 (91.67 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.29)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.33 (0.65)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 66.25 (229.50)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 76.75 (263.98)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 66.25 (229.50)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 76.75 (263.98)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,180.08 (17,438.09)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 38.85 (114.76)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 162.86 (564.15)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.71)  
cohort_3; <=50; Female  
overall | overall | number records | N | 33  
|  | number subjects | N | 33  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.50)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.15 (0.36)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 26 (78.79 %)  
|  |  | Mean (SD) | 1,976.43 (3,464.24)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 28 (84.85 %)  
|  |  | Mean (SD) | 1,047.60 (1,292.92)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.97 (18.47)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.18 (9.59)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.18 (9.59)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.94 (18.40)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 28 (84.85 %)  
|  |  | Mean (SD) | 309.40 (339.47)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 26 (78.79 %)  
|  |  | Mean (SD) | 535.29 (600.76)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.42)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.15 (0.36)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 106.03 (327.99)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 45.85 (161.64)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 117.42 (363.26)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 45.85 (161.64)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 14,435.20 (54,907.07)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 231.40 (764.49)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,669.78 (11,540.00)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 91.37 (284.10)  
cohort_3; <=50; Male  
overall | overall | number records | N | 38  
|  | number subjects | N | 38  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.59)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.32 (0.62)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 32 (84.21 %)  
|  |  | Mean (SD) | 470.33 (707.54)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 29 (76.32 %)  
|  |  | Mean (SD) | 682.11 (839.34)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.74 (24.77)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 10.00 (29.22)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.32 (16.99)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.29 (23.08)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 29 (76.32 %)  
|  |  | Mean (SD) | 683.44 (719.01)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 32 (84.21 %)  
|  |  | Mean (SD) | 684.17 (1,483.47)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.18 (0.46)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.43)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 74.79 (334.57)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 127.16 (373.12)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 85.79 (398.10)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 137.00 (389.61)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 10,887.73 (38,698.41)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 339.49 (1,510.79)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6,005.45 (17,279.29)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 632.10 (2,575.59)  
cohort_3; >50; Female  
overall | overall | number records | N | 6  
|  | number subjects | N | 6  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.84)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 6 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 4 (66.67 %)  
|  |  | Mean (SD) | 118.00 (147.08)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 30.17 (73.40)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 15.17 (36.66)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 4 (66.67 %)  
|  |  | Mean (SD) | 441.00 (581.24)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 6 (100.00 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.84)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 152.83 (373.38)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 152.83 (373.38)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 10,093.49 (24,710.83)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 11.03 (21.16)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
cohort_3; >50; Male  
overall | overall | number records | N | 6  
|  | number subjects | N | 6  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 5 (83.33 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 5 (83.33 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.83 (2.04)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.67 (4.08)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.67 (4.08)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.83 (2.04)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 5 (83.33 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 5 (83.33 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 132.50 (324.56)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.67 (1.63)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 132.50 (324.56)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.67 (1.63)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 266.67 (653.20)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 66.67 (163.30)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 325.71 (797.83)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.41 (1.00)  
cohort_3; overall; overall  
overall | overall | number records | N | 83  
|  | number subjects | N | 83  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.52)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.25 (0.54)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 69 (83.13 %)  
|  |  | Mean (SD) | 1,235.36 (2,514.90)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 66 (79.52 %)  
|  |  | Mean (SD) | 683.12 (939.21)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.08 (20.50)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.14 (28.30)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.37 (16.11)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.41 (19.53)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 66 (79.52 %)  
|  |  | Mean (SD) | 505.29 (595.07)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 69 (83.13 %)  
|  |  | Mean (SD) | 633.50 (1,015.23)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.18 (0.42)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.44)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 85.98 (315.96)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 87.54 (289.49)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 95.54 (361.16)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 92.05 (299.78)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 11,472.97 (43,617.78)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 253.05 (1,126.99)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,629.69 (13,803.33)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 325.75 (1,762.34)  
cohort_3; overall; Female  
overall | overall | number records | N | 39  
|  | number subjects | N | 39  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.47)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.47)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 32 (82.05 %)  
|  |  | Mean (SD) | 1,976.43 (3,464.24)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 32 (82.05 %)  
|  |  | Mean (SD) | 782.00 (1,150.56)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.59 (17.27)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.33 (29.73)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.03 (16.54)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.56 (17.20)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 32 (82.05 %)  
|  |  | Mean (SD) | 347.00 (370.48)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 32 (82.05 %)  
|  |  | Mean (SD) | 535.29 (600.76)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.18 (0.39)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.47)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 89.72 (303.47)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 62.31 (204.63)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 99.36 (336.10)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 62.31 (204.63)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 13,767.25 (51,201.87)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 197.50 (706.19)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,951.35 (10,726.51)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 77.32 (262.84)  
cohort_3; overall; Male  
overall | overall | number records | N | 44  
|  | number subjects | N | 44  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.23 (0.57)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.30 (0.59)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 37 (84.09 %)  
|  |  | Mean (SD) | 494.29 (649.00)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 34 (77.27 %)  
|  |  | Mean (SD) | 613.90 (820.20)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.52 (23.19)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.86 (27.30)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.68 (15.91)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.27 (21.58)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 34 (77.27 %)  
|  |  | Mean (SD) | 616.10 (710.56)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 37 (84.09 %)  
|  |  | Mean (SD) | 731.71 (1,360.05)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.18 (0.45)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.23 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 82.66 (330.11)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 109.91 (348.88)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 92.16 (385.86)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 118.41 (364.49)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9,439.40 (36,086.67)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 302.29 (1,405.73)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,230.94 (16,151.59)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 545.96 (2,399.19)  
  
## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/articles/summarise_treatments.html

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

# Summarise treatments

Source: [`vignettes/summarise_treatments.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/summarise_treatments.Rmd)

`summarise_treatments.Rmd`

## Introduction

After creating a study cohort, for example of some specific condition of interest, we may be interested in describing the treatments received by the individuals within it. Here we show how such a summary can be obtained.

### Create mock table

We will use mock data contained in the package throughout the vignette. Let’s modify cohort tables `cohort1` and `cohort2` in our mock dataset, so the first table includes 3 cohorts of health conditions (our study cohorts), while the second contains three are of treatments they could receive.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividual = 200)
    
    new_cohort_set <- [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1) |>
      dplyr::[arrange](https://dplyr.tidyverse.org/reference/arrange.html)(cohort_definition_id) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_name = [c](https://rdrr.io/r/base/c.html)("asthma", "bronchitis", "pneumonia"))
    
    cdm$cohort1 <- cdm$cohort1 |>
      omopgenerics::[newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)(cohortSetRef = new_cohort_set)
    
    new_cohort_set <- [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2) |>
      dplyr::[arrange](https://dplyr.tidyverse.org/reference/arrange.html)(cohort_definition_id) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_name = [c](https://rdrr.io/r/base/c.html)("albuterol", "fluticasone", "montelukast"))
    
    cdm$cohort2 <- cdm$cohort2 |>
      omopgenerics::[newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)(cohortSetRef = new_cohort_set)

Notice that `cohort1` is a cohort table with three cohorts representing three different conditions:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)
    #> # A tibble: 3 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 asthma     
    #> 2                    2 bronchitis 
    #> 3                    3 pneumonia

And `cohort2` is a cohort table with three different treatment cohorts:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2)
    #> # A tibble: 3 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 albuterol  
    #> 2                    2 fluticasone
    #> 3                    3 montelukast

## Summarise treatment

The `[summariseTreatment()](../reference/summariseTreatment.html)` function produces a summary of the treatment received by our study cohorts. There are three mandatory arguments:

  1. `cohort`: cohort from the cdm object.
  2. `treatmentCohortName`: name of the treatment cohort table.
  3. `window`: a list specifying the time windows during which treatments should be summarised.



See an example of its usage below, where we use `[summariseTreatment()](../reference/summariseTreatment.html)` to summarise treatments defined in `cohort2` in the target cohorts defined in `cohort1`.
    
    
    [summariseTreatment](../reference/summariseTreatment.html)(
      cohort = cdm$cohort1,
      treatmentCohortName = [c](https://rdrr.io/r/base/c.html)("cohort2"),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, 30))
    )

### strata parameter

We can also stratify our cohort and calculate the estimates within each strata group by using the `strata` parameter.
    
    
    cdm[["cohort1"]] <- cdm[["cohort1"]] |>
      PatientProfiles::[addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      PatientProfiles::[addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)("<40" = [c](https://rdrr.io/r/base/c.html)(0, 39), ">=40" = [c](https://rdrr.io/r/base/c.html)(40, 150)))
    
    results <- [summariseTreatment](../reference/summariseTreatment.html)(
      cohort = cdm$cohort1,
      treatmentCohortName = [c](https://rdrr.io/r/base/c.html)("cohort2"),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      treatmentCohortId = 1,
      strata = [list](https://rdrr.io/r/base/list.html)("sex", "age_group")
    )

Notice that we have also used the `treatmentCohortId` parameter to specify that we only want to explore `albuterol` (which corresponds to the cohort id 1 in our cohort table) across the cohorts defined in `cohort1`.

### other parameters

The `[summariseTreatment()](../reference/summariseTreatment.html)` functions also has other input parameters which can be tuned:

  * `cohortId`: to restrict the analysis to a particular cohort definition id in the target cohort.
  * `indexDate`: what column to use as the index date to start the analysis. By default we use `cohort_start_date`, but any other date column, such as `cohort_end_date`, can be specified instead.
  * `censorDate`: whether to end the analysis at any specific date. Otherwise we will follow the individuals until end of their respective observation period.
  * `mutuallyExclusive`: by default set to FALSE, this will consider the treatments separately, so an individual can belong to different treatment groups at the same time (i.e. if they are treated with multiple drugs). Therefore, for each target cohort, we could have a sum of percentages of all treatment drugs greater than 100%. If set to TRUE, non-overlapping treatment groups will be assessed (with multiple drugs in some of those if needed), so that all individuals will belong to only one of them, and the percentages will add up to a 100.


    
    
    result_not_mutually_exc <- [summariseTreatment](../reference/summariseTreatment.html)(
      cohort = cdm$cohort1,
      treatmentCohortName = [c](https://rdrr.io/r/base/c.html)("cohort2"),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0))
    )
    #> ℹ Intersect with medications table (cohort2)
    #> ℹ Summarising medications.
    
    result_mutually_exc <- [summariseTreatment](../reference/summariseTreatment.html)(
      cohort = cdm$cohort1,
      treatmentCohortName = [c](https://rdrr.io/r/base/c.html)("cohort2"),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      mutuallyExclusive = TRUE
    )
    #> ℹ Intersect with medications table (cohort2)
    #> ℹ Summarising medications.
    
    [tableTreatment](../reference/tableTreatment.html)(result = result_not_mutually_exc)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
    #> are missing in `columnOrder`, will be added last.

|  CDM name  
---|---  
|  DUS MOCK  
Treatment | Estimate name |  Cohort name  
asthma | bronchitis | pneumonia  
Medication on index date  
albuterol | N (%) | 5 (7.58 %) | 6 (11.76 %) | 7 (8.43 %)  
fluticasone | N (%) | 10 (15.15 %) | 5 (9.80 %) | 9 (10.84 %)  
montelukast | N (%) | 6 (9.09 %) | 5 (9.80 %) | 2 (2.41 %)  
untreated | N (%) | 45 (68.18 %) | 35 (68.63 %) | 65 (78.31 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
      
    
    [tableTreatment](../reference/tableTreatment.html)(result = result_mutually_exc)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
    #> are missing in `columnOrder`, will be added last.

|  CDM name  
---|---  
|  DUS MOCK  
Treatment | Estimate name |  Cohort name  
asthma | bronchitis | pneumonia  
Medication on index date  
albuterol | N (%) | 5 (7.58 %) | 6 (11.76 %) | 7 (8.43 %)  
fluticasone | N (%) | 10 (15.15 %) | 5 (9.80 %) | 9 (10.84 %)  
montelukast | N (%) | 6 (9.09 %) | 5 (9.80 %) | 2 (2.41 %)  
albuterol and fluticasone | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
albuterol and montelukast | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
fluticasone and montelukast | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
albuterol and fluticasone and montelukast | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
untreated | N (%) | 45 (68.18 %) | 35 (68.63 %) | 65 (78.31 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
  
In this case, as no individual was given more than one of the treatment drugs, the percentages are the same. However, we can easily see how these analyses would provide different results in other contexts.

## Visualise results

The package includes `table` and `plot` functions to help visualise the results from `[summariseTreatment()](../reference/summariseTreatment.html)`, like we have just used to show the results above.

### Tables

The `[tableTreatment()](../reference/tableTreatment.html)` function generates a table in gt, flextable, or tibble format from the summarised_result produced by `[summariseTreatment()](../reference/summariseTreatment.html)`. This function has customisation options to format the table according to user preferences.
    
    
    [tableTreatment](../reference/tableTreatment.html)(result = results)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
    #> are missing in `columnOrder`, will be added last.

|  CDM name  
---|---  
|  DUS MOCK  
Sex | Age group | Treatment | Estimate name |  Cohort name  
asthma | bronchitis | pneumonia  
Medication on index date  
overall | overall | albuterol | N (%) | 5 (7.58 %) | 6 (11.76 %) | 7 (8.43 %)  
|  | untreated | N (%) | 61 (92.42 %) | 45 (88.24 %) | 76 (91.57 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
Female | overall | albuterol | N (%) | 2 (6.90 %) | 3 (11.11 %) | 2 (5.13 %)  
|  | untreated | N (%) | 27 (93.10 %) | 24 (88.89 %) | 37 (94.87 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
Male | overall | albuterol | N (%) | 3 (8.11 %) | 3 (12.50 %) | 5 (11.36 %)  
|  | untreated | N (%) | 34 (91.89 %) | 21 (87.50 %) | 39 (88.64 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
overall | <40 | albuterol | N (%) | 5 (9.80 %) | 6 (13.64 %) | 4 (6.67 %)  
|  | untreated | N (%) | 46 (90.20 %) | 38 (86.36 %) | 56 (93.33 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| >=40 | albuterol | N (%) | 0 (0.00 %) | 0 (0.00 %) | 3 (13.04 %)  
|  | untreated | N (%) | 15 (100.00 %) | 7 (100.00 %) | 20 (86.96 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
  
### Plots

The `[plotTreatment()](../reference/plotTreatment.html)` function creates a bar plot showing the percentage of treated and untreated in each cohort, stratum, and time-window. This function offers customization options for colors, faceting, and handling of strata.
    
    
    [plotTreatment](../reference/plotTreatment.html)(
      result = results,
      facet =  sex + age_group ~ window_name + cohort_name,
      colour = "variable_level"
    )

![](summarise_treatments_files/figure-html/unnamed-chunk-9-1.png)

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/articles/treatment_discontinuation.html

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

---

## Content from https://darwin-eu.github.io/DrugUtilisation/articles/drug_restart.html

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

# Assessing drug restart and switching after treatment

Source: [`vignettes/drug_restart.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/drug_restart.Rmd)

`drug_restart.Rmd`

## Introduction

Obtaining information on drug restart or switching to another drug after discontinuation of the original treatment is often of interest in drug utilisation studies. In this vignette, we show how to assess drug switching and restart with this package.

## Data

### Connect to mock data

For this vignette we will use mock data contained in the DrugUtilisation package.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividual = 200)

### Generate study cohorts

We will examine the patterns of drug restart and switching among patients taking metformin as an example. Specifically, we will investigate whether patients restart metformin after discontinuation, switch to insulin, try both medications, or remain untreated.

For this we will need two cohorts: one of patients exposed to metformin and another of patients exposed to insulin.
    
    
    # codelists
    metformin <- CodelistGenerator::[getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "metformin")
    insulin <- CodelistGenerator::[getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "insulin detemir")
    
    cdm <- [generateDrugUtilisationCohortSet](../reference/generateDrugUtilisationCohortSet.html)(
      cdm = cdm, name = "metformin", conceptSet = metformin
    )
    cdm$metformin |>
      [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)()
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            107              92
    
    cdm <- [generateDrugUtilisationCohortSet](../reference/generateDrugUtilisationCohortSet.html)(
      cdm = cdm, name = "insulin", conceptSet = insulin
    )
    cdm$insulin |>
      [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)()
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             93              85

## Assess drug restart

The `[summariseDrugRestart()](../reference/summariseDrugRestart.html)` function analyses the outcomes within a treatment cohort following the first exposure to a specific drug. It categorises the events into four distinct groups:

  * Restarting the same treatment.

  * Switching to a different treatment.

  * Restarting the same treatment while also switching to another.

  * Discontinuing treatment altogether (neither the original treatment nor any potential switch).




The figure below illustrates the analysis, focusing on the outcomes after the initial exposure to a particular drug (in blue), with consideration of a specific switch drug (in orange). This study examines what occurs within 100, 180, and 365 days following first treatment discontinuation in the cohort.

![](figures/drug_restart_A.png)

Now, let’s use the function to assess metformin restart and switch to insulin after the first metformin treatment.
    
    
    results <- cdm$metformin |>
      [summariseDrugRestart](../reference/summariseDrugRestart.html)(
        switchCohortTable = "insulin",
        switchCohortId = NULL,
        strata = [list](https://rdrr.io/r/base/list.html)(),
        followUpDays = Inf,
        censorDate = NULL,
        restrictToFirstDiscontinuation = TRUE
      )
    
    results |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 8
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "6809_metformin", "6809_metformin", "6809_metformin",…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Drug restart till end of observation", "Drug restart…
    #> $ variable_level   <chr> "restart", "restart", "switch", "switch", "restart an…
    #> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
    #> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
    #> $ estimate_value   <chr> "13", "14.1304347826087", "3", "3.26086956521739", "2…
    #> $ additional_name  <chr> "follow_up_days", "follow_up_days", "follow_up_days",…
    #> $ additional_level <chr> "inf days", "inf days", "inf days", "inf days", "inf …

We could be interested in getting these results in different follow-up periods since the first metformin exposure ended. For instance, next we get the results in the first 180 days, the first year, and until the end of observation.
    
    
    results <- cdm$metformin |>
      [summariseDrugRestart](../reference/summariseDrugRestart.html)(
        switchCohortTable = "insulin",
        switchCohortId = NULL,
        strata = [list](https://rdrr.io/r/base/list.html)(),
        followUpDays = [c](https://rdrr.io/r/base/c.html)(180, 365, Inf),
        censorDate = NULL,
        restrictToFirstDiscontinuation = TRUE
      )

Other options that this function allows are:

  * **restrictToFirstDiscontinuation**



By default this argument is set to TRUE, which means that we only consider the firsts exposure of the subject. If FALSE, the analysis is conducted on a record level, considering all exposures in the cohort, as the following image illustrates:

![](figures/drug_restart_B.png)

  * **censorEndDate**



This argument allows to stop considering restart and switch events after a certain date, which must specified as a column in the cohort.

  * **incident**



This argument is by default TRUE, which means we will only consider switch treatments starting after discontinuation. If set to FALSE, we will allow switch treatments starting before the discontinuation of the treatment and ending afterwards.

  * **followUpDays**



The follow-up of the individuals will be set to Inf by default, i.e. we will follow them up for as long as possible. However, we can restrict the follow-up period to any other time interval as seen in the previous example.

  * **strata**



This argument must be a list pointing to columns or combinations of columns in the cohort to use as strata. It will produce stratified estimates as well as for the overall cohort.

For instance, we reproduce the last calculation but this time straifying by sex. We first use PatientProfiles to add a column indicating the sex, which later we use in strata.
    
    
    results <- cdm$cohort1 |>
      PatientProfiles::[addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)(name = "cohort1") |>
      [summariseDrugRestart](../reference/summariseDrugRestart.html)(
        switchCohortTable = "insulin",
        switchCohortId = NULL,
        strata = [list](https://rdrr.io/r/base/list.html)("sex"),
        followUpDays = [c](https://rdrr.io/r/base/c.html)(180, 365, Inf),
        censorDate = NULL,
        restrictToFirstDiscontinuation = TRUE
      )

## Visualise drug restart

The package has table and plot functions to help visualising the results from `[summariseDrugRestart()](../reference/summariseDrugRestart.html)`.

### Table

The function `[tableDrugRestart()](../reference/tableDrugRestart.html)` will create a gt, flextable or tibble table from the summarised_result object created with `[summariseDrugRestart()](../reference/summariseDrugRestart.html)`. This function offers multiple customisation options to format the resulting table according to the user preferences.
    
    
    results |>
      [tableDrugRestart](../reference/tableDrugRestart.html)()
    #> Warning: cdm_name, cohort_name, variable_name, follow_up_days, censor_date,
    #> cohort_table_name, incident, restrict_to_first_discontinuation, and
    #> switch_cohort_table are missing in `columnOrder`, will be added last.

|  CDM name  
---|---  
|  DUS MOCK  
Sex | Treatment | Estimate name |  Cohort name  
cohort_1 | cohort_2 | cohort_3  
Drug restart in 180 days  
overall | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 3 (4.55 %) | 3 (5.88 %) | 4 (4.82 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 63 (95.45 %) | 48 (94.12 %) | 79 (95.18 %)  
Female | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 2 (6.90 %) | 2 (7.41 %) | 3 (7.69 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 27 (93.10 %) | 25 (92.59 %) | 36 (92.31 %)  
Male | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 1 (2.70 %) | 1 (4.17 %) | 1 (2.27 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 36 (97.30 %) | 23 (95.83 %) | 43 (97.73 %)  
Drug restart in 365 days  
overall | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 3 (4.55 %) | 5 (9.80 %) | 5 (6.02 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 63 (95.45 %) | 46 (90.20 %) | 78 (93.98 %)  
Female | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 2 (6.90 %) | 3 (11.11 %) | 4 (10.26 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 27 (93.10 %) | 24 (88.89 %) | 35 (89.74 %)  
Male | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 1 (2.70 %) | 2 (8.33 %) | 1 (2.27 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 36 (97.30 %) | 22 (91.67 %) | 43 (97.73 %)  
Drug restart till end of observation  
overall | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 5 (7.58 %) | 8 (15.69 %) | 8 (9.64 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 61 (92.42 %) | 43 (84.31 %) | 75 (90.36 %)  
Female | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 4 (13.79 %) | 5 (18.52 %) | 6 (15.38 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 25 (86.21 %) | 22 (81.48 %) | 33 (84.62 %)  
Male | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 1 (2.70 %) | 3 (12.50 %) | 2 (4.55 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 36 (97.30 %) | 21 (87.50 %) | 42 (95.45 %)  
  
### Plot

The `[plotDrugRestart()](../reference/plotDrugRestart.html)` function creates a bar plot depicting the percentage of drug restart events for each cohort, stratum, and follow-up time (specified in the variable_name column of the summarised result). This function offers customisation options for colours, facetting, and handling of strata.
    
    
    results |>
      [plotDrugRestart](../reference/plotDrugRestart.html)(facet = cohort_name + sex ~ follow_up_days)

![](drug_restart_files/figure-html/unnamed-chunk-10-1.png)

### Adding the information to an existing cohort

We can directly add the drug restart information to an existing cohort as a column instead of asking for a summarising object. In this case we will use the function `[addDrugRestart()](../reference/addDrugRestart.html)`, which will add one column per follow-up window we ask for:
    
    
    cdm$metformin |>
      [addDrugRestart](../reference/addDrugRestart.html)(
        switchCohortTable = "insulin",
        switchCohortId = NULL,
        followUpDays = [c](https://rdrr.io/r/base/c.html)(180, 365, Inf),
        censorDate = NULL
      ) |>
      gt::[gt](https://gt.rstudio.com/reference/gt.html)()

cohort_definition_id | subject_id | cohort_start_date | cohort_end_date | drug_restart_180 | drug_restart_365 | drug_restart_inf  
---|---|---|---|---|---|---  
1 | 103 | 2010-11-18 | 2014-07-23 | restart | restart | restart  
1 | 59 | 2019-09-08 | 2020-06-19 | untreated | untreated | restart  
1 | 116 | 2016-12-01 | 2017-06-29 | untreated | untreated | restart  
1 | 69 | 2020-04-28 | 2020-10-03 | restart | restart | restart  
1 | 129 | 2020-01-10 | 2020-08-31 | restart | restart | restart  
1 | 98 | 2014-07-10 | 2016-02-06 | restart | restart | restart  
1 | 99 | 2020-03-12 | 2020-04-10 | untreated | untreated | restart  
1 | 128 | 2021-08-20 | 2021-08-20 | restart | restart | restart  
1 | 19 | 2009-03-10 | 2011-04-27 | untreated | restart | restart  
1 | 191 | 2019-11-02 | 2020-04-17 | restart | restart | restart  
1 | 54 | 1987-06-05 | 1990-04-03 | restart | restart | restart  
1 | 4 | 2009-05-01 | 2009-11-27 | untreated | restart | restart  
1 | 121 | 2019-05-17 | 2019-11-13 | restart | restart | restart  
1 | 48 | 2021-07-21 | 2021-12-05 | untreated | untreated | untreated  
1 | 152 | 2021-10-24 | 2021-12-02 | untreated | untreated | untreated  
1 | 191 | 2020-05-17 | 2020-05-19 | untreated | untreated | untreated  
1 | 127 | 2019-09-07 | 2019-09-15 | untreated | untreated | untreated  
1 | 99 | 2021-05-16 | 2021-06-22 | untreated | untreated | untreated  
1 | 78 | 2016-08-20 | 2016-11-02 | untreated | untreated | untreated  
1 | 151 | 2005-05-06 | 2007-12-30 | untreated | untreated | untreated  
1 | 51 | 2014-09-11 | 2017-09-02 | untreated | untreated | untreated  
1 | 111 | 2021-03-01 | 2022-06-28 | untreated | untreated | untreated  
1 | 68 | 2003-04-21 | 2007-10-04 | untreated | untreated | untreated  
1 | 118 | 2010-04-22 | 2013-07-06 | untreated | untreated | untreated  
1 | 181 | 1987-06-02 | 1997-12-15 | untreated | untreated | untreated  
1 | 187 | 1994-10-31 | 1996-09-28 | untreated | untreated | untreated  
1 | 114 | 2021-03-19 | 2021-06-24 | untreated | untreated | untreated  
1 | 56 | 2017-05-04 | 2018-03-04 | untreated | untreated | untreated  
1 | 199 | 2020-04-16 | 2020-04-25 | untreated | untreated | untreated  
1 | 4 | 2010-07-25 | 2011-12-11 | untreated | untreated | untreated  
1 | 70 | 2018-01-01 | 2018-08-23 | untreated | untreated | untreated  
1 | 11 | 2007-04-03 | 2007-05-07 | untreated | untreated | untreated  
1 | 36 | 1999-08-07 | 2004-01-08 | untreated | untreated | untreated  
1 | 34 | 2018-09-26 | 2018-10-02 | untreated | untreated | untreated  
1 | 108 | 2001-09-04 | 2007-10-06 | untreated | untreated | untreated  
1 | 137 | 2020-06-16 | 2020-07-01 | untreated | untreated | untreated  
1 | 80 | 2018-08-03 | 2018-09-08 | untreated | untreated | untreated  
1 | 132 | 2007-05-18 | 2008-04-24 | untreated | untreated | untreated  
1 | 175 | 2022-09-13 | 2022-09-27 | untreated | untreated | untreated  
1 | 174 | 2019-05-21 | 2019-06-13 | untreated | untreated | untreated  
1 | 194 | 2022-02-16 | 2022-03-10 | untreated | untreated | untreated  
1 | 35 | 2014-12-01 | 2016-04-11 | untreated | untreated | untreated  
1 | 47 | 2016-02-29 | 2016-09-10 | untreated | untreated | untreated  
1 | 69 | 2021-01-06 | 2021-01-19 | untreated | untreated | untreated  
1 | 125 | 2013-01-13 | 2013-07-15 | untreated | untreated | untreated  
1 | 38 | 2000-03-27 | 2003-07-03 | untreated | untreated | untreated  
1 | 43 | 1972-03-04 | 1990-03-14 | untreated | untreated | untreated  
1 | 16 | 2019-03-19 | 2019-10-19 | untreated | untreated | untreated  
1 | 45 | 2020-11-27 | 2020-12-18 | untreated | untreated | untreated  
1 | 116 | 2019-01-28 | 2019-03-06 | untreated | untreated | untreated  
1 | 65 | 2004-09-04 | 2015-07-24 | untreated | untreated | untreated  
1 | 82 | 2004-02-25 | 2008-06-14 | untreated | untreated | untreated  
1 | 169 | 2016-03-29 | 2020-10-15 | untreated | untreated | untreated  
1 | 12 | 1991-08-30 | 1994-01-03 | untreated | untreated | untreated  
1 | 107 | 2021-07-04 | 2021-07-08 | untreated | untreated | untreated  
1 | 172 | 2003-07-30 | 2005-08-24 | untreated | untreated | untreated  
1 | 155 | 1999-08-04 | 2001-12-26 | untreated | untreated | untreated  
1 | 185 | 1993-07-02 | 1999-05-12 | untreated | untreated | untreated  
1 | 124 | 2021-07-09 | 2022-08-07 | untreated | untreated | untreated  
1 | 22 | 1958-05-12 | 1975-05-23 | untreated | untreated | untreated  
1 | 183 | 1999-12-27 | 2003-01-03 | untreated | untreated | untreated  
1 | 19 | 2011-12-01 | 2014-01-15 | untreated | untreated | untreated  
1 | 143 | 2020-11-20 | 2020-11-21 | untreated | untreated | untreated  
1 | 40 | 2022-07-02 | 2022-07-09 | untreated | untreated | untreated  
1 | 130 | 2019-01-01 | 2019-07-20 | untreated | untreated | untreated  
1 | 54 | 1990-06-01 | 1990-06-26 | untreated | untreated | untreated  
1 | 7 | 2010-01-08 | 2011-05-13 | untreated | untreated | untreated  
1 | 179 | 2017-08-07 | 2017-08-11 | untreated | untreated | untreated  
1 | 177 | 2022-02-05 | 2022-03-17 | untreated | untreated | untreated  
1 | 20 | 2018-01-25 | 2018-03-07 | untreated | untreated | untreated  
1 | 25 | 2006-05-08 | 2009-02-17 | untreated | untreated | untreated  
1 | 31 | 2019-07-28 | 2019-12-28 | untreated | untreated | untreated  
1 | 123 | 1982-07-20 | 1982-08-03 | untreated | untreated | untreated  
1 | 86 | 2008-04-13 | 2013-09-23 | untreated | untreated | untreated  
1 | 95 | 2000-12-05 | 2001-09-12 | untreated | untreated | untreated  
1 | 166 | 2004-01-31 | 2014-03-25 | untreated | untreated | untreated  
1 | 57 | 2010-12-03 | 2013-03-16 | untreated | untreated | untreated  
1 | 66 | 2006-09-07 | 2006-09-25 | untreated | untreated | untreated  
1 | 192 | 1981-09-01 | 1985-05-07 | untreated | untreated | untreated  
1 | 67 | 2009-09-27 | 2012-08-13 | untreated | untreated | untreated  
1 | 98 | 2016-05-09 | 2017-03-17 | untreated | untreated | untreated  
1 | 171 | 2000-01-18 | 2002-04-03 | untreated | untreated | untreated  
1 | 121 | 2020-05-04 | 2021-09-09 | untreated | untreated | untreated  
1 | 129 | 2020-11-08 | 2020-11-22 | untreated | untreated | untreated  
1 | 21 | 2015-10-09 | 2018-01-10 | untreated | untreated | untreated  
1 | 73 | 2019-09-04 | 2019-10-15 | untreated | untreated | untreated  
1 | 140 | 1997-04-09 | 1999-02-14 | untreated | untreated | untreated  
1 | 103 | 2014-10-08 | 2020-01-23 | untreated | untreated | untreated  
1 | 144 | 2011-12-07 | 2013-03-06 | untreated | untreated | untreated  
1 | 128 | 2021-09-30 | 2021-10-07 | untreated | untreated | untreated  
1 | 102 | 2009-03-20 | 2009-09-23 | untreated | untreated | untreated  
1 | 196 | 2000-11-04 | 2004-05-07 | untreated | untreated | untreated  
1 | 158 | 2015-01-16 | 2018-11-30 | untreated | untreated | untreated  
1 | 3 | 2001-07-12 | 2002-03-10 | untreated | untreated | untreated  
1 | 76 | 2013-05-10 | 2019-10-08 | untreated | untreated | untreated  
1 | 110 | 1980-11-27 | 1984-11-11 | untreated | untreated | untreated  
1 | 74 | 2008-03-21 | 2017-06-02 | untreated | untreated | untreated  
1 | 134 | 2016-04-21 | 2017-01-31 | untreated | untreated | untreated  
1 | 59 | 2021-10-24 | 2022-03-31 | untreated | untreated | untreated  
1 | 92 | 2022-09-29 | 2022-10-11 | untreated | untreated | untreated  
1 | 71 | 2010-10-25 | 2011-12-13 | untreated | untreated | untreated  
1 | 136 | 2012-12-09 | 2013-11-15 | untreated | restart | restart and switch  
1 | 177 | 2012-12-18 | 2014-07-01 | untreated | untreated | restart and switch  
1 | 136 | 2014-09-03 | 2015-10-01 | untreated | switch | switch  
1 | 29 | 2022-12-12 | 2022-12-15 | switch | switch | switch  
1 | 15 | 2012-11-05 | 2019-04-21 | switch | switch | switch  
1 | 186 | 2004-12-30 | 2006-09-08 | untreated | untreated | switch  
  
## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/news/index.html

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

# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/NEWS.md)

## DrugUtilisation 1.0.4

CRAN release: 2025-07-02

  * Fix plotDrugUtilisation combining different cdm_name by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 1.0.3

CRAN release: 2025-06-03

  * Skip some tests for regression in duckdb by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 1.0.2

CRAN release: 2025-05-13

  * Add examples of atc and ingredient documentation by [@catalamarti](https://github.com/catalamarti)
  * Add summariseTreatment input information in vignette by [@KimLopezGuell](https://github.com/KimLopezGuell)
  * Drug restart documentation by [@KimLopezGuell](https://github.com/KimLopezGuell)
  * Add drug utilisation documentation by [@KimLopezGuell](https://github.com/KimLopezGuell)
  * Update equation daily dose vignette by [@KimLopezGuell](https://github.com/KimLopezGuell)
  * Compatibility with omopgenerics 1.2.0 by [@catalamarti](https://github.com/catalamarti)
  * Homogenise examples by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 1.0.1

CRAN release: 2025-04-15

  * lifecycle stable by [@catalamarti](https://github.com/catalamarti)
  * Correct settings to not be NA by [@catalamarti](https://github.com/catalamarti)
  * add .options argument by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 1.0.0

CRAN release: 2025-03-27

  * Stable release.
  * plotPPC between 0 and 100% by [@catalamarti](https://github.com/catalamarti)
  * add observation_period_id in erafy by [@catalamarti](https://github.com/catalamarti)
  * use window_name as factor in plotTreatment/Indication by [@catalamarti](https://github.com/catalamarti)
  * remove lifecycle tags 1.0.0 by [@catalamarti](https://github.com/catalamarti)
  * use mockDisconnect in all tests by [@catalamarti](https://github.com/catalamarti)
  * Change default of tables to hide all settings by [@catalamarti](https://github.com/catalamarti)
  * Test validateNameStyle by [@catalamarti](https://github.com/catalamarti)
  * update requirePriorDrugWashout to <= to align with IncidencePrevalence by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.8.3

CRAN release: 2025-03-20

  * Add +1L to initialExposureDuration to calculate duration as `end - start + 1` by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.8.2

CRAN release: 2025-01-16

  * Fix snowflake edge case with duplicated prescriptions by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.8.1

CRAN release: 2024-12-19

  * Arguments recorded in summarise* functions by [@catalamarti](https://github.com/catalamarti)
  * Improved performance of addIndication, addTreatment, summariseIndication, summariseTreatment by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.8.0

CRAN release: 2024-12-10

### New features

  * Add argument … to generateATC/IngredientCohortSet by [@catalamarti](https://github.com/catalamarti)
  * benchmarkDrugUtilisation to test all functions by [@MimiYuchenGuo](https://github.com/MimiYuchenGuo)
  * Add confidence intervals to PPC by [@catalamarti](https://github.com/catalamarti)
  * Export erafyCohort by [@catalamarti](https://github.com/catalamarti)
  * Add numberExposures and daysPrescribed to generate functions by [@catalamarti](https://github.com/catalamarti)
  * Add subsetCohort and subsetCohortId arguments to cohort creation functions by [@catalamarti](https://github.com/catalamarti)
  * New function: addDrugRestart by [@catalamarti](https://github.com/catalamarti)
  * Add initialExposureDuration by [@catalamarti](https://github.com/catalamarti)
  * add cohortId to summarise* functions by [@catalamarti](https://github.com/catalamarti)
  * addDaysPrescribed by [@catalamarti](https://github.com/catalamarti)
  * plotDrugUtilisation by [@catalamarti](https://github.com/catalamarti)



### Minor updates

  * Account for omopgenerics 0.4.0 by [@catalamarti](https://github.com/catalamarti)
  * Add messages about dropped records in cohort creation by [@catalamarti](https://github.com/catalamarti)
  * Refactor of table functions following visOmopResults 0.5.0 release by [@catalamart](https://github.com/catalamart)
  * Cast settings to characters by [@catalamarti](https://github.com/catalamarti)
  * checkVersion utility function for tables and plots by [@catalamarti](https://github.com/catalamarti)
  * Deprecation warnings to errors for deprecated arguments in geenrateDrugUtilisation by [@catalamarti](https://github.com/catalamarti)
  * Add message if too many indications by [@catalamarti](https://github.com/catalamarti)
  * not treated -> untreated by [@catalamarti](https://github.com/catalamarti)
  * warn overwrite columns by [@catalamarti](https://github.com/catalamarti)
  * Use omopgenerics assert function by [@catalamarti](https://github.com/catalamarti)
  * add documentation helpers for consistent argument documentation by [@catalamarti](https://github.com/catalamarti)
  * exposedTime -> daysExposed by [@catalamarti](https://github.com/catalamarti)
  * Fix cast warning in mock by [@catalamarti](https://github.com/catalamarti)
  * test addDaysPrescribed by [@catalamarti](https://github.com/catalamarti)
  * refactor plots to use visOmopResults plot tools by [@catalamarti](https://github.com/catalamarti)



### Bug fix

  * allow integer64 in sampleSize by [@catalamarti](https://github.com/catalamarti)



## DrugUtilisation 0.7.0

CRAN release: 2024-07-29

  * Deprecate dose specific functions: `addDailyDose`, `addRoute`, `stratifyByUnit`.

  * Deprecate drug use functions: `addDrugUse`, `summariseDrugUse`.

  * Rename `dailyDoseCoverage` -> `summariseDoseCoverage`.

  * Refactor of `addIndication` to create a categorical variable per window.

  * New functionality `summariseProportionOfPatientsCovered`, `tableProportionOfPatientsCovered` and `plotProportionOfPatientsCovered`.

  * Create `require*` functions.

  * New functionality `summariseDrugRestart`, `tableDrugRestart` and `plotDrugRestart`.

  * New functionality `addDrugUtilisation`, `summariseDrugUtilisation` and `tableDrugUtilisation`




## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/mockDrugUtilisation.html

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

# It creates a mock database for testing DrugUtilisation package

Source: [`R/mockDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/mockDrugUtilisation.R)

`mockDrugUtilisation.Rd`

It creates a mock database for testing DrugUtilisation package

## Usage
    
    
    mockDrugUtilisation(
      con = NULL,
      writeSchema = NULL,
      numberIndividuals = 10,
      seed = NULL,
      ...
    )

## Arguments

con
    

A DBIConnection object to a database. If NULL a new duckdb connection will be used.

writeSchema
    

A schema with writing permissions to copy there the cdm tables.

numberIndividuals
    

Number of individuals in the mock cdm.

seed
    

Seed for the random numbers. If NULL no seed is used.

...
    

Tables to use as basis to create the mock. If some tables are provided they will be used to construct the cdm object.

## Value

A cdm reference with the mock tables

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- mockDrugUtilisation()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of DUS MOCK ───────────────────────────────────
    #> • omop tables: person, observation_period, concept, concept_ancestor,
    #> drug_strength, concept_relationship, drug_exposure, condition_occurrence,
    #> observation, visit_occurrence
    #> • cohort tables: cohort1, cohort2
    #> • achilles tables: -
    #> • other tables: -
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html

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

# Generate a set of drug cohorts based on drug ingredients

Source: [`R/generateIngredientCohortSet.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/generateIngredientCohortSet.R)

`generateIngredientCohortSet.Rd`

Adds a new cohort table to the cdm reference with individuals who have drug exposure records with the specified drug ingredient. Cohort start and end dates will be based on drug record start and end dates, respectively. Records that overlap or have fewer days between them than the specified gap era will be concatenated into a single cohort entry.

## Usage
    
    
    generateIngredientCohortSet(
      cdm,
      name,
      ingredient = NULL,
      gapEra = 1,
      subsetCohort = NULL,
      subsetCohortId = NULL,
      numberExposures = FALSE,
      daysPrescribed = FALSE,
      ...
    )

## Arguments

cdm
    

A `cdm_reference` object.

name
    

Name of the new cohort table, it must be a length 1 character vector.

ingredient
    

Accepts both vectors and named lists of ingredient names. For a vector input, e.g., c("acetaminophen", "codeine"), it generates a cohort table with descendant concept codes for each ingredient, assigning unique cohort_definition_id. For a named list input, e.g., list( "test_1" = c("simvastatin", "acetaminophen"), "test_2" = "metformin"), it produces a cohort table based on the structure of the input, where each name leads to a combined set of descendant concept codes for the specified ingredients, creating distinct cohort_definition_id for each named group.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

subsetCohort
    

Cohort table to subset.

subsetCohortId
    

Cohort id to subset.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

daysPrescribed
    

Whether to include 'days_prescribed' (number of days prescribed used to create each era).

...
    

Arguments to be passed to `[CodelistGenerator::getDrugIngredientCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)`.

## Value

The function returns the cdm reference provided with the addition of the new cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm <- generateIngredientCohortSet(cdm = cdm,
                                       ingredient = "acetaminophen",
                                       name = "acetaminophen")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$acetaminophen |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1
    #> $ subject_id           <int> 1, 3, 10, 5, 4, 6, 2
    #> $ cohort_start_date    <date> 2021-08-16, 2007-08-11, 2019-01-10, 2009-11-01, 2…
    #> $ cohort_end_date      <date> 2021-09-15, 2013-10-24, 2020-12-07, 2011-06-22, 2…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/requireIsFirstDrugEntry.html

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

# Restrict cohort to only the first cohort record per subject

Source: [`R/require.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/require.R)

`requireIsFirstDrugEntry.Rd`

Filter the cohort table keeping only the first cohort record per subject.

## Usage
    
    
    requireIsFirstDrugEntry(
      cohort,
      cohortId = NULL,
      name = omopgenerics::[tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

name
    

Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the first entry requirement.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm$cohort1 <- cdm$cohort1 |>
      requireIsFirstDrugEntry()
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 6
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
    #> $ number_records       <int> 6, 6, 2, 2, 2, 2
    #> $ number_subjects      <int> 6, 6, 2, 2, 2, 2
    #> $ reason_id            <int> 1, 2, 1, 2, 1, 2
    #> $ reason               <chr> "Initial qualifying events", "require is the firs…
    #> $ excluded_records     <int> 0, 0, 0, 0, 0, 0
    #> $ excluded_subjects    <int> 0, 0, 0, 0, 0, 0
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/requireObservationBeforeDrug.html

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

# Restrict cohort to only cohort records with the given amount of prior observation time in the database

Source: [`R/require.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/require.R)

`requireObservationBeforeDrug.Rd`

Filter the cohort table keeping only the cohort records for which the individual has the required observation time in the database prior to their cohort start date.

## Usage
    
    
    requireObservationBeforeDrug(
      cohort,
      days,
      cohortId = NULL,
      name = omopgenerics::[tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort_table object.

days
    

Number of days of prior observation required before cohort start date. Any records with fewer days will be dropped.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

name
    

Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the prior observation requirement.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm$cohort1 <- cdm$cohort1 |>
      requireObservationBeforeDrug(days = 365)
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 6
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
    #> $ number_records       <int> 2, 2, 0, 0, 8, 4
    #> $ number_subjects      <int> 2, 2, 0, 0, 8, 4
    #> $ reason_id            <int> 1, 2, 1, 2, 1, 2
    #> $ reason               <chr> "Initial qualifying events", "require prior obser…
    #> $ excluded_records     <int> 0, 0, 0, 0, 0, 4
    #> $ excluded_subjects    <int> 0, 0, 0, 0, 0, 4
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/summariseIndication.html

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

# Summarise the indications of individuals in a drug cohort

Source: [`R/summariseIntersect.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseIntersect.R)

`summariseIndication.Rd`

Summarise the observed indications of patients in a drug cohort based on their presence in an indication cohort in a specified time window. If an individual is not in one of the indication cohorts, they will be considered to have an unknown indication if they are present in one of the specified OMOP CDM clinical tables. Otherwise, if they are neither in an indication cohort or a clinical table they will be considered as having no observed indication.

## Usage
    
    
    summariseIndication(
      cohort,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      indicationCohortName,
      cohortId = NULL,
      indicationCohortId = NULL,
      indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      unknownIndicationTable = NULL,
      indexDate = "cohort_start_date",
      mutuallyExclusive = TRUE,
      censorDate = NULL
    )

## Arguments

cohort
    

A cohort_table object.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

indicationCohortName
    

Name of the cohort table with potential indications.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

indicationCohortId
    

The target cohort ID to add indication. If NULL all cohorts will be considered.

indicationWindow
    

The time window over which to identify indications.

unknownIndicationTable
    

Tables in the OMOP CDM to search for unknown indications.

indexDate
    

Name of a column that indicates the date to start the analysis.

mutuallyExclusive
    

Whether to report indications as mutually exclusive or report them as independent results.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    indications <- [list](https://rdrr.io/r/base/list.html)(headache = 378253, asthma = 317009)
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                                    conceptSet = indications,
                                    name = "indication_cohorts")
    
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       name = "drug_cohort",
                                       ingredient = "acetaminophen")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$drug_cohort |>
      summariseIndication(
        indicationCohortName = "indication_cohorts",
        unknownIndicationTable = "condition_occurrence",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, 0))
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ Intersect with indications table (indication_cohorts)
    #> ℹ Summarising indications.
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Indication any time before or on index date", "Indic…
    #> $ variable_level   <chr> "asthma", "asthma", "headache", "headache", "asthma a…
    #> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
    #> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
    #> $ estimate_value   <chr> "1", "12.5", "0", "0", "2", "25", "2", "25", "3", "37…
    #> $ additional_name  <chr> "window_name", "window_name", "window_name", "window_…
    #> $ additional_level <chr> "-inf to 0", "-inf to 0", "-inf to 0", "-inf to 0", "…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/summariseDrugUtilisation.html

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

# This function is used to summarise the dose utilisation table over multiple cohorts.

Source: [`R/summariseDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseDrugUtilisation.R)

`summariseDrugUtilisation.Rd`

This function is used to summarise the dose utilisation table over multiple cohorts.

## Usage
    
    
    summariseDrugUtilisation(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      estimates = [c](https://rdrr.io/r/base/c.html)("q25", "median", "q75", "mean", "sd", "count_missing",
        "percentage_missing"),
      ingredientConceptId = NULL,
      conceptSet = NULL,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      gapEra = 1,
      numberExposures = TRUE,
      numberEras = TRUE,
      daysExposed = TRUE,
      daysPrescribed = TRUE,
      timeToExposure = TRUE,
      initialExposureDuration = TRUE,
      initialQuantity = TRUE,
      cumulativeQuantity = TRUE,
      initialDailyDose = TRUE,
      cumulativeDose = TRUE
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

estimates
    

Estimates that we want for the columns.

ingredientConceptId
    

Ingredient OMOP concept that we are interested for the study.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

numberEras
    

Whether to include 'number_eras' (number of continuous exposure episodes between indexDate and censorDate).

daysExposed
    

Whether to include 'days_exposed' (number of days that the individual is in a continuous exposure episode, including allowed treatment gaps, between indexDate and censorDate; sum of the length of the different drug eras).

daysPrescribed
    

Whether to include 'days_prescribed' (sum of the number of days for each prescription that contribute in the analysis).

timeToExposure
    

Whether to include 'time_to_exposure' (number of days between indexDate and the first episode).

initialExposureDuration
    

Whether to include 'initial_exposure_duration' (number of prescribed days of the first drug exposure record).

initialQuantity
    

Whether to include 'initial_quantity' (quantity of the first drug exposure record).

cumulativeQuantity
    

Whether to include 'cumulative_quantity' (sum of the quantity of the different exposures considered in the analysis).

initialDailyDose
    

Whether to include 'initial_daily_dose_{unit}' (daily dose of the first considered prescription).

cumulativeDose
    

Whether to include 'cumulative_dose_{unit}' (sum of the cumulative dose of the analysed drug exposure records).

## Value

A summary of drug utilisation stratified by cohort_name and strata_name

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       ingredient = "acetaminophen",
                                       name = "dus_cohort")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      summariseDrugUtilisation(ingredientConceptId = 1125315)
    #> # A tibble: 72 × 13
    #>    result_id cdm_name group_name  group_level   strata_name strata_level
    #>        <int> <chr>    <chr>       <chr>         <chr>       <chr>       
    #>  1         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  2         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  3         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  4         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  5         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  6         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  7         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  8         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  9         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #> 10         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #> # ℹ 62 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/LICENSE.html

Skip to contents

[DrugUtilisation](index.html) 1.0.4

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](articles/mock_data.html)
    * [Creating drug cohorts](articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](articles/indication.html)
    * [Daily dose calculation](articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](articles/drug_utilisation.html)
    * [Summarise treatments](articles/summarise_treatments.html)
    * [Summarising treatment adherence](articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](articles/drug_restart.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](logo.png)

# Apache License

Source: [`LICENSE.md`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/LICENSE.md)

_Version 2.0, January 2004_ _<<http://www.apache.org/licenses/>>_

### Terms and Conditions for use, reproduction, and distribution

#### 1\. Definitions

“License” shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

“Licensor” shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.

“Legal Entity” shall mean the union of the acting entity and all other entities that control, are controlled by, or are under common control with that entity. For the purposes of this definition, “control” means **(i)** the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or **(ii)** ownership of fifty percent (50%) or more of the outstanding shares, or **(iii)** beneficial ownership of such entity.

“You” (or “Your”) shall mean an individual or Legal Entity exercising permissions granted by this License.

“Source” form shall mean the preferred form for making modifications, including but not limited to software source code, documentation source, and configuration files.

“Object” form shall mean any form resulting from mechanical transformation or translation of a Source form, including but not limited to compiled object code, generated documentation, and conversions to other media types.

“Work” shall mean the work of authorship, whether in Source or Object form, made available under the License, as indicated by a copyright notice that is included in or attached to the work (an example is provided in the Appendix below).

“Derivative Works” shall mean any work, whether in Source or Object form, that is based on (or derived from) the Work and for which the editorial revisions, annotations, elaborations, or other modifications represent, as a whole, an original work of authorship. For the purposes of this License, Derivative Works shall not include works that remain separable from, or merely link (or bind by name) to the interfaces of, the Work and Derivative Works thereof.

“Contribution” shall mean any work of authorship, including the original version of the Work and any modifications or additions to that Work or Derivative Works thereof, that is intentionally submitted to Licensor for inclusion in the Work by the copyright owner or by an individual or Legal Entity authorized to submit on behalf of the copyright owner. For the purposes of this definition, “submitted” means any form of electronic, verbal, or written communication sent to the Licensor or its representatives, including but not limited to communication on electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, the Licensor for the purpose of discussing and improving the Work, but excluding communication that is conspicuously marked or otherwise designated in writing by the copyright owner as “Not a Contribution.”

“Contributor” shall mean Licensor and any individual or Legal Entity on behalf of whom a Contribution has been received by Licensor and subsequently incorporated within the Work.

#### 2\. Grant of Copyright License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare Derivative Works of, publicly display, publicly perform, sublicense, and distribute the Work and such Derivative Works in Source or Object form.

#### 3\. Grant of Patent License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this section) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work, where such license applies only to those patent claims licensable by such Contributor that are necessarily infringed by their Contribution(s) alone or by combination of their Contribution(s) with the Work to which such Contribution(s) was submitted. If You institute patent litigation against any entity (including a cross-claim or counterclaim in a lawsuit) alleging that the Work or a Contribution incorporated within the Work constitutes direct or contributory patent infringement, then any patent licenses granted to You under this License for that Work shall terminate as of the date such litigation is filed.

#### 4\. Redistribution

You may reproduce and distribute copies of the Work or Derivative Works thereof in any medium, with or without modifications, and in Source or Object form, provided that You meet the following conditions:

  * **(a)** You must give any other recipients of the Work or Derivative Works a copy of this License; and
  * **(b)** You must cause any modified files to carry prominent notices stating that You changed the files; and
  * **(c)** You must retain, in the Source form of any Derivative Works that You distribute, all copyright, patent, trademark, and attribution notices from the Source form of the Work, excluding those notices that do not pertain to any part of the Derivative Works; and
  * **(d)** If the Work includes a “NOTICE” text file as part of its distribution, then any Derivative Works that You distribute must include a readable copy of the attribution notices contained within such NOTICE file, excluding those notices that do not pertain to any part of the Derivative Works, in at least one of the following places: within a NOTICE text file distributed as part of the Derivative Works; within the Source form or documentation, if provided along with the Derivative Works; or, within a display generated by the Derivative Works, if and wherever such third-party notices normally appear. The contents of the NOTICE file are for informational purposes only and do not modify the License. You may add Your own attribution notices within Derivative Works that You distribute, alongside or as an addendum to the NOTICE text from the Work, provided that such additional attribution notices cannot be construed as modifying the License.



You may add Your own copyright statement to Your modifications and may provide additional or different license terms and conditions for use, reproduction, or distribution of Your modifications, or for any such Derivative Works as a whole, provided Your use, reproduction, and distribution of the Work otherwise complies with the conditions stated in this License.

#### 5\. Submission of Contributions

Unless You explicitly state otherwise, any Contribution intentionally submitted for inclusion in the Work by You to the Licensor shall be under the terms and conditions of this License, without any additional terms or conditions. Notwithstanding the above, nothing herein shall supersede or modify the terms of any separate license agreement you may have executed with Licensor regarding such Contributions.

#### 6\. Trademarks

This License does not grant permission to use the trade names, trademarks, service marks, or product names of the Licensor, except as required for reasonable and customary use in describing the origin of the Work and reproducing the content of the NOTICE file.

#### 7\. Disclaimer of Warranty

Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.

#### 8\. Limitation of Liability

In no event and under no legal theory, whether in tort (including negligence), contract, or otherwise, unless required by applicable law (such as deliberate and grossly negligent acts) or agreed to in writing, shall any Contributor be liable to You for damages, including any direct, indirect, special, incidental, or consequential damages of any character arising as a result of this License or out of the use or inability to use the Work (including but not limited to damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses), even if such Contributor has been advised of the possibility of such damages.

#### 9\. Accepting Warranty or Additional Liability

While redistributing the Work or Derivative Works thereof, You may choose to offer, and charge a fee for, acceptance of support, warranty, indemnity, or other liability obligations and/or rights consistent with this License. However, in accepting such obligations, You may act only on Your own behalf and on Your sole responsibility, not on behalf of any other Contributor, and only if You agree to indemnify, defend, and hold each Contributor harmless for any liability incurred by, or claims asserted against, such Contributor by reason of your accepting any such warranty or additional liability.

_END OF TERMS AND CONDITIONS_

### APPENDIX: How to apply the Apache License to your work

To apply the Apache License to your work, attach the following boilerplate notice, with the fields enclosed by brackets `[]` replaced with your own identifying information. (Don’t include the brackets!) The text should be enclosed in the appropriate comment syntax for the file format. We also recommend that a file or class name and description of purpose be included on the same “printed page” as the copyright notice for easier identification within third-party archives.
    
    
    Copyright [yyyy] [name of copyright owner]
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
      http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/authors.html

Skip to contents

[DrugUtilisation](index.html) 1.0.4

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](articles/mock_data.html)
    * [Creating drug cohorts](articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](articles/indication.html)
    * [Daily dose calculation](articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](articles/drug_utilisation.html)
    * [Summarise treatments](articles/summarise_treatments.html)
    * [Summarising treatment adherence](articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](articles/drug_restart.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](logo.png)

# Authors and Citation

## Authors

  * **Martí Català**. Author, maintainer. [](https://orcid.org/0000-0003-3308-9905)

  * **Mike Du**. Contributor. [](https://orcid.org/0000-0002-9517-8834)

  * **Yuchen Guo**. Author. [](https://orcid.org/0000-0002-0847-4855)

  * **Kim Lopez-Guell**. Author. [](https://orcid.org/0000-0002-8462-8668)

  * **Edward Burn**. Author. [](https://orcid.org/0000-0002-9286-1128)

  * **Xintong Li**. Contributor. [](https://orcid.org/0000-0002-6872-5804)

  * **Marta Alcalde-Herraiz**. Contributor. [](https://orcid.org/0009-0002-4405-1814)

  * **Nuria Mercade-Besora**. Author. [](https://orcid.org/0009-0006-7948-3747)

  * **Xihang Chen**. Author. [](https://orcid.org/0009-0001-8112-8959)




## Citation

Source: [`inst/CITATION`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/inst/CITATION)

Burkard, Theresa, López-Güell, Kim, Gorbachev, Artem, Bellas, Lucía, Jödicke, M. A, Burn, Edward, de Ridder, Maria, Mosseveld, Mees, Gratton, Jasmine, Seager, Sarah, Vojinovic, Dina, Mayer, Angel M, Ramírez-Anguita, Manuel J, Machín, Leis A, Oja, Marek, Kolde, Raivo, Bonadt, Klaus, Prieto-Alhambra, Daniel, Reich, Chistian, Català, Martí (2024). “Calculating daily dose in the Observational Medical Outcomes Partnership Common Data Model.” _Pharmacoepidemiology and Drug Safety_ , **33**(6), e5809. [doi:10.1002/pds.5809](https://doi.org/10.1002/pds.5809). 
    
    
    @Article{,
      title = {Calculating daily dose in the Observational Medical Outcomes Partnership Common Data Model},
      author = {{Burkard} and {Theresa} and {López-Güell} and {Kim} and {Gorbachev} and {Artem} and {Bellas} and {Lucía} and {Jödicke} and Annika M. and {Burn} and {Edward} and {de Ridder} and {Maria} and {Mosseveld} and {Mees} and {Gratton} and {Jasmine} and {Seager} and {Sarah} and {Vojinovic} and {Dina} and {Mayer} and Miguel Angel and {Ramírez-Anguita} and Juan Manuel and {Machín} and Angela Leis and {Oja} and {Marek} and {Kolde} and {Raivo} and {Bonadt} and {Klaus} and {Prieto-Alhambra} and {Daniel} and {Reich} and {Chistian} and {Català} and {Martí}},
      journal = {Pharmacoepidemiology and Drug Safety},
      year = {2024},
      volume = {33},
      number = {6},
      pages = {e5809},
      doi = {10.1002/pds.5809},
    }

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/generateDrugUtilisationCohortSet.html

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

# Generate a set of drug cohorts based on given concepts

Source: [`R/generateDrugUtilisationCohortSet.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/generateDrugUtilisationCohortSet.R)

`generateDrugUtilisationCohortSet.Rd`

Adds a new cohort table to the cdm reference with individuals who have drug exposure records with the specified concepts. Cohort start and end dates will be based on drug record start and end dates, respectively. Records that overlap or have fewer days between them than the specified gap era will be concatenated into a single cohort entry.

## Usage
    
    
    generateDrugUtilisationCohortSet(
      cdm,
      name,
      conceptSet,
      gapEra = 1,
      subsetCohort = NULL,
      subsetCohortId = NULL,
      numberExposures = FALSE,
      daysPrescribed = FALSE
    )

## Arguments

cdm
    

A `cdm_reference` object.

name
    

Name of the new cohort table, it must be a length 1 character vector.

conceptSet
    

List of concepts to be included.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

subsetCohort
    

Cohort table to subset.

subsetCohortId
    

Cohort id to subset.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

daysPrescribed
    

Whether to include 'days_prescribed' (number of days prescribed used to create each era).

## Value

The function returns the cdm reference provided with the addition of the new cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    druglist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm,
                                       name = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "metformin"),
                                       nameStyle = "{concept_name}")
    
    cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                            name = "drug_cohorts",
                                            conceptSet = druglist,
                                            gapEra = 30,
                                            numberExposures = TRUE,
                                            daysPrescribed = TRUE)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 30 days.
    
    cdm$drug_cohorts |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 2, 2, 2, 1, 1
    #> $ subject_id           <int> 9, 4, 5, 2, 3, 6, 6, 8, 1, 1, 1, 7, 4, 4, 3, 10
    #> $ cohort_start_date    <date> 2019-07-31, 1984-05-28, 2002-03-31, 2019-05-16, 2…
    #> $ cohort_end_date      <date> 2019-08-11, 1990-05-25, 2002-12-03, 2019-08-10, 2…
    #> $ number_exposures     <int> 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 3, 2, 1, 1, 1
    #> $ days_prescribed      <int> 12, 2272, 248, 87, 94, 1358, 321, 292, 2098, 423…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/generateAtcCohortSet.html

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

# Generate a set of drug cohorts based on ATC classification

Source: [`R/generateAtcCohortSet.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/generateAtcCohortSet.R)

`generateAtcCohortSet.Rd`

Adds a new cohort table to the cdm reference with individuals who have drug exposure records that belong to the specified Anatomical Therapeutic Chemical (ATC) classification. Cohort start and end dates will be based on drug record start and end dates, respectively. Records that overlap or have fewer days between them than the specified gap era will be concatenated into a single cohort entry.

## Usage
    
    
    generateAtcCohortSet(
      cdm,
      name,
      atcName = NULL,
      gapEra = 1,
      subsetCohort = NULL,
      subsetCohortId = NULL,
      numberExposures = FALSE,
      daysPrescribed = FALSE,
      ...
    )

## Arguments

cdm
    

A `cdm_reference` object.

name
    

Name of the new cohort table, it must be a length 1 character vector.

atcName
    

Names of ATC classification of interest.

gapEra
    

Number of days between two continuous exposures to be considered in the same era. Records that have fewer days between them than this gap will be concatenated into the same cohort record.

subsetCohort
    

Cohort table to subset.

subsetCohortId
    

Cohort id to subset.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

daysPrescribed
    

Whether to include 'days_prescribed' (number of days prescribed used to create each era).

...
    

Arguments to be passed to `[CodelistGenerator::getATCCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getATCCodes.html)`.

## Value

The function returns the cdm reference provided with the addition of the new cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm <- generateAtcCohortSet(cdm = cdm,
                                atcName = "alimentary tract and metabolism",
                                name = "drugs")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> Warning: cohort_name must be snake case and have less than 100 characters, the following
    #> cohorts will be renamed:
    #> • alimentary tract and metabolism -> alimentary_tract_and_metabolism
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$drugs |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 
    #> $ subject_id           <int> 
    #> $ cohort_start_date    <date> 
    #> $ cohort_end_date      <date> 
    #> $ number_exposures     <int> 
    #> $ days_prescribed      <int> 
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/erafyCohort.html

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

# Erafy a cohort_table collapsing records separated gapEra days or less.

Source: [`R/erafyCohort.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/erafyCohort.R)

`erafyCohort.Rd`

Erafy a cohort_table collapsing records separated gapEra days or less.

## Usage
    
    
    erafyCohort(
      cohort,
      gapEra,
      cohortId = NULL,
      nameStyle = "{cohort_name}_{gap_era}",
      name = omopgenerics::[tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort_table object.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

nameStyle
    

String to create the new names of cohorts. Must contain '{cohort_name}' if more than one cohort is present and '{gap_era}' if more than one gapEra is provided.

name
    

Name of the new cohort table, it must be a length 1 character vector.

## Value

A cohort_table object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm$cohort2 <- cdm$cohort1 |>
      erafyCohort(gapEra = 30, name = "cohort2")
    
    cdm$cohort2
    #> # Source:   table<cohort2> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          3 2007-06-02        2010-01-09     
    #>  2                    2          6 2022-05-22        2022-06-24     
    #>  3                    2          5 2020-11-19        2020-12-09     
    #>  4                    2          1 2018-01-01        2018-04-13     
    #>  5                    1          9 1996-07-08        2011-06-17     
    #>  6                    2          2 2013-01-11        2013-03-19     
    #>  7                    2         10 2001-09-26        2003-09-30     
    #>  8                    2          8 1984-01-05        1984-01-10     
    #>  9                    3          4 2012-06-19        2012-10-10     
    #> 10                    3          7 2007-06-07        2007-08-01     
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id cohort_name gap_era
    #>                  <int> <chr>       <chr>  
    #> 1                    1 cohort_1_30 30     
    #> 2                    2 cohort_2_30 30     
    #> 3                    3 cohort_3_30 30     
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/cohortGapEra.html

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

# Get the gapEra used to create a cohort

Source: [`R/generateDrugUtilisationCohortSet.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/generateDrugUtilisationCohortSet.R)

`cohortGapEra.Rd`

Get the gapEra used to create a cohort

## Usage
    
    
    cohortGapEra(cohort, cohortId = NULL)

## Arguments

cohort
    

A `cohort_table` object.

cohortId
    

Integer vector refering to cohortIds from cohort. If NULL all cohort definition ids in settings will be used.

## Value

gapEra values for the specific cohortIds

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    druglist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm,
                                       name = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "metformin"))
    
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "drug_cohorts",
                                            conceptSet = druglist,
                                            gapEra = 100)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 100 days.
    
    cohortGapEra(cdm$drug_cohorts)
    #> [1] 100 100
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/requireDrugInDateRange.html

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

# Restrict cohort to only cohort records within a certain date range

Source: [`R/require.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/require.R)

`requireDrugInDateRange.Rd`

Filter the cohort table keeping only the cohort records for which the specified index date is within a specified date range.

## Usage
    
    
    requireDrugInDateRange(
      cohort,
      dateRange,
      indexDate = "cohort_start_date",
      cohortId = NULL,
      name = omopgenerics::[tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort_table object.

dateRange
    

Date interval to consider. Any records with the index date outside of this range will be dropped.

indexDate
    

The column containing the date that will be checked against the date range.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

name
    

Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the date requirement.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm$cohort1 <- cdm$cohort1 |>
      requireDrugInDateRange(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-01-01", NA)))
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 6
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
    #> $ number_records       <int> 4, 1, 2, 1, 4, 1
    #> $ number_subjects      <int> 4, 1, 2, 1, 4, 1
    #> $ reason_id            <int> 1, 2, 1, 2, 1, 2
    #> $ reason               <chr> "Initial qualifying events", "require cohort_star…
    #> $ excluded_records     <int> 0, 3, 0, 1, 0, 3
    #> $ excluded_subjects    <int> 0, 3, 0, 1, 0, 3
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/requirePriorDrugWashout.html

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

# Restrict cohort to only cohort records with a given amount of time since the last cohort record ended

Source: [`R/require.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/require.R)

`requirePriorDrugWashout.Rd`

Filter the cohort table keeping only the cohort records for which the required amount of time has passed since the last cohort entry ended for that individual.

## Usage
    
    
    requirePriorDrugWashout(
      cohort,
      days,
      cohortId = NULL,
      name = omopgenerics::[tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort_table object.

days
    

The number of days required to have passed since the last cohort record finished. Any records with fewer days than this will be dropped. Note that setting days to Inf will lead to the same result as that from using the `requireIsFirstDrugEntry` function (with only an individual´s first cohort record kept).

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

name
    

Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the washout requirement.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm$cohort1 <- cdm$cohort1 |>
      requirePriorDrugWashout(days = 90)
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 6
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
    #> $ number_records       <int> 4, 4, 4, 4, 2, 2
    #> $ number_subjects      <int> 4, 4, 4, 4, 2, 2
    #> $ reason_id            <int> 1, 2, 1, 2, 1, 2
    #> $ reason               <chr> "Initial qualifying events", "require prior use d…
    #> $ excluded_records     <int> 0, 0, 0, 0, 0, 0
    #> $ excluded_subjects    <int> 0, 0, 0, 0, 0, 0
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addIndication.html

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

# Add a variable indicating individuals indications

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addIntersect.R)

`addIndication.Rd`

Add a variable to a drug cohort indicating their presence in an indication cohort in a specified time window. If an individual is not in one of the indication cohorts, they will be considered to have an unknown indication if they are present in one of the specified OMOP CDM clinical tables. If they are neither in an indication cohort or a clinical table they will be considered as having no observed indication.

## Usage
    
    
    addIndication(
      cohort,
      indicationCohortName,
      indicationCohortId = NULL,
      indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      unknownIndicationTable = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      mutuallyExclusive = TRUE,
      nameStyle = NULL,
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

indicationCohortName
    

Name of indication cohort table

indicationCohortId
    

target cohort Id to add indication

indicationWindow
    

time window of interests

unknownIndicationTable
    

Tables to search unknown indications

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

mutuallyExclusive
    

Whether to consider mutually exclusive categories (one column per window) or not (one column per window and indication).

nameStyle
    

Name style for the indications. By default: 'indication_{window_name}' (mutuallyExclusive = TRUE), 'indication_{window_name}_{cohort_name}' (mutuallyExclusive = FALSE).

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The original table with a variable added that summarises the individual´s indications.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    indications <- [list](https://rdrr.io/r/base/list.html)(headache = 378253, asthma = 317009)
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                                    conceptSet = indications,
                                    name = "indication_cohorts")
    
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       name = "drug_cohort",
                                       ingredient = "acetaminophen")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$drug_cohort |>
      addIndication(
        indicationCohortName = "indication_cohorts",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
        unknownIndicationTable = "condition_occurrence"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ Intersect with indications table (indication_cohorts).
    #> ℹ Getting unknown indications from condition_occurrence.
    #> ℹ Collapse indications to mutually exclusive categories
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1
    #> $ subject_id           <int> 2, 3, 4, 6, 7, 9
    #> $ cohort_start_date    <date> 2006-05-13, 1987-08-06, 2010-08-05, 2020-10-14, 2…
    #> $ cohort_end_date      <date> 2008-06-29, 2001-06-07, 2010-10-28, 2021-05-26, 2…
    #> $ indication_0_to_0    <chr> "asthma", "none", "none", "headache", "none", "n…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/tableIndication.html

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

# Create a table showing indication results

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableIndication.Rd`

Create a table showing indication results

## Usage
    
    
    tableIndication(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name", [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result)),
      groupColumn = "variable_name",
      hide = [c](https://rdrr.io/r/base/c.html)("window_name", "mutually_exclusive", "unknown_indication_table",
        "censor_date", "cohort_table_name", "index_date", "indication_cohort_name"),
      type = "gt",
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseIndication() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    result <- cdm$cohort1 |>
      [summariseIndication](summariseIndication.html)(
        indicationCohortName = "cohort2",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-30, 0)),
        unknownIndicationTable = "condition_occurrence"
      )
    #> ℹ Intersect with indications table (cohort2)
    #> ℹ Summarising indications.
    
    tableIndication(result)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, indication_cohort_name, mutually_exclusive, and
    #> unknown_indication_table are missing in `columnOrder`, will be added last.
    
    
    
    
      
          | 
            CDM name
          
          
    ---|---  
    
          | 
            DUS MOCK
          
          
    Indication
          | Estimate name
          | 
            Cohort name
          
          
    cohort_1
          | cohort_2
          | cohort_3
          
    Indication from 30 days before to the index date
          
    cohort_1
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_2
    | N (%)
    | 2 (66.67 %)
    | 1 (33.33 %)
    | 1 (25.00 %)  
    cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_1 and cohort_2
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_1 and cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_2 and cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    cohort_1 and cohort_2 and cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    unknown
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    none
    | N (%)
    | 1 (33.33 %)
    | 2 (66.67 %)
    | 3 (75.00 %)  
    not in observation
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/plotIndication.html

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

# Generate a plot visualisation (ggplot2) from the output of summariseIndication

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotIndication.Rd`

Generate a plot visualisation (ggplot2) from the output of summariseIndication

## Usage
    
    
    plotIndication(
      result,
      facet = cdm_name + cohort_name ~ window_name,
      colour = "variable_level"
    )

## Arguments

result
    

A summarised_result object.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot2 object

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    indications <- [list](https://rdrr.io/r/base/list.html)(headache = 378253, asthma = 317009)
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                                    conceptSet = indications,
                                    name = "indication_cohorts")
    
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       name = "drug_cohort",
                                       ingredient = "acetaminophen")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$drug_cohort |>
      [summariseIndication](summariseIndication.html)(
        indicationCohortName = "indication_cohorts",
        unknownIndicationTable = "condition_occurrence",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, 0), [c](https://rdrr.io/r/base/c.html)(-365, 0))
      )
    #> ℹ Intersect with indications table (indication_cohorts)
    #> ℹ Summarising indications.
    
    plotIndication(result)
    ![](plotIndication-1.png)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.html

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

# Add new columns with drug use related information

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addDrugUtilisation.Rd`

Add new columns with drug use related information

## Usage
    
    
    addDrugUtilisation(
      cohort,
      gapEra,
      conceptSet = NULL,
      ingredientConceptId = NULL,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      numberExposures = TRUE,
      numberEras = TRUE,
      daysExposed = TRUE,
      daysPrescribed = TRUE,
      timeToExposure = TRUE,
      initialExposureDuration = TRUE,
      initialQuantity = TRUE,
      cumulativeQuantity = TRUE,
      initialDailyDose = TRUE,
      cumulativeDose = TRUE,
      nameStyle = "{value}_{concept_name}_{ingredient}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

conceptSet
    

List of concepts to be included.

ingredientConceptId
    

Ingredient OMOP concept that we are interested for the study.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

numberEras
    

Whether to include 'number_eras' (number of continuous exposure episodes between indexDate and censorDate).

daysExposed
    

Whether to include 'days_exposed' (number of days that the individual is in a continuous exposure episode, including allowed treatment gaps, between indexDate and censorDate; sum of the length of the different drug eras).

daysPrescribed
    

Whether to include 'days_prescribed' (sum of the number of days for each prescription that contribute in the analysis).

timeToExposure
    

Whether to include 'time_to_exposure' (number of days between indexDate and the first episode).

initialExposureDuration
    

Whether to include 'initial_exposure_duration' (number of prescribed days of the first drug exposure record).

initialQuantity
    

Whether to include 'initial_quantity' (quantity of the first drug exposure record).

cumulativeQuantity
    

Whether to include 'cumulative_quantity' (sum of the quantity of the different exposures considered in the analysis).

initialDailyDose
    

Whether to include 'initial_daily_dose_{unit}' (daily dose of the first considered prescription).

cumulativeDose
    

Whether to include 'cumulative_dose_{unit}' (sum of the cumulative dose of the analysed drug exposure records).

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added columns.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    cdm$dus_cohort |>
      addDrugUtilisation(ingredientConceptId = 1125315, gapEra = 30) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 14
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id                                                <int> 1,…
    #> $ subject_id                                                          <int> 2,…
    #> $ cohort_start_date                                                   <date> 2…
    #> $ cohort_end_date                                                     <date> 2…
    #> $ number_exposures_ingredient_1125315_descendants                     <int> 1,…
    #> $ time_to_exposure_ingredient_1125315_descendants                     <int> 0,…
    #> $ cumulative_quantity_ingredient_1125315_descendants                  <dbl> 50…
    #> $ initial_quantity_ingredient_1125315_descendants                     <dbl> 50…
    #> $ initial_exposure_duration_ingredient_1125315_descendants            <int> 19…
    #> $ number_eras_ingredient_1125315_descendants                          <int> 1,…
    #> $ days_exposed_ingredient_1125315_descendants                         <int> 19…
    #> $ days_prescribed_ingredient_1125315_descendants                      <int> 19…
    #> $ cumulative_dose_milligram_ingredient_1125315_descendants_1125315    <dbl> 48…
    #> $ initial_daily_dose_milligram_ingredient_1125315_descendants_1125315 <dbl> 2.…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/tableDrugUtilisation.html

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

# Format a drug_utilisation object into a visual table.

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableDrugUtilisation.Rd`

Format a drug_utilisation object into a visual table.

## Usage
    
    
    tableDrugUtilisation(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cohort_name", [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result)),
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", "censor_date", "cohort_table_name", "gap_era", "index_date",
        "restrict_incident"),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseIndication() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    drugUse <- cdm$dus_cohort |>
      [summariseDrugUtilisation](summariseDrugUtilisation.html)(ingredientConceptId = 1125315)
    
    tableDrugUtilisation(drugUse)
    #> Warning: cdm_name, cohort_name, variable_level, censor_date, cohort_table_name, gap_era,
    #> index_date, and restrict_incident are missing in `columnOrder`, will be added
    #> last.
    
    
    
    
      Concept set
          | Ingredient
          | Variable name
          | Estimate name
          | 
            CDM name
          
          
    ---|---|---|---|---  
    DUS MOCK
          
    161_acetaminophen
          
    overall
    | overall
    | number records
    | N
    | 9  
    
    | 
    | number subjects
    | N
    | 6  
    ingredient_1125315_descendants
    | overall
    | number exposures
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 1.00 (0.00)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 1 (1 - 1)  
    
    | 
    | time to exposure
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 0.00 (0.00)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 0 (0 - 0)  
    
    | 
    | cumulative quantity
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 32.78 (35.28)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 10.00 (5.00 - 50.00)  
    
    | 
    | initial quantity
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 32.78 (35.28)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 10.00 (5.00 - 50.00)  
    
    | 
    | initial exposure duration
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 67.33 (62.45)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 45 (35 - 62)  
    
    | 
    | number eras
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 1.00 (0.00)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 1 (1 - 1)  
    
    | 
    | days exposed
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 67.33 (62.45)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 45 (35 - 62)  
    
    | 
    | days prescribed
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 67.33 (62.45)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 45 (35 - 62)  
    
    | acetaminophen
    | cumulative dose milligram
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 198,222.22 (257,150.63)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 50,000.00 (2,000.00 - 432,000.00)  
    
    | 
    | initial daily dose milligram
    | missing N (%)
    | 0 (0.00 %)  
    
    | 
    | 
    | Mean (SD)
    | 4,317.24 (5,436.40)  
    
    | 
    | 
    | Median (Q25 - Q75)
    | 1,428.57 (55.56 - 7,148.94)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/plotDrugUtilisation.html

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

# Plot the results of `summariseDrugUtilisation`

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotDrugUtilisation.Rd`

Plot the results of `summariseDrugUtilisation`

## Usage
    
    
    plotDrugUtilisation(
      result,
      variable = "number exposures",
      plotType = "barplot",
      facet = [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result),
      colour = "cohort_name"
    )

## Arguments

result
    

A summarised_result object.

variable
    

Variable to plot. See `unique(result$variable_name)` for options.

plotType
    

Must be a choice between: 'scatterplot', 'barplot', 'densityplot', and 'boxplot'.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot2 object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)(numberIndividuals = 100)
    codes <- [list](https://rdrr.io/r/base/list.html)(aceta = [c](https://rdrr.io/r/base/c.html)(1125315, 1125360, 2905077, 43135274))
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "cohort",
                                            conceptSet = codes)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$cohort |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [summariseDrugUtilisation](summariseDrugUtilisation.html)(
        strata = "sex",
        ingredientConceptId = 1125315,
        estimates = [c](https://rdrr.io/r/base/c.html)("min", "q25", "median", "q75", "max", "density")
      )
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(estimate_name == "median") |>
      plotDrugUtilisation(
        variable = "days prescribed",
        plotType = "barplot"
      )
    ![](plotDrugUtilisation-1.png)
    
    result |>
      plotDrugUtilisation(
        variable = "days exposed",
        facet = cohort_name ~ cdm_name,
        colour = "sex",
        plotType = "boxplot"
      )
    ![](plotDrugUtilisation-2.png)
    
    result |>
      plotDrugUtilisation(
        variable = "cumulative dose milligram",
        plotType = "densityplot",
        facet = "cohort_name",
        colour = "sex"
      )
    ![](plotDrugUtilisation-3.png)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addNumberExposures.html

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

# To add a new column with the number of exposures. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addNumberExposures.Rd`

To add a new column with the number of exposures. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addNumberExposures(
      cohort,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "number_exposures_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added columns.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addNumberExposures(conceptSet = codelist) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id               <int> 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ subject_id                         <int> 3, 3, 6, 6, 8, 8, 10, 10, 5
    #> $ cohort_start_date                  <date> 1982-03-05, 1977-04-12, 2012-03-10,…
    #> $ cohort_end_date                    <date> 1991-08-30, 1979-09-09, 2014-04-20,…
    #> $ number_exposures_161_acetaminophen <int> 2, 1, 1, 1, 1, 1, 1, 1, 1
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addNumberEras.html

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

# To add a new column with the number of eras. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addNumberEras.Rd`

To add a new column with the number of eras. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addNumberEras(
      cohort,
      conceptSet,
      gapEra,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "number_eras_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added column.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addNumberEras(conceptSet = codelist, gapEra = 1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id          <int> 1, 1, 1, 1, 1, 1
    #> $ subject_id                    <int> 1, 2, 9, 10, 3, 8
    #> $ cohort_start_date             <date> 2005-09-17, 2004-11-16, 2018-12-14, 2012…
    #> $ cohort_end_date               <date> 2005-11-04, 2010-11-07, 2019-04-27, 2013…
    #> $ number_eras_161_acetaminophen <int> 1, 1, 1, 1, 1, 1
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addTimeToExposure.html

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

# To add a new column with the time to exposure. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addTimeToExposure.Rd`

To add a new column with the time to exposure. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addTimeToExposure(
      cohort,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "time_to_exposure_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added column.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addTimeToExposure(conceptSet = codelist) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id               <int> 1, 1, 1, 1, 1, 1, 1, 1
    #> $ subject_id                         <int> 5, 3, 7, 6, 4, 4, 8, 8
    #> $ cohort_start_date                  <date> 2007-08-28, 2012-10-29, 2022-04-27,…
    #> $ cohort_end_date                    <date> 2019-06-06, 2014-03-09, 2022-05-04,…
    #> $ time_to_exposure_161_acetaminophen <int> 0, 0, 0, 0, 0, 0, 0, 0
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addDaysExposed.html

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

# To add a new column with the days exposed. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addDaysExposed.Rd`

To add a new column with the days exposed. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addDaysExposed(
      cohort,
      conceptSet,
      gapEra,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "days_exposed_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added column.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addDaysExposed(conceptSet = codelist, gapEra = 1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id           <int> 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ subject_id                     <int> 1, 3, 4, 3, 7, 5, 6, 2, 7
    #> $ cohort_start_date              <date> 2022-02-26, 2000-07-20, 2010-07-11, 200…
    #> $ cohort_end_date                <date> 2022-03-03, 2005-09-25, 2011-11-13, 200…
    #> $ days_exposed_161_acetaminophen <int> 6, 1894, 491, 143, 382, 14, 39, 4225, 33
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addDaysPrescribed.html

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

# To add a new column with the days prescribed. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addDaysPrescribed.Rd`

To add a new column with the days prescribed. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addDaysPrescribed(
      cohort,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "days_prescribed_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added columns.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addDaysPrescribed(conceptSet = codelist) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id              <int> 1, 1, 1, 1, 1, 1
    #> $ subject_id                        <int> 2, 10, 10, 4, 6, 5
    #> $ cohort_start_date                 <date> 2022-02-05, 2011-03-09, 2015-08-17, …
    #> $ cohort_end_date                   <date> 2022-02-25, 2015-02-22, 2016-02-21, …
    #> $ days_prescribed_161_acetaminophen <int> 21, 1447, 189, 10, 2079, 866
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addInitialExposureDuration.html

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

# To add a new column with the duration of the first exposure. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addInitialExposureDuration.Rd`

To add a new column with the duration of the first exposure. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addInitialExposureDuration(
      cohort,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "initial_exposure_duration_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added column.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addInitialExposureDuration(conceptSet = codelist) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id                        <int> 1, 1, 1, 1, 1, 1, 1, 1
    #> $ subject_id                                  <int> 4, 9, 9, 3, 3, 8, 2, 10
    #> $ cohort_start_date                           <date> 1999-12-25, 1962-10-21, 19…
    #> $ cohort_end_date                             <date> 2001-05-25, 1973-05-03, 19…
    #> $ initial_exposure_duration_161_acetaminophen <int> 518, 1958, 517, 5, 4, 482…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addInitialQuantity.html

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

# To add a new column with the initial quantity. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addInitialQuantity.Rd`

To add a new column with the initial quantity. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addInitialQuantity(
      cohort,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "initial_quantity_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added column.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addInitialQuantity(conceptSet = codelist) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id               <int> 1, 1, 1, 1, 1
    #> $ subject_id                         <int> 5, 6, 7, 8, 2
    #> $ cohort_start_date                  <date> 2000-10-05, 2022-08-08, 1987-05-07,…
    #> $ cohort_end_date                    <date> 2001-01-25, 2022-08-10, 1994-01-09,…
    #> $ initial_quantity_161_acetaminophen <dbl> 10, 50, 30, 45, 90
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addCumulativeQuantity.html

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

# To add a new column with the cumulative quantity. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addCumulativeQuantity.Rd`

To add a new column with the cumulative quantity. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addCumulativeQuantity(
      cohort,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "cumulative_quantity_{concept_name}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added column.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addCumulativeQuantity(conceptSet = codelist) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id                  <int> 1, 1, 1, 1, 1, 1, 1, 1
    #> $ subject_id                            <int> 3, 5, 7, 7, 2, 8, 4, 4
    #> $ cohort_start_date                     <date> 2014-04-16, 2016-02-27, 2016-03-…
    #> $ cohort_end_date                       <date> 2016-10-12, 2017-12-12, 2016-03-…
    #> $ cumulative_quantity_161_acetaminophen <dbl> 1, 60, 10, 90, 35, 70, 30, 150
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addInitialDailyDose.html

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

# To add a new column with the initial daily dose. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addInitialDailyDose.Rd`

To add a new column with the initial daily dose. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addInitialDailyDose(
      cohort,
      ingredientConceptId,
      conceptSet = NULL,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "initial_daily_dose_{concept_name}_{ingredient}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

ingredientConceptId
    

Ingredient OMOP concept that we are interested for the study.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added column.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addInitialDailyDose(ingredientConceptId = 1125315) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id                                      <int> 1, 1, 1, 1, …
    #> $ subject_id                                                <int> 1, 7, 8, 3, …
    #> $ cohort_start_date                                         <date> 2009-12-27,…
    #> $ cohort_end_date                                           <date> 2015-03-21,…
    #> $ initial_daily_dose_ingredient_1125315_descendants_1125315 <dbl> 502.354788, …
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addCumulativeDose.html

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

# To add a new column with the cumulative dose. To add multiple columns use `addDrugUtilisation()` for efficiency.

Source: [`R/addDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addDrugUtilisation.R)

`addCumulativeDose.Rd`

To add a new column with the cumulative dose. To add multiple columns use `[addDrugUtilisation()](addDrugUtilisation.html)` for efficiency.

## Usage
    
    
    addCumulativeDose(
      cohort,
      ingredientConceptId,
      conceptSet = NULL,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "cumulative_dose_{concept_name}_{ingredient}",
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

ingredientConceptId
    

Ingredient OMOP concept that we are interested for the study.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

nameStyle
    

Character string to specify the nameStyle of the new columns.

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The same cohort with the added column.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    codelist <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "acetaminophen")
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "dus_cohort",
                                            conceptSet = codelist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      addCumulativeDose(ingredientConceptId = 1125315) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id                                   <int> 1, 1, 1, 1, 1, 1
    #> $ subject_id                                             <int> 1, 5, 6, 2, 8, …
    #> $ cohort_start_date                                      <date> 2021-11-30, 201…
    #> $ cohort_end_date                                        <date> 2021-12-04, 20…
    #> $ cumulative_dose_ingredient_1125315_descendants_1125315 <dbl> 20000, 24000, …
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/summariseProportionOfPatientsCovered.html

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

# Summarise proportion Of patients covered

Source: [`R/summariseProportionOfPatientsCovered.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseProportionOfPatientsCovered.R)

`summariseProportionOfPatientsCovered.Rd`

Gives the proportion of patients still in observation who are in the cohort on any given day following their first cohort entry. This is known as the “proportion of patients covered” (PPC) method for assessing treatment persistence.

## Usage
    
    
    summariseProportionOfPatientsCovered(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      followUpDays = NULL
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

followUpDays
    

Number of days to follow up individuals for. If NULL the maximum amount of days from an individuals first cohort start date to their last cohort end date will be used

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)(numberIndividuals = 100)
    
    result <- cdm$cohort1 |>
      summariseProportionOfPatientsCovered(followUpDays = 365)
    #> Getting PPC for cohort cohort_1
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■           258 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    #> Getting PPC for cohort cohort_2
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■           259 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    #> Getting PPC for cohort cohort_3
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■           258 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(result)
    #> # A tibble: 1,098 × 11
    #>    cdm_name cohort_name variable_name variable_level time  outcome_count
    #>    <chr>    <chr>       <chr>         <chr>          <chr>         <int>
    #>  1 DUS MOCK cohort_1    overall       overall        0                26
    #>  2 DUS MOCK cohort_1    overall       overall        1                26
    #>  3 DUS MOCK cohort_1    overall       overall        2                26
    #>  4 DUS MOCK cohort_1    overall       overall        3                26
    #>  5 DUS MOCK cohort_1    overall       overall        4                25
    #>  6 DUS MOCK cohort_1    overall       overall        5                25
    #>  7 DUS MOCK cohort_1    overall       overall        6                25
    #>  8 DUS MOCK cohort_1    overall       overall        7                25
    #>  9 DUS MOCK cohort_1    overall       overall        8                25
    #> 10 DUS MOCK cohort_1    overall       overall        9                25
    #> # ℹ 1,088 more rows
    #> # ℹ 5 more variables: denominator_count <int>, ppc <dbl>, ppc_lower <dbl>,
    #> #   ppc_upper <dbl>, cohort_table_name <chr>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/tableProportionOfPatientsCovered.html

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

# Create a table with proportion of patients covered results

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableProportionOfPatientsCovered.Rd`

Create a table with proportion of patients covered results

## Usage
    
    
    tableProportionOfPatientsCovered(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cohort_name", [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result)),
      groupColumn = "cdm_name",
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("variable_name", "variable_level", "cohort_table_name"),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseProportionOfPatientsCovered() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "my_cohort",
                                            conceptSet = [list](https://rdrr.io/r/base/list.html)(drug_of_interest = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327)))
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$my_cohort |>
      [summariseProportionOfPatientsCovered](summariseProportionOfPatientsCovered.html)(followUpDays = 365)
    #> Getting PPC for cohort drug_of_interest
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■                      127 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■            247 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    
    tableProportionOfPatientsCovered(result)
    #> Warning: cdm_name, cohort_name, variable_name, variable_level, and cohort_table_name are
    #> missing in `columnOrder`, will be added last.
    #> ℹ <ppc>% has not been formatted.
    #> ℹ <ppc_lower>% has not been formatted.
    #> ℹ <ppc_upper>% has not been formatted.
    
    
    
    
      Time
          | Estimate name
          | 
            Cohort name
          
          
    ---|---|---  
    drug_of_interest
          
    DUS MOCK
          
    0
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    1
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    2
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    3
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    4
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    5
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    6
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    7
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    8
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    9
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    10
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    11
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    12
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    13
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    14
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    15
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    16
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    17
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    18
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    19
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    20
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    21
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    22
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    23
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    24
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    25
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    26
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    27
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    28
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    29
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    30
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    31
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    32
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    33
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    34
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    35
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    36
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    37
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    38
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    39
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    40
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    41
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    42
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    43
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    44
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    45
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    46
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    47
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    48
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    49
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    50
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    51
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    52
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    53
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    54
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    55
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    56
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    57
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    58
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    59
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    60
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    61
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    62
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    63
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    64
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    65
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    66
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    67
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    68
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    69
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    70
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    71
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    72
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    73
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    74
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    75
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    76
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    77
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    78
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    79
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    80
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    81
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    82
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    83
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    84
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    85
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    86
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    87
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    88
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    89
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    90
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    91
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    92
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    93
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    94
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    95
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    96
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    97
    | PPC (95%CI)
    | 100.00% [43.85% - 100.00%]  
    98
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    99
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    100
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    101
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    102
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    103
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    104
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    105
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    106
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    107
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    108
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    109
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    110
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    111
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    112
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    113
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    114
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    115
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    116
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    117
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    118
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    119
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    120
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    121
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    122
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    123
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    124
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    125
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    126
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    127
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    128
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    129
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    130
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    131
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    132
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    133
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    134
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    135
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    136
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    137
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    138
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    139
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    140
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    141
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    142
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    143
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    144
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    145
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    146
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    147
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    148
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    149
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    150
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    151
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    152
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    153
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    154
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    155
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    156
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    157
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    158
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    159
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    160
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    161
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    162
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    163
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    164
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    165
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    166
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    167
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    168
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    169
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    170
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    171
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    172
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    173
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    174
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    175
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    176
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    177
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    178
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    179
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    180
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    181
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    182
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    183
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    184
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    185
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    186
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    187
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    188
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    189
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    190
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    191
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    192
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    193
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    194
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    195
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    196
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    197
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    198
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    199
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    200
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    201
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    202
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    203
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    204
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    205
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    206
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    207
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    208
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    209
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    210
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    211
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    212
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    213
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    214
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    215
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    216
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    217
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    218
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    219
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    220
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    221
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    222
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    223
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    224
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    225
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    226
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    227
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    228
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    229
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    230
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    231
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    232
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    233
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    234
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    235
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    236
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    237
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    238
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    239
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    240
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    241
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    242
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    243
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    244
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    245
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    246
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    247
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    248
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    249
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    250
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    251
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    252
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    253
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    254
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    255
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    256
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    257
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    258
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    259
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    260
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    261
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    262
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    263
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    264
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    265
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    266
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    267
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    268
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    269
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    270
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    271
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    272
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    273
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    274
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    275
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    276
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    277
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    278
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    279
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    280
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    281
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    282
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    283
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    284
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    285
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    286
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    287
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    288
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    289
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    290
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    291
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    292
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    293
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    294
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    295
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    296
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    297
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    298
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    299
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    300
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    301
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    302
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    303
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    304
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    305
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    306
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    307
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    308
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    309
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    310
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    311
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    312
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    313
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    314
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    315
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    316
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    317
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    318
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    319
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    320
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    321
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    322
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    323
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    324
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    325
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    326
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    327
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    328
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    329
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    330
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    331
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    332
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    333
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    334
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    335
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    336
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    337
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    338
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    339
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    340
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    341
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    342
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    343
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    344
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    345
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    346
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    347
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    348
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    349
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    350
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    351
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    352
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    353
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    354
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    355
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    356
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    357
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    358
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    359
    | PPC (95%CI)
    | 66.67% [20.77% - 93.85%]  
    360
    | PPC (95%CI)
    | 33.33% [6.15% - 79.23%]  
    361
    | PPC (95%CI)
    | 33.33% [6.15% - 79.23%]  
    362
    | PPC (95%CI)
    | 33.33% [6.15% - 79.23%]  
    363
    | PPC (95%CI)
    | 33.33% [6.15% - 79.23%]  
    364
    | PPC (95%CI)
    | 33.33% [6.15% - 79.23%]  
    365
    | PPC (95%CI)
    | 33.33% [6.15% - 79.23%]  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/plotProportionOfPatientsCovered.html

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

# Plot proportion of patients covered

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotProportionOfPatientsCovered.Rd`

Plot proportion of patients covered

## Usage
    
    
    plotProportionOfPatientsCovered(
      result,
      facet = "cohort_name",
      colour = [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result),
      ribbon = TRUE
    )

## Arguments

result
    

A summarised_result object.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

ribbon
    

Whether to plot a ribbon with the confidence intervals.

## Value

Plot of proportion Of patients covered over time

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "my_cohort",
                                            conceptSet = [list](https://rdrr.io/r/base/list.html)(drug_of_interest = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327)))
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$my_cohort |>
      [summariseProportionOfPatientsCovered](summariseProportionOfPatientsCovered.html)(followUpDays = 365)
    #> Getting PPC for cohort drug_of_interest
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■■                     130 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    
    plotProportionOfPatientsCovered(result)
    ![](plotProportionOfPatientsCovered-1.png)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addTreatment.html

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

# Add a variable indicating individuals medications

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/addIntersect.R)

`addTreatment.Rd`

Add a variable to a drug cohort indicating their presence of a medication cohort in a specified time window.

## Usage
    
    
    addTreatment(
      cohort,
      treatmentCohortName,
      treatmentCohortId = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      indexDate = "cohort_start_date",
      censorDate = NULL,
      mutuallyExclusive = TRUE,
      nameStyle = NULL,
      name = NULL
    )

## Arguments

cohort
    

A cohort_table object.

treatmentCohortName
    

Name of treatment cohort table

treatmentCohortId
    

target cohort Id to add treatment

window
    

time window of interests.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

mutuallyExclusive
    

Whether to consider mutually exclusive categories (one column per window) or not (one column per window and treatment).

nameStyle
    

Name style for the treatment columns. By default: 'treatment_{window_name}' (mutuallyExclusive = TRUE), 'treatment_{window_name}_{cohort_name}' (mutuallyExclusive = FALSE).

name
    

Name of the new computed cohort table, if NULL a temporary table will be created.

## Value

The original table with a variable added that summarises the individual´s indications.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)(numberIndividuals = 50)
    
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       name = "drug_cohort",
                                       ingredient = "acetaminophen")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       name = "treatments",
                                       ingredient = [c](https://rdrr.io/r/base/c.html)("metformin", "simvastatin"))
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$drug_cohort |>
      addTreatment("treatments", window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, 30), [c](https://rdrr.io/r/base/c.html)(31, 60))) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ Intersect with medications table (treatments).
    #> ℹ Collapse medications to mutually exclusive categories
    #> Rows: ??
    #> Columns: 7
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 33, 46, 16, 12, 14, 22, 31, 2, 6, 25, 3, 3, 15, 2…
    #> $ cohort_start_date    <date> 2022-01-15, 2009-12-04, 2020-08-07, 2006-08-15, …
    #> $ cohort_end_date      <date> 2022-05-03, 2013-02-02, 2021-05-01, 2009-05-02, …
    #> $ medication_0_to_0    <chr> "simvastatin", "metformin", "metformin", "simvast…
    #> $ medication_1_to_30   <chr> "simvastatin", "metformin", "metformin", "simvast…
    #> $ medication_31_to_60  <chr> "simvastatin", "metformin", "metformin", "simvast…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/summariseTreatment.html

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

# This function is used to summarise treatments received

Source: [`R/summariseIntersect.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseIntersect.R)

`summariseTreatment.Rd`

This function is used to summarise treatments received

## Usage
    
    
    summariseTreatment(
      cohort,
      window,
      treatmentCohortName,
      cohortId = NULL,
      treatmentCohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      indexDate = "cohort_start_date",
      censorDate = NULL,
      mutuallyExclusive = FALSE
    )

## Arguments

cohort
    

A cohort_table object.

window
    

Time window over which to summarise the treatments.

treatmentCohortName
    

Name of a cohort in the cdm that contains the treatments of interest.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

treatmentCohortId
    

Cohort definition id of interest from treatmentCohortName.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

mutuallyExclusive
    

Whether to include mutually exclusive treatments or not.

## Value

A summary of treatments stratified by cohort_name and strata_name

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    cdm$cohort1 |>
      summariseTreatment(
        treatmentCohortName = "cohort2",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 30), [c](https://rdrr.io/r/base/c.html)(31, 365))
      )
    #> ℹ Intersect with medications table (cohort2)
    #> ℹ Summarising medications.
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/tableTreatment.html

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

# Format a summarised_treatment result into a visual table.

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableTreatment.Rd`

Format a summarised_treatment result into a visual table.

## Usage
    
    
    tableTreatment(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      groupColumn = "variable_name",
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("window_name", "mutually_exclusive", "censor_date", "cohort_table_name",
        "index_date", "treatment_cohort_name"),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseTreatment() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    result <- cdm$cohort1 |>
      [summariseTreatment](summariseTreatment.html)(
        treatmentCohortName = "cohort2",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 30), [c](https://rdrr.io/r/base/c.html)(31, 365))
      )
    #> ℹ Intersect with medications table (cohort2)
    #> ℹ Summarising medications.
    
    tableTreatment(result)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
    #> are missing in `columnOrder`, will be added last.
    
    
    
    
      
          | 
            CDM name
          
          
    ---|---  
    
          | 
            DUS MOCK
          
          
    Treatment
          | Estimate name
          | 
            Cohort name
          
          
    cohort_1
          | cohort_2
          | cohort_3
          
    Medication from index date to 30 days after
          
    cohort_1
    | N (%)
    | 0 (0.00 %)
    | 1 (100.00 %)
    | 0 (0.00 %)  
    cohort_2
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 1 (16.67 %)  
    cohort_3
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 2 (33.33 %)  
    untreated
    | N (%)
    | 3 (100.00 %)
    | 0 (0.00 %)
    | 3 (50.00 %)  
    not in observation
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    Medication from 31 days after to 365 days after the index date
          
    cohort_1
    | N (%)
    | 0 (0.00 %)
    | 1 (100.00 %)
    | 0 (0.00 %)  
    cohort_2
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 1 (16.67 %)  
    cohort_3
    | N (%)
    | 1 (33.33 %)
    | 0 (0.00 %)
    | 2 (33.33 %)  
    untreated
    | N (%)
    | 2 (66.67 %)
    | 0 (0.00 %)
    | 3 (50.00 %)  
    not in observation
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/plotTreatment.html

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

# Generate a custom ggplot2 from a summarised_result object generated with summariseTreatment function.

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotTreatment.Rd`

Generate a custom ggplot2 from a summarised_result object generated with summariseTreatment function.

## Usage
    
    
    plotTreatment(
      result,
      facet = cdm_name + cohort_name ~ window_name,
      colour = "variable_level"
    )

## Arguments

result
    

A summarised_result object.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot2 object.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    result <- cdm$cohort1 |>
      [summariseTreatment](summariseTreatment.html)(
        treatmentCohortName = "cohort2",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 30), [c](https://rdrr.io/r/base/c.html)(31, 365))
      )
    
    plotTreatment(result)
    } # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/addDrugRestart.html

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

# Add drug restart information as a column per follow-up period of interest.

Source: [`R/summariseDrugRestart.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseDrugRestart.R)

`addDrugRestart.Rd`

Add drug restart information as a column per follow-up period of interest.

## Usage
    
    
    addDrugRestart(
      cohort,
      switchCohortTable,
      switchCohortId = NULL,
      followUpDays = Inf,
      censorDate = NULL,
      incident = TRUE,
      nameStyle = "drug_restart_{follow_up_days}"
    )

## Arguments

cohort
    

A cohort_table object.

switchCohortTable
    

A cohort table in the cdm that contains possible alternative treatments.

switchCohortId
    

The cohort ids to be used from switchCohortTable. If NULL all cohort definition ids are used.

followUpDays
    

A vector of number of days to follow up. It can be multiple values.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

incident
    

Whether the switch treatment has to be incident (start after discontinuation) or not (it can start before the discontinuation and last till after).

nameStyle
    

Character string to specify the nameStyle of the new columns.

## Value

The cohort table given with additional columns with information on the restart, switch and not exposed per follow-up period of interest.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    conceptlist <- [list](https://rdrr.io/r/base/list.html)(acetaminophen = 1125360, metformin = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327))
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "switch_cohort",
                                            conceptSet = conceptlist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$cohort1 |>
      addDrugRestart(switchCohortTable = "switch_cohort")
    #> # Source:   table<og_046_1751551185> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2         10 2007-02-09        2007-11-01     
    #>  2                    2          3 2011-06-01        2012-01-18     
    #>  3                    2          6 2020-08-14        2020-12-16     
    #>  4                    3          1 2012-09-30        2012-11-14     
    #>  5                    3          7 2008-10-22        2009-05-22     
    #>  6                    3          8 2021-08-28        2021-08-28     
    #>  7                    3          5 1985-08-28        2009-04-23     
    #>  8                    3          9 2017-06-09        2018-05-10     
    #>  9                    1          2 2020-05-11        2020-05-28     
    #> 10                    2          4 2022-05-25        2022-07-25     
    #> # ℹ 1 more variable: drug_restart_inf <chr>
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/summariseDrugRestart.html

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

# Summarise the drug restart for each follow-up period of interest.

Source: [`R/summariseDrugRestart.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseDrugRestart.R)

`summariseDrugRestart.Rd`

Summarise the drug restart for each follow-up period of interest.

## Usage
    
    
    summariseDrugRestart(
      cohort,
      cohortId = NULL,
      switchCohortTable,
      switchCohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      followUpDays = Inf,
      censorDate = NULL,
      incident = TRUE,
      restrictToFirstDiscontinuation = TRUE
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

switchCohortTable
    

A cohort table in the cdm that contains possible alternative treatments.

switchCohortId
    

The cohort ids to be used from switchCohortTable. If NULL all cohort definition ids are used.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

followUpDays
    

A vector of number of days to follow up. It can be multiple values.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

incident
    

Whether the switch treatment has to be incident (start after discontinuation) or not (it can start before the discontinuation and last till after).

restrictToFirstDiscontinuation
    

Whether to consider only the first discontinuation episode or all of them.

## Value

A summarised_result object with the percentages of restart, switch and not exposed per follow-up period given.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    conceptlist <- [list](https://rdrr.io/r/base/list.html)(acetaminophen = 1125360, metformin = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327))
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "switch_cohort",
                                            conceptSet = conceptlist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$cohort1 |>
      summariseDrugRestart(switchCohortTable = "switch_cohort")
    
    [tableDrugRestart](tableDrugRestart.html)(result)
    #> Warning: cdm_name, cohort_name, variable_name, follow_up_days, censor_date,
    #> cohort_table_name, incident, restrict_to_first_discontinuation, and
    #> switch_cohort_table are missing in `columnOrder`, will be added last.
    
    
    
    
      
          | 
            CDM name
          
          
    ---|---  
    
          | 
            DUS MOCK
          
          
    Treatment
          | Estimate name
          | 
            Cohort name
          
          
    cohort_1
          | cohort_2
          | cohort_3
          
    Drug restart till end of observation
          
    restart
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    switch
    | N (%)
    | 0 (0.00 %)
    | 1 (33.33 %)
    | 0 (0.00 %)  
    restart and switch
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    untreated
    | N (%)
    | 2 (100.00 %)
    | 2 (66.67 %)
    | 5 (100.00 %)  
      
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/tableDrugRestart.html

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

# Format a drug_restart object into a visual table.

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableDrugRestart.Rd`

Format a drug_restart object into a visual table.

## Usage
    
    
    tableDrugRestart(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      groupColumn = "variable_name",
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("censor_date", "restrict_to_first_discontinuation", "follow_up_days",
        "cohort_table_name", "incident", "switch_cohort_table"),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseDrugRestart() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    conceptlist <- [list](https://rdrr.io/r/base/list.html)(acetaminophen = 1125360, metformin = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327))
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "switch_cohort",
                                            conceptSet = conceptlist)
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    result <- cdm$cohort1 |>
      [summariseDrugRestart](summariseDrugRestart.html)(switchCohortTable = "switch_cohort")
    
    tableDrugRestart(result)
    #> Warning: cdm_name, cohort_name, variable_name, follow_up_days, censor_date,
    #> cohort_table_name, incident, restrict_to_first_discontinuation, and
    #> switch_cohort_table are missing in `columnOrder`, will be added last.
    
    
    
    
      
          | 
            CDM name
          
          
    ---|---  
    
          | 
            DUS MOCK
          
          
    Treatment
          | Estimate name
          | 
            Cohort name
          
          
    cohort_1
          | cohort_2
          | cohort_3
          
    Drug restart till end of observation
          
    restart
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    switch
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    restart and switch
    | N (%)
    | 0 (0.00 %)
    | 0 (0.00 %)
    | 0 (0.00 %)  
    untreated
    | N (%)
    | 3 (100.00 %)
    | 3 (100.00 %)
    | 4 (100.00 %)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/plotDrugRestart.html

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

# Generate a custom ggplot2 from a summarised_result object generated with summariseDrugRestart() function.

Source: [`R/plots.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/plots.R)

`plotDrugRestart.Rd`

Generate a custom ggplot2 from a summarised_result object generated with summariseDrugRestart() function.

## Usage
    
    
    plotDrugRestart(
      result,
      facet = cdm_name + cohort_name ~ follow_up_days,
      colour = "variable_level"
    )

## Arguments

result
    

A summarised_result object.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot2 object.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    conceptlist <- [list](https://rdrr.io/r/base/list.html)("a" = 1125360, "b" = [c](https://rdrr.io/r/base/c.html)(1503297, 1503327))
    cdm <- [generateDrugUtilisationCohortSet](generateDrugUtilisationCohortSet.html)(cdm = cdm,
                                            name = "switch_cohort",
                                            conceptSet = conceptlist)
    
    result <- cdm$cohort1 |>
      [summariseDrugRestart](summariseDrugRestart.html)(switchCohortTable = "switch_cohort")
    
    plotDrugRestart(result)
    } # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/patternsWithFormula.html

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

# Patterns valid to compute daily dose with the associated formula.

Source: [`R/data.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/data.R)

`patternsWithFormula.Rd`

Patterns valid to compute daily dose with the associated formula.

## Usage
    
    
    patternsWithFormula

## Format

A data frame with eight variables: `pattern_id`, `amount`, `amount_unit`, `numerator`, `numerator_unit`, `denominator`, `denominator_unit`, `formula_name` and `formula`.

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/patternTable.html

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

# Function to create a tibble with the patterns from current drug strength table

Source: [`R/pattern.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/pattern.R)

`patternTable.Rd`

Function to create a tibble with the patterns from current drug strength table

## Usage
    
    
    patternTable(cdm)

## Arguments

cdm
    

A `cdm_reference` object.

## Value

The function creates a tibble with the different patterns found in the table, plus a column of potentially valid and invalid combinations.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    patternTable(cdm)
    #> # A tibble: 5 × 12
    #>   pattern_id formula_name            validity number_concepts number_ingredients
    #>        <dbl> <chr>                   <chr>              <dbl>              <dbl>
    #> 1          9 fixed amount formulati… pattern…               7                  4
    #> 2         18 concentration formulat… pattern…               1                  1
    #> 3         24 concentration formulat… pattern…               1                  1
    #> 4         40 concentration formulat… pattern…               1                  1
    #> 5         NA NA                      no patt…               4                  4
    #> # ℹ 7 more variables: number_records <dbl>, amount_numeric <dbl>,
    #> #   amount_unit_concept_id <dbl>, numerator_numeric <dbl>,
    #> #   numerator_unit_concept_id <dbl>, denominator_numeric <dbl>,
    #> #   denominator_unit_concept_id <dbl>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/summariseDoseCoverage.html

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

# Check coverage of daily dose computation in a sample of the cdm for selected concept sets and ingredient

Source: [`R/dailyDose.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/dailyDose.R)

`summariseDoseCoverage.Rd`

Check coverage of daily dose computation in a sample of the cdm for selected concept sets and ingredient

## Usage
    
    
    summariseDoseCoverage(
      cdm,
      ingredientConceptId,
      estimates = [c](https://rdrr.io/r/base/c.html)("count_missing", "percentage_missing", "mean", "sd", "q25", "median",
        "q75"),
      sampleSize = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object.

ingredientConceptId
    

Ingredient OMOP concept that we are interested for the study.

estimates
    

Estimates to obtain.

sampleSize
    

Maximum number of records of an ingredient to estimate dose coverage. If an ingredient has more, a random sample equal to `sampleSize` will be considered. If NULL, all records will be used.

## Value

The function returns information of the coverage of computeDailyDose.R for the selected ingredients and concept sets

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315)
    #> ℹ The following estimates will be computed:
    #> • daily_dose: count_missing, percentage_missing, mean, sd, q25, median, q75
    #> ! Table is collected to memory as not all requested estimates are supported on
    #>   the database side
    #> → Start summary of data, at 2025-07-03 14:03:08.642649
    #> ✔ Summary finished, at 2025-07-03 14:03:09.067993
    #> # A tibble: 56 × 13
    #>    result_id cdm_name group_name      group_level   strata_name strata_level
    #>        <int> <chr>    <chr>           <chr>         <chr>       <chr>       
    #>  1         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  2         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  3         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  4         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  5         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  6         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  7         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  8         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  9         1 DUS MOCK ingredient_name acetaminophen unit        milligram   
    #> 10         1 DUS MOCK ingredient_name acetaminophen unit        milligram   
    #> # ℹ 46 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/tableDoseCoverage.html

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

# Format a dose_coverage object into a visual table.

Source: [`R/tables.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/tables.R)

`tableDoseCoverage.Rd`

Format a dose_coverage object into a visual table.

## Usage
    
    
    tableDoseCoverage(
      result,
      header = [c](https://rdrr.io/r/base/c.html)("variable_name", "estimate_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "ingredient_name"),
      type = "gt",
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", "sample_size"),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseDrugCoverage() results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    result <- [summariseDoseCoverage](summariseDoseCoverage.html)(cdm, 1125315)
    #> ℹ The following estimates will be computed:
    #> • daily_dose: count_missing, percentage_missing, mean, sd, q25, median, q75
    #> ! Table is collected to memory as not all requested estimates are supported on
    #>   the database side
    #> → Start summary of data, at 2025-07-03 14:04:04.260479
    #> ✔ Summary finished, at 2025-07-03 14:04:04.691457
    
    tableDoseCoverage(result)
    #> Warning: cdm_name, ingredient_name, variable_name, variable_level, estimate_name, and
    #> sample_size are missing in `columnOrder`, will be added last.
    
    
    
    
      
          | 
            Variable name
          
          
    ---|---  
    
          | 
            number records
          
          | 
            Missing dose
          
          | 
            daily_dose
          
          
    Unit
          | Route
          | Pattern id
          | 
            Estimate name
          
          
    N
          | N (%)
          | Mean (SD)
          | Median (Q25 - Q75)
          
    DUS MOCK; acetaminophen
          
    overall
    | overall
    | overall
    | 7
    | 0 (0.00 %)
    | 69,701.82 (180,937.18)
    | 577.44 (23.98 - 3,640.00)  
    milligram
    | overall
    | overall
    | 7
    | 0 (0.00 %)
    | 69,701.82 (180,937.18)
    | 577.44 (23.98 - 3,640.00)  
    
    | oral
    | overall
    | 1
    | 0 (0.00 %)
    | -
    | 7.31 (7.31 - 7.31)  
    
    | topical
    | overall
    | 6
    | 0 (0.00 %)
    | 81,317.57 (195,326.75)
    | 928.72 (173.21 - 4,820.00)  
    
    | oral
    | 9
    | 1
    | 0 (0.00 %)
    | -
    | 7.31 (7.31 - 7.31)  
    
    | topical
    | 18
    | 3
    | 0 (0.00 %)
    | 160,619.15 (276,592.15)
    | 1,280.00 (928.72 - 240,640.00)  
    
    | 
    | 9
    | 3
    | 0 (0.00 %)
    | 2,015.99 (3,450.29)
    | 38.46 (23.98 - 3,019.23)  
      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/DrugUtilisation/reference/benchmarkDrugUtilisation.html

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

# Run benchmark of drug utilisation cohort generation

Source: [`R/benchmarkDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/benchmarkDrugUtilisation.R)

`benchmarkDrugUtilisation.Rd`

Run benchmark of drug utilisation cohort generation

## Usage
    
    
    benchmarkDrugUtilisation(
      cdm,
      ingredient = "acetaminophen",
      alternativeIngredient = [c](https://rdrr.io/r/base/c.html)("ibuprofen", "aspirin", "diclofenac"),
      indicationCohort = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object.

ingredient
    

Name of ingredient to benchmark.

alternativeIngredient
    

Name of ingredients to use as alternative treatments.

indicationCohort
    

Name of a cohort in the cdm_reference object to use as indicatiomn.

## Value

A summarise_result object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    #> ℹ `EUNOMIA_DATA_FOLDER` set to: /tmp/Rtmp2H2pze.
    #> 
    #> Download completed!
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()))
    #> Creating CDM database /tmp/Rtmp2H2pze/GiBleed_5.3.zip
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    timings <- benchmarkDrugUtilisation(cdm)
    #> 03-07-2025 14:01:05 Benchmark get necessary concepts
    #> 03-07-2025 14:01:05 Benchmark generateDrugUtilisation
    #> 03-07-2025 14:01:08 Benchmark generateDrugUtilisation with numberExposures and
    #> daysPrescribed
    #> 03-07-2025 14:01:11 Benchmark require
    #> 03-07-2025 14:01:13 Benchmark generateIngredientCohortSet
    #> 03-07-2025 14:01:18 Benchmark summariseDrugUtilisation
    #> 03-07-2025 14:01:24 Benchmark summariseDrugRestart
    #> 03-07-2025 14:01:26 Benchmark summariseProportionOfPatientsCovered
    #> 03-07-2025 14:01:31 Benchmark summariseTreatment
    #> 03-07-2025 14:01:34 Benchmark drop created tables
    
    timings
    #> # A tibble: 10 × 13
    #>    result_id cdm_name group_name group_level            strata_name strata_level
    #>        <int> <chr>    <chr>      <chr>                  <chr>       <chr>       
    #>  1         1 Synthea  task       get necessary concepts overall     overall     
    #>  2         1 Synthea  task       generateDrugUtilisati… overall     overall     
    #>  3         1 Synthea  task       generateDrugUtilisati… overall     overall     
    #>  4         1 Synthea  task       require                overall     overall     
    #>  5         1 Synthea  task       generateIngredientCoh… overall     overall     
    #>  6         1 Synthea  task       summariseDrugUtilisat… overall     overall     
    #>  7         1 Synthea  task       summariseDrugRestart   overall     overall     
    #>  8         1 Synthea  task       summariseProportionOf… overall     overall     
    #>  9         1 Synthea  task       summariseTreatment     overall     overall     
    #> 10         1 Synthea  task       drop created tables    overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
