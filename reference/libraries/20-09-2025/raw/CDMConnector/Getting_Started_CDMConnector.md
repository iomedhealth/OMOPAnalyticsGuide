# Getting Started • CDMConnector

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

# Getting Started

Source: [`vignettes/a01_getting-started.Rmd`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/vignettes/a01_getting-started.Rmd)

`a01_getting-started.Rmd`

The Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM) is a commonly used format for storing and analyzing observational health data derived from electronic health records, insurance claims, registries, and other sources. Source data is “mapped” into the OMOP CDM format providing researchers with a standardized interface for querying and analyzing observational health data. The CDMConnector package provides tools for working with OMOP Common Data Model (CDM) tables using familiar [dplyr](https://dplyr.tidyverse.org) syntax and using the [tidyverse design principles](https://design.tidyverse.org/) popular in the R ecosystem.

This vignette is for new users of CDMConnector who have access to data already mapped into the OMOP CDM format. However, CDMConnector does provide several example synthetic datasets in the OMOP CDM format. To learn more about the OMOP CDM or the mapping process check out these resources.

  * <https://academy.ehden.eu/>

  * <https://ohdsi.github.io/TheBookOfOhdsi/>

  * <https://www.ohdsi.org/join-the-journey/>

  * <https://ohdsi.github.io/CommonDataModel/>




### Creating a reference to the OMOP CDM

Typically OMOP CDM datasets are stored in a database and can range in size from hundreds of patients with thousands of records to hundreds of millions of patients with billions of records. The Observational Health Data Science and Informatics (OHDSI) community supports a selection of popular database platforms including Postgres, Microsoft SQL Server, Oracle, as well as cloud data platforms such as Amazon Redshift, Google Big Query, Databricks, and Snowflake. The first step in using CDMConnector is to create a connection to your database from R. This can take some effort the first time you set up drivers. See the “Database Connection Examples” vignette or check out the [Posit’s database documentation.](https://solutions.posit.co/connections/db/getting-started/connect-to-database/)

In our example’s we will use some synthetic data from the [Synthea project](https://synthetichealth.github.io/synthea/) that has been mapped to the OMOP CDM format. We’ll use the [duckdb](https://duckdb.org/) database which is a file based database similar to SQLite but with better date type support. To see all the example datasets available run `[exampleDatasets()](../reference/exampleDatasets.html)`.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [exampleDatasets](../reference/exampleDatasets.html)()
    #>  [1] "GiBleed"                             "synthea-allergies-10k"              
    #>  [3] "synthea-anemia-10k"                  "synthea-breast_cancer-10k"          
    #>  [5] "synthea-contraceptives-10k"          "synthea-covid19-10k"                
    #>  [7] "synthea-covid19-200k"                "synthea-dermatitis-10k"             
    #>  [9] "synthea-heart-10k"                   "synthea-hiv-10k"                    
    #> [11] "synthea-lung_cancer-10k"             "synthea-medications-10k"            
    #> [13] "synthea-metabolic_syndrome-10k"      "synthea-opioid_addiction-10k"       
    #> [15] "synthea-rheumatoid_arthritis-10k"    "synthea-snf-10k"                    
    #> [17] "synthea-surgery-10k"                 "synthea-total_joint_replacement-10k"
    #> [19] "synthea-veteran_prostate_cancer-10k" "synthea-veterans-10k"               
    #> [21] "synthea-weight_loss-10k"             "synpuf-1k"                          
    #> [23] "empty_cdm"                           "Synthea27NjParquet"
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](../reference/eunomiaDir.html)("GiBleed"))
    DBI::[dbListTables](https://dbi.r-dbi.org/reference/dbListTables.html)(con)
    #>  [1] "care_site"             "cdm_source"            "concept"              
    #>  [4] "concept_ancestor"      "concept_class"         "concept_relationship" 
    #>  [7] "concept_synonym"       "condition_era"         "condition_occurrence" 
    #> [10] "cost"                  "death"                 "device_exposure"      
    #> [13] "domain"                "dose_era"              "drug_era"             
    #> [16] "drug_exposure"         "drug_strength"         "fact_relationship"    
    #> [19] "location"              "measurement"           "metadata"             
    #> [22] "note"                  "note_nlp"              "observation"          
    #> [25] "observation_period"    "payer_plan_period"     "person"               
    #> [28] "procedure_occurrence"  "provider"              "relationship"         
    #> [31] "source_to_concept_map" "specimen"              "visit_detail"         
    #> [34] "visit_occurrence"      "vocabulary"

If you’re using CDMConnector for the first time you may get a message about adding an environment variable `EUNOMIA_DATA_FOLDER` . To do this simply create a new text file in your home directory called .Renviron and add the line `EUNOMIA_DATA_FOLDER="path/to/folder/where/we/can/store/example/data"`. If you run `[usethis::edit_r_environ()](https://usethis.r-lib.org/reference/edit.html)` this file will be created and opened for you and opened in RStudio.

After connecting to a database containing data mapped to the OMOP CDM, use `cdmFromCon` to create a CDM reference. This CDM reference is a single object that contains dplyr table references to each CDM table along with metadata about the CDM instance.

The `cdmSchema` is the schema in the database that contains the OMOP CDM tables and is required. The `writeSchema` is a schema in the database where the user has the ability to create tables. Both `cdmSchema` and `writeSchema` are required to create a cdm object.

Every cdm object needs a `cdmName` that is used to identify the CDM in output files.
    
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, cdmName = "eunomia", cdmSchema = "main", writeSchema = "main")
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: person, observation_period, visit_occurrence, visit_detail,
    #> condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
    #> measurement, observation, death, note, note_nlp, specimen, fact_relationship,
    #> location, care_site, provider, payer_plan_period, cost, drug_era, dose_era,
    #> condition_era, metadata, cdm_source, concept, vocabulary, domain,
    #> concept_class, concept_relationship, relationship, concept_synonym,
    #> concept_ancestor, source_to_concept_map, drug_strength
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    cdm$observation_period
    #> # Source:   table<observation_period> [?? x 5]
    #> # Database: DuckDB v1.3.1 [root@Darwin 23.1.0:R 4.3.3//private/var/folders/2j/8z0yfn1j69q8sxjc7vj9yhz40000gp/T/RtmpNbq2PQ/file94507d1bee41.duckdb]
    #>    observation_period_id person_id observation_period_s…¹ observation_period_e…²
    #>                    <int>     <int> <date>                 <date>                
    #>  1                     6         6 1963-12-31             2007-02-06            
    #>  2                    13        13 2009-04-26             2019-04-14            
    #>  3                    27        27 2002-01-30             2018-11-21            
    #>  4                    16        16 1971-10-14             2017-11-02            
    #>  5                    55        55 2009-05-30             2019-03-23            
    #>  6                    60        60 1990-11-21             2019-01-23            
    #>  7                    42        42 1909-11-03             2019-03-13            
    #>  8                    33        33 1986-05-12             2018-09-10            
    #>  9                    18        18 1965-11-17             2018-11-07            
    #> 10                    25        25 2007-03-18             2019-04-07            
    #> # ℹ more rows
    #> # ℹ abbreviated names: ¹​observation_period_start_date,
    #> #   ²​observation_period_end_date
    #> # ℹ 1 more variable: period_type_concept_id <int>

Individual CDM table references can be accessed using `$`.
    
    
    cdm$person [%>%](../reference/pipe.html) 
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 18
    #> Database: DuckDB v1.3.1 [root@Darwin 23.1.0:R 4.3.3//private/var/folders/2j/8z0yfn1j69q8sxjc7vj9yhz40000gp/T/RtmpNbq2PQ/file94507d1bee41.duckdb]
    #> $ person_id                   <int> 6, 123, 129, 16, 65, 74, 42, 187, 18, 111,…
    #> $ gender_concept_id           <int> 8532, 8507, 8507, 8532, 8532, 8532, 8532, …
    #> $ year_of_birth               <int> 1963, 1950, 1974, 1971, 1967, 1972, 1909, …
    #> $ month_of_birth              <int> 12, 4, 10, 10, 3, 1, 11, 7, 11, 5, 8, 3, 3…
    #> $ day_of_birth                <int> 31, 12, 7, 13, 31, 5, 2, 23, 17, 2, 19, 13…
    #> $ birth_datetime              <dttm> 1963-12-31, 1950-04-12, 1974-10-07, 1971-…
    #> $ race_concept_id             <int> 8516, 8527, 8527, 8527, 8516, 8527, 8527, …
    #> $ ethnicity_concept_id        <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ person_source_value         <chr> "001f4a87-70d0-435c-a4b9-1425f6928d33", "0…
    #> $ gender_source_value         <chr> "F", "M", "M", "F", "F", "F", "F", "M", "F…
    #> $ gender_source_concept_id    <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ race_source_value           <chr> "black", "white", "white", "white", "black…
    #> $ race_source_concept_id      <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ ethnicity_source_value      <chr> "west_indian", "italian", "polish", "ameri…
    #> $ ethnicity_source_concept_id <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …

You can then use dplyr to query the cdm tables just as you would an R dataframe. The difference is that the data stays in the database and SQL code is dynamically generated and set to the database backend. The goal is to allow users to not think too much about the database or SQL and instead use familiar R syntax to work with these large tables. `collect` will bring the data from the database into R. Be careful not to request a gigantic result set! In general it is better to aggregate data in the database, if possible, before bringing data into R.
    
    
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
    
    cdm$person [%>%](../reference/pipe.html) 
      [group_by](https://dplyr.tidyverse.org/reference/group_by.html)(year_of_birth, gender_concept_id) [%>%](../reference/pipe.html) 
      [summarize](https://dplyr.tidyverse.org/reference/summarise.html)(n = [n](https://dplyr.tidyverse.org/reference/context.html)(), .groups = "drop") [%>%](../reference/pipe.html) 
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html) 
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(sex = [case_when](https://dplyr.tidyverse.org/reference/case_when.html)(
        gender_concept_id == 8532 ~ "Female",
        gender_concept_id == 8507 ~ "Male"
      )) [%>%](../reference/pipe.html) 
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(y = n, x = year_of_birth, fill = sex)) +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)(stat = "identity", position = "dodge") +
      [labs](https://ggplot2.tidyverse.org/reference/labs.html)(x = "Year of birth", 
           y = "Person count", 
           title = "Age Distribution",
           subtitle = [cdmName](https://darwin-eu.github.io/omopgenerics/reference/cdmName.html)(cdm),
           fill = NULL) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)()

![](a01_getting-started_files/figure-html/unnamed-chunk-4-1.png)

### Joining tables

Since the OMOP CDM is a relational data model joins are very common in analytic code. All of the events in the OMOP CDM are recorded using integers representing standard “concepts”. To see the text description of a concept researchers need to join clinical tables to the concept vocabulary table. Every OMOP CDM should have a copy of the vocabulary used to map the data to the OMOP CDM format.

Here is an example query looking at the most common conditions in the CDM.
    
    
    cdm$condition_occurrence [%>%](../reference/pipe.html) 
      [count](https://dplyr.tidyverse.org/reference/count.html)(condition_concept_id, sort = T) [%>%](../reference/pipe.html) 
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(cdm$concept, by = [c](https://rdrr.io/r/base/c.html)("condition_concept_id" = "concept_id")) [%>%](../reference/pipe.html) 
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html) 
      [select](https://dplyr.tidyverse.org/reference/select.html)("condition_concept_id", "concept_name", "n") 
    #> # A tibble: 80 × 3
    #>    condition_concept_id concept_name                                           n
    #>                   <int> <chr>                                              <dbl>
    #>  1              4116491 Escherichia coli urinary tract infection             482
    #>  2              4113008 Laceration of hand                                   500
    #>  3              4156265 Facial laceration                                    497
    #>  4              4155034 Laceration of forearm                                507
    #>  5              4109685 Laceration of foot                                   484
    #>  6              4094814 Bullet wound                                          46
    #>  7              4048695 Fracture of vertebral column without spinal cord …    23
    #>  8             40486433 Perennial allergic rhinitis                           64
    #>  9              4051466 Childhood asthma                                      96
    #> 10              4142905 Fracture of rib                                      263
    #> # ℹ 70 more rows

Let’s look at the most common drugs used by patients with “Acute viral pharyngitis”.
    
    
    cdm$condition_occurrence [%>%](../reference/pipe.html) 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(condition_concept_id == 4112343) [%>%](../reference/pipe.html) 
      [distinct](https://dplyr.tidyverse.org/reference/distinct.html)(person_id) [%>%](../reference/pipe.html) 
      [inner_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(cdm$drug_exposure, by = "person_id") [%>%](../reference/pipe.html) 
      [count](https://dplyr.tidyverse.org/reference/count.html)(drug_concept_id, sort = TRUE) [%>%](../reference/pipe.html) 
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(cdm$concept, by = [c](https://rdrr.io/r/base/c.html)("drug_concept_id" = "concept_id")) [%>%](../reference/pipe.html) 
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html) 
      [select](https://dplyr.tidyverse.org/reference/select.html)("concept_name", "n") 
    #> # A tibble: 113 × 2
    #>    concept_name                                                          n
    #>    <chr>                                                             <dbl>
    #>  1 Acetaminophen 325 MG / Hydrocodone Bitartrate 7.5 MG Oral Tablet    305
    #>  2 Penicillin V Potassium 250 MG Oral Tablet                          1666
    #>  3 Methylphenidate Hydrochloride 20 MG Oral Tablet                      63
    #>  4 Amoxicillin 500 MG Oral Tablet                                      246
    #>  5 Warfarin Sodium 5 MG Oral Tablet                                    135
    #>  6 remifentanil                                                         16
    #>  7 Piperacillin 4000 MG / tazobactam 500 MG Injection                   35
    #>  8 {28 (Norethindrone 0.35 MG Oral Tablet) } Pack [Jolivette 28 Day]    12
    #>  9 Lorazepam 2 MG/ML Injectable Solution                                 1
    #> 10 Penicillin V Potassium 500 MG Oral Tablet                          1060
    #> # ℹ 103 more rows

To inspect the generated SQL use `show_query` from dplyr.
    
    
    cdm$condition_occurrence [%>%](../reference/pipe.html) 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(condition_concept_id == 4112343) [%>%](../reference/pipe.html) 
      [distinct](https://dplyr.tidyverse.org/reference/distinct.html)(person_id) [%>%](../reference/pipe.html) 
      [inner_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(cdm$drug_exposure, by = "person_id") [%>%](../reference/pipe.html) 
      [count](https://dplyr.tidyverse.org/reference/count.html)(drug_concept_id, sort = TRUE) [%>%](../reference/pipe.html) 
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(cdm$concept, by = [c](https://rdrr.io/r/base/c.html)("drug_concept_id" = "concept_id")) [%>%](../reference/pipe.html) 
      [show_query](https://dplyr.tidyverse.org/reference/explain.html)() 
    #> <SQL>
    #> SELECT
    #>   LHS.*,
    #>   concept_name,
    #>   domain_id,
    #>   vocabulary_id,
    #>   concept_class_id,
    #>   standard_concept,
    #>   concept_code,
    #>   valid_start_date,
    #>   valid_end_date,
    #>   invalid_reason
    #> FROM (
    #>   SELECT drug_concept_id, COUNT(*) AS n
    #>   FROM (
    #>     SELECT
    #>       LHS.person_id AS person_id,
    #>       drug_exposure_id,
    #>       drug_concept_id,
    #>       drug_exposure_start_date,
    #>       drug_exposure_start_datetime,
    #>       drug_exposure_end_date,
    #>       drug_exposure_end_datetime,
    #>       verbatim_end_date,
    #>       drug_type_concept_id,
    #>       stop_reason,
    #>       refills,
    #>       quantity,
    #>       days_supply,
    #>       sig,
    #>       route_concept_id,
    #>       lot_number,
    #>       provider_id,
    #>       visit_occurrence_id,
    #>       visit_detail_id,
    #>       drug_source_value,
    #>       drug_source_concept_id,
    #>       route_source_value,
    #>       dose_unit_source_value
    #>     FROM (
    #>       SELECT DISTINCT person_id
    #>       FROM condition_occurrence
    #>       WHERE (condition_concept_id = 4112343.0)
    #>     ) LHS
    #>     INNER JOIN drug_exposure
    #>       ON (LHS.person_id = drug_exposure.person_id)
    #>   ) q01
    #>   GROUP BY drug_concept_id
    #> ) LHS
    #> LEFT JOIN concept
    #>   ON (LHS.drug_concept_id = concept.concept_id)

These are a few simple queries. More complex queries can be built by combining simple queries like the ones above and other analytic packages provide functions that implement common analytic use cases.

For example a “cohort definition” is a set of criteria that persons must satisfy that can be quite complex. The “Working with Cohorts” vignette describes creating and using cohorts with CDMConnector.

### Saving query results to the database

Sometimes it is helpful to save query results to the database instead of reading the result into R. dplyr provides the `compute` function but due to differences between database systems CDMConnector has needed to export its own method that handles the slight differences. Internally CDMConnector runs `compute_query` function that is tested across the OHDSI supported database platforms.

If we are writing data to the CDM database we need to add one more argument when creating our cdm reference object, the “write_schema”. This is a schema in the database where you have write permissions. Typically this should be a separate schema from the “cdm_schema”.
    
    
    DBI::[dbExecute](https://dbi.r-dbi.org/reference/dbExecute.html)(con, "create schema scratch;")
    #> [1] 0
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, cdmName = "eunomia", cdmSchema = "main", writeSchema = "scratch")
    #> Note: method with signature 'DBIConnection#Id' chosen for function 'dbExistsTable',
    #>  target signature 'duckdb_connection#Id'.
    #>  "duckdb_connection#ANY" would also be valid
    
    
    
    drugs <- cdm$condition_occurrence [%>%](../reference/pipe.html) 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(condition_concept_id == 4112343) [%>%](../reference/pipe.html) 
      [distinct](https://dplyr.tidyverse.org/reference/distinct.html)(person_id) [%>%](../reference/pipe.html) 
      [inner_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(cdm$drug_exposure, by = "person_id") [%>%](../reference/pipe.html) 
      [count](https://dplyr.tidyverse.org/reference/count.html)(drug_concept_id, sort = TRUE) [%>%](../reference/pipe.html) 
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(cdm$concept, by = [c](https://rdrr.io/r/base/c.html)("drug_concept_id" = "concept_id")) [%>%](../reference/pipe.html) 
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(name = "test", temporary = FALSE, overwrite = TRUE)
    
    drugs [%>%](../reference/pipe.html) [show_query](https://dplyr.tidyverse.org/reference/explain.html)()
    #> <SQL>
    #> SELECT *
    #> FROM scratch.test
    
    drugs
    #> # Source:   table<scratch.test> [?? x 11]
    #> # Database: DuckDB v1.3.1 [root@Darwin 23.1.0:R 4.3.3//private/var/folders/2j/8z0yfn1j69q8sxjc7vj9yhz40000gp/T/RtmpNbq2PQ/file94507d1bee41.duckdb]
    #>    drug_concept_id     n concept_name   domain_id vocabulary_id concept_class_id
    #>              <int> <dbl> <chr>          <chr>     <chr>         <chr>           
    #>  1        40213306  1826 hepatitis B v… Drug      CVX           CVX             
    #>  2        40173590   129 Alendronic ac… Drug      RxNorm        Clinical Drug   
    #>  3        40220960   210 alteplase 100… Drug      RxNorm        Clinical Drug   
    #>  4        19126352   207 Nitroglycerin… Drug      RxNorm        Clinical Drug   
    #>  5         1545959    57 atorvastatin … Drug      RxNorm        Clinical Drug   
    #>  6         1154029     8 Fentanyl       Drug      RxNorm        Ingredient      
    #>  7         1519937     6 Etonogestrel … Drug      RxNorm        Clinical Drug   
    #>  8         1127078  2060 Acetaminophen… Drug      RxNorm        Clinical Drug   
    #>  9         1127433  9125 Acetaminophen… Drug      RxNorm        Clinical Drug   
    #> 10        40232448   100 Diphenhydrami… Drug      RxNorm        Clinical Drug   
    #> # ℹ more rows
    #> # ℹ 5 more variables: standard_concept <chr>, concept_code <chr>,
    #> #   valid_start_date <date>, valid_end_date <date>, invalid_reason <chr>

We can see that the query has been saved to a new table in the scratch schema. `compute` returns a dplyr reference to this table.

### Selecting a subset of CDM tables

If you do not need references to all tables you can easily select only a subset of tables to include in the CDM reference. The `cdmSelect` function supports the [tidyselect selection language](https://tidyselect.r-lib.org/reference/language.html) and provides a new selection helper: `tbl_group`.
    
    
    cdm [%>%](../reference/pipe.html) [cdmSelect](https://darwin-eu.github.io/omopgenerics/reference/cdmSelect.html)("person", "observation_period") # quoted names
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: person, observation_period
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    cdm [%>%](../reference/pipe.html) [cdmSelect](https://darwin-eu.github.io/omopgenerics/reference/cdmSelect.html)(person, observation_period) # unquoted names 
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: person, observation_period
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    cdm [%>%](../reference/pipe.html) [cdmSelect](https://darwin-eu.github.io/omopgenerics/reference/cdmSelect.html)([starts_with](https://tidyselect.r-lib.org/reference/starts_with.html)("concept")) # tables that start with 'concept'
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: concept, concept_class, concept_relationship, concept_synonym,
    #> concept_ancestor
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    cdm [%>%](../reference/pipe.html) [cdmSelect](https://darwin-eu.github.io/omopgenerics/reference/cdmSelect.html)([contains](https://tidyselect.r-lib.org/reference/starts_with.html)("era")) # tables that contain the substring 'era'
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: drug_era, dose_era, condition_era
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    cdm [%>%](../reference/pipe.html) [cdmSelect](https://darwin-eu.github.io/omopgenerics/reference/cdmSelect.html)([matches](https://tidyselect.r-lib.org/reference/starts_with.html)("person|period")) # regular expression
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: person, observation_period, payer_plan_period
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

Predefined sets of tables can also be selected using `tbl_group` which supports several subsets of the CDM: “all”, “clinical”, “vocab”, “derived”, and “default”.
    
    
    # pre-defined groups
    cdm [%>%](../reference/pipe.html) [cdmSelect](https://darwin-eu.github.io/omopgenerics/reference/cdmSelect.html)([tblGroup](../reference/tblGroup.html)("clinical")) 
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: person, observation_period, visit_occurrence, visit_detail,
    #> condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
    #> measurement, observation, death, note, note_nlp, specimen, fact_relationship
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    cdm [%>%](../reference/pipe.html) [cdmSelect](https://darwin-eu.github.io/omopgenerics/reference/cdmSelect.html)([tblGroup](../reference/tblGroup.html)("vocab")) 
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: concept, vocabulary, domain, concept_class,
    #> concept_relationship, relationship, concept_synonym, concept_ancestor,
    #> source_to_concept_map, drug_strength
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

The default set of CDM tables included in a CDM object is:
    
    
    [tblGroup](../reference/tblGroup.html)("default")
    #>  [1] "person"               "observation_period"   "visit_occurrence"    
    #>  [4] "condition_occurrence" "drug_exposure"        "procedure_occurrence"
    #>  [7] "measurement"          "observation"          "death"               
    #> [10] "location"             "care_site"            "provider"            
    #> [13] "drug_era"             "dose_era"             "condition_era"       
    #> [16] "cdm_source"           "concept"              "vocabulary"          
    #> [19] "concept_relationship" "concept_synonym"      "concept_ancestor"    
    #> [22] "drug_strength"

### Subsetting a CDM

Sometimes it is helpful to subset a CDM to a specific set of persons or simply down sample the data to a more reasonable size. Let’s subset our cdm to just persons with a Pneumonia (concept_id 255848). This works best then the number of persons in the subset is quite small and the database has indexes on the “person_id” columns of each table.
    
    
    personIds <- cdm$condition_occurrence [%>%](../reference/pipe.html) 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(condition_concept_id == 255848) [%>%](../reference/pipe.html) 
      [distinct](https://dplyr.tidyverse.org/reference/distinct.html)(person_id) [%>%](../reference/pipe.html) 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)(person_id)
    
    [length](https://rdrr.io/r/base/length.html)(personIds)
    #> [1] 52
    
    cdm_pneumonia <- cdm [%>%](../reference/pipe.html)
      [cdmSubset](../reference/cdmSubset.html)(personId = personIds)
    
    [tally](https://dplyr.tidyverse.org/reference/count.html)(cdm_pneumonia$person) [%>%](../reference/pipe.html) 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)(n)
    #> [1] 52
    
    cdm_pneumonia$condition_occurrence [%>%](../reference/pipe.html) 
      [distinct](https://dplyr.tidyverse.org/reference/distinct.html)(person_id) [%>%](../reference/pipe.html) 
      [tally](https://dplyr.tidyverse.org/reference/count.html)() [%>%](../reference/pipe.html) 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)(n)
    #> [1] 52

Alternatively if we simply want a random sample of the entire CDM we can use `cdm_sample`.
    
    
    
    cdm_100person <- [cdmSample](../reference/cdmSample.html)(cdm, n = 100)
    
    [tally](https://dplyr.tidyverse.org/reference/count.html)(cdm_100person$person) [%>%](../reference/pipe.html) [pull](https://dplyr.tidyverse.org/reference/pull.html)("n")
    #> [1] 100

## Flatten a CDM

An OMOP CDM is a relational data model. Sometimes it is helpful to flatten this relational structure into a “tidy” dataframe with one row per observation. This transformation should only be done with a small number of persons and events.
    
    
    [cdmFlatten](../reference/cdmFlatten.html)(cdm_pneumonia,
               domain = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "drug_exposure", "measurement")) [%>%](../reference/pipe.html) 
      [collect](https://dplyr.tidyverse.org/reference/compute.html)()
    #> # A tibble: 3,892 × 8
    #>    person_id observation_concept_id start_date end_date   type_concept_id domain
    #>        <int>                  <int> <date>     <date>               <int> <chr> 
    #>  1      2801                4024958 1939-05-11 1939-05-11            5001 measu…
    #>  2      3614                4024958 1992-07-22 1992-07-22            5001 measu…
    #>  3       550                3006322 1965-09-13 1965-09-13            5001 measu…
    #>  4      3811                3006322 1967-08-31 1967-08-31            5001 measu…
    #>  5       419                3006322 1915-01-11 1915-01-11            5001 measu…
    #>  6      5073                4112343 1996-04-30 1996-05-09           32020 condi…
    #>  7      2333                 381316 2007-04-03 NA                   32020 condi…
    #>  8      4976               19059056 1917-08-16 1917-11-14        38000177 drug_…
    #>  9      2821               40481087 1998-01-10 1998-01-17           32020 condi…
    #> 10       190                 260139 1949-12-26 1950-01-09           32020 condi…
    #> # ℹ 3,882 more rows
    #> # ℹ 2 more variables: observation_concept_name <chr>, type_concept_name <chr>

### Closing connections

Close the database connection with `dbDisconnect`. After a connection is closed any cdm objects created with that connection can no longer be used.
    
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)

### Summary

CDMConnector provides an interface to working with observational health data in the OMOP CDM format from R. Check out the other vignettes for more details about the package.

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
