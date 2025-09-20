# Content from https://darwin-eu.github.io/PatientProfiles/


---

## Content from https://darwin-eu.github.io/PatientProfiles/

Skip to contents

[PatientProfiles](index.html) 1.4.2

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](articles/demographics.html)
    * [Adding cohort intersections](articles/cohort-intersect.html)
    * [Adding concept intersections](articles/concept-intersect.html)
    * [Adding table intersections](articles/table-intersect.html)
    * [Summarise result](articles/summarise.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](logo.png)

# PatientProfiles 

[![CRAN status](https://www.r-pkg.org/badges/version/PatientProfiles)](https://CRAN.R-project.org/package=PatientProfiles) [![R-CMD-check](https://github.com/darwin-eu/PatientProfiles/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/PatientProfiles/actions) [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![metacran downloads](https://cranlogs.r-pkg.org/badges/PatientProfiles)](https://cran.r-project.org/package=PatientProfiles) [![metacran downloads](https://cranlogs.r-pkg.org/badges/grand-total/PatientProfiles)](https://cran.r-project.org/package=PatientProfiles)

## Package overview

PatientProfiles contains functions for adding characteristics to OMOP CDM tables containing patient level data (e.g. condition occurrence, drug exposure, and so on) and OMOP CDM cohort tables. The characteristics that can be added include an individual´s sex, age, and days of prior observation Time varying characteristics, such as age, can be estimated relative to any date in the corresponding table. In addition, PatientProfiles also provides functionality for identifying intersections between a cohort table and OMOP CDM tables containing patient level data or other cohort tables.

## Package installation

You can install the latest version of PatientProfiles like so:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("PatientProfiles")

## Citation
    
    
    [citation](https://rdrr.io/r/utils/citation.html)("PatientProfiles")
    #> To cite package 'PatientProfiles' in publications use:
    #> 
    #>   Catala M, Guo Y, Du M, Lopez-Guell K, Burn E, Mercade-Besora N
    #>   (????). _PatientProfiles: Identify Characteristics of Patients in the
    #>   OMOP Common Data Model_. R package version 1.3.1,
    #>   <https://darwin-eu.github.io/PatientProfiles/>.
    #> 
    #> A BibTeX entry for LaTeX users is
    #> 
    #>   @Manual{,
    #>     title = {PatientProfiles: Identify Characteristics of Patients in the OMOP Common Data Model},
    #>     author = {Marti Catala and Yuchen Guo and Mike Du and Kim Lopez-Guell and Edward Burn and Nuria Mercade-Besora},
    #>     note = {R package version 1.3.1},
    #>     url = {https://darwin-eu.github.io/PatientProfiles/},
    #>   }

## Example usage

### Create a reference to data in the OMOP CDM format

The PatientProfiles package is designed to work with data in the OMOP CDM format, so our first step is to create a reference to the data using the CDMConnector package.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))

Creating a connection to a Postgres database would for example look like:
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(
      RPostgres::[Postgres](https://rpostgres.r-dbi.org/reference/Postgres.html)(),
      dbname = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_DBNAME"),
      host = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_HOST"),
      user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_USER"),
      password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_PASSWORD")
    )
    
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con,
      cdmSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_CDM_SCHEMA"),
      writeSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_RESULT_SCHEMA")
    )

To see how you would create a reference to your database please consult the CDMConnector package [documentation](https://darwin-eu.github.io/CDMConnector/articles/a04_DBI_connection_examples.html). For this example though we’ll work with simulated data, and we’ll generate an example cdm reference like so:
    
    
    cdm <- [mockPatientProfiles](reference/mockPatientProfiles.html)(numberIndividuals = 1000)

### Adding individuals´ characteristics

#### Adding characteristics to patient-level data

Say we wanted to get individuals´sex and age at condition start date for records in the condition occurrence table. We can use the `addAge` and `addSex` functions to do this:
    
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ person_id                 <int> 156, 458, 327, 609, 621, 173, 549, 381, 578,…
    #> $ condition_start_date      <date> 1955-09-02, 1942-08-31, 1995-07-25, 1981-07…
    #> $ condition_end_date        <date> 1965-08-19, 1953-11-24, 1998-09-22, 1987-04…
    #> $ condition_occurrence_id   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1…
    #> $ condition_concept_id      <int> 2, 9, 5, 5, 3, 3, 4, 1, 9, 9, 9, 3, 10, 8, 4…
    #> $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    
    cdm$condition_occurrence <- cdm$condition_occurrence |>
      [addAge](reference/addAge.html)(indexDate = "condition_start_date") |>
      [addSex](reference/addSex.html)()
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 8
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ person_id                 <int> 156, 621, 173, 381, 557, 963, 653, 998, 719,…
    #> $ condition_start_date      <date> 1955-09-02, 1969-04-08, 1970-04-30, 1981-01…
    #> $ condition_end_date        <date> 1965-08-19, 1972-10-10, 1971-01-03, 1983-02…
    #> $ condition_occurrence_id   <int> 1, 5, 6, 8, 13, 14, 15, 19, 20, 22, 23, 24, …
    #> $ condition_concept_id      <int> 2, 3, 3, 1, 10, 8, 4, 10, 8, 10, 9, 1, 6, 8,…
    #> $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ age                       <int> 3, 6, 5, 19, 21, 11, 30, 9, 21, 7, 13, 5, 2,…
    #> $ sex                       <chr> "Female", "Female", "Female", "Female", "Mal…

We could, for example, then limit our data to only males aged between 18 and 65
    
    
    cdm$condition_occurrence |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(age >= 18 & age <= 65) |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(sex == "Male")
    #> # Source:   SQL [?? x 8]
    #> # Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #>    person_id condition_start_date condition_end_date condition_occurrence_id
    #>        <int> <date>               <date>                               <int>
    #>  1       557 1944-07-25           1952-04-19                              13
    #>  2       351 1983-06-01           1994-12-31                              27
    #>  3       194 2000-03-09           2000-09-29                              29
    #>  4       199 1980-10-21           1982-04-19                              42
    #>  5       833 1985-11-19           1989-08-19                              45
    #>  6       444 1968-07-28           1968-10-27                              49
    #>  7       131 1975-12-15           1977-06-01                              60
    #>  8       345 1963-03-31           1964-08-23                              70
    #>  9       273 1994-05-07           1996-06-21                              71
    #> 10       495 1993-08-14           1998-04-26                              85
    #> # ℹ more rows
    #> # ℹ 4 more variables: condition_concept_id <int>,
    #> #   condition_type_concept_id <int>, age <int>, sex <chr>

#### Adding characteristics of a cohort

As with other tables in the OMOP CDM, we can work in a similar way with cohort tables. For example, say we have the below cohort table
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 3, 1, 1, 1, 1, 3, 2, 2, 2, 2, 1, 3, 1, 3, 1, 3, 2…
    #> $ subject_id           <int> 306, 387, 912, 870, 878, 45, 833, 149, 110, 616, …
    #> $ cohort_start_date    <date> 1930-04-19, 1989-05-12, 1973-08-21, 1915-07-03, …
    #> $ cohort_end_date      <date> 1942-01-05, 1998-01-16, 1977-03-13, 1929-02-26, …

We can add age, age groups, sex, and days of prior observation to a cohort like so
    
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addAge](reference/addAge.html)(
        indexDate = "cohort_start_date",
        ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 18), [c](https://rdrr.io/r/base/c.html)(19, 65), [c](https://rdrr.io/r/base/c.html)(66, 100))
      ) |>
      [addSex](reference/addSex.html)() |>
      [addPriorObservation](reference/addPriorObservation.html)()
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 8
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 3, 2, 2, 1, 1, 3, 2, 2, 2, 3, 3, 1, 3, 1, 1…
    #> $ subject_id           <int> 387, 878, 45, 149, 616, 875, 508, 581, 268, 579, …
    #> $ cohort_start_date    <date> 1989-05-12, 1972-03-14, 1957-09-03, 1937-05-06, …
    #> $ cohort_end_date      <date> 1998-01-16, 1979-09-21, 1959-02-08, 1942-05-13, …
    #> $ age                  <int> 22, 7, 8, 5, 31, 20, 9, 21, 22, 9, 7, 10, 18, 8, …
    #> $ age_group            <chr> "19 to 65", "0 to 18", "0 to 18", "0 to 18", "19 …
    #> $ sex                  <chr> "Male", "Female", "Male", "Female", "Male", "Male…
    #> $ prior_observation    <int> 8167, 2629, 3167, 1952, 11535, 7502, 3411, 7839, …

We could use this information to subset the cohort. For example limiting to those with at least 365 days of prior observation available before their cohort start date like so
    
    
    cdm$cohort1 |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(prior_observation >= 365)
    #> # Source:   SQL [?? x 8]
    #> # Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    #>                   <int>      <int> <date>            <date>          <int>
    #>  1                    1        387 1989-05-12        1998-01-16         22
    #>  2                    1        878 1972-03-14        1979-09-21          7
    #>  3                    3         45 1957-09-03        1959-02-08          8
    #>  4                    2        149 1937-05-06        1942-05-13          5
    #>  5                    2        616 1970-08-01        1974-02-04         31
    #>  6                    1        875 1990-07-17        1993-06-17         20
    #>  7                    1        508 1939-05-05        1952-11-20          9
    #>  8                    3        581 1989-06-18        1994-05-29         21
    #>  9                    2        268 1944-10-25        1952-11-04         22
    #> 10                    2        579 1939-01-29        1962-07-06          9
    #> # ℹ more rows
    #> # ℹ 3 more variables: age_group <chr>, sex <chr>, prior_observation <int>

### Cohort intersections

#### Detect the presence of another cohort in a certain window

We can use `addCohortIntersectFlag` to add a flag for the presence (or not) of a cohort in a certain window.
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 2, 2, 3, 2, 2, 2, 1, 1, 1
    #> $ subject_id           <int> 5, 2, 1, 7, 10, 4, 8, 3, 6, 9
    #> $ cohort_start_date    <date> 1968-12-04, 1938-06-13, 1906-07-16, 1945-11-11, 1…
    #> $ cohort_end_date      <date> 1968-12-27, 1948-07-14, 1907-02-09, 1946-08-25, 1…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectFlag](reference/addCohortIntersectFlag.html)(
        targetCohortTable = "cohort2",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 7
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 2, 1, 2, 2, 3, 2, 2, 1, 1
    #> $ subject_id           <int> 5, 4, 6, 2, 1, 7, 10, 8, 3, 9
    #> $ cohort_start_date    <date> 1968-12-04, 1926-12-18, 1966-04-26, 1938-06-13, 1…
    #> $ cohort_end_date      <date> 1968-12-27, 1939-10-18, 1985-01-13, 1948-07-14, 1…
    #> $ cohort_3_minf_to_m1  <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
    #> $ cohort_1_minf_to_m1  <dbl> 0, 1, 1, 0, 0, 0, 0, 0, 0, 0
    #> $ cohort_2_minf_to_m1  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

#### Count appearances of a certain cohort in a certain window

If we wanted the number of appearances, we could instead use the `addCohortIntersectCount` function
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 3, 3, 3, 3, 1, 3, 1, 1, 2
    #> $ subject_id           <int> 2, 3, 7, 10, 1, 5, 8, 6, 4, 9
    #> $ cohort_start_date    <date> 2015-12-01, 1987-07-03, 1953-10-15, 1968-10-21, 1…
    #> $ cohort_end_date      <date> 2019-03-15, 2002-10-16, 1957-02-19, 1979-11-29, 1…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectCount](reference/addCohortIntersectCount.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        window = [list](https://rdrr.io/r/base/list.html)("short_term" = [c](https://rdrr.io/r/base/c.html)(1, 30), "mid_term" = [c](https://rdrr.io/r/base/c.html)(31, 180))
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 2, 2, 3, 3, 3, 3, 1, 3, 1
    #> $ subject_id           <int> 4, 9, 2, 3, 7, 10, 1, 5, 8, 6
    #> $ cohort_start_date    <date> 1953-04-13, 1977-10-03, 2015-12-01, 1987-07-03, 1…
    #> $ cohort_end_date      <date> 1974-09-21, 1981-04-22, 2019-03-15, 2002-10-16, 1…
    #> $ cohort_1_mid_term    <dbl> 1, 1, 0, 0, 0, 0, 0, 0, 0, 0
    #> $ cohort_1_short_term  <dbl> 1, 1, 0, 0, 0, 0, 0, 0, 0, 0

#### Add a column with the first/last event in a certain window

Say we wanted the date at which an individual was in another cohort then we can use the `addCohortIntersectDate` function. As there might be multiple records for the other cohort, we can also choose the first or the last appearance in that cohort.

First occurrence:
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 3, 1, 3, 1, 3, 1, 3, 2, 1
    #> $ subject_id           <int> 5, 4, 9, 7, 2, 8, 3, 1, 10, 6
    #> $ cohort_start_date    <date> 1941-08-04, 1945-09-24, 1937-10-13, 1929-07-16, 1…
    #> $ cohort_end_date      <date> 1942-06-25, 1981-02-18, 1937-11-05, 1929-11-22, 1…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectDate](reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        order = "first",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 3, 2, 3, 1, 3, 1, 3, 2, 1
    #> $ subject_id           <int> 2, 8, 5, 4, 9, 7, 3, 1, 10, 6
    #> $ cohort_start_date    <date> 1956-05-06, 1973-09-24, 1941-08-04, 1945-09-24, 1…
    #> $ cohort_end_date      <date> 1986-02-01, 1980-04-14, 1942-06-25, 1981-02-18, 1…
    #> $ cohort_1_minf_to_inf <date> 1979-06-01, 1966-08-16, NA, NA, NA, NA, NA, NA, …

Last occurrence:
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 3, 3, 2, 2, 1, 2, 2, 3, 3, 2
    #> $ subject_id           <int> 2, 6, 4, 8, 10, 9, 1, 5, 3, 7
    #> $ cohort_start_date    <date> 1944-08-01, 1947-06-17, 1904-03-09, 1957-03-05, 2…
    #> $ cohort_end_date      <date> 1946-08-20, 1951-02-15, 1927-06-28, 1962-09-09, 2…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectDate](reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 3, 2, 3, 3, 3, 2, 1, 2, 2, 2
    #> $ subject_id           <int> 6, 4, 5, 3, 2, 8, 10, 9, 1, 7
    #> $ cohort_start_date    <date> 1947-06-17, 1904-03-09, 1913-06-09, 1924-09-15, 1…
    #> $ cohort_end_date      <date> 1951-02-15, 1927-06-28, 1920-06-29, 1930-01-23, 1…
    #> $ cohort_1_minf_to_inf <date> 1936-02-23, 1906-08-30, 1930-05-25, 1935-04-03, …

#### Add the number of days instead of the date

Instead of returning a date, we could return the days to the intersection by using `addCohortIntersectDays`
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 2, 1, 2, 2, 1, 3, 3, 1, 3
    #> $ subject_id           <int> 5, 9, 10, 3, 4, 1, 2, 8, 7, 6
    #> $ cohort_start_date    <date> 1908-03-05, 1904-07-25, 1956-01-18, 2012-03-18, 1…
    #> $ cohort_end_date      <date> 1909-07-11, 1908-01-27, 1969-04-26, 2013-12-06, 1…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectDays](reference/addCohortIntersectDays.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 2, 2, 2, 1, 1, 3, 3, 1, 3
    #> $ subject_id           <int> 5, 9, 3, 4, 10, 1, 2, 8, 7, 6
    #> $ cohort_start_date    <date> 1908-03-05, 1904-07-25, 2012-03-18, 1907-03-23, 1…
    #> $ cohort_end_date      <date> 1909-07-11, 1908-01-27, 2013-12-06, 1916-10-25, 1…
    #> $ cohort_1_minf_to_inf <dbl> 964, 937, -7714, 5191, NA, NA, NA, NA, NA, NA

#### Combine multiple cohort intersects

If we want to combine multiple cohort intersects we can concatenate the operations using the `pipe` operator:
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 3, 2, 1, 3, 2, 2, 3, 3, 2
    #> $ subject_id           <int> 9, 2, 7, 8, 1, 3, 5, 6, 4, 10
    #> $ cohort_start_date    <date> 1976-04-06, 1950-11-24, 2010-05-13, 1949-09-30, 1…
    #> $ cohort_end_date      <date> 1992-07-18, 1955-08-08, 2010-09-07, 1957-09-29, 2…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectDate](reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      ) |>
      [addCohortIntersectCount](reference/addCohortIntersectCount.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 3, 1, 3, 2, 3, 2, 2, 3, 2
    #> $ subject_id           <int> 9, 2, 8, 1, 5, 6, 7, 3, 4, 10
    #> $ cohort_start_date    <date> 1976-04-06, 1950-11-24, 1949-09-30, 1996-03-01, 1…
    #> $ cohort_end_date      <date> 1992-07-18, 1955-08-08, 1957-09-29, 2013-06-08, 2…
    #> $ cohort_1_minf_to_inf <dbl> 1, 1, 1, 1, 1, 1, 0, 0, 0, 0
    
    
    [mockDisconnect](reference/mockDisconnect.html)(cdm)

## Links

  * [View on CRAN](https://cloud.r-project.org/package=PatientProfiles)
  * [Browse source code](https://github.com/darwin-eu/PatientProfiles/)
  * [Report a bug](https://github.com/darwin-eu/PatientProfiles/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Community

  * [Contributing guide](CONTRIBUTING.html)



## Citation

  * [Citing PatientProfiles](authors.html#citation)



## Developers

  * Martí Català   
Author, maintainer  [](https://orcid.org/0000-0003-3308-9905)
  * Yuchen Guo   
Author  [](https://orcid.org/0000-0002-0847-4855)
  * Mike Du   
Author  [](https://orcid.org/0000-0002-9517-8834)
  * Kim Lopez-Guell   
Author  [](https://orcid.org/0000-0002-8462-8668)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * [More about authors...](authors.html)



Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/index.html

Skip to contents

[PatientProfiles](index.html) 1.4.2

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](articles/demographics.html)
    * [Adding cohort intersections](articles/cohort-intersect.html)
    * [Adding concept intersections](articles/concept-intersect.html)
    * [Adding table intersections](articles/table-intersect.html)
    * [Summarise result](articles/summarise.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](logo.png)

# PatientProfiles 

[![CRAN status](https://www.r-pkg.org/badges/version/PatientProfiles)](https://CRAN.R-project.org/package=PatientProfiles) [![R-CMD-check](https://github.com/darwin-eu/PatientProfiles/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/PatientProfiles/actions) [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![metacran downloads](https://cranlogs.r-pkg.org/badges/PatientProfiles)](https://cran.r-project.org/package=PatientProfiles) [![metacran downloads](https://cranlogs.r-pkg.org/badges/grand-total/PatientProfiles)](https://cran.r-project.org/package=PatientProfiles)

## Package overview

PatientProfiles contains functions for adding characteristics to OMOP CDM tables containing patient level data (e.g. condition occurrence, drug exposure, and so on) and OMOP CDM cohort tables. The characteristics that can be added include an individual´s sex, age, and days of prior observation Time varying characteristics, such as age, can be estimated relative to any date in the corresponding table. In addition, PatientProfiles also provides functionality for identifying intersections between a cohort table and OMOP CDM tables containing patient level data or other cohort tables.

## Package installation

You can install the latest version of PatientProfiles like so:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("PatientProfiles")

## Citation
    
    
    [citation](https://rdrr.io/r/utils/citation.html)("PatientProfiles")
    #> To cite package 'PatientProfiles' in publications use:
    #> 
    #>   Catala M, Guo Y, Du M, Lopez-Guell K, Burn E, Mercade-Besora N
    #>   (????). _PatientProfiles: Identify Characteristics of Patients in the
    #>   OMOP Common Data Model_. R package version 1.3.1,
    #>   <https://darwin-eu.github.io/PatientProfiles/>.
    #> 
    #> A BibTeX entry for LaTeX users is
    #> 
    #>   @Manual{,
    #>     title = {PatientProfiles: Identify Characteristics of Patients in the OMOP Common Data Model},
    #>     author = {Marti Catala and Yuchen Guo and Mike Du and Kim Lopez-Guell and Edward Burn and Nuria Mercade-Besora},
    #>     note = {R package version 1.3.1},
    #>     url = {https://darwin-eu.github.io/PatientProfiles/},
    #>   }

## Example usage

### Create a reference to data in the OMOP CDM format

The PatientProfiles package is designed to work with data in the OMOP CDM format, so our first step is to create a reference to the data using the CDMConnector package.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))

Creating a connection to a Postgres database would for example look like:
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(
      RPostgres::[Postgres](https://rpostgres.r-dbi.org/reference/Postgres.html)(),
      dbname = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_DBNAME"),
      host = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_HOST"),
      user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_USER"),
      password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_PASSWORD")
    )
    
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con,
      cdmSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_CDM_SCHEMA"),
      writeSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_RESULT_SCHEMA")
    )

To see how you would create a reference to your database please consult the CDMConnector package [documentation](https://darwin-eu.github.io/CDMConnector/articles/a04_DBI_connection_examples.html). For this example though we’ll work with simulated data, and we’ll generate an example cdm reference like so:
    
    
    cdm <- [mockPatientProfiles](reference/mockPatientProfiles.html)(numberIndividuals = 1000)

### Adding individuals´ characteristics

#### Adding characteristics to patient-level data

Say we wanted to get individuals´sex and age at condition start date for records in the condition occurrence table. We can use the `addAge` and `addSex` functions to do this:
    
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ person_id                 <int> 156, 458, 327, 609, 621, 173, 549, 381, 578,…
    #> $ condition_start_date      <date> 1955-09-02, 1942-08-31, 1995-07-25, 1981-07…
    #> $ condition_end_date        <date> 1965-08-19, 1953-11-24, 1998-09-22, 1987-04…
    #> $ condition_occurrence_id   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1…
    #> $ condition_concept_id      <int> 2, 9, 5, 5, 3, 3, 4, 1, 9, 9, 9, 3, 10, 8, 4…
    #> $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    
    cdm$condition_occurrence <- cdm$condition_occurrence |>
      [addAge](reference/addAge.html)(indexDate = "condition_start_date") |>
      [addSex](reference/addSex.html)()
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 8
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ person_id                 <int> 156, 621, 173, 381, 557, 963, 653, 998, 719,…
    #> $ condition_start_date      <date> 1955-09-02, 1969-04-08, 1970-04-30, 1981-01…
    #> $ condition_end_date        <date> 1965-08-19, 1972-10-10, 1971-01-03, 1983-02…
    #> $ condition_occurrence_id   <int> 1, 5, 6, 8, 13, 14, 15, 19, 20, 22, 23, 24, …
    #> $ condition_concept_id      <int> 2, 3, 3, 1, 10, 8, 4, 10, 8, 10, 9, 1, 6, 8,…
    #> $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ age                       <int> 3, 6, 5, 19, 21, 11, 30, 9, 21, 7, 13, 5, 2,…
    #> $ sex                       <chr> "Female", "Female", "Female", "Female", "Mal…

We could, for example, then limit our data to only males aged between 18 and 65
    
    
    cdm$condition_occurrence |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(age >= 18 & age <= 65) |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(sex == "Male")
    #> # Source:   SQL [?? x 8]
    #> # Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #>    person_id condition_start_date condition_end_date condition_occurrence_id
    #>        <int> <date>               <date>                               <int>
    #>  1       557 1944-07-25           1952-04-19                              13
    #>  2       351 1983-06-01           1994-12-31                              27
    #>  3       194 2000-03-09           2000-09-29                              29
    #>  4       199 1980-10-21           1982-04-19                              42
    #>  5       833 1985-11-19           1989-08-19                              45
    #>  6       444 1968-07-28           1968-10-27                              49
    #>  7       131 1975-12-15           1977-06-01                              60
    #>  8       345 1963-03-31           1964-08-23                              70
    #>  9       273 1994-05-07           1996-06-21                              71
    #> 10       495 1993-08-14           1998-04-26                              85
    #> # ℹ more rows
    #> # ℹ 4 more variables: condition_concept_id <int>,
    #> #   condition_type_concept_id <int>, age <int>, sex <chr>

#### Adding characteristics of a cohort

As with other tables in the OMOP CDM, we can work in a similar way with cohort tables. For example, say we have the below cohort table
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 3, 1, 1, 1, 1, 3, 2, 2, 2, 2, 1, 3, 1, 3, 1, 3, 2…
    #> $ subject_id           <int> 306, 387, 912, 870, 878, 45, 833, 149, 110, 616, …
    #> $ cohort_start_date    <date> 1930-04-19, 1989-05-12, 1973-08-21, 1915-07-03, …
    #> $ cohort_end_date      <date> 1942-01-05, 1998-01-16, 1977-03-13, 1929-02-26, …

We can add age, age groups, sex, and days of prior observation to a cohort like so
    
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addAge](reference/addAge.html)(
        indexDate = "cohort_start_date",
        ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 18), [c](https://rdrr.io/r/base/c.html)(19, 65), [c](https://rdrr.io/r/base/c.html)(66, 100))
      ) |>
      [addSex](reference/addSex.html)() |>
      [addPriorObservation](reference/addPriorObservation.html)()
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 8
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 3, 2, 2, 1, 1, 3, 2, 2, 2, 3, 3, 1, 3, 1, 1…
    #> $ subject_id           <int> 387, 878, 45, 149, 616, 875, 508, 581, 268, 579, …
    #> $ cohort_start_date    <date> 1989-05-12, 1972-03-14, 1957-09-03, 1937-05-06, …
    #> $ cohort_end_date      <date> 1998-01-16, 1979-09-21, 1959-02-08, 1942-05-13, …
    #> $ age                  <int> 22, 7, 8, 5, 31, 20, 9, 21, 22, 9, 7, 10, 18, 8, …
    #> $ age_group            <chr> "19 to 65", "0 to 18", "0 to 18", "0 to 18", "19 …
    #> $ sex                  <chr> "Male", "Female", "Male", "Female", "Male", "Male…
    #> $ prior_observation    <int> 8167, 2629, 3167, 1952, 11535, 7502, 3411, 7839, …

We could use this information to subset the cohort. For example limiting to those with at least 365 days of prior observation available before their cohort start date like so
    
    
    cdm$cohort1 |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(prior_observation >= 365)
    #> # Source:   SQL [?? x 8]
    #> # Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    #>                   <int>      <int> <date>            <date>          <int>
    #>  1                    1        387 1989-05-12        1998-01-16         22
    #>  2                    1        878 1972-03-14        1979-09-21          7
    #>  3                    3         45 1957-09-03        1959-02-08          8
    #>  4                    2        149 1937-05-06        1942-05-13          5
    #>  5                    2        616 1970-08-01        1974-02-04         31
    #>  6                    1        875 1990-07-17        1993-06-17         20
    #>  7                    1        508 1939-05-05        1952-11-20          9
    #>  8                    3        581 1989-06-18        1994-05-29         21
    #>  9                    2        268 1944-10-25        1952-11-04         22
    #> 10                    2        579 1939-01-29        1962-07-06          9
    #> # ℹ more rows
    #> # ℹ 3 more variables: age_group <chr>, sex <chr>, prior_observation <int>

### Cohort intersections

#### Detect the presence of another cohort in a certain window

We can use `addCohortIntersectFlag` to add a flag for the presence (or not) of a cohort in a certain window.
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 2, 2, 3, 2, 2, 2, 1, 1, 1
    #> $ subject_id           <int> 5, 2, 1, 7, 10, 4, 8, 3, 6, 9
    #> $ cohort_start_date    <date> 1968-12-04, 1938-06-13, 1906-07-16, 1945-11-11, 1…
    #> $ cohort_end_date      <date> 1968-12-27, 1948-07-14, 1907-02-09, 1946-08-25, 1…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectFlag](reference/addCohortIntersectFlag.html)(
        targetCohortTable = "cohort2",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 7
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 2, 1, 2, 2, 3, 2, 2, 1, 1
    #> $ subject_id           <int> 5, 4, 6, 2, 1, 7, 10, 8, 3, 9
    #> $ cohort_start_date    <date> 1968-12-04, 1926-12-18, 1966-04-26, 1938-06-13, 1…
    #> $ cohort_end_date      <date> 1968-12-27, 1939-10-18, 1985-01-13, 1948-07-14, 1…
    #> $ cohort_3_minf_to_m1  <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
    #> $ cohort_1_minf_to_m1  <dbl> 0, 1, 1, 0, 0, 0, 0, 0, 0, 0
    #> $ cohort_2_minf_to_m1  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

#### Count appearances of a certain cohort in a certain window

If we wanted the number of appearances, we could instead use the `addCohortIntersectCount` function
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 3, 3, 3, 3, 1, 3, 1, 1, 2
    #> $ subject_id           <int> 2, 3, 7, 10, 1, 5, 8, 6, 4, 9
    #> $ cohort_start_date    <date> 2015-12-01, 1987-07-03, 1953-10-15, 1968-10-21, 1…
    #> $ cohort_end_date      <date> 2019-03-15, 2002-10-16, 1957-02-19, 1979-11-29, 1…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectCount](reference/addCohortIntersectCount.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        window = [list](https://rdrr.io/r/base/list.html)("short_term" = [c](https://rdrr.io/r/base/c.html)(1, 30), "mid_term" = [c](https://rdrr.io/r/base/c.html)(31, 180))
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 2, 2, 3, 3, 3, 3, 1, 3, 1
    #> $ subject_id           <int> 4, 9, 2, 3, 7, 10, 1, 5, 8, 6
    #> $ cohort_start_date    <date> 1953-04-13, 1977-10-03, 2015-12-01, 1987-07-03, 1…
    #> $ cohort_end_date      <date> 1974-09-21, 1981-04-22, 2019-03-15, 2002-10-16, 1…
    #> $ cohort_1_mid_term    <dbl> 1, 1, 0, 0, 0, 0, 0, 0, 0, 0
    #> $ cohort_1_short_term  <dbl> 1, 1, 0, 0, 0, 0, 0, 0, 0, 0

#### Add a column with the first/last event in a certain window

Say we wanted the date at which an individual was in another cohort then we can use the `addCohortIntersectDate` function. As there might be multiple records for the other cohort, we can also choose the first or the last appearance in that cohort.

First occurrence:
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 3, 1, 3, 1, 3, 1, 3, 2, 1
    #> $ subject_id           <int> 5, 4, 9, 7, 2, 8, 3, 1, 10, 6
    #> $ cohort_start_date    <date> 1941-08-04, 1945-09-24, 1937-10-13, 1929-07-16, 1…
    #> $ cohort_end_date      <date> 1942-06-25, 1981-02-18, 1937-11-05, 1929-11-22, 1…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectDate](reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        order = "first",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 3, 2, 3, 1, 3, 1, 3, 2, 1
    #> $ subject_id           <int> 2, 8, 5, 4, 9, 7, 3, 1, 10, 6
    #> $ cohort_start_date    <date> 1956-05-06, 1973-09-24, 1941-08-04, 1945-09-24, 1…
    #> $ cohort_end_date      <date> 1986-02-01, 1980-04-14, 1942-06-25, 1981-02-18, 1…
    #> $ cohort_1_minf_to_inf <date> 1979-06-01, 1966-08-16, NA, NA, NA, NA, NA, NA, …

Last occurrence:
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 3, 3, 2, 2, 1, 2, 2, 3, 3, 2
    #> $ subject_id           <int> 2, 6, 4, 8, 10, 9, 1, 5, 3, 7
    #> $ cohort_start_date    <date> 1944-08-01, 1947-06-17, 1904-03-09, 1957-03-05, 2…
    #> $ cohort_end_date      <date> 1946-08-20, 1951-02-15, 1927-06-28, 1962-09-09, 2…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectDate](reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 3, 2, 3, 3, 3, 2, 1, 2, 2, 2
    #> $ subject_id           <int> 6, 4, 5, 3, 2, 8, 10, 9, 1, 7
    #> $ cohort_start_date    <date> 1947-06-17, 1904-03-09, 1913-06-09, 1924-09-15, 1…
    #> $ cohort_end_date      <date> 1951-02-15, 1927-06-28, 1920-06-29, 1930-01-23, 1…
    #> $ cohort_1_minf_to_inf <date> 1936-02-23, 1906-08-30, 1930-05-25, 1935-04-03, …

#### Add the number of days instead of the date

Instead of returning a date, we could return the days to the intersection by using `addCohortIntersectDays`
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 2, 1, 2, 2, 1, 3, 3, 1, 3
    #> $ subject_id           <int> 5, 9, 10, 3, 4, 1, 2, 8, 7, 6
    #> $ cohort_start_date    <date> 1908-03-05, 1904-07-25, 1956-01-18, 2012-03-18, 1…
    #> $ cohort_end_date      <date> 1909-07-11, 1908-01-27, 1969-04-26, 2013-12-06, 1…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectDays](reference/addCohortIntersectDays.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 1, 2, 2, 2, 1, 1, 3, 3, 1, 3
    #> $ subject_id           <int> 5, 9, 3, 4, 10, 1, 2, 8, 7, 6
    #> $ cohort_start_date    <date> 1908-03-05, 1904-07-25, 2012-03-18, 1907-03-23, 1…
    #> $ cohort_end_date      <date> 1909-07-11, 1908-01-27, 2013-12-06, 1916-10-25, 1…
    #> $ cohort_1_minf_to_inf <dbl> 964, 937, -7714, 5191, NA, NA, NA, NA, NA, NA

#### Combine multiple cohort intersects

If we want to combine multiple cohort intersects we can concatenate the operations using the `pipe` operator:
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 3, 2, 1, 3, 2, 2, 3, 3, 2
    #> $ subject_id           <int> 9, 2, 7, 8, 1, 3, 5, 6, 4, 10
    #> $ cohort_start_date    <date> 1976-04-06, 1950-11-24, 2010-05-13, 1949-09-30, 1…
    #> $ cohort_end_date      <date> 1992-07-18, 1955-08-08, 2010-09-07, 1957-09-29, 2…
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addCohortIntersectDate](reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      ) |>
      [addCohortIntersectCount](reference/addCohortIntersectCount.html)(
        targetCohortTable = "cohort2",
        targetCohortId = 1,
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      )
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.2.0 [root@Darwin 24.3.0:R 4.4.1/:memory:]
    #> $ cohort_definition_id <int> 2, 3, 1, 3, 2, 3, 2, 2, 3, 2
    #> $ subject_id           <int> 9, 2, 8, 1, 5, 6, 7, 3, 4, 10
    #> $ cohort_start_date    <date> 1976-04-06, 1950-11-24, 1949-09-30, 1996-03-01, 1…
    #> $ cohort_end_date      <date> 1992-07-18, 1955-08-08, 1957-09-29, 2013-06-08, 2…
    #> $ cohort_1_minf_to_inf <dbl> 1, 1, 1, 1, 1, 1, 0, 0, 0, 0
    
    
    [mockDisconnect](reference/mockDisconnect.html)(cdm)

## Links

  * [View on CRAN](https://cloud.r-project.org/package=PatientProfiles)
  * [Browse source code](https://github.com/darwin-eu/PatientProfiles/)
  * [Report a bug](https://github.com/darwin-eu/PatientProfiles/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Community

  * [Contributing guide](CONTRIBUTING.html)



## Citation

  * [Citing PatientProfiles](authors.html#citation)



## Developers

  * Martí Català   
Author, maintainer  [](https://orcid.org/0000-0003-3308-9905)
  * Yuchen Guo   
Author  [](https://orcid.org/0000-0002-0847-4855)
  * Mike Du   
Author  [](https://orcid.org/0000-0002-9517-8834)
  * Kim Lopez-Guell   
Author  [](https://orcid.org/0000-0002-8462-8668)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * [More about authors...](authors.html)



Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/index.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Package index

### Add individual patient characteristics

Add patient characteristics to a table in the OMOP Common Data Model

`[addAge()](addAge.html)`
    Compute the age of the individuals at a certain date

`[addSex()](addSex.html)`
    Compute the sex of the individuals

`[addDateOfBirth()](addDateOfBirth.html)`
    Add a column with the individual birth date

`[addPriorObservation()](addPriorObservation.html)`
    Compute the number of days of prior observation in the current observation period at a certain date

`[addFutureObservation()](addFutureObservation.html)`
    Compute the number of days till the end of the observation period at a certain date

`[addInObservation()](addInObservation.html)`
    Indicate if a certain record is within the observation period

### Add multiple individual patient characteristics

Add a set of patient characteristics to a table in the OMOP Common Data Model

`[addDemographics()](addDemographics.html)`
    Compute demographic characteristics at a certain date

### Add death information

Add patient death information to a table in the OMOP Common Data Model

`[addDeathDate()](addDeathDate.html)`
    Add date of death for individuals. Only death within the same observation period than `indexDate` will be observed.

`[addDeathDays()](addDeathDays.html)`
    Add days to death for individuals. Only death within the same observation period than `indexDate` will be observed.

`[addDeathFlag()](addDeathFlag.html)`
    Add flag for death for individuals. Only death within the same observation period than `indexDate` will be observed.

### Add a value from a cohort intersection

Add a variable indicating the intersection between a table in the OMOP Common Data Model and a cohort table.

`[addCohortIntersectCount()](addCohortIntersectCount.html)`
    It creates columns to indicate number of occurrences of intersection with a cohort

`[addCohortIntersectDate()](addCohortIntersectDate.html)`
    Date of cohorts that are present in a certain window

`[addCohortIntersectDays()](addCohortIntersectDays.html)`
    It creates columns to indicate the number of days between the current table and a target cohort

`[addCohortIntersectFlag()](addCohortIntersectFlag.html)`
    It creates columns to indicate the presence of cohorts

### Add a value from a concept intersection

Add a variable indicating the intersection between a table in the OMOP Common Data Model and a concept.

`[addConceptIntersectCount()](addConceptIntersectCount.html)`
    It creates column to indicate the count overlap information between a table and a concept

`[addConceptIntersectDate()](addConceptIntersectDate.html)`
    It creates column to indicate the date overlap information between a table and a concept

`[addConceptIntersectDays()](addConceptIntersectDays.html)`
    It creates column to indicate the days of difference from an index date to a concept

`[addConceptIntersectField()](addConceptIntersectField.html)`
    It adds a custom column (field) from the intersection with a certain table subsetted by concept id. In general it is used to add the first value of a certain measurement.

`[addConceptIntersectFlag()](addConceptIntersectFlag.html)`
    It creates column to indicate the flag overlap information between a table and a concept

### Add a value from an omop standard table intersection

Add a variable indicating the intersection between a table in the OMOP Common Data Model and a standard omop table.

`[addTableIntersectCount()](addTableIntersectCount.html)`
    Compute number of intersect with an omop table.

`[addTableIntersectDate()](addTableIntersectDate.html)`
    Compute date of intersect with an omop table.

`[addTableIntersectDays()](addTableIntersectDays.html)`
    Compute time to intersect with an omop table.

`[addTableIntersectField()](addTableIntersectField.html)`
    Intersecting the cohort with columns of an OMOP table of user's choice. It will add an extra column to the cohort, indicating the intersected entries with the target columns in a window of the user's choice.

`[addTableIntersectFlag()](addTableIntersectFlag.html)`
    Compute a flag intersect with an omop table.

### Query functions

These functions add the same information than their analogous add* function but, the result is not computed into a table.

`[addAgeQuery()](addAgeQuery.html)`
    Query to add the age of the individuals at a certain date

`[addDateOfBirthQuery()](addDateOfBirthQuery.html)`
    Query to add a column with the individual birth date

`[addDemographicsQuery()](addDemographicsQuery.html)`
    Query to add demographic characteristics at a certain date

`[addFutureObservationQuery()](addFutureObservationQuery.html)`
    Query to add the number of days till the end of the observation period at a certain date

`[addInObservationQuery()](addInObservationQuery.html)`
    Query to add a new column to indicate if a certain record is within the observation period

`[addObservationPeriodIdQuery()](addObservationPeriodIdQuery.html)`
    Add the ordinal number of the observation period associated that a given date is in. Result is not computed, only query is added.

`[addPriorObservationQuery()](addPriorObservationQuery.html)`
    Query to add the number of days of prior observation in the current observation period at a certain date

`[addSexQuery()](addSexQuery.html)`
    Query to add the sex of the individuals

### Summarise patient characteristics

Function that allow the user to summarise patient characteristics (characteristics must be added priot the use of the function)

`[summariseResult()](summariseResult.html)`
    Summarise variables using a set of estimate functions. The output will be a formatted summarised_result object.

### Suppress counts of a summarised_result object

Function that allow the user to suppress counts and estimates for a certain minCellCount

`[reexports](reexports.html)` `[suppress](reexports.html)` `[settings](reexports.html)`
    Objects exported from other packages

### Create a mock database with OMOP CDM format data

Function that allow the user to create new OMOP CDM mock data

`[mockDisconnect()](mockDisconnect.html)`
    Function to disconnect from the mock

`[mockPatientProfiles()](mockPatientProfiles.html)`
    It creates a mock database for testing PatientProfiles package

### Other functions

Helper functions

`[benchmarkPatientProfiles()](benchmarkPatientProfiles.html)`
    Benchmark intersections and demographics functions for a certain source (cdm).

`[addCohortName()](addCohortName.html)`
    Add cohort name for each cohort_definition_id

`[addConceptName()](addConceptName.html)`
    Add concept name for each concept_id

`[addCdmName()](addCdmName.html)`
    Add cdm name

`[addCategories()](addCategories.html)`
    Categorize a numeric variable

`[addObservationPeriodId()](addObservationPeriodId.html)`
    Add the ordinal number of the observation period associated that a given date is in.

`[filterCohortId()](filterCohortId.html)`
    Filter a cohort according to cohort_definition_id column, the result is not computed into a table. only a query is added. Used usually as internal functions of other packages.

`[filterInObservation()](filterInObservation.html)`
    Filter the rows of a `cdm_table` to the ones in observation that `indexDate` is in observation.

`[variableTypes()](variableTypes.html)`
    Classify the variables between 5 types: "numeric", "categorical", "binary", "date", or NA.

`[availableEstimates()](availableEstimates.html)`
    Show the available estimates that can be used for the different variable_type supported.

`[startDateColumn()](startDateColumn.html)`
    Get the name of the start date column for a certain table in the cdm

`[endDateColumn()](endDateColumn.html)`
    Get the name of the end date column for a certain table in the cdm

`[sourceConceptIdColumn()](sourceConceptIdColumn.html)`
    Get the name of the source concept_id column for a certain table in the cdm

`[standardConceptIdColumn()](standardConceptIdColumn.html)`
    Get the name of the standard concept_id column for a certain table in the cdm

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/articles/demographics.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Adding patient demographics

Source: [`vignettes/demographics.rmd`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/vignettes/demographics.rmd)

`demographics.rmd`

## Introduction

The OMOP CDM is a person-centric model. The person table contains records that uniquely identify each individual along with some of their demographic information. Below we create a mock CDM reference which, as is standard, has a person table which contains fields which indicate an individual’s date of birth, gender, race, and ethnicity. Each of these, except for date of birth, are represented by a concept ID (and as the person table contains one record per person these fields are treated as time-invariant).
    
    
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm <- [mockPatientProfiles](../reference/mockPatientProfiles.html)(numberIndividuals = 10000)
    
    cdm$person |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15…
    ## $ gender_concept_id    <int> 8532, 8532, 8507, 8532, 8532, 8507, 8532, 8532, 8…
    ## $ year_of_birth        <int> 1940, 1952, 1958, 1906, 1950, 1917, 1967, 1972, 1…
    ## $ race_concept_id      <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ ethnicity_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

As well as the person table, every CDM reference will include an observation period table. This table contains spans of times during which an individual is considered to being under observation. Individuals can have multiple observation periods, but they cannot overlap.
    
    
    cdm$observation_period |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    ## $ observation_period_start_date <date> 1940-01-01, 1952-01-01, 1958-01-01, 190…
    ## $ observation_period_end_date   <date> 1969-04-09, 1977-04-26, 2000-12-04, 193…
    ## $ period_type_concept_id        <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ observation_period_id         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…

When performing analyses we will often be interested in working with the person and observation period tables to identify individuals’ characteristics on some date of interest. PatientProfiles provides a number of functions that can help us do this.

## Adding characteristics to OMOP CDM tables

Let’s say we’re working with the condition occurrence table.
    
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 6
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                 <int> 2284, 3335, 9438, 6762, 9433, 9393, 6360, 36…
    ## $ condition_start_date      <date> 1918-10-05, 1934-12-06, 1945-12-27, 1944-09…
    ## $ condition_end_date        <date> 1925-01-30, 1954-09-30, 1947-08-23, 1947-08…
    ## $ condition_occurrence_id   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1…
    ## $ condition_concept_id      <int> 1, 2, 2, 7, 6, 9, 8, 3, 10, 5, 3, 2, 5, 5, 3…
    ## $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…

This table contains diagnoses of individuals and we might, for example, want to identify their age on their date of diagnosis. This involves linking back to the person table which contains their date of birth (split across three different columns). PatientProfiles provides a simple function for this. `[addAge()](../reference/addAge.html)` will add a new column to the table containing each patient’s age relative to the specified index date.
    
    
    cdm$condition_occurrence <- cdm$condition_occurrence |>
      [addAge](../reference/addAge.html)(indexDate = "condition_start_date")
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 7
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                 <int> 74, 266, 318, 410, 427, 434, 450, 457, 468, …
    ## $ condition_start_date      <date> 1969-08-01, 1936-01-11, 1952-08-18, 1957-01…
    ## $ condition_end_date        <date> 1978-06-27, 1959-01-10, 1967-10-03, 1957-09…
    ## $ condition_occurrence_id   <int> 21, 81, 88, 105, 109, 117, 32, 41, 36, 82, 7…
    ## $ condition_concept_id      <int> 2, 1, 1, 8, 10, 3, 3, 9, 1, 1, 5, 2, 6, 3, 7…
    ## $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ age                       <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…

As well as calculating age, we can also create age groups at the same time. Here we create three age groups: those aged 0 to 17, those 18 to 65, and those 66 or older.
    
    
    cdm$condition_occurrence <- cdm$condition_occurrence |>
      [addAge](../reference/addAge.html)(
        indexDate = "condition_start_date",
        ageGroup = [list](https://rdrr.io/r/base/list.html)(
          "0 to 17" = [c](https://rdrr.io/r/base/c.html)(0, 17),
          "18 to 65" = [c](https://rdrr.io/r/base/c.html)(18, 65),
          ">= 66" = [c](https://rdrr.io/r/base/c.html)(66, Inf)
        )
      )
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 8
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                 <int> 74, 266, 318, 410, 427, 434, 450, 457, 468, …
    ## $ condition_start_date      <date> 1969-08-01, 1936-01-11, 1952-08-18, 1957-01…
    ## $ condition_end_date        <date> 1978-06-27, 1959-01-10, 1967-10-03, 1957-09…
    ## $ condition_occurrence_id   <int> 21, 81, 88, 105, 109, 117, 32, 41, 36, 82, 7…
    ## $ condition_concept_id      <int> 2, 1, 1, 8, 10, 3, 3, 9, 1, 1, 5, 2, 6, 3, 7…
    ## $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ age                       <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ age_group                 <chr> "0 to 17", "0 to 17", "18 to 65", "18 to 65"…

By default, when adding age the new column will have been called “age” and will have been calculated using all available information on date of birth contained in the person. We can though also alter these defaults. Here, for example, we impose that month of birth is January and day of birth is the 1st for all individuals.
    
    
    cdm$condition_occurrence <- cdm$condition_occurrence |>
      [addAge](../reference/addAge.html)(
        indexDate = "condition_start_date",
        ageName = "age_from_year_of_birth",
        ageMissingMonth = 1,
        ageMissingDay = 1,
        ageImposeMonth = TRUE,
        ageImposeDay = TRUE
      )
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 9
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                 <int> 74, 266, 318, 410, 427, 434, 450, 457, 468, …
    ## $ condition_start_date      <date> 1969-08-01, 1936-01-11, 1952-08-18, 1957-01…
    ## $ condition_end_date        <date> 1978-06-27, 1959-01-10, 1967-10-03, 1957-09…
    ## $ condition_occurrence_id   <int> 21, 81, 88, 105, 109, 117, 32, 41, 36, 82, 7…
    ## $ condition_concept_id      <int> 2, 1, 1, 8, 10, 3, 3, 9, 1, 1, 5, 2, 6, 3, 7…
    ## $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ age                       <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ age_group                 <chr> "0 to 17", "0 to 17", "18 to 65", "18 to 65"…
    ## $ age_from_year_of_birth    <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…

As well as age at diagnosis, we might also want identify patients’ sex. PatientProfiles provides the `[addSex()](../reference/addSex.html)` function that will add this for us. Because this is treated as time-invariant, we will not have to specify any index variable.
    
    
    cdm$condition_occurrence <- cdm$condition_occurrence |>
      [addSex](../reference/addSex.html)()
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 10
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                 <int> 74, 266, 318, 410, 427, 434, 450, 457, 468, …
    ## $ condition_start_date      <date> 1969-08-01, 1936-01-11, 1952-08-18, 1957-01…
    ## $ condition_end_date        <date> 1978-06-27, 1959-01-10, 1967-10-03, 1957-09…
    ## $ condition_occurrence_id   <int> 21, 81, 88, 105, 109, 117, 32, 41, 36, 82, 7…
    ## $ condition_concept_id      <int> 2, 1, 1, 8, 10, 3, 3, 9, 1, 1, 5, 2, 6, 3, 7…
    ## $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ age                       <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ age_group                 <chr> "0 to 17", "0 to 17", "18 to 65", "18 to 65"…
    ## $ age_from_year_of_birth    <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ sex                       <chr> "Female", "Male", "Female", "Female", "Male"…

Similarly, we could also identify whether an individual was in observation at the time of their diagnosis (i.e. had an observation period that overlaps with their diagnosis date), as well as identifying how much prior observation time they had on this date and how much they have following it.
    
    
    cdm$condition_occurrence <- cdm$condition_occurrence |>
      [addInObservation](../reference/addInObservation.html)(indexDate = "condition_start_date") |>
      [addPriorObservation](../reference/addPriorObservation.html)(indexDate = "condition_start_date") |>
      [addFutureObservation](../reference/addFutureObservation.html)(indexDate = "condition_start_date")
    
    cdm$condition_occurrence |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 13
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                 <int> 74, 266, 318, 410, 427, 434, 450, 457, 468, …
    ## $ condition_start_date      <date> 1969-08-01, 1936-01-11, 1952-08-18, 1957-01…
    ## $ condition_end_date        <date> 1978-06-27, 1959-01-10, 1967-10-03, 1957-09…
    ## $ condition_occurrence_id   <int> 21, 81, 88, 105, 109, 117, 32, 41, 36, 82, 7…
    ## $ condition_concept_id      <int> 2, 1, 1, 8, 10, 3, 3, 9, 1, 1, 5, 2, 6, 3, 7…
    ## $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ age                       <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ age_group                 <chr> "0 to 17", "0 to 17", "18 to 65", "18 to 65"…
    ## $ age_from_year_of_birth    <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ sex                       <chr> "Female", "Male", "Female", "Female", "Male"…
    ## $ in_observation            <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    ## $ prior_observation         <int> 578, 3297, 7900, 8409, 10879, 9565, 2697, 57…
    ## $ future_observation        <int> 14672, 10185, 12460, 1601, 2901, 4798, 9016,…

For these functions which work with information from the observation table, it is important to note that the results will be based on the observation period during which the index date falls within. Moreover, if a patient is not under observation at the specified date, `[addPriorObservation()](../reference/addPriorObservation.html)` and `[addFutureObservation()](../reference/addFutureObservation.html)` functions will return NA.

When checking whether someone is in observation the default is that we are checking whether someone was in observation on the index date. We could though expand this and consider a window of time around this date. For example here we add a variable indicating whether someone was in observation from 180 days before the index date to 30 days following it.
    
    
    cdm$condition_occurrence |>
      [addInObservation](../reference/addInObservation.html)(
        indexDate = "condition_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(-180, 30)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 13
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                 <int> 74, 266, 318, 410, 427, 434, 450, 457, 468, …
    ## $ condition_start_date      <date> 1969-08-01, 1936-01-11, 1952-08-18, 1957-01…
    ## $ condition_end_date        <date> 1978-06-27, 1959-01-10, 1967-10-03, 1957-09…
    ## $ condition_occurrence_id   <int> 21, 81, 88, 105, 109, 117, 32, 41, 36, 82, 7…
    ## $ condition_concept_id      <int> 2, 1, 1, 8, 10, 3, 3, 9, 1, 1, 5, 2, 6, 3, 7…
    ## $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ age                       <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ age_group                 <chr> "0 to 17", "0 to 17", "18 to 65", "18 to 65"…
    ## $ age_from_year_of_birth    <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ sex                       <chr> "Female", "Male", "Female", "Female", "Male"…
    ## $ prior_observation         <int> 578, 3297, 7900, 8409, 10879, 9565, 2697, 57…
    ## $ future_observation        <int> 14672, 10185, 12460, 1601, 2901, 4798, 9016,…
    ## $ in_observation            <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…

We can also specify a window and require that an individual is present for only some days within it. Here we add a variable indicating whether the individual was in observation at least a year in the future,
    
    
    cdm$condition_occurrence |>
      [addInObservation](../reference/addInObservation.html)(
        indexDate = "condition_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(365, Inf),
        completeInterval = FALSE
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 13
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ person_id                 <int> 74, 266, 318, 410, 427, 434, 450, 457, 468, …
    ## $ condition_start_date      <date> 1969-08-01, 1936-01-11, 1952-08-18, 1957-01…
    ## $ condition_end_date        <date> 1978-06-27, 1959-01-10, 1967-10-03, 1957-09…
    ## $ condition_occurrence_id   <int> 21, 81, 88, 105, 109, 117, 32, 41, 36, 82, 7…
    ## $ condition_concept_id      <int> 2, 1, 1, 8, 10, 3, 3, 9, 1, 1, 5, 2, 6, 3, 7…
    ## $ condition_type_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ age                       <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ age_group                 <chr> "0 to 17", "0 to 17", "18 to 65", "18 to 65"…
    ## $ age_from_year_of_birth    <int> 1, 9, 21, 23, 29, 26, 7, 15, 8, 6, 14, 26, 2…
    ## $ sex                       <chr> "Female", "Male", "Female", "Female", "Male"…
    ## $ prior_observation         <int> 578, 3297, 7900, 8409, 10879, 9565, 2697, 57…
    ## $ future_observation        <int> 14672, 10185, 12460, 1601, 2901, 4798, 9016,…
    ## $ in_observation            <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…

## Adding characteristics to a cohort tables

The above functions can be used on both standard OMOP CDM tables and cohort tables. Note as the default index date in the functions is “cohort_start_date” we can now omit this.
    
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 4
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1, 1, 1, 1, 2, 1, 3, 2, 2, 2, 1, 3, 3, 1, 3, 2, 3…
    ## $ subject_id           <int> 5853, 1622, 8574, 6414, 7299, 4793, 6541, 1029, 5…
    ## $ cohort_start_date    <date> 1964-06-05, 1927-03-08, 1955-08-04, 1963-06-12, …
    ## $ cohort_end_date      <date> 1964-12-11, 1934-04-21, 1958-05-01, 1983-11-26, …
    
    
    cdm$cohort1 <- cdm$cohort1 |>
      [addAge](../reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)(
        "0 to 17" = [c](https://rdrr.io/r/base/c.html)(0, 17),
        "18 to 65" = [c](https://rdrr.io/r/base/c.html)(18, 65),
        ">= 66" = [c](https://rdrr.io/r/base/c.html)(66, Inf)
      )) |>
      [addSex](../reference/addSex.html)() |>
      [addInObservation](../reference/addInObservation.html)() |>
      [addPriorObservation](../reference/addPriorObservation.html)() |>
      [addFutureObservation](../reference/addFutureObservation.html)()
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 10
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 3, 2, 1, 1, 3, 2, 1, 3, 3, 2, 2, 1, 2, 3, 3, 3, 2…
    ## $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15…
    ## $ cohort_start_date    <date> 1957-08-12, 1957-03-05, 1985-01-22, 1909-02-23, …
    ## $ cohort_end_date      <date> 1966-11-16, 1960-04-16, 1999-11-20, 1934-12-29, …
    ## $ age                  <int> 17, 5, 27, 3, 0, 6, 22, 33, 10, 2, 11, 4, 21, 10,…
    ## $ age_group            <chr> "0 to 17", "0 to 17", "18 to 65", "0 to 17", "0 t…
    ## $ sex                  <chr> "Female", "Female", "Male", "Female", "Female", "…
    ## $ in_observation       <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    ## $ prior_observation    <int> 6433, 1890, 9883, 1149, 293, 2331, 8400, 12221, 3…
    ## $ future_observation   <int> 4258, 7357, 5795, 10317, 2482, 9935, 672, 4918, 6…

## Getting multiple characteristics at once

The above functions, which are chained together, each fetch the related information one by one. In the cases where we are interested in adding multiple characteristics, we can add these all at the same time using the more general `[addDemographics()](../reference/addDemographics.html)` functions. This will be more efficient that adding characteristics as it requires fewer joins between our table of interest and the person and observation period tables.
    
    
    cdm$cohort2 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 4
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 3, 3, 1, 3, 1, 1, 2, 3, 3, 1, 2, 1, 2, 2, 1, 1, 3…
    ## $ subject_id           <int> 6688, 3035, 5292, 1351, 8144, 699, 8733, 1007, 68…
    ## $ cohort_start_date    <date> 1999-06-28, 1977-03-24, 1931-10-19, 1993-07-08, …
    ## $ cohort_end_date      <date> 2019-08-31, 1988-06-17, 1937-06-27, 2003-11-19, …
    
    
    tictoc::[tic](https://rdrr.io/pkg/tictoc/man/tic.html)()
    cdm$cohort2 |>
      [addAge](../reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)(
        "0 to 17" = [c](https://rdrr.io/r/base/c.html)(0, 17),
        "18 to 65" = [c](https://rdrr.io/r/base/c.html)(18, 65),
        ">= 66" = [c](https://rdrr.io/r/base/c.html)(66, Inf)
      )) |>
      [addSex](../reference/addSex.html)() |>
      [addInObservation](../reference/addInObservation.html)() |>
      [addPriorObservation](../reference/addPriorObservation.html)() |>
      [addFutureObservation](../reference/addFutureObservation.html)()
    
    
    ## # Source:   table<og_024_1752078036> [?? x 10]
    ## # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ##    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    ##                   <int>      <int> <date>            <date>          <int>
    ##  1                    2          1 1940-11-29        1959-10-09          0
    ##  2                    3          2 1963-05-30        1977-03-31         11
    ##  3                    2          3 1993-09-04        1995-07-27         35
    ##  4                    3          4 1923-10-12        1926-04-27         17
    ##  5                    3          5 1954-06-30        1955-12-24          4
    ##  6                    2          6 1923-07-07        1940-06-01          6
    ##  7                    3          7 1989-02-22        1991-02-24         22
    ##  8                    2          8 1992-10-16        2017-04-23         20
    ##  9                    3          9 1985-09-19        1997-05-06         12
    ## 10                    3         10 1935-05-26        1936-02-06         12
    ## # ℹ more rows
    ## # ℹ 5 more variables: age_group <chr>, sex <chr>, in_observation <int>,
    ## #   prior_observation <int>, future_observation <int>
    
    
    tictoc::[toc](https://rdrr.io/pkg/tictoc/man/tic.html)()
    
    
    ## 1.127 sec elapsed
    
    
    tictoc::[tic](https://rdrr.io/pkg/tictoc/man/tic.html)()
    cdm$cohort2 |>
      [addDemographics](../reference/addDemographics.html)(
        age = TRUE,
        ageName = "age",
        ageGroup = [list](https://rdrr.io/r/base/list.html)(
          "0 to 17" = [c](https://rdrr.io/r/base/c.html)(0, 17),
          "18 to 65" = [c](https://rdrr.io/r/base/c.html)(18, 65),
          ">= 66" = [c](https://rdrr.io/r/base/c.html)(66, Inf)
        ),
        sex = TRUE,
        sexName = "sex",
        priorObservation = TRUE,
        priorObservationName = "prior_observation",
        futureObservation = FALSE,
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 8
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 2, 3, 2, 3, 3, 2, 3, 2, 3, 3, 2, 1, 2, 3, 2, 3, 2…
    ## $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15…
    ## $ cohort_start_date    <date> 1940-11-29, 1963-05-30, 1993-09-04, 1923-10-12, …
    ## $ cohort_end_date      <date> 1959-10-09, 1977-03-31, 1995-07-27, 1926-04-27, …
    ## $ age                  <int> 0, 11, 35, 17, 4, 6, 22, 20, 12, 12, 14, 25, 2, 2…
    ## $ age_group            <chr> "0 to 17", "0 to 17", "18 to 65", "0 to 17", "0 t…
    ## $ sex                  <chr> "Female", "Female", "Male", "Female", "Female", "…
    ## $ prior_observation    <int> 333, 4167, 13030, 6493, 1641, 2378, 8088, 7594, 4…
    
    
    tictoc::[toc](https://rdrr.io/pkg/tictoc/man/tic.html)()
    
    
    ## 0.429 sec elapsed

In our small mock dataset we see a small improvement in performance, but this difference will become much more noticeable when working with real data that will typically be far larger.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/articles/cohort-intersect.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Adding cohort intersections

Source: [`vignettes/cohort-intersect.Rmd`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/vignettes/cohort-intersect.Rmd)

`cohort-intersect.Rmd`

## Introduction

Cohorts are often a key component in studies that use the OMOP CDM. They may be created to represent various clinical events of interest and we often use cohorts in combination, whether it is to identify outcomes among people with an exposure of interest, report baseline comorbidites among a certain study population, or for many other possible reasons.

Cohorts have a particular format in the OMOP CDM, which we can see for two cohort tables created by the `[mockPatientProfiles()](../reference/mockPatientProfiles.html)` function provided by PatientProfiles, which mimics a database in the OMOP CDM format. We can see the first cohort table contains 2 cohorts while the second contains 3 cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    cdm <- [mockPatientProfiles](../reference/mockPatientProfiles.html)(numberIndividuals = 1000)
    
    cdm$cohort1 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 4
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 2, 1, 1, 2, 2, 3, 2, 3, 1, 2, 2, 2, 2, 1, 1, 1, 3…
    ## $ subject_id           <int> 503, 261, 750, 1, 445, 523, 899, 929, 925, 200, 6…
    ## $ cohort_start_date    <date> 2004-08-05, 1976-07-21, 1978-01-02, 1916-08-27, …
    ## $ cohort_end_date      <date> 2005-12-14, 1979-07-22, 1980-06-14, 1946-04-06, …
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)
    
    
    ## # A tibble: 3 × 2
    ##   cohort_definition_id cohort_name
    ##                  <int> <chr>      
    ## 1                    1 cohort_1   
    ## 2                    2 cohort_2   
    ## 3                    3 cohort_3
    
    
    cdm$cohort2 |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 4
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 3, 1, 1, 3, 1, 2, 1, 1, 2, 2, 3, 2, 2, 3, 1, 3, 1…
    ## $ subject_id           <int> 576, 112, 58, 256, 335, 291, 294, 615, 782, 721, …
    ## $ cohort_start_date    <date> 1956-05-21, 1978-06-11, 1921-03-26, 1955-04-22, …
    ## $ cohort_end_date      <date> 1973-09-24, 2001-11-10, 1923-07-03, 1955-07-27, …
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2)
    
    
    ## # A tibble: 3 × 2
    ##   cohort_definition_id cohort_name
    ##                  <int> <chr>      
    ## 1                    1 cohort_1   
    ## 2                    2 cohort_2   
    ## 3                    3 cohort_3

## Identifying cohort intersections

PatientProfiles provides four functions for identifying cohort intersections (the presence of an individual in two cohorts). The first `[addCohortIntersectFlag()](../reference/addCohortIntersectFlag.html)` adds a flag of whether someone appeared in the other cohort during a time window. The second, `[addCohortIntersectCount()](../reference/addCohortIntersectCount.html)`, counts the number of times someone appeared in the other cohort in the window. A third, `[addCohortIntersectDate()](../reference/addCohortIntersectDate.html)`, adds the date when the intersection occurred. And the fourth, `[addCohortIntersectDays()](../reference/addCohortIntersectDays.html)`, adds the number of days to the intersection.

We can see each of these below. Note that they add variables to our cohort table of interest, and identify intersections over a given window. As we can see, if our target cohort table contains multiple cohorts then by default these functions will add one new variable per cohort.

Let’s start by adding flag and count variables using a window of 180 days before to 180 days after the cohort start date in our table of interest. By default the cohort start date of our cohort of interest will be used as the index date, with the cohort start to cohort end date of the target cohort then used to check for an intersection.
    
    
    cdm$cohort1 |>
      [addCohortIntersectFlag](../reference/addCohortIntersectFlag.html)(
        indexDate = "cohort_start_date",
        targetCohortTable = "cohort2",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-180, 180))
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 7
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 3, 2, 3, 1, 1, 1, 1, 3, 1, 2, 3, 2, 3, 2, 1, 2, 3…
    ## $ subject_id           <int> 523, 899, 778, 85, 222, 140, 70, 591, 54, 137, 77…
    ## $ cohort_start_date    <date> 1962-10-26, 1950-03-28, 1925-07-30, 1939-09-06, …
    ## $ cohort_end_date      <date> 1974-01-15, 1976-07-06, 1936-05-29, 1942-05-25, …
    ## $ cohort_1_m180_to_180 <dbl> 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0…
    ## $ cohort_2_m180_to_180 <dbl> 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1…
    ## $ cohort_3_m180_to_180 <dbl> 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0…
    
    
    cdm$cohort1 |>
      [addCohortIntersectCount](../reference/addCohortIntersectCount.html)(
        indexDate = "cohort_start_date",
        targetCohortTable = "cohort2",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-180, 180))
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 7
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 3, 2, 3, 1, 1, 1, 1, 3, 1, 2, 3, 2, 3, 2, 1, 2, 3…
    ## $ subject_id           <int> 523, 899, 778, 85, 222, 140, 70, 591, 54, 137, 77…
    ## $ cohort_start_date    <date> 1962-10-26, 1950-03-28, 1925-07-30, 1939-09-06, …
    ## $ cohort_end_date      <date> 1974-01-15, 1976-07-06, 1936-05-29, 1942-05-25, …
    ## $ cohort_3_m180_to_180 <dbl> 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0…
    ## $ cohort_2_m180_to_180 <dbl> 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1…
    ## $ cohort_1_m180_to_180 <dbl> 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0…

Next we can add the date of the intersection and the days to the intersection. When identifying these variables we use only one date in our target table, which by default will be the cohort start date. In addition by default the first intersection that occurs within our window will be used.
    
    
    cdm$cohort1 |>
      [addCohortIntersectDate](../reference/addCohortIntersectDate.html)(
        indexDate = "cohort_start_date",
        targetCohortTable = "cohort2",
        targetDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-180, 180)),
        order = "first"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 7
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 2, 1, 1, 2, 2, 3, 2, 3, 1, 2, 2, 2, 2, 1, 1, 1, 3…
    ## $ subject_id           <int> 503, 261, 750, 1, 445, 523, 899, 929, 925, 200, 6…
    ## $ cohort_start_date    <date> 2004-08-05, 1976-07-21, 1978-01-02, 1916-08-27, …
    ## $ cohort_end_date      <date> 2005-12-14, 1979-07-22, 1980-06-14, 1946-04-06, …
    ## $ cohort_3_m180_to_180 <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ cohort_2_m180_to_180 <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ cohort_1_m180_to_180 <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    
    
    cdm$cohort1 |>
      [addCohortIntersectDays](../reference/addCohortIntersectDays.html)(
        indexDate = "cohort_start_date",
        targetCohortTable = "cohort2",
        targetDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-180, 180)),
        order = "first"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 7
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 2, 1, 1, 2, 2, 3, 2, 3, 1, 2, 2, 2, 2, 1, 1, 1, 3…
    ## $ subject_id           <int> 503, 261, 750, 1, 445, 523, 899, 929, 925, 200, 6…
    ## $ cohort_start_date    <date> 2004-08-05, 1976-07-21, 1978-01-02, 1916-08-27, …
    ## $ cohort_end_date      <date> 2005-12-14, 1979-07-22, 1980-06-14, 1946-04-06, …
    ## $ cohort_3_m180_to_180 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ cohort_2_m180_to_180 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ cohort_1_m180_to_180 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…

## Options for identifying cohort intersection

To consider the impact of the different options we can choose when identifying cohort intersections let´s consider a toy example with a single patient with common cold (diagnosed on the 1st February 2020 and ending on the 15th February 2020). This person had two records for aspirin, one ending shortly before their start date for common cold and the other starting during their record for common cold.
    
    
    common_cold <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-02-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-02-15")
    )
    
    aspirin <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1),
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 1),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-01-01", "2020-02-10")),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-01-28", "2020-03-15"))
    )

We can visualise what this person’s timeline looks like.
    
    
    [bind_rows](https://dplyr.tidyverse.org/reference/bind_rows.html)(
      common_cold |> [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort = "common cold"),
      aspirin |> [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort = "aspirin")
    ) |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(record = [as.character](https://rdrr.io/r/base/character.html)([row_number](https://dplyr.tidyverse.org/reference/row_number.html)())) |>
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_segment](https://ggplot2.tidyverse.org/reference/geom_segment.html)(
        [aes](https://ggplot2.tidyverse.org/reference/aes.html)(
          x = cohort_start_date,
          y = cohort,
          xend = cohort_end_date,
          yend = cohort, col = cohort, fill = cohort
        ),
        size = 4.5, alpha = .5
      ) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = cohort_start_date, y = cohort, color = cohort), size = 4) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = cohort_end_date, y = cohort, color = cohort), size = 4) +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("") +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("") +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(legend.position = "none")

![](cohort-intersect_files/figure-html/unnamed-chunk-5-1.png)

Whether we consider there to be a cohort intersection between the common cold and aspirin cohorts will depend on what options we choose. To see this let’s first create a cdm reference containing our example.
    
    
    cdm <- [mockPatientProfiles](../reference/mockPatientProfiles.html)(
      cohort1 = common_cold,
      cohort2 = aspirin,
      numberIndividuals = 2
    )

If we consider the intersection relative to the cohort start date for common cold with a window of 0 to 0 (ie only the index date) then no intersection will be identified as the individual did not have an ongoing record for aspirin on that date.
    
    
    cdm$cohort1 |>
      [addCohortIntersectFlag](../reference/addCohortIntersectFlag.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1
    ## $ subject_id           <int> 1
    ## $ cohort_start_date    <date> 2020-02-01
    ## $ cohort_end_date      <date> 2020-02-15
    ## $ cohort_1_0_to_0      <dbl> 0

We could, however, change the index date to cohort end date in which case an intersection would be found.
    
    
    cdm$cohort1 |>
      [addCohortIntersectFlag](../reference/addCohortIntersectFlag.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_end_date",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0))
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1
    ## $ subject_id           <int> 1
    ## $ cohort_start_date    <date> 2020-02-01
    ## $ cohort_end_date      <date> 2020-02-15
    ## $ cohort_1_0_to_0      <dbl> 1

Or we could also extend the window to include more time before or after which in both cases would lead to cohort intersections being found.
    
    
    cdm$cohort1 |>
      [addCohortIntersectFlag](../reference/addCohortIntersectFlag.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, 90)),
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1
    ## $ subject_id           <int> 1
    ## $ cohort_start_date    <date> 2020-02-01
    ## $ cohort_end_date      <date> 2020-02-15
    ## $ cohort_1_m90_to_90   <dbl> 1

With a window of 90 days before to 90 days after cohort start, the person would have a count of two cohort intersections.
    
    
    cdm$cohort1 |>
      [addCohortIntersectCount](../reference/addCohortIntersectCount.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, 90)),
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1
    ## $ subject_id           <int> 1
    ## $ cohort_start_date    <date> 2020-02-01
    ## $ cohort_end_date      <date> 2020-02-15
    ## $ cohort_1_m90_to_90   <dbl> 2

With this same window, if we add the first cohort intersect date we will get the start date of the first record of aspirin.
    
    
    cdm$cohort1 |>
      [addCohortIntersectDate](../reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, 90)),
        order = "first"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1
    ## $ subject_id           <int> 1
    ## $ cohort_start_date    <date> 2020-02-01
    ## $ cohort_end_date      <date> 2020-02-15
    ## $ cohort_1_m90_to_90   <date> 2020-01-01

But if we instead set order to last, we get the start date of the second record of aspirin.
    
    
    cdm$cohort1 |>
      [addCohortIntersectDate](../reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, 90)),
        order = "last"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1
    ## $ subject_id           <int> 1
    ## $ cohort_start_date    <date> 2020-02-01
    ## $ cohort_end_date      <date> 2020-02-15
    ## $ cohort_1_m90_to_90   <date> 2020-02-10

## Naming conventions for new variables

One last option relates to the naming convention used to for the new variables.
    
    
    cdm$cohort1 |>
      [addCohortIntersectDate](../reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, 90)),
        order = "last",
        nameStyle = "{cohort_name}_{window_name}"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1
    ## $ subject_id           <int> 1
    ## $ cohort_start_date    <date> 2020-02-01
    ## $ cohort_end_date      <date> 2020-02-15
    ## $ cohort_1_m90_to_90   <date> 2020-02-10

We can instead choose a specific name (but this will only work if only one new variable will be added, otherwise we will get an error to avoid duplicate names).
    
    
    cdm$cohort1 |>
      [addCohortIntersectDate](../reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, 90)),
        order = "last",
        nameStyle = "my_new_variable"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 5
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id <int> 1
    ## $ subject_id           <int> 1
    ## $ cohort_start_date    <date> 2020-02-01
    ## $ cohort_end_date      <date> 2020-02-15
    ## $ my_new_variable      <date> 2020-02-10

In the other direction we could also include the estimate type in the name. This will be useful, for example, if we’re adding multiple different types of intersection values.
    
    
    cdm$cohort1 |>
      [addCohortIntersectDate](../reference/addCohortIntersectDate.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, 90)),
        order = "last",
        nameStyle = "{cohort_name}_{window_name}_{value}"
      ) |>
      [addCohortIntersectDays](../reference/addCohortIntersectDays.html)(
        targetCohortTable = "cohort2",
        indexDate = "cohort_start_date",
        targetDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, 90)),
        order = "last",
        nameStyle = "{cohort_name}_{window_name}_{value}"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    
    ## Rows: ??
    ## Columns: 6
    ## Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    ## $ cohort_definition_id    <int> 1
    ## $ subject_id              <int> 1
    ## $ cohort_start_date       <date> 2020-02-01
    ## $ cohort_end_date         <date> 2020-02-15
    ## $ cohort_1_m90_to_90_date <date> 2020-02-10
    ## $ cohort_1_m90_to_90_days <dbl> 9

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/articles/concept-intersect.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Adding concept intersections

Source: [`vignettes/concept-intersect.Rmd`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/vignettes/concept-intersect.Rmd)

`concept-intersect.Rmd`

## Introduction

Concept sets play an important role when working with data in the format of the OMOP CDM. They can be used to create cohorts after which, as we’ve seen in the previous vignette, we can identify intersections between the cohorts. PatientProfiles adds another option for working with concept sets which is use them for adding associated variables directly without first having to create a cohort.

It is important to note, and is explained more below, that results may differ when generating a cohort and then identifying intersections between two cohorts compared to working directly with concept sets. The creation of cohorts will involve the collapsing of overlapping records as well as imposing certain requirements such as only including records that were observed during an individuals observation period. When adding variables based on concept sets we will be working directly with record-level data in the OMOP CDM clinical tables.

## Adding variables from concept sets

For this vignette we’ll use the Eunomia synthetic dataset. First lets create our cohort of interest, individuals with an ankle sprain.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    CDMConnector::[requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main")
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "all",
      overwrite = TRUE
    )
    
    cdm$ankle_sprain
    #> # Source:   table<ankle_sprain> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1        673 1978-09-28        1978-10-12     
    #>  2                    1        673 2012-05-26        2012-06-16     
    #>  3                    1        775 1948-03-28        1948-04-25     
    #>  4                    1        883 1975-09-30        1975-10-14     
    #>  5                    1       1149 2004-12-21        2005-01-04     
    #>  6                    1       1432 1984-05-28        1984-06-25     
    #>  7                    1       1623 1952-08-23        1952-09-20     
    #>  8                    1       1703 1995-09-02        1995-09-30     
    #>  9                    1       1819 1991-06-10        1991-07-08     
    #> 10                    1       1964 2009-04-25        2009-05-23     
    #> # ℹ more rows

Now let’s say we’re interested in summarising use of acetaminophen among our ankle sprain cohort. We can start by identifying the relevant concepts.
    
    
    acetaminophen_cs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen")
    )
    
    acetaminophen_cs
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - 161_acetaminophen (7 codes)

Once we have our codes for acetaminophen we can create variables based on these. As with cohort intersections, PatientProfiles provides four types of functions for concept intersections.

First, we can add a binary flag variable indicating whether an individual had a record of acetaminophen on the day of their ankle sprain or up to 30 days afterwards.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectFlag](../reference/addConceptIntersectFlag.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 30)
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                  <int> 673, 883, 1432, 1703, 3381, 3488, 3604, 36…
    #> $ cohort_start_date           <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…
    #> $ cohort_end_date             <date> 1978-10-12, 1975-10-14, 1984-06-25, 1995-…
    #> $ `161_acetaminophen_0_to_30` <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …

Second, we can count the number of records of acetaminophen in this same window for each individual.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectCount](../reference/addConceptIntersectCount.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 30)
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                  <int> 673, 883, 1432, 1703, 3381, 3488, 3604, 36…
    #> $ cohort_start_date           <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…
    #> $ cohort_end_date             <date> 1978-10-12, 1975-10-14, 1984-06-25, 1995-…
    #> $ `161_acetaminophen_0_to_30` <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …

Third, we could identify the first start date of acetaminophen in this window.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectDate](../reference/addConceptIntersectDate.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 30),
        order = "first"
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                  <int> 673, 883, 1432, 1703, 3381, 3488, 3604, 36…
    #> $ cohort_start_date           <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…
    #> $ cohort_end_date             <date> 1978-10-12, 1975-10-14, 1984-06-25, 1995-…
    #> $ `161_acetaminophen_0_to_30` <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…

Or fourth, we can get the number of days to the start date of acetaminophen in the window.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectDays](../reference/addConceptIntersectDays.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 30),
        order = "first"
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                  <int> 673, 883, 1432, 1703, 3381, 3488, 3604, 36…
    #> $ cohort_start_date           <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…
    #> $ cohort_end_date             <date> 1978-10-12, 1975-10-14, 1984-06-25, 1995-…
    #> $ `161_acetaminophen_0_to_30` <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …

## Adding multiple concept based variables

We can add more than one variable at a time when using these functions. For example, we might want to add variables for multiple time windows.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectFlag](../reference/addConceptIntersectFlag.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)(
          [c](https://rdrr.io/r/base/c.html)(-Inf, -1),
          [c](https://rdrr.io/r/base/c.html)(0, 0),
          [c](https://rdrr.io/r/base/c.html)(1, Inf)
        )
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 7
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id           <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                     <int> 673, 673, 775, 883, 1149, 1432, 1623, 1…
    #> $ cohort_start_date              <date> 1978-09-28, 2012-05-26, 1948-03-28, 19…
    #> $ cohort_end_date                <date> 1978-10-12, 2012-06-16, 1948-04-25, 19…
    #> $ `161_acetaminophen_minf_to_m1` <dbl> 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, …
    #> $ `161_acetaminophen_0_to_0`     <dbl> 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, …
    #> $ `161_acetaminophen_1_to_inf`   <dbl> 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NA,…

Or we might want to get variables for multiple drug ingredients of interest.
    
    
    meds_cs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)(
        "acetaminophen",
        "amoxicillin",
        "aspirin",
        "heparin",
        "morphine",
        "oxycodone",
        "warfarin"
      )
    )
    
    cdm$ankle_sprain |>
      [addConceptIntersectFlag](../reference/addConceptIntersectFlag.html)(
        conceptSet = meds_cs,
        indexDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)(
          [c](https://rdrr.io/r/base/c.html)(-Inf, -1),
          [c](https://rdrr.io/r/base/c.html)(0, 0)
        )
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 18
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id           <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                     <int> 525, 3158, 576, 5063, 759, 1941, 1415, …
    #> $ cohort_start_date              <date> 2000-09-17, 1971-09-18, 1999-06-28, 19…
    #> $ cohort_end_date                <date> 2000-10-08, 1971-10-16, 1999-07-12, 19…
    #> $ `7052_morphine_minf_to_m1`     <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `723_amoxicillin_minf_to_m1`   <dbl> 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, …
    #> $ `7804_oxycodone_minf_to_m1`    <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, …
    #> $ `5224_heparin_minf_to_m1`      <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `723_amoxicillin_0_to_0`       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `1191_aspirin_minf_to_m1`      <dbl> 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, …
    #> $ `161_acetaminophen_minf_to_m1` <dbl> 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, …
    #> $ `11289_warfarin_minf_to_m1`    <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `161_acetaminophen_0_to_0`     <dbl> 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, …
    #> $ `1191_aspirin_0_to_0`          <dbl> 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, …
    #> $ `11289_warfarin_0_to_0`        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `5224_heparin_0_to_0`          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `7052_morphine_0_to_0`         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `7804_oxycodone_0_to_0`        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …

## Cohort-based versus concept-based intersections

In the previous vignette we saw that we can add an intersection variable using a cohort we have created. Meanwhile in this vignette we see that we can instead create an intersection variable using a concept set directly. It is important to note that under some circumstances these two approaches can lead to different results.

When creating a cohort we combine overlapping records, as cohort entries cannot overlap. Thus when adding an intersection count, `[addCohortIntersectCount()](../reference/addCohortIntersectCount.html)` will return a count of cohort entries in the window of interest while `[addConceptIntersectCount()](../reference/addConceptIntersectCount.html)` will return a count of records withing the window. We can see the impact for acetaminophen for our example data below, where we have slightly more records than cohort entries.
    
    
    acetaminophen_cs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen")
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "acetaminophen",
      conceptSet = acetaminophen_cs,
      end = "event_end_date",
      limit = "all"
    )
    
    dplyr::[bind_rows](https://dplyr.tidyverse.org/reference/bind_rows.html)(
      cdm$ankle_sprain |>
        [addCohortIntersectCount](../reference/addCohortIntersectCount.html)(
          targetCohortTable = "acetaminophen",
          window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
        ) |>
        dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(`161_acetaminophen_minf_to_inf`) |>
        dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)() |>
        dplyr::[collect](https://dplyr.tidyverse.org/reference/compute.html)() |>
        dplyr::[arrange](https://dplyr.tidyverse.org/reference/arrange.html)([desc](https://dplyr.tidyverse.org/reference/desc.html)(`161_acetaminophen_minf_to_inf`)) |>
        dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(type = "cohort"),
      cdm$ankle_sprain |>
        [addConceptIntersectCount](../reference/addConceptIntersectCount.html)(
          conceptSet = acetaminophen_cs,
          window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
        ) |>
        dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(`161_acetaminophen_minf_to_inf`) |>
        dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)() |>
        dplyr::[collect](https://dplyr.tidyverse.org/reference/compute.html)() |>
        dplyr::[arrange](https://dplyr.tidyverse.org/reference/arrange.html)([desc](https://dplyr.tidyverse.org/reference/desc.html)(`161_acetaminophen_minf_to_inf`)) |>
        dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(type = "concept_set")
    ) |>
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_col](https://ggplot2.tidyverse.org/reference/geom_bar.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(`161_acetaminophen_minf_to_inf`, n, fill = type),
        position = "dodge"
      ) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(
        legend.title = [element_blank](https://ggplot2.tidyverse.org/reference/element.html)(),
        legend.position = "top"
      )

![](concept-intersect_files/figure-html/unnamed-chunk-10-1.png)

Additional differences between cohort and concept set intersections may also result from cohort table rules. For example, cohort tables will typically omit any records that occur outside an individual´s observation time (as defined in the observation period window). Such records, however, would not be excluded when adding a concept based intersection.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/articles/table-intersect.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Adding table intersections

Source: [`vignettes/table-intersect.Rmd`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/vignettes/table-intersect.Rmd)

`table-intersect.Rmd`

So far we’ve seen that we can add variables indicating intersections based on cohorts or concept sets. One additional option we have is to simply add an intersection based on a table.

Let’s again create a cohort containing people with an ankle sprain.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    CDMConnector::[requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(),
      dbdir = CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()
    )
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main")
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "all",
      overwrite = TRUE
    )
    
    cdm$ankle_sprain
    #> # Source:   table<ankle_sprain> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         99 1959-08-21        1959-09-18     
    #>  2                    1        331 1948-08-28        1948-10-02     
    #>  3                    1        399 1999-03-30        1999-05-04     
    #>  4                    1        404 1962-06-04        1962-07-09     
    #>  5                    1        744 1972-04-12        1972-05-03     
    #>  6                    1        895 1962-11-21        1962-12-05     
    #>  7                    1       1022 2005-12-21        2006-01-11     
    #>  8                    1       1510 1968-05-13        1968-05-27     
    #>  9                    1       1641 1967-04-20        1967-05-11     
    #> 10                    1       1670 2002-10-26        2002-11-16     
    #> # ℹ more rows
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "condition_occurrence",
        window = [c](https://rdrr.io/r/base/c.html)(-30, -1)
      ) |>
      [tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #>       n
    #>   <dbl>
    #> 1  1915

We can use table intersection functions to check whether someone had a record in the drug exposure table in the 30 days before their ankle sprain. If we set targetStartDate to “drug_exposure_start_date” and targetEndDate to “drug_exposure_end_date” we are checking whether an individual had an ongoing drug exposure record in the window.
    
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        targetStartDate = "drug_exposure_start_date",
        targetEndDate = "drug_exposure_end_date",
        window = [c](https://rdrr.io/r/base/c.html)(-30, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id    <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id              <int> 4572, 5200, 2097, 2651, 4026, 4820, 3386, 1107…
    #> $ cohort_start_date       <date> 1977-11-08, 1960-08-20, 1982-11-04, 1951-06-2…
    #> $ cohort_end_date         <date> 1977-12-13, 1960-09-03, 1982-12-02, 1951-07-2…
    #> $ drug_exposure_m30_to_m1 <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…

Meanwhile if we set we set targetStartDate to “drug_exposure_start_date” and targetEndDate to “drug_exposure_start_date” we will instead be checking whether they had a drug exposure record that started during the window.
    
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(-30, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id    <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id              <int> 4572, 5200, 2097, 2651, 4026, 4820, 3386, 1107…
    #> $ cohort_start_date       <date> 1977-11-08, 1960-08-20, 1982-11-04, 1951-06-2…
    #> $ cohort_end_date         <date> 1977-12-13, 1960-09-03, 1982-12-02, 1951-07-2…
    #> $ drug_exposure_m30_to_m1 <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…

As before, instead of a flag, we could also add count, date, or days variables.
    
    
    cdm$ankle_sprain |>
      [addTableIntersectCount](../reference/addTableIntersectCount.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(-180, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id               <int> 99, 1641, 4563, 4572, 5200, 2235, 2243, 2425,…
    #> $ cohort_start_date        <date> 1959-08-21, 1967-04-20, 1980-04-17, 1977-11-…
    #> $ cohort_end_date          <date> 1959-09-18, 1967-05-11, 1980-05-15, 1977-12-…
    #> $ drug_exposure_m180_to_m1 <dbl> 4, 2, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    
    cdm$ankle_sprain |>
      [addTableIntersectDate](../reference/addTableIntersectDate.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-180, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id               <int> 99, 1641, 4572, 5200, 2235, 2243, 2425, 2988,…
    #> $ cohort_start_date        <date> 1959-08-21, 1967-04-20, 1977-11-08, 1960-08-…
    #> $ cohort_end_date          <date> 1959-09-18, 1967-05-11, 1977-12-13, 1960-09-…
    #> $ drug_exposure_m180_to_m1 <date> 1959-07-04, 1967-02-07, 1977-10-18, 1960-07-…
    
    
    cdm$ankle_sprain |>
      [addTableIntersectDate](../reference/addTableIntersectDate.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-180, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id               <int> 99, 1641, 4572, 5200, 2235, 2243, 2425, 2988,…
    #> $ cohort_start_date        <date> 1959-08-21, 1967-04-20, 1977-11-08, 1960-08-…
    #> $ cohort_end_date          <date> 1959-09-18, 1967-05-11, 1977-12-13, 1960-09-…
    #> $ drug_exposure_m180_to_m1 <date> 1959-07-04, 1967-02-07, 1977-10-18, 1960-07-…

In these examples we’ve been adding intersections using the entire drug exposure concept table. However, we could have subsetted it before adding our table intersection. For example, let’s say we want to add a variable for acetaminophen use among our ankle sprain cohort. As we’ve seen before we could use a cohort or concept set for this, but now we have another option - subset the drug exposure table down to acetaminophen records and add a table intersection.
    
    
    acetaminophen_cs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen")
    )
    
    cdm$acetaminophen_records <- cdm$drug_exposure |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(drug_concept_id [%in%](https://rdrr.io/r/base/match.html) !!acetaminophen_cs[[1]]) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)()
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "acetaminophen_records",
        indexDate = "cohort_start_date",
        targetStartDate = "drug_exposure_start_date",
        targetEndDate = "drug_exposure_end_date",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id              <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                        <int> 99, 331, 399, 404, 744, 895, 1022, 1…
    #> $ cohort_start_date                 <date> 1959-08-21, 1948-08-28, 1999-03-30,…
    #> $ cohort_end_date                   <date> 1959-09-18, 1948-10-02, 1999-05-04,…
    #> $ acetaminophen_records_minf_to_inf <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …

Beyond this table intersection provides a means if implementing a wide range of custom analyses. One more example to show this is provided below, where we check whether individuals have a measurement or procedure record on the date of their ankle sprain.
    
    
    cdm$proc_or_meas <- [union_all](https://dplyr.tidyverse.org/reference/setops.html)(
      cdm$procedure_occurrence |>
        [select](https://dplyr.tidyverse.org/reference/select.html)("person_id",
          "record_date" = "procedure_date"
        ),
      cdm$measurement |>
        [select](https://dplyr.tidyverse.org/reference/select.html)("person_id",
          "record_date" = "measurement_date"
        )
    ) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)()
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "proc_or_meas",
        indexDate = "cohort_start_date",
        targetStartDate = "record_date",
        targetEndDate = "record_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 0)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 99, 331, 399, 404, 744, 895, 1022, 1510, 1641, 16…
    #> $ cohort_start_date    <date> 1959-08-21, 1948-08-28, 1999-03-30, 1962-06-04, …
    #> $ cohort_end_date      <date> 1959-09-18, 1948-10-02, 1999-05-04, 1962-07-09, …
    #> $ proc_or_meas_0_to_0  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/articles/summarise.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Summarise result

Source: [`vignettes/summarise.Rmd`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/vignettes/summarise.Rmd)

`summarise.Rmd`

## Introduction

In previous vignettes we have seen how to add patient level demographics (age, sex, prior observation, …) or intersections with cohorts , concepts and tables.

Once we have added several columns to our table of interest we may want to summarise all this data into a `summarised_result` object using several different estimates.

### Variables type

We support different types of variables, variable type is assigned using `[dplyr::type_sum](https://pillar.r-lib.org/reference/type_sum.html)`:

  * Date: `date` or `dttm`.

  * Numeric: `dbl` or `drtn`.

  * Integer: `int` or `int64`.

  * Categorical: `chr`, `fct` or `ord`.

  * Logical: `lgl`.




### Estimates names

We can summarise this data using different estimates:

Estimate name | Description | Estimate type  
---|---|---  
date  
mean | mean of the variable of interest. | date  
sd | standard deviation of the variable of interest. | date  
median | median of the variable of interest. | date  
qXX | qualtile of XX% the variable of interest. | date  
min | minimum of the variable of interest. | date  
max | maximum of the variable of interest. | date  
count_missing | number of missing values. | integer  
percentage_missing | percentage of missing values | percentage  
density | density distribution | multiple  
numeric  
sum | sum of all the values for the variable of interest. | numeric  
mean | mean of the variable of interest. | numeric  
sd | standard deviation of the variable of interest. | numeric  
median | median of the variable of interest. | numeric  
qXX | qualtile of XX% the variable of interest. | numeric  
min | minimum of the variable of interest. | numeric  
max | maximum of the variable of interest. | numeric  
count_missing | number of missing values. | integer  
percentage_missing | percentage of missing values | percentage  
count | count number of `1`. | integer  
percentage | percentage of occurrences of `1` (NA are excluded). | percentage  
density | density distribution | multiple  
integer  
sum | sum of all the values for the variable of interest. | integer  
mean | mean of the variable of interest. | numeric  
sd | standard deviation of the variable of interest. | numeric  
median | median of the variable of interest. | integer  
qXX | qualtile of XX% the variable of interest. | integer  
min | minimum of the variable of interest. | integer  
max | maximum of the variable of interest. | integer  
count_missing | number of missing values. | integer  
percentage_missing | percentage of missing values | percentage  
count | count number of `1`. | integer  
percentage | percentage of occurrences of `1` (NA are excluded). | percentage  
density | density distribution | multiple  
categorical  
count | number of times that each category is observed. | integer  
percentage | percentage of individuals with that category. | percentage  
logical  
count | count number of `TRUE`. | integer  
percentage | percentage of occurrences of `TRUE` (NA are excluded). | percentage  
  
## Summarise our first table

Lets get started creating our data that we are going to summarise:
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()),
      cdmSchema = "main",
      writeSchema = "main"
    )
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)("sinusitis" = [c](https://rdrr.io/r/base/c.html)(4294548, 4283893, 40481087, 257012)),
      limit = "first",
      name = "my_cohort"
    )
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      conceptSet = [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = [c](https://rdrr.io/r/base/c.html)("morphine", "aspirin", "oxycodone")),
      name = "drugs"
    )
    
    x <- cdm$my_cohort |>
      # add demographics variables
      [addDemographics](../reference/addDemographics.html)() |>
      # add number of counts per ingredient before and after index date
      [addCohortIntersectCount](../reference/addCohortIntersectCount.html)(
        targetCohortTable = "drugs",
        window = [list](https://rdrr.io/r/base/list.html)("prior" = [c](https://rdrr.io/r/base/c.html)(-Inf, -1), "future" = [c](https://rdrr.io/r/base/c.html)(1, Inf)),
        nameStyle = "{window_name}_{cohort_name}"
      ) |>
      # add a flag regarding if they had a prior occurrence of pharyngitis
      [addConceptIntersectFlag](../reference/addConceptIntersectFlag.html)(
        conceptSet = [list](https://rdrr.io/r/base/list.html)(pharyngitis = 4112343),
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1),
        nameStyle = "pharyngitis_before"
      ) |>
      # date fo the first visit for that individual
      [addTableIntersectDate](../reference/addTableIntersectDate.html)(
        tableName = "visit_occurrence",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf),
        nameStyle = "first_visit"
      ) |>
      # time till the next visit after sinusitis
      [addTableIntersectDays](../reference/addTableIntersectDays.html)(
        tableName = "visit_occurrence",
        window = [c](https://rdrr.io/r/base/c.html)(1, Inf),
        nameStyle = "days_to_next_visit"
      )
    #> Warning: ! `codelist` casted to integers.
    
    x |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 17
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpEzf1a0/file275f3a60f2a8.duckdb]
    #> $ cohort_definition_id  <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id            <int> 42, 187, 96, 32, 5, 222, 1, 176, 116, 236, 101, …
    #> $ cohort_start_date     <date> 1926-05-12, 1953-02-18, 1933-11-16, 1967-01-29,…
    #> $ cohort_end_date       <date> 2019-03-13, 2018-11-19, 1997-02-01, 2014-12-24,…
    #> $ age                   <int> 16, 7, 8, 23, 9, 6, 18, 4, 12, 6, 4, 2, 23, 4, 3…
    #> $ sex                   <chr> "Female", "Male", "Male", "Male", "Male", "Femal…
    #> $ prior_observation     <int> 6034, 2767, 3246, 8495, 3308, 2379, 6696, 1537, …
    #> $ future_observation    <int> 33908, 24015, 23088, 17496, 14990, 22191, 18987,…
    #> $ prior_7052_morphine   <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ prior_7804_oxycodone  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, …
    #> $ future_1191_aspirin   <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, …
    #> $ future_7804_oxycodone <dbl> 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, …
    #> $ future_7052_morphine  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ prior_1191_aspirin    <dbl> 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, …
    #> $ pharyngitis_before    <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ first_visit           <date> 1933-10-30, 1985-02-09, 1985-04-13, 1987-06-09,…
    #> $ days_to_next_visit    <dbl> 2728, 11679, 18776, 7436, 4619, 10966, 5194, 229…

In this table (`x`) we have a cohort of first occurrences of sinusitis, and then we added: demographics; the counts of 3 ingredients, any time prior and any time after the index date; a flag indicating if they had pharyngitis before; date of the first visit; and, finally, time to next visit.

If we want to summarise the age stratified by sex we could use tidyverse functions like:
    
    
    x |>
      [group_by](https://dplyr.tidyverse.org/reference/group_by.html)(sex) |>
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)(mean_age = [mean](https://rdrr.io/r/base/mean.html)(age), sd_age = [sd](https://rdrr.io/r/stats/sd.html)(age))
    #> Warning: Missing values are always removed in SQL aggregation functions.
    #> Use `na.rm = TRUE` to silence this warning
    #> This warning is displayed once every 8 hours.
    #> # Source:   SQL [?? x 3]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpEzf1a0/file275f3a60f2a8.duckdb]
    #>   sex    mean_age sd_age
    #>   <chr>     <dbl>  <dbl>
    #> 1 Female     7.51   7.46
    #> 2 Male       7.72   8.14

This would give us a first insight of the differences of age. But the output is not going to be in an standardised format.

In PatientProfiles we have built a function that:

  * Allow you to get the standardised output.

  * You have a wide range of estimates that you can get.

  * You don’t have to worry which of the functions are supported in the database side (e.g. not all dbms support quantile function).




For example we could get the same information like before using:
    
    
    x |>
      [summariseResult](../reference/summariseResult.html)(
        strata = "sex",
        variables = "age",
        estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd"),
        counts = FALSE
      ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_name, strata_level, variable_name, estimate_value)
    #> ℹ The following estimates will be computed:
    #> • age: mean, sd
    #> → Start summary of data, at 2025-07-09 16:20:51.046991
    #> 
    #> ✔ Summary finished, at 2025-07-09 16:20:51.475062
    #> # A tibble: 6 × 4
    #>   strata_name strata_level variable_name estimate_value  
    #>   <chr>       <chr>        <chr>         <chr>           
    #> 1 overall     overall      age           7.61212346597248
    #> 2 overall     overall      age           7.79743654397838
    #> 3 sex         Female       age           7.5127644055434 
    #> 4 sex         Male         age           7.7154779969651 
    #> 5 sex         Female       age           7.45793686970358
    #> 6 sex         Male         age           8.13712697581575

You can stratify the results also by “pharyngitis_before”:
    
    
    x |>
      [summariseResult](../reference/summariseResult.html)(
        strata = [list](https://rdrr.io/r/base/list.html)("sex", "pharyngitis_before"),
        variables = "age",
        estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd"),
        counts = FALSE
      ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_name, strata_level, variable_name, estimate_value)
    #> ℹ The following estimates will be computed:
    #> • age: mean, sd
    #> → Start summary of data, at 2025-07-09 16:20:52.121535
    #> 
    #> ✔ Summary finished, at 2025-07-09 16:20:52.804982
    #> # A tibble: 10 × 4
    #>    strata_name        strata_level variable_name estimate_value  
    #>    <chr>              <chr>        <chr>         <chr>           
    #>  1 overall            overall      age           7.61212346597248
    #>  2 overall            overall      age           7.79743654397838
    #>  3 sex                Female       age           7.5127644055434 
    #>  4 sex                Male         age           7.7154779969651 
    #>  5 sex                Female       age           7.45793686970358
    #>  6 sex                Male         age           8.13712697581575
    #>  7 pharyngitis_before 0            age           4.95620875824835
    #>  8 pharyngitis_before 1            age           11.9442270058708
    #>  9 pharyngitis_before 0            age           5.61220818358422
    #> 10 pharyngitis_before 1            age           8.85279666294611

Note that the interaction term was not included, if we want to include it we have to specify it as follows:
    
    
    x |>
      [summariseResult](../reference/summariseResult.html)(
        strata = [list](https://rdrr.io/r/base/list.html)("sex", "pharyngitis_before", [c](https://rdrr.io/r/base/c.html)("sex", "pharyngitis_before")),
        variables = "age",
        estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd"),
        counts = FALSE
      ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_name, strata_level, variable_name, estimate_value) |>
      [print](https://rdrr.io/r/base/print.html)(n = Inf)
    #> ℹ The following estimates will be computed:
    #> • age: mean, sd
    #> → Start summary of data, at 2025-07-09 16:20:53.451611
    #> 
    #> ✔ Summary finished, at 2025-07-09 16:20:54.39609
    #> # A tibble: 18 × 4
    #>    strata_name                strata_level variable_name estimate_value  
    #>    <chr>                      <chr>        <chr>         <chr>           
    #>  1 overall                    overall      age           7.61212346597248
    #>  2 overall                    overall      age           7.79743654397838
    #>  3 sex                        Female       age           7.5127644055434 
    #>  4 sex                        Male         age           7.7154779969651 
    #>  5 sex                        Female       age           7.45793686970358
    #>  6 sex                        Male         age           8.13712697581575
    #>  7 pharyngitis_before         0            age           4.95620875824835
    #>  8 pharyngitis_before         1            age           11.9442270058708
    #>  9 pharyngitis_before         0            age           5.61220818358422
    #> 10 pharyngitis_before         1            age           8.85279666294611
    #> 11 sex &&& pharyngitis_before Female &&& 0 age           4.97596153846154
    #> 12 sex &&& pharyngitis_before Female &&& 1 age           11.4285714285714
    #> 13 sex &&& pharyngitis_before Male &&& 0   age           4.93652694610778
    #> 14 sex &&& pharyngitis_before Male &&& 1   age           12.51966873706  
    #> 15 sex &&& pharyngitis_before Female &&& 0 age           5.61023639284453
    #> 16 sex &&& pharyngitis_before Female &&& 1 age           8.22838499965833
    #> 17 sex &&& pharyngitis_before Male &&& 0   age           5.61746547644658
    #> 18 sex &&& pharyngitis_before Male &&& 1   age           9.47682947960302

You can remove overall strata with the includeOverallStrata option:
    
    
    x |>
      [summariseResult](../reference/summariseResult.html)(
        includeOverallStrata = FALSE,
        strata = [list](https://rdrr.io/r/base/list.html)("sex", "pharyngitis_before"),
        variables = "age",
        estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd"),
        counts = FALSE
      ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_name, strata_level, variable_name, estimate_value) |>
      [print](https://rdrr.io/r/base/print.html)(n = Inf)
    #> ℹ The following estimates will be computed:
    #> • age: mean, sd
    #> → Start summary of data, at 2025-07-09 16:20:55.041476
    #> 
    #> ✔ Summary finished, at 2025-07-09 16:20:55.558165
    #> # A tibble: 8 × 4
    #>   strata_name        strata_level variable_name estimate_value  
    #>   <chr>              <chr>        <chr>         <chr>           
    #> 1 sex                Female       age           7.5127644055434 
    #> 2 sex                Male         age           7.7154779969651 
    #> 3 sex                Female       age           7.45793686970358
    #> 4 sex                Male         age           8.13712697581575
    #> 5 pharyngitis_before 0            age           4.95620875824835
    #> 6 pharyngitis_before 1            age           11.9442270058708
    #> 7 pharyngitis_before 0            age           5.61220818358422
    #> 8 pharyngitis_before 1            age           8.85279666294611

The results model has two levels of grouping (group and strata), you can specify them independently:
    
    
    x |>
      [addCohortName](../reference/addCohortName.html)() |>
      [summariseResult](../reference/summariseResult.html)(
        group = "cohort_name",
        includeOverallGroup = FALSE,
        strata = [list](https://rdrr.io/r/base/list.html)("sex", "pharyngitis_before"),
        includeOverallStrata = TRUE,
        variables = "age",
        estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd"),
        counts = FALSE
      ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(group_name, group_level, strata_name, strata_level, variable_name, estimate_value) |>
      [print](https://rdrr.io/r/base/print.html)(n = Inf)
    #> ℹ The following estimates will be computed:
    #> • age: mean, sd
    #> → Start summary of data, at 2025-07-09 16:20:56.411661
    #> 
    #> ✔ Summary finished, at 2025-07-09 16:20:57.25681
    #> # A tibble: 10 × 6
    #>    group_name  group_level strata_name strata_level variable_name estimate_value
    #>    <chr>       <chr>       <chr>       <chr>        <chr>         <chr>         
    #>  1 cohort_name sinusitis   overall     overall      age           7.61212346597…
    #>  2 cohort_name sinusitis   overall     overall      age           7.79743654397…
    #>  3 cohort_name sinusitis   sex         Female       age           7.51276440554…
    #>  4 cohort_name sinusitis   sex         Male         age           7.71547799696…
    #>  5 cohort_name sinusitis   sex         Female       age           7.45793686970…
    #>  6 cohort_name sinusitis   sex         Male         age           8.13712697581…
    #>  7 cohort_name sinusitis   pharyngiti… 0            age           4.95620875824…
    #>  8 cohort_name sinusitis   pharyngiti… 1            age           11.9442270058…
    #>  9 cohort_name sinusitis   pharyngiti… 0            age           5.61220818358…
    #> 10 cohort_name sinusitis   pharyngiti… 1            age           8.85279666294…

We can add or remove number subjects and records (if a person identifier is found) counts with the counts parameter:
    
    
    x |>
      [summariseResult](../reference/summariseResult.html)(
        variables = "age",
        estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd"),
        counts = TRUE
      ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_name, strata_level, variable_name, estimate_value) |>
      [print](https://rdrr.io/r/base/print.html)(n = Inf)
    #> ℹ The following estimates will be computed:
    #> • age: mean, sd
    #> → Start summary of data, at 2025-07-09 16:20:57.910523
    #> 
    #> ✔ Summary finished, at 2025-07-09 16:20:58.17918
    #> # A tibble: 4 × 4
    #>   strata_name strata_level variable_name   estimate_value  
    #>   <chr>       <chr>        <chr>           <chr>           
    #> 1 overall     overall      number records  2689            
    #> 2 overall     overall      number subjects 2689            
    #> 3 overall     overall      age             7.61212346597248
    #> 4 overall     overall      age             7.79743654397838

If you want to specify different groups of estimates per different groups of variables you can use lists:
    
    
    x |>
      [summariseResult](../reference/summariseResult.html)(
        strata = "pharyngitis_before",
        includeOverallStrata = FALSE,
        variables = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)("age", "prior_observation"), "sex"),
        estimates = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)("mean", "sd"), [c](https://rdrr.io/r/base/c.html)("count", "percentage")),
        counts = FALSE
      ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_name, strata_level, variable_name, estimate_value) |>
      [print](https://rdrr.io/r/base/print.html)(n = Inf)
    #> ℹ The following estimates will be computed:
    #> • age: mean, sd
    #> • prior_observation: mean, sd
    #> • sex: count, percentage
    #> → Start summary of data, at 2025-07-09 16:20:58.838856
    #> 
    #> ✔ Summary finished, at 2025-07-09 16:20:59.287133
    #> # A tibble: 16 × 4
    #>    strata_name        strata_level variable_name     estimate_value  
    #>    <chr>              <chr>        <chr>             <chr>           
    #>  1 pharyngitis_before 0            age               4.95620875824835
    #>  2 pharyngitis_before 1            age               11.9442270058708
    #>  3 pharyngitis_before 0            age               5.61220818358422
    #>  4 pharyngitis_before 1            age               8.85279666294611
    #>  5 pharyngitis_before 0            sex               832             
    #>  6 pharyngitis_before 1            sex               539             
    #>  7 pharyngitis_before 0            sex               835             
    #>  8 pharyngitis_before 1            sex               483             
    #>  9 pharyngitis_before 0            sex               49.9100179964007
    #> 10 pharyngitis_before 1            sex               52.7397260273973
    #> 11 pharyngitis_before 0            sex               50.0899820035993
    #> 12 pharyngitis_before 1            sex               47.2602739726027
    #> 13 pharyngitis_before 0            prior_observation 1986.83443311338
    #> 14 pharyngitis_before 1            prior_observation 4542.85812133072
    #> 15 pharyngitis_before 0            prior_observation 2053.24325390978
    #> 16 pharyngitis_before 1            prior_observation 3228.06460521218

An example of a complete analysis would be:
    
    
    drugs <- [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$drugs)$cohort_name
    x |>
      [addCohortName](../reference/addCohortName.html)() |>
      [summariseResult](../reference/summariseResult.html)(
        group = "cohort_name",
        includeOverallGroup = FALSE,
        strata = [list](https://rdrr.io/r/base/list.html)("pharyngitis_before"),
        includeOverallStrata = TRUE,
        variables = [list](https://rdrr.io/r/base/list.html)(
          [c](https://rdrr.io/r/base/c.html)(
            "age", "prior_observation", "future_observation", [paste0](https://rdrr.io/r/base/paste.html)("prior_", drugs),
            [paste0](https://rdrr.io/r/base/paste.html)("future_", drugs), "days_to_next_visit"
          ),
          [c](https://rdrr.io/r/base/c.html)("sex", "pharyngitis_before"),
          [c](https://rdrr.io/r/base/c.html)("first_visit", "cohort_start_date", "cohort_end_date")
        ),
        estimates = [list](https://rdrr.io/r/base/list.html)(
          [c](https://rdrr.io/r/base/c.html)("median", "q25", "q75"),
          [c](https://rdrr.io/r/base/c.html)("count", "percentage"),
          [c](https://rdrr.io/r/base/c.html)("median", "q25", "q75", "min", "max")
        ),
        counts = TRUE
      ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(group_name, group_level, strata_name, strata_level, variable_name, estimate_value)
    #> ℹ The following estimates will be computed:
    #> • age: median, q25, q75
    #> • prior_observation: median, q25, q75
    #> • future_observation: median, q25, q75
    #> • prior_1191_aspirin: median, q25, q75
    #> • prior_7052_morphine: median, q25, q75
    #> • prior_7804_oxycodone: median, q25, q75
    #> • future_1191_aspirin: median, q25, q75
    #> • future_7052_morphine: median, q25, q75
    #> • future_7804_oxycodone: median, q25, q75
    #> • days_to_next_visit: median, q25, q75
    #> • sex: count, percentage
    #> • pharyngitis_before: count, percentage
    #> • first_visit: median, q25, q75, min, max
    #> • cohort_start_date: median, q25, q75, min, max
    #> • cohort_end_date: median, q25, q75, min, max
    #> ! Table is collected to memory as not all requested estimates are supported on
    #>   the database side
    #> → Start summary of data, at 2025-07-09 16:21:00.238599
    #> 
    #> ✔ Summary finished, at 2025-07-09 16:21:00.555486
    #> # A tibble: 159 × 6
    #>    group_name  group_level strata_name strata_level variable_name estimate_value
    #>    <chr>       <chr>       <chr>       <chr>        <chr>         <chr>         
    #>  1 cohort_name sinusitis   overall     overall      number recor… 2689          
    #>  2 cohort_name sinusitis   overall     overall      number subje… 2689          
    #>  3 cohort_name sinusitis   overall     overall      cohort_start… 1968-05-06    
    #>  4 cohort_name sinusitis   overall     overall      cohort_start… 1956-07-05    
    #>  5 cohort_name sinusitis   overall     overall      cohort_start… 1978-09-04    
    #>  6 cohort_name sinusitis   overall     overall      cohort_start… 1908-10-30    
    #>  7 cohort_name sinusitis   overall     overall      cohort_start… 2018-02-13    
    #>  8 cohort_name sinusitis   overall     overall      cohort_end_d… 2018-12-14    
    #>  9 cohort_name sinusitis   overall     overall      cohort_end_d… 2018-08-02    
    #> 10 cohort_name sinusitis   overall     overall      cohort_end_d… 2019-04-06    
    #> # ℹ 149 more rows

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/news/index.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/NEWS.md)

## PatientProfiles 1.4.2

CRAN release: 2025-07-09

  * Allow NA values with density estimate by [@catalamarti](https://github.com/catalamarti) in [#795](https://github.com/darwin-eu/PatientProfiles/issues/795)



## PatientProfiles 1.4.1

CRAN release: 2025-06-27

  * Fix pass type in expression by [@edward-burn](https://github.com/edward-burn) in [#794](https://github.com/darwin-eu/PatientProfiles/issues/794)



## PatientProfiles 1.4.0

CRAN release: 2025-05-30

  * Fix readme lifecycle badge by [@catalamarti](https://github.com/catalamarti) in [#778](https://github.com/darwin-eu/PatientProfiles/issues/778)
  * create new function `addConceptName` by [@catalamarti](https://github.com/catalamarti) in [#783](https://github.com/darwin-eu/PatientProfiles/issues/783)
  * Support visit domain and drop non supported concepts in `addConceptIntersect` by [@catalamarti](https://github.com/catalamarti) in [#784](https://github.com/darwin-eu/PatientProfiles/issues/784)
  * Collect in SummariseResult if median is asked in a sql server by [@catalamarti](https://github.com/catalamarti) in [#789](https://github.com/darwin-eu/PatientProfiles/issues/789)
  * arrange strata in summariseResult by [@catalamarti](https://github.com/catalamarti) in [#790](https://github.com/darwin-eu/PatientProfiles/issues/790)
  * Improve performance of .addIntersect by [@catalamarti](https://github.com/catalamarti) in [#788](https://github.com/darwin-eu/PatientProfiles/issues/788)



## PatientProfiles 1.3.1

CRAN release: 2025-03-05

  * Validate cohort using class by [@catalamarti](https://github.com/catalamarti) in [#773](https://github.com/darwin-eu/PatientProfiles/issues/773)
  * Use case_when in addCategories by [@catalamarti](https://github.com/catalamarti) in [#774](https://github.com/darwin-eu/PatientProfiles/issues/774)
  * Fix binary counts in db by [@catalamarti](https://github.com/catalamarti) in [#775](https://github.com/darwin-eu/PatientProfiles/issues/775)



## PatientProfiles 1.3.0

CRAN release: 2025-02-26

  * Changed addCategories by [@KimLopezGuell](https://github.com/KimLopezGuell) in [#734](https://github.com/darwin-eu/PatientProfiles/issues/734)
  * conceptSet allows conceptSetExpression by [@catalamarti](https://github.com/catalamarti) in [#743](https://github.com/darwin-eu/PatientProfiles/issues/743)
  * account for integer64 counts by [@catalamarti](https://github.com/catalamarti) in [#745](https://github.com/darwin-eu/PatientProfiles/issues/745)
  * add inObservation argument in addTable… by [@catalamarti](https://github.com/catalamarti) in [#749](https://github.com/darwin-eu/PatientProfiles/issues/749)
  * addConceptIntersectField by [@catalamarti](https://github.com/catalamarti) in [#747](https://github.com/darwin-eu/PatientProfiles/issues/747)
  * validate targetCohortId with og by [@catalamarti](https://github.com/catalamarti) in [#750](https://github.com/darwin-eu/PatientProfiles/issues/750)
  * create filterInObservation by [@catalamarti](https://github.com/catalamarti) in [#744](https://github.com/darwin-eu/PatientProfiles/issues/744)
  * create filterCohortId by [@catalamarti](https://github.com/catalamarti) in [#748](https://github.com/darwin-eu/PatientProfiles/issues/748)
  * add benchmarkPatientProfiles by [@catalamarti](https://github.com/catalamarti) in [#752](https://github.com/darwin-eu/PatientProfiles/issues/752)
  * Update addIntersect.R by [@catalamarti](https://github.com/catalamarti) in [#758](https://github.com/darwin-eu/PatientProfiles/issues/758)
  * Reduce addDemographics computing time by [@catalamarti](https://github.com/catalamarti) in [#759](https://github.com/darwin-eu/PatientProfiles/issues/759)
  * Reduce addIntersect computing time by [@catalamarti](https://github.com/catalamarti) in [#761](https://github.com/darwin-eu/PatientProfiles/issues/761) [#762](https://github.com/darwin-eu/PatientProfiles/issues/762) [#764](https://github.com/darwin-eu/PatientProfiles/issues/764) [#763](https://github.com/darwin-eu/PatientProfiles/issues/763)
  * preserve field type and add allowDuplicates arg by [@catalamarti](https://github.com/catalamarti) in [#765](https://github.com/darwin-eu/PatientProfiles/issues/765)
  * Add `weights` argument to `summariseResult` by [@nmercadeb](https://github.com/nmercadeb) in [#733](https://github.com/darwin-eu/PatientProfiles/issues/733)
  * Increase test coverage by [@catalamarti](https://github.com/catalamarti) in [#768](https://github.com/darwin-eu/PatientProfiles/issues/768)



## PatientProfiles 1.2.3

CRAN release: 2024-12-12

  * Bug fix to correct NA columns when not in observation by [@catalamarti](https://github.com/catalamarti)



## PatientProfiles 1.2.2

CRAN release: 2024-11-28

  * Update links and codecoverage by [@catalamarti](https://github.com/catalamarti)
  * Distinct individuals in addObservationPeriodId() by [@martaalcalde](https://github.com/martaalcalde)
  * Remove dependencies on visOmopResults and magrittr [@catalamarti](https://github.com/catalamarti)



## PatientProfiles 1.2.1

CRAN release: 2024-10-25

  * edge case where no concept in concept table by [@edward-burn](https://github.com/edward-burn)
  * update assertions in addDeath functions by [@catalamarti](https://github.com/catalamarti)
  * increase test coverage by [@catalamarti](https://github.com/catalamarti)
  * add internal compute to addInObservation by [@edward-burn](https://github.com/edward-burn)
  * conceptIntersect inObservation argument by [@edward-burn](https://github.com/edward-burn)



## PatientProfiles 1.2.0

CRAN release: 2024-09-11

  * `[addObservationPeriodId()](../reference/addObservationPeriodId.html)` is a new function that adds the number of observation period that an observation is in.

  * Add `density` estimate to `[summariseResult()](../reference/summariseResult.html)`




## PatientProfiles 1.1.1

CRAN release: 2024-07-28

  * `addCohortName` overwrites if there already exists a `cohort_name` column [#680](https://github.com/darwin-eu/PatientProfiles/issues/680) and [#682](https://github.com/darwin-eu/PatientProfiles/issues/682).

  * Correct nan and Inf for missing values [#674](https://github.com/darwin-eu/PatientProfiles/issues/674)

  * Fix [#670](https://github.com/darwin-eu/PatientProfiles/issues/670) [#671](https://github.com/darwin-eu/PatientProfiles/issues/671)




## PatientProfiles 1.1.0

CRAN release: 2024-06-11

  * addConceptIntersect now includes records with missing end date under the assumption that end date is equal to start date.

  * add* functions have a new argument called `name` to decide if we want a resultant temp table (`name = NULL`) or have a permanent table with a certain name. Additional functions are provided, e.g. addDemographicsQuery, where the result is not computed.




## PatientProfiles 1.0.0

CRAN release: 2024-05-16

  * Stable release of package



## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/mockPatientProfiles.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates a mock database for testing PatientProfiles package

Source: [`R/mockPatientProfiles.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/mockPatientProfiles.R)

`mockPatientProfiles.Rd`

It creates a mock database for testing PatientProfiles package

## Usage
    
    
    mockPatientProfiles(
      con = NULL,
      writeSchema = NULL,
      numberIndividuals = 10,
      ...,
      seed = NULL
    )

## Arguments

con
    

A DBI connection to create the cdm mock object.

writeSchema
    

Name of an schema on the same connection with writing permisions.

numberIndividuals
    

Number of individuals to create in the cdm reference.

...
    

User self defined tables to put in cdm, it can input as many as the user want.

seed
    

A number to set the seed. If NULL seed is not used.

## Value

A mock cdm_reference object created following user's specifications.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    cdm <- mockPatientProfiles()
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addAge.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute the age of the individuals at a certain date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addAge.Rd`

Compute the age of the individuals at a certain date

## Usage
    
    
    addAge(
      x,
      indexDate = "cohort_start_date",
      ageName = "age",
      ageGroup = NULL,
      ageMissingMonth = 1,
      ageMissingDay = 1,
      ageImposeMonth = FALSE,
      ageImposeDay = FALSE,
      missingAgeGroupValue = "None",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the age.

ageName
    

Name of the new column that contains age.

ageGroup
    

List of age groups to be added.

ageMissingMonth
    

Month of the year assigned to individuals with missing month of birth. By default: 1.

ageMissingDay
    

day of the month assigned to individuals with missing day of birth. By default: 1.

ageImposeMonth
    

Whether the month of the date of birth will be considered as missing for all the individuals.

ageImposeDay
    

Whether the day of the date of birth will be considered as missing for all the individuals.

missingAgeGroupValue
    

Value to include if missing age.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

tibble with the age column added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addAge()
    #> # Source:   table<og_001_1752077876> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    #>                   <int>      <int> <date>            <date>          <int>
    #>  1                    1         10 1995-08-12        2002-08-14         33
    #>  2                    2          4 1986-05-17        1986-07-22          7
    #>  3                    3          6 1938-08-02        1938-08-19         36
    #>  4                    1          7 1970-09-20        1973-06-22          8
    #>  5                    3          9 1956-11-27        1965-01-19         13
    #>  6                    1          2 1927-11-21        1933-10-31         22
    #>  7                    1          3 1926-01-03        1931-07-22          2
    #>  8                    1          5 1983-11-23        1990-12-19          6
    #>  9                    1          1 1971-08-26        1979-02-11          2
    #> 10                    2          8 1973-08-11        1978-10-05         18
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addSex.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute the sex of the individuals

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addSex.Rd`

Compute the sex of the individuals

## Usage
    
    
    addSex(x, sexName = "sex", missingSexValue = "None", name = NULL)

## Arguments

x
    

Table with individuals in the cdm.

sexName
    

name of the new column to be added.

missingSexValue
    

Value to include if missing sex.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table x with the added column with sex information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addSex()
    #> # Source:   table<og_120_1752077949> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date sex   
    #>                   <int>      <int> <date>            <date>          <chr> 
    #>  1                    2          1 1948-09-19        1951-07-04      Female
    #>  2                    1          2 1996-03-02        2006-04-11      Female
    #>  3                    2          3 1975-06-24        1980-12-09      Female
    #>  4                    3          4 1964-10-14        1981-03-17      Male  
    #>  5                    3          5 1954-10-18        1957-04-05      Male  
    #>  6                    2          6 1938-12-16        1939-02-14      Male  
    #>  7                    3          7 1955-05-18        1962-05-10      Male  
    #>  8                    1          8 1939-01-25        1939-04-04      Male  
    #>  9                    3          9 1958-07-31        1962-12-28      Female
    #> 10                    2         10 1910-01-31        1910-03-17      Male  
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addPriorObservation.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute the number of days of prior observation in the current observation period at a certain date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addPriorObservation.Rd`

Compute the number of days of prior observation in the current observation period at a certain date

## Usage
    
    
    addPriorObservation(
      x,
      indexDate = "cohort_start_date",
      priorObservationName = "prior_observation",
      priorObservationType = "days",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the prior observation.

priorObservationName
    

name of the new column to be added.

priorObservationType
    

Whether to return a "date" or the number of "days".

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

cohort table with added column containing prior observation of the individuals.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addPriorObservation()
    #> # Source:   table<og_119_1752077945> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          8 1963-04-02        1975-08-05     
    #>  2                    2          1 1945-12-20        1964-04-11     
    #>  3                    2         10 1959-01-17        1976-06-12     
    #>  4                    3          4 1975-09-18        1979-05-02     
    #>  5                    2          3 1940-03-02        1940-12-11     
    #>  6                    1          9 1959-07-04        1960-03-27     
    #>  7                    1          7 1913-02-17        1914-10-20     
    #>  8                    3          2 1953-03-30        1954-02-13     
    #>  9                    1          5 1959-07-16        1959-08-27     
    #> 10                    2          6 1916-12-23        1931-10-23     
    #> # ℹ 1 more variable: prior_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addCohortIntersectFlag.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates columns to indicate the presence of cohorts

Source: [`R/addCohortIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCohortIntersect.R)

`addCohortIntersectFlag.Rd`

It creates columns to indicate the presence of cohorts

## Usage
    
    
    addCohortIntersectFlag(
      x,
      targetCohortTable,
      targetCohortId = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      targetStartDate = "cohort_start_date",
      targetEndDate = "cohort_end_date",
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      nameStyle = "{cohort_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

targetCohortTable
    

name of the cohort that we want to check for overlap.

targetCohortId
    

vector of cohort definition ids to include.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

targetStartDate
    

date of reference in cohort table, either for start (in overlap) or on its own (for incidence).

targetEndDate
    

date of reference in cohort table, either for end (overlap) or NULL (if incidence).

window
    

window to consider events of.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with overlap information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addCohortIntersectFlag(
        targetCohortTable = "cohort2"
      )
    #> # Source:   table<og_027_1752077892> [?? x 7]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          3 1952-10-08        1958-09-10     
    #>  2                    3          4 1941-08-11        1947-04-26     
    #>  3                    3          5 1990-05-15        1995-07-25     
    #>  4                    2          9 1936-08-20        1944-12-19     
    #>  5                    3          7 1967-01-03        1972-10-31     
    #>  6                    1         10 1919-04-06        1939-09-01     
    #>  7                    3          2 1951-07-30        1955-01-08     
    #>  8                    2          8 1950-08-19        1977-04-20     
    #>  9                    3          6 1952-06-04        1965-07-15     
    #> 10                    3          1 1948-05-23        1966-02-05     
    #> # ℹ 3 more variables: cohort_1_0_to_inf <dbl>, cohort_3_0_to_inf <dbl>,
    #> #   cohort_2_0_to_inf <dbl>
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addCohortIntersectCount.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates columns to indicate number of occurrences of intersection with a cohort

Source: [`R/addCohortIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCohortIntersect.R)

`addCohortIntersectCount.Rd`

It creates columns to indicate number of occurrences of intersection with a cohort

## Usage
    
    
    addCohortIntersectCount(
      x,
      targetCohortTable,
      targetCohortId = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      targetStartDate = "cohort_start_date",
      targetEndDate = "cohort_end_date",
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      nameStyle = "{cohort_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

targetCohortTable
    

name of the cohort that we want to check for overlap.

targetCohortId
    

vector of cohort definition ids to include.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

targetStartDate
    

date of reference in cohort table, either for start (in overlap) or on its own (for incidence).

targetEndDate
    

date of reference in cohort table, either for end (overlap) or NULL (if incidence).

window
    

window to consider events of.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with overlap information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addCohortIntersectCount(
        targetCohortTable = "cohort2"
      )
    #> # Source:   table<og_004_1752077884> [?? x 7]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          6 1980-09-12        2005-08-18     
    #>  2                    3         10 1975-11-09        1977-04-11     
    #>  3                    3          7 1983-04-18        2002-06-23     
    #>  4                    1          8 1930-02-14        1942-04-25     
    #>  5                    1          9 1953-11-05        1954-04-24     
    #>  6                    1          3 1969-10-19        1977-08-26     
    #>  7                    2          5 1923-06-04        1940-05-22     
    #>  8                    1          2 1993-09-24        1993-12-02     
    #>  9                    3          4 1970-08-12        1971-09-07     
    #> 10                    3          1 1978-12-03        1982-05-08     
    #> # ℹ 3 more variables: cohort_2_0_to_inf <dbl>, cohort_1_0_to_inf <dbl>,
    #> #   cohort_3_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addCohortIntersectDate.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Date of cohorts that are present in a certain window

Source: [`R/addCohortIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCohortIntersect.R)

`addCohortIntersectDate.Rd`

Date of cohorts that are present in a certain window

## Usage
    
    
    addCohortIntersectDate(
      x,
      targetCohortTable,
      targetCohortId = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      targetDate = "cohort_start_date",
      order = "first",
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      nameStyle = "{cohort_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

targetCohortTable
    

Cohort table to.

targetCohortId
    

Cohort IDs of interest from the other cohort table. If NULL, all cohorts will be used with a time variable added for each cohort of interest.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

targetDate
    

Date of interest in the other cohort table. Either cohort_start_date or cohort_end_date.

order
    

date to use if there are multiple records for an individual during the window of interest. Either first or last.

window
    

Window of time to identify records relative to the indexDate. Records outside of this time period will be ignored.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

x along with additional columns for each cohort of interest.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addCohortIntersectDate(targetCohortTable = "cohort2")
    #> # Source:   table<og_014_1752077887> [?? x 7]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          2 1923-02-14        1926-02-19     
    #>  2                    3         10 2006-06-15        2017-05-06     
    #>  3                    3          9 2003-01-10        2006-06-01     
    #>  4                    1          1 1936-01-12        1936-08-21     
    #>  5                    2          5 1940-08-05        1940-09-14     
    #>  6                    3          6 1961-08-03        1963-05-20     
    #>  7                    3          8 1956-07-17        1957-08-06     
    #>  8                    1          4 1985-11-12        2000-10-01     
    #>  9                    1          3 1911-10-08        1913-04-20     
    #> 10                    3          7 1937-05-17        1940-11-20     
    #> # ℹ 3 more variables: cohort_3_0_to_inf <date>, cohort_2_0_to_inf <date>,
    #> #   cohort_1_0_to_inf <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addCohortIntersectDays.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates columns to indicate the number of days between the current table and a target cohort

Source: [`R/addCohortIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCohortIntersect.R)

`addCohortIntersectDays.Rd`

It creates columns to indicate the number of days between the current table and a target cohort

## Usage
    
    
    addCohortIntersectDays(
      x,
      targetCohortTable,
      targetCohortId = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      targetDate = "cohort_start_date",
      order = "first",
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      nameStyle = "{cohort_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

targetCohortTable
    

Cohort table to.

targetCohortId
    

Cohort IDs of interest from the other cohort table. If NULL, all cohorts will be used with a days variable added for each cohort of interest.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

targetDate
    

Date of interest in the other cohort table. Either cohort_start_date or cohort_end_date.

order
    

date to use if there are multiple records for an individual during the window of interest. Either first or last.

window
    

Window of time to identify records relative to the indexDate. Records outside of this time period will be ignored.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

x along with additional columns for each cohort of interest.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addCohortIntersectDays(targetCohortTable = "cohort2")
    #> # Source:   table<og_021_1752077889> [?? x 7]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          1 1957-05-28        1960-02-18     
    #>  2                    1         10 1951-03-24        1969-10-06     
    #>  3                    3          5 1958-01-08        1965-11-13     
    #>  4                    3          2 1988-11-20        2000-05-23     
    #>  5                    1          4 1955-01-13        1962-02-16     
    #>  6                    2          8 1997-04-11        2003-01-20     
    #>  7                    3          6 1985-05-23        1993-10-25     
    #>  8                    2          9 1961-12-14        1965-09-21     
    #>  9                    3          3 1951-12-31        1957-11-21     
    #> 10                    3          7 1978-06-08        1985-08-02     
    #> # ℹ 3 more variables: cohort_2_0_to_inf <dbl>, cohort_1_0_to_inf <dbl>,
    #> #   cohort_3_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Function to disconnect from the mock

Source: [`R/mockPatientProfiles.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/mockPatientProfiles.R)

`mockDisconnect.Rd`

Function to disconnect from the mock

## Usage
    
    
    mockDisconnect(cdm)

## Arguments

cdm
    

A cdm_reference object.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/LICENSE.html

Skip to contents

[PatientProfiles](index.html) 1.4.2

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](articles/demographics.html)
    * [Adding cohort intersections](articles/cohort-intersect.html)
    * [Adding concept intersections](articles/concept-intersect.html)
    * [Adding table intersections](articles/table-intersect.html)
    * [Summarise result](articles/summarise.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](logo.png)

# Apache License

Source: [`LICENSE.md`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/LICENSE.md)

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

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/CONTRIBUTING.html

Skip to contents

[PatientProfiles](index.html) 1.4.2

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](articles/demographics.html)
    * [Adding cohort intersections](articles/cohort-intersect.html)
    * [Adding concept intersections](articles/concept-intersect.html)
    * [Adding table intersections](articles/table-intersect.html)
    * [Summarise result](articles/summarise.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](logo.png)

# Contributing to PatientProfiles

Source: [`.github/CONTRIBUTING.md`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/.github/CONTRIBUTING.md)

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated. Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

### Documenting the package

Run the below to update and check package documentation:
    
    
    devtools::document() 
    devtools::run_examples()
    devtools::build_readme()
    devtools::build_vignettes()
    devtools::check_man()

Note that `devtools::check_man()` should not return any warnings. If your commit is limited to only package documentation, running the above should be sufficient (although running `devtools::check()` will always generally be a good idea before submitting a pull request.

### Run tests

Before starting to contribute any code, first make sure the package tests are all passing. If not raise an issue before going any further (although please first make sure you have all the packages from imports and suggests installed). As you then contribute code, make sure that all the current tests and any you add continue to pass. All package tests can be run together with:
    
    
    devtools::test()

Code to add new functionality should be accompanied by tests. Code coverage can be checked using:
    
    
    # note, you may first have to detach the package
    # detach("package:PatientProfiles", unload=TRUE)
    devtools::test_coverage()

### Adhere to code style

Please adhere to the code style when adding any new code. Do not though restyle any code unrelated to your pull request as this will make code review more difficult.
    
    
    lintr::lint_package(".",
                        linters = lintr::linters_with_defaults(
                          lintr::object_name_linter(styles = "camelCase")
                        )
    )

### Run check() before opening a pull request

Before opening any pull request please make sure to run:
    
    
    devtools::check() 

No warnings should be seen.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/authors.html

Skip to contents

[PatientProfiles](index.html) 1.4.2

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](articles/demographics.html)
    * [Adding cohort intersections](articles/cohort-intersect.html)
    * [Adding concept intersections](articles/concept-intersect.html)
    * [Adding table intersections](articles/table-intersect.html)
    * [Summarise result](articles/summarise.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](logo.png)

# Authors and Citation

## Authors

  * **Martí Català**. Author, maintainer. [](https://orcid.org/0000-0003-3308-9905)

  * **Yuchen Guo**. Author. [](https://orcid.org/0000-0002-0847-4855)

  * **Mike Du**. Author. [](https://orcid.org/0000-0002-9517-8834)

  * **Kim Lopez-Guell**. Author. [](https://orcid.org/0000-0002-8462-8668)

  * **Edward Burn**. Author. [](https://orcid.org/0000-0002-9286-1128)

  * **Nuria Mercade-Besora**. Author. [](https://orcid.org/0009-0006-7948-3747)

  * **Xintong Li**. Contributor. [](https://orcid.org/0000-0002-6872-5804)

  * **Xihang Chen**. Contributor. [](https://orcid.org/0009-0001-8112-8959)




## Citation

Source: [`DESCRIPTION`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/DESCRIPTION)

Català M, Guo Y, Du M, Lopez-Guell K, Burn E, Mercade-Besora N (2025). _PatientProfiles: Identify Characteristics of Patients in the OMOP Common Data Model_. R package version 1.4.2, <https://darwin-eu.github.io/PatientProfiles/>. 
    
    
    @Manual{,
      title = {PatientProfiles: Identify Characteristics of Patients in the OMOP Common Data Model},
      author = {Martí Català and Yuchen Guo and Mike Du and Kim Lopez-Guell and Edward Burn and Nuria Mercade-Besora},
      year = {2025},
      note = {R package version 1.4.2},
      url = {https://darwin-eu.github.io/PatientProfiles/},
    }

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addDateOfBirth.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add a column with the individual birth date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addDateOfBirth.Rd`

Add a column with the individual birth date

## Usage
    
    
    addDateOfBirth(
      x,
      dateOfBirthName = "date_of_birth",
      missingDay = 1,
      missingMonth = 1,
      imposeDay = FALSE,
      imposeMonth = FALSE,
      name = NULL
    )

## Arguments

x
    

Table in the cdm that contains 'person_id' or 'subject_id'.

dateOfBirthName
    

Name of the column to be added with the date of birth.

missingDay
    

Day of the individuals with no or imposed day of birth.

missingMonth
    

Month of the individuals with no or imposed month of birth.

imposeDay
    

Whether to impose day of birth.

imposeMonth
    

Whether to impose month of birth.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

The function returns the table x with an extra column that contains the date of birth.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDateOfBirth()
    #> # Source:   table<og_092_1752077916> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          1 1980-06-16        2005-08-11     
    #>  2                    2          4 1936-09-15        1939-10-27     
    #>  3                    1         10 1952-08-16        1954-05-10     
    #>  4                    2          9 2001-01-23        2002-04-18     
    #>  5                    3          2 1974-10-04        1979-05-21     
    #>  6                    1          5 1993-11-01        1996-08-26     
    #>  7                    2          3 1979-05-02        1999-11-28     
    #>  8                    3          8 1956-01-15        1964-03-09     
    #>  9                    1          7 1947-04-12        1951-04-21     
    #> 10                    1          6 1936-01-30        1942-05-05     
    #> # ℹ 1 more variable: date_of_birth <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addFutureObservation.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute the number of days till the end of the observation period at a certain date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addFutureObservation.Rd`

Compute the number of days till the end of the observation period at a certain date

## Usage
    
    
    addFutureObservation(
      x,
      indexDate = "cohort_start_date",
      futureObservationName = "future_observation",
      futureObservationType = "days",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the future observation.

futureObservationName
    

name of the new column to be added.

futureObservationType
    

Whether to return a "date" or the number of "days".

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

cohort table with added column containing future observation of the individuals.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addFutureObservation()
    #> # Source:   table<og_115_1752077932> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          2 1954-06-30        1955-07-22     
    #>  2                    3          3 1965-07-15        1966-05-07     
    #>  3                    2          9 1928-05-22        1938-06-22     
    #>  4                    3          4 1963-07-23        1973-02-21     
    #>  5                    3          8 1935-03-13        1952-02-24     
    #>  6                    2          7 1936-12-01        1946-12-14     
    #>  7                    3          1 1963-05-29        1972-03-02     
    #>  8                    3         10 1984-11-09        1985-02-05     
    #>  9                    2          6 1972-04-06        1972-12-04     
    #> 10                    1          5 1972-03-05        1974-09-12     
    #> # ℹ 1 more variable: future_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addInObservation.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Indicate if a certain record is within the observation period

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addInObservation.Rd`

Indicate if a certain record is within the observation period

## Usage
    
    
    addInObservation(
      x,
      indexDate = "cohort_start_date",
      window = [c](https://rdrr.io/r/base/c.html)(0, 0),
      completeInterval = FALSE,
      nameStyle = "in_observation",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the observation flag.

window
    

window to consider events of.

completeInterval
    

If the individuals are in observation for the full window.

nameStyle
    

Name of the new columns to create, it must contain "window_name" if multiple windows are provided.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

cohort table with the added binary column assessing inObservation.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addInObservation()
    #> # Source:   table<og_117_1752077937> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          1 1953-10-29        1954-04-12     
    #>  2                    1          9 1988-08-25        1990-01-07     
    #>  3                    3          4 1974-08-13        1980-06-01     
    #>  4                    3          8 1975-05-15        1996-12-29     
    #>  5                    1          6 1923-09-01        1928-12-03     
    #>  6                    3          7 1909-02-09        1921-09-17     
    #>  7                    2          5 1909-10-21        1922-07-08     
    #>  8                    1          2 1996-04-09        1996-05-30     
    #>  9                    3         10 1920-05-26        1927-09-15     
    #> 10                    2          3 1959-05-05        1965-08-27     
    #> # ℹ 1 more variable: in_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addDemographics.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute demographic characteristics at a certain date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addDemographics.Rd`

Compute demographic characteristics at a certain date

## Usage
    
    
    addDemographics(
      x,
      indexDate = "cohort_start_date",
      age = TRUE,
      ageName = "age",
      ageMissingMonth = 1,
      ageMissingDay = 1,
      ageImposeMonth = FALSE,
      ageImposeDay = FALSE,
      ageGroup = NULL,
      missingAgeGroupValue = "None",
      sex = TRUE,
      sexName = "sex",
      missingSexValue = "None",
      priorObservation = TRUE,
      priorObservationName = "prior_observation",
      priorObservationType = "days",
      futureObservation = TRUE,
      futureObservationName = "future_observation",
      futureObservationType = "days",
      dateOfBirth = FALSE,
      dateOfBirthName = "date_of_birth",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the demographics characteristics.

age
    

TRUE or FALSE. If TRUE, age will be calculated relative to indexDate.

ageName
    

Age variable name.

ageMissingMonth
    

Month of the year assigned to individuals with missing month of birth.

ageMissingDay
    

day of the month assigned to individuals with missing day of birth.

ageImposeMonth
    

TRUE or FALSE. Whether the month of the date of birth will be considered as missing for all the individuals.

ageImposeDay
    

TRUE or FALSE. Whether the day of the date of birth will be considered as missing for all the individuals.

ageGroup
    

if not NULL, a list of ageGroup vectors.

missingAgeGroupValue
    

Value to include if missing age.

sex
    

TRUE or FALSE. If TRUE, sex will be identified.

sexName
    

Sex variable name.

missingSexValue
    

Value to include if missing sex.

priorObservation
    

TRUE or FALSE. If TRUE, days of between the start of the current observation period and the indexDate will be calculated.

priorObservationName
    

Prior observation variable name.

priorObservationType
    

Whether to return a "date" or the number of "days".

futureObservation
    

TRUE or FALSE. If TRUE, days between the indexDate and the end of the current observation period will be calculated.

futureObservationName
    

Future observation variable name.

futureObservationType
    

Whether to return a "date" or the number of "days".

dateOfBirth
    

TRUE or FALSE, if true the date of birth will be return.

dateOfBirthName
    

dateOfBirth column name.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

cohort table with the added demographic information columns.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDemographics()
    #> # Source:   table<og_114_1752077928> [?? x 8]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age sex  
    #>                   <int>      <int> <date>            <date>          <int> <chr>
    #>  1                    2          1 1973-06-21        1975-05-16         41 Fema…
    #>  2                    3          2 1963-12-29        1964-12-14         12 Male 
    #>  3                    2          3 1943-10-25        1944-05-13         38 Fema…
    #>  4                    3          4 1931-07-03        1940-06-25          1 Fema…
    #>  5                    2          5 1944-07-23        1962-01-31         17 Fema…
    #>  6                    3          6 1977-01-05        1998-03-25          1 Fema…
    #>  7                    3          7 1996-07-05        1996-11-24         36 Male 
    #>  8                    2          8 1942-01-09        1949-01-17         14 Fema…
    #>  9                    2          9 1942-06-17        1942-11-28         15 Male 
    #> 10                    1         10 1905-10-16        1911-05-06          0 Fema…
    #> # ℹ 2 more variables: prior_observation <int>, future_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addDeathDate.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add date of death for individuals. Only death within the same observation period than `indexDate` will be observed.

Source: [`R/addDeath.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDeath.R)

`addDeathDate.Rd`

Add date of death for individuals. Only death within the same observation period than `indexDate` will be observed.

## Usage
    
    
    addDeathDate(
      x,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      deathDateName = "date_of_death",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the window origin.

censorDate
    

Name of a column to stop followup.

window
    

window to consider events over.

deathDateName
    

name of the new column to be added.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table x with the added column with death information added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDeathDate()
    #> # Source:   table<og_093_1752077920> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          5 1974-05-13        1976-11-03     
    #>  2                    1          2 1913-05-22        1925-01-17     
    #>  3                    2          1 1991-02-24        1995-02-10     
    #>  4                    2          8 1988-08-14        1993-08-05     
    #>  5                    1          7 1952-12-01        1961-03-14     
    #>  6                    1         10 1993-08-21        1996-09-23     
    #>  7                    1          9 1934-06-14        1935-10-28     
    #>  8                    1          4 1982-07-22        1984-06-09     
    #>  9                    1          3 1909-05-22        1917-07-04     
    #> 10                    1          6 1977-01-06        1977-07-07     
    #> # ℹ 1 more variable: date_of_death <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addDeathDays.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add days to death for individuals. Only death within the same observation period than `indexDate` will be observed.

Source: [`R/addDeath.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDeath.R)

`addDeathDays.Rd`

Add days to death for individuals. Only death within the same observation period than `indexDate` will be observed.

## Usage
    
    
    addDeathDays(
      x,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      deathDaysName = "days_to_death",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the window origin.

censorDate
    

Name of a column to stop followup.

window
    

window to consider events over.

deathDaysName
    

name of the new column to be added.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table x with the added column with death information added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDeathDays()
    #> # Source:   table<og_099_1752077923> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          5 1971-10-31        1984-10-02     
    #>  2                    1          6 1993-02-18        1994-05-24     
    #>  3                    1          7 1992-03-08        1997-10-05     
    #>  4                    3         10 1952-08-12        1955-11-26     
    #>  5                    1          9 1965-07-21        1966-11-18     
    #>  6                    2          8 1910-10-08        1927-04-22     
    #>  7                    3          4 1951-08-01        1955-01-19     
    #>  8                    2          1 1935-02-23        1937-10-23     
    #>  9                    3          3 1924-08-03        1934-08-09     
    #> 10                    2          2 1966-01-07        1966-12-08     
    #> # ℹ 1 more variable: days_to_death <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addDeathFlag.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add flag for death for individuals. Only death within the same observation period than `indexDate` will be observed.

Source: [`R/addDeath.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDeath.R)

`addDeathFlag.Rd`

Add flag for death for individuals. Only death within the same observation period than `indexDate` will be observed.

## Usage
    
    
    addDeathFlag(
      x,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      deathFlagName = "death",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the window origin.

censorDate
    

Name of a column to stop followup.

window
    

window to consider events over.

deathFlagName
    

name of the new column to be added.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table x with the added column with death information added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDeathFlag()
    #> # Source:   table<og_105_1752077925> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date death
    #>                   <int>      <int> <date>            <date>          <dbl>
    #>  1                    1          3 1975-02-22        1986-08-28          0
    #>  2                    2          5 1981-09-20        1993-07-16          0
    #>  3                    1          9 1941-03-20        1953-09-03          0
    #>  4                    2          4 1960-11-27        1964-07-15          0
    #>  5                    3          7 1920-11-23        1920-12-30          0
    #>  6                    2          8 1963-07-17        1964-02-16          0
    #>  7                    2         10 1962-10-12        1976-12-01          0
    #>  8                    3          6 1955-09-30        1965-03-06          0
    #>  9                    1          2 1953-12-21        1958-11-17          0
    #> 10                    1          1 2009-07-18        2016-12-13          0
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addConceptIntersectCount.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates column to indicate the count overlap information between a table and a concept

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectCount.Rd`

It creates column to indicate the count overlap information between a table and a concept

## Usage
    
    
    addConceptIntersectCount(
      x,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetStartDate = "event_start_date",
      targetEndDate = "event_end_date",
      inObservation = TRUE,
      nameStyle = "{concept_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

conceptSet
    

Concept set list.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a date column of x

window
    

window to consider events in.

targetStartDate
    

Event start date to use for the intersection.

targetEndDate
    

Event end date to use for the intersection.

inObservation
    

If TRUE only records inside an observation period will be considered.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with overlap information

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    concept <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = [c](https://rdrr.io/r/base/c.html)(1125315),
      domain_id = "Drug",
      vocabulary_id = NA_character_,
      concept_class_id = "Ingredient",
      standard_concept = "S",
      concept_code = NA_character_,
      valid_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
      valid_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2099-01-01"),
      invalid_reason = NA_character_
    ) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(concept_name = [paste0](https://rdrr.io/r/base/paste.html)("concept: ", .data$concept_id))
    cdm <- CDMConnector::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "concept", concept)
    
    cdm$cohort1 |>
      addConceptIntersectCount(conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315))
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_039_1752077897> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1974-12-08        1976-09-22     
    #>  2                    1          4 1917-06-20        1930-10-24     
    #>  3                    3          3 1921-09-19        1924-01-07     
    #>  4                    1          1 1954-02-08        1997-09-25     
    #>  5                    1          8 2002-01-02        2005-01-26     
    #>  6                    1          7 1903-07-20        1907-03-21     
    #>  7                    3          2 1961-01-02        1968-03-22     
    #>  8                    3         10 1983-10-05        1986-12-08     
    #>  9                    3          5 1962-10-29        1965-11-10     
    #> 10                    2          9 1956-11-03        1957-01-08     
    #> # ℹ 1 more variable: acetaminophen_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addConceptIntersectDate.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates column to indicate the date overlap information between a table and a concept

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectDate.Rd`

It creates column to indicate the date overlap information between a table and a concept

## Usage
    
    
    addConceptIntersectDate(
      x,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = "event_start_date",
      order = "first",
      inObservation = TRUE,
      nameStyle = "{concept_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

conceptSet
    

Concept set list.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a date column of x

window
    

window to consider events in.

targetDate
    

Event date to use for the intersection.

order
    

last or first date to use for date/days calculations.

inObservation
    

If TRUE only records inside an observation period will be considered.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with overlap information

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    concept <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = [c](https://rdrr.io/r/base/c.html)(1125315),
      domain_id = "Drug",
      vocabulary_id = NA_character_,
      concept_class_id = "Ingredient",
      standard_concept = "S",
      concept_code = NA_character_,
      valid_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
      valid_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2099-01-01"),
      invalid_reason = NA_character_
    ) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(concept_name = [paste0](https://rdrr.io/r/base/paste.html)("concept: ", .data$concept_id))
    cdm <- CDMConnector::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "concept", concept)
    
    cdm$cohort1 |>
      addConceptIntersectDate(conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315))
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_052_1752077901> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          8 2015-07-04        2016-07-05     
    #>  2                    2          2 1954-12-27        1988-12-04     
    #>  3                    3          7 1949-04-10        1992-01-21     
    #>  4                    2         10 2006-01-13        2009-11-18     
    #>  5                    1          4 1978-07-14        1995-03-14     
    #>  6                    1          1 1951-04-24        1951-06-25     
    #>  7                    1          9 1935-07-29        1950-08-08     
    #>  8                    1          3 1946-05-04        1951-12-29     
    #>  9                    2          6 1930-07-04        1947-10-09     
    #> 10                    3          5 1976-08-29        1981-12-03     
    #> # ℹ 1 more variable: acetaminophen_0_to_inf <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addConceptIntersectDays.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates column to indicate the days of difference from an index date to a concept

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectDays.Rd`

It creates column to indicate the days of difference from an index date to a concept

## Usage
    
    
    addConceptIntersectDays(
      x,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = "event_start_date",
      order = "first",
      inObservation = TRUE,
      nameStyle = "{concept_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

conceptSet
    

Concept set list.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a date column of x

window
    

window to consider events in.

targetDate
    

Event date to use for the intersection.

order
    

last or first date to use for date/days calculations.

inObservation
    

If TRUE only records inside an observation period will be considered.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with overlap information

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    concept <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = [c](https://rdrr.io/r/base/c.html)(1125315),
      domain_id = "Drug",
      vocabulary_id = NA_character_,
      concept_class_id = "Ingredient",
      standard_concept = "S",
      concept_code = NA_character_,
      valid_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
      valid_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2099-01-01"),
      invalid_reason = NA_character_
    ) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(concept_name = [paste0](https://rdrr.io/r/base/paste.html)("concept: ", .data$concept_id))
    cdm <- CDMConnector::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "concept", concept)
    
    cdm$cohort1 |>
      addConceptIntersectDays(conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315))
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_062_1752077904> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          7 1994-04-10        2001-11-07     
    #>  2                    2          9 1929-02-13        1940-06-25     
    #>  3                    1          8 1965-10-03        1967-11-21     
    #>  4                    3          5 1965-12-17        1967-04-28     
    #>  5                    2         10 1938-10-09        1953-06-22     
    #>  6                    2          2 1944-07-27        1945-11-03     
    #>  7                    1          3 1960-04-15        1966-10-06     
    #>  8                    2          6 1970-08-02        1972-05-14     
    #>  9                    2          4 1960-04-16        1962-06-15     
    #> 10                    2          1 1942-08-04        1944-01-25     
    #> # ℹ 1 more variable: acetaminophen_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addConceptIntersectField.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It adds a custom column (field) from the intersection with a certain table subsetted by concept id. In general it is used to add the first value of a certain measurement.

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectField.Rd`

It adds a custom column (field) from the intersection with a certain table subsetted by concept id. In general it is used to add the first value of a certain measurement.

## Usage
    
    
    addConceptIntersectField(
      x,
      conceptSet,
      field,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = "event_start_date",
      order = "first",
      inObservation = TRUE,
      allowDuplicates = FALSE,
      nameStyle = "{field}_{concept_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

conceptSet
    

Concept set list.

field
    

Column in the standard omop table that you want to add.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

Whether to censor overlap events at a date column of x

window
    

Window to consider events in.

targetDate
    

Event date to use for the intersection.

order
    

'last' or 'first' to refer to which event consider if multiple events are present in the same window.

inObservation
    

If TRUE only records inside an observation period will be considered.

allowDuplicates
    

Whether to allow multiple records with same conceptSet, person_id and targetDate. If switched to TRUE, it can have a different and unpredictable behavior depending on the cdm_source.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

Table with the `field` value obtained from the intersection

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    concept <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = [c](https://rdrr.io/r/base/c.html)(1125315),
      domain_id = "Drug",
      vocabulary_id = NA_character_,
      concept_class_id = "Ingredient",
      standard_concept = "S",
      concept_code = NA_character_,
      valid_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
      valid_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2099-01-01"),
      invalid_reason = NA_character_
    ) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(concept_name = [paste0](https://rdrr.io/r/base/paste.html)("concept: ", .data$concept_id))
    cdm <- CDMConnector::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "concept", concept)
    
    cdm$cohort1 |>
      addConceptIntersectField(
        conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315),
        field = "drug_type_concept_id"
      )
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_072_1752077907> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          8 1941-07-12        1957-05-12     
    #>  2                    2          3 1994-05-22        1997-11-08     
    #>  3                    3          5 1980-09-16        1980-09-21     
    #>  4                    1         10 1949-11-26        1955-08-07     
    #>  5                    2          1 1922-11-21        1923-02-25     
    #>  6                    3          7 1994-07-30        2016-07-22     
    #>  7                    2          4 1995-03-09        1996-04-10     
    #>  8                    1          6 1937-02-06        1937-12-23     
    #>  9                    3          2 1975-12-19        1981-01-05     
    #> 10                    3          9 1990-06-29        1991-06-01     
    #> # ℹ 1 more variable: drug_type_concept_id_acetaminophen_0_to_inf <chr>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addConceptIntersectFlag.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates column to indicate the flag overlap information between a table and a concept

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectFlag.Rd`

It creates column to indicate the flag overlap information between a table and a concept

## Usage
    
    
    addConceptIntersectFlag(
      x,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetStartDate = "event_start_date",
      targetEndDate = "event_end_date",
      inObservation = TRUE,
      nameStyle = "{concept_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

conceptSet
    

Concept set list.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a date column of x

window
    

window to consider events in.

targetStartDate
    

Event start date to use for the intersection.

targetEndDate
    

Event end date to use for the intersection.

inObservation
    

If TRUE only records inside an observation period will be considered.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with overlap information

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    concept <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = [c](https://rdrr.io/r/base/c.html)(1125315),
      domain_id = "Drug",
      vocabulary_id = NA_character_,
      concept_class_id = "Ingredient",
      standard_concept = "S",
      concept_code = NA_character_,
      valid_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
      valid_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2099-01-01"),
      invalid_reason = NA_character_
    ) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(concept_name = [paste0](https://rdrr.io/r/base/paste.html)("concept: ", .data$concept_id))
    cdm <- CDMConnector::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "concept", concept)
    
    cdm$cohort1 |>
      addConceptIntersectFlag(conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315))
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_082_1752077910> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          2 1916-01-01        1936-02-18     
    #>  2                    2          3 1906-01-21        1916-06-29     
    #>  3                    1          4 1937-07-21        1940-10-11     
    #>  4                    1          7 1934-11-06        1940-05-06     
    #>  5                    3          5 1953-03-27        1986-11-03     
    #>  6                    2          9 1945-05-09        1955-11-24     
    #>  7                    1          6 1972-05-14        1975-05-25     
    #>  8                    2         10 1944-10-15        1949-07-15     
    #>  9                    2          8 1947-12-26        1968-03-18     
    #> 10                    2          1 2030-01-04        2031-09-23     
    #> # ℹ 1 more variable: acetaminophen_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addTableIntersectCount.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute number of intersect with an omop table.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectCount.Rd`

Compute number of intersect with an omop table.

## Usage
    
    
    addTableIntersectCount(
      x,
      tableName,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetStartDate = [startDateColumn](startDateColumn.html)(tableName),
      targetEndDate = [endDateColumn](endDateColumn.html)(tableName),
      inObservation = TRUE,
      nameStyle = "{table_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

tableName
    

Name of the table to intersect with. Options: visit_occurrence, condition_occurrence, drug_exposure, procedure_occurrence, device_exposure, measurement, observation, drug_era, condition_era, specimen, episode.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

window
    

window to consider events in.

targetStartDate
    

Column name with start date for comparison.

targetEndDate
    

Column name with end date for comparison.

inObservation
    

If TRUE only records inside an observation period will be considered.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with intersect information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addTableIntersectCount(tableName = "visit_occurrence")
    #> # Source:   table<og_121_1752077953> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          5 1989-09-06        1991-07-02     
    #>  2                    2          7 1967-02-08        1968-08-01     
    #>  3                    2         10 1979-12-02        2003-08-10     
    #>  4                    2          8 2005-12-29        2015-03-13     
    #>  5                    2          2 1913-02-12        1921-03-10     
    #>  6                    3          4 1980-01-30        1981-04-05     
    #>  7                    3          3 1995-03-24        1998-11-13     
    #>  8                    2          1 1912-07-28        1912-09-17     
    #>  9                    2          6 1946-10-01        1959-05-09     
    #> 10                    2          9 1955-10-31        1956-06-15     
    #> # ℹ 1 more variable: visit_occurrence_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addTableIntersectDate.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute date of intersect with an omop table.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectDate.Rd`

Compute date of intersect with an omop table.

## Usage
    
    
    addTableIntersectDate(
      x,
      tableName,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = [startDateColumn](startDateColumn.html)(tableName),
      inObservation = TRUE,
      order = "first",
      nameStyle = "{table_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

tableName
    

Name of the table to intersect with. Options: visit_occurrence, condition_occurrence, drug_exposure, procedure_occurrence, device_exposure, measurement, observation, drug_era, condition_era, specimen, episode.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

window
    

window to consider events in.

targetDate
    

Target date in tableName.

inObservation
    

If TRUE only records inside an observation period will be considered.

order
    

which record is considered in case of multiple records (only required for date and days options).

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with intersect information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addTableIntersectDate(tableName = "visit_occurrence")
    #> # Source:   table<og_129_1752077955> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          9 1980-05-20        1981-11-17     
    #>  2                    2          2 1926-09-04        1927-12-31     
    #>  3                    2         10 1982-12-16        1983-05-20     
    #>  4                    2          3 1962-05-28        1980-10-16     
    #>  5                    3          4 1923-04-19        1929-01-14     
    #>  6                    1          8 1959-02-03        1966-10-01     
    #>  7                    3          1 1946-08-30        1971-11-30     
    #>  8                    3          6 1977-10-07        1981-03-22     
    #>  9                    3          7 1972-09-13        1973-10-05     
    #> 10                    1          5 1978-07-21        1996-05-05     
    #> # ℹ 1 more variable: visit_occurrence_0_to_inf <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addTableIntersectDays.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute time to intersect with an omop table.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectDays.Rd`

Compute time to intersect with an omop table.

## Usage
    
    
    addTableIntersectDays(
      x,
      tableName,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = [startDateColumn](startDateColumn.html)(tableName),
      inObservation = TRUE,
      order = "first",
      nameStyle = "{table_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

tableName
    

Name of the table to intersect with. Options: visit_occurrence, condition_occurrence, drug_exposure, procedure_occurrence, device_exposure, measurement, observation, drug_era, condition_era, specimen, episode.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

window
    

window to consider events in.

targetDate
    

Target date in tableName.

inObservation
    

If TRUE only records inside an observation period will be considered.

order
    

which record is considered in case of multiple records (only required for date and days options).

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with intersect information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addTableIntersectDays(tableName = "visit_occurrence")
    #> # Source:   table<og_134_1752077958> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          8 1940-06-22        1944-11-10     
    #>  2                    2         10 1929-10-21        1933-01-31     
    #>  3                    1          2 1917-05-04        1926-07-16     
    #>  4                    3          3 1986-05-23        1987-09-06     
    #>  5                    1          4 1965-04-11        1972-01-20     
    #>  6                    2          9 1947-08-23        1952-11-04     
    #>  7                    3          1 1932-06-22        1934-03-12     
    #>  8                    1          5 1924-01-12        1938-04-10     
    #>  9                    1          6 1982-11-05        1984-07-06     
    #> 10                    3          7 1909-08-03        1909-12-21     
    #> # ℹ 1 more variable: visit_occurrence_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addTableIntersectField.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Intersecting the cohort with columns of an OMOP table of user's choice. It will add an extra column to the cohort, indicating the intersected entries with the target columns in a window of the user's choice.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectField.Rd`

Intersecting the cohort with columns of an OMOP table of user's choice. It will add an extra column to the cohort, indicating the intersected entries with the target columns in a window of the user's choice.

## Usage
    
    
    addTableIntersectField(
      x,
      tableName,
      field,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = [startDateColumn](startDateColumn.html)(tableName),
      inObservation = TRUE,
      order = "first",
      allowDuplicates = FALSE,
      nameStyle = "{table_name}_{extra_value}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

tableName
    

Name of the table to intersect with. Options: visit_occurrence, condition_occurrence, drug_exposure, procedure_occurrence, device_exposure, measurement, observation, drug_era, condition_era, specimen, episode.

field
    

The columns from the table in tableName to intersect over. For example, if the user uses visit_occurrence in tableName then for field the possible options include visit_occurrence_id, visit_concept_id, visit_type_concept_id.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

window
    

window to consider events in when intersecting with the chosen column.

targetDate
    

The dates in the target columns in tableName that the user may want to restrict to.

inObservation
    

If TRUE only records inside an observation period will be considered.

order
    

which record is considered in case of multiple records (only required for date and days options).

allowDuplicates
    

Whether to allow multiple records with same conceptSet, person_id and targetDate. If switched to TRUE, it can have a different and unpredictable behavior depending on the cdm_source.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with intersect information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    cdm$cohort1 |>
      addTableIntersectField(
        tableName = "visit_occurrence",
        field = "visit_concept_id",
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1)
      )
    #> # Source:   table<og_139_1752077960> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          3 1913-04-17        1934-09-30     
    #>  2                    1         10 1926-07-09        1932-08-03     
    #>  3                    1          1 1964-04-09        1964-04-28     
    #>  4                    2          5 2006-06-04        2012-04-19     
    #>  5                    1          6 1939-09-12        1939-10-24     
    #>  6                    3          7 1949-08-27        1955-07-15     
    #>  7                    1          2 1994-05-27        1994-11-27     
    #>  8                    2          8 1953-12-12        1956-06-29     
    #>  9                    1          4 1933-11-23        1946-04-22     
    #> 10                    3          9 1953-07-16        1975-08-19     
    #> # ℹ 1 more variable: visit_occurrence_visit_concept_id_minf_to_m1 <int>
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addTableIntersectFlag.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Compute a flag intersect with an omop table.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectFlag.Rd`

Compute a flag intersect with an omop table.

## Usage
    
    
    addTableIntersectFlag(
      x,
      tableName,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetStartDate = [startDateColumn](startDateColumn.html)(tableName),
      targetEndDate = [endDateColumn](endDateColumn.html)(tableName),
      inObservation = TRUE,
      nameStyle = "{table_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

tableName
    

Name of the table to intersect with. Options: visit_occurrence, condition_occurrence, drug_exposure, procedure_occurrence, device_exposure, measurement, observation, drug_era, condition_era, specimen, episode.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

window
    

window to consider events in.

targetStartDate
    

Column name with start date for comparison.

targetEndDate
    

Column name with end date for comparison.

inObservation
    

If TRUE only records inside an observation period will be considered.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with intersect information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addTableIntersectFlag(tableName = "visit_occurrence")
    #> # Source:   table<og_144_1752077963> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          3 1976-05-05        1985-04-10     
    #>  2                    2          4 1938-02-14        1938-04-23     
    #>  3                    2          6 1910-08-21        1911-10-24     
    #>  4                    3          2 1925-02-18        1927-09-16     
    #>  5                    2          7 1937-02-06        1955-03-13     
    #>  6                    3          1 1931-03-25        1932-12-19     
    #>  7                    1          9 1975-05-27        1981-10-23     
    #>  8                    1          5 1967-03-13        1969-11-07     
    #>  9                    1          8 1943-06-02        1943-08-21     
    #> 10                    3         10 1948-01-23        1957-10-30     
    #> # ℹ 1 more variable: visit_occurrence_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addAgeQuery.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Query to add the age of the individuals at a certain date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addAgeQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addAge()`, except query is not computed to a table.

## Usage
    
    
    addAgeQuery(
      x,
      indexDate = "cohort_start_date",
      ageName = "age",
      ageGroup = NULL,
      ageMissingMonth = 1,
      ageMissingDay = 1,
      ageImposeMonth = FALSE,
      ageImposeDay = FALSE,
      missingAgeGroupValue = "None"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the age.

ageName
    

Name of the new column that contains age.

ageGroup
    

List of age groups to be added.

ageMissingMonth
    

Month of the year assigned to individuals with missing month of birth. By default: 1.

ageMissingDay
    

day of the month assigned to individuals with missing day of birth. By default: 1.

ageImposeMonth
    

Whether the month of the date of birth will be considered as missing for all the individuals.

ageImposeDay
    

Whether the day of the date of birth will be considered as missing for all the individuals.

missingAgeGroupValue
    

Value to include if missing age.

## Value

tibble with the age column added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addAgeQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    #>                   <int>      <int> <date>            <date>          <int>
    #>  1                    1          4 1948-11-06        1950-08-02         22
    #>  2                    3          8 1981-05-14        1997-02-24         25
    #>  3                    2         10 1950-10-09        1955-07-29         42
    #>  4                    3          5 1942-07-31        1942-08-29          6
    #>  5                    2          9 1940-07-19        1941-10-31         20
    #>  6                    3          3 1950-03-10        1951-04-15         40
    #>  7                    2          1 1958-01-29        1971-06-15         14
    #>  8                    1          7 1942-09-04        1947-07-28          8
    #>  9                    2          2 1919-02-04        1937-02-18         12
    #> 10                    3          6 1993-07-26        1993-08-05         45
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addDateOfBirthQuery.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Query to add a column with the individual birth date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addDateOfBirthQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addDateOfBirth()`, except query is not computed to a table.

## Usage
    
    
    addDateOfBirthQuery(
      x,
      dateOfBirthName = "date_of_birth",
      missingDay = 1,
      missingMonth = 1,
      imposeDay = FALSE,
      imposeMonth = FALSE
    )

## Arguments

x
    

Table in the cdm that contains 'person_id' or 'subject_id'.

dateOfBirthName
    

Name of the column to be added with the date of birth.

missingDay
    

Day of the individuals with no or imposed day of birth.

missingMonth
    

Month of the individuals with no or imposed month of birth.

imposeDay
    

Whether to impose day of birth.

imposeMonth
    

Whether to impose month of birth.

## Value

The function returns the table x with an extra column that contains the date of birth.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDateOfBirthQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1983-01-30        1988-08-25     
    #>  2                    1          2 1933-10-18        1935-04-25     
    #>  3                    3          3 1943-04-29        1948-02-11     
    #>  4                    2          7 1977-12-29        1980-02-06     
    #>  5                    2          5 1945-08-10        1946-12-12     
    #>  6                    1         10 1938-04-29        1958-05-17     
    #>  7                    2          1 1946-07-01        1952-05-09     
    #>  8                    3          8 1992-11-22        1996-10-29     
    #>  9                    3          4 1983-09-24        1984-02-14     
    #> 10                    3          9 1919-01-22        1933-01-30     
    #> # ℹ 1 more variable: date_of_birth <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addDemographicsQuery.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Query to add demographic characteristics at a certain date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addDemographicsQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addDemographics()`, except query is not computed to a table.

## Usage
    
    
    addDemographicsQuery(
      x,
      indexDate = "cohort_start_date",
      age = TRUE,
      ageName = "age",
      ageMissingMonth = 1,
      ageMissingDay = 1,
      ageImposeMonth = FALSE,
      ageImposeDay = FALSE,
      ageGroup = NULL,
      missingAgeGroupValue = "None",
      sex = TRUE,
      sexName = "sex",
      missingSexValue = "None",
      priorObservation = TRUE,
      priorObservationName = "prior_observation",
      priorObservationType = "days",
      futureObservation = TRUE,
      futureObservationName = "future_observation",
      futureObservationType = "days",
      dateOfBirth = FALSE,
      dateOfBirthName = "date_of_birth"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the demographics characteristics.

age
    

TRUE or FALSE. If TRUE, age will be calculated relative to indexDate.

ageName
    

Age variable name.

ageMissingMonth
    

Month of the year assigned to individuals with missing month of birth.

ageMissingDay
    

day of the month assigned to individuals with missing day of birth.

ageImposeMonth
    

TRUE or FALSE. Whether the month of the date of birth will be considered as missing for all the individuals.

ageImposeDay
    

TRUE or FALSE. Whether the day of the date of birth will be considered as missing for all the individuals.

ageGroup
    

if not NULL, a list of ageGroup vectors.

missingAgeGroupValue
    

Value to include if missing age.

sex
    

TRUE or FALSE. If TRUE, sex will be identified.

sexName
    

Sex variable name.

missingSexValue
    

Value to include if missing sex.

priorObservation
    

TRUE or FALSE. If TRUE, days of between the start of the current observation period and the indexDate will be calculated.

priorObservationName
    

Prior observation variable name.

priorObservationType
    

Whether to return a "date" or the number of "days".

futureObservation
    

TRUE or FALSE. If TRUE, days between the indexDate and the end of the current observation period will be calculated.

futureObservationName
    

Future observation variable name.

futureObservationType
    

Whether to return a "date" or the number of "days".

dateOfBirth
    

TRUE or FALSE, if true the date of birth will be return.

dateOfBirthName
    

dateOfBirth column name.

## Value

cohort table with the added demographic information columns.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDemographicsQuery()
    #> # Source:   SQL [?? x 8]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age sex  
    #>                   <int>      <int> <date>            <date>          <int> <chr>
    #>  1                    3          1 1947-10-16        1960-06-03          0 Male 
    #>  2                    3          2 1912-02-15        1919-08-29          8 Male 
    #>  3                    2          3 1962-10-15        1962-11-03         30 Male 
    #>  4                    1          4 1956-10-16        1966-09-14          8 Male 
    #>  5                    1          5 1951-07-26        1973-09-17          4 Male 
    #>  6                    1          6 1977-10-28        1989-09-22          6 Fema…
    #>  7                    3          7 1925-09-09        1930-06-29          3 Male 
    #>  8                    3          8 1953-04-23        1954-06-20         39 Fema…
    #>  9                    1          9 1971-12-11        1980-08-17          4 Male 
    #> 10                    2         10 1978-06-15        1998-04-29         16 Male 
    #> # ℹ 2 more variables: prior_observation <int>, future_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addFutureObservationQuery.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Query to add the number of days till the end of the observation period at a certain date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addFutureObservationQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addFutureObservation()`, except query is not computed to a table.

## Usage
    
    
    addFutureObservationQuery(
      x,
      indexDate = "cohort_start_date",
      futureObservationName = "future_observation",
      futureObservationType = "days"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the future observation.

futureObservationName
    

name of the new column to be added.

futureObservationType
    

Whether to return a "date" or the number of "days".

## Value

cohort table with added column containing future observation of the individuals.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addFutureObservationQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          1 1977-08-29        1982-12-01     
    #>  2                    1         10 1980-04-24        1986-02-12     
    #>  3                    3          5 1914-09-24        1929-12-27     
    #>  4                    3          6 1997-06-03        1998-06-16     
    #>  5                    1          7 1913-12-24        1919-07-31     
    #>  6                    1          3 1972-04-24        1972-10-03     
    #>  7                    3          4 1947-11-14        1957-07-09     
    #>  8                    1          2 1918-10-13        1920-10-21     
    #>  9                    1          8 1938-09-11        1953-11-12     
    #> 10                    2          9 1927-05-18        1930-03-22     
    #> # ℹ 1 more variable: future_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addInObservationQuery.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Query to add a new column to indicate if a certain record is within the observation period

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addInObservationQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addInObservation()`, except query is not computed to a table.

## Usage
    
    
    addInObservationQuery(
      x,
      indexDate = "cohort_start_date",
      window = [c](https://rdrr.io/r/base/c.html)(0, 0),
      completeInterval = FALSE,
      nameStyle = "in_observation"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the observation flag.

window
    

window to consider events of.

completeInterval
    

If the individuals are in observation for the full window.

nameStyle
    

Name of the new columns to create, it must contain "window_name" if multiple windows are provided.

## Value

cohort table with the added binary column assessing inObservation.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addInObservationQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2         10 1913-10-17        1913-12-18     
    #>  2                    1          5 1969-02-28        1986-01-18     
    #>  3                    1          4 1931-10-22        1932-06-30     
    #>  4                    2          8 1985-11-25        1986-05-21     
    #>  5                    3          6 1937-05-01        1947-08-11     
    #>  6                    3          7 1923-02-14        1930-02-19     
    #>  7                    2          1 1931-04-11        1963-07-28     
    #>  8                    3          9 2002-04-11        2002-05-07     
    #>  9                    2          2 1975-07-18        1984-09-14     
    #> 10                    2          3 1929-09-27        1937-04-29     
    #> # ℹ 1 more variable: in_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addObservationPeriodIdQuery.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add the ordinal number of the observation period associated that a given date is in. Result is not computed, only query is added.

Source: [`R/addObservationPeriodId.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addObservationPeriodId.R)

`addObservationPeriodIdQuery.Rd`

Add the ordinal number of the observation period associated that a given date is in. Result is not computed, only query is added.

## Usage
    
    
    addObservationPeriodIdQuery(
      x,
      indexDate = "cohort_start_date",
      nameObservationPeriodId = "observation_period_id"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the observation flag.

nameObservationPeriodId
    

Name of the new column.

## Value

Table with the current observation period id added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addObservationPeriodIdQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          9 1959-03-12        1959-05-03     
    #>  2                    3          8 1946-07-31        1947-03-27     
    #>  3                    3          7 1964-05-08        1989-12-19     
    #>  4                    2          3 1996-06-03        2004-07-12     
    #>  5                    1          2 1996-03-22        2006-12-16     
    #>  6                    2          4 1973-12-10        1986-11-03     
    #>  7                    1          6 1999-04-26        2010-12-01     
    #>  8                    1          5 1953-06-05        1963-12-28     
    #>  9                    1          1 2028-05-21        2029-12-02     
    #> 10                    2         10 1940-04-20        1940-06-18     
    #> # ℹ 1 more variable: observation_period_id <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addPriorObservationQuery.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Query to add the number of days of prior observation in the current observation period at a certain date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addPriorObservationQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addPriorObservation()`, except query is not computed to a table.

## Usage
    
    
    addPriorObservationQuery(
      x,
      indexDate = "cohort_start_date",
      priorObservationName = "prior_observation",
      priorObservationType = "days"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the prior observation.

priorObservationName
    

name of the new column to be added.

priorObservationType
    

Whether to return a "date" or the number of "days".

## Value

cohort table with added column containing prior observation of the individuals.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addPriorObservationQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 1988-07-02        1988-07-15     
    #>  2                    1          7 1986-01-19        1995-05-19     
    #>  3                    3          8 1955-12-28        1956-08-19     
    #>  4                    2          1 1958-01-08        1961-06-04     
    #>  5                    2         10 1935-02-08        1940-12-14     
    #>  6                    1          5 1994-04-17        2012-05-29     
    #>  7                    3          6 1917-11-19        1919-09-11     
    #>  8                    2          3 1944-03-02        1944-06-22     
    #>  9                    2          2 1911-07-06        1954-07-06     
    #> 10                    3          9 2004-06-11        2012-02-06     
    #> # ℹ 1 more variable: prior_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addSexQuery.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Query to add the sex of the individuals

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addSexQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addSex()`, except query is not computed to a table.

## Usage
    
    
    addSexQuery(x, sexName = "sex", missingSexValue = "None")

## Arguments

x
    

Table with individuals in the cdm.

sexName
    

name of the new column to be added.

missingSexValue
    

Value to include if missing sex.

## Value

table x with the added column with sex information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addSexQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date sex   
    #>                   <int>      <int> <date>            <date>          <chr> 
    #>  1                    1          1 1986-09-24        1989-08-06      Female
    #>  2                    3          2 1925-05-20        1927-02-09      Female
    #>  3                    2          3 1985-01-21        1986-09-24      Female
    #>  4                    3          4 1935-06-18        1951-07-26      Female
    #>  5                    1          5 1969-08-15        1975-09-22      Male  
    #>  6                    2          6 1935-01-10        1942-08-07      Female
    #>  7                    1          7 1970-12-07        1971-03-12      Female
    #>  8                    1          8 1965-01-10        1985-11-04      Female
    #>  9                    1          9 1952-06-02        1954-12-07      Female
    #> 10                    2         10 1956-01-29        1958-08-21      Female
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/summariseResult.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Summarise variables using a set of estimate functions. The output will be a formatted summarised_result object.

Source: [`R/summariseResult.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/summariseResult.R)

`summariseResult.Rd`

Summarise variables using a set of estimate functions. The output will be a formatted summarised_result object.

## Usage
    
    
    summariseResult(
      table,
      group = [list](https://rdrr.io/r/base/list.html)(),
      includeOverallGroup = FALSE,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      includeOverallStrata = TRUE,
      variables = NULL,
      estimates = [c](https://rdrr.io/r/base/c.html)("min", "q25", "median", "q75", "max", "count", "percentage"),
      counts = TRUE,
      weights = NULL
    )

## Arguments

table
    

Table with different records.

group
    

List of groups to be considered.

includeOverallGroup
    

TRUE or FALSE. If TRUE, results for an overall group will be reported when a list of groups has been specified.

strata
    

List of the stratifications within each group to be considered.

includeOverallStrata
    

TRUE or FALSE. If TRUE, results for an overall strata will be reported when a list of strata has been specified.

variables
    

Variables to summarise, it can be a list to point to different set of estimate names.

estimates
    

Estimates to obtain, it can be a list to point to different set of variables.

counts
    

Whether to compute number of records and number of subjects.

weights
    

Name of the column in the table that contains the weights to be used when measuring the estimates.

## Value

A summarised_result object with the summarised data of interest.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    x <- cdm$cohort1 |>
      [addDemographics](addDemographics.html)() |>
      [collect](https://dplyr.tidyverse.org/reference/compute.html)()
    result <- summariseResult(x)
    #> ℹ The following estimates will be computed:
    #> • cohort_start_date: min, q25, median, q75, max
    #> • cohort_end_date: min, q25, median, q75, max
    #> • age: min, q25, median, q75, max
    #> • sex: count, percentage
    #> • prior_observation: min, q25, median, q75, max
    #> • future_observation: min, q25, median, q75, max
    #> ! Table is collected to memory as not all requested estimates are supported on
    #>   the database side
    #> → Start summary of data, at 2025-07-09 16:19:29.719281
    #> ✔ Summary finished, at 2025-07-09 16:19:29.836414
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/reexports.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Objects exported from other packages

Source: [`R/reexports-omopgenerics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/reexports-omopgenerics.R)

`reexports.Rd`

These objects are imported from other packages. Follow the links below to see their documentation.

omopgenerics
    

`[settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)`, `[suppress](https://darwin-eu.github.io/omopgenerics/reference/suppress.html)`

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/benchmarkPatientProfiles.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Benchmark intersections and demographics functions for a certain source (cdm).

Source: [`R/benchmarkPatientProfiles.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/benchmarkPatientProfiles.R)

`benchmarkPatientProfiles.Rd`

Benchmark intersections and demographics functions for a certain source (cdm).

## Usage
    
    
    benchmarkPatientProfiles(cdm, n = 50000, iterations = 1)

## Arguments

cdm
    

A cdm_reference object.

n
    

Size of the synthetic cohorts used to benchmark.

iterations
    

Number of iterations to run the benchmark.

## Value

A summarise_result object with the summary statistics.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addCohortName.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add cohort name for each cohort_definition_id

Source: [`R/utilities.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/utilities.R)

`addCohortName.Rd`

Add cohort name for each cohort_definition_id

## Usage
    
    
    addCohortName(cohort)

## Arguments

cohort
    

cohort to which add the cohort name

## Value

cohort with an extra column with the cohort names

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    cdm$cohort1 |>
      addCohortName()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date cohort_name
    #>                   <int>      <int> <date>            <date>          <chr>      
    #>  1                    2          6 1962-05-15        1980-12-24      cohort_2   
    #>  2                    3          5 1940-09-14        1954-11-21      cohort_3   
    #>  3                    2          7 1971-01-26        1975-08-12      cohort_2   
    #>  4                    3          1 1948-10-20        1966-10-26      cohort_3   
    #>  5                    1          3 1957-10-29        1962-07-29      cohort_1   
    #>  6                    2         10 1974-12-24        1976-07-06      cohort_2   
    #>  7                    1          8 1991-08-31        1991-10-03      cohort_1   
    #>  8                    1          4 1923-05-31        1931-06-08      cohort_1   
    #>  9                    3          2 1935-08-08        1937-09-14      cohort_3   
    #> 10                    1          9 1962-01-21        1971-12-16      cohort_1   
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addConceptName.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add concept name for each concept_id

Source: [`R/utilities.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/utilities.R)

`addConceptName.Rd`

Add concept name for each concept_id

## Usage
    
    
    addConceptName(table, column = NULL, nameStyle = "{column}_name")

## Arguments

table
    

cdm_table that contains column.

column
    

Column to add the concept names from. If NULL any column that its name ends with `concept_id` will be used.

nameStyle
    

Name of the new column.

## Value

table with an extra column with the concept names.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    dbName <- "GiBleed"
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)(datasetName = dbName)
    #> ℹ `EUNOMIA_DATA_FOLDER` set to: /tmp/Rtmpx4JqXS.
    #> 
    #> Download completed!
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)(datasetName = dbName)))
    #> Creating CDM database /tmp/Rtmpx4JqXS/GiBleed_5.3.zip
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    cdm$drug_exposure |>
      addConceptName(column = "drug_concept_id", nameStyle = "drug_name") |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 24
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpx4JqXS/file21f1526b7d68.duckdb]
    #> $ drug_exposure_id             <int> 26318, 60926, 26418, 54785, 47027, 38712,…
    #> $ person_id                    <int> 573, 1332, 576, 4550, 3895, 3199, 476, 11…
    #> $ drug_concept_id              <int> 40213160, 40213198, 40213260, 1118084, 40…
    #> $ drug_exposure_start_date     <date> 1960-04-09, 2010-10-06, 2017-10-25, 2000…
    #> $ drug_exposure_start_datetime <dttm> 1960-04-09, 2010-10-06, 2017-10-25, 2000…
    #> $ drug_exposure_end_date       <date> 1960-04-09, 2010-10-06, 2017-10-25, 2000…
    #> $ drug_exposure_end_datetime   <dttm> 1960-04-09, 2010-10-06, 2017-10-25, 2000…
    #> $ verbatim_end_date            <date> 1960-04-09, 2010-10-06, 2017-10-25, NA, …
    #> $ drug_type_concept_id         <int> 581452, 581452, 581452, 38000177, 3800017…
    #> $ stop_reason                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ refills                      <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ quantity                     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ days_supply                  <int> 0, 0, 0, 0, 0, 14, 0, 0, 0, 60, 14, 28, 7…
    #> $ sig                          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ route_concept_id             <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ lot_number                   <chr> "0", "0", "0", "0", "0", "0", "0", "0", "…
    #> $ provider_id                  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ visit_occurrence_id          <int> 38004, 88400, 38145, 303185, 259023, 2127…
    #> $ visit_detail_id              <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ drug_source_value            <chr> "10", "133", "121", "00025152531", "85700…
    #> $ drug_source_concept_id       <int> 40213160, 40213198, 40213260, 44923712, 4…
    #> $ route_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ dose_unit_source_value       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ drug_name                    <chr> "poliovirus vaccine, inactivated", "pneum…
    
    cdm$drug_exposure |>
      addConceptName() |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 27
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpx4JqXS/file21f1526b7d68.duckdb]
    #> $ drug_exposure_id             <int> 26318, 60926, 26418, 54785, 47027, 38712,…
    #> $ person_id                    <int> 573, 1332, 576, 4550, 3895, 3199, 476, 11…
    #> $ drug_concept_id              <int> 40213160, 40213198, 40213260, 1118084, 40…
    #> $ drug_exposure_start_date     <date> 1960-04-09, 2010-10-06, 2017-10-25, 2000…
    #> $ drug_exposure_start_datetime <dttm> 1960-04-09, 2010-10-06, 2017-10-25, 2000…
    #> $ drug_exposure_end_date       <date> 1960-04-09, 2010-10-06, 2017-10-25, 2000…
    #> $ drug_exposure_end_datetime   <dttm> 1960-04-09, 2010-10-06, 2017-10-25, 2000…
    #> $ verbatim_end_date            <date> 1960-04-09, 2010-10-06, 2017-10-25, NA, …
    #> $ drug_type_concept_id         <int> 581452, 581452, 581452, 38000177, 3800017…
    #> $ stop_reason                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ refills                      <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ quantity                     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ days_supply                  <int> 0, 0, 0, 0, 0, 14, 0, 0, 0, 60, 14, 28, 7…
    #> $ sig                          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ route_concept_id             <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ lot_number                   <chr> "0", "0", "0", "0", "0", "0", "0", "0", "…
    #> $ provider_id                  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ visit_occurrence_id          <int> 38004, 88400, 38145, 303185, 259023, 2127…
    #> $ visit_detail_id              <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ drug_source_value            <chr> "10", "133", "121", "00025152531", "85700…
    #> $ drug_source_concept_id       <int> 40213160, 40213198, 40213260, 44923712, 4…
    #> $ route_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ dose_unit_source_value       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ drug_concept_id_name         <chr> "poliovirus vaccine, inactivated", "pneum…
    #> $ drug_type_concept_id_name    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ route_concept_id_name        <chr> "No matching concept", "No matching conce…
    #> $ drug_source_concept_id_name  <chr> "poliovirus vaccine, inactivated", "pneum…
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addCdmName.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add cdm name

Source: [`R/utilities.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/utilities.R)

`addCdmName.Rd`

Add cdm name

## Usage
    
    
    addCdmName(table, cdm = omopgenerics::[cdmReference](https://darwin-eu.github.io/omopgenerics/reference/cdmReference.html)(table))

## Arguments

table
    

Table in the cdm

cdm
    

A cdm reference object

## Value

Table with an extra column with the cdm names

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    cdm$cohort1 |>
      addCdmName()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date cdm_name
    #>                   <int>      <int> <date>            <date>          <chr>   
    #>  1                    3          2 1990-03-24        1993-07-05      PP_MOCK 
    #>  2                    3          4 1967-11-12        1983-07-03      PP_MOCK 
    #>  3                    3          6 1923-10-05        1925-11-21      PP_MOCK 
    #>  4                    2          5 1999-03-19        2003-07-23      PP_MOCK 
    #>  5                    3          7 1935-01-04        1937-03-15      PP_MOCK 
    #>  6                    1          1 1966-02-19        1968-05-07      PP_MOCK 
    #>  7                    2          9 1967-08-05        1983-06-26      PP_MOCK 
    #>  8                    3          8 1948-10-22        1951-08-05      PP_MOCK 
    #>  9                    3          3 1956-02-20        1962-06-23      PP_MOCK 
    #> 10                    1         10 2016-10-06        2024-12-11      PP_MOCK 
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addCategories.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Categorize a numeric variable

Source: [`R/addCategories.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCategories.R)

`addCategories.Rd`

Categorize a numeric variable

## Usage
    
    
    addCategories(
      x,
      variable,
      categories,
      missingCategoryValue = "None",
      overlap = FALSE,
      includeLowerBound = TRUE,
      includeUpperBound = TRUE,
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

variable
    

Target variable that we want to categorize.

categories
    

List of lists of named categories with lower and upper limit.

missingCategoryValue
    

Value to assign to those individuals not in any named category. If NULL or NA, missing values will not be changed.

overlap
    

TRUE if the categories given overlap.

includeLowerBound
    

Whether to include the lower bound in the group.

includeUpperBound
    

Whether to include the upper bound in the group.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

The x table with the categorical variable added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    result <- cdm$cohort1 |>
      [addAge](addAge.html)() |>
      addCategories(
        variable = "age",
        categories = [list](https://rdrr.io/r/base/list.html)("age_group" = [list](https://rdrr.io/r/base/list.html)(
          "0 to 39" = [c](https://rdrr.io/r/base/c.html)(0, 39), "40 to 79" = [c](https://rdrr.io/r/base/c.html)(40, 79), "80 to 150" = [c](https://rdrr.io/r/base/c.html)(80, 150)
        ))
      )
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/addObservationPeriodId.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Add the ordinal number of the observation period associated that a given date is in.

Source: [`R/addObservationPeriodId.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addObservationPeriodId.R)

`addObservationPeriodId.Rd`

Add the ordinal number of the observation period associated that a given date is in.

## Usage
    
    
    addObservationPeriodId(
      x,
      indexDate = "cohort_start_date",
      nameObservationPeriodId = "observation_period_id",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the observation flag.

nameObservationPeriodId
    

Name of the new column.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

Table with the current observation period id added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addObservationPeriodId()
    #> # Source:   table<og_118_1752077941> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 1970-05-25        1974-04-12     
    #>  2                    1          2 1961-08-10        1992-12-26     
    #>  3                    1          6 1943-11-08        1955-09-30     
    #>  4                    2         10 1986-09-04        1993-07-04     
    #>  5                    3          1 1998-03-29        1998-04-24     
    #>  6                    3          5 1944-06-16        1946-01-18     
    #>  7                    2          8 1929-07-09        1930-04-11     
    #>  8                    1          9 1982-10-04        1983-04-21     
    #>  9                    2          3 1929-08-19        1936-05-01     
    #> 10                    1          7 1966-02-28        1967-01-22     
    #> # ℹ 1 more variable: observation_period_id <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/filterCohortId.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Filter a cohort according to cohort_definition_id column, the result is not computed into a table. only a query is added. Used usually as internal functions of other packages.

Source: [`R/filterCohortId.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/filterCohortId.R)

`filterCohortId.Rd`

Filter a cohort according to cohort_definition_id column, the result is not computed into a table. only a query is added. Used usually as internal functions of other packages.

## Usage
    
    
    filterCohortId(cohort, cohortId = NULL)

## Arguments

cohort
    

A `cohort_table` object.

cohortId
    

A vector with cohort ids.

## Value

A `cohort_table` object.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/filterInObservation.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Filter the rows of a `cdm_table` to the ones in observation that `indexDate` is in observation.

Source: [`R/filterInObservation.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/filterInObservation.R)

`filterInObservation.Rd`

Filter the rows of a `cdm_table` to the ones in observation that `indexDate` is in observation.

## Usage
    
    
    filterInObservation(x, indexDate)

## Arguments

x
    

A `cdm_table` object.

indexDate
    

Name of a column of x that is a date.

## Value

A `cdm_table` that is a subset of the original table.

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- duckdb::dbConnect(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchema = "main", writeSchema = "main"
    )
    
    cdm$condition_occurrence |>
      filterInObservation(indexDate = "condition_start_date") |>
      dplyr::[compute](https://dplyr.tidyverse.org/reference/compute.html)()
    } # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/variableTypes.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Classify the variables between 5 types: "numeric", "categorical", "binary", "date", or NA.

Source: [`R/formats.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/formats.R)

`variableTypes.Rd`

Classify the variables between 5 types: "numeric", "categorical", "binary", "date", or NA.

## Usage
    
    
    variableTypes(table)

## Arguments

table
    

Tibble.

## Value

Tibble with the variables type and classification.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = [c](https://rdrr.io/r/base/c.html)(1, 2),
      start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-05-02", "2021-11-19")),
      asthma = [c](https://rdrr.io/r/base/c.html)(0, 1)
    )
    variableTypes(x)
    #> # A tibble: 3 × 2
    #>   variable_name variable_type
    #>   <chr>         <chr>        
    #> 1 person_id     numeric      
    #> 2 start_date    date         
    #> 3 asthma        numeric      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/availableEstimates.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Show the available estimates that can be used for the different variable_type supported.

Source: [`R/formats.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/formats.R)

`availableEstimates.Rd`

Show the available estimates that can be used for the different variable_type supported.

## Usage
    
    
    availableEstimates(variableType = NULL, fullQuantiles = FALSE)

## Arguments

variableType
    

A set of variable types.

fullQuantiles
    

Whether to display the exact quantiles that can be computed or only the qXX to summarise all of them.

## Value

A tibble with the available estimates.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    availableEstimates()
    #> # A tibble: 37 × 4
    #>    variable_type estimate_name      estimate_description           estimate_type
    #>    <chr>         <chr>              <chr>                          <chr>        
    #>  1 date          mean               mean of the variable of inter… date         
    #>  2 date          sd                 standard deviation of the var… date         
    #>  3 date          median             median of the variable of int… date         
    #>  4 date          qXX                qualtile of XX% the variable … date         
    #>  5 date          min                minimum of the variable of in… date         
    #>  6 date          max                maximum of the variable of in… date         
    #>  7 date          count_missing      number of missing values.      integer      
    #>  8 date          percentage_missing percentage of missing values   percentage   
    #>  9 numeric       sum                sum of all the values for the… numeric      
    #> 10 numeric       mean               mean of the variable of inter… numeric      
    #> # ℹ 27 more rows
    availableEstimates("numeric")
    #> # A tibble: 12 × 4
    #>    variable_type estimate_name      estimate_description           estimate_type
    #>    <chr>         <chr>              <chr>                          <chr>        
    #>  1 numeric       sum                sum of all the values for the… numeric      
    #>  2 numeric       mean               mean of the variable of inter… numeric      
    #>  3 numeric       sd                 standard deviation of the var… numeric      
    #>  4 numeric       median             median of the variable of int… numeric      
    #>  5 numeric       qXX                qualtile of XX% the variable … numeric      
    #>  6 numeric       min                minimum of the variable of in… numeric      
    #>  7 numeric       max                maximum of the variable of in… numeric      
    #>  8 numeric       count_missing      number of missing values.      integer      
    #>  9 numeric       percentage_missing percentage of missing values   percentage   
    #> 10 numeric       count              count number of `1`.           integer      
    #> 11 numeric       percentage         percentage of occurrences of … percentage   
    #> 12 numeric       density            density distribution           multiple     
    availableEstimates([c](https://rdrr.io/r/base/c.html)("numeric", "categorical"))
    #> # A tibble: 14 × 4
    #>    variable_type estimate_name      estimate_description           estimate_type
    #>    <chr>         <chr>              <chr>                          <chr>        
    #>  1 numeric       sum                sum of all the values for the… numeric      
    #>  2 numeric       mean               mean of the variable of inter… numeric      
    #>  3 numeric       sd                 standard deviation of the var… numeric      
    #>  4 numeric       median             median of the variable of int… numeric      
    #>  5 numeric       qXX                qualtile of XX% the variable … numeric      
    #>  6 numeric       min                minimum of the variable of in… numeric      
    #>  7 numeric       max                maximum of the variable of in… numeric      
    #>  8 numeric       count_missing      number of missing values.      integer      
    #>  9 numeric       percentage_missing percentage of missing values   percentage   
    #> 10 numeric       count              count number of `1`.           integer      
    #> 11 numeric       percentage         percentage of occurrences of … percentage   
    #> 12 categorical   count              number of times that each cat… integer      
    #> 13 categorical   percentage         percentage of individuals wit… percentage   
    #> 14 numeric       density            density distribution           multiple     
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/startDateColumn.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Get the name of the start date column for a certain table in the cdm

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addIntersect.R)

`startDateColumn.Rd`

Get the name of the start date column for a certain table in the cdm

## Usage
    
    
    startDateColumn(tableName)

## Arguments

tableName
    

Name of the table.

## Value

Name of the start date column in that table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    startDateColumn("condition_occurrence")
    #> [1] "condition_start_date"
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/endDateColumn.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Get the name of the end date column for a certain table in the cdm

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addIntersect.R)

`endDateColumn.Rd`

Get the name of the end date column for a certain table in the cdm

## Usage
    
    
    endDateColumn(tableName)

## Arguments

tableName
    

Name of the table.

## Value

Name of the end date column in that table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    endDateColumn("condition_occurrence")
    #> [1] "condition_end_date"
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/sourceConceptIdColumn.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Get the name of the source concept_id column for a certain table in the cdm

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addIntersect.R)

`sourceConceptIdColumn.Rd`

Get the name of the source concept_id column for a certain table in the cdm

## Usage
    
    
    sourceConceptIdColumn(tableName)

## Arguments

tableName
    

Name of the table.

## Value

Name of the source_concept_id column in that table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    sourceConceptIdColumn("condition_occurrence")
    #> [1] "condition_source_concept_id"
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/PatientProfiles/reference/standardConceptIdColumn.html

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Get the name of the standard concept_id column for a certain table in the cdm

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addIntersect.R)

`standardConceptIdColumn.Rd`

Get the name of the standard concept_id column for a certain table in the cdm

## Usage
    
    
    standardConceptIdColumn(tableName)

## Arguments

tableName
    

Name of the table.

## Value

Name of the concept_id column in that table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    standardConceptIdColumn("condition_occurrence")
    #> [1] "condition_concept_id"
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
