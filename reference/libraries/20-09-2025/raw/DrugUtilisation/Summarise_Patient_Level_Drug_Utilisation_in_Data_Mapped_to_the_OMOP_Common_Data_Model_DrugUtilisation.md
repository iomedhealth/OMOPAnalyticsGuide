# Summarise Patient-Level Drug Utilisation in Data Mapped to the OMOP Common Data Model • DrugUtilisation

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
