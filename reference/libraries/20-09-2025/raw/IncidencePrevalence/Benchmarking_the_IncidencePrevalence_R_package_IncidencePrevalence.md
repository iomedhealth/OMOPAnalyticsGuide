# Benchmarking the IncidencePrevalence R package • IncidencePrevalence

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
