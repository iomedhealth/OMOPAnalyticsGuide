# Behind the scenes • CohortConstructor

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

# Behind the scenes

Source: [`vignettes/a12_behind_the_scenes.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a12_behind_the_scenes.Rmd)

`a12_behind_the_scenes.Rmd`

In previous vignettes we have seen numerous R functions that can help us to add a cohort of interest to a cdm reference. When our cdm reference is to tables in a database, as is often the code, our R code will have been translated to SQL that is run against tables in the databases (for more details on how this is all implemented see <https://oxford-pharmacoepi.github.io/Tidy-R-programming-with-OMOP/>).

Let’s again work with Eunomia and get the codes needed to create a set of drug cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(),
                     dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main", 
                      writePrefix = "my_study_")
    drug_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm, 
                                         name = [c](https://rdrr.io/r/base/c.html)("acetaminophen",
                                                  "amoxicillin", 
                                                  "diclofenac", 
                                                  "simvastatin",
                                                  "warfarin"))

To capture all the SQL executed as we use CohortConstructor functions we can set a global option. For this, we just need to point to a directory in which we’ll save each SQL statement run behind the scenes. Note that in this example we’re using duckdb so the SQL is for this database management system. If you were running on a different type of database the SQL would be adapted accordingly.
    
    
    dir_sql <- [file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "sql_folder")
    [dir.create](https://rdrr.io/r/base/files2.html)(dir_sql)
    [options](https://rdrr.io/r/base/options.html)("omopgenerics.log_sql_path" = dir_sql)
    
    cdm$drugs <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = drug_codes,
                               exit = "event_end_date",
                               name = "drugs")
    
    # print sql in order they were saved
    files <- [file.info](https://rdrr.io/r/base/file.info.html)([list.files](https://rdrr.io/r/base/list.files.html)(dir_sql, full.names = TRUE))
    sorted_files <- [rownames](https://rdrr.io/r/base/colnames.html)(files[[order](https://rdrr.io/r/base/order.html)(files$ctime),])
    for(i in [seq_along](https://rdrr.io/r/base/seq.html)(sorted_files)) {
      [cat](https://rdrr.io/r/base/cat.html)([paste0](https://rdrr.io/r/base/paste.html)("### ", sorted_files[i], "\n\n"))
      sql_with_quotes <- [paste0](https://rdrr.io/r/base/paste.html)('"', [paste](https://rdrr.io/r/base/paste.html)([readLines](https://rdrr.io/r/base/readLines.html)(sorted_files[i]), collapse = '\n'), '"')
      [cat](https://rdrr.io/r/base/cat.html)(sql_with_quotes, "\n```\n\n")
    }
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00003_on_2025_09_19_at_08_25_11.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: tmp_001_og_004_1758270312
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_uploadCohortCodelist
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   CAST(concept_id AS INTEGER) AS concept_id,
    #>   LOWER(domain_id) AS domain_id
    #> FROM (
    #>   SELECT my_study_tmp_001_og_004_1758270312.*, domain_id
    #>   FROM my_study_tmp_001_og_004_1758270312
    #>   LEFT JOIN concept
    #>     ON (my_study_tmp_001_og_004_1758270312.concept_id = concept.concept_id)
    #> ) q01" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00004_on_2025_09_19_at_08_25_12.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: og_005_1758270312_1
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_tempCohort_
    #> <SQL>
    #> SELECT
    #>   person_id AS subject_id,
    #>   drug_concept_id AS concept_id,
    #>   drug_exposure_start_date AS cohort_start_date,
    #>   drug_exposure_end_date AS cohort_end_date,
    #>   cohort_definition_id
    #> FROM drug_exposure
    #> INNER JOIN (
    #>   SELECT concept_id, cohort_definition_id
    #>   FROM my_study_tmp_001_og_004_1758270312
    #>   WHERE (domain_id IN ('drug'))
    #> ) RHS
    #>   ON (drug_exposure.drug_concept_id = RHS.concept_id)" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00005_on_2025_09_19_at_08_25_12.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_conceptCohort_reduce_
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   subject_id,
    #>   cohort_start_date,
    #>   COALESCE(cohort_end_date, cohort_start_date) AS cohort_end_date
    #> FROM my_study_og_005_1758270312_1" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00006_on_2025_09_19_at_08_25_12.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_observationJoin_
    #> <SQL>
    #> SELECT
    #>   my_study_drugs.*,
    #>   observation_period_id,
    #>   observation_period_start_date,
    #>   observation_period_end_date
    #> FROM my_study_drugs
    #> LEFT JOIN observation_period
    #>   ON (my_study_drugs.subject_id = observation_period.person_id)" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00007_on_2025_09_19_at_08_25_13.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_useRecordsBeforeObservation_
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   subject_id,
    #>   cohort_start_date,
    #>   CASE WHEN (observation_period_end_date >= cohort_end_date) THEN cohort_end_date WHEN NOT (observation_period_end_date >= cohort_end_date) THEN observation_period_end_date END AS cohort_end_date
    #> FROM my_study_drugs
    #> WHERE
    #>   (cohort_start_date >= observation_period_start_date) AND
    #>   (cohort_start_date <= observation_period_end_date)" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00008_on_2025_09_19_at_08_25_13.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_filterStartEnd_
    #> <SQL>
    #> SELECT my_study_drugs.*
    #> FROM my_study_drugs
    #> WHERE
    #>   (NOT((cohort_start_date IS NULL))) AND
    #>   (cohort_start_date <= cohort_end_date)" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00009_on_2025_09_19_at_08_25_14.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_sex_
    #> <SQL>
    #> SELECT q01.*
    #> FROM (
    #>   SELECT my_study_drugs.*, gender_concept_id, year_of_birth
    #>   FROM my_study_drugs
    #>   INNER JOIN person
    #>     ON (my_study_drugs.subject_id = person.person_id)
    #> ) q01
    #> WHERE (NOT((gender_concept_id IS NULL)))" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00010_on_2025_09_19_at_08_25_15.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_birth_year_
    #> <SQL>
    #> SELECT cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
    #> FROM my_study_drugs
    #> WHERE (NOT((year_of_birth IS NULL)))" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00011_on_2025_09_19_at_08_25_15.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: og_006_1758270316
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_joinOverlap_workingTbl_
    #> <SQL>
    #> SELECT q01.*, -1.0 AS date_id
    #> FROM (
    #>   SELECT cohort_definition_id, subject_id, cohort_start_date AS date
    #>   FROM my_study_drugs
    #> ) q01
    #> 
    #> UNION ALL
    #> 
    #> SELECT q01.*, 1.0 AS date_id
    #> FROM (
    #>   SELECT cohort_definition_id, subject_id, cohort_end_date AS date
    #>   FROM my_study_drugs
    #> ) q01" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00012_on_2025_09_19_at_08_25_15.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: og_006_1758270316
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_joinOverlap_ids_
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   subject_id,
    #>   SUM(CAST(era_id AS NUMERIC)) OVER (PARTITION BY cohort_definition_id, subject_id ORDER BY date, date_id ROWS UNBOUNDED PRECEDING) AS era_id,
    #>   "name",
    #>   date
    #> FROM (
    #>   SELECT
    #>     my_study_og_006_1758270316.*,
    #>     SUM(date_id) OVER (PARTITION BY cohort_definition_id, subject_id ORDER BY date, date_id ROWS UNBOUNDED PRECEDING) AS cum_id,
    #>     CASE WHEN (date_id = -1.0) THEN 'cohort_start_date' WHEN NOT (date_id = -1.0) THEN 'cohort_end_date' END AS "name",
    #>     CASE WHEN (date_id = -1.0) THEN 1.0 WHEN NOT (date_id = -1.0) THEN 0.0 END AS era_id
    #>   FROM my_study_og_006_1758270316
    #> ) q01
    #> WHERE (cum_id = 0.0 OR (cum_id = -1.0 AND date_id = -1.0))" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00013_on_2025_09_19_at_08_25_16.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: og_006_1758270316
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_joinOverlap_pivot_wider_
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   subject_id,
    #>   MAX(CASE WHEN ("name" = 'cohort_start_date') THEN date END) AS cohort_start_date,
    #>   MAX(CASE WHEN ("name" = 'cohort_end_date') THEN date END) AS cohort_end_date
    #> FROM my_study_og_006_1758270316
    #> GROUP BY cohort_definition_id, subject_id, era_id" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00014_on_2025_09_19_at_08_25_16.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_joinOverlap_relocate_
    #> <SQL>
    #> SELECT DISTINCT my_study_og_006_1758270316.*
    #> FROM my_study_og_006_1758270316" 
    #> ```

If we want even more detail, we also have the option to see the execution plan along with the SQL.
    
    
    dir_explain <- [file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "explain_folder")
    [dir.create](https://rdrr.io/r/base/files2.html)(dir_explain)
    [options](https://rdrr.io/r/base/options.html)("omopgenerics.log_sql_explain_path" = dir_explain)
    
    cdm$drugs <- cdm$drugs |> 
      [requireIsFirstEntry](../reference/requireIsFirstEntry.html)()
    
    files <- [list.files](https://rdrr.io/r/base/list.files.html)(dir_explain, full.names = TRUE)
    file_names <- [list.files](https://rdrr.io/r/base/list.files.html)(dir_explain, full.names = FALSE)
    
    for(i in [seq_along](https://rdrr.io/r/base/seq.html)(files)) {
      [cat](https://rdrr.io/r/base/cat.html)([paste0](https://rdrr.io/r/base/paste.html)("### ", file_names[i], "\n\n"))
      sql_with_quotes <- [paste0](https://rdrr.io/r/base/paste.html)('"', [paste](https://rdrr.io/r/base/paste.html)([readLines](https://rdrr.io/r/base/readLines.html)(files[i]), collapse = '\n'), '"')
      [cat](https://rdrr.io/r/base/cat.html)(sql_with_quotes, "\n```\n\n")
    }
    #> ### logged_explain_00015_on_2025_09_19_at_08_25_18.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_requireIsFirstEntry_min_
    #> <SQL>
    #> SELECT cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
    #> FROM (
    #>   SELECT
    #>     my_study_drugs.*,
    #>     MIN(cohort_start_date) OVER (PARTITION BY subject_id, cohort_definition_id) AS col01
    #>   FROM my_study_drugs
    #> ) q01
    #> WHERE (cohort_start_date = col01)
    #> 
    #> <PLAN>
    #> physical_plan
    #> ┌───────────────────────────┐
    #> │         PROJECTION        │
    #> │    ────────────────────   │
    #> │             #0            │
    #> │             #1            │
    #> │             #2            │
    #> │             #3            │
    #> │                           │
    #> │         ~3872 Rows        │
    #> └─────────────┬─────────────┘
    #> ┌─────────────┴─────────────┐
    #> │           FILTER          │
    #> │    ────────────────────   │
    #> │(cohort_start_date = col01)│
    #> │                           │
    #> │         ~3872 Rows        │
    #> └─────────────┬─────────────┘
    #> ┌─────────────┴─────────────┐
    #> │         PROJECTION        │
    #> │    ────────────────────   │
    #> │             #0            │
    #> │             #1            │
    #> │             #2            │
    #> │             #3            │
    #> │             #4            │
    #> │                           │
    #> │        ~19364 Rows        │
    #> └─────────────┬─────────────┘
    #> ┌─────────────┴─────────────┐
    #> │           WINDOW          │
    #> │    ────────────────────   │
    #> │        Projections:       │
    #> │   min(cohort_start_date)  │
    #> │     OVER (PARTITION BY    │
    #> │         subject_id,       │
    #> │    cohort_definition_id)  │
    #> └─────────────┬─────────────┘
    #> ┌─────────────┴─────────────┐
    #> │         SEQ_SCAN          │
    #> │    ────────────────────   │
    #> │   Table: my_study_drugs   │
    #> │   Type: Sequential Scan   │
    #> │                           │
    #> │        Projections:       │
    #> │    cohort_definition_id   │
    #> │         subject_id        │
    #> │     cohort_start_date     │
    #> │      cohort_end_date      │
    #> │                           │
    #> │        ~19364 Rows        │
    #> └───────────────────────────┘" 
    #> ```

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
