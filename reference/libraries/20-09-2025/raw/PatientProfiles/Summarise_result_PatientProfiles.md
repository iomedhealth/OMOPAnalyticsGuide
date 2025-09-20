# Summarise result • PatientProfiles

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
