# 5  Creating a CDM reference – Tidy R programming with databases: applications with the OMOP common data model

__

  1. [Working with the OMOP CDM from R](./omop.html)
  2. [5 Creating a CDM reference](./cdm_reference.html)

__

[Tidy R programming with databases: applications with the OMOP common data model](./)

  * [ Preface](./index.html)

  * [ Getting started with working databases from R](./intro.html) __

    * [ 1 A first analysis using data in a database](./working_with_databases_from_r.html)

    * [ 2 Core verbs for analytic pipelines utilising a database](./tidyverse_verbs.html)

    * [ 3 Supported expressions for database queries](./tidyverse_expressions.html)

    * [ 4 Building analytic pipelines for a data model](./dbplyr_packages.html)

  * [ Working with the OMOP CDM from R](./omop.html) __

    * [ 5 Creating a CDM reference](./cdm_reference.html)

    * [ 6 Exploring the OMOP CDM](./exploring_the_cdm.html)

    * [ 7 Identifying patient characteristics](./adding_features.html)

    * [ 8 Adding cohorts to the CDM](./creating_cohorts.html)

    * [ 9 Working with cohorts](./working_with_cohorts.html)




## Table of contents

  * 5.1 The OMOP common data model (CDM) layout
  * 5.2 Creating a reference to the OMOP CDM
  * 5.3 CDM attributes
    * 5.3.1 CDM name
    * 5.3.2 CDM version
  * 5.4 Including cohort tables in the cdm reference
  * 5.5 Including achilles tables in the cdm reference
  * 5.6 Adding other tables to the cdm reference
  * 5.7 Mutability of the cdm reference
  * 5.8 Working with temporary and permanent tables
  * 6 Disconnecting
  * 7 Further reading



  1. [Working with the OMOP CDM from R](./omop.html)
  2. [5 Creating a CDM reference](./cdm_reference.html)



# 5 Creating a CDM reference

## 5.1 The OMOP common data model (CDM) layout

The OMOP CDM standardises the structure of healthcare data. Data is stored across a system of tables with established relationships between them. In other words, the OMOP CDM provides a relational database structure, with version 5.4 of the OMOP CDM shown below. [![](images/erd.jpg)](images/erd.jpg)

## 5.2 Creating a reference to the OMOP CDM

As we saw in [Chapter 4](dbplyr_packages.html), creating a data model in R to represent the OMOP CDM can provide a basis for analytic pipelines using the data. Luckily for us, we won’t have to create functions and methods for this ourselves. Instead, we will use the `omopgenerics` package which defines a data model for OMOP CDM data and the `CDMConnector` package which provides functions for connecting to a OMOP CDM data held in a database.

To see how this works we will use the `omock` package to create example data in the format of the OMOP CDM, which we will then copy to a `duckdb` database.
    
    
    library(DBI)
    library(duckdb)
    library(here)
    library(dplyr)
    library(omock)
    library(omopgenerics)
    library(CDMConnector)
    library(palmerpenguins)
    
    cdm_local <- mockCdmReference() |>
        mockPerson(nPerson = 100) |>
        mockObservationPeriod() |>
        mockConditionOccurrence() |>
        mockDrugExposure() |>
        mockObservation() |>
        mockMeasurement() |>
        mockVisitOccurrence() |>
        mockProcedureOccurrence()
    
    db <- dbConnect(drv = duckdb())
    
    cdm <- insertCdmTo(cdm = cdm_local,
                       to = dbSource(con = db, writeSchema = "main"))__

Now that we have OMOP CDM data in a database, we can use the function `cdmFromCon()` from `CDMConnector` to create our cdm reference. Note that as well as specifying the schema containing our OMOP CDM tables, we will also specify a write schema where any database tables we create during our analysis will be stored. Often our OMOP CDM tables will be in a schema that we only have read-access to and we’ll have another schema where we can have write-access and where intermediate tables can be created for a given study.
    
    
    cdm <- cdmFromCon(db, 
                      cdmSchema = "main", 
                      writeSchema = "main",
                      cdmName = "example_data")__
    
    
    cdm __
    
    
    ── # OMOP CDM reference (duckdb) of example_data ───────────────────────────────
    
    
    • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    concept_synonym, condition_occurrence, drug_exposure, drug_strength,
    measurement, observation, observation_period, person, procedure_occurrence,
    visit_occurrence, vocabulary
    
    
    • cohort tables: -
    
    
    • achilles tables: -
    
    
    • other tables: -

__

Setting a write prefix 

__

We can also specify a write prefix and this will be used whenever permanent tables are created in the write schema. This can be useful when we’re sharing our write schema with others and want to avoid table name conflicts and easily drop tables created as part of a particular study.
    
    
    cdm <- cdmFromCon(con = db,
                      cdmSchema = "main", 
                      writeSchema = "main", 
                      writePrefix = "my_study_",
                      cdmName = "example_data")__

We can see that we now have an object that contains references to all the OMOP CDM tables. We can reference specific tables using the “$” or “[[ … ]]” operators.
    
    
    cdm$person __
    
    
    # Source:   table<person> [?? x 18]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
       person_id gender_concept_id year_of_birth month_of_birth day_of_birth
           <int>             <int>         <int>          <int>        <int>
     1         1              8507          1998             10           21
     2         2              8507          1986              8           22
     3         3              8507          2000             12           18
     4         4              8507          1971              8           12
     5         5              8507          1981             10           14
     6         6              8507          1973             12           16
     7         7              8507          1955              1           22
     8         8              8532          1978             12            4
     9         9              8507          1980             10           20
    10        10              8532          1956              3           15
    # ℹ more rows
    # ℹ 13 more variables: race_concept_id <int>, ethnicity_concept_id <int>,
    #   birth_datetime <dttm>, location_id <int>, provider_id <int>,
    #   care_site_id <int>, person_source_value <chr>, gender_source_value <chr>,
    #   gender_source_concept_id <int>, race_source_value <chr>,
    #   race_source_concept_id <int>, ethnicity_source_value <chr>,
    #   ethnicity_source_concept_id <int>
    
    
    cdm[["observation_period"]]__
    
    
    # Source:   table<observation_period> [?? x 5]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
       observation_period_id person_id observation_period_s…¹ observation_period_e…²
                       <int>     <int> <date>                 <date>                
     1                     1         1 2011-04-26             2019-07-27            
     2                     2         2 2002-07-15             2011-06-17            
     3                     3         3 2015-12-15             2019-01-22            
     4                     4         4 1996-06-16             2000-01-05            
     5                     5         5 1994-09-05             2004-05-08            
     6                     6         6 2013-08-09             2019-01-25            
     7                     7         7 1963-07-06             1993-09-13            
     8                     8         8 2008-08-07             2017-09-17            
     9                     9         9 2001-05-31             2009-04-10            
    10                    10        10 1989-04-03             2013-11-29            
    # ℹ more rows
    # ℹ abbreviated names: ¹​observation_period_start_date,
    #   ²​observation_period_end_date
    # ℹ 1 more variable: period_type_concept_id <int>

Note that here we have first created a local version of the cdm with all the tables of interest with `omock`, then copied it to a `duckdb` database, and finally crated a reference to it with `CDMConnector`, so that we can work with the final `cdm` object as we normally would for one created with our own healthcare data. In that case we would directly use `cdmFromCon` with our own database information. Throughout this chapter, however, we will keep working with the mock dataset.

## 5.3 CDM attributes

### 5.3.1 CDM name

Our cdm reference will be associated with a name. By default this name will be taken from the `cdm_source_name` field from the `cdm_source` table. We will use the function `cdmName` from `omopgenerics` to get it.
    
    
    cdm <- cdmFromCon(db,
      cdmSchema = "main", 
      writeSchema = "main")
    cdm$cdm_source __
    
    
    # Source:   table<cdm_source> [?? x 10]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
      cdm_source_name cdm_source_abbreviation cdm_holder source_description
      <chr>           <chr>                   <chr>      <chr>             
    1 mock            <NA>                    <NA>       <NA>              
    # ℹ 6 more variables: source_documentation_reference <chr>,
    #   cdm_etl_reference <chr>, source_release_date <date>,
    #   cdm_release_date <date>, cdm_version <chr>, vocabulary_version <chr>
    
    
    cdmName(cdm)__
    
    
    [1] "mock"

However, we can instead set this name to whatever else we want when creating our cdm reference.
    
    
    cdm <- cdmFromCon(db,
      cdmSchema = "main", 
      writeSchema = "main", 
      cdmName = "my_cdm")
    cdmName(cdm)__
    
    
    [1] "my_cdm"

Note that we can also get our cdm name from any of the tables in our cdm reference.
    
    
    cdmName(cdm$person)__
    
    
    [1] "my_cdm"

__

Behind the scenes 

__

The class of the cdm reference itself is cdm_reference.
    
    
    class(cdm)__
    
    
    [1] "cdm_reference"
    
    
    class(cdm$person)__
    
    
    [1] "omop_table"            "cdm_table"             "tbl_duckdb_connection"
    [4] "tbl_dbi"               "tbl_sql"               "tbl_lazy"             
    [7] "tbl"                  

Each of the tables has class cdm_table. If the table is one of the standard OMOP CDM tables it will also have class omop_table. This latter class is defined so that we can allow different behaviour for these core tables (person, condition_occurrence, observation_period, etc.) compared to other tables that are added to the cdm reference during the course of running a study.
    
    
    class(cdm$person)__
    
    
    [1] "omop_table"            "cdm_table"             "tbl_duckdb_connection"
    [4] "tbl_dbi"               "tbl_sql"               "tbl_lazy"             
    [7] "tbl"                  

We can see that `cdmName()` is a generic function, which works for both the cdm reference as a whole and individual tables.
    
    
    library(sloop)
    s3_dispatch(cdmName(cdm))__
    
    
    => cdmName.cdm_reference
     * cdmName.default
    
    
    s3_dispatch(cdmName(cdm$person))__
    
    
       cdmName.omop_table
    => cdmName.cdm_table
       cdmName.tbl_duckdb_connection
       cdmName.tbl_dbi
       cdmName.tbl_sql
       cdmName.tbl_lazy
       cdmName.tbl
     * cdmName.default

### 5.3.2 CDM version

We can also easily check the OMOP CDM version that is being used with the function `cdmVersion` from `omopgenerics` like so:
    
    
    cdmVersion(cdm)__
    
    
    [1] "5.3"

## 5.4 Including cohort tables in the cdm reference

We’ll be seeing how to create cohorts in more detail in ?sec-creating_cohorts. For the moment, let’s just outline how we can include a cohort in our cdm reference. For this we’ll use `omock` to add a cohort to our local cdm and upload that to a `duckdb` database again.
    
    
    cdm_local <- cdm_local |> 
      mockCohort(name = "my_study_cohort")
    db <- dbConnect(drv = duckdb())
    cdm <- insertCdmTo(cdm = cdm_local,
                       to = dbSource(con = db, writeSchema = "main"))__

Now we can specify we want to include this existing cohort table to our cdm object when creating our cdm reference.
    
    
    cdm <- cdmFromCon(db, 
                      cdmSchema = "main", 
                      writeSchema = "main",
                      cohortTables = "my_study_cohort",
                      cdmName = "example_data")
    cdm __
    
    
    cdm$my_study_cohort |> 
      glimpse()__
    
    
    Rows: ??
    Columns: 4
    Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
    $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    $ subject_id           <int> 3, 4, 6, 6, 7, 8, 8, 9, 9, 9, 10, 11, 12, 12, 14,…
    $ cohort_start_date    <date> 2018-05-06, 1999-06-10, 2013-12-18, 2015-05-24, …
    $ cohort_end_date      <date> 2018-11-30, 1999-09-21, 2014-09-15, 2017-05-02, …

## 5.5 Including achilles tables in the cdm reference

If we have the results tables from the [Achilles R package](https://ohdsi.github.io/Achilles/) in our database, we can also include these in our cdm reference.

Just to show how this can be done let’s upload some empty results tables in the Achilles format.
    
    
    dbWriteTable(db, 
                 "achilles_analysis",
                 tibble(
                   analysis_id = NA_integer_,
                   analysis_name = NA_character_,
                   stratum_1_name = NA_character_,
                   stratum_2_name = NA_character_,
                   stratum_3_name = NA_character_,
                   stratum_4_name = NA_character_,
                   stratum_5_name = NA_character_,
                   is_default = NA_character_,
                   category = NA_character_))
    dbWriteTable(db, 
                 "achilles_results",
                 tibble(
                   analysis_id = NA_integer_,
                   stratum_1 = NA_character_,
                   stratum_2 = NA_character_,
                   stratum_3 = NA_character_,
                   stratum_4 = NA_character_,
                   stratum_5 = NA_character_,
                   count_value = NA_character_))
    dbWriteTable(db, 
                 "achilles_results_dist",
                 tibble(
                   analysis_id = NA_integer_,
                   stratum_1 = NA_character_,
                   stratum_2 = NA_character_,
                   stratum_3 = NA_character_,
                   stratum_4 = NA_character_,
                   stratum_5 = NA_character_,
                   count_value = NA_character_,
                   min_value = NA_character_,
                   max_value = NA_character_,
                   avg_value = NA_character_,
                   stdev_value = NA_character_,
                   median_value = NA_character_,
                   p10_value = NA_character_,
                   p25_value = NA_character_,
                   p75_value = NA_character_,
                   p90_value = NA_character_))__

We can now include these achilles table in our cdm reference as in the previous case.
    
    
    cdm <- cdmFromCon(db, 
                      cdmSchema = "main", 
                      writeSchema = "main",
                      cohortTables = "my_study_cohort",
                      achillesSchema = "main",
                      cdmName = "example_data")
    cdm __

## 5.6 Adding other tables to the cdm reference

Let’s say we have some additional local data that we want to add to our cdm reference. We can add this both to the same source (in this case a database) and to our cdm reference using `insertTable` from `omopgenerics`. We will show this with the dataset `cars` in-built in R.
    
    
    cars |> 
      glimpse()__
    
    
    Rows: 50
    Columns: 2
    $ speed <dbl> 4, 4, 7, 7, 8, 9, 10, 10, 10, 11, 11, 12, 12, 12, 12, 13, 13, 13…
    $ dist  <dbl> 2, 10, 4, 22, 16, 10, 18, 26, 34, 17, 28, 14, 20, 24, 28, 26, 34…
    
    
    cdm <- insertTable(cdm = cdm, 
                       name = "cars", 
                       table = cars, 
                       temporary = FALSE)__

We can see that now this extra table has been uploaded to the database behind our cdm reference and also added to our reference.
    
    
    cdm __
    
    
    ── # OMOP CDM reference (duckdb) of example_data ───────────────────────────────
    
    
    • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    concept_synonym, condition_occurrence, drug_exposure, drug_strength,
    measurement, observation, observation_period, person, procedure_occurrence,
    visit_occurrence, vocabulary
    
    
    • cohort tables: my_study_cohort
    
    
    • achilles tables: achilles_analysis, achilles_results, achilles_results_dist
    
    
    • other tables: cars
    
    
    cdm$cars __
    
    
    # Source:   table<cars> [?? x 2]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
       speed  dist
       <dbl> <dbl>
     1     4     2
     2     4    10
     3     7     4
     4     7    22
     5     8    16
     6     9    10
     7    10    18
     8    10    26
     9    10    34
    10    11    17
    # ℹ more rows

If we already had the table in the database we could have instead just assigned it to our existing cdm reference. To see this let’s upload the `penguins` table to our `duckdb` database.
    
    
    dbWriteTable(db, 
                 "penguins",
                 penguins)__

Once we have this table in the database, we can just assign it to our cdm reference.
    
    
    cdm$penguins <- tbl(db, "penguins")
    
    cdm __
    
    
    ── # OMOP CDM reference (duckdb) of example_data ───────────────────────────────
    
    
    • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    concept_synonym, condition_occurrence, drug_exposure, drug_strength,
    measurement, observation, observation_period, person, procedure_occurrence,
    visit_occurrence, vocabulary
    
    
    • cohort tables: my_study_cohort
    
    
    • achilles tables: achilles_analysis, achilles_results, achilles_results_dist
    
    
    • other tables: cars, penguins

## 5.7 Mutability of the cdm reference

An important characteristic of our cdm reference is that we can alter the tables in R, but the OMOP CDM data will not be affected. We will therefore only be transforming the data in our cdm object but the original datasets behind it will remain intact.

For example, let’s say we want to perform a study with only people born in 1970. For this we could filter our person table to only people born in this year.
    
    
    cdm$person <- cdm$person |> 
      filter(year_of_birth == 1970)
    
    cdm$person __
    
    
    # Source:   SQL [?? x 18]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
      person_id gender_concept_id year_of_birth month_of_birth day_of_birth
          <int>             <int>         <int>          <int>        <int>
    1        22              8507          1970             11           29
    # ℹ 13 more variables: race_concept_id <int>, ethnicity_concept_id <int>,
    #   birth_datetime <dttm>, location_id <int>, provider_id <int>,
    #   care_site_id <int>, person_source_value <chr>, gender_source_value <chr>,
    #   gender_source_concept_id <int>, race_source_value <chr>,
    #   race_source_concept_id <int>, ethnicity_source_value <chr>,
    #   ethnicity_source_concept_id <int>

From now on, when we work with our cdm reference this restriction will continue to have been applied.
    
    
    cdm$person |> 
        tally()__
    
    
    # Source:   SQL [?? x 1]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
          n
      <dbl>
    1     1

The original OMOP CDM data itself however will remain unaffected. We can see that, indeed, if we create our reference again the underlying data is unchanged.
    
    
    cdm <- cdmFromCon(con = db,
                      cdmSchema = "main", 
                      writeSchema = "main", 
                      cdmName = "Synthea Covid-19 data")
    cdm$person |> 
        tally()__
    
    
    # Source:   SQL [?? x 1]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
          n
      <dbl>
    1   100

The mutability of our cdm reference is a useful feature for studies as it means we can easily tweak our OMOP CDM data if needed. Meanwhile, leaving the underlying data unchanged is essential so that other study code can run against the data, unaffected by any of our changes.

One thing we can’t do, though, is alter the structure of OMOP CDM tables. For example, the following code would cause an error as the person table must always have the column person_id.
    
    
    cdm$person <- cdm$person |> 
        rename("new_id" = "person_id")__
    
    
    Error in `newOmopTable()`:
    ! person_id is not present in table person

In such a case we would have to call the table something else first, and then run the previous code:
    
    
    cdm$person_new <- cdm$person |> 
        rename("new_id" = "person_id") |> 
        compute(name = "person_new", 
                temporary = TRUE)__

Now we would be allowed to have this new table as an additional table in our cdm reference, knowing it was not in the format of one of the core OMOP CDM tables.
    
    
    cdm __
    
    
    ── # OMOP CDM reference (duckdb) of Synthea Covid-19 data ──────────────────────
    
    
    • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    concept_synonym, condition_occurrence, drug_exposure, drug_strength,
    measurement, observation, observation_period, person, procedure_occurrence,
    visit_occurrence, vocabulary
    
    
    • cohort tables: -
    
    
    • achilles tables: -
    
    
    • other tables: -

The package `omopgenerics` provides a comprehensive list of the required features of a valid cdm reference. You can read more about it [here](https://darwin-eu-dev.github.io/omopgenerics/articles/cdm_reference.html).

## 5.8 Working with temporary and permanent tables

When we create new tables and our cdm reference is in a database we have a choice between using temporary or permanent tables. In most cases we can work with these interchangeably. Below we create one temporary table and one permanent table. We can see that both of these tables have been added to our cdm reference and that we can use them in the same way. Note that any new computed table will by default be temporary unless otherwise specified.
    
    
    cdm$person_new_temp <- cdm$person |> 
      head(5) |> 
      compute()__
    
    
    cdm$person_new_permanent <- cdm$person |> 
      head(5) |> 
      compute(name = "person_new_permanent", 
              temporary = FALSE)__
    
    
    cdm
    
    cdm$person_new_temp __
    
    
    # Source:   table<og_001_1757550306> [?? x 18]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
      person_id gender_concept_id year_of_birth month_of_birth day_of_birth
          <int>             <int>         <int>          <int>        <int>
    1         1              8507          1998             10           21
    2         2              8507          1986              8           22
    3         3              8507          2000             12           18
    4         4              8507          1971              8           12
    5         5              8507          1981             10           14
    # ℹ 13 more variables: race_concept_id <int>, ethnicity_concept_id <int>,
    #   birth_datetime <dttm>, location_id <int>, provider_id <int>,
    #   care_site_id <int>, person_source_value <chr>, gender_source_value <chr>,
    #   gender_source_concept_id <int>, race_source_value <chr>,
    #   race_source_concept_id <int>, ethnicity_source_value <chr>,
    #   ethnicity_source_concept_id <int>
    
    
    cdm$person_new_permanent __
    
    
    # Source:   table<person_new_permanent> [?? x 18]
    # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.4.1/:memory:]
      person_id gender_concept_id year_of_birth month_of_birth day_of_birth
          <int>             <int>         <int>          <int>        <int>
    1         1              8507          1998             10           21
    2         2              8507          1986              8           22
    3         3              8507          2000             12           18
    4         4              8507          1971              8           12
    5         5              8507          1981             10           14
    # ℹ 13 more variables: race_concept_id <int>, ethnicity_concept_id <int>,
    #   birth_datetime <dttm>, location_id <int>, provider_id <int>,
    #   care_site_id <int>, person_source_value <chr>, gender_source_value <chr>,
    #   gender_source_concept_id <int>, race_source_value <chr>,
    #   race_source_concept_id <int>, ethnicity_source_value <chr>,
    #   ethnicity_source_concept_id <int>

One benefit of working with temporary tables is that they will be automatically dropped at the end of the session, whereas the permanent tables will be left over in the database until explicitly dropped. This helps maintain the original database structure tidy and free of irrelevant data.

However, one disadvantage of using temporary tables is that we will generally accumulate more and more of them as we go (in a single R session), whereas we can overwrite permanent tables continuously. For example, if our study code contains a loop that requires a compute, we would either overwrite an intermediate permanent table 100 times or create 100 different temporary tables in the process. In the latter case we should be wary of consuming a lot of RAM, which could lead to performance issues or even crashes.

# 6 Disconnecting

Once we have finished our analysis we can close our connection to the database behind our cdm reference.
    
    
    cdmDisconnect(cdm) __

# 7 Further reading

  * [omopgenerics package](https://darwin-eu.github.io/omopgenerics)
  * [CDMConnector package](https://darwin-eu.github.io/CDMConnector)



[ __ Working with the OMOP CDM from R ](./omop.html)

[ 6 Exploring the OMOP CDM __](./exploring_the_cdm.html)
