# Working with cohorts • CDMConnector

Skip to contents

[CDMConnector](../index.html) 2.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Getting Started](../articles/a01_getting-started.html)
    * [Working with cohorts](../articles/a02_cohorts.html)
    * [CDMConnector and dbplyr](../articles/a03_dbplyr.html)
    * [DBI connection examples](../articles/a04_DBI_connection_examples.html)
    * [Using CDM attributes](../articles/a06_using_cdm_attributes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CDMConnector/)



![](../logo.png)

# Working with cohorts

Source: [`vignettes/a02_cohorts.Rmd`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/vignettes/a02_cohorts.Rmd)

`a02_cohorts.Rmd`

Cohorts are a fundamental building block for observational health data analysis. A “cohort” is a set of persons satisfying a one or more inclusion criteria for a duration of time. If you are familiar with the idea of sets in math then a cohort can be nicely represented as a set of person-days. In the OMOP Common Data Model we represent cohorts using a table with four columns.

An example cohort table cohort_definition_id | subject_id | cohort_start_date | cohort_end_date  
---|---|---|---  
1 | 1000 | 2020-01-01 | 2020-05-01  
1 | 1000 | 2021-06-01 | 2020-07-01  
1 | 2000 | 2020-03-01 | 2020-09-01  
2 | 1000 | 2020-02-01 | 2020-03-01  
  
A cohort table can contain multiple cohorts and each cohort can have multiple persons. There can even be multiple records for the same person in a single cohort as long as the date ranges do not overlap. In the same way that an element is either in a set or not, a single person-day is either in a cohort or not. For a more comprehensive treatment of cohorts in OHDSI check out the Cohorts chapter in [The Book of OHDSI](https://ohdsi.github.io/TheBookOfOhdsi/Cohorts.html).

## Cohort Generation

The n*4n*4 cohort table is created through the process of cohort _generation_. To generate a cohort on a specific CDM dataset means that we combine a _cohort definition_ with CDM to produce a cohort table. The standardization provided by the OMOP CDM allows researchers to generate the same cohort definition on any OMOP CDM dataset.

A cohort definition is an expression of the rules governing the inclusion/exclusion of person-days in the cohort. There are three common ways to create cohort definitions for the OMOP CDM.

  1. The Atlas cohort builder

  2. The Capr R package

  3. Custom SQL and/or R code




Atlas is a web application that provides a graphical user interface for creating cohort definitions. . To get started with Atlas check out the free course on [Ehden Academy](https://academy.ehden.eu/course/index.php) and the demo at <https://atlas-demo.ohdsi.org/>.

Capr is an R package that provides a code-based interface for creating cohort definitions. The options available in Capr exactly match the options available in Atlas and the resulting cohort tables should be identical.

There are times when more customization is needed and it is possible to use bespoke SQL or dplyr code to build a cohort. CDMConnector provides the `generate_concept_cohort_set` function for quickly building simple cohorts that can then be a starting point for further subsetting.

Atlas cohorts are represented using json text files. To “generate” one or more Atlas cohorts on a cdm object use the `read_cohort_set` function to first read a folder of Atlas cohort json files into R. Then create the cohort table with `generate_cohort_set`. There can be an optional csv file called “CohortsToCreate.csv” in the folder that specifies the cohort IDs and names to use. If this file doesn’t exist IDs will be assigned automatically using alphabetical order of the filenames.
    
    
    pathToCohortJsonFiles <- [system.file](https://rdrr.io/r/base/system.file.html)("cohorts1", package = "CDMConnector")
    [list.files](https://rdrr.io/r/base/list.files.html)(pathToCohortJsonFiles)
    #> [1] "cerebral_venous_sinus_thrombosis_01.json"
    #> [2] "CohortsToCreate.csv"                     
    #> [3] "deep_vein_thrombosis_01.json"
    
    readr::[read_csv](https://readr.tidyverse.org/reference/read_delim.html)([file.path](https://rdrr.io/r/base/file.path.html)(pathToCohortJsonFiles, "CohortsToCreate.csv"),
                    show_col_types = FALSE)
    #> # A tibble: 2 × 3
    #>   cohortId cohortName                          jsonPath                         
    #>      <dbl> <chr>                               <chr>                            
    #> 1        1 cerebral_venous_sinus_thrombosis_01 cerebral_venous_sinus_thrombosis…
    #> 2        2 deep_vein_thrombosis_01             deep_vein_thrombosis_01.json

### Atlas cohort definitions

First we need to create our CDM object. Note that we will need to specify a `write_schema` when creating the object. Cohort tables will go into the CDM’s `write_schema`.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    pathToCohortJsonFiles <- [system.file](https://rdrr.io/r/base/system.file.html)("example_cohorts", package = "CDMConnector")
    [list.files](https://rdrr.io/r/base/list.files.html)(pathToCohortJsonFiles)
    #> [1] "GiBleed_default.json" "GIBleed_male.json"
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](../reference/eunomiaDir.html)("GiBleed"))
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, cdmName = "eunomia", cdmSchema = "main", writeSchema = "main")
    
    cohortSet <- [readCohortSet](../reference/readCohortSet.html)(pathToCohortJsonFiles) |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_name = snakecase::[to_snake_case](https://rdrr.io/pkg/snakecase/man/caseconverter.html)(cohort_name))
    
    cohortSet
    #> # A tibble: 2 × 5
    #>   cohort_definition_id cohort_name     cohort       json   cohort_name_snakecase
    #>                  <int> <chr>           <list>       <list> <chr>                
    #> 1                    1 gibleed_default <named list> <chr>  gibleed_default      
    #> 2                    2 gibleed_male    <named list> <chr>  gibleed_male
    
    cdm <- [generateCohortSet](../reference/generateCohortSet.html)(
      cdm = cdm, 
      cohortSet = cohortSet,
      name = "study_cohorts"
    )
    #> ℹ Generating 2 cohorts
    #> ℹ Generating cohort (1/2) - gibleed_default
    #> ✔ Generating cohort (1/2) - gibleed_default [126ms]
    #> 
    #> ℹ Generating cohort (2/2) - gibleed_male
    #> ✔ Generating cohort (2/2) - gibleed_male [119ms]
    #> 
    
    cdm$study_cohorts
    #> # Source:   table<study_cohorts> [?? x 4]
    #> # Database: DuckDB v1.3.1 [root@Darwin 23.1.0:R 4.3.3//private/var/folders/2j/8z0yfn1j69q8sxjc7vj9yhz40000gp/T/RtmpKeUm4S/file946e8a7e2cc.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <dbl> <date>            <date>         
    #>  1                    1       1713 2010-07-22        2018-05-16     
    #>  2                    1       1934 2000-09-08        2019-03-09     
    #>  3                    1       2579 1992-06-03        2019-06-17     
    #>  4                    1        422 2001-03-04        2019-04-28     
    #>  5                    1       3177 1950-07-05        2012-06-06     
    #>  6                    1       3960 1997-06-12        2019-04-20     
    #>  7                    1       4109 2002-03-25        2019-04-23     
    #>  8                    1        377 2003-04-02        2018-10-25     
    #>  9                    1        793 2010-06-18        2017-12-01     
    #> 10                    1       1464 2002-11-01        2018-11-22     
    #> # ℹ more rows

The generated cohort has associated metadata tables. We can access these with utility functions.

  * `cohort_count` contains the person and record counts for each cohort in the cohort set
  * `settings` table contains the cohort id and cohort name
  * `attrition` table contains the attrition information (persons, and records dropped at each sequential inclusion rule)


    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$study_cohorts)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            479             479
    #> 2                    2            237             237
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$study_cohorts)
    #> # A tibble: 2 × 2
    #>   cohort_definition_id cohort_name    
    #>                  <int> <chr>          
    #> 1                    1 gibleed_default
    #> 2                    2 gibleed_male
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$study_cohorts)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1            479             479         1 Qualifying init…
    #> 2                    1            479             479         2 Cohort records …
    #> 3                    2            479             479         1 Qualifying init…
    #> 4                    2            237             237         2 Male            
    #> 5                    2            237             237         3 30 days prior o…
    #> 6                    2            237             237         4 Cohort records …
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

Note the this cohort table is still in the database so it can be quite large. We can also join it to other CDM table or subset the entire cdm to just the persons in the cohort.
    
    
    cdm_gibleed <- cdm [%>%](../reference/pipe.html) 
      [cdmSubsetCohort](../reference/cdmSubsetCohort.html)(cohortTable = "study_cohorts")

### Subset a cohort

Suppose you have a generated cohort and you would like to create a new cohort that is a subset of the first. This can be done using the

First we will generate an example cohort set and then create a new cohort based on filtering the Atlas cohort.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](../reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main")
    
    cohortSet <- [readCohortSet](../reference/readCohortSet.html)([system.file](https://rdrr.io/r/base/system.file.html)("cohorts3", package = "CDMConnector"))
    
    
    cdm <- [generateCohortSet](../reference/generateCohortSet.html)(cdm, cohortSet, name = "cohort") 
    #> ℹ Generating 5 cohorts
    #> ℹ Generating cohort (1/5) - gibleed_all_end_10
    #> ✔ Generating cohort (1/5) - gibleed_all_end_10 [70ms]
    #> 
    #> ℹ Generating cohort (2/5) - gibleed_all
    #> ✔ Generating cohort (2/5) - gibleed_all [56ms]
    #> 
    #> ℹ Generating cohort (3/5) - gibleed_default_with_descendants
    #> ✔ Generating cohort (3/5) - gibleed_default_with_descendants [57ms]
    #> 
    #> ℹ Generating cohort (4/5) - gibleed_default
    #> ✔ Generating cohort (4/5) - gibleed_default [53ms]
    #> 
    #> ℹ Generating cohort (5/5) - gibleed_end_10
    #> ✔ Generating cohort (5/5) - gibleed_end_10 [55ms]
    #> 
    
    cdm$cohort
    #> # Source:   table<cohort> [?? x 4]
    #> # Database: DuckDB v1.3.1 [root@Darwin 23.1.0:R 4.3.3//private/var/folders/2j/8z0yfn1j69q8sxjc7vj9yhz40000gp/T/RtmpKeUm4S/file946e5cf817a6.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <dbl> <date>            <date>         
    #>  1                    1       3928 2012-09-11        2012-09-21     
    #>  2                    1       1118 2014-07-07        2014-07-17     
    #>  3                    1       2834 1972-03-16        1972-03-26     
    #>  4                    1       3573 1963-12-21        1963-12-31     
    #>  5                    1       2649 1993-02-14        1993-02-24     
    #>  6                    1       5104 2017-06-24        2017-07-04     
    #>  7                    1       1498 2007-05-02        2007-05-12     
    #>  8                    1       1737 1950-09-18        1950-09-28     
    #>  9                    1       4450 2009-03-03        2009-03-13     
    #> 10                    1       5267 2006-04-03        2006-04-13     
    #> # ℹ more rows
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$cohort)
    #> # A tibble: 5 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            479             479
    #> 2                    2            479             479
    #> 3                    3            479             479
    #> 4                    4            479             479
    #> 5                    5            479             479

As an example we will take only people in the cohort that have a cohort duration that is longer than 4 weeks. Using dplyr we can write this query and save the result in a new table in the cdm.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm$cohort_subset <- cdm$cohort [%>%](../reference/pipe.html) 
      # only keep persons who are in the cohort at least 28 days
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(!![datediff](../reference/datediff.html)("cohort_start_date", "cohort_end_date") >= 28) [%>%](../reference/pipe.html) 
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(name = "cohort_subset", temporary = FALSE, overwrite = TRUE) [%>%](../reference/pipe.html) 
      [newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)()
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$cohort_subset)
    #> # A tibble: 5 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            479             479
    #> 2                    2            479             479
    #> 3                    3            479             479
    #> 4                    4            479             479
    #> 5                    5            479             479

In this case we can see that cohorts 1 and 5 were dropped completely and some patients were dropped from cohorts 2, 3, and 4.

Let’s confirm that everyone in cohorts 1 and 5 were in the cohort for less than 28 days.
    
    
    daysInCohort <- cdm$cohort [%>%](../reference/pipe.html) 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_definition_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)(1,5)) [%>%](../reference/pipe.html) 
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(days_in_cohort = !![datediff](../reference/datediff.html)("cohort_start_date", "cohort_end_date")) [%>%](../reference/pipe.html) 
      [count](https://dplyr.tidyverse.org/reference/count.html)(cohort_definition_id, days_in_cohort) [%>%](../reference/pipe.html) 
      [collect](https://dplyr.tidyverse.org/reference/compute.html)()
    
    daysInCohort
    #> # A tibble: 8 × 3
    #>   cohort_definition_id days_in_cohort     n
    #>                  <int>          <dbl> <dbl>
    #> 1                    5              1    10
    #> 2                    5             10   467
    #> 3                    5              9     1
    #> 4                    1              9     1
    #> 5                    1             10   467
    #> 6                    1              1    10
    #> 7                    1              2     1
    #> 8                    5              2     1

We have confirmed that everyone in cohorts 1 and 5 were in the cohort less than 10 days.

Now suppose we would like to create a new cohort table with three different versions of the cohorts in the original cohort table. We will keep persons who are in the cohort at 2 weeks, 3 weeks, and 4 weeks. We can simply write some custom dplyr to create the table and then call `new_generated_cohort_set` just like in the previous example.
    
    
    
    cdm$cohort_subset <- cdm$cohort [%>%](../reference/pipe.html) 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(!![datediff](../reference/datediff.html)("cohort_start_date", "cohort_end_date") >= 14) [%>%](../reference/pipe.html) 
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_definition_id = 10 + cohort_definition_id) [%>%](../reference/pipe.html) 
      [union_all](https://dplyr.tidyverse.org/reference/setops.html)(
        cdm$cohort [%>%](../reference/pipe.html)
        [filter](https://dplyr.tidyverse.org/reference/filter.html)(!![datediff](../reference/datediff.html)("cohort_start_date", "cohort_end_date") >= 21) [%>%](../reference/pipe.html) 
        [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_definition_id = 100 + cohort_definition_id)
      ) [%>%](../reference/pipe.html) 
      [union_all](https://dplyr.tidyverse.org/reference/setops.html)(
        cdm$cohort [%>%](../reference/pipe.html) 
        [filter](https://dplyr.tidyverse.org/reference/filter.html)(!![datediff](../reference/datediff.html)("cohort_start_date", "cohort_end_date") >= 28) [%>%](../reference/pipe.html) 
        [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_definition_id = 1000 + cohort_definition_id)
      ) [%>%](../reference/pipe.html) 
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(name = "cohort_subset", temporary = FALSE, overwrite = TRUE) # %>% 
      # newCohortTable() # this function creates the cohort object and metadata
    
    cdm$cohort_subset [%>%](../reference/pipe.html) 
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(days_in_cohort = !![datediff](../reference/datediff.html)("cohort_start_date", "cohort_end_date")) [%>%](../reference/pipe.html) 
      [group_by](https://dplyr.tidyverse.org/reference/group_by.html)(cohort_definition_id) [%>%](../reference/pipe.html) 
      [summarize](https://dplyr.tidyverse.org/reference/summarise.html)(mean_days_in_cohort = [mean](https://rdrr.io/r/base/mean.html)(days_in_cohort, na.rm = TRUE)) [%>%](../reference/pipe.html) 
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html) 
      [arrange](https://dplyr.tidyverse.org/reference/arrange.html)(mean_days_in_cohort)
    #> # A tibble: 9 × 2
    #>   cohort_definition_id mean_days_in_cohort
    #>                  <dbl>               <dbl>
    #> 1                   14               7586.
    #> 2                   13               7586.
    #> 3                   12               7586.
    #> 4                 1004               7602.
    #> 5                  102               7602.
    #> 6                 1002               7602.
    #> 7                  104               7602.
    #> 8                  103               7602.
    #> 9                 1003               7602.

This is an example of creating new cohorts from existing cohorts using CDMConnector. There is a lot of flexibility with this approach. Next we will look at completely custom cohort creation which is quite similar.

### Custom Cohort Creation

Sometimes you may want to create cohorts that cannot be easily expressed using Atlas or Capr. In these situations you can create implement cohort creation using SQL or R. See the chapter in [The Book of OHDSI](https://ohdsi.github.io/TheBookOfOhdsi/Cohorts.html#implementing-the-cohort-using-sql) for details on using SQL to create cohorts. CDMConnector provides a helper function to build simple cohorts from a list of OMOP concepts. `generate_concept_cohort_set` accepts a named list of concept sets and will create cohorts based on those concept sets. While this function does not allow for inclusion/exclusion criteria in the initial definition, additional criteria can be applied “manually” after the initial generation.
    
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [generateConceptCohortSet](../reference/generateConceptCohortSet.html)(
      cdm, 
      conceptSet = [list](https://rdrr.io/r/base/list.html)(gibleed = 192671), 
      name = "gibleed2", # name of the cohort table
      limit = "all", # use all occurrences of the concept instead of just the first
      end = 10 # set explicit cohort end date 10 days after start
    )
    
    cdm$gibleed2 <- cdm$gibleed2 [%>%](../reference/pipe.html) 
      [semi_join](https://dplyr.tidyverse.org/reference/filter-joins.html)(
        [filter](https://dplyr.tidyverse.org/reference/filter.html)(cdm$person, gender_concept_id == 8507), 
        by = [c](https://rdrr.io/r/base/c.html)("subject_id" = "person_id")
      ) [%>%](../reference/pipe.html) 
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)(reason = "Male")
      
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$gibleed2) 
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1            479             479         1 Initial qualify…
    #> 2                    1            237             237         2 Male            
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

In the above example we built a cohort table from a concept set. The cohort essentially captures patient-time based off of the presence or absence of OMOP standard concept IDs. We then manually applied an inclusion criteria and recorded a new attrition record in the cohort. To learn more about this approach to building cohorts check out the [PatientProfiles](https://darwin-eu.github.io/PatientProfiles/) R package.

You can also create a generated cohort set using any method you choose. As long as the table is in the CDM database and has the four required columns it can be added to the CDM object as a generated cohort set.

Suppose for example our cohort table is
    
    
    cohort <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1L,
      subject_id = 1L,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1999-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2001-01-01")
    )
    
    cohort
    #> # A tibble: 1 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 1999-01-01        2001-01-01

First make sure the table is in the database and create a dplyr table reference to it and add it to the CDM object.
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    #> 
    #> Attaching package: 'omopgenerics'
    #> The following object is masked from 'package:stats':
    #> 
    #>     filter
    cdm <- [insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm = cdm, name = "cohort", table = cohort, overwrite = TRUE)
    
    cdm$cohort
    #> # Source:   table<cohort> [?? x 4]
    #> # Database: DuckDB v1.3.1 [root@Darwin 23.1.0:R 4.3.3//private/var/folders/2j/8z0yfn1j69q8sxjc7vj9yhz40000gp/T/RtmpKeUm4S/file946e5cf817a6.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 1999-01-01        2001-01-01

To make this a true generated cohort object use the `cohort_table`
    
    
    cdm$cohort <- [newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)(cdm$cohort)

We can see that this cohort is now has the class “cohort_table” as well as the various metadata tables.
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort)
    #> # A tibble: 1 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

If you would like to override the attribute tables then pass additional dataframes to cohortTable
    
    
    cdm <- [insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm = cdm, name = "cohort2", table = cohort, overwrite = TRUE)
    cdm$cohort2 <- [newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)(cdm$cohort2)
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1
    
    cohort_set <- [data.frame](https://rdrr.io/r/base/data.frame.html)(cohort_definition_id = 1L,
                             cohort_name = "made_up_cohort")
    cdm$cohort2 <- [newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)(cdm$cohort2, cohortSetRef = cohort_set)
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name   
    #>                  <int> <chr>         
    #> 1                    1 made_up_cohort
    
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)

Cohort building is a fundamental building block of observational health analysis and CDMConnector supports different ways of creating cohorts. As long as your cohort table is has the required structure and columns you can add it to the cdm with the `new_generated_cohort_set` function and use it in any downstream OHDSI analytic packages.

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
