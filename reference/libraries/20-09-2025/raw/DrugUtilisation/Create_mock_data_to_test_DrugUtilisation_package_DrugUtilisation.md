# Create mock data to test DrugUtilisation package • DrugUtilisation

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
