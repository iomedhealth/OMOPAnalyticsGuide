# Concatenating cohort records • CohortConstructor

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

# Concatenating cohort records

Source: [`vignettes/a06_concatanate_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a06_concatanate_cohorts.Rmd)

`a06_concatanate_cohorts.Rmd`
    
    
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

Let’s start by creating a cohort of users of acetaminophen
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1127433), 
                                     name = "medications")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580

We can merge cohort records using the `[collapseCohorts()](../reference/collapseCohorts.html)` function in the CohortConstructor package. The function allows us to specifying the number of days between two cohort entries, which will then be merged into a single record.

Let’s first define a new cohort where records within 1095 days (~ 3 years) of each other will be merged.
    
    
    cdm$medications_collapsed <- cdm$medications |> 
      [collapseCohorts](../reference/collapseCohorts.html)(
      gap = 1095,
      name = "medications_collapsed"
    )

Let’s compare how this function would change the records of a single individual.
    
    
    cdm$medications |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 1)
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpKSn3kh/file295f2362deec.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 1980-03-15        1980-03-29     
    #> 2                    1          1 1971-01-04        1971-01-18     
    #> 3                    1          1 1982-09-11        1982-10-02     
    #> 4                    1          1 1976-10-20        1976-11-03
    cdm$medications_collapsed |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 1)
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpKSn3kh/file295f2362deec.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 1980-03-15        1982-10-02     
    #> 2                    1          1 1971-01-04        1971-01-18     
    #> 3                    1          1 1976-10-20        1976-11-03

Subject 1 initially had 4 records between 1971 and 1982. After specifying that records within three years of each other are to be merged, the number of records decreases to three. The record from 1980-03-15 to 1980-03-29 and the record from 1982-09-11 to 1982-10-02 are merged to create a new record from 1980-03-15 to 1982-10-02.

Now let’s look at how the cohorts have been changed.
    
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$medications_collapsed)
    [tableCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortAttrition.html)(summary_attrition)

Reason |  Variable name  
---|---  
number_records | number_subjects | excluded_records | excluded_subjects  
Synthea; acetaminophen  
Initial qualifying events | 9,365 | 2,580 | 0 | 0  
Record in observation | 9,365 | 2,580 | 0 | 0  
Record start <= record end | 9,365 | 2,580 | 0 | 0  
Non-missing sex | 9,365 | 2,580 | 0 | 0  
Non-missing year of birth | 9,365 | 2,580 | 0 | 0  
Merge overlapping records | 9,365 | 2,580 | 0 | 0  
Collapse cohort with a gap of 1095 days. | 7,975 | 2,580 | 1,390 | 0  
  
Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
