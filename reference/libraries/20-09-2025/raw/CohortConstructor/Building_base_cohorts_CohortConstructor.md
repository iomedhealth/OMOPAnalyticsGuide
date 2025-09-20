# Building base cohorts • CohortConstructor

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

# Building base cohorts

Source: [`vignettes/a01_building_base_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a01_building_base_cohorts.Rmd)

`a01_building_base_cohorts.Rmd`

## Introduction

Let’s first create a cdm reference to the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main", 
                      writePrefix = "my_study_")

## Concept based cohort creation

A way of defining base cohorts is to identify clinical records with codes from some pre-specified concept list. Here for example we’ll first find codes for diclofenac and acetaminophen. We use the `[getDrugIngredientCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)` function from the package **CodelistGenerator** to obtain the codes for these drugs.
    
    
    drug_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm, 
                                         name = [c](https://rdrr.io/r/base/c.html)("acetaminophen",
                                                  "amoxicillin", 
                                                  "diclofenac", 
                                                  "simvastatin",
                                                  "warfarin"))
    
    drug_codes
    #> 
    #> - 11289_warfarin (2 codes)
    #> - 161_acetaminophen (7 codes)
    #> - 3355_diclofenac (1 codes)
    #> - 36567_simvastatin (2 codes)
    #> - 723_amoxicillin (4 codes)

Now we have our codes of interest, we’ll make cohorts for each of these where cohort exit is defined as the event start date (which for these will be their drug exposure end date).
    
    
    cdm$drugs <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = drug_codes,
                               exit = "event_end_date",
                               name = "drugs")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$drugs)
    #> # A tibble: 5 × 4
    #>   cohort_definition_id cohort_name       cdm_version vocabulary_version
    #>                  <int> <chr>             <chr>       <chr>             
    #> 1                    1 11289_warfarin    5.3         v5.0 18-JAN-19    
    #> 2                    2 161_acetaminophen 5.3         v5.0 18-JAN-19    
    #> 3                    3 3355_diclofenac   5.3         v5.0 18-JAN-19    
    #> 4                    4 36567_simvastatin 5.3         v5.0 18-JAN-19    
    #> 5                    5 723_amoxicillin   5.3         v5.0 18-JAN-19
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$drugs)
    #> # A tibble: 5 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            137             137
    #> 2                    2          13908            2679
    #> 3                    3            830             830
    #> 4                    4            182             182
    #> 5                    5           4307            2130
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$drugs)
    #> # A tibble: 30 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1            137             137         1 Initial qualif…
    #>  2                    1            137             137         2 Record in obse…
    #>  3                    1            137             137         3 Record start <…
    #>  4                    1            137             137         4 Non-missing sex
    #>  5                    1            137             137         5 Non-missing ye…
    #>  6                    1            137             137         6 Merge overlapp…
    #>  7                    2          14205            2679         1 Initial qualif…
    #>  8                    2          14205            2679         2 Record in obse…
    #>  9                    2          14205            2679         3 Record start <…
    #> 10                    2          14205            2679         4 Non-missing sex
    #> # ℹ 20 more rows
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

This creates a cohort where individuals are defined by their exposure to the specified drugs, and their cohort duration is determined by the exposure end date.

Next, let’s create a cohort for individuals with bronchitis. We define a set of codes representing bronchitis and use the `[conceptCohort()](../reference/conceptCohort.html)` function to create the cohort. Here, the cohort exit is defined by the event start date (i.e., `event_start_date`). We set `table = "condition_occurrence"` so that the records for the provided concepts will be searched only in the _condition_occurrence_ table. We then set `subsetCohort = "drugs"` to restrict the cohort creation to individuals already in the `drugs` cohort. Additionally, we use `subsetCohortId = 1` to include only subjects from the cohort 1 (which corresponds to individuals who have been exposed to warfarin).
    
    
    
    bronchitis_codes <- [list](https://rdrr.io/r/base/list.html)(bronchitis = [c](https://rdrr.io/r/base/c.html)(260139, 256451, 4232302))
    
    cdm$bronchitis <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = bronchitis_codes,
                               exit = "event_start_date",
                               name = "bronchitis",
                               table = "condition_occurrence", 
                               subsetCohort = "drugs", 
                               subsetCohortId = 1
                               )
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$bronchitis)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            533             130
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$bronchitis)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1            533             130         1 Initial qualify…
    #> 2                    1            533             130         2 Record in obser…
    #> 3                    1            533             130         3 Record start <=…
    #> 4                    1            533             130         4 Non-missing sex 
    #> 5                    1            533             130         5 Non-missing yea…
    #> 6                    1            533             130         6 Merge overlappi…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

When some records in the cohort overlap, the cohort start date will be set to the earliest start date. If we set `overlap = "merge"`, the cohort end date will be set to the latest end date of the overlapping records.
    
    
    cdm$drugs_merge <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = drug_codes,
                               overlap = "merge",
                               name = "drugs_merge")
    
    cdm$drugs_merge |>
      [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 30 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1            137             137         1 Initial qualif…
    #>  2                    1            137             137         2 Record in obse…
    #>  3                    1            137             137         3 Record start <…
    #>  4                    1            137             137         4 Non-missing sex
    #>  5                    1            137             137         5 Non-missing ye…
    #>  6                    1            137             137         6 Merge overlapp…
    #>  7                    2          14205            2679         1 Initial qualif…
    #>  8                    2          14205            2679         2 Record in obse…
    #>  9                    2          14205            2679         3 Record start <…
    #> 10                    2          14205            2679         4 Non-missing sex
    #> # ℹ 20 more rows
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

Alternatively, if we set `overlap = "extend"`, the cohort end date will be extended by summing the durations of each overlapping record.
    
    
    cdm$drugs_extend <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = drug_codes,
                               overlap = "extend",
                               name = "drugs_extend")
    
    cdm$drugs_extend |>
      [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 50 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1            137             137         1 Initial qualif…
    #>  2                    1            137             137         2 Record in obse…
    #>  3                    1            137             137         3 Record start <…
    #>  4                    1            137             137         4 Non-missing sex
    #>  5                    1            137             137         5 Non-missing ye…
    #>  6                    1            137             137         6 Add overlappin…
    #>  7                    1            137             137         7 Record in obse…
    #>  8                    1            137             137         8 Record start <…
    #>  9                    1            137             137         9 Non-missing sex
    #> 10                    1            137             137        10 Non-missing ye…
    #> # ℹ 40 more rows
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

To create a cohort from a concept set and include records outside of the observation period, we can set `useRecordsBeforeObservation = TRUE`. If we also want to search for the given concepts in the source concept_id fields, rather than only the standard concept_id fields, we can set `useSourceFields = TRUE`.
    
    
    
    cdm$celecoxib <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = [list](https://rdrr.io/r/base/list.html)(celecoxib = 44923712),
                               name = "celecoxib", 
                               useRecordsBeforeObservation = TRUE, 
                               useSourceFields = TRUE)
    cdm$celecoxib |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpRzA3TJ/file27e013b5926.duckdb]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 1, 919, 2175, 2406, 5103, 43, 505, 1408, 2244, 25…
    #> $ cohort_start_date    <date> 1982-08-12, 2009-06-05, 2013-08-07, 1979-04-20, …
    #> $ cohort_end_date      <date> 1982-08-12, 2009-06-05, 2013-08-07, 1979-04-20, …

## Demographic based cohort creation

One base cohort we can create is based around patient demographics. Here for example we create a cohort where people enter on their 18th birthday and leave at on the day before their 66th birthday.
    
    
    cdm$working_age_cohort <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, 
                                                 ageRange = [c](https://rdrr.io/r/base/c.html)(18, 65), 
                                                 name = "working_age_cohort")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$working_age_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id cohort_name  age_range
    #>                  <int> <chr>        <chr>    
    #> 1                    1 demographics 18_65
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$working_age_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           2694            2694
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$working_age_cohort)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1           2694            2694         1 Initial qualify…
    #> 2                    1           2694            2694         2 Age requirement…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

We can also add an additional requirement of only people of working age with sex “female”.
    
    
    cdm$female_working_age_cohort <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, 
                                                 ageRange = [c](https://rdrr.io/r/base/c.html)(18, 65),
                                                 sex = "Female",
                                                 name = "female_working_age_cohort")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$female_working_age_cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id cohort_name  age_range sex   
    #>                  <int> <chr>        <chr>     <chr> 
    #> 1                    1 demographics 18_65     Female
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$female_working_age_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           1373            1373
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$female_working_age_cohort)
    #> # A tibble: 3 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1           2694            2694         1 Initial qualify…
    #> 2                    1           1373            1373         2 Sex requirement…
    #> 3                    1           1373            1373         3 Age requirement…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

We can also use this function to create cohorts for different combinations of age groups and sex.
    
    
    cdm$age_sex_cohorts <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, 
                                                 ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 17), [c](https://rdrr.io/r/base/c.html)(18, 65), [c](https://rdrr.io/r/base/c.html)(66,120)),
                                                 sex = [c](https://rdrr.io/r/base/c.html)("Female", "Male"),
                                                 name = "age_sex_cohorts")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$age_sex_cohorts)
    #> # A tibble: 6 × 4
    #>   cohort_definition_id cohort_name    age_range sex   
    #>                  <int> <chr>          <chr>     <chr> 
    #> 1                    1 demographics_1 0_17      Female
    #> 2                    2 demographics_2 0_17      Male  
    #> 3                    3 demographics_3 18_65     Female
    #> 4                    4 demographics_4 18_65     Male  
    #> 5                    5 demographics_5 66_120    Female
    #> 6                    6 demographics_6 66_120    Male
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$age_sex_cohorts)
    #> # A tibble: 6 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           1373            1373
    #> 2                    2           1321            1321
    #> 3                    3           1373            1373
    #> 4                    4           1321            1321
    #> 5                    5            393             393
    #> 6                    6            378             378
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$age_sex_cohorts)
    #> # A tibble: 18 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1           2694            2694         1 Initial qualif…
    #>  2                    1           1373            1373         2 Sex requiremen…
    #>  3                    1           1373            1373         3 Age requiremen…
    #>  4                    2           2694            2694         1 Initial qualif…
    #>  5                    2           1321            1321         2 Sex requiremen…
    #>  6                    2           1321            1321         3 Age requiremen…
    #>  7                    3           2694            2694         1 Initial qualif…
    #>  8                    3           1373            1373         2 Sex requiremen…
    #>  9                    3           1373            1373         3 Age requiremen…
    #> 10                    4           2694            2694         1 Initial qualif…
    #> 11                    4           1321            1321         2 Sex requiremen…
    #> 12                    4           1321            1321         3 Age requiremen…
    #> 13                    5           2694            2694         1 Initial qualif…
    #> 14                    5           1373            1373         2 Sex requiremen…
    #> 15                    5            393             393         3 Age requiremen…
    #> 16                    6           2694            2694         1 Initial qualif…
    #> 17                    6           1321            1321         2 Sex requiremen…
    #> 18                    6            378             378         3 Age requiremen…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

We can also specify the minimum number of days of prior observation required.
    
    
    cdm$working_age_cohort_0_365 <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, 
                                                 ageRange = [c](https://rdrr.io/r/base/c.html)(18, 65), 
                                                 name = "working_age_cohort_0_365",
                                                 minPriorObservation = [c](https://rdrr.io/r/base/c.html)(0,365))
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$working_age_cohort_0_365)
    #> # A tibble: 2 × 4
    #>   cohort_definition_id cohort_name    age_range min_prior_observation
    #>                  <int> <chr>          <chr>                     <dbl>
    #> 1                    1 demographics_1 18_65                         0
    #> 2                    2 demographics_2 18_65                       365
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$working_age_cohort_0_365)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           2694            2694
    #> 2                    2           2694            2694
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$working_age_cohort_0_365)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1           2694            2694         1 Initial qualify…
    #> 2                    1           2694            2694         2 Age requirement…
    #> 3                    1           2694            2694         3 Prior observati…
    #> 4                    2           2694            2694         1 Initial qualify…
    #> 5                    2           2694            2694         2 Age requirement…
    #> 6                    2           2694            2694         3 Prior observati…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

## Measurement Cohort

Another base cohort we can create is based around patient measurements. Here for example we create a cohort of patients who have a normal BMI (BMI between 18 and 25). To do this you must first identify the measurement you want to look at (in this case BMI (concept id = 4245997)), the unit of measurement (kg per square-meter (concept id = 9531)) and ‘normal’ value concept (concept id = 4069590). The value concept is included for the cases where the exact BMI measurement is not specified, but the BMI category (i.e. normal, overweight, obese etc) is. This means that if a record matches the value concept OR has a normal BMI score then it is included in the cohort.
    
    
    cdm$cohort <- [measurementCohort](../reference/measurementCohort.html)(
      cdm = cdm,
      name = "cohort",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("bmi_normal" = [c](https://rdrr.io/r/base/c.html)(4245997)),
      valueAsConcept = [c](https://rdrr.io/r/base/c.html)(4069590),
      valueAsNumber = [list](https://rdrr.io/r/base/list.html)("9531" = [c](https://rdrr.io/r/base/c.html)(18, 25))
    )
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              5               3         1 Initial qualify…
    #> 2                    1              3               2         2 Record in obser…
    #> 3                    1              3               2         3 Not missing rec…
    #> 4                    1              3               2         4 Non-missing sex 
    #> 5                    1              3               2         5 Non-missing yea…
    #> 6                    1              3               2         6 Distinct measur…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id cohort_name cdm_version vocabulary_version
    #>                  <int> <chr>       <chr>       <chr>             
    #> 1                    1 bmi_normal  5.3         mock
    cdm$cohort
    #> # Source:   table<cohort> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <dbl> <date>            <date>         
    #> 1                    1          1 2009-07-01        2009-07-01     
    #> 2                    1          3 1999-09-08        1999-09-08     
    #> 3                    1          1 2015-02-19        2015-02-19

As you can see in the above code, the concept set is the list of BMI concepts, the concept value is the ‘normal’ weight concept, and the values are the minimum and maximum BMI scores to be considered.

It is also possible to include records outside of observation by setting the `useRecordsBeforeObservation` argument to TRUE.
    
    
    cdm$cohort <- [measurementCohort](../reference/measurementCohort.html)(
      cdm = cdm,
      name = "cohort",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("bmi_normal" = [c](https://rdrr.io/r/base/c.html)(4245997)),
      valueAsConcept = [c](https://rdrr.io/r/base/c.html)(4069590),
      valueAsNumber = [list](https://rdrr.io/r/base/list.html)("9531" = [c](https://rdrr.io/r/base/c.html)(18, 25)),
      useRecordsBeforeObservation = TRUE
    )
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              5               3         1 Initial qualify…
    #> 2                    1              4               3         2 Record in obser…
    #> 3                    1              4               3         3 Not missing rec…
    #> 4                    1              4               3         4 Non-missing sex 
    #> 5                    1              4               3         5 Non-missing yea…
    #> 6                    1              4               3         6 Distinct measur…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id cohort_name cdm_version vocabulary_version
    #>                  <int> <chr>       <chr>       <chr>             
    #> 1                    1 bmi_normal  5.3         mock
    cdm$cohort
    #> # Source:   table<cohort> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <dbl> <date>            <date>         
    #> 1                    1          2 2006-04-01        2006-04-01     
    #> 2                    1          3 1999-09-08        1999-09-08     
    #> 3                    1          1 2009-07-01        2009-07-01     
    #> 4                    1          1 2015-02-19        2015-02-19

## Death cohort

Another base cohort we can make is one with individuals who have died. For this we’ll simply be finding those people in the OMOP CDM death table and creating a cohort with them.
    
    
    cdm$death_cohort <- [deathCohort](../reference/deathCohort.html)(cdm = cdm,
                                    name = "death_cohort")

To create a cohort of individuals who have died, but restrict it to those already part of another cohort (e.g., the “drugs” cohort), you can use `subsetCohort = "drugs"`. This ensures that only individuals from the “drugs” cohort are included in the death cohort.
    
    
    cdm$death_drugs <- [deathCohort](../reference/deathCohort.html)(cdm = cdm,
                                   name = "death_drugs",
                                   subsetCohort = "drugs")

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
