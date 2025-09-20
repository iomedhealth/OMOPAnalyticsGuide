# Content from https://darwin-eu.github.io/IncidencePrevalence/


---

## Content from https://darwin-eu.github.io/IncidencePrevalence/

Skip to contents

[IncidencePrevalence](index.html) 1.2.1

  * [Reference](reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](articles/a07_benchmark.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](logo.png)

# IncidencePrevalence 

[![CRANstatus](https://www.r-pkg.org/badges/version/IncidencePrevalence)](https://CRAN.R-project.org/package=IncidencePrevalence) [![codecov.io](https://codecov.io/github/darwin-eu/IncidencePrevalence/coverage.svg?branch=main)](https://app.codecov.io/github/darwin-eu/IncidencePrevalence?branch=main) [![R-CMD-check](https://github.com/darwin-eu/IncidencePrevalence/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/IncidencePrevalence/actions) [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

## Package overview

IncidencePrevalence contains functions for estimating population-level incidence and prevalence using the OMOP common data model. For more information on the package please see our paper in Pharmacoepidemiology and Drug Safety.

> Raventós, B, Català, M, Du, M, et al. IncidencePrevalence: An R package to calculate population-level incidence rates and prevalence using the OMOP common data model. Pharmacoepidemiol Drug Saf. 2023; 1-11. doi: 10.1002/pds.5717

If you find the package useful in supporting your research study, please consider citing this paper.

## Package installation

You can install the latest version of IncidencePrevalence from CRAN:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("IncidencePrevalence")

Or from github:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("remotes")
    remotes::install_github("darwin-eu/IncidencePrevalence")

## Example usage

### Create a reference to data in the OMOP CDM format

The IncidencePrevalence package is designed to work with data in the OMOP CDM format, so our first step is to create a reference to the data using the CDMConnector package.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))

Creating a connection to a Postgres database would for example look like:
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(RPostgres::[Postgres](https://rpostgres.r-dbi.org/reference/Postgres.html)(),
      dbname = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_DBNAME"),
      host = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_HOST"),
      user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_USER"),
      password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_PASSWORD")
    )
    
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con,
      cdmSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_CDM_SCHEMA"),
      writeSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_RESULT_SCHEMA")
    )

To see how you would create a reference to your database please consult the CDMConnector package documentation. For this example though we´ll work with simulated data, and we’ll generate an example cdm reference like so:
    
    
    cdm <- [mockIncidencePrevalence](reference/mockIncidencePrevalence.html)(
      sampleSize = 10000,
      outPre = 0.3,
      minOutcomeDays = 365,
      maxOutcomeDays = 3650
    )

### Identify a denominator cohort

To identify a set of denominator cohorts we can use the `generateDenominatorCohortSet` function. Here we want to identify denominator populations for a study period between 2008 and 2018 and with 180 days of prior history (observation time in the database). We also wish to consider multiple age groups (from 0 to 64, and 65 to 100) and multiple sex criteria (one cohort only males, one only females, and one with both sexes included).
    
    
    cdm <- [generateDenominatorCohortSet](reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2008-01-01", "2018-01-01")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 64),
        [c](https://rdrr.io/r/base/c.html)(65, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = 180
    )

This will then give us six denominator cohorts
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)
    #> # A tibble: 6 × 11
    #>   cohort_definition_id cohort_name        age_group sex   days_prior_observation
    #>                  <int> <chr>              <chr>     <chr>                  <dbl>
    #> 1                    1 denominator_cohor… 0 to 64   Male                     180
    #> 2                    2 denominator_cohor… 0 to 64   Fema…                    180
    #> 3                    3 denominator_cohor… 0 to 64   Both                     180
    #> 4                    4 denominator_cohor… 65 to 100 Male                     180
    #> 5                    5 denominator_cohor… 65 to 100 Fema…                    180
    #> 6                    6 denominator_cohor… 65 to 100 Both                     180
    #> # ℹ 6 more variables: start_date <date>, end_date <date>,
    #> #   requirements_at_entry <chr>, target_cohort_definition_id <int>,
    #> #   target_cohort_name <chr>, time_at_risk <chr>

These cohorts will be in the typical OMOP CDM structure
    
    
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2-dev13 [eburn@Windows 10 x64:R 4.2.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         87 2008-01-01        2018-01-01     
    #>  2                    1        116 2008-01-01        2009-01-10     
    #>  3                    1        204 2008-01-01        2009-12-05     
    #>  4                    1        271 2008-01-01        2008-02-06     
    #>  5                    1        371 2008-01-01        2011-04-23     
    #>  6                    1        390 2010-04-14        2013-03-29     
    #>  7                    1        480 2008-01-01        2015-12-27     
    #>  8                    1        526 2008-01-01        2008-03-12     
    #>  9                    1        555 2010-03-24        2017-12-09     
    #> 10                    1        567 2008-01-01        2011-04-23     
    #> # ℹ more rows

### Estimating incidence and prevalence

As well as a denominator cohort, an outcome cohort will need to be identified. Defining outcome cohorts is done outside of the IncdidencePrevalence package and our mock data already includes an outcome cohort.
    
    
    cdm$outcome
    #> # Source:   table<outcome> [?? x 4]
    #> # Database: DuckDB v1.3.2-dev13 [eburn@Windows 10 x64:R 4.2.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 1991-07-21        1991-12-05     
    #>  2                    1          3 1996-08-23        1999-03-13     
    #>  3                    1          9 1934-05-01        1939-09-20     
    #>  4                    1         10 1994-06-16        1994-12-01     
    #>  5                    1         13 1963-01-20        1969-02-06     
    #>  6                    1         15 1901-01-28        1904-08-02     
    #>  7                    1         16 2002-05-01        2006-07-26     
    #>  8                    1         21 1913-07-19        1915-03-10     
    #>  9                    1         29 1926-04-01        1928-01-18     
    #> 10                    1         30 1919-07-17        1919-07-30     
    #> # ℹ more rows

Now we have identified our denominator population, we can calculate incidence and prevalence as below. Note, in our example cdm reference we already have an outcome cohort defined.

For this example we´ll estimate incidence on a yearly basis, allowing individuals to have multiple events but with an outcome washout of 180 days. We also require that only complete database intervals are included, by which we mean that the database must have individuals observed throughout a year for that year to be included in the analysis. Note, we also specify a minimum cell count of 5, under which estimates will be obscured.
    
    
    inc <- [estimateIncidence](reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      repeatedEvents = TRUE,
      outcomeWashout = 180,
      completeDatabaseIntervals = TRUE
    )
    [plotIncidence](reference/plotIncidence.html)(inc, facet = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"))

![](reference/figures/README-unnamed-chunk-11-1.png)

We could also estimate point prevalence, as of the start of each calendar year like so:
    
    
    prev_point <- [estimatePointPrevalence](reference/estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      timePoint = "start"
    )
    [plotPrevalence](reference/plotPrevalence.html)(prev_point, facet = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"))

![](reference/figures/README-unnamed-chunk-12-1.png)

And annual period prevalence where we again require complete database intervals and, in addition, only include those people who are observed in the data for the full year:
    
    
    prev_period <- [estimatePeriodPrevalence](reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      completeDatabaseIntervals = TRUE,
      fullContribution = TRUE
    )
    [plotPrevalence](reference/plotPrevalence.html)(prev_period, facet = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"))

![](reference/figures/README-unnamed-chunk-13-1.png)

## Links

  * [View on CRAN](https://cloud.r-project.org/package=IncidencePrevalence)
  * [Browse source code](https://github.com/darwin-eu/IncidencePrevalence/)
  * [Report a bug](https://github.com/darwin-eu/IncidencePrevalence/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Community

  * [Contributing guide](CONTRIBUTING.html)



## Citation

  * [Citing IncidencePrevalence](authors.html#citation)



## Developers

  * Edward Burn   
Author, maintainer  [](https://orcid.org/0000-0002-9286-1128)
  * Berta Raventos   
Author  [](https://orcid.org/0000-0002-4668-2970)
  * Martí Català   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * [More about authors...](authors.html)



Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/index.html

Skip to contents

[IncidencePrevalence](index.html) 1.2.1

  * [Reference](reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](articles/a07_benchmark.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](logo.png)

# IncidencePrevalence 

[![CRANstatus](https://www.r-pkg.org/badges/version/IncidencePrevalence)](https://CRAN.R-project.org/package=IncidencePrevalence) [![codecov.io](https://codecov.io/github/darwin-eu/IncidencePrevalence/coverage.svg?branch=main)](https://app.codecov.io/github/darwin-eu/IncidencePrevalence?branch=main) [![R-CMD-check](https://github.com/darwin-eu/IncidencePrevalence/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/IncidencePrevalence/actions) [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

## Package overview

IncidencePrevalence contains functions for estimating population-level incidence and prevalence using the OMOP common data model. For more information on the package please see our paper in Pharmacoepidemiology and Drug Safety.

> Raventós, B, Català, M, Du, M, et al. IncidencePrevalence: An R package to calculate population-level incidence rates and prevalence using the OMOP common data model. Pharmacoepidemiol Drug Saf. 2023; 1-11. doi: 10.1002/pds.5717

If you find the package useful in supporting your research study, please consider citing this paper.

## Package installation

You can install the latest version of IncidencePrevalence from CRAN:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("IncidencePrevalence")

Or from github:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("remotes")
    remotes::install_github("darwin-eu/IncidencePrevalence")

## Example usage

### Create a reference to data in the OMOP CDM format

The IncidencePrevalence package is designed to work with data in the OMOP CDM format, so our first step is to create a reference to the data using the CDMConnector package.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))

Creating a connection to a Postgres database would for example look like:
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(RPostgres::[Postgres](https://rpostgres.r-dbi.org/reference/Postgres.html)(),
      dbname = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_DBNAME"),
      host = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_HOST"),
      user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_USER"),
      password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_PASSWORD")
    )
    
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con,
      cdmSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_CDM_SCHEMA"),
      writeSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_RESULT_SCHEMA")
    )

To see how you would create a reference to your database please consult the CDMConnector package documentation. For this example though we´ll work with simulated data, and we’ll generate an example cdm reference like so:
    
    
    cdm <- [mockIncidencePrevalence](reference/mockIncidencePrevalence.html)(
      sampleSize = 10000,
      outPre = 0.3,
      minOutcomeDays = 365,
      maxOutcomeDays = 3650
    )

### Identify a denominator cohort

To identify a set of denominator cohorts we can use the `generateDenominatorCohortSet` function. Here we want to identify denominator populations for a study period between 2008 and 2018 and with 180 days of prior history (observation time in the database). We also wish to consider multiple age groups (from 0 to 64, and 65 to 100) and multiple sex criteria (one cohort only males, one only females, and one with both sexes included).
    
    
    cdm <- [generateDenominatorCohortSet](reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2008-01-01", "2018-01-01")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 64),
        [c](https://rdrr.io/r/base/c.html)(65, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = 180
    )

This will then give us six denominator cohorts
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)
    #> # A tibble: 6 × 11
    #>   cohort_definition_id cohort_name        age_group sex   days_prior_observation
    #>                  <int> <chr>              <chr>     <chr>                  <dbl>
    #> 1                    1 denominator_cohor… 0 to 64   Male                     180
    #> 2                    2 denominator_cohor… 0 to 64   Fema…                    180
    #> 3                    3 denominator_cohor… 0 to 64   Both                     180
    #> 4                    4 denominator_cohor… 65 to 100 Male                     180
    #> 5                    5 denominator_cohor… 65 to 100 Fema…                    180
    #> 6                    6 denominator_cohor… 65 to 100 Both                     180
    #> # ℹ 6 more variables: start_date <date>, end_date <date>,
    #> #   requirements_at_entry <chr>, target_cohort_definition_id <int>,
    #> #   target_cohort_name <chr>, time_at_risk <chr>

These cohorts will be in the typical OMOP CDM structure
    
    
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2-dev13 [eburn@Windows 10 x64:R 4.2.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         87 2008-01-01        2018-01-01     
    #>  2                    1        116 2008-01-01        2009-01-10     
    #>  3                    1        204 2008-01-01        2009-12-05     
    #>  4                    1        271 2008-01-01        2008-02-06     
    #>  5                    1        371 2008-01-01        2011-04-23     
    #>  6                    1        390 2010-04-14        2013-03-29     
    #>  7                    1        480 2008-01-01        2015-12-27     
    #>  8                    1        526 2008-01-01        2008-03-12     
    #>  9                    1        555 2010-03-24        2017-12-09     
    #> 10                    1        567 2008-01-01        2011-04-23     
    #> # ℹ more rows

### Estimating incidence and prevalence

As well as a denominator cohort, an outcome cohort will need to be identified. Defining outcome cohorts is done outside of the IncdidencePrevalence package and our mock data already includes an outcome cohort.
    
    
    cdm$outcome
    #> # Source:   table<outcome> [?? x 4]
    #> # Database: DuckDB v1.3.2-dev13 [eburn@Windows 10 x64:R 4.2.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 1991-07-21        1991-12-05     
    #>  2                    1          3 1996-08-23        1999-03-13     
    #>  3                    1          9 1934-05-01        1939-09-20     
    #>  4                    1         10 1994-06-16        1994-12-01     
    #>  5                    1         13 1963-01-20        1969-02-06     
    #>  6                    1         15 1901-01-28        1904-08-02     
    #>  7                    1         16 2002-05-01        2006-07-26     
    #>  8                    1         21 1913-07-19        1915-03-10     
    #>  9                    1         29 1926-04-01        1928-01-18     
    #> 10                    1         30 1919-07-17        1919-07-30     
    #> # ℹ more rows

Now we have identified our denominator population, we can calculate incidence and prevalence as below. Note, in our example cdm reference we already have an outcome cohort defined.

For this example we´ll estimate incidence on a yearly basis, allowing individuals to have multiple events but with an outcome washout of 180 days. We also require that only complete database intervals are included, by which we mean that the database must have individuals observed throughout a year for that year to be included in the analysis. Note, we also specify a minimum cell count of 5, under which estimates will be obscured.
    
    
    inc <- [estimateIncidence](reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      repeatedEvents = TRUE,
      outcomeWashout = 180,
      completeDatabaseIntervals = TRUE
    )
    [plotIncidence](reference/plotIncidence.html)(inc, facet = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"))

![](reference/figures/README-unnamed-chunk-11-1.png)

We could also estimate point prevalence, as of the start of each calendar year like so:
    
    
    prev_point <- [estimatePointPrevalence](reference/estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      timePoint = "start"
    )
    [plotPrevalence](reference/plotPrevalence.html)(prev_point, facet = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"))

![](reference/figures/README-unnamed-chunk-12-1.png)

And annual period prevalence where we again require complete database intervals and, in addition, only include those people who are observed in the data for the full year:
    
    
    prev_period <- [estimatePeriodPrevalence](reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      completeDatabaseIntervals = TRUE,
      fullContribution = TRUE
    )
    [plotPrevalence](reference/plotPrevalence.html)(prev_period, facet = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"))

![](reference/figures/README-unnamed-chunk-13-1.png)

## Links

  * [View on CRAN](https://cloud.r-project.org/package=IncidencePrevalence)
  * [Browse source code](https://github.com/darwin-eu/IncidencePrevalence/)
  * [Report a bug](https://github.com/darwin-eu/IncidencePrevalence/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Community

  * [Contributing guide](CONTRIBUTING.html)



## Citation

  * [Citing IncidencePrevalence](authors.html#citation)



## Developers

  * Edward Burn   
Author, maintainer  [](https://orcid.org/0000-0002-9286-1128)
  * Berta Raventos   
Author  [](https://orcid.org/0000-0002-4668-2970)
  * Martí Català   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * [More about authors...](authors.html)



Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/index.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Package index

### Build denominator cohorts

`[generateDenominatorCohortSet()](generateDenominatorCohortSet.html)`
    Identify a set of denominator populations

`[generateTargetDenominatorCohortSet()](generateTargetDenominatorCohortSet.html)`
    Identify a set of denominator populations using a target cohort

### Estimate incidence rates

`[estimateIncidence()](estimateIncidence.html)`
    Collect population incidence estimates

### Estimate point and period prevalence

`[estimatePeriodPrevalence()](estimatePeriodPrevalence.html)`
    Estimate period prevalence

`[estimatePointPrevalence()](estimatePointPrevalence.html)`
    Estimate point prevalence

### Tidy results

`[asIncidenceResult()](asIncidenceResult.html)`
    A tidy implementation of the summarised_result object for incidence results.

`[asPrevalenceResult()](asPrevalenceResult.html)`
    A tidy implementation of the summarised_result object for prevalence results.

### Plot results

`[availableIncidenceGrouping()](availableIncidenceGrouping.html)`
    Variables that can be used for faceting and colouring incidence plots

`[availablePrevalenceGrouping()](availablePrevalenceGrouping.html)`
    Variables that can be used for faceting and colouring prevalence plots

`[plotIncidence()](plotIncidence.html)`
    Plot incidence results

`[plotIncidencePopulation()](plotIncidencePopulation.html)`
    Bar plot of denominator counts, outcome counts, and person-time from incidence results

`[plotPrevalence()](plotPrevalence.html)`
    Plot prevalence results

`[plotPrevalencePopulation()](plotPrevalencePopulation.html)`
    Bar plot of denominator and outcome counts from prevalence results

### Tabulate results

`[optionsTableIncidence()](optionsTableIncidence.html)`
    Additional arguments for the functions tableIncidence.

`[optionsTablePrevalence()](optionsTablePrevalence.html)`
    Additional arguments for the functions tablePrevalence.

`[tableIncidence()](tableIncidence.html)`
    Table of incidence results

`[tableIncidenceAttrition()](tableIncidenceAttrition.html)`
    Table of incidence attrition results

`[tablePrevalence()](tablePrevalence.html)`
    Table of prevalence results

`[tablePrevalenceAttrition()](tablePrevalenceAttrition.html)`
    Table of prevalence attrition results

### Mock data

`[mockIncidencePrevalence()](mockIncidencePrevalence.html)`
    Generate example subset of the OMOP CDM for estimating incidence and prevalence

### Benchmark package

`[IncidencePrevalenceBenchmarkResults](IncidencePrevalenceBenchmarkResults.html)`
    Benchmarking results

`[benchmarkIncidencePrevalence()](benchmarkIncidencePrevalence.html)`
    Run benchmark of incidence and prevalence analyses

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/articles/a01_Introduction_to_IncidencePrevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Introduction to IncidencePrevalence

Source: [`vignettes/a01_Introduction_to_IncidencePrevalence.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a01_Introduction_to_IncidencePrevalence.Rmd)

`a01_Introduction_to_IncidencePrevalence.Rmd`

To do a study of incidence and prevalence, the analytics functions from this package that you would interact with are

  1. `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` and `[generateTargetDenominatorCohortSet()](../reference/generateTargetDenominatorCohortSet.html)` \- these function will identify a set of denominator populations from the database population as a whole, the former, or based on individuals in a target cohort, the latter

  2. `[estimatePointPrevalence()](../reference/estimatePointPrevalence.html)` and `[estimatePeriodPrevalence()](../reference/estimatePeriodPrevalence.html)` \- these function will estimate point and period prevalence for outcomes among denominator populations

  3. `[estimateIncidence()](../reference/estimateIncidence.html)` \- this function will estimate incidence rates for outcomes among denominator populations




Below, we show an example analysis to provide an broad overview of how this functionality provided by the IncidencePrevalence package can be used. More context and further examples for each of these functions are provided in later vignettes.

First, let’s load relevant libraries.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

The IncidencePrevalence package works with data mapped to the OMOP CDM and we will first need to connect to a database, after which we can use the CDMConnector package to represent our mapped data as a cdm reference. For this example though we´ll use a synthetic cdm reference containing 50,000 hypothetical patients which we create using the `[mockIncidencePrevalence()](../reference/mockIncidencePrevalence.html)` function.
    
    
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(
      sampleSize = 50000,
      outPre = 0.2
    )

This example data already includes an outcome cohort.
    
    
    cdm$outcome [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()

Once we have a cdm reference, we can use the `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` to identify a denominator cohort to use later when calculating incidence and prevalence. In this case we identify three denominator cohorts one with males, one with females, and one with both males and females included. For each of these cohorts only those aged between 18 and 65 from 2008 to 2012, and who had 365 days of prior history available are included.
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2012-01-01")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(18, 65)),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = 365
    )

We can see that each of our denominator cohorts is in the format of an OMOP CDM cohort:
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 59, 89, 126, 136, 156, 200, 208, 261, 501, 533, 5…
    #> $ cohort_start_date    <date> 2008-06-24, 2008-01-01, 2008-01-01, 2008-01-01, …
    #> $ cohort_end_date      <date> 2012-01-01, 2009-08-06, 2010-05-29, 2010-02-18, …

We can also see the settings associated with each cohort:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)
    #> # A tibble: 3 × 11
    #>   cohort_definition_id cohort_name        age_group sex   days_prior_observation
    #>                  <int> <chr>              <chr>     <chr>                  <dbl>
    #> 1                    1 denominator_cohor… 18 to 65  Male                     365
    #> 2                    2 denominator_cohor… 18 to 65  Fema…                    365
    #> 3                    3 denominator_cohor… 18 to 65  Both                     365
    #> # ℹ 6 more variables: start_date <date>, end_date <date>,
    #> #   requirements_at_entry <chr>, target_cohort_definition_id <int>,
    #> #   target_cohort_name <chr>, time_at_risk <chr>

And we can also see the count for each cohort
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           1139            1139
    #> 2                    2           1068            1068
    #> 3                    3           2207            2207

Now that we have our denominator cohorts, and using the outcome cohort that was also generated by the `[mockIncidencePrevalence()](../reference/mockIncidencePrevalence.html)` function, we can estimate prevalence for each using the `[estimatePointPrevalence()](../reference/estimatePointPrevalence.html)` function. Here we calculate point prevalence on a yearly basis.
    
    
    prev <- [estimatePeriodPrevalence](../reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "quarters"
    )
    
    prev [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 380
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_3 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Outcome", "Outcome", "Outc…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "prevalence", "…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "1420", "9", "0.00634", "0.00334", "0.012", "1417", "…
    #> $ additional_name  <chr> "prevalence_start_date &&& prevalence_end_date &&& an…
    #> $ additional_level <chr> "2008-01-01 &&& 2008-03-31 &&& quarters", "2008-01-01…

![](a01_Introduction_to_IncidencePrevalence_files/figure-html/unnamed-chunk-10-1.png)

Similarly we can use the `[estimateIncidence()](../reference/estimateIncidence.html)` function to estimate incidence rates. Here we annual incidence rates, with 180 days used for outcome washout windows.
    
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = [c](https://rdrr.io/r/base/c.html)("Years"),
      outcomeWashout = 180
    )
    
    inc [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 224
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_3 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "1634", "43", "487065", "1333.511", "3224.57", "2333.…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "2008-01-01 &&& 2008-12-31 &&& years", "2008-01-01 &&…

![](a01_Introduction_to_IncidencePrevalence_files/figure-html/unnamed-chunk-12-1.png)

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/articles/a02_Creating_denominator_populations.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Creating denominator cohorts

Source: [`vignettes/a02_Creating_denominator_populations.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a02_Creating_denominator_populations.Rmd)

`a02_Creating_denominator_populations.Rmd`

## Introduction

Calculating incidence or prevalence requires first identifying an appropriate denominator population. To find such a denominator population (or multiple denominator populations) we can use the `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` function. This function will identify the time that people in the database satisfy a set of criteria related to the study period and individuals´ age, sex, and amount of prior observed history.

When using `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` individuals will enter a denominator population on the respective date of the latest of the following:

  1. Study start date
  2. Date at which they have sufficient prior observation
  3. Date at which they reach a minimum age



They will then exit on the respective date of the earliest of the following:

  1. Study end date
  2. Date at which their observation period ends
  3. The last day in which they have the maximum age



Let´s go through a few examples to make this logic a little more concrete.

#### No specific requirements

The simplest case is that no study start and end dates are specified, no prior history requirement is imposed, nor any age or sex criteria. In this case individuals will enter the denominator population once they have entered the database (start of observation period) and will leave when they exit the database (end of observation period). Note that in some databases a person can have multiple observation periods, in which case their contribution of person time would look like the the last person below.

![](dpop1.png)

#### Specified study period

If we specify a study start and end date then only observation time during this period will be included.

![](dpop2.png)

#### Specified study period and prior history requirement

If we also add some requirement of prior history then somebody will only contribute time at risk once this is reached.

![](dpop3.png)

#### Specified study period, prior history requirement, and age and sex criteria

Lastly we can also impose age and sex criteria, and now individuals will only contribute time when they also satisfy these criteria. Not shown in the below figure is a person´s sex, but we could also stratify a denominator population by this as well.

![](dpop4.png)

## Using generateDenominatorCohortSet()

`[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` is the function we use to identify a set of denominator populations. To demonstrate its use, let´s load the IncidencePrevalence package (along with a couple of packages to help for subsequent plots) and generate 500 example patients using the `[mockIncidencePrevalence()](../reference/mockIncidencePrevalence.html)` function.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(sampleSize = 500)

#### No specific requirements

We can get a denominator population without including any particular requirements like so
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA)),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0
    )
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 1974-04-03        1982-01-16     
    #>  2                    1          6 1990-10-30        1996-06-28     
    #>  3                    1          7 1995-10-09        1997-02-28     
    #>  4                    1          9 1984-04-14        1989-04-07     
    #>  5                    1         11 2004-04-10        2012-09-24     
    #>  6                    1         12 2004-11-14        2007-04-29     
    #>  7                    1         13 2000-06-29        2004-06-13     
    #>  8                    1         15 1995-03-27        2005-09-01     
    #>  9                    1         16 2009-02-24        2011-09-29     
    #> 10                    1         17 2003-04-03        2006-01-26     
    #> # ℹ more rows
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"))
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          4 1974-04-03        1982-01-16

Let´s have a look at the included time of the first five patients. We can see that people enter and leave at different times.

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-9-1.png)

We can also plot a histogram of start and end dates of the 500 simulated patients
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(cohort_start_date),
        colour = "black", fill = "grey"
      )

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-10-1.png)
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(cohort_end_date),
        colour = "black", fill = "grey"
      )

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-11-1.png)

#### Specified study period

We can get specify a study period like so
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0
    )
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1990-10-30        1996-06-28     
    #>  2                    1          7 1995-10-09        1997-02-28     
    #>  3                    1         11 2004-04-10        2009-12-31     
    #>  4                    1         12 2004-11-14        2007-04-29     
    #>  5                    1         13 2000-06-29        2004-06-13     
    #>  6                    1         15 1995-03-27        2005-09-01     
    #>  7                    1         16 2009-02-24        2009-12-31     
    #>  8                    1         17 2003-04-03        2006-01-26     
    #>  9                    1         21 1991-11-16        2000-05-05     
    #> 10                    1         28 2005-11-16        2007-03-12     
    #> # ℹ more rows
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             97              97
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"))
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>

Now we can see that many more people share the same cohort entry (the study start date) and cohort exit (the study end date).
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(cohort_start_date),
        colour = "black", fill = "grey"
      )

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-13-1.png)
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(cohort_end_date),
        colour = "black", fill = "grey"
      )

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-14-1.png)

#### Specified study period and prior history requirement

We can add some requirement of prior history
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 365
    )
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1991-10-30        1996-06-28     
    #>  2                    1          7 1996-10-08        1997-02-28     
    #>  3                    1         11 2005-04-10        2009-12-31     
    #>  4                    1         12 2005-11-14        2007-04-29     
    #>  5                    1         13 2001-06-29        2004-06-13     
    #>  6                    1         15 1996-03-26        2005-09-01     
    #>  7                    1         17 2004-04-02        2006-01-26     
    #>  8                    1         21 1992-11-15        2000-05-05     
    #>  9                    1         28 2006-11-16        2007-03-12     
    #> 10                    1         35 1990-01-01        1991-07-05     
    #> # ℹ more rows
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             85              85
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"))
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>

#### Specified study period, prior history requirement, and age and sex criteria

In addition to all the above we could also add some requirements around age and sex. One thing to note is that the age upper limit will include time from a person up to the day before their reach the age upper limit + 1 year. For instance, when the upper limit is 65, that means we will include time from a person up to and including the day before their 66th birthday.
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(18, 65)),
      sex = "Female",
      daysPriorObservation = 365
    )
    cdm$denominator [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 6, 7, 21, 41, 62, 72, 79, 115, 122, 142, 163, 197…
    #> $ cohort_start_date    <date> 1991-10-30, 1996-10-08, 1992-11-15, 1991-11-22, …
    #> $ cohort_end_date      <date> 1996-06-28, 1997-02-28, 2000-05-05, 1992-10-13, …
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             27              27
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"))
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>

#### Multiple options to return multiple denominator populations

More than one age, sex and prior history requirements can be specified at the same time. First, we can take a look at having two age groups. We can see below that those individuals who have their 41st birthday during the study period will go from the first cohort (age_group: 0;40) to the second (age_group: 41;100) on this day.
    
    
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(
      sampleSize = 500,
      earliestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      latestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-01-01"),
      minDaysToObservationEnd = 10000,
      maxDaysToObservationEnd = NULL,
      earliestDateOfBirth = [as.Date](https://rdrr.io/r/base/as.Date.html)("1960-01-01"),
      latestDateOfBirth = [as.Date](https://rdrr.io/r/base/as.Date.html)("1980-01-01")
    )
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 40),
        [c](https://rdrr.io/r/base/c.html)(41, 100)
      ),
      sex = "Both",
      daysPriorObservation = 0
    )
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) !![as.character](https://rdrr.io/r/base/character.html)([seq](https://rdrr.io/r/base/seq.html)(1:30))) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)([settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator),
        by = "cohort_definition_id"
      ) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(subject_id = [factor](https://rdrr.io/r/base/factor.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id))) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = subject_id, y = value, colour = age_group)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(
        legend.position = "top",
        legend.title = [element_blank](https://ggplot2.tidyverse.org/reference/element.html)()
      ) +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Year") +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-17-1.png)

We can then also sex specific denominator cohorts.
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 40),
        [c](https://rdrr.io/r/base/c.html)(41, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = 0
    )
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) !![as.character](https://rdrr.io/r/base/character.html)([seq](https://rdrr.io/r/base/seq.html)(1:15))) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)([settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(subject_id = [factor](https://rdrr.io/r/base/factor.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id))) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = subject_id, y = value, colour = age_group)) +
      [facet_grid](https://ggplot2.tidyverse.org/reference/facet_grid.html)(sex ~ ., space = "free_y") +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(
        legend.position = "top",
        legend.title = [element_blank](https://ggplot2.tidyverse.org/reference/element.html)()
      ) +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Year") +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-18-1.png)

And we could also specifying multiple prior history requirements
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 40),
        [c](https://rdrr.io/r/base/c.html)(41, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = [c](https://rdrr.io/r/base/c.html)(0, 365)
    )
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) !![as.character](https://rdrr.io/r/base/character.html)([seq](https://rdrr.io/r/base/seq.html)(1:8))) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)([settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(subject_id = [factor](https://rdrr.io/r/base/factor.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id))) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(
        x = subject_id, y = value, colour = age_group,
        linetype = sex, shape = sex
      )) +
      [facet_grid](https://ggplot2.tidyverse.org/reference/facet_grid.html)(sex + days_prior_observation ~ .,
        space = "free",
        scales = "free"
      ) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(legend.position = "top") +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Year") +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-19-1.png)

Note, setting requirementInteractions to FALSE would mean that only the first value of other age, sex, and prior history requirements are considered for a given characteristic. In this case the order of the values will be important and generally the first values will be the primary analysis settings while subsequent values are for secondary analyses.
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 40),
        [c](https://rdrr.io/r/base/c.html)(41, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = [c](https://rdrr.io/r/base/c.html)(0, 365),
      requirementInteractions = FALSE
    )
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) !![as.character](https://rdrr.io/r/base/character.html)([seq](https://rdrr.io/r/base/seq.html)(1:8))) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)([settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(subject_id = [factor](https://rdrr.io/r/base/factor.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id))) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(
        x = subject_id, y = value, colour = age_group,
        linetype = sex, shape = sex
      )) +
      [facet_grid](https://ggplot2.tidyverse.org/reference/facet_grid.html)(sex + days_prior_observation ~ .,
        space = "free",
        scales = "free"
      ) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(legend.position = "top") +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Year") +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-20-1.png)

#### Output

`[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` will generate a table with the denominator population, which includes the information on all the individuals who fulfill the given criteria at any point during the study period. It also includes information on the specific start and end dates in which individuals contributed to the denominator population (cohort_start_date and cohort_end_date). Each patient is recorded in a different row. For those databases that allow individuals to have multiple non-overlapping observation periods, one row for each patient and observation period is considered.

Considering the following example, we can see:
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 18),
        [c](https://rdrr.io/r/base/c.html)(19, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female"),
      daysPriorObservation = [c](https://rdrr.io/r/base/c.html)(0, 365)
    )
    
    [head](https://rdrr.io/r/utils/head.html)(cdm$denominator, 8)
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    5          2 2004-12-15        2009-12-31     
    #> 2                    5          3 2004-09-24        2009-12-31     
    #> 3                    5          4 2002-06-22        2009-12-31     
    #> 4                    5          5 2001-05-11        2009-12-31     
    #> 5                    5          9 2004-02-27        2009-12-31     
    #> 6                    5         10 2000-01-18        2009-12-31     
    #> 7                    5         12 2004-10-21        2009-12-31     
    #> 8                    5         13 2000-06-29        2009-12-31

The output table will have several attributes. With `[settings()](https://darwin-eu.github.io/omopgenerics/reference/settings.html)` we can see the options used when defining the set of denominator populations. More than one age, sex and prior history requirements can be specified at the same time and each combination of these variables will result in a different cohort, each of which has a corresponding cohort_definition_id. In the above example, we identified 8 different cohorts:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator) [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 8
    #> Columns: 11
    #> $ cohort_definition_id        <int> 1, 2, 3, 4, 5, 6, 7, 8
    #> $ cohort_name                 <chr> "denominator_cohort_1", "denominator_cohor…
    #> $ age_group                   <chr> "0 to 18", "0 to 18", "0 to 18", "0 to 18"…
    #> $ sex                         <chr> "Male", "Male", "Female", "Female", "Male"…
    #> $ days_prior_observation      <dbl> 0, 365, 0, 365, 0, 365, 0, 365
    #> $ start_date                  <date> 1990-01-01, 1990-01-01, 1990-01-01, 1990-0…
    #> $ end_date                    <date> 2009-12-31, 2009-12-31, 2009-12-31, 2009-1…
    #> $ requirements_at_entry       <chr> "FALSE", "FALSE", "FALSE", "FALSE", "FALS…
    #> $ target_cohort_definition_id <int> NA, NA, NA, NA, NA, NA, NA, NA
    #> $ target_cohort_name          <chr> "None", "None", "None", "None", "None", "…
    #> $ time_at_risk                <chr> "0 to Inf", "0 to Inf", "0 to Inf", "0 to …

With `[cohortCount()](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)` we can see the number of individuals who entered each study cohort
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator) [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 8
    #> Columns: 3
    #> $ cohort_definition_id <int> 1, 2, 3, 4, 5, 6, 7, 8
    #> $ number_records       <int> 0, 0, 0, 0, 233, 233, 267, 267
    #> $ number_subjects      <int> 0, 0, 0, 0, 233, 233, 267, 267

With `[attrition()](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)` we can see the number of individuals in the database who were excluded from entering a given denominator population along with the reason (such as missing crucial information or not satisfying the sex or age criteria required, among others):
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$denominator) [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 72
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2…
    #> $ number_records       <int> 500, 500, 500, 500, 500, 500, 500, 233, 0, 500, 5…
    #> $ number_subjects      <int> 500, 500, 500, 500, 500, 500, 500, 233, 0, 500, 5…
    #> $ reason_id            <int> 1, 2, 3, 4, 5, 6, 7, 8, 10, 1, 2, 3, 4, 5, 6, 7, …
    #> $ reason               <chr> "Starting population", "Missing year of birth", "…
    #> $ excluded_records     <int> NA, 0, 0, 0, 0, 0, 0, 267, 233, NA, 0, 0, 0, 0, 0…
    #> $ excluded_subjects    <int> NA, 0, 0, 0, 0, 0, 0, 267, 233, NA, 0, 0, 0, 0, 0…

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/articles/a03_Creating_target_denominator_populations.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Creating target denominator populations

Source: [`vignettes/a03_Creating_target_denominator_populations.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a03_Creating_target_denominator_populations.Rmd)

`a03_Creating_target_denominator_populations.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

## Using generateDenominatorCohortSet() with a target cohort

As seen in the previous vignette, `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` can be used to generate denominator populations based on all individuals in the database with individuals included once they satisfy criteria. However, in some case we might want to define a denominator population within a specific population of interest, for example people diagnosed with a condition of interest. The function `[generateTargetDenominatorCohortSet()](../reference/generateTargetDenominatorCohortSet.html)` provides functionality for this.

To provide an example its use, let´s generate 5 example patients.

Here we generate a simulated target cohort table with 5 individuals and 2 different target cohorts to illustrate the following examples. Note, some of the individuals in the database are in an acute asthma cohort.
    
    
    personTable <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"),
      gender_concept_id = [c](https://rdrr.io/r/base/c.html)([rep](https://rdrr.io/r/base/rep.html)("8507", 2), [rep](https://rdrr.io/r/base/rep.html)("8532", 3)),
      year_of_birth = 2000,
      month_of_birth = 06,
      day_of_birth = 01
    )
    observationPeriodTable <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = "1",
      person_id = [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"),
      observation_period_start_date = [c](https://rdrr.io/r/base/c.html)(
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-12-19"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-04-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-04-10"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-08-20"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01")
      ),
      observation_period_end_date = [c](https://rdrr.io/r/base/c.html)(
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2011-06-19"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-11-29"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2016-01-02"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2011-12-11"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2015-06-01")
      )
    )
    
    acute_asthma <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [rep](https://rdrr.io/r/base/rep.html)("1", 5),
      subject_id = [c](https://rdrr.io/r/base/c.html)("3", "3", "5", "5", "2"),
      cohort_start_date = [c](https://rdrr.io/r/base/c.html)(
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2011-01-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2015-06-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2014-10-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-06-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-08-20")
      ),
      cohort_end_date = [c](https://rdrr.io/r/base/c.html)(
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2013-01-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2015-12-31"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2015-04-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-06-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-09-20")
      )
    )
    
    # mock database
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(
      personTable = personTable,
      observationPeriodTable = observationPeriodTable,
      targetCohortTable = acute_asthma
    )

As we´ve already seen, we can get a denominator population without including any particular subset like so
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator"
    )
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int> <chr>      <date>            <date>         
    #> 1                    1 1          2010-12-19        2011-06-19     
    #> 2                    1 2          2005-04-01        2005-11-29     
    #> 3                    1 3          2009-04-10        2016-01-02     
    #> 4                    1 4          2010-08-20        2011-12-11     
    #> 5                    1 5          2010-01-01        2015-06-01

As we did not specify any study start and end date, the cohort start and end date of our 5 patients correspond to the same registered as observation period.
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5")) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-4-1.png)

But if we use `[generateTargetDenominatorCohortSet()](../reference/generateTargetDenominatorCohortSet.html)` to create a denominator cohort among the individuals in the acute asthma cohort.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma",
      targetCohortTable = "target"
    )

We can see that persons “3” and “5” experienced this condition in two different occasions and contribute time to the denominator population twice, while person “2” contributes one period of time at risk.
    
    
    cdm$denominator_acute_asthma [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-6-1.png)

### Applying cohort restrictions

We can use PatientProfiles to see demographics at time of entry to the target cohort.
    
    
    cdm$target |> 
      PatientProfiles::[addDemographics](https://darwin-eu.github.io/PatientProfiles/reference/addDemographics.html)(indexDate = "cohort_start_date")
    #> # Source:   table<og_001_1753254292> [?? x 8]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date   age sex   
    #>                  <int> <chr>      <date>            <date>          <int> <chr> 
    #> 1                    1 2          2005-08-20        2005-09-20          5 Male  
    #> 2                    1 3          2015-06-01        2015-12-31         15 Female
    #> 3                    1 5          2010-06-01        2010-06-01         10 Female
    #> 4                    1 3          2011-01-01        2013-01-01         10 Female
    #> 5                    1 5          2014-10-01        2015-04-01         14 Female
    #> # ℹ 2 more variables: prior_observation <int>, future_observation <int>

Restrictions based on age, sex, and prior observation, and calendar dates can again be applied like with `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)`. However, now we have additional considerations on how these restrictions are implemented. In particular, whether requirements must be fulfilled on the date of target cohort entry or whether we allow people to contribute time once they satisfy time-varying criteria.

This choice is implemented using the `requirementsAtEntry` argument. When this is set to TRUE individuals must satisfy the age and prior observation requirements on their target cohort entry date. In the case below we can see that persons “3” and “5” satisfy the sex and age requirements on their target cohort start dates, although one of the cohort entries is excluded for patient “3” and “5” as they were below the minimum age at their date of cohort entry.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_incident",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target",
      requirementsAtEntry = TRUE
    )
    
    cdm$denominator_acute_asthma_incident [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-8-1.png)

If we change `requirementsAtEntry` to FALSE individuals can now contribute once they the various criteria. Now we can see that we have included an extra period of time of risk for patient “3”. This is because although they were younger than 11 at their cohort entry, we now allow them to contribute time once they have reached the age of 11.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_prevalent",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target",
      requirementsAtEntry = FALSE
    )
    
    cdm$denominator_acute_asthma_prevalent [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-9-1.png)

Similarly, let’s say we are considering multiple, non-overlapping, age groups. Setting requirementsAtEntry to TRUE will mean that an individual will only contribute a given target entry to one of these - the one where they are that age on the day of target cohort entry. However, setting requirementsAtEntry to FALSE would allow an individual to graduate from one age group to another.

As with age, the same will apply when specifying time varying elements such as date criteria and prior observation requirements. For example, if we specify dates using `cohortDateRange` then if requirementsAtEntry is TRUE an individual must enter the target cohort during the date range,

### Specifying time at risk

We can also enforce a time at risk for people to contribute to the denominator. For instance, we might only want to take into account events for people in the target denominator cohort on their first month after cohort entry. This can be achieved by adding the input parameter `timeAtRisk = c(0,30)` when computing the denominator, before any incidence or prevalence calculations.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_2",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target",
      timeAtRisk = [c](https://rdrr.io/r/base/c.html)(0, 30)
    )
    
    cdm$denominator_acute_asthma_2 [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-10-1.png)

Note that this parameter allows the user to input different time at risk values in the same function call. Therefore, if we ask for `timeAtRisk = list(c(0, 30), c(31, 60))`, we will get a denominator cohort of people contributing time up to 30 days following cohort entry, and another one with time from 31 days following cohort entry to 60 days.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_3",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target",
      timeAtRisk = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 30), [c](https://rdrr.io/r/base/c.html)(31, 60))
    )
    
    cdm$denominator_acute_asthma_3 [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      dplyr::[left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(
        [attr](https://rdrr.io/r/base/attr.html)(cdm$denominator_acute_asthma_3, "cohort_set") [%>%](../reference/pipe.html)
          dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)([c](https://rdrr.io/r/base/c.html)(
            "cohort_definition_id",
            "time_at_risk"
          )),
        by = "cohort_definition_id",
        copy = TRUE
      ) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row, colour = time_at_risk)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-11-1.png)

Additionally, observe that this parameter allows us to control the follow-up of these individuals after cohort entry for the denominator cohort, but this is inherently linked to their cohort exit and the end of their observation period. Hence, if we define the target cohort so that individuals are only followed for one month, and we now require `timeAtRisk = c(0,90)`, we will get the same denominator cohort as in the previous example.
    
    
    cdm$target_2 <- cdm$target |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(dif = cohort_end_date - cohort_start_date) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_end_date = dplyr::[if_else](https://dplyr.tidyverse.org/reference/if_else.html)(
        dif > 30,
        clock::[add_days](https://clock.r-lib.org/reference/clock-arithmetic.html)(cohort_start_date, 30),
        cohort_end_date
      )) |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(-"dif") |>
      dplyr::[compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "target_2")
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_4",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target_2",
      timeAtRisk = [c](https://rdrr.io/r/base/c.html)(0, 90)
    )
    
    cdm$denominator_acute_asthma_4 [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-12-1.png)

Note that time at risk will always be related to target cohort entry. If we set `requirementsAtEntry` to FALSE and an individual contributes time from 31 days after their target entry date, they wouldn’t contribute any time if timeAtRisk was set to c(0, 30).

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/articles/a04_Calculating_prevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Calculating prevalence

Source: [`vignettes/a04_Calculating_prevalence.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a04_Calculating_prevalence.Rmd)

`a04_Calculating_prevalence.Rmd`

## Introduction

Prevalence is the total number of people with an ongoing health-related event, such as a medical condition or medication use, at a particular time or during a given period divided by the population at risk. In the previous vignettes we have seen how we can identify a denominator population and define and instantiate an outcome cohort. Prevalence then can be calculated to describe the proportion of people in the denominator population who are in the outcome cohort at a specified time point (point prevalence) or over a given time interval (period prevalence).

In the first plot below, we can We can see at time t+2 that 2 out of 5 people were in an outcome cohort, giving a point prevalence of 40%. In the second figure, period prevalence between t+2 and t+3 was also 40%. However for period prevalence between t and t+1, what do we do with those people who only contributed some time during the period? If we included them we´ll have a period prevalence of 20%, whereas if we require that everyone is observed for the full period to contribute then we´ll have a period prevalence of 33%.

![](point_prev.png)

![](period_prev.png)

## Outcome definition

Outcome cohorts are defined externally. When creating outcome cohorts for estimating prevalence, important considerations relate to whether to restrict events to the first occurrence in an individuals history or not and how cohort exit is defined. These decisions will necessarily be based on the nature of the proposed outcome (e.g., whether it is an acute or chronic condition) and the research question being investigated.

In addition, it is typically not recommended to include exclusion requirements when creating outcome cohorts. Restrictions on patient characteristics can be specified when identifying the denominator cohort using `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` or `[generateTargetDenominatorCohortSet()](../reference/generateTargetDenominatorCohortSet.html)`

## Using estimatePointPrevalence() and estimatePeriodPrevalence()

`[estimatePointPrevalence()](../reference/estimatePointPrevalence.html)` and `[estimatePeriodPrevalence()](../reference/estimatePeriodPrevalence.html)` are the functions we use to estimate prevalence. To demonstrate its use, let´s load the IncidencePrevalence package (along with a couple of packages to help for subsequent plots) and generate 20,000 example patients using the `[mockIncidencePrevalence()](../reference/mockIncidencePrevalence.html)` function from whom we´ll create a denominator population without adding any restrictions other than a study period.
    
    
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([patchwork](https://patchwork.data-imaginist.com))
    
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(
      sampleSize = 20000,
      earliestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("1960-01-01"),
      minOutcomeDays = 365,
      outPre = 0.3
    )
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0
    )
    
    cdm$denominator [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 1, 3, 10, 12, 14, 16, 18, 19, 20, 22, 23, 25, 27,…
    #> $ cohort_start_date    <date> 1991-08-05, 2007-02-16, 2009-04-21, 1992-01-28, …
    #> $ cohort_end_date      <date> 1996-01-10, 2007-12-09, 2009-12-31, 1999-08-18, …

### Using estimatePointPrevalence()

Let´s first calculate point prevalence on a yearly basis.
    
    
    prev <- [estimatePointPrevalence](../reference/estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "Years"
    )
    
    prev [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 144
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Outcome", "Outcome", "Outc…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "prevalence", "…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2147", "82", "0.03819", "0.03088", "0.04716", "2164"…
    #> $ additional_name  <chr> "prevalence_start_date &&& prevalence_end_date &&& an…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-01-01 &&& years", "1990-01-01 &&…
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-6-1.png)

As well as plotting our prevalence estimates, we can also plot the population for whom these were calculated. Here we´ll plot outcome and population counts together.
    
    
    outcome_plot <- [plotPrevalencePopulation](../reference/plotPrevalencePopulation.html)(result = prev, y = "outcome_count") + [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("") +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(axis.text.x = [element_blank](https://ggplot2.tidyverse.org/reference/element.html)()) +
      [ggtitle](https://ggplot2.tidyverse.org/reference/labs.html)("a) Number of outcomes by year")
    denominator_plot <- [plotPrevalencePopulation](../reference/plotPrevalencePopulation.html)(result = prev) +
      [ggtitle](https://ggplot2.tidyverse.org/reference/labs.html)("b) Number of people in denominator population by year")
    outcome_plot / denominator_plot

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-7-1.png)

We can also calculate point prevalence by calendar month.
    
    
    prev <- [estimatePointPrevalence](../reference/estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "Months"
    )
    
    prev [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,244
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Outcome", "Outcome", "Outc…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "prevalence", "…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2147", "82", "0.03819", "0.03088", "0.04716", "2148"…
    #> $ additional_name  <chr> "prevalence_start_date &&& prevalence_end_date &&& an…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-01-01 &&& months", "1990-01-01 &…
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-8-1.png)

By using the estimatePointPrevalence() function, we can further specify where to compute point prevalence in each time interval (start, middle, end). By default, this parameter is set to start. But we can use middle instead like so:
    
    
    prev <- [estimatePointPrevalence](../reference/estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "Years",
      timePoint = "middle"
    )
    
    prev [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 144
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Outcome", "Outcome", "Outc…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "prevalence", "…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2160", "76", "0.03519", "0.0282", "0.04382", "2161",…
    #> $ additional_name  <chr> "prevalence_start_date &&& prevalence_end_date &&& an…
    #> $ additional_level <chr> "1990-07-01 &&& 1990-07-01 &&& years", "1990-07-01 &&…
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev, line = FALSE)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-9-1.png)

### Using estimatePeriodPrevalence()

To calculate period prevalence by year (i.e. each period is a calendar year)
    
    
    prev <- [estimatePeriodPrevalence](../reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "Years"
    )
    
    prev [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 144
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Outcome", "Outcome", "Outc…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "prevalence", "…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2523", "189", "0.07491", "0.06527", "0.08584", "2517…
    #> $ additional_name  <chr> "prevalence_start_date &&& prevalence_end_date &&& an…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-12-31 &&& years", "1990-01-01 &&…
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-10-1.png)

To calculate period prevalence by month (i.e. each period is a calendar month)
    
    
    prev <- [estimatePeriodPrevalence](../reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "Months"
    )
    
    prev [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,244
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Outcome", "Outcome", "Outc…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "prevalence", "…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2176", "94", "0.0432", "0.03543", "0.05258", "2171",…
    #> $ additional_name  <chr> "prevalence_start_date &&& prevalence_end_date &&& an…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-01-31 &&& months", "1990-01-01 &…
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-11-1.png)

When using the estimatePeriodPrevalence() function, we can set the fullContribution parameter to decide whether individuals are required to be present in the database throughout the interval of interest in order to be included (fullContribution=TRUE). If not, individuals will only be required to be present for one day of the interval to contribute (fullContribution=FALSE), which would be specified like so:
    
    
    prev <- [estimatePeriodPrevalence](../reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "Months",
      fullContribution = FALSE
    )
    
    prev [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,244
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Outcome", "Outcome", "Outc…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "prevalence", "…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2176", "94", "0.0432", "0.03543", "0.05258", "2171",…
    #> $ additional_name  <chr> "prevalence_start_date &&& prevalence_end_date &&& an…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-01-31 &&& months", "1990-01-01 &…
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-12-1.png)

### Stratified analyses

If we specified multiple denominator populations results will be returned for each. Here for example we define three age groups for denominator populations and get three sets of estimates back when estimating prevalence.
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator_age_sex",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 39),
        [c](https://rdrr.io/r/base/c.html)(41, 65),
        [c](https://rdrr.io/r/base/c.html)(66, 150)
      ),
      sex = "Both",
      daysPriorObservation = 0
    )
    prev <- [estimatePeriodPrevalence](../reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator_age_sex",
      outcomeTable = "outcome"
    )
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev) +
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://dplyr.tidyverse.org/reference/vars.html)(denominator_age_group), ncol = 1)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-13-1.png)

We can also plot a count of the denominator by year for each strata.
    
    
    denominator_plot <- [plotPrevalencePopulation](../reference/plotPrevalencePopulation.html)(result = prev)
    
    denominator_plot +
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://dplyr.tidyverse.org/reference/vars.html)(denominator_age_group), ncol = 1)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-14-1.png)

While we specify time-varying stratifications when defining our denominator populations, if we have time-invariant stratifications we can include these at the the estimation stage. To do this we first need to add a new column to our denominator cohort with our stratification variable. Here we’ll add an example stratification just to show the idea. Note, as well as getting stratified results we’ll also get overall results.
    
    
    cdm$denominator <- cdm$denominator [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(group = [if_else](https://dplyr.tidyverse.org/reference/if_else.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id) < 500, "first", "second"))
    
    prev <- [estimatePeriodPrevalence](../reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      strata = "group"
    )
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev,
      colour = "group"
    ) + 
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://dplyr.tidyverse.org/reference/vars.html)(group), ncol = 1)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-15-1.png)

We can also stratify on multiple variables at the same time.
    
    
    cdm$denominator <- cdm$denominator [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(
        group_1 = [if_else](https://dplyr.tidyverse.org/reference/if_else.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id) < 1500, "first", "second"),
        group_2 = [if_else](https://dplyr.tidyverse.org/reference/if_else.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id) < 1000, "one", "two")
      )
    
    prev <- [estimatePeriodPrevalence](../reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      strata = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)("group_1"), # for just group_1
        [c](https://rdrr.io/r/base/c.html)("group_2"), # for just group_2
        [c](https://rdrr.io/r/base/c.html)("group_1", "group_2")
      ) # for group_1 and group_2
    )
    
    [plotPrevalence](../reference/plotPrevalence.html)(prev) + 
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://dplyr.tidyverse.org/reference/vars.html)(group_1, group_2), ncol = 2)

![](a04_Calculating_prevalence_files/figure-html/unnamed-chunk-16-1.png)

### Other parameters

In the examples above, we have used calculated prevalence by months and years, but it can be also calculated by weeks, months or for the entire time period observed (overall). In addition, the user can decide whether to include time intervals that are not fully captured in the database (e.g., having data up to June for the last study year when computing period prevalence rates). By default, incidence will only be estimated for those intervals where the database captures all the interval (completeDatabaseIntervals=TRUE).

Given that we can set `[estimatePointPrevalence()](../reference/estimatePointPrevalence.html)` and `estimatePeriorPrevalence()` to exclude individuals based on certain parameters (e.g., fullContribution), it is important to note that the denominator population used to compute prevalence rates might differ from the one calculated with `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)`. Along with our central estimate, 95 % confidence intervals are calculated using the Wilson Score method.

### Attrition

`[estimatePointPrevalence()](../reference/estimatePointPrevalence.html)` and `estimatePeriorPrevalence()` will generate a table with point and period prevalence rates for each of the time intervals studied and for each combination of the parameters set, respectively. We can also view attrition associated with performing the analysis.
    
    
    prev <- [estimatePeriodPrevalence](../reference/estimatePeriodPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "Years",
      fullContribution = TRUE
    )
    [tablePrevalenceAttrition](../reference/tablePrevalenceAttrition.html)(prev, style = "darwin")

Reason |  Variable name  
---|---  
Number records | Number subjects | Excluded records | Excluded subjects  
mock; cohort_1  
Starting population | 20,000 | 20,000 | - | -  
Missing year of birth | 20,000 | 20,000 | 0 | 0  
Missing sex | 20,000 | 20,000 | 0 | 0  
Cannot satisfy age criteria during the study period based on year of birth | 20,000 | 20,000 | 0 | 0  
No observation time available during study period | 10,399 | 10,399 | 9,601 | 9,601  
Doesn't satisfy age criteria during the study period | 10,399 | 10,399 | 0 | 0  
Prior history requirement not fulfilled during study period | 10,399 | 10,399 | 0 | 0  
No observation time available after applying age, prior observation and, if applicable, target criteria | 10,149 | 10,149 | 250 | 250  
Starting analysis population | 10,149 | 10,149 | - | -  
Not observed during the complete database interval | 10,149 | 10,149 | 0 | 0  
Do not satisfy full contribution requirement for an interval | 8,385 | 8,385 | 1,764 | 1,764  
  
## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/articles/a05_Calculating_incidence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Calculating incidence

Source: [`vignettes/a05_Calculating_incidence.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a05_Calculating_incidence.Rmd)

`a05_Calculating_incidence.Rmd`

## Introduction

Incidence rates describe the rate at which new events occur in a population, with the denominator the person-time at risk of the event during this period. In the previous vignettes we have seen how we can identify a set of denominator and outcome cohorts. Incidence rates can then be calculated using time contributed from these denominator cohorts up to their entry into an outcome cohort.

There are a number of options to consider when calculating incidence rates. This package accommodates various parameters when estimating incidence. In particular, the **outcome washout** (the number of days used for a ‘washout’ period between the end of one outcome ending and an individual starting to contribute time at risk again) and allowing **repeated events** (whether individuals are able to contribute multiple events during the study period or if they will only contribute time up to their first event during the study period) are particularly important analytic settings to consider. In addition, censoring events can also be specified to limit time at risk.

#### No washout, no repetitive events

In this example there is no outcome washout specified and repetitive events are not allowed, so individuals contribute time up to their first event during the study period. ![](inc_no_rep_no_washout.png)

#### Washout all history, no repetitive events

In this example the outcome washout is all history and repetitive events are not allowed. As before individuals contribute time up to their first event during the study period, but having an outcome prior to the study period (such as person “3”) means that no time at risk is contributed.

![](inc_no_rep_washout_all.png)

#### Some washout, no repetitive events

In this example there is some amount of outcome washout and repetitive events are not allowed. As before individuals contribute time up to their first event during the study period, but having an outcome prior to the study period (such as person “3”) means that time at risk is only contributed once sufficient time has passed for the outcome washout criteria to have been satisfied.

![](inc_no_rep_some_washout.png)

#### Some washout, repetitive events

Now repetitive events are allowed with some amount of outcome washout specified. So individuals contribute time up to their first event during the study period, and then after passing the outcome washout requirement they begin to contribute time at risk again.

![](inc_rep_some_washout.png)

#### Some washout, repetitive events, censoring event

We can also incorporate a censoring event. Here any time at risk after this censoring event will be excluded.

![](inc_rep_some_washout_censor.png)

## Outcome definition

Outcome cohorts are defined externally. When creating outcome cohorts for estimating incidence, the most important recommendations for defining an outcome cohort for calculating incidence are:

  1. Do not restrict outcome cohorts to first events only. This will impact the ability to exclude participants (as they can be excluded based on the prior latest event) and to capture more than one event per person (which is an option allowed in the package).
  2. Set an appropriate cohort exit strategy. If we want to consider multiple events per person, the duration of these events will be of importance, as we are not going to capture subsequent events if prior events have not yet been concluded. In addition, outcome washouts will be implemented relative to cohort exit from any previous event.
  3. Do not add further restrictions on sex, age and prior history requirements. These can be specified when identifying the denominator population with the `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` function.



## Using estimateIncidence()

`[estimateIncidence()](../reference/estimateIncidence.html)` is the function we use to estimate incidence rates. To demonstrate its use, let´s load the IncidencePrevalence package (along with a couple of packages to help for subsequent plots) and generate 20,000 example patients using the `[mockIncidencePrevalence()](../reference/mockIncidencePrevalence.html)` function, from whom we´ll create a denominator population without adding any restrictions other than a study period. In this example we’ll use permanent tables (rather than temporary tables which would be used by default).
    
    
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([patchwork](https://patchwork.data-imaginist.com))
    
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(
      sampleSize = 20000,
      earliestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("1960-01-01"),
      minOutcomeDays = 365,
      outPre = 0.3
    )
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0
    )
    
    cdm$denominator [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 1, 3, 10, 12, 14, 16, 18, 19, 20, 22, 23, 25, 27,…
    #> $ cohort_start_date    <date> 1991-08-05, 2007-02-16, 2009-04-21, 1992-01-28, …
    #> $ cohort_end_date      <date> 1996-01-10, 2007-12-09, 2009-12-31, 1999-08-18, …

Let´s first calculate incidence rates on a yearly basis, without allowing repetitive events
    
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      outcomeWashout = 0,
      repeatedEvents = FALSE
    )
    
    inc [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 184
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2517", "107", "760044", "2080.887", "5142.038", "421…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-12-31 &&& years", "1990-01-01 &&…
    
    [plotIncidence](../reference/plotIncidence.html)(inc)

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-8-1.png)

As well as plotting our prevalence estimates, we can also plot the population for whom these were calculated. Here we´ll plot outcome and population counts together.
    
    
    outcome_plot <- [plotIncidencePopulation](../reference/plotIncidencePopulation.html)(result = inc, y = "outcome_count") +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("") +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(axis.text.x = [element_blank](https://ggplot2.tidyverse.org/reference/element.html)()) +
      [ggtitle](https://ggplot2.tidyverse.org/reference/labs.html)("a) Number of outcomes by year")
    denominator_plot <- [plotIncidencePopulation](../reference/plotIncidencePopulation.html)(result = inc) +
      [ggtitle](https://ggplot2.tidyverse.org/reference/labs.html)("b) Number of people in denominator population by year")
    pys_plot <- [plotIncidencePopulation](../reference/plotIncidencePopulation.html)(result = inc, y = "person_years") +
      [ggtitle](https://ggplot2.tidyverse.org/reference/labs.html)("c) Person-years contributed by year")
    
    outcome_plot / denominator_plot / pys_plot

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-9-1.png)

Now with a washout of all prior history while still not allowing repetitive events. Here we use `Inf` to specify that we will use a washout of all prior history for an individual.
    
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      outcomeWashout = Inf,
      repeatedEvents = FALSE
    )
    
    inc [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 184
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2168", "107", "659947", "1806.836", "5921.954", "485…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-12-31 &&& years", "1990-01-01 &&…
    
    [plotIncidence](../reference/plotIncidence.html)(inc)

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-10-1.png)

Now we´ll set the washout to 180 days while still not allowing repetitive events
    
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      outcomeWashout = 180,
      repeatedEvents = FALSE
    )
    
    inc [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 184
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2491", "107", "743647", "2035.995", "5255.416", "430…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-12-31 &&& years", "1990-01-01 &&…
    
    [plotIncidence](../reference/plotIncidence.html)(inc)

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-11-1.png)

And now we´ll set the washout to 180 days and allow repetitive events
    
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      outcomeWashout = 180,
      repeatedEvents = TRUE
    )
    
    inc [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 184
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2491", "107", "743647", "2035.995", "5255.416", "430…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-12-31 &&& years", "1990-01-01 &&…
    
    [plotIncidence](../reference/plotIncidence.html)(inc)

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-12-1.png)

Finally, we can apply a censoring event. For this we will need to point to a cohort which we want to be used for censoring. As with the outcome cohort, censoring cohorts need to be defined externally. But once created we can use these to limit follow-up. Note, only one censoring cohort can be used and this cohort must only include one record per person
    
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      censorTable = "censor",
      interval = "years",
      outcomeWashout = 180,
      repeatedEvents = TRUE
    )
    
    inc [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 184
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_1 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "2266", "101", "667834", "1828.43", "5523.865", "4499…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "1990-01-01 &&& 1990-12-31 &&& years", "1990-01-01 &&…
    
    [plotIncidence](../reference/plotIncidence.html)(inc)

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-13-1.png)

### Stratified analyses

As with prevalence, if we specified multiple denominator populations results will be returned for each. Here for example we define three age groups for denominator populations and get three sets of estimates back when estimating incidence
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator_age_sex",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 39),
        [c](https://rdrr.io/r/base/c.html)(41, 65),
        [c](https://rdrr.io/r/base/c.html)(66, 150)
      ),
      sex = "Both",
      daysPriorObservation = 0
    )
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator_age_sex",
      outcomeTable = "outcome",
      interval = "years",
      outcomeWashout = 180,
      repeatedEvents = TRUE
    )
    
    [plotIncidence](../reference/plotIncidence.html)(inc) + 
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://dplyr.tidyverse.org/reference/vars.html)(denominator_age_group), ncol = 1)

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-14-1.png)

We can also plot person years by year for each strata.
    
    
    pys_plot <- [plotIncidencePopulation](../reference/plotIncidencePopulation.html)(result = inc, y = "person_years")
    
    pys_plot +
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://dplyr.tidyverse.org/reference/vars.html)(denominator_age_group), ncol = 1)

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-15-1.png)

And again, as with prevalence while we specify time-varying stratifications when defining our denominator populations, if we have time-invariant stratifications we can include these at the the estimation stage.
    
    
    cdm$denominator <- cdm$denominator [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(group = [if_else](https://dplyr.tidyverse.org/reference/if_else.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id) < 3000, "first", "second"))
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      strata = [list](https://rdrr.io/r/base/list.html)("group"),
      outcomeWashout = 180,
      repeatedEvents = TRUE
    )
    
    [plotIncidence](../reference/plotIncidence.html)(inc,
      colour = "group"
    ) + 
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://dplyr.tidyverse.org/reference/vars.html)(group), ncol = 1)

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-16-1.png)
    
    
    
    cdm$denominator <- cdm$denominator [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(
        group_1 = [if_else](https://dplyr.tidyverse.org/reference/if_else.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id) < 3000, "first", "second"),
        group_2 = [if_else](https://dplyr.tidyverse.org/reference/if_else.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id) < 2000, "one", "two")
      )
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      strata = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)("group_1"), # for just group_1
        [c](https://rdrr.io/r/base/c.html)("group_2"), # for just group_2
        [c](https://rdrr.io/r/base/c.html)("group_1", "group_2")
      ), # for group_1 and group_2
      outcomeWashout = 180,
      repeatedEvents = TRUE
    )
    
    [plotIncidence](../reference/plotIncidence.html)(inc,
      colour = [c](https://rdrr.io/r/base/c.html)("group_1", "group_2")
    ) +
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://dplyr.tidyverse.org/reference/vars.html)(group_1, group_2), ncol = 2) +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(legend.position = "top")

![](a05_Calculating_incidence_files/figure-html/unnamed-chunk-16-2.png)

#### Other parameters

In the examples above, we have used calculated incidence rates by months and years, but it can be also calculated by weeks, months, quarters, or for the entire study time period. In addition, we can decide whether to include time intervals that are not fully captured in the database (e.g., having data up to June for the last study year when computing yearly incidence rates). By default, incidence will only be estimated for those intervals where the denominator cohort captures all the interval (completeDatabaseIntervals=TRUE).

Given that we can set `[estimateIncidence()](../reference/estimateIncidence.html)` to exclude individuals based on other parameters (e.g., outcomeWashout), it is important to note that the denominator population used to compute incidence rates might differ from the one calculated with `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)`. 95 % confidence intervals are calculated using the exact method.
    
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = [c](https://rdrr.io/r/base/c.html)("weeks"),
      completeDatabaseIntervals = FALSE,
      outcomeWashout = 180,
      repeatedEvents = TRUE
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 10 secs

#### Analysis attrition

As with our prevalence results, we can also view the attrition associate with estimating incidence.
    
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = [c](https://rdrr.io/r/base/c.html)("Years"),
      outcomeWashout = 180,
      repeatedEvents = TRUE
    )
    [tableIncidenceAttrition](../reference/tableIncidenceAttrition.html)(inc, style = "darwin")

Reason |  Variable name  
---|---  
Number records | Number subjects | Excluded records | Excluded subjects  
mock; cohort_1  
Starting population | 20,000 | 20,000 | - | -  
Missing year of birth | 20,000 | 20,000 | 0 | 0  
Missing sex | 20,000 | 20,000 | 0 | 0  
Cannot satisfy age criteria during the study period based on year of birth | 20,000 | 20,000 | 0 | 0  
No observation time available during study period | 10,399 | 10,399 | 9,601 | 9,601  
Doesn't satisfy age criteria during the study period | 10,399 | 10,399 | 0 | 0  
Prior history requirement not fulfilled during study period | 10,399 | 10,399 | 0 | 0  
No observation time available after applying age, prior observation and, if applicable, target criteria | 10,149 | 10,149 | 250 | 250  
Starting analysis population | 10,149 | 10,149 | - | -  
Apply washout criteria of 180 days (note, additional records may be created for those with an outcome) | 11,583 | 10,132 | -1,434 | 17  
Not observed during the complete database interval | 11,583 | 10,132 | 0 | 0  
  
## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/articles/a06_Working_with_IncidencePrevalence_Results.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Working with IncidencePrevalence results

Source: [`vignettes/a06_Working_with_IncidencePrevalence_Results.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a06_Working_with_IncidencePrevalence_Results.Rmd)

`a06_Working_with_IncidencePrevalence_Results.Rmd`

### Standardardised results format

The IncidencePrevalence returns results from analyses in a standardised results format, as defined in the omopgenerics package. This format, a `summarised_result`, is explained in general in the omopgenerics documenatation <https://darwin-eu.github.io/omopgenerics/articles/summarised_result.html>.

Let’s see how this result format is used by IncidencePrevalence.

We’ll first create some example incidence and prevalence results with a mock dataset.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(
      sampleSize = 10000,
      outPre = 0.3,
      minOutcomeDays = 365,
      maxOutcomeDays = 3650
    )
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2008-01-01", "2018-01-01")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 64),
        [c](https://rdrr.io/r/base/c.html)(65, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = 180
    )
    
    inc <- [estimateIncidence](../reference/estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      repeatedEvents = TRUE,
      outcomeWashout = 180,
      completeDatabaseIntervals = TRUE
    )
    
    prev_point <- [estimatePointPrevalence](../reference/estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "years",
      timePoint = "start"
    )

We can see that both of our results object have a “summarised_result” class.
    
    
    [inherits](https://rdrr.io/r/base/class.html)(inc, "summarised_result")
    #> [1] TRUE
    
    [inherits](https://rdrr.io/r/base/class.html)(prev_point, "summarised_result")
    #> [1] TRUE

In practice, this means that our results have the following columns
    
    
    omopgenerics::[resultColumns](https://darwin-eu.github.io/omopgenerics/reference/resultColumns.html)("summarised_result")
    #>  [1] "result_id"        "cdm_name"         "group_name"       "group_level"     
    #>  [5] "strata_name"      "strata_level"     "variable_name"    "variable_level"  
    #>  [9] "estimate_name"    "estimate_type"    "estimate_value"   "additional_name" 
    #> [13] "additional_level"

And we can see that this is indeed the case for incidence and prevalence results
    
    
    inc |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 700
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_3 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "326", "13", "96994", "265.555", "4895.408", "2606.59…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "2008-01-01 &&& 2008-12-31 &&& years", "2008-01-01 &&…
    
    prev_point |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 610
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_3 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Outcome", "Outcome", "Outc…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "prevalence", "…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "330", "57", "0.17273", "0.13577", "0.21722", "322", …
    #> $ additional_name  <chr> "prevalence_start_date &&& prevalence_end_date &&& an…
    #> $ additional_level <chr> "2008-01-01 &&& 2008-01-01 &&& years", "2008-01-01 &&…

In addition to these main results, we can see that our results are also associated with settings. These settings contain information on how the results were created. Although we can see that some settings are present for both incidence and prevalence, such as `denominator_days_prior_observation` which relates to the input to `daysPriorObservation` we specified above, others are only present for the relevant result, such analysis_outcome_washout which relates to the `outcomeWashout` argument used for the `[estimateIncidence()](../reference/estimateIncidence.html)` function.
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(inc) |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 12
    #> Columns: 20
    #> $ result_id                            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11…
    #> $ result_type                          <chr> "incidence", "incidence", "incide…
    #> $ package_name                         <chr> "IncidencePrevalence", "Incidence…
    #> $ package_version                      <chr> "1.2.1", "1.2.1", "1.2.1", "1.2.1…
    #> $ group                                <chr> "denominator_cohort_name &&& outc…
    #> $ strata                               <chr> "", "", "", "", "", "", "reason",…
    #> $ additional                           <chr> "incidence_start_date &&& inciden…
    #> $ min_cell_count                       <chr> "0", "0", "0", "0", "0", "0", "0"…
    #> $ analysis_censor_cohort_name          <chr> "None", "None", "None", "None", "…
    #> $ analysis_complete_database_intervals <chr> "TRUE", "TRUE", "TRUE", "TRUE", "…
    #> $ analysis_outcome_washout             <chr> "180", "180", "180", "180", "180"…
    #> $ analysis_repeated_events             <chr> "TRUE", "TRUE", "TRUE", "TRUE", "…
    #> $ denominator_age_group                <chr> "0 to 64", "0 to 64", "0 to 64", …
    #> $ denominator_days_prior_observation   <chr> "180", "180", "180", "180", "180"…
    #> $ denominator_end_date                 <chr> "2018-01-01", "2018-01-01", "2018…
    #> $ denominator_requirements_at_entry    <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ denominator_sex                      <chr> "Both", "Female", "Male", "Both",…
    #> $ denominator_start_date               <chr> "2008-01-01", "2008-01-01", "2008…
    #> $ denominator_target_cohort_name       <chr> "None", "None", "None", "None", "…
    #> $ denominator_time_at_risk             <chr> "0 to Inf", "0 to Inf", "0 to Inf…
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(prev_point) |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 12
    #> Columns: 20
    #> $ result_id                            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11…
    #> $ result_type                          <chr> "prevalence", "prevalence", "prev…
    #> $ package_name                         <chr> "IncidencePrevalence", "Incidence…
    #> $ package_version                      <chr> "1.2.1", "1.2.1", "1.2.1", "1.2.1…
    #> $ group                                <chr> "denominator_cohort_name &&& outc…
    #> $ strata                               <chr> "", "", "", "", "", "", "reason",…
    #> $ additional                           <chr> "prevalence_start_date &&& preval…
    #> $ min_cell_count                       <chr> "0", "0", "0", "0", "0", "0", "0"…
    #> $ analysis_complete_database_intervals <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ analysis_full_contribution           <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ analysis_level                       <chr> "person", "person", "person", "pe…
    #> $ analysis_type                        <chr> "point prevalence", "point preval…
    #> $ denominator_age_group                <chr> "0 to 64", "0 to 64", "0 to 64", …
    #> $ denominator_days_prior_observation   <chr> "180", "180", "180", "180", "180"…
    #> $ denominator_end_date                 <chr> "2018-01-01", "2018-01-01", "2018…
    #> $ denominator_requirements_at_entry    <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ denominator_sex                      <chr> "Both", "Female", "Male", "Both",…
    #> $ denominator_start_date               <chr> "2008-01-01", "2008-01-01", "2008…
    #> $ denominator_target_cohort_name       <chr> "None", "None", "None", "None", "…
    #> $ denominator_time_at_risk             <chr> "0 to Inf", "0 to Inf", "0 to Inf…

Because our results are in the same format we can easily combine them using the `bind`. We can see that after this we will have the same results columns, while the settings are now combined with all analytic choices used stored.
    
    
    results <- [bind](https://darwin-eu.github.io/omopgenerics/reference/bind.html)(inc, prev_point) |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,310
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_3 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "326", "13", "96994", "265.555", "4895.408", "2606.59…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "2008-01-01 &&& 2008-12-31 &&& years", "2008-01-01 &&…
    
    results |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,310
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "denominator_cohort_name &&& outcome_cohort_name", "d…
    #> $ group_level      <chr> "denominator_cohort_3 &&& cohort_1", "denominator_coh…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Denominator", "Outcome", "Denominator", "Denominator…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "denominator_count", "outcome_count", "person_days", …
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "326", "13", "96994", "265.555", "4895.408", "2606.59…
    #> $ additional_name  <chr> "incidence_start_date &&& incidence_end_date &&& anal…
    #> $ additional_level <chr> "2008-01-01 &&& 2008-12-31 &&& years", "2008-01-01 &&…
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(results) |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 24
    #> Columns: 23
    #> $ result_id                            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11…
    #> $ result_type                          <chr> "incidence", "incidence", "incide…
    #> $ package_name                         <chr> "IncidencePrevalence", "Incidence…
    #> $ package_version                      <chr> "1.2.1", "1.2.1", "1.2.1", "1.2.1…
    #> $ group                                <chr> "denominator_cohort_name &&& outc…
    #> $ strata                               <chr> "", "", "", "", "", "", "reason",…
    #> $ additional                           <chr> "incidence_start_date &&& inciden…
    #> $ min_cell_count                       <chr> "0", "0", "0", "0", "0", "0", "0"…
    #> $ analysis_censor_cohort_name          <chr> "None", "None", "None", "None", "…
    #> $ analysis_complete_database_intervals <chr> "TRUE", "TRUE", "TRUE", "TRUE", "…
    #> $ analysis_full_contribution           <chr> NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ analysis_level                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ analysis_outcome_washout             <chr> "180", "180", "180", "180", "180"…
    #> $ analysis_repeated_events             <chr> "TRUE", "TRUE", "TRUE", "TRUE", "…
    #> $ analysis_type                        <chr> NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ denominator_age_group                <chr> "0 to 64", "0 to 64", "0 to 64", …
    #> $ denominator_days_prior_observation   <chr> "180", "180", "180", "180", "180"…
    #> $ denominator_end_date                 <chr> "2018-01-01", "2018-01-01", "2018…
    #> $ denominator_requirements_at_entry    <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ denominator_sex                      <chr> "Both", "Female", "Male", "Both",…
    #> $ denominator_start_date               <chr> "2008-01-01", "2008-01-01", "2008…
    #> $ denominator_target_cohort_name       <chr> "None", "None", "None", "None", "…
    #> $ denominator_time_at_risk             <chr> "0 to Inf", "0 to Inf", "0 to Inf…

### Exporting and importing results

We can export our results in a single CSV. Note that when exporting we will apply minimum cell count of 5, suppressing any results below this.
    
    
    dir <- [file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "my_study_results")
    [dir.create](https://rdrr.io/r/base/files2.html)(dir)
    
    [exportSummarisedResult](https://darwin-eu.github.io/omopgenerics/reference/exportSummarisedResult.html)(results,
                           minCellCount = 5,
                           fileName = "incidence_prevalence_results.csv",
                           path = dir)

We can see we have created a single CSV file with our results which contains our suppressed aggregated results which our ready to share.
    
    
    [list.files](https://rdrr.io/r/base/list.files.html)(dir)
    #> [1] "incidence_prevalence_results.csv"

We can import our results back into R (or if we’re running a network study we could import our set of results from data partners).
    
    
    res_imported <- [importSummarisedResult](https://darwin-eu.github.io/omopgenerics/reference/importSummarisedResult.html)(path = dir)

## Validate minimum cell count suppression

We can validate whether our results have been suppressed. We can see that our original results have not been suppressed but the ones we exported were.
    
    
    omopgenerics::[isResultSuppressed](https://darwin-eu.github.io/omopgenerics/reference/isResultSuppressed.html)(results)
    #> Warning: ✖ 24 (1310 rows) not suppressed.
    #> [1] FALSE
    
    
    omopgenerics::[isResultSuppressed](https://darwin-eu.github.io/omopgenerics/reference/isResultSuppressed.html)(res_imported)
    #> ✔ The <summarised_result> is suppressed with
    #> minCellCount = 5.
    #> [1] TRUE

## Tidying results for further analysis

Although our standardised result format is a nice way to combine, store, and share results, in can be somewhat difficult to use if we want to perform further analyses. So to get to a tidy format more specific to their type of results we can use asIncidenceResult() and asPrevalenceResult(), respectively.
    
    
    [asIncidenceResult](../reference/asIncidenceResult.html)(inc) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 60
    #> Columns: 26
    #> $ cdm_name                             <chr> "mock", "mock", "mock", "mock", "…
    #> $ denominator_cohort_name              <chr> "denominator_cohort_3", "denomina…
    #> $ outcome_cohort_name                  <chr> "cohort_1", "cohort_1", "cohort_1…
    #> $ incidence_start_date                 <date> 2008-01-01, 2009-01-01, 2010-01-…
    #> $ incidence_end_date                   <date> 2008-12-31, 2009-12-31, 2010-12-…
    #> $ analysis_interval                    <chr> "years", "years", "years", "years…
    #> $ analysis_censor_cohort_name          <chr> "None", "None", "None", "None", "…
    #> $ analysis_complete_database_intervals <chr> "TRUE", "TRUE", "TRUE", "TRUE", "…
    #> $ analysis_outcome_washout             <chr> "180", "180", "180", "180", "180"…
    #> $ analysis_repeated_events             <chr> "TRUE", "TRUE", "TRUE", "TRUE", "…
    #> $ denominator_age_group                <chr> "0 to 64", "0 to 64", "0 to 64", …
    #> $ denominator_days_prior_observation   <chr> "180", "180", "180", "180", "180"…
    #> $ denominator_end_date                 <date> 2018-01-01, 2018-01-01, 2018-01-…
    #> $ denominator_requirements_at_entry    <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ denominator_sex                      <chr> "Both", "Both", "Both", "Both", "…
    #> $ denominator_start_date               <date> 2008-01-01, 2008-01-01, 2008-01-…
    #> $ denominator_target_cohort_name       <chr> "None", "None", "None", "None", "…
    #> $ denominator_time_at_risk             <chr> "0 to Inf", "0 to Inf", "0 to Inf…
    #> $ denominator_count                    <int> 326, 317, 312, 235, 179, 140, 106…
    #> $ outcome_count                        <int> 13, 14, 20, 16, 6, 7, 4, 2, 4, 2,…
    #> $ person_days                          <dbl> 96994, 98005, 95462, 76142, 58392…
    #> $ person_years                         <dbl> 265.555, 268.323, 261.361, 208.46…
    #> $ incidence_100000_pys                 <dbl> 4895.408, 5217.592, 7652.251, 767…
    #> $ incidence_100000_pys_95CI_lower      <dbl> 2606.598, 2852.506, 4674.194, 438…
    #> $ incidence_100000_pys_95CI_upper      <dbl> 8371.296, 8754.233, 11818.281, 12…
    #> $ result_type                          <chr> "tidy_incidence", "tidy_incidence…
    
    
    [asPrevalenceResult](../reference/asPrevalenceResult.html)(prev_point) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 66
    #> Columns: 24
    #> $ cdm_name                             <chr> "mock", "mock", "mock", "mock", "…
    #> $ denominator_cohort_name              <chr> "denominator_cohort_3", "denomina…
    #> $ outcome_cohort_name                  <chr> "cohort_1", "cohort_1", "cohort_1…
    #> $ prevalence_start_date                <date> 2008-01-01, 2009-01-01, 2010-01-…
    #> $ prevalence_end_date                  <date> 2008-01-01, 2009-01-01, 2010-01-…
    #> $ analysis_interval                    <chr> "years", "years", "years", "years…
    #> $ analysis_complete_database_intervals <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ analysis_full_contribution           <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ analysis_level                       <chr> "person", "person", "person", "pe…
    #> $ analysis_type                        <chr> "point prevalence", "point preval…
    #> $ denominator_age_group                <chr> "0 to 64", "0 to 64", "0 to 64", …
    #> $ denominator_days_prior_observation   <chr> "180", "180", "180", "180", "180"…
    #> $ denominator_end_date                 <date> 2018-01-01, 2018-01-01, 2018-01-…
    #> $ denominator_requirements_at_entry    <chr> "FALSE", "FALSE", "FALSE", "FALSE…
    #> $ denominator_sex                      <chr> "Both", "Both", "Both", "Both", "…
    #> $ denominator_start_date               <date> 2008-01-01, 2008-01-01, 2008-01-…
    #> $ denominator_target_cohort_name       <chr> "None", "None", "None", "None", "…
    #> $ denominator_time_at_risk             <chr> "0 to Inf", "0 to Inf", "0 to Inf…
    #> $ denominator_count                    <int> 330, 322, 326, 291, 236, 184, 142…
    #> $ outcome_count                        <int> 57, 55, 54, 56, 57, 44, 36, 27, 2…
    #> $ prevalence                           <dbl> 0.17273, 0.17081, 0.16564, 0.1924…
    #> $ prevalence_95CI_lower                <dbl> 0.13577, 0.13364, 0.12923, 0.1512…
    #> $ prevalence_95CI_upper                <dbl> 0.21722, 0.21573, 0.20985, 0.2416…
    #> $ result_type                          <chr> "tidy_prevalence", "tidy_prevalen…

With these formats it is now much easier to create custom tables, plots, or post-process are results. For a somewhat trivial example, we can use this to help us quickly add a smoothed line to our incidence results in a custom plot.
    
    
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    [asIncidenceResult](../reference/asIncidenceResult.html)(inc) |> 
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = incidence_start_date, 
                 y = incidence_100000_pys)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)() +  
      [geom_smooth](https://ggplot2.tidyverse.org/reference/geom_smooth.html)(method = "loess", se = FALSE, color = "red") +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [facet_wrap](https://ggplot2.tidyverse.org/reference/facet_wrap.html)([vars](https://ggplot2.tidyverse.org/reference/vars.html)(denominator_age_group, denominator_sex)) + 
      [ggtitle](https://ggplot2.tidyverse.org/reference/labs.html)("Smoothed incidence rates over time") +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Date") +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Incidence per 100,000 person-years")

![](a06_Working_with_IncidencePrevalence_Results_files/figure-html/unnamed-chunk-15-1.png)

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/articles/a07_benchmark.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Benchmarking the IncidencePrevalence R package

Source: [`vignettes/a07_benchmark.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a07_benchmark.Rmd)

`a07_benchmark.Rmd`

To check the performance of the IncidencePrevalence package we can use the benchmarkIncidencePrevalence(). This function generates some hypothetical study cohorts and the estimates incidence and prevalence using various settings and times how long these analyses take.

We can start for example by benchmarking our example mock data which uses duckdb.
    
    
    #> Rows: 4
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock"
    #> $ group_name       <chr> "task", "task", "task", "task"
    #> $ group_level      <chr> "generating denominator (8 cohorts)", "yearly point p…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall"
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall"
    #> $ variable_name    <chr> "overall", "overall", "overall", "overall"
    #> $ variable_level   <chr> "overall", "overall", "overall", "overall"
    #> $ estimate_name    <chr> "time_taken_minutes", "time_taken_minutes", "time_tak…
    #> $ estimate_type    <chr> "numeric", "numeric", "numeric", "numeric"
    #> $ estimate_value   <chr> "0.11", "0.05", "0.05", "0.15"
    #> $ additional_name  <chr> "dbms &&& person_n &&& min_observation_start &&& max_…
    #> $ additional_level <chr> "duckdb &&& 100 &&& 2010-01-01 &&& 2010-12-31", "duck…

We can see our results like so:

CDM name | Dbms | Person n | Min observation start | Max observation end | Estimate name | Estimate value  
---|---|---|---|---|---|---  
generating denominator (8 cohorts)  
mock | duckdb | 100 | 2010-01-01 | 2010-12-31 | time_taken_minutes | 0.11  
yearly point prevalence for two outcomes with eight denominator cohorts  
mock | duckdb | 100 | 2010-01-01 | 2010-12-31 | time_taken_minutes | 0.05  
yearly period prevalence for two outcomes with eight denominator cohorts  
mock | duckdb | 100 | 2010-01-01 | 2010-12-31 | time_taken_minutes | 0.05  
yearly incidence for two outcomes with eight denominator cohorts  
mock | duckdb | 100 | 2010-01-01 | 2010-12-31 | time_taken_minutes | 0.15  
  
## Results from test databases

Here we can see the results from the running the benchmark on test datasets on different databases management systems. These benchmarks have already been run so we’ll start by loading the results.
    
    
    #> Rows: 20
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "ohdsi_postgres", "ohdsi_postgres", "ohdsi_postgres",…
    #> $ group_name       <chr> "task", "task", "task", "task", "task", "task", "task…
    #> $ group_level      <chr> "generating denominator (8 cohorts)", "yearly point p…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_level   <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ estimate_name    <chr> "time_taken_minutes", "time_taken_minutes", "time_tak…
    #> $ estimate_type    <chr> "numeric", "numeric", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "1.55", "0.33", "0.36", "2.35", "1.39", "0.34", "0.36…
    #> $ additional_name  <chr> "dbms &&& person_n &&& min_observation_start &&& max_…
    #> $ additional_level <chr> "postgresql &&& 1000 &&& 2008-01-01 &&& 2010-12-31", …

CDM name | Dbms | Person n | Min observation start | Max observation end | Package version | Estimate name | Estimate value  
---|---|---|---|---|---|---|---  
generating denominator (8 cohorts)  
mock | duckdb | 100 | 2010-01-01 | 2010-12-31 | 1.2.1 | time_taken_minutes | 0.11  
ohdsi_postgres | postgresql | 1000 | 2008-01-01 | 2010-12-31 | 1.1.0 | time_taken_minutes | 1.55  
ohdsi_redshift | redshift | 1000 | 2007-12-15 | 2010-12-31 | 1.1.0 | time_taken_minutes | 1.39  
ohdsi_sql_Server | sql server | 1000 | 2008-01-01 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.75  
ohdsi_snowflake | snowflake | 116352 | 2007-11-27 | 2010-12-31 | 1.1.0 | time_taken_minutes | 2.17  
darwin_databricks_spark | spark | 2694 | 1908-09-22 | 2019-07-03 | 1.1.0 | time_taken_minutes | 4.71  
yearly point prevalence for two outcomes with eight denominator cohorts  
mock | duckdb | 100 | 2010-01-01 | 2010-12-31 | 1.2.1 | time_taken_minutes | 0.05  
ohdsi_postgres | postgresql | 1000 | 2008-01-01 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.33  
ohdsi_redshift | redshift | 1000 | 2007-12-15 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.34  
ohdsi_sql_Server | sql server | 1000 | 2008-01-01 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.20  
ohdsi_snowflake | snowflake | 116352 | 2007-11-27 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.82  
darwin_databricks_spark | spark | 2694 | 1908-09-22 | 2019-07-03 | 1.1.0 | time_taken_minutes | 0.93  
yearly period prevalence for two outcomes with eight denominator cohorts  
mock | duckdb | 100 | 2010-01-01 | 2010-12-31 | 1.2.1 | time_taken_minutes | 0.05  
ohdsi_postgres | postgresql | 1000 | 2008-01-01 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.36  
ohdsi_redshift | redshift | 1000 | 2007-12-15 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.36  
ohdsi_sql_Server | sql server | 1000 | 2008-01-01 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.21  
ohdsi_snowflake | snowflake | 116352 | 2007-11-27 | 2010-12-31 | 1.1.0 | time_taken_minutes | 0.59  
darwin_databricks_spark | spark | 2694 | 1908-09-22 | 2019-07-03 | 1.1.0 | time_taken_minutes | 1.03  
yearly incidence for two outcomes with eight denominator cohorts  
mock | duckdb | 100 | 2010-01-01 | 2010-12-31 | 1.2.1 | time_taken_minutes | 0.15  
ohdsi_postgres | postgresql | 1000 | 2008-01-01 | 2010-12-31 | 1.1.0 | time_taken_minutes | 2.35  
ohdsi_redshift | redshift | 1000 | 2007-12-15 | 2010-12-31 | 1.1.0 | time_taken_minutes | 2.58  
ohdsi_sql_Server | sql server | 1000 | 2008-01-01 | 2010-12-31 | 1.1.0 | time_taken_minutes | 1.08  
ohdsi_snowflake | snowflake | 116352 | 2007-11-27 | 2010-12-31 | 1.1.0 | time_taken_minutes | 5.36  
darwin_databricks_spark | spark | 2694 | 1908-09-22 | 2019-07-03 | 1.1.0 | time_taken_minutes | 5.61  
  
## Results from real databases

Above we’ve seen performance on small test databases. However, more interesting is to know how the package performs on our actual patient-level data, which is often much larger. Below our results from running our benchmarking tasks against real patient datasets.

CDM name | Dbms | Person n | Min observation start | Max observation end | Package version | Estimate name | Estimate value  
---|---|---|---|---|---|---|---  
generating denominator (8 cohorts)  
CPRD GOLD | postgresql | 17521504 | 1987-09-09 | 2024-06-15 | 1.1.0 | time_taken_minutes | 31.06  
yearly point prevalence for two outcomes with eight denominator cohorts  
CPRD GOLD | postgresql | 17521504 | 1987-09-09 | 2024-06-15 | 1.1.0 | time_taken_minutes | 14.08  
yearly period prevalence for two outcomes with eight denominator cohorts  
CPRD GOLD | postgresql | 17521504 | 1987-09-09 | 2024-06-15 | 1.1.0 | time_taken_minutes | 14.78  
yearly incidence for two outcomes with eight denominator cohorts  
CPRD GOLD | postgresql | 17521504 | 1987-09-09 | 2024-06-15 | 1.1.0 | time_taken_minutes | 64.51  
  
## Sharing your benchmarking results

Sharing your benchmark results will help us improve the package. To run the benchmark, connect to your database and create your cdm reference. Then run the benchmark like below and export the results as a csv.

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/news/index.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/NEWS.md)

## IncidencePrevalence 1.2.0

CRAN release: 2025-03-08

  * Added argument censortTable and censorCohortId arguments to estimateIncidence



## IncidencePrevalence 1.1.0

CRAN release: 2025-02-20

  * Added argument requirementsAtEntry to generateTargetDenominatorCohortSet



## IncidencePrevalence 1.0.0

CRAN release: 2025-01-16

  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/mockIncidencePrevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Generate example subset of the OMOP CDM for estimating incidence and prevalence

Source: [`R/mockIncidencePrevalence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/mockIncidencePrevalence.R)

`mockIncidencePrevalence.Rd`

Generate example subset of the OMOP CDM for estimating incidence and prevalence

## Usage
    
    
    mockIncidencePrevalence(
      personTable = NULL,
      observationPeriodTable = NULL,
      targetCohortTable = NULL,
      outcomeTable = NULL,
      censorTable = NULL,
      sampleSize = 1,
      outPre = 1,
      seed = 444,
      earliestDateOfBirth = NULL,
      latestDateOfBirth = NULL,
      earliestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
      latestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      minDaysToObservationEnd = 1,
      maxDaysToObservationEnd = 4380,
      minOutcomeDays = 1,
      maxOutcomeDays = 10,
      maxOutcomes = 1
    )

## Arguments

personTable
    

A tibble in the format of the person table.

observationPeriodTable
    

A tibble in the format of the observation period table.

targetCohortTable
    

A tibble in the format of a cohort table which can be used for stratification

outcomeTable
    

A tibble in the format of a cohort table which can be used for outcomes

censorTable
    

A tibble in the format of a cohort table which can be used for censoring

sampleSize
    

The number of unique patients.

outPre
    

The fraction of patients with an event.

seed
    

The seed for simulating the data set. Use the same seed to get same data set.

earliestDateOfBirth
    

The earliest date of birth of a patient in person table.

latestDateOfBirth
    

The latest date of birth of a patient in person table.

earliestObservationStartDate
    

The earliest observation start date for patient format.

latestObservationStartDate
    

The latest observation start date for patient format.

minDaysToObservationEnd
    

The minimum number of days of the observational integer.

maxDaysToObservationEnd
    

The maximum number of days of the observation period integer.

minOutcomeDays
    

The minimum number of days of the outcome period default set to 1.

maxOutcomeDays
    

The maximum number of days of the outcome period default set to 10.

maxOutcomes
    

The maximum possible number of outcomes per person can have default set to 1.

## Value

A cdm reference to a duckdb database with mock data.

## Examples
    
    
    # \donttest{
    cdm <- mockIncidencePrevalence(sampleSize = 100)
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock ───────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: censor, outcome, target
    #> • achilles tables: -
    #> • other tables: -
    # }
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/generateDenominatorCohortSet.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Identify a set of denominator populations

Source: [`R/generateDenominatorCohortSet.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/generateDenominatorCohortSet.R)

`generateDenominatorCohortSet.Rd`

`generateDenominatorCohortSet()` creates a set of cohorts that can be used for the denominator population in analyses of incidence, using `[estimateIncidence()](estimateIncidence.html)`, or prevalence, using `[estimatePointPrevalence()](estimatePointPrevalence.html)` or `[estimatePeriodPrevalence()](estimatePeriodPrevalence.html)`.

## Usage
    
    
    generateDenominatorCohortSet(
      cdm,
      name,
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA)),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0,
      requirementInteractions = TRUE
    )

## Arguments

cdm
    

A CDM reference object

name
    

Name of the cohort table to be created. Note if a table already exists with this name in the database (give the prefix being used for the cdm reference) it will be overwritten.

cohortDateRange
    

Two dates. The first indicating the earliest cohort start date and the second indicating the latest possible cohort end date. If NULL or the first date is set as missing, the earliest observation_start_date in the observation_period table will be used for the former. If NULL or the second date is set as missing, the latest observation_end_date in the observation_period table will be used for the latter.

ageGroup
    

A list of age groups for which cohorts will be generated. A value of `list(c(0,17), c(18,30))` would, for example, lead to the creation of cohorts for those aged from 0 to 17, and from 18 to 30. In this example an individual turning 18 during the time period would appear in both cohorts (leaving the first cohort the day before their 18th birthday and entering the second from the day of their 18th birthday).

sex
    

Sex of the cohorts. This can be one or more of: `"Male"`, `"Female"`, or `"Both"`.

daysPriorObservation
    

The number of days of prior observation observed in the database required for an individual to start contributing time in a cohort.

requirementInteractions
    

If TRUE, cohorts will be created for all combinations of ageGroup, sex, and daysPriorObservation. If FALSE, only the first value specified for the other factors will be used. Consequently, order of values matters when requirementInteractions is FALSE.

## Value

A cdm reference

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- generateDenominatorCohortSet(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2008-01-01", "2020-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 3 sec
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock ───────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: censor, denominator, outcome, target
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/estimateIncidence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Collect population incidence estimates

Source: [`R/estimateIncidence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/estimateIncidence.R)

`estimateIncidence.Rd`

Collect population incidence estimates

## Usage
    
    
    estimateIncidence(
      cdm,
      denominatorTable,
      outcomeTable,
      censorTable = NULL,
      denominatorCohortId = NULL,
      outcomeCohortId = NULL,
      censorCohortId = NULL,
      interval = "years",
      completeDatabaseIntervals = TRUE,
      outcomeWashout = Inf,
      repeatedEvents = FALSE,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      includeOverallStrata = TRUE
    )

## Arguments

cdm
    

A CDM reference object

denominatorTable
    

A cohort table with a set of denominator cohorts (for example, created using the `[generateDenominatorCohortSet()](generateDenominatorCohortSet.html)` function).

outcomeTable
    

A cohort table in the cdm reference containing a set of outcome cohorts.

censorTable
    

A cohort table in the cdm reference containing a cohort to be used for censoring. Individuals will stop contributing time at risk from the date of their first record in the censor cohort. If they appear in the censor cohort before entering the denominator cohort they will be excluded. The censor cohort can only contain one record per individual.

denominatorCohortId
    

The cohort definition ids or the cohort names of the denominator cohorts of interest. If NULL all cohorts will be considered in the analysis.

outcomeCohortId
    

The cohort definition ids or the cohort names of the outcome cohorts of interest. If NULL all cohorts will be considered in the analysis.

censorCohortId
    

The cohort definition id or the cohort name of the cohort to be used for censoring. Must be specified if there are multiple cohorts in the censor table.

interval
    

Time intervals over which incidence is estimated. Can be "weeks", "months", "quarters", "years", or "overall". ISO weeks will be used for weeks. Calendar months, quarters, or years can be used, or an overall estimate for the entire time period observed (from earliest cohort start to last cohort end) can also be estimated. If more than one option is chosen then results will be estimated for each chosen interval.

completeDatabaseIntervals
    

TRUE/ FALSE. Where TRUE, incidence will only be estimated for those intervals where the denominator cohort captures all the interval.

outcomeWashout
    

The number of days used for a 'washout' period between the end of one outcome and an individual starting to contribute time at risk. If Inf, no time can be contributed after an event has occurred.

repeatedEvents
    

TRUE/ FALSE. If TRUE, an individual will be able to contribute multiple events during the study period (time while they are present in an outcome cohort and any subsequent washout will be excluded). If FALSE, an individual will only contribute time up to their first event.

strata
    

Variables added to the denominator cohort table for which to stratify estimates.

includeOverallStrata
    

Whether to include an overall result as well as strata specific results (when strata has been specified).

## Value

Incidence estimates

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 3 sec
    inc <- estimateIncidence(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/plotIncidence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Plot incidence results

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`plotIncidence.Rd`

Plot incidence results

## Usage
    
    
    plotIncidence(
      result,
      x = "incidence_start_date",
      y = "incidence_100000_pys",
      line = FALSE,
      point = TRUE,
      ribbon = FALSE,
      ymin = "incidence_100000_pys_95CI_lower",
      ymax = "incidence_100000_pys_95CI_upper",
      facet = NULL,
      colour = NULL
    )

## Arguments

result
    

Incidence results

x
    

Variable to plot on x axis

y
    

Variable to plot on y axis.

line
    

Whether to plot a line using `geom_line`

point
    

Whether to plot points using `geom_point`

ribbon
    

Whether to plot a ribbon using `geom_ribbon`

ymin
    

Lower limit of error bars, if provided is plot using `geom_errorbar`

ymax
    

Upper limit of error bars, if provided is plot using `geom_errorbar`

facet
    

Variables to use for facets. To see available variables for facetting use the function `[availableIncidenceGrouping()](availableIncidenceGrouping.html)`.

colour
    

Variables to use for colours. To see available variables for colouring use the function `[availableIncidenceGrouping()](availableIncidenceGrouping.html)`.

## Value

A ggplot with the incidence results plotted

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    inc <- [estimateIncidence](estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    plotIncidence(inc)
    ![](plotIncidence-1.png)
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/estimatePointPrevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Estimate point prevalence

Source: [`R/estimatePrevalence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/estimatePrevalence.R)

`estimatePointPrevalence.Rd`

Estimate point prevalence

## Usage
    
    
    estimatePointPrevalence(
      cdm,
      denominatorTable,
      outcomeTable,
      denominatorCohortId = NULL,
      outcomeCohortId = NULL,
      interval = "years",
      timePoint = "start",
      strata = [list](https://rdrr.io/r/base/list.html)(),
      includeOverallStrata = TRUE
    )

## Arguments

cdm
    

A CDM reference object

denominatorTable
    

A cohort table with a set of denominator cohorts (for example, created using the `[generateDenominatorCohortSet()](generateDenominatorCohortSet.html)` function).

outcomeTable
    

A cohort table in the cdm reference containing a set of outcome cohorts.

denominatorCohortId
    

The cohort definition ids or the cohort names of the denominator cohorts of interest. If NULL all cohorts will be considered in the analysis.

outcomeCohortId
    

The cohort definition ids or the cohort names of the outcome cohorts of interest. If NULL all cohorts will be considered in the analysis.

interval
    

Time intervals over which period prevalence is estimated. Can be "weeks", "months", "quarters", or "years". ISO weeks will be used for weeks. Calendar months, quarters, or years can be used as the period. If more than one option is chosen then results will be estimated for each chosen interval.

timePoint
    

where to compute the point prevalence

strata
    

Variables added to the denominator cohort table for which to stratify estimates.

includeOverallStrata
    

Whether to include an overall result as well as strata specific results (when strata has been specified).

## Value

Point prevalence estimates

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    estimatePointPrevalence(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "months"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 1 secs
    #> # A tibble: 649 × 13
    #>    result_id cdm_name group_name            group_level strata_name strata_level
    #>        <int> <chr>    <chr>                 <chr>       <chr>       <chr>       
    #>  1         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  2         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  3         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  4         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  5         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  6         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  7         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  8         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  9         1 mock     denominator_cohort_n… denominato… overall     overall     
    #> 10         1 mock     denominator_cohort_n… denominato… overall     overall     
    #> # ℹ 639 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/plotPrevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Plot prevalence results

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`plotPrevalence.Rd`

Plot prevalence results

## Usage
    
    
    plotPrevalence(
      result,
      x = "prevalence_start_date",
      y = "prevalence",
      line = FALSE,
      point = TRUE,
      ribbon = FALSE,
      ymin = "prevalence_95CI_lower",
      ymax = "prevalence_95CI_upper",
      facet = NULL,
      colour = NULL
    )

## Arguments

result
    

Prevalence results

x
    

Variable to plot on x axis

y
    

Variable to plot on y axis.

line
    

Whether to plot a line using `geom_line`

point
    

Whether to plot points using `geom_point`

ribbon
    

Whether to plot a ribbon using `geom_ribbon`

ymin
    

Lower limit of error bars, if provided is plot using `geom_errorbar`

ymax
    

Upper limit of error bars, if provided is plot using `geom_errorbar`

facet
    

Variables to use for facets. To see available variables for facetting use the function `[availablePrevalenceGrouping()](availablePrevalenceGrouping.html)`.

colour
    

Variables to use for colours. To see available variables for colouring use the function `[availablePrevalenceGrouping()](availablePrevalenceGrouping.html)`.

## Value

A ggplot with the prevalence results plotted

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2014-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    prev <- [estimatePointPrevalence](estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 0 secs
    plotPrevalence(prev)
    ![](plotPrevalence-1.png)
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/estimatePeriodPrevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Estimate period prevalence

Source: [`R/estimatePrevalence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/estimatePrevalence.R)

`estimatePeriodPrevalence.Rd`

Estimate period prevalence

## Usage
    
    
    estimatePeriodPrevalence(
      cdm,
      denominatorTable,
      outcomeTable,
      denominatorCohortId = NULL,
      outcomeCohortId = NULL,
      interval = "years",
      completeDatabaseIntervals = TRUE,
      fullContribution = FALSE,
      level = "person",
      strata = [list](https://rdrr.io/r/base/list.html)(),
      includeOverallStrata = TRUE
    )

## Arguments

cdm
    

A CDM reference object

denominatorTable
    

A cohort table with a set of denominator cohorts (for example, created using the `[generateDenominatorCohortSet()](generateDenominatorCohortSet.html)` function).

outcomeTable
    

A cohort table in the cdm reference containing a set of outcome cohorts.

denominatorCohortId
    

The cohort definition ids or the cohort names of the denominator cohorts of interest. If NULL all cohorts will be considered in the analysis.

outcomeCohortId
    

The cohort definition ids or the cohort names of the outcome cohorts of interest. If NULL all cohorts will be considered in the analysis.

interval
    

Time intervals over which period prevalence is estimated. This can be "weeks", "months", "quarters", "years", or "overall". ISO weeks will be used for weeks. Calendar months, quarters, or years can be used as the period. If more than one option is chosen then results will be estimated for each chosen interval.

completeDatabaseIntervals
    

TRUE/ FALSE. Where TRUE, prevalence will only be estimated for those intervals where the database captures all the interval (based on the earliest and latest observation period start dates, respectively).

fullContribution
    

TRUE/ FALSE. Where TRUE, individuals will only be included if they in the database for the entire interval of interest. If FALSE they are only required to present for one day of the interval in order to contribute.

level
    

Can be "person" or "record". When estimating at the record level, each span of time contributed in the denominator will be considered separately (e.g. so as to estimate prevalence at the episode level). When estimating at the person level, multiple entries for a person will be considered together.

strata
    

Variables added to the denominator cohort table for which to stratify estimates.

includeOverallStrata
    

Whether to include an overall result as well as strata specific results (when strata has been specified).

## Value

Period prevalence estimates

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    estimatePeriodPrevalence(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "months"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 1 secs
    #> # A tibble: 644 × 13
    #>    result_id cdm_name group_name            group_level strata_name strata_level
    #>        <int> <chr>    <chr>                 <chr>       <chr>       <chr>       
    #>  1         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  2         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  3         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  4         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  5         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  6         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  7         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  8         1 mock     denominator_cohort_n… denominato… overall     overall     
    #>  9         1 mock     denominator_cohort_n… denominato… overall     overall     
    #> 10         1 mock     denominator_cohort_n… denominato… overall     overall     
    #> # ℹ 634 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/LICENSE.html

Skip to contents

[IncidencePrevalence](index.html) 1.2.1

  * [Reference](reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](articles/a07_benchmark.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](logo.png)

# Apache License

Source: [`LICENSE.md`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/LICENSE.md)

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

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/CONTRIBUTING.html

Skip to contents

[IncidencePrevalence](index.html) 1.2.1

  * [Reference](reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](articles/a07_benchmark.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](logo.png)

# Contributing to IncidencePrevalence

Source: [`.github/CONTRIBUTING.md`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/.github/CONTRIBUTING.md)

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated. Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

## Contributing code or documentation

> This package has been developed as part of the DARWIN EU(R) project and is closed to external contributions.

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
    # detach("package:IncidencePrevalence", unload=TRUE)
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

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/authors.html

Skip to contents

[IncidencePrevalence](index.html) 1.2.1

  * [Reference](reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](articles/a07_benchmark.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](logo.png)

# Authors and Citation

## Authors

  * **Edward Burn**. Author, maintainer. [](https://orcid.org/0000-0002-9286-1128)

  * **Berta Raventos**. Author. [](https://orcid.org/0000-0002-4668-2970)

  * **Martí Català**. Author. [](https://orcid.org/0000-0003-3308-9905)

  * **Mike Du**. Contributor. [](https://orcid.org/0000-0002-9517-8834)

  * **Yuchen Guo**. Contributor. [](https://orcid.org/0000-0002-0847-4855)

  * **Adam Black**. Contributor. [](https://orcid.org/0000-0001-5576-8701)

  * **Ger Inberg**. Contributor. [](https://orcid.org/0000-0001-8993-8748)

  * **Kim Lopez**. Contributor. [](https://orcid.org/0000-0002-8462-8668)




## Citation

Source: [`inst/CITATION`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/inst/CITATION)

Raventós B, Català M, Du M, Guo Y, Black A, Inberg G, Li X, López-Güell K, Newby D, de Ridder M, Barboza C, Duarte-Salles T, Verhamme K, Rijnbeek P, Prieto-Alhambra D, Burn E (2024). “IncidencePrevalence: An R package to calculate population-level incidence rates and prevalence using the OMOP common data model.” _Pharmacoepidemiology and Drug Safety_ , **33**(1), e5717. 
    
    
    @Article{,
      author = {Berta Raventós and Martí Català and Mike Du and Yuchen Guo and Adam Black and Ger Inberg and Xintong Li and Kim López-Güell and Danielle Newby and Maria {de Ridder} and Cesar Barboza and Talita Duarte-Salles and Katia Verhamme and Peter Rijnbeek and Daniel Prieto-Alhambra and Edward Burn},
      title = {IncidencePrevalence: An R package to calculate population-level incidence rates and prevalence using the OMOP common data model},
      journal = {Pharmacoepidemiology and Drug Safety},
      volume = {33},
      number = {1},
      pages = {e5717},
      keywords = {common data model, incidence, OMOP, prevalence, R package},
      year = {2024},
    }

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/generateTargetDenominatorCohortSet.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Identify a set of denominator populations using a target cohort

Source: [`R/generateDenominatorCohortSet.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/generateDenominatorCohortSet.R)

`generateTargetDenominatorCohortSet.Rd`

`generateTargetDenominatorCohortSet()` creates a set of cohorts that can be used for the denominator population in analyses of incidence, using `[estimateIncidence()](estimateIncidence.html)`, or prevalence, using `[estimatePointPrevalence()](estimatePointPrevalence.html)` or `[estimatePeriodPrevalence()](estimatePeriodPrevalence.html)`.

## Usage
    
    
    generateTargetDenominatorCohortSet(
      cdm,
      name,
      targetCohortTable,
      targetCohortId = NULL,
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA)),
      timeAtRisk = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0,
      requirementsAtEntry = TRUE,
      requirementInteractions = TRUE
    )

## Arguments

cdm
    

A CDM reference object

name
    

Name of the cohort table to be created.

targetCohortTable
    

A cohort table in the cdm reference to use to limit cohort entry and exit (with individuals only contributing to a cohort when they are contributing to the cohort in the target table).

targetCohortId
    

The cohort definition ids or the cohort names of the cohorts of interest for the target table. If NULL all cohorts will be considered in the analysis.

cohortDateRange
    

Two dates. The first indicating the earliest cohort start date and the second indicating the latest possible cohort end date. If NULL or the first date is set as missing, the earliest observation_start_date in the observation_period table will be used for the former. If NULL or the second date is set as missing, the latest observation_end_date in the observation_period table will be used for the latter.

timeAtRisk
    

Lower and upper bound for the time at risk window to apply relative to the target cohort entry. A value of list(c(0, 30), c(31, 60)) would, for example, create one set of denominator cohorts with time up to the 30 days following target cohort entry and another set with time from 31 days following entry to 60 days. If time at risk start is after target cohort exit and/ or observation period end then no time will be contributed. If time at risk end is after cohort exit and/ or observation period, then only time up to these will be contributed.

ageGroup
    

A list of age groups for which cohorts will be generated. A value of `list(c(0,17), c(18,30))` would, for example, lead to the creation of cohorts for those aged from 0 to 17, and from 18 to 30.

sex
    

Sex of the cohorts. This can be one or more of: `"Male"`, `"Female"`, or `"Both"`.

daysPriorObservation
    

The number of days of prior observation observed in the database required for an individual to start contributing time in a cohort.

requirementsAtEntry
    

If TRUE, individuals must satisfy requirements for inclusion on their cohort start date for the target cohort. If FALSE, individuals will be included once they satisfy all requirements.

requirementInteractions
    

If TRUE, cohorts will be created for all combinations of ageGroup, sex, and daysPriorObservation. If FALSE, only the first value specified for the other factors will be used. Consequently, order of values matters when requirementInteractions is FALSE.

## Value

A cdm reference

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- generateTargetDenominatorCohortSet(
      cdm = cdm,
      name = "denominator",
      targetCohortTable = "target",
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2008-01-01", "2020-01-01"))
    )
    #> ℹ Creating denominator cohorts: target cohort id 1
    #> ✔ Cohorts created in 0 min and 3 sec
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock ───────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: censor, denominator, outcome, target
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/asIncidenceResult.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# A tidy implementation of the summarised_result object for incidence results.

Source: [`R/tidyResults.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tidyResults.R)

`asIncidenceResult.Rd`

A tidy implementation of the summarised_result object for incidence results.

## Usage
    
    
    asIncidenceResult(result, metadata = FALSE)

## Arguments

result
    

A summarised_result object created by the IncidencePrevalence package.

metadata
    

If TRUE additional metadata columns will be included in the result.

## Value

A tibble with a tidy version of the summarised_result object.

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)()
    inc <- [estimateIncidence](estimateIncidence.html)(cdm, "target", "outcome")
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    tidy_inc <- asIncidenceResult(inc)
    # }
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/asPrevalenceResult.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# A tidy implementation of the summarised_result object for prevalence results.

Source: [`R/tidyResults.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tidyResults.R)

`asPrevalenceResult.Rd`

A tidy implementation of the summarised_result object for prevalence results.

## Usage
    
    
    asPrevalenceResult(result, metadata = FALSE)

## Arguments

result
    

A summarised_result object created by the IncidencePrevalence package.

metadata
    

If TRUE additional metadata columns will be included in the result.

## Value

A tibble with a tidy version of the summarised_result object.

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)()
    prev <- [estimatePointPrevalence](estimatePointPrevalence.html)(cdm, "target", "outcome")
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 0 secs
    tidy_prev <- asPrevalenceResult(prev)
    # }
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/availableIncidenceGrouping.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Variables that can be used for faceting and colouring incidence plots

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`availableIncidenceGrouping.Rd`

Variables that can be used for faceting and colouring incidence plots

## Usage
    
    
    availableIncidenceGrouping(result, varying = FALSE)

## Arguments

result
    

Incidence results

varying
    

If FALSE, only variables with non-unique values will be returned, otherwise all available variables will be returned

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2014-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    inc <- [estimateIncidence](estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    availableIncidenceGrouping(inc)
    #> character(0)
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/availablePrevalenceGrouping.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Variables that can be used for faceting and colouring prevalence plots

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`availablePrevalenceGrouping.Rd`

Variables that can be used for faceting and colouring prevalence plots

## Usage
    
    
    availablePrevalenceGrouping(result, varying = FALSE)

## Arguments

result
    

Prevalence results

varying
    

If FALSE, only variables with non-unique values will be returned, otherwise all available variables will be returned

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2014-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 3 sec
    prev <- [estimatePointPrevalence](estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 0 secs
    availablePrevalenceGrouping(prev)
    #> character(0)
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/plotIncidencePopulation.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Bar plot of denominator counts, outcome counts, and person-time from incidence results

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`plotIncidencePopulation.Rd`

Bar plot of denominator counts, outcome counts, and person-time from incidence results

## Usage
    
    
    plotIncidencePopulation(
      result,
      x = "incidence_start_date",
      y = "denominator_count",
      facet = NULL,
      colour = NULL
    )

## Arguments

result
    

Incidence results

x
    

Variable to plot on x axis

y
    

Variable to plot on y axis.

facet
    

Variables to use for facets. To see available variables for facetting use the functions `[availableIncidenceGrouping()](availableIncidenceGrouping.html)`.

colour
    

Variables to use for colours. To see available variables for colouring use the function `[availableIncidenceGrouping()](availableIncidenceGrouping.html)`.

## Value

A ggplot object

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2014-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    inc <- [estimateIncidence](estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    plotIncidencePopulation(inc)
    ![](plotIncidencePopulation-1.png)
    # }
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/plotPrevalencePopulation.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Bar plot of denominator and outcome counts from prevalence results

Source: [`R/plotting.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/plotting.R)

`plotPrevalencePopulation.Rd`

Bar plot of denominator and outcome counts from prevalence results

## Usage
    
    
    plotPrevalencePopulation(
      result,
      x = "prevalence_start_date",
      y = "denominator_count",
      facet = NULL,
      colour = NULL
    )

## Arguments

result
    

Prevalence results

x
    

Variable to plot on x axis

y
    

Variable to plot on y axis.

facet
    

Variables to use for facets. To see available variables for facetting use the functions `[availablePrevalenceGrouping()](availablePrevalenceGrouping.html)`.

colour
    

Variables to use for colours. To see available variables for colouring use the function `[availablePrevalenceGrouping()](availablePrevalenceGrouping.html)`.

## Value

A ggplot object

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2014-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    prev <- [estimatePointPrevalence](estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 0 secs
    plotPrevalencePopulation(prev)
    ![](plotPrevalencePopulation-1.png)
    # }
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/optionsTableIncidence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Additional arguments for the functions tableIncidence.

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`optionsTableIncidence.Rd`

It provides a list of allowed inputs for .option argument in tableIncidence, and their given default values.

## Usage
    
    
    optionsTableIncidence()

## Value

The default .options named list.

## Examples
    
    
    {
      optionsTableIncidence()
    }
    #> $decimals
    #>    integer percentage    numeric proportion 
    #>          0          2          2          2 
    #> 
    #> $decimalMark
    #> [1] "."
    #> 
    #> $bigMark
    #> [1] ","
    #> 
    #> $keepNotFormatted
    #> [1] FALSE
    #> 
    #> $useFormatOrder
    #> [1] TRUE
    #> 
    #> $delim
    #> [1] "\n"
    #> 
    #> $includeHeaderName
    #> [1] TRUE
    #> 
    #> $includeHeaderKey
    #> [1] TRUE
    #> 
    #> $na
    #> [1] "-"
    #> 
    #> $title
    #> NULL
    #> 
    #> $subtitle
    #> NULL
    #> 
    #> $caption
    #> NULL
    #> 
    #> $groupAsColumn
    #> [1] FALSE
    #> 
    #> $groupOrder
    #> NULL
    #> 
    #> $merge
    #> [1] "all_columns"
    #> 
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/optionsTablePrevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Additional arguments for the functions tablePrevalence.

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`optionsTablePrevalence.Rd`

It provides a list of allowed inputs for .option argument in tablePrevalence, and their given default values.

## Usage
    
    
    optionsTablePrevalence()

## Value

The default .options named list.

## Examples
    
    
    {
      optionsTablePrevalence()
    }
    #> $decimals
    #>    integer percentage    numeric proportion 
    #>          0          2          2          2 
    #> 
    #> $decimalMark
    #> [1] "."
    #> 
    #> $bigMark
    #> [1] ","
    #> 
    #> $keepNotFormatted
    #> [1] TRUE
    #> 
    #> $useFormatOrder
    #> [1] TRUE
    #> 
    #> $delim
    #> [1] "\n"
    #> 
    #> $includeHeaderName
    #> [1] TRUE
    #> 
    #> $includeHeaderKey
    #> [1] TRUE
    #> 
    #> $na
    #> [1] "-"
    #> 
    #> $title
    #> NULL
    #> 
    #> $subtitle
    #> NULL
    #> 
    #> $caption
    #> NULL
    #> 
    #> $groupAsColumn
    #> [1] FALSE
    #> 
    #> $groupOrder
    #> NULL
    #> 
    #> $merge
    #> [1] "all_columns"
    #> 
    
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/tableIncidence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Table of incidence results

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`tableIncidence.Rd`

Table of incidence results

## Usage
    
    
    tableIncidence(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("estimate_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
      settingsColumn = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"),
      hide = [c](https://rdrr.io/r/base/c.html)("denominator_cohort_name", "analysis_interval"),
      style = "default",
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

Incidence results

type
    

Type of table. Can be "gt", "flextable", or "tibble"

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "denominator_cohort_name", "outcome_cohort_name", "incidence_start_date", "incidence_end_date", "estimate_name", variables in the `strata_name` column, and any of the settings columns specified in `settingsColumn` argument. The header can also include other names to use as overall header labels

groupColumn
    

Variables to use as group labels. Allowed columns are the same as in `header`

settingsColumn
    

Variables from the settings attribute to display in the table

hide
    

Table columns to exclude, options are the ones described in `header`

style
    

A style supported by visOmopResults::visOmopTable()

.options
    

Table options to apply

## Value

Table of results

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 3 sec
    inc <- [estimateIncidence](estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    tableIncidence(inc)
    
    
    
    
      Incidence start date
          | Incidence end date
          | Denominator age group
          | Denominator sex
          | 
            Estimate name
          
          
    ---|---|---|---|---  
    Denominator (N)
          | Person-years
          | Outcome (N)
          | Incidence 100,000 person-years [95% CI]
          
    mock; cohort_1
          
    2008-01-01
    | 2008-12-31
    | 0 to 150
    | Both
    | 42
    | 33.05
    | 9
    | 27,230.64 (12,451.58 -
          51,692.24)  
    2009-01-01
    | 2009-12-31
    | 0 to 150
    | Both
    | 38
    | 28.74
    | 13
    | 45,229.98 (24,083.06 -
          77,344.64)  
    2010-01-01
    | 2010-12-31
    | 0 to 150
    | Both
    | 25
    | 19.69
    | 8
    | 40,623.57 (17,538.38 -
          80,044.63)  
    2011-01-01
    | 2011-12-31
    | 0 to 150
    | Both
    | 17
    | 11.57
    | 7
    | 60,485.61 (24,318.35 -
          124,623.48)  
    2012-01-01
    | 2012-12-31
    | 0 to 150
    | Both
    | 10
    | 9.86
    | 1
    | 10,137.88 (256.67 -
          56,484.62)  
    2013-01-01
    | 2013-12-31
    | 0 to 150
    | Both
    | 9
    | 8.74
    | 1
    | 11,446.89 (289.81 -
          63,777.97)  
    2014-01-01
    | 2014-12-31
    | 0 to 150
    | Both
    | 8
    | 6.36
    | 2
    | 31,461.38 (3,810.12 -
          113,649.33)  
    2015-01-01
    | 2015-12-31
    | 0 to 150
    | Both
    | 6
    | 3.86
    | 4
    | 103,761.35 (28,271.47 -
          265,670.26)  
    2016-01-01
    | 2016-12-31
    | 0 to 150
    | Both
    | 2
    | 1.11
    | 1
    | 90,415.91 (2,289.13 -
          503,765.22)  
      
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/tableIncidenceAttrition.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Table of incidence attrition results

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`tableIncidenceAttrition.Rd`

Table of incidence attrition results

## Usage
    
    
    tableIncidenceAttrition(
      result,
      type = "gt",
      header = "variable_name",
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
      settingsColumn = NULL,
      hide = [c](https://rdrr.io/r/base/c.html)("denominator_cohort_name", "estimate_name", "reason_id", "variable_level"),
      style = "default"
    )

## Arguments

result
    

A summarised_result object. Output of summariseCohortAttrition().

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `colnames(omopgenerics::splitAll(result))`. Variables in `settingsColumn` are also allowed

groupColumn
    

Variables to use as group labels. Allowed columns are the same as in `header`

settingsColumn
    

Variables from the settings attribute to display in the table

hide
    

Table columns to exclude, options are the ones described in `header`

style
    

A style supported by visOmopResults::visOmopTable()

## Value

A visual table.

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    inc <- [estimateIncidence](estimateIncidence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome"
    )
    #> ℹ Getting incidence for analysis 1 of 1
    #> ✔ Overall time taken: 0 mins and 1 secs
    tableIncidenceAttrition(inc)
    
    
    
    
      Reason
          | 
            Variable name
          
          
    ---|---  
    Number records
          | Number subjects
          | Excluded records
          | Excluded subjects
          
    mock; cohort_1
          
    Starting population
    | 1,000
    | 1,000
    | -
    | -  
    Missing year of birth
    | 1,000
    | 1,000
    | 0
    | 0  
    Missing sex
    | 1,000
    | 1,000
    | 0
    | 0  
    Cannot satisfy age criteria during the study period based on year of birth
    | 1,000
    | 1,000
    | 0
    | 0  
    No observation time available during study period
    | 70
    | 70
    | 930
    | 930  
    Doesn't satisfy age criteria during the study period
    | 70
    | 70
    | 0
    | 0  
    Prior history requirement not fulfilled during study period
    | 70
    | 70
    | 0
    | 0  
    No observation time available after applying age, prior observation and, if applicable, target criteria
    | 70
    | 70
    | 0
    | 0  
    Starting analysis population
    | 70
    | 70
    | -
    | -  
    Apply washout - anyone with outcome prior to start excluded
    | 47
    | 47
    | 23
    | 23  
    Not observed during the complete database interval
    | 47
    | 47
    | 0
    | 0  
      
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/tablePrevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Table of prevalence results

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`tablePrevalence.Rd`

Table of prevalence results

## Usage
    
    
    tablePrevalence(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("estimate_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
      settingsColumn = [c](https://rdrr.io/r/base/c.html)("denominator_age_group", "denominator_sex"),
      hide = [c](https://rdrr.io/r/base/c.html)("denominator_cohort_name", "analysis_interval"),
      style = "default",
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

Prevalence results

type
    

Type of table. Can be "gt", "flextable", or "tibble"

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "denominator_cohort_name", "outcome_cohort_name", "prevalence_start_date", "prevalence_end_date", "estimate_name", variables in the `strata_name` column, and any of the settings columns specified in `settingsColumn` argument. The header can also include other names to use as overall header labels

groupColumn
    

Variables to use as group labels. Allowed columns are the same as in `header`

settingsColumn
    

Variables from the settings attribute to display in the table

hide
    

Table columns to exclude, options are the ones described in `header`

style
    

A style supported by visOmopResults::visOmopTable()

.options
    

Table options to apply

## Value

Table of prevalence results

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    prev <- [estimatePointPrevalence](estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "months"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 1 secs
    tablePrevalence(prev)
    
    
    
    
      Prevalence start date
          | Prevalence end date
          | Denominator age group
          | Denominator sex
          | 
            Estimate name
          
          
    ---|---|---|---|---  
    Denominator (N)
          | Outcome (N)
          | Prevalence [95% CI]
          
    mock; cohort_1
          
    2008-01-01
    | 2008-01-01
    | 0 to 150
    | Both
    | 55
    | 0
    | 0.00 (0.00 - 0.07)  
    2008-02-01
    | 2008-02-01
    | 0 to 150
    | Both
    | 55
    | 0
    | 0.00 (0.00 - 0.07)  
    2008-03-01
    | 2008-03-01
    | 0 to 150
    | Both
    | 55
    | 0
    | 0.00 (0.00 - 0.07)  
    2008-04-01
    | 2008-04-01
    | 0 to 150
    | Both
    | 56
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-05-01
    | 2008-05-01
    | 0 to 150
    | Both
    | 57
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-06-01
    | 2008-06-01
    | 0 to 150
    | Both
    | 57
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-07-01
    | 2008-07-01
    | 0 to 150
    | Both
    | 57
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-08-01
    | 2008-08-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-09-01
    | 2008-09-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-10-01
    | 2008-10-01
    | 0 to 150
    | Both
    | 59
    | 1
    | 0.02 (0.00 - 0.09)  
    2008-11-01
    | 2008-11-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2008-12-01
    | 2008-12-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-01-01
    | 2009-01-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-02-01
    | 2009-02-01
    | 0 to 150
    | Both
    | 59
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-03-01
    | 2009-03-01
    | 0 to 150
    | Both
    | 56
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-04-01
    | 2009-04-01
    | 0 to 150
    | Both
    | 56
    | 0
    | 0.00 (0.00 - 0.06)  
    2009-05-01
    | 2009-05-01
    | 0 to 150
    | Both
    | 54
    | 0
    | 0.00 (0.00 - 0.07)  
    2009-06-01
    | 2009-06-01
    | 0 to 150
    | Both
    | 54
    | 0
    | 0.00 (0.00 - 0.07)  
    2009-07-01
    | 2009-07-01
    | 0 to 150
    | Both
    | 54
    | 1
    | 0.02 (0.00 - 0.10)  
    2009-08-01
    | 2009-08-01
    | 0 to 150
    | Both
    | 54
    | 2
    | 0.04 (0.01 - 0.13)  
    2009-09-01
    | 2009-09-01
    | 0 to 150
    | Both
    | 53
    | 0
    | 0.00 (0.00 - 0.07)  
    2009-10-01
    | 2009-10-01
    | 0 to 150
    | Both
    | 52
    | 0
    | 0.00 (0.00 - 0.07)  
    2009-11-01
    | 2009-11-01
    | 0 to 150
    | Both
    | 51
    | 1
    | 0.02 (0.00 - 0.10)  
    2009-12-01
    | 2009-12-01
    | 0 to 150
    | Both
    | 53
    | 0
    | 0.00 (0.00 - 0.07)  
    2010-01-01
    | 2010-01-01
    | 0 to 150
    | Both
    | 52
    | 1
    | 0.02 (0.00 - 0.10)  
    2010-02-01
    | 2010-02-01
    | 0 to 150
    | Both
    | 52
    | 0
    | 0.00 (0.00 - 0.07)  
    2010-03-01
    | 2010-03-01
    | 0 to 150
    | Both
    | 49
    | 0
    | 0.00 (0.00 - 0.07)  
    2010-04-01
    | 2010-04-01
    | 0 to 150
    | Both
    | 46
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-05-01
    | 2010-05-01
    | 0 to 150
    | Both
    | 44
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-06-01
    | 2010-06-01
    | 0 to 150
    | Both
    | 44
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-07-01
    | 2010-07-01
    | 0 to 150
    | Both
    | 43
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-08-01
    | 2010-08-01
    | 0 to 150
    | Both
    | 42
    | 0
    | 0.00 (0.00 - 0.08)  
    2010-09-01
    | 2010-09-01
    | 0 to 150
    | Both
    | 41
    | 1
    | 0.02 (0.00 - 0.13)  
    2010-10-01
    | 2010-10-01
    | 0 to 150
    | Both
    | 41
    | 1
    | 0.02 (0.00 - 0.13)  
    2010-11-01
    | 2010-11-01
    | 0 to 150
    | Both
    | 41
    | 0
    | 0.00 (0.00 - 0.09)  
    2010-12-01
    | 2010-12-01
    | 0 to 150
    | Both
    | 41
    | 0
    | 0.00 (0.00 - 0.09)  
    2011-01-01
    | 2011-01-01
    | 0 to 150
    | Both
    | 41
    | 0
    | 0.00 (0.00 - 0.09)  
    2011-02-01
    | 2011-02-01
    | 0 to 150
    | Both
    | 39
    | 1
    | 0.03 (0.00 - 0.13)  
    2011-03-01
    | 2011-03-01
    | 0 to 150
    | Both
    | 39
    | 1
    | 0.03 (0.00 - 0.13)  
    2011-04-01
    | 2011-04-01
    | 0 to 150
    | Both
    | 37
    | 0
    | 0.00 (0.00 - 0.09)  
    2011-05-01
    | 2011-05-01
    | 0 to 150
    | Both
    | 36
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-06-01
    | 2011-06-01
    | 0 to 150
    | Both
    | 36
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-07-01
    | 2011-07-01
    | 0 to 150
    | Both
    | 36
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-08-01
    | 2011-08-01
    | 0 to 150
    | Both
    | 35
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-09-01
    | 2011-09-01
    | 0 to 150
    | Both
    | 35
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-10-01
    | 2011-10-01
    | 0 to 150
    | Both
    | 35
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-11-01
    | 2011-11-01
    | 0 to 150
    | Both
    | 33
    | 0
    | 0.00 (0.00 - 0.10)  
    2011-12-01
    | 2011-12-01
    | 0 to 150
    | Both
    | 33
    | 0
    | 0.00 (0.00 - 0.10)  
    2012-01-01
    | 2012-01-01
    | 0 to 150
    | Both
    | 32
    | 0
    | 0.00 (0.00 - 0.11)  
    2012-02-01
    | 2012-02-01
    | 0 to 150
    | Both
    | 31
    | 0
    | 0.00 (0.00 - 0.11)  
    2012-03-01
    | 2012-03-01
    | 0 to 150
    | Both
    | 31
    | 0
    | 0.00 (0.00 - 0.11)  
    2012-04-01
    | 2012-04-01
    | 0 to 150
    | Both
    | 29
    | 0
    | 0.00 (0.00 - 0.12)  
    2012-05-01
    | 2012-05-01
    | 0 to 150
    | Both
    | 28
    | 0
    | 0.00 (0.00 - 0.12)  
    2012-06-01
    | 2012-06-01
    | 0 to 150
    | Both
    | 27
    | 0
    | 0.00 (0.00 - 0.12)  
    2012-07-01
    | 2012-07-01
    | 0 to 150
    | Both
    | 26
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-08-01
    | 2012-08-01
    | 0 to 150
    | Both
    | 26
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-09-01
    | 2012-09-01
    | 0 to 150
    | Both
    | 26
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-10-01
    | 2012-10-01
    | 0 to 150
    | Both
    | 26
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-11-01
    | 2012-11-01
    | 0 to 150
    | Both
    | 25
    | 0
    | 0.00 (0.00 - 0.13)  
    2012-12-01
    | 2012-12-01
    | 0 to 150
    | Both
    | 25
    | 0
    | 0.00 (0.00 - 0.13)  
    2013-01-01
    | 2013-01-01
    | 0 to 150
    | Both
    | 25
    | 0
    | 0.00 (0.00 - 0.13)  
    2013-02-01
    | 2013-02-01
    | 0 to 150
    | Both
    | 24
    | 0
    | 0.00 (0.00 - 0.14)  
    2013-03-01
    | 2013-03-01
    | 0 to 150
    | Both
    | 23
    | 0
    | 0.00 (0.00 - 0.14)  
    2013-04-01
    | 2013-04-01
    | 0 to 150
    | Both
    | 22
    | 0
    | 0.00 (0.00 - 0.15)  
    2013-05-01
    | 2013-05-01
    | 0 to 150
    | Both
    | 21
    | 0
    | 0.00 (0.00 - 0.15)  
    2013-06-01
    | 2013-06-01
    | 0 to 150
    | Both
    | 21
    | 0
    | 0.00 (0.00 - 0.15)  
    2013-07-01
    | 2013-07-01
    | 0 to 150
    | Both
    | 20
    | 0
    | 0.00 (0.00 - 0.16)  
    2013-08-01
    | 2013-08-01
    | 0 to 150
    | Both
    | 20
    | 0
    | 0.00 (0.00 - 0.16)  
    2013-09-01
    | 2013-09-01
    | 0 to 150
    | Both
    | 20
    | 0
    | 0.00 (0.00 - 0.16)  
    2013-10-01
    | 2013-10-01
    | 0 to 150
    | Both
    | 18
    | 1
    | 0.06 (0.01 - 0.26)  
    2013-11-01
    | 2013-11-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2013-12-01
    | 2013-12-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-01-01
    | 2014-01-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-02-01
    | 2014-02-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-03-01
    | 2014-03-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-04-01
    | 2014-04-01
    | 0 to 150
    | Both
    | 18
    | 1
    | 0.06 (0.01 - 0.26)  
    2014-05-01
    | 2014-05-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-06-01
    | 2014-06-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-07-01
    | 2014-07-01
    | 0 to 150
    | Both
    | 18
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-08-01
    | 2014-08-01
    | 0 to 150
    | Both
    | 17
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-09-01
    | 2014-09-01
    | 0 to 150
    | Both
    | 17
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-10-01
    | 2014-10-01
    | 0 to 150
    | Both
    | 17
    | 0
    | 0.00 (0.00 - 0.18)  
    2014-11-01
    | 2014-11-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2014-12-01
    | 2014-12-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-01-01
    | 2015-01-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-02-01
    | 2015-02-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-03-01
    | 2015-03-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-04-01
    | 2015-04-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-05-01
    | 2015-05-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-06-01
    | 2015-06-01
    | 0 to 150
    | Both
    | 16
    | 1
    | 0.06 (0.01 - 0.28)  
    2015-07-01
    | 2015-07-01
    | 0 to 150
    | Both
    | 16
    | 0
    | 0.00 (0.00 - 0.19)  
    2015-08-01
    | 2015-08-01
    | 0 to 150
    | Both
    | 15
    | 0
    | 0.00 (0.00 - 0.20)  
    2015-09-01
    | 2015-09-01
    | 0 to 150
    | Both
    | 15
    | 0
    | 0.00 (0.00 - 0.20)  
    2015-10-01
    | 2015-10-01
    | 0 to 150
    | Both
    | 15
    | 0
    | 0.00 (0.00 - 0.20)  
    2015-11-01
    | 2015-11-01
    | 0 to 150
    | Both
    | 15
    | 0
    | 0.00 (0.00 - 0.20)  
    2015-12-01
    | 2015-12-01
    | 0 to 150
    | Both
    | 14
    | 0
    | 0.00 (0.00 - 0.22)  
    2016-01-01
    | 2016-01-01
    | 0 to 150
    | Both
    | 14
    | 0
    | 0.00 (0.00 - 0.22)  
    2016-02-01
    | 2016-02-01
    | 0 to 150
    | Both
    | 13
    | 0
    | 0.00 (0.00 - 0.23)  
    2016-03-01
    | 2016-03-01
    | 0 to 150
    | Both
    | 11
    | 0
    | 0.00 (0.00 - 0.26)  
    2016-04-01
    | 2016-04-01
    | 0 to 150
    | Both
    | 11
    | 0
    | 0.00 (0.00 - 0.26)  
    2016-05-01
    | 2016-05-01
    | 0 to 150
    | Both
    | 10
    | 0
    | 0.00 (0.00 - 0.28)  
    2016-06-01
    | 2016-06-01
    | 0 to 150
    | Both
    | 10
    | 0
    | 0.00 (0.00 - 0.28)  
    2016-07-01
    | 2016-07-01
    | 0 to 150
    | Both
    | 10
    | 0
    | 0.00 (0.00 - 0.28)  
    2016-08-01
    | 2016-08-01
    | 0 to 150
    | Both
    | 10
    | 0
    | 0.00 (0.00 - 0.28)  
    2016-09-01
    | 2016-09-01
    | 0 to 150
    | Both
    | 9
    | 0
    | 0.00 (0.00 - 0.30)  
    2016-10-01
    | 2016-10-01
    | 0 to 150
    | Both
    | 8
    | 0
    | 0.00 (0.00 - 0.32)  
    2016-11-01
    | 2016-11-01
    | 0 to 150
    | Both
    | 8
    | 0
    | 0.00 (0.00 - 0.32)  
    2016-12-01
    | 2016-12-01
    | 0 to 150
    | Both
    | 8
    | 0
    | 0.00 (0.00 - 0.32)  
    2017-01-01
    | 2017-01-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-02-01
    | 2017-02-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-03-01
    | 2017-03-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-04-01
    | 2017-04-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-05-01
    | 2017-05-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-06-01
    | 2017-06-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-07-01
    | 2017-07-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-08-01
    | 2017-08-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-09-01
    | 2017-09-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-10-01
    | 2017-10-01
    | 0 to 150
    | Both
    | 7
    | 0
    | 0.00 (0.00 - 0.35)  
    2017-11-01
    | 2017-11-01
    | 0 to 150
    | Both
    | 6
    | 0
    | 0.00 (0.00 - 0.39)  
    2017-12-01
    | 2017-12-01
    | 0 to 150
    | Both
    | 6
    | 0
    | 0.00 (0.00 - 0.39)  
    2018-01-01
    | 2018-01-01
    | 0 to 150
    | Both
    | 6
    | 0
    | 0.00 (0.00 - 0.39)  
      
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/tablePrevalenceAttrition.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Table of prevalence attrition results

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`tablePrevalenceAttrition.Rd`

Table of prevalence attrition results

## Usage
    
    
    tablePrevalenceAttrition(
      result,
      type = "gt",
      header = "variable_name",
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
      settingsColumn = NULL,
      hide = [c](https://rdrr.io/r/base/c.html)("denominator_cohort_name", "estimate_name", "reason_id", "variable_level"),
      style = "default"
    )

## Arguments

result
    

A summarised_result object. Output of summariseCohortAttrition().

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `colnames(omopgenerics::splitAll(result))`. Variables in `settingsColumn` are also allowed

groupColumn
    

Variables to use as group labels. Allowed columns are the same as in `header`

settingsColumn
    

Variables from the settings attribute to display in the table

hide
    

Table columns to exclude, options are the ones described in `header`

style
    

A style supported by visOmopResults::visOmopTable()

## Value

A visual table.

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(sampleSize = 1000)
    cdm <- [generateDenominatorCohortSet](generateDenominatorCohortSet.html)(
      cdm = cdm, name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("2008-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2018-01-01"))
    )
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 2 sec
    prev <- [estimatePointPrevalence](estimatePointPrevalence.html)(
      cdm = cdm,
      denominatorTable = "denominator",
      outcomeTable = "outcome",
      interval = "months"
    )
    #> ℹ Getting prevalence for analysis 1 of 1
    #> ✔ Time taken: 0 mins and 1 secs
    tablePrevalenceAttrition(prev)
    
    
    
    
      Reason
          | 
            Variable name
          
          
    ---|---  
    Number records
          | Number subjects
          | Excluded records
          | Excluded subjects
          
    mock; cohort_1
          
    Starting population
    | 1,000
    | 1,000
    | -
    | -  
    Missing year of birth
    | 1,000
    | 1,000
    | 0
    | 0  
    Missing sex
    | 1,000
    | 1,000
    | 0
    | 0  
    Cannot satisfy age criteria during the study period based on year of birth
    | 1,000
    | 1,000
    | 0
    | 0  
    No observation time available during study period
    | 70
    | 70
    | 930
    | 930  
    Doesn't satisfy age criteria during the study period
    | 70
    | 70
    | 0
    | 0  
    Prior history requirement not fulfilled during study period
    | 70
    | 70
    | 0
    | 0  
    No observation time available after applying age, prior observation and, if applicable, target criteria
    | 70
    | 70
    | 0
    | 0  
    Starting analysis population
    | 70
    | 70
    | -
    | -  
    Not observed during the complete database interval
    | 70
    | 70
    | 0
    | 0  
    Do not satisfy full contribution requirement for an interval
    | 70
    | 70
    | 0
    | 0  
      
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/IncidencePrevalenceBenchmarkResults.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Benchmarking results

Source: [`R/data.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/data.R)

`IncidencePrevalenceBenchmarkResults.Rd`

Benchmarking results

## Usage
    
    
    IncidencePrevalenceBenchmarkResults

## Format

A list of results from benchmarking

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/benchmarkIncidencePrevalence.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Run benchmark of incidence and prevalence analyses

Source: [`R/benchmarkIncidencePrevalence.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/benchmarkIncidencePrevalence.R)

`benchmarkIncidencePrevalence.Rd`

Run benchmark of incidence and prevalence analyses

## Usage
    
    
    benchmarkIncidencePrevalence(cdm, analysisType = "all")

## Arguments

cdm
    

A CDM reference object

analysisType
    

A string of the following: "all", "only incidence", "only prevalence"

## Value

a tibble with time taken for different analyses

## Examples
    
    
    # \donttest{
    cdm <- [mockIncidencePrevalence](mockIncidencePrevalence.html)(
      sampleSize = 100,
      earliestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      latestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      minDaysToObservationEnd = 364,
      maxDaysToObservationEnd = 364,
      outPre = 0.1
    )
    
    timings <- benchmarkIncidencePrevalence(cdm)
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 6 sec
    #> ℹ Getting prevalence for analysis 1 of 16
    #> ℹ Getting prevalence for analysis 2 of 16
    #> ℹ Getting prevalence for analysis 3 of 16
    #> ℹ Getting prevalence for analysis 4 of 16
    #> ℹ Getting prevalence for analysis 5 of 16
    #> ℹ Getting prevalence for analysis 6 of 16
    #> ℹ Getting prevalence for analysis 7 of 16
    #> ℹ Getting prevalence for analysis 8 of 16
    #> ℹ Getting prevalence for analysis 9 of 16
    #> ℹ Getting prevalence for analysis 10 of 16
    #> ℹ Getting prevalence for analysis 11 of 16
    #> ℹ Getting prevalence for analysis 12 of 16
    #> ℹ Getting prevalence for analysis 13 of 16
    #> ℹ Getting prevalence for analysis 14 of 16
    #> ℹ Getting prevalence for analysis 15 of 16
    #> ℹ Getting prevalence for analysis 16 of 16
    #> ✔ Time taken: 0 mins and 3 secs
    #> ℹ Getting prevalence for analysis 1 of 16
    #> ℹ Getting prevalence for analysis 2 of 16
    #> ℹ Getting prevalence for analysis 3 of 16
    #> ℹ Getting prevalence for analysis 4 of 16
    #> ℹ Getting prevalence for analysis 5 of 16
    #> ℹ Getting prevalence for analysis 6 of 16
    #> ℹ Getting prevalence for analysis 7 of 16
    #> ℹ Getting prevalence for analysis 8 of 16
    #> ℹ Getting prevalence for analysis 9 of 16
    #> ℹ Getting prevalence for analysis 10 of 16
    #> ℹ Getting prevalence for analysis 11 of 16
    #> ℹ Getting prevalence for analysis 12 of 16
    #> ℹ Getting prevalence for analysis 13 of 16
    #> ℹ Getting prevalence for analysis 14 of 16
    #> ℹ Getting prevalence for analysis 15 of 16
    #> ℹ Getting prevalence for analysis 16 of 16
    #> ✔ Time taken: 0 mins and 3 secs
    #> ℹ Getting incidence for analysis 1 of 16
    #> ℹ Getting incidence for analysis 2 of 16
    #> ℹ Getting incidence for analysis 3 of 16
    #> ℹ Getting incidence for analysis 4 of 16
    #> ℹ Getting incidence for analysis 5 of 16
    #> ℹ Getting incidence for analysis 6 of 16
    #> ℹ Getting incidence for analysis 7 of 16
    #> ℹ Getting incidence for analysis 8 of 16
    #> ℹ Getting incidence for analysis 9 of 16
    #> ℹ Getting incidence for analysis 10 of 16
    #> ℹ Getting incidence for analysis 11 of 16
    #> ℹ Getting incidence for analysis 12 of 16
    #> ℹ Getting incidence for analysis 13 of 16
    #> ℹ Getting incidence for analysis 14 of 16
    #> ℹ Getting incidence for analysis 15 of 16
    #> ℹ Getting incidence for analysis 16 of 16
    #> ✔ Overall time taken: 0 mins and 9 secs
    # }
    

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/IncidencePrevalence/reference/pipe.html

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Pipe operator

Source: [`R/utils-pipe.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/utils-pipe.R)

`pipe.Rd`

See `magrittr::%>%` for details.

## Usage
    
    
    lhs %>% rhs

## Arguments

lhs
    

A value or the magrittr placeholder.

rhs
    

A function call using the magrittr semantics.

## Value

The result of calling `rhs(lhs)`.

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
