# Splitting cohorts • CohortConstructor

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

# Splitting cohorts

Source: [`vignettes/a08_split_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a08_split_cohorts.Rmd)

`a08_split_cohorts.Rmd`

## Introduction

In this vignette we show how to split existing cohorts. We are going to use the _GiBleed_ database to conduct the different examples. To make sure _GiBleed_ database is available you can use the function `[requireEunomia()](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)` so let’s get started.

Load necessary packages:
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([clock](https://clock.r-lib.org))

Create `cdm_reference` object from _GiBleed_ database:
    
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)(datasetName = "GiBleed")
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchema = "main", writeSchema = "main", writePrefix = "my_study_"
    )

Let’s start by creating two drug cohorts, one for users of diclofenac and another for users of acetaminophen.
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = [list](https://rdrr.io/r/base/list.html)("diclofenac" = 1124300L,
                                                       "acetaminophen" = 1127433L), 
                                     name = "medications")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$medications)
    #> # A tibble: 2 × 4
    #>   cohort_definition_id cohort_name   cdm_version vocabulary_version
    #>                  <int> <chr>         <chr>       <chr>             
    #> 1                    1 acetaminophen 5.3         v5.0 18-JAN-19    
    #> 2                    2 diclofenac    5.3         v5.0 18-JAN-19

## stratifyCohorts

If we want to create separate cohorts by sex we could use the function `[requireSex()](../reference/requireSex.html)`:
    
    
    cdm$medications_female <- cdm$medications |>
      [requireSex](../reference/requireSex.html)(sex = "Female", name = "medications_female") |>
      [renameCohort](../reference/renameCohort.html)(
        cohortId = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "diclofenac"), 
        newCohortName = [c](https://rdrr.io/r/base/c.html)("acetaminophen_female", "diclofenac_female")
      )
    cdm$medications_male <- cdm$medications |>
      [requireSex](../reference/requireSex.html)(sex = "Male", name = "medications_male") |>
      [renameCohort](../reference/renameCohort.html)(
        cohortId = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "diclofenac"), 
        newCohortName = [c](https://rdrr.io/r/base/c.html)("acetaminophen_male", "diclofenac_male")
      )
    cdm <- [bind](https://darwin-eu.github.io/omopgenerics/reference/bind.html)(cdm$medications_female, cdm$medications_male, name = "medications_sex")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications_sex)
    #> # A tibble: 4 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           4718            1316
    #> 2                    2            435             435
    #> 3                    3           4647            1264
    #> 4                    4            395             395
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$medications_sex)
    #> # A tibble: 4 × 5
    #>   cohort_definition_id cohort_name          cdm_version vocabulary_version sex  
    #>                  <int> <chr>                <chr>       <chr>              <chr>
    #> 1                    1 acetaminophen_female 5.3         v5.0 18-JAN-19     Fema…
    #> 2                    2 diclofenac_female    5.3         v5.0 18-JAN-19     Fema…
    #> 3                    3 acetaminophen_male   5.3         v5.0 18-JAN-19     Male 
    #> 4                    4 diclofenac_male      5.3         v5.0 18-JAN-19     Male

The `[stratifyCohorts()](../reference/stratifyCohorts.html)` function will produce a similar output but it relies on a column being already created so let’s first add a column sex to my existent cohort:
    
    
    cdm$medications <- cdm$medications |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)()
    cdm$medications
    #> # Source:   table<og_009_1758270112> [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/Rtmp5jJxPo/file29f454de3f40.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date sex   
    #>                   <int>      <int> <date>            <date>          <chr> 
    #>  1                    1        222 2014-07-18        2014-08-01      Female
    #>  2                    1        248 2009-05-19        2009-06-18      Male  
    #>  3                    1        363 1995-10-16        1995-10-23      Male  
    #>  4                    1        392 2019-01-31        2019-02-08      Male  
    #>  5                    1        406 1987-06-15        1987-06-29      Male  
    #>  6                    1        776 2003-02-01        2003-02-15      Female
    #>  7                    1        841 1966-08-31        1966-09-07      Male  
    #>  8                    1       1151 2014-01-26        2014-02-09      Female
    #>  9                    1       1325 2001-04-06        2001-04-13      Male  
    #> 10                    1       1513 1968-07-26        1968-08-09      Female
    #> # ℹ more rows

Now we can use the function `[stratifyCohorts()](../reference/stratifyCohorts.html)` to create a new cohort based on the `sex` column, one new cohort will be created for any value of the `sex` column:
    
    
    cdm$medications_sex_2 <- cdm$medications |>
      [stratifyCohorts](../reference/stratifyCohorts.html)(strata = "sex", name = "medications_sex_2")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications_sex_2)
    #> # A tibble: 4 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           4718            1316
    #> 2                    2           4647            1264
    #> 3                    3            435             435
    #> 4                    4            395             395
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$medications_sex_2)
    #> # A tibble: 4 × 9
    #>   cohort_definition_id cohort_name          target_cohort_id target_cohort_name
    #>                  <int> <chr>                           <int> <chr>             
    #> 1                    1 acetaminophen_female                1 acetaminophen     
    #> 2                    2 acetaminophen_male                  1 acetaminophen     
    #> 3                    3 diclofenac_female                   2 diclofenac        
    #> 4                    4 diclofenac_male                     2 diclofenac        
    #> # ℹ 5 more variables: cdm_version <chr>, vocabulary_version <chr>,
    #> #   target_cohort_table_name <chr>, strata_columns <chr>, sex <chr>

Note that both cohorts can be slightly different, in the first case four cohorts will always be created, whereas in the second one it will rely on whatever is in the data, if one the diclofenac cohort does not have ‘Female’ records the `diclofenac_female` cohort is not going to be created, if we have individuals with sex ‘None’ then a `{cohort_name}_none` cohort will be created.

The function is very powerful and multiple cohorts can be created in one go, in this example we will create cohorts by “age and sex” and by “year”.
    
    
    cdm$stratified <- cdm$medications |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)("child" = [c](https://rdrr.io/r/base/c.html)(0,17), "18_to_65" = [c](https://rdrr.io/r/base/c.html)(18,64), "65_and_over" = [c](https://rdrr.io/r/base/c.html)(65, Inf))) |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(year = [get_year](https://clock.r-lib.org/reference/clock-getters.html)(cohort_start_date)) |>
      [stratifyCohorts](../reference/stratifyCohorts.html)(strata = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)("sex", "age_group"), "year"), name = "stratified")
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$stratified)
    #> # A tibble: 232 × 3
    #>    cohort_definition_id number_records number_subjects
    #>                   <int>          <int>           <int>
    #>  1                    1           2941            2894
    #>  2                    2            380             370
    #>  3                    3           1397            1382
    #>  4                    4           2916            2857
    #>  5                    5            336             328
    #>  6                    6           1395            1373
    #>  7                    7            435             435
    #>  8                    8              0               0
    #>  9                    9              0               0
    #> 10                   10            395             395
    #> # ℹ 222 more rows
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$stratified)
    #> # A tibble: 232 × 11
    #>    cohort_definition_id cohort_name          target_cohort_id target_cohort_name
    #>                   <int> <chr>                           <int> <chr>             
    #>  1                    1 acetaminophen_femal…                1 acetaminophen     
    #>  2                    2 acetaminophen_femal…                1 acetaminophen     
    #>  3                    3 acetaminophen_femal…                1 acetaminophen     
    #>  4                    4 acetaminophen_male_…                1 acetaminophen     
    #>  5                    5 acetaminophen_male_…                1 acetaminophen     
    #>  6                    6 acetaminophen_male_…                1 acetaminophen     
    #>  7                    7 diclofenac_female_1…                2 diclofenac        
    #>  8                    8 diclofenac_female_6…                2 diclofenac        
    #>  9                    9 diclofenac_female_c…                2 diclofenac        
    #> 10                   10 diclofenac_male_18_…                2 diclofenac        
    #> # ℹ 222 more rows
    #> # ℹ 7 more variables: cdm_version <chr>, vocabulary_version <chr>,
    #> #   target_cohort_table_name <chr>, strata_columns <chr>, sex <chr>,
    #> #   age_group <chr>, year <dbl>

A total of 232 cohorts were created in one go, 12 related to sex & age group combination, and 220 by year.

Note that these year cohorts were created based on the prescription start date, but they can have end dates after that year. If you want to split the cohorts on yearly contributions see the next section.

## yearCohorts

`[yearCohorts()](../reference/yearCohorts.html)` is a function that is used to split the contribution of a cohort into the different years that is spread across, let’s see this simple example:

![](a08_split_cohorts_files/figure-html/unnamed-chunk-9-1.png)

In this example we have an individual that has a cohort entry that starts on the ‘2010-05-01’ and ends on the ‘2012-06-12’ then its contributions will be split into three contributions:

  * From ‘2010-05-01’ to ‘2010-12-31’.
  * From ‘2011-01-01’ to ‘2011-12-31’.
  * From ‘2012-01-01’ to ‘2012-06-12’.



So let’s use it in one example:
    
    
    cdm$medications_year <- cdm$medications |>
      [yearCohorts](../reference/yearCohorts.html)(years = [c](https://rdrr.io/r/base/c.html)(1990:1993), name = "medications_year")
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$medications_year)
    #> # A tibble: 8 × 7
    #>   cohort_definition_id cohort_name        target_cohort_definition…¹ cdm_version
    #>                  <int> <chr>                                   <int> <chr>      
    #> 1                    1 acetaminophen_1990                          1 5.3        
    #> 2                    2 diclofenac_1990                             2 5.3        
    #> 3                    3 acetaminophen_1991                          1 5.3        
    #> 4                    4 diclofenac_1991                             2 5.3        
    #> 5                    5 acetaminophen_1992                          1 5.3        
    #> 6                    6 diclofenac_1992                             2 5.3        
    #> 7                    7 acetaminophen_1993                          1 5.3        
    #> 8                    8 diclofenac_1993                             2 5.3        
    #> # ℹ abbreviated name: ¹​target_cohort_definition_id
    #> # ℹ 3 more variables: vocabulary_version <chr>, year <int>,
    #> #   target_cohort_name <chr>
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications_year)
    #> # A tibble: 8 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            200             191
    #> 2                    2             16              16
    #> 3                    3            196             191
    #> 4                    4             12              12
    #> 5                    5            201             194
    #> 6                    6             13              13
    #> 7                    7            211             207
    #> 8                    8             15              15

Note we could choose the years of interest and that invididuals. Let’s look closer to one of the individuals (`person_id = 4383`) that has 6 records:
    
    
    cdm$medications |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 4383)
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/Rtmp5jJxPo/file29f454de3f40.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date sex  
    #>                  <int>      <int> <date>            <date>          <chr>
    #> 1                    1       4383 1990-12-20        1991-01-03      Male 
    #> 2                    1       4383 2004-05-21        2004-06-11      Male 
    #> 3                    1       4383 1990-10-13        1990-10-27      Male 
    #> 4                    1       4383 2000-03-12        2000-03-19      Male 
    #> 5                    1       4383 1971-02-06        1971-02-13      Male 
    #> 6                    1       4383 1992-07-18        1992-08-22      Male

From the 6 records only 3 are within our period of interest `1990-1993`, there are two contributions that start and end in the same year that’s why they are going to be unaltered and just assigned to the year of interest. But one of the cohort entries starts in 1990 and ends in 1991, then their contribution will be split into the two years, so we expect to see 4 cohort contributions for this subject (2 in 1990, 1 in 1991 and 1 in 1992):
    
    
    cdm$medications_year |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 4383)
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/Rtmp5jJxPo/file29f454de3f40.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date sex  
    #>                  <int>      <int> <date>            <date>          <chr>
    #> 1                    1       4383 1990-12-20        1990-12-31      Male 
    #> 2                    1       4383 1990-10-13        1990-10-27      Male 
    #> 3                    3       4383 1991-01-01        1991-01-03      Male 
    #> 4                    5       4383 1992-07-18        1992-08-22      Male

Let’s disconnect from our cdm object to finish.
    
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
