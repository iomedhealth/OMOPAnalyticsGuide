# Filtering cohorts • CohortConstructor

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Filtering cohorts

Source: [`vignettes/a07_filter_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a07_filter_cohorts.Rmd)

`a07_filter_cohorts.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

For this example we’ll use the Eunomia synthetic data from the CDMConnector package.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating two drug cohorts, one for users of diclofenac and another for users of acetaminophen.
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = [list](https://rdrr.io/r/base/list.html)("diclofenac" = 1124300,
                                                       "acetaminophen" = 1127433), 
                                     name = "medications")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830

We can take a sample from a cohort table using the function `sampleCohort()`. This allows us to specify the number of individuals in each cohort.
    
    
    cdm$medications |> [sampleCohorts](../reference/sampleCohorts.html)(cohortId = NULL, n = 100)
    #> # Source:   table<my_study_medications> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpeV7jIu/file29a4369244db.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1       5096 1971-03-25        1971-04-08     
    #>  2                    2       4847 1977-07-08        1977-07-08     
    #>  3                    2       1751 2017-09-08        2017-09-08     
    #>  4                    1        246 2018-03-15        2018-04-05     
    #>  5                    1        870 2002-11-11        2002-12-02     
    #>  6                    1       1900 1980-01-04        1980-01-11     
    #>  7                    1       2780 1968-04-16        1968-04-30     
    #>  8                    1       3469 2015-09-18        2015-10-02     
    #>  9                    1       3580 1989-05-15        1989-06-14     
    #> 10                    2       2218 2011-08-03        2011-08-03     
    #> # ℹ more rows
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            344             100
    #> 2                    2            100             100

When cohortId = NULL all cohorts in the table are used. Note that this function does not reduced the number of records in each cohort, only the number of individuals.

It is also possible to only sample one cohort within cohort table, however the remaining cohorts will still remain.
    
    
    cdm$medications <- cdm$medications |> [sampleCohorts](../reference/sampleCohorts.html)(cohortId = 2, n = 100)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            100             100

The chosen cohort (users of diclofenac) has been reduced to 100 individuals, as specified in the function, however all individuals from cohort 1 (users of acetaminophen) and their records remain.

If you want to filter the cohort table to only include individuals and records from a specified cohort, you can use the function `subsetCohorts`.
    
    
    cdm$medications <- cdm$medications |> [subsetCohorts](../reference/subsetCohorts.html)(cohortId = 2)
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    2            830             830

The cohort table has been filtered so it now only includes individuals and records from cohort 2. If you want to take a sample of the filtered cohort table then you can use the `sampleCohorts` function.
    
    
    cdm$medications <- cdm$medications |> [sampleCohorts](../reference/sampleCohorts.html)(cohortId = 2, n = 100)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    2            100             100

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
