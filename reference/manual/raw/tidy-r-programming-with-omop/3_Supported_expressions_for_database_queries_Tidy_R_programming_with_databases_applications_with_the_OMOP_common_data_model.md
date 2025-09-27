# 3  Supported expressions for database queries – Tidy R programming with databases: applications with the OMOP common data model

__

  1. [Getting started with working databases from R](./intro.html)
  2. [3 Supported expressions for database queries](./tidyverse_expressions.html)

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

  * 3.1 Data types
  * 3.2 Comparison and logical operators
  * 3.3 Conditional statements
  * 3.4 Working with strings
  * 3.5 Working with dates
  * 3.6 Data aggregation
  * 3.7 Window functions
  * 3.8 Calculating quantiles, including the median



  1. [Getting started with working databases from R](./intro.html)
  2. [3 Supported expressions for database queries](./tidyverse_expressions.html)



# 3 Supported expressions for database queries

In the previous chapter, [Chapter 2](tidyverse_verbs.html), we saw that there are a core set of tidyverse functions that can be used with databases to extract data for analysis. The SQL code used in the previous chapter would be the same for all database management systems, with only joins and variable selection being used.

For more complex data pipleines we will, however, often need to incorporate additional expressions within these functions. Because of differences across database management systems, the SQL these pipelines get translated to can vary. Moreover, some expressions may only be supported for some subset of databases. When writing code which we want to work across different database management systems we therefore need to keep in mind what is supported where. To help with this, the sections below show the available translations for common expressions we might wish to use.

Let’s first load the packages which these expressions come from. In addition to base R types, `bit64` adds support for integer64. The `stringr` package provides functions for working with strings, while `clock` has various functions for working with dates. Many other useful expressions will come from `dplyr` itself.
    
    
    library(duckdb)
    library(bit64)
    library(dplyr)
    library(dbplyr)
    library(stringr)
    library(clock)
    
    options(dplyr.strict_sql = TRUE) # force error if no known translation __

## 3.1 Data types

Commonly used data types are consistently supported across database backends. We can use the base `as.numeric()`, `as.integer()`, `as.charater()`, `as.Date()`, and `as.POSIXct()`. We can also use `as.integer64()` from the `bit64` package to coerce to integer64, and the `as_date()` and `as_datetime()` from the `clock` package instead of `as.Date()` and `as.POSIXct()`, respectively.

__

Show SQL 

__

  * duckdb
  * Redshift
  * Postgres
  * Snowflake
  * Spark
  * SQL Server


    
    
    translate_sql(as.numeric(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS NUMERIC)
    
    
    translate_sql(as.integer(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS INTEGER)
    
    
    translate_sql(as.integer64(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS BIGINT)
    
    
    translate_sql(as.character(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS TEXT)
    
    
    translate_sql(as.Date(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as_date(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as.POSIXct(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as_datetime(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as.logical(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> CAST(`var` AS BOOLEAN)
    
    
    translate_sql(as.numeric(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS FLOAT)
    
    
    translate_sql(as.integer(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS INTEGER)
    
    
    translate_sql(as.integer64(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS BIGINT)
    
    
    translate_sql(as.character(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS TEXT)
    
    
    translate_sql(as.Date(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as_date(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as.POSIXct(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as_datetime(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as.logical(var), 
                  con = simulate_redshift())__
    
    
    <SQL> CAST(`var` AS BOOLEAN)
    
    
    translate_sql(as.numeric(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS NUMERIC)
    
    
    translate_sql(as.integer(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS INTEGER)
    
    
    translate_sql(as.integer64(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS BIGINT)
    
    
    translate_sql(as.character(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS TEXT)
    
    
    translate_sql(as.Date(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as_date(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as.POSIXct(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as_datetime(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as.logical(var), 
                  con = simulate_postgres())__
    
    
    <SQL> CAST(`var` AS BOOLEAN)
    
    
    translate_sql(as.numeric(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS DOUBLE)
    
    
    translate_sql(as.integer(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS INT)
    
    
    translate_sql(as.integer64(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS BIGINT)
    
    
    translate_sql(as.character(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS STRING)
    
    
    translate_sql(as.Date(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as_date(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as.POSIXct(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as_datetime(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as.logical(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> CAST(`var` AS BOOLEAN)
    
    
    translate_sql(as.numeric(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS DOUBLE)
    
    
    translate_sql(as.integer(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS INT)
    
    
    translate_sql(as.integer64(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS BIGINT)
    
    
    translate_sql(as.character(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS STRING)
    
    
    translate_sql(as.Date(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as_date(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS DATE)
    
    
    translate_sql(as.POSIXct(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as_datetime(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS TIMESTAMP)
    
    
    translate_sql(as.logical(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CAST(`var` AS BOOLEAN)
    
    
    translate_sql(as.numeric(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(`var` AS FLOAT)
    
    
    translate_sql(as.integer(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(TRY_CAST(`var` AS NUMERIC) AS INT)
    
    
    translate_sql(as.integer64(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(TRY_CAST(`var` AS NUMERIC(38, 0)) AS BIGINT)
    
    
    translate_sql(as.character(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(`var` AS VARCHAR(MAX))
    
    
    translate_sql(as.Date(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(`var` AS DATE)
    
    
    translate_sql(as_date(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(`var` AS DATE)
    
    
    translate_sql(as.POSIXct(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(`var` AS DATETIME2)
    
    
    translate_sql(as_datetime(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(`var` AS DATETIME2)
    
    
    translate_sql(as.logical(var), 
                  con = simulate_mssql())__
    
    
    <SQL> TRY_CAST(`var` AS BIT)

## 3.2 Comparison and logical operators

Base R comparison operators, such as `<`, `<=`, `==`, `>=`, `>`, are also well supported in all database backends. Logical operators, such as `&` and `|` can also be used as if the data was in R.

__

Show SQL 

__

  * duckdb
  * Redshift
  * Postgres
  * Snowflake
  * Spark
  * SQL Server


    
    
    translate_sql(var_1 == var_2, 
                  con = simulate_duckdb())__
    
    
    <SQL> `var_1` = `var_2`
    
    
    translate_sql(var_1 >= var_2, 
                  con = simulate_duckdb())__
    
    
    <SQL> `var_1` >= `var_2`
    
    
    translate_sql(var_1 < 100, 
                  con = simulate_duckdb())__
    
    
    <SQL> `var_1` < 100.0
    
    
    translate_sql(var_1 %in% c("a", "b", "c"), 
                  con = simulate_duckdb())__
    
    
    <SQL> `var_1` IN ('a', 'b', 'c')
    
    
    translate_sql(!var_1 %in% c("a", "b", "c"), 
                  con = simulate_duckdb())__
    
    
    <SQL> NOT(`var_1` IN ('a', 'b', 'c'))
    
    
    translate_sql(is.na(var_1), 
                  con = simulate_duckdb())__
    
    
    <SQL> (`var_1` IS NULL)
    
    
    translate_sql(!is.na(var_1), 
                  con = simulate_duckdb())__
    
    
    <SQL> NOT((`var_1` IS NULL))
    
    
    translate_sql(var_1 >= 100 & var_1  < 200, 
                  con = simulate_duckdb())__
    
    
    <SQL> `var_1` >= 100.0 AND `var_1` < 200.0
    
    
    translate_sql(var_1 >= 100 | var_1  < 200, 
                  con = simulate_duckdb())__
    
    
    <SQL> `var_1` >= 100.0 OR `var_1` < 200.0
    
    
    translate_sql(var_1 == var_2, 
                  con = simulate_redshift())__
    
    
    <SQL> `var_1` = `var_2`
    
    
    translate_sql(var_1 >= var_2, 
                  con = simulate_redshift())__
    
    
    <SQL> `var_1` >= `var_2`
    
    
    translate_sql(var_1 < 100, 
                  con = simulate_redshift())__
    
    
    <SQL> `var_1` < 100.0
    
    
    translate_sql(var_1 %in% c("a", "b", "c"), 
                  con = simulate_redshift())__
    
    
    <SQL> `var_1` IN ('a', 'b', 'c')
    
    
    translate_sql(!var_1 %in% c("a", "b", "c"), 
                  con = simulate_redshift())__
    
    
    <SQL> NOT(`var_1` IN ('a', 'b', 'c'))
    
    
    translate_sql(is.na(var_1), 
                  con = simulate_redshift())__
    
    
    <SQL> (`var_1` IS NULL)
    
    
    translate_sql(!is.na(var_1), 
                  con = simulate_redshift())__
    
    
    <SQL> NOT((`var_1` IS NULL))
    
    
    translate_sql(var_1 >= 100 & var_1  < 200, 
                  con = simulate_redshift())__
    
    
    <SQL> `var_1` >= 100.0 AND `var_1` < 200.0
    
    
    translate_sql(var_1 >= 100 | var_1  < 200, 
                  con = simulate_redshift())__
    
    
    <SQL> `var_1` >= 100.0 OR `var_1` < 200.0
    
    
    translate_sql(var_1 == var_2, 
                  con = simulate_postgres())__
    
    
    <SQL> `var_1` = `var_2`
    
    
    translate_sql(var_1 >= var_2, 
                  con = simulate_postgres())__
    
    
    <SQL> `var_1` >= `var_2`
    
    
    translate_sql(var_1 < 100, 
                  con = simulate_postgres())__
    
    
    <SQL> `var_1` < 100.0
    
    
    translate_sql(var_1 %in% c("a", "b", "c"), 
                  con = simulate_postgres())__
    
    
    <SQL> `var_1` IN ('a', 'b', 'c')
    
    
    translate_sql(!var_1 %in% c("a", "b", "c"), 
                  con = simulate_postgres())__
    
    
    <SQL> NOT(`var_1` IN ('a', 'b', 'c'))
    
    
    translate_sql(is.na(var_1), 
                  con = simulate_postgres())__
    
    
    <SQL> (`var_1` IS NULL)
    
    
    translate_sql(!is.na(var_1), 
                  con = simulate_postgres())__
    
    
    <SQL> NOT((`var_1` IS NULL))
    
    
    translate_sql(var_1 >= 100 & var_1  < 200, 
                  con = simulate_postgres())__
    
    
    <SQL> `var_1` >= 100.0 AND `var_1` < 200.0
    
    
    translate_sql(var_1 >= 100 | var_1  < 200, 
                  con = simulate_postgres())__
    
    
    <SQL> `var_1` >= 100.0 OR `var_1` < 200.0
    
    
    translate_sql(var_1 == var_2, 
                  con = simulate_snowflake())__
    
    
    <SQL> `var_1` = `var_2`
    
    
    translate_sql(var_1 >= var_2, 
                  con = simulate_snowflake())__
    
    
    <SQL> `var_1` >= `var_2`
    
    
    translate_sql(var_1 < 100, 
                  con = simulate_snowflake())__
    
    
    <SQL> `var_1` < 100.0
    
    
    translate_sql(var_1 %in% c("a", "b", "c"), 
                  con = simulate_snowflake())__
    
    
    <SQL> `var_1` IN ('a', 'b', 'c')
    
    
    translate_sql(!var_1 %in% c("a", "b", "c"), 
                  con = simulate_snowflake())__
    
    
    <SQL> NOT(`var_1` IN ('a', 'b', 'c'))
    
    
    translate_sql(is.na(var_1), 
                  con = simulate_snowflake())__
    
    
    <SQL> (`var_1` IS NULL)
    
    
    translate_sql(!is.na(var_1), 
                  con = simulate_snowflake())__
    
    
    <SQL> NOT((`var_1` IS NULL))
    
    
    translate_sql(var_1 >= 100 & var_1  < 200, 
                  con = simulate_snowflake())__
    
    
    <SQL> `var_1` >= 100.0 AND `var_1` < 200.0
    
    
    translate_sql(var_1 >= 100 | var_1  < 200, 
                  con = simulate_snowflake())__
    
    
    <SQL> `var_1` >= 100.0 OR `var_1` < 200.0
    
    
    translate_sql(var_1 == var_2, 
                  con = simulate_spark_sql())__
    
    
    <SQL> `var_1` = `var_2`
    
    
    translate_sql(var_1 >= var_2, 
                  con = simulate_spark_sql())__
    
    
    <SQL> `var_1` >= `var_2`
    
    
    translate_sql(var_1 < 100, 
                  con = simulate_spark_sql())__
    
    
    <SQL> `var_1` < 100.0
    
    
    translate_sql(var_1 %in% c("a", "b", "c"), 
                  con = simulate_spark_sql())__
    
    
    <SQL> `var_1` IN ('a', 'b', 'c')
    
    
    translate_sql(!var_1 %in% c("a", "b", "c"), 
                  con = simulate_spark_sql())__
    
    
    <SQL> NOT(`var_1` IN ('a', 'b', 'c'))
    
    
    translate_sql(is.na(var_1), 
                  con = simulate_spark_sql())__
    
    
    <SQL> (`var_1` IS NULL)
    
    
    translate_sql(!is.na(var_1), 
                  con = simulate_spark_sql())__
    
    
    <SQL> NOT((`var_1` IS NULL))
    
    
    translate_sql(var_1 >= 100 & var_1  < 200, 
                  con = simulate_spark_sql())__
    
    
    <SQL> `var_1` >= 100.0 AND `var_1` < 200.0
    
    
    translate_sql(var_1 >= 100 | var_1  < 200, 
                  con = simulate_spark_sql())__
    
    
    <SQL> `var_1` >= 100.0 OR `var_1` < 200.0
    
    
    translate_sql(var_1 == var_2, 
                  con = simulate_mssql())__
    
    
    <SQL> `var_1` = `var_2`
    
    
    translate_sql(var_1 >= var_2, 
                  con = simulate_mssql())__
    
    
    <SQL> `var_1` >= `var_2`
    
    
    translate_sql(var_1 < 100, 
                  con = simulate_mssql())__
    
    
    <SQL> `var_1` < 100.0
    
    
    translate_sql(var_1 %in% c("a", "b", "c"), 
                  con = simulate_mssql())__
    
    
    <SQL> `var_1` IN ('a', 'b', 'c')
    
    
    translate_sql(!var_1 %in% c("a", "b", "c"), 
                  con = simulate_mssql())__
    
    
    <SQL> NOT(`var_1` IN ('a', 'b', 'c'))
    
    
    translate_sql(is.na(var_1), 
                  con = simulate_mssql())__
    
    
    <SQL> (`var_1` IS NULL)
    
    
    translate_sql(!is.na(var_1), 
                  con = simulate_mssql())__
    
    
    <SQL> NOT((`var_1` IS NULL))
    
    
    translate_sql(var_1 >= 100 & var_1  < 200, 
                  con = simulate_mssql())__
    
    
    <SQL> `var_1` >= 100.0 AND `var_1` < 200.0
    
    
    translate_sql(var_1 >= 100 | var_1  < 200, 
                  con = simulate_mssql())__
    
    
    <SQL> `var_1` >= 100.0 OR `var_1` < 200.0

## 3.3 Conditional statements

The base `ifelse` function, along with `if_else` and `case_when` from `dplyr` are translated for each database backend. As can be seen in the translations, `case_when` maps to the SQL CASE WHEN statement.

__

Show SQL 

__

  * duckdb
  * Redshift
  * Postgres
  * Snowflake
  * Spark
  * SQL Server


    
    
    translate_sql(ifelse(var == "a", 1L, 2L), 
                  con = simulate_duckdb())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(if_else(var == "a", 1L, 2L), 
                  con = simulate_duckdb())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, .default = 2L), 
                  con = simulate_duckdb())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 ELSE 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = NULL), 
                  con = simulate_duckdb())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = "something else"), 
                  con = simulate_duckdb())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    ELSE 'something else'
    END
    
    
    translate_sql(ifelse(var == "a", 1L, 2L), 
                  con = simulate_redshift())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(if_else(var == "a", 1L, 2L), 
                  con = simulate_redshift())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, .default = 2L), 
                  con = simulate_redshift())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 ELSE 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = NULL), 
                  con = simulate_redshift())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = "something else"), 
                  con = simulate_redshift())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    ELSE 'something else'
    END
    
    
    translate_sql(ifelse(var == "a", 1L, 2L), 
                  con = simulate_postgres())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(if_else(var == "a", 1L, 2L), 
                  con = simulate_postgres())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, .default = 2L), 
                  con = simulate_postgres())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 ELSE 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = NULL), 
                  con = simulate_postgres())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = "something else"), 
                  con = simulate_postgres())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    ELSE 'something else'
    END
    
    
    translate_sql(ifelse(var == "a", 1L, 2L), 
                  con = simulate_snowflake())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(if_else(var == "a", 1L, 2L), 
                  con = simulate_snowflake())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, .default = 2L), 
                  con = simulate_snowflake())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 ELSE 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = NULL), 
                  con = simulate_snowflake())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = "something else"), 
                  con = simulate_snowflake())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    ELSE 'something else'
    END
    
    
    translate_sql(ifelse(var == "a", 1L, 2L), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(if_else(var == "a", 1L, 2L), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 WHEN NOT (`var` = 'a') THEN 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, .default = 2L), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 ELSE 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = NULL), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = "something else"), 
                  con = simulate_spark_sql())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    ELSE 'something else'
    END
    
    
    translate_sql(ifelse(var == "a", 1L, 2L), 
                  con = simulate_mssql())__
    
    
    <SQL> IIF(`var` = 'a', 1, 2)
    
    
    translate_sql(if_else(var == "a", 1L, 2L), 
                  con = simulate_mssql())__
    
    
    <SQL> IIF(`var` = 'a', 1, 2)
    
    
    translate_sql(case_when(var == "a" ~ 1L, .default = 2L), 
                  con = simulate_mssql())__
    
    
    <SQL> CASE WHEN (`var` = 'a') THEN 1 ELSE 2 END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = NULL), 
                  con = simulate_mssql())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    END
    
    
    translate_sql(case_when(var == "a" ~ 1L, 
                            var == "b" ~ 2L, 
                            var == "c" ~ 3L, 
                            .default = "something else"), 
                  con = simulate_mssql())__
    
    
    <SQL> CASE
    WHEN (`var` = 'a') THEN 1
    WHEN (`var` = 'b') THEN 2
    WHEN (`var` = 'c') THEN 3
    ELSE 'something else'
    END

## 3.4 Working with strings

Compared to the previous sections, there is much more variation in support of functions to work with strings across database management systems. In particular, although various useful `stringr` functions do have translations ubiquitously it can be seen below that more translations are available for some databases compared to others.

__

Show SQL 

__

  * duckdb
  * Redshift
  * Postgres
  * Snowflake
  * Spark
  * SQL Server


    
    
    translate_sql(nchar(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> LENGTH(`var`)
    
    
    translate_sql(nzchar(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> ((`var` IS NULL) OR `var` != '')
    
    
    translate_sql(substr(var, 1, 2), 
                  con = simulate_duckdb())__
    
    
    <SQL> SUBSTR(`var`, 1, 2)
    
    
    translate_sql(trimws(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(tolower(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(str_to_lower(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(toupper(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_upper(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_title(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> INITCAP(`var`)
    
    
    translate_sql(str_trim(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(str_squish(var), 
                  con = simulate_duckdb())__
    
    
    <SQL> TRIM(REGEXP_REPLACE(`var`, '\s+', ' ', 'g'))
    
    
    translate_sql(str_detect(var, "b"), 
                  con = simulate_duckdb())__
    
    
    <SQL> REGEXP_MATCHES(`var`, 'b')
    
    
    translate_sql(str_detect(var, "b", negate = TRUE), 
                  con = simulate_duckdb())__
    
    
    <SQL> (NOT(REGEXP_MATCHES(`var`, 'b')))
    
    
    translate_sql(str_detect(var, "[aeiou]"), 
                  con = simulate_duckdb())__
    
    
    <SQL> REGEXP_MATCHES(`var`, '[aeiou]')
    
    
    translate_sql(str_replace(var, "a", "b"), 
                  con = simulate_duckdb())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', 'b')
    
    
    translate_sql(str_replace_all(var, "a", "b"), 
                  con = simulate_duckdb())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', 'b', 'g')
    
    
    translate_sql(str_remove(var, "a"), 
                  con = simulate_duckdb())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', '')
    
    
    translate_sql(str_remove_all(var, "a"), 
                  con = simulate_duckdb())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', '', 'g')
    
    
    translate_sql(str_like(var, "a"), 
                  con = simulate_duckdb())__
    
    
    <SQL> `var` LIKE 'a'
    
    
    translate_sql(str_starts(var, "a"), 
                  con = simulate_duckdb())__
    
    
    <SQL> REGEXP_MATCHES(`var`, '^(?:' || 'a' || ')')
    
    
    translate_sql(str_ends(var, "a"), 
                  con = simulate_duckdb())__
    
    
    <SQL> REGEXP_MATCHES(`var`, '(?:' || 'a' || ')$')
    
    
    translate_sql(nchar(var), 
                  con = simulate_redshift())__
    
    
    <SQL> LENGTH(`var`)
    
    
    translate_sql(nzchar(var), 
                  con = simulate_redshift())__
    
    
    <SQL> ((`var` IS NULL) OR `var` != '')
    
    
    translate_sql(substr(var, 1, 2), 
                  con = simulate_redshift())__
    
    
    <SQL> SUBSTRING(`var`, 1, 2)
    
    
    translate_sql(trimws(var), 
                  con = simulate_redshift())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(tolower(var), 
                  con = simulate_redshift())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(str_to_lower(var), 
                  con = simulate_redshift())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(toupper(var), 
                  con = simulate_redshift())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_upper(var), 
                  con = simulate_redshift())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_title(var), 
                  con = simulate_redshift())__
    
    
    <SQL> INITCAP(`var`)
    
    
    translate_sql(str_trim(var), 
                  con = simulate_redshift())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(str_squish(var), 
                  con = simulate_redshift())__
    
    
    <SQL> LTRIM(RTRIM(REGEXP_REPLACE(`var`, '\s+', ' ', 'g')))
    
    
    translate_sql(str_detect(var, "b"), 
                  con = simulate_redshift())__
    
    
    <SQL> `var` ~ 'b'
    
    
    translate_sql(str_detect(var, "b", negate = TRUE), 
                  con = simulate_redshift())__
    
    
    <SQL> !(`var` ~ 'b')
    
    
    translate_sql(str_detect(var, "[aeiou]"), 
                  con = simulate_redshift())__
    
    
    <SQL> `var` ~ '[aeiou]'
    
    
    translate_sql(str_replace(var, "a", "b"),
                  con = simulate_redshift())__
    
    
    Error in `str_replace()`:
    ! `str_replace()` is not available in this SQL variant.
    
    
    translate_sql(str_replace_all(var, "a", "b"), 
                  con = simulate_redshift())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', 'b')
    
    
    translate_sql(str_remove(var, "a"), 
                  con = simulate_redshift())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', '')
    
    
    translate_sql(str_remove_all(var, "a"), 
                  con = simulate_redshift())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', '', 'g')
    
    
    translate_sql(str_like(var, "a"), 
                  con = simulate_redshift())__
    
    
    <SQL> `var` ILIKE 'a'
    
    
    translate_sql(str_starts(var, "a"),
                  con = simulate_redshift())__
    
    
    Error in `str_starts()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_ends(var, "a"),
                  con = simulate_redshift())__
    
    
    Error in `str_ends()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(nchar(var), 
                  con = simulate_postgres())__
    
    
    <SQL> LENGTH(`var`)
    
    
    translate_sql(nzchar(var), 
                  con = simulate_postgres())__
    
    
    <SQL> ((`var` IS NULL) OR `var` != '')
    
    
    translate_sql(substr(var, 1, 2), 
                  con = simulate_postgres())__
    
    
    <SQL> SUBSTR(`var`, 1, 2)
    
    
    translate_sql(trimws(var), 
                  con = simulate_postgres())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(tolower(var), 
                  con = simulate_postgres())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(str_to_lower(var), 
                  con = simulate_postgres())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(toupper(var), 
                  con = simulate_postgres())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_upper(var), 
                  con = simulate_postgres())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_title(var), 
                  con = simulate_postgres())__
    
    
    <SQL> INITCAP(`var`)
    
    
    translate_sql(str_trim(var), 
                  con = simulate_postgres())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(str_squish(var), 
                  con = simulate_postgres())__
    
    
    <SQL> LTRIM(RTRIM(REGEXP_REPLACE(`var`, '\s+', ' ', 'g')))
    
    
    translate_sql(str_detect(var, "b"), 
                  con = simulate_postgres())__
    
    
    <SQL> `var` ~ 'b'
    
    
    translate_sql(str_detect(var, "b", negate = TRUE), 
                  con = simulate_postgres())__
    
    
    <SQL> !(`var` ~ 'b')
    
    
    translate_sql(str_detect(var, "[aeiou]"), 
                  con = simulate_postgres())__
    
    
    <SQL> `var` ~ '[aeiou]'
    
    
    translate_sql(str_replace(var, "a", "b"), 
                  con = simulate_postgres())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', 'b')
    
    
    translate_sql(str_replace_all(var, "a", "b"), 
                  con = simulate_postgres())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', 'b', 'g')
    
    
    translate_sql(str_remove(var, "a"), 
                  con = simulate_postgres())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', '')
    
    
    translate_sql(str_remove_all(var, "a"), 
                  con = simulate_postgres())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', '', 'g')
    
    
    translate_sql(str_like(var, "a"), 
                  con = simulate_postgres())__
    
    
    <SQL> `var` ILIKE 'a'
    
    
    translate_sql(str_starts(var, "a"),
                  con = simulate_postgres())__
    
    
    Error in `str_starts()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_ends(var, "a"),
                  con = simulate_postgres())__
    
    
    Error in `str_ends()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(nchar(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> LENGTH(`var`)
    
    
    translate_sql(nzchar(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> ((`var` IS NULL) OR `var` != '')
    
    
    translate_sql(substr(var, 1, 2), 
                  con = simulate_snowflake())__
    
    
    <SQL> SUBSTR(`var`, 1, 2)
    
    
    translate_sql(trimws(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(tolower(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(str_to_lower(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(toupper(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_upper(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_title(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> INITCAP(`var`)
    
    
    translate_sql(str_trim(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> TRIM(`var`)
    
    
    translate_sql(str_squish(var), 
                  con = simulate_snowflake())__
    
    
    <SQL> REGEXP_REPLACE(TRIM(`var`), '\\s+', ' ')
    
    
    translate_sql(str_detect(var, "b"),
                  con = simulate_snowflake())__
    
    
    Error in `REGEXP_INSTR()`:
    ! Don't know how to translate `REGEXP_INSTR()`
    
    
    translate_sql(str_detect(var, "b", negate = TRUE),
                  con = simulate_snowflake())__
    
    
    Error in `REGEXP_INSTR()`:
    ! Don't know how to translate `REGEXP_INSTR()`
    
    
    translate_sql(str_detect(var, "[aeiou]"),
                  con = simulate_snowflake())__
    
    
    Error in `REGEXP_INSTR()`:
    ! Don't know how to translate `REGEXP_INSTR()`
    
    
    translate_sql(str_replace(var, "a", "b"), 
                  con = simulate_snowflake())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', 'b', 1.0, 1.0)
    
    
    translate_sql(str_replace_all(var, "a", "b"), 
                  con = simulate_snowflake())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', 'b')
    
    
    translate_sql(str_remove(var, "a"), 
                  con = simulate_snowflake())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a', '', 1.0, 1.0)
    
    
    translate_sql(str_remove_all(var, "a"), 
                  con = simulate_snowflake())__
    
    
    <SQL> REGEXP_REPLACE(`var`, 'a')
    
    
    translate_sql(str_like(var, "a"), 
                  con = simulate_snowflake())__
    
    
    <SQL> `var` LIKE 'a'
    
    
    translate_sql(str_starts(var, "a"),
                  con = simulate_snowflake())__
    
    
    Error in `REGEXP_INSTR()`:
    ! Don't know how to translate `REGEXP_INSTR()`
    
    
    translate_sql(str_ends(var, "a"),
                  con = simulate_snowflake())__
    
    
    Error in `REGEXP_INSTR()`:
    ! Don't know how to translate `REGEXP_INSTR()`
    
    
    translate_sql(nchar(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> LENGTH(`var`)
    
    
    translate_sql(nzchar(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> ((`var` IS NULL) OR `var` != '')
    
    
    translate_sql(substr(var, 1, 2), 
                  con = simulate_spark_sql())__
    
    
    <SQL> SUBSTR(`var`, 1, 2)
    
    
    translate_sql(trimws(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(tolower(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(str_to_lower(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(toupper(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_upper(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_title(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> INITCAP(`var`)
    
    
    translate_sql(str_trim(var), 
                  con = simulate_spark_sql())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(str_squish(var),
                  con = simulate_spark_sql())__
    
    
    Error in `str_squish()`:
    ! `str_squish()` is not available in this SQL variant.
    
    
    translate_sql(str_detect(var, "b"),
                  con = simulate_spark_sql())__
    
    
    Error in `str_detect()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_detect(var, "b", negate = TRUE),
                  con = simulate_spark_sql())__
    
    
    Error in `str_detect()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_detect(var, "[aeiou]"),
                  con = simulate_spark_sql())__
    
    
    Error in `str_detect()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_replace(var, "a", "b"),
                  con = simulate_spark_sql())__
    
    
    Error in `str_replace()`:
    ! `str_replace()` is not available in this SQL variant.
    
    
    translate_sql(str_replace_all(var, "a", "b"),
                  con = simulate_spark_sql())__
    
    
    Error in `str_replace_all()`:
    ! `str_replace_all()` is not available in this SQL variant.
    
    
    translate_sql(str_remove(var, "a"),
                  con = simulate_spark_sql())__
    
    
    Error in `str_remove()`:
    ! `str_remove()` is not available in this SQL variant.
    
    
    translate_sql(str_remove_all(var, "a"),
                  con = simulate_spark_sql())__
    
    
    Error in `str_remove_all()`:
    ! `str_remove_all()` is not available in this SQL variant.
    
    
    translate_sql(str_like(var, "a"), 
                  con = simulate_spark_sql())__
    
    
    <SQL> `var` LIKE 'a'
    
    
    translate_sql(str_starts(var, "a"),
                  con = simulate_spark_sql())__
    
    
    Error in `str_starts()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_ends(var, "a"),
                  con = simulate_spark_sql())__
    
    
    Error in `str_ends()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(nchar(var), 
                  con = simulate_mssql())__
    
    
    <SQL> LEN(`var`)
    
    
    translate_sql(nzchar(var), 
                  con = simulate_mssql())__
    
    
    <SQL> ((`var` IS NULL) OR `var` != '')
    
    
    translate_sql(substr(var, 1, 2), 
                  con = simulate_mssql())__
    
    
    <SQL> SUBSTRING(`var`, 1, 2)
    
    
    translate_sql(trimws(var), 
                  con = simulate_mssql())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(tolower(var), 
                  con = simulate_mssql())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(str_to_lower(var), 
                  con = simulate_mssql())__
    
    
    <SQL> LOWER(`var`)
    
    
    translate_sql(toupper(var), 
                  con = simulate_mssql())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_upper(var), 
                  con = simulate_mssql())__
    
    
    <SQL> UPPER(`var`)
    
    
    translate_sql(str_to_title(var),
                  con = simulate_mssql())__
    
    
    Error in `str_to_title()`:
    ! `str_to_title()` is not available in this SQL variant.
    
    
    translate_sql(str_trim(var), 
                  con = simulate_mssql())__
    
    
    <SQL> LTRIM(RTRIM(`var`))
    
    
    translate_sql(str_squish(var),
                  con = simulate_mssql())__
    
    
    Error in `str_squish()`:
    ! `str_squish()` is not available in this SQL variant.
    
    
    translate_sql(str_detect(var, "b"),
                  con = simulate_mssql())__
    
    
    Error in `str_detect()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_detect(var, "b", negate = TRUE),
                  con = simulate_mssql())__
    
    
    Error in `str_detect()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_detect(var, "[aeiou]"),
                  con = simulate_mssql())__
    
    
    Error in `str_detect()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_replace(var, "a", "b"),
                  con = simulate_mssql())__
    
    
    Error in `str_replace()`:
    ! `str_replace()` is not available in this SQL variant.
    
    
    translate_sql(str_replace_all(var, "a", "b"),
                  con = simulate_mssql())__
    
    
    Error in `str_replace_all()`:
    ! `str_replace_all()` is not available in this SQL variant.
    
    
    translate_sql(str_remove(var, "a"),
                  con = simulate_mssql())__
    
    
    Error in `str_remove()`:
    ! `str_remove()` is not available in this SQL variant.
    
    
    translate_sql(str_remove_all(var, "a"),
                  con = simulate_mssql())__
    
    
    Error in `str_remove_all()`:
    ! `str_remove_all()` is not available in this SQL variant.
    
    
    translate_sql(str_like(var, "a"), 
                  con = simulate_mssql())__
    
    
    <SQL> `var` LIKE 'a'
    
    
    translate_sql(str_starts(var, "a"),
                  con = simulate_mssql())__
    
    
    Error in `str_starts()`:
    ! Only fixed patterns are supported on database backends.
    
    
    translate_sql(str_ends(var, "a"),
                  con = simulate_mssql())__
    
    
    Error in `str_ends()`:
    ! Only fixed patterns are supported on database backends.

## 3.5 Working with dates

Like with strings, support for working with dates is somewhat mixed. In general, we would use functions from the `clock` package such as `get_day()`, `get_month()`, `get_year()` to extract parts from a date, `add_days()` to add or subtract days to a date, and `date_count_between()` to get the number of days between two date variables.

__

Show SQL 

__

  * duckdb
  * Redshift
  * Postgres
  * Snowflake
  * Spark
  * SQL Server


    
    
    translate_sql(get_day(date_1), 
                  con = simulate_duckdb())__
    
    
    <SQL> DATE_PART('day', `date_1`)
    
    
    translate_sql(get_month(date_1), 
                  con = simulate_duckdb())__
    
    
    <SQL> DATE_PART('month', `date_1`)
    
    
    translate_sql(get_year(date_1), 
                  con = simulate_duckdb())__
    
    
    <SQL> DATE_PART('year', `date_1`)
    
    
    translate_sql(add_days(date_1, 1), 
                  con = simulate_duckdb())__
    
    
    <SQL> DATE_ADD(`date_1`, INTERVAL (1.0) day)
    
    
    translate_sql(add_years(date_1, 1), 
                  con = simulate_duckdb())__
    
    
    <SQL> DATE_ADD(`date_1`, INTERVAL (1.0) year)
    
    
    translate_sql(difftime(date_1, date_2), 
                  con = simulate_duckdb())__
    
    
    Error in `difftime()`:
    ! Don't know how to translate `difftime()`
    
    
    translate_sql(date_count_between(date_1, date_2, "day"), 
                  con = simulate_duckdb())__
    
    
    <SQL> DATEDIFF('day', `date_1`, `date_2`)
    
    
    translate_sql(date_count_between(date_1, date_2, "year"), 
                  con = simulate_duckdb())__
    
    
    Error in date_count_between(date_1, date_2, "year"): The only supported value for `precision` on SQL backends is "day"
    
    
    translate_sql(get_day(date_1), 
                  con = simulate_redshift())__
    
    
    <SQL> DATE_PART('day', `date_1`)
    
    
    translate_sql(get_month(date_1), 
                  con = simulate_redshift())__
    
    
    <SQL> DATE_PART('month', `date_1`)
    
    
    translate_sql(get_year(date_1), 
                  con = simulate_redshift())__
    
    
    <SQL> DATE_PART('year', `date_1`)
    
    
    translate_sql(add_days(date_1, 1), 
                  con = simulate_redshift())__
    
    
    <SQL> DATEADD(DAY, 1.0, `date_1`)
    
    
    translate_sql(add_years(date_1, 1), 
                  con = simulate_redshift())__
    
    
    <SQL> DATEADD(YEAR, 1.0, `date_1`)
    
    
    translate_sql(difftime(date_1, date_2), 
                  con = simulate_redshift())__
    
    
    <SQL> DATEDIFF(DAY, `date_2`, `date_1`)
    
    
    translate_sql(date_count_between(date_1, date_2, "day"), 
                  con = simulate_redshift())__
    
    
    <SQL> DATEDIFF(DAY, `date_1`, `date_2`)
    
    
    translate_sql(date_count_between(date_1, date_2, "year"), 
                  con = simulate_redshift())__
    
    
    Error in `date_count_between()`:
    ! `precision = "year"` isn't supported on database backends.
    ℹ It must be "day" instead.
    
    
    translate_sql(get_day(date_1), 
                  con = simulate_postgres())__
    
    
    <SQL> DATE_PART('day', `date_1`)
    
    
    translate_sql(get_month(date_1), 
                  con = simulate_postgres())__
    
    
    <SQL> DATE_PART('month', `date_1`)
    
    
    translate_sql(get_year(date_1), 
                  con = simulate_postgres())__
    
    
    <SQL> DATE_PART('year', `date_1`)
    
    
    translate_sql(add_days(date_1, 1), 
                  con = simulate_postgres())__
    
    
    <SQL> (`date_1` + 1.0*INTERVAL'1 day')
    
    
    translate_sql(add_years(date_1, 1), 
                  con = simulate_postgres())__
    
    
    <SQL> (`date_1` + 1.0*INTERVAL'1 year')
    
    
    translate_sql(difftime(date_1, date_2), 
                  con = simulate_postgres())__
    
    
    <SQL> (CAST(`date_1` AS DATE) - CAST(`date_2` AS DATE))
    
    
    translate_sql(date_count_between(date_1, date_2, "day"), 
                  con = simulate_postgres())__
    
    
    <SQL> `date_2` - `date_1`
    
    
    translate_sql(date_count_between(date_1, date_2, "year"), 
                  con = simulate_postgres())__
    
    
    Error in `date_count_between()`:
    ! `precision = "year"` isn't supported on database backends.
    ℹ It must be "day" instead.
    
    
    translate_sql(get_day(date_1), 
                  con = simulate_snowflake())__
    
    
    <SQL> DATE_PART(DAY, `date_1`)
    
    
    translate_sql(get_month(date_1), 
                  con = simulate_snowflake())__
    
    
    <SQL> DATE_PART(MONTH, `date_1`)
    
    
    translate_sql(get_year(date_1), 
                  con = simulate_snowflake())__
    
    
    <SQL> DATE_PART(YEAR, `date_1`)
    
    
    translate_sql(add_days(date_1, 1), 
                  con = simulate_snowflake())__
    
    
    <SQL> DATEADD(DAY, 1.0, `date_1`)
    
    
    translate_sql(add_years(date_1, 1), 
                  con = simulate_snowflake())__
    
    
    <SQL> DATEADD(YEAR, 1.0, `date_1`)
    
    
    translate_sql(difftime(date_1, date_2), 
                  con = simulate_snowflake())__
    
    
    <SQL> DATEDIFF(DAY, `date_2`, `date_1`)
    
    
    translate_sql(date_count_between(date_1, date_2, "day"), 
                  con = simulate_snowflake())__
    
    
    <SQL> DATEDIFF(DAY, `date_1`, `date_2`)
    
    
    translate_sql(date_count_between(date_1, date_2, "year"), 
                  con = simulate_snowflake())__
    
    
    Error in `date_count_between()`:
    ! `precision = "year"` isn't supported on database backends.
    ℹ It must be "day" instead.
    
    
    translate_sql(get_day(date_1), 
                  con = simulate_spark_sql())__
    
    
    <SQL> DATE_PART('DAY', `date_1`)
    
    
    translate_sql(get_month(date_1), 
                  con = simulate_spark_sql())__
    
    
    <SQL> DATE_PART('MONTH', `date_1`)
    
    
    translate_sql(get_year(date_1), 
                  con = simulate_spark_sql())__
    
    
    <SQL> DATE_PART('YEAR', `date_1`)
    
    
    translate_sql(add_days(date_1, 1), 
                  con = simulate_spark_sql())__
    
    
    <SQL> DATE_ADD(`date_1`, 1.0)
    
    
    translate_sql(add_years(date_1, 1), 
                  con = simulate_spark_sql())__
    
    
    <SQL> ADD_MONTHS(`date_1`, 1.0 * 12.0)
    
    
    translate_sql(difftime(date_1, date_2), 
                  con = simulate_spark_sql())__
    
    
    <SQL> DATEDIFF(`date_2`, `date_1`)
    
    
    translate_sql(date_count_between(date_1, date_2, "day"), 
                  con = simulate_spark_sql())__
    
    
    <SQL> DATEDIFF(`date_2`, `date_1`)
    
    
    translate_sql(date_count_between(date_1, date_2, "year"), 
                  con = simulate_spark_sql())__
    
    
    Error in `date_count_between()`:
    ! `precision = "year"` isn't supported on database backends.
    ℹ It must be "day" instead.
    
    
    translate_sql(get_day(date_1), 
                  con = simulate_mssql())__
    
    
    <SQL> DATEPART(DAY, `date_1`)
    
    
    translate_sql(get_month(date_1), 
                  con = simulate_mssql())__
    
    
    <SQL> DATEPART(MONTH, `date_1`)
    
    
    translate_sql(get_year(date_1), 
                  con = simulate_mssql())__
    
    
    <SQL> DATEPART(YEAR, `date_1`)
    
    
    translate_sql(add_days(date_1, 1), 
                  con = simulate_mssql())__
    
    
    <SQL> DATEADD(DAY, 1.0, `date_1`)
    
    
    translate_sql(add_years(date_1, 1), 
                  con = simulate_mssql())__
    
    
    <SQL> DATEADD(YEAR, 1.0, `date_1`)
    
    
    translate_sql(difftime(date_1, date_2), 
                  con = simulate_mssql())__
    
    
    <SQL> DATEDIFF(DAY, `date_2`, `date_1`)
    
    
    translate_sql(date_count_between(date_1, date_2, "day"), 
                  con = simulate_mssql())__
    
    
    <SQL> DATEDIFF(DAY, `date_1`, `date_2`)
    
    
    translate_sql(date_count_between(date_1, date_2, "year"), 
                  con = simulate_mssql())__
    
    
    Error in `date_count_between()`:
    ! `precision = "year"` isn't supported on database backends.
    ℹ It must be "day" instead.

## 3.6 Data aggregation

Within the context of using `summarise()`, we can get aggregated results across entire columns using functions such as `n()`, `n_distinct()`, `sum()`, `min()`, `max()`, `mean()`, and `sd()`. As can be seen below, the SQL for these calculations is similar across different database management systems.

__

Show SQL 

__

  * duckdb
  * postgres
  * redshift
  * Snowflake
  * Spark
  * SQL Server


    
    
    lazy_frame(x = c(1,2), con = simulate_duckdb()) %>% 
      summarise(
              n = n(),
              n_unique = n_distinct(x),
              sum = sum(x, na.rm = TRUE),
              sum_is_1 = sum(x == 1, na.rm = TRUE),
              min = min(x, na.rm = TRUE),
              mean = mean(x, na.rm = TRUE),
              max = max(x, na.rm = TRUE),
              sd = sd(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      COUNT(*) AS `n`,
      COUNT(DISTINCT row(`x`)) AS `n_unique`,
      SUM(`x`) AS `sum`,
      SUM(`x` = 1.0) AS `sum_is_1`,
      MIN(`x`) AS `min`,
      AVG(`x`) AS `mean`,
      MAX(`x`) AS `max`,
      STDDEV(`x`) AS `sd`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_postgres()) %>% 
      summarise(
              n = n(),
              n_unique = n_distinct(x),
              sum = sum(x, na.rm = TRUE),
              sum_is_1 = sum(x == 1, na.rm = TRUE),
              min = min(x, na.rm = TRUE),
              mean = mean(x, na.rm = TRUE),
              max = max(x, na.rm = TRUE),
              sd = sd(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      COUNT(*) AS `n`,
      COUNT(DISTINCT `x`) AS `n_unique`,
      SUM(`x`) AS `sum`,
      SUM(`x` = 1.0) AS `sum_is_1`,
      MIN(`x`) AS `min`,
      AVG(`x`) AS `mean`,
      MAX(`x`) AS `max`,
      STDDEV_SAMP(`x`) AS `sd`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_redshift()) %>% 
      summarise(
              n = n(),
              n_unique = n_distinct(x),
              sum = sum(x, na.rm = TRUE),
              sum_is_1 = sum(x == 1, na.rm = TRUE),
              min = min(x, na.rm = TRUE),
              mean = mean(x, na.rm = TRUE),
              max = max(x, na.rm = TRUE),
              sd = sd(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      COUNT(*) AS `n`,
      COUNT(DISTINCT `x`) AS `n_unique`,
      SUM(`x`) AS `sum`,
      SUM(`x` = 1.0) AS `sum_is_1`,
      MIN(`x`) AS `min`,
      AVG(`x`) AS `mean`,
      MAX(`x`) AS `max`,
      STDDEV_SAMP(`x`) AS `sd`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_snowflake()) %>% 
      summarise(
              n = n(),
              n_unique = n_distinct(x),
              sum = sum(x, na.rm = TRUE),
              sum_is_1 = sum(x == 1, na.rm = TRUE),
              min = min(x, na.rm = TRUE),
              mean = mean(x, na.rm = TRUE),
              max = max(x, na.rm = TRUE),
              sd = sd(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      COUNT(*) AS `n`,
      COUNT(DISTINCT `x`) AS `n_unique`,
      SUM(`x`) AS `sum`,
      SUM(`x` = 1.0) AS `sum_is_1`,
      MIN(`x`) AS `min`,
      AVG(`x`) AS `mean`,
      MAX(`x`) AS `max`,
      STDDEV(`x`) AS `sd`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_spark_sql()) %>% 
      summarise(
              n = n(),
              n_unique = n_distinct(x),
              sum = sum(x, na.rm = TRUE),
              sum_is_1 = sum(x == 1, na.rm = TRUE),
              min = min(x, na.rm = TRUE),
              mean = mean(x, na.rm = TRUE),
              max = max(x, na.rm = TRUE),
              sd = sd(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      COUNT(*) AS `n`,
      COUNT(DISTINCT `x`) AS `n_unique`,
      SUM(`x`) AS `sum`,
      SUM(`x` = 1.0) AS `sum_is_1`,
      MIN(`x`) AS `min`,
      AVG(`x`) AS `mean`,
      MAX(`x`) AS `max`,
      STDDEV_SAMP(`x`) AS `sd`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), a = "a", con = simulate_mssql()) %>% 
      summarise(
              n = n(),
              n_unique = n_distinct(x),
              sum = sum(x, na.rm = TRUE),
              sum_is_1 = sum(x == 1, na.rm = TRUE),
              min = min(x, na.rm = TRUE),
              mean = mean(x, na.rm = TRUE),
              max = max(x, na.rm = TRUE),
              sd = sd(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      COUNT_BIG(*) AS `n`,
      COUNT(DISTINCT `x`) AS `n_unique`,
      SUM(`x`) AS `sum`,
      SUM(CAST(IIF(`x` = 1.0, 1, 0) AS BIT)) AS `sum_is_1`,
      MIN(`x`) AS `min`,
      AVG(`x`) AS `mean`,
      MAX(`x`) AS `max`,
      STDEV(`x`) AS `sd`
    FROM `df`

## 3.7 Window functions

In the previous section we saw how aggregate functions can be used to perform operations across entire columns. Window functions differ in that they perform calculations across rows that are in some way related to a current row. For these we now use `mutate()` instead of using `summarise()`.

We can use window functions like `cumsum()` and `cummean()` to calculate running totals and averages, or `lag()` and `lead()` to help compare rows to their preceding or following rows.

Given that window functions compare rows to rows before or after them, we will often use `arrange()` to specify the order of rows. This will translate into a ORDER BY clause in the SQL. In addition, we may well also want to apply window functions within some specific groupings in our data. Using `group_by()` would result in a PARTITION BY clause in the translated SQL so that window function operates on each group independently.

__

Show SQL 

__

  * duckdb
  * postgres
  * redshift
  * Snowflake
  * Spark
  * SQL Server


    
    
    lazy_frame(x = c(10, 20, 30),
               z = c(1, 2, 3),
               con = simulate_duckdb()) %>% 
      window_order(z) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER (ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `sum_x`,
      AVG(`x`) OVER (ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `mean_x`,
      LAG(`x`, 1, NULL) OVER (ORDER BY `z`) AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER (ORDER BY `z`) AS `lead_x`
    FROM `df`
    
    
    lazy_frame(x = c(10, 20, 30),  
               y = c("a", "a", "b"),
               z = c(1, 2, 3),
               con = simulate_duckdb()) %>% 
      window_order(z) |> 
      group_by(y) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `sum_x`,
      AVG(`x`) OVER (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `mean_x`,
      LAG(`x`, 1, NULL) OVER (PARTITION BY `y` ORDER BY `z`) AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER (PARTITION BY `y` ORDER BY `z`) AS `lead_x`
    FROM `df`
    
    
    lazy_frame(x = c(10, 20, 30),
               z = c(1, 2, 3),
               con = simulate_postgres()) %>% 
      window_order(z) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER `win1` AS `sum_x`,
      AVG(`x`) OVER `win1` AS `mean_x`,
      LAG(`x`, 1, NULL) OVER `win2` AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER `win2` AS `lead_x`
    FROM `df`
    WINDOW
      `win1` AS (ORDER BY `z` ROWS UNBOUNDED PRECEDING),
      `win2` AS (ORDER BY `z`)
    
    
    lazy_frame(x = c(10, 20, 30),  
               y = c("a", "a", "b"),
               z = c(1, 2, 3),
               con = simulate_postgres()) %>% 
      window_order(z) |> 
      group_by(y) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER `win1` AS `sum_x`,
      AVG(`x`) OVER `win1` AS `mean_x`,
      LAG(`x`, 1, NULL) OVER `win2` AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER `win2` AS `lead_x`
    FROM `df`
    WINDOW
      `win1` AS (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING),
      `win2` AS (PARTITION BY `y` ORDER BY `z`)
    
    
    lazy_frame(x = c(10, 20, 30),
               z = c(1, 2, 3),
               con = simulate_redshift()) %>% 
      window_order(z) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER (ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `sum_x`,
      AVG(`x`) OVER (ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `mean_x`,
      LAG(`x`, 1) OVER (ORDER BY `z`) AS `lag_x`,
      LEAD(`x`, 1) OVER (ORDER BY `z`) AS `lead_x`
    FROM `df`
    
    
    lazy_frame(x = c(10, 20, 30),  
               y = c("a", "a", "b"),
               z = c(1, 2, 3),
               con = simulate_redshift()) %>% 
      window_order(z) |> 
      group_by(y) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `sum_x`,
      AVG(`x`) OVER (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `mean_x`,
      LAG(`x`, 1) OVER (PARTITION BY `y` ORDER BY `z`) AS `lag_x`,
      LEAD(`x`, 1) OVER (PARTITION BY `y` ORDER BY `z`) AS `lead_x`
    FROM `df`
    
    
    lazy_frame(x = c(10, 20, 30),
               z = c(1, 2, 3),
               con = simulate_snowflake()) %>% 
      window_order(z) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER (ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `sum_x`,
      AVG(`x`) OVER (ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `mean_x`,
      LAG(`x`, 1, NULL) OVER (ORDER BY `z`) AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER (ORDER BY `z`) AS `lead_x`
    FROM `df`
    
    
    lazy_frame(x = c(10, 20, 30),  
               y = c("a", "a", "b"),
               z = c(1, 2, 3),
               con = simulate_snowflake()) %>% 
      window_order(z) |> 
      group_by(y) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `sum_x`,
      AVG(`x`) OVER (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `mean_x`,
      LAG(`x`, 1, NULL) OVER (PARTITION BY `y` ORDER BY `z`) AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER (PARTITION BY `y` ORDER BY `z`) AS `lead_x`
    FROM `df`
    
    
    lazy_frame(x = c(10, 20, 30),
               z = c(1, 2, 3),
               con = simulate_spark_sql()) %>% 
      window_order(z) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER `win1` AS `sum_x`,
      AVG(`x`) OVER `win1` AS `mean_x`,
      LAG(`x`, 1, NULL) OVER `win2` AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER `win2` AS `lead_x`
    FROM `df`
    WINDOW
      `win1` AS (ORDER BY `z` ROWS UNBOUNDED PRECEDING),
      `win2` AS (ORDER BY `z`)
    
    
    lazy_frame(x = c(10, 20, 30),  
               y = c("a", "a", "b"),
               z = c(1, 2, 3),
               con = simulate_spark_sql()) %>% 
      window_order(z) |> 
      group_by(y) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER `win1` AS `sum_x`,
      AVG(`x`) OVER `win1` AS `mean_x`,
      LAG(`x`, 1, NULL) OVER `win2` AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER `win2` AS `lead_x`
    FROM `df`
    WINDOW
      `win1` AS (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING),
      `win2` AS (PARTITION BY `y` ORDER BY `z`)
    
    
    lazy_frame(x = c(10, 20, 30),
               z = c(1, 2, 3),
               con = simulate_mssql()) %>% 
      window_order(z) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER (ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `sum_x`,
      AVG(`x`) OVER (ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `mean_x`,
      LAG(`x`, 1, NULL) OVER (ORDER BY `z`) AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER (ORDER BY `z`) AS `lead_x`
    FROM `df`
    
    
    lazy_frame(x = c(10, 20, 30),  
               y = c("a", "a", "b"),
               z = c(1, 2, 3),
               con = simulate_mssql()) %>% 
      window_order(z) |> 
      group_by(y) |> 
      mutate(sum_x = cumsum(x),
             mean_x = cummean(x),
             lag_x = lag(x), 
             lead_x = lead(x)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      SUM(`x`) OVER (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `sum_x`,
      AVG(`x`) OVER (PARTITION BY `y` ORDER BY `z` ROWS UNBOUNDED PRECEDING) AS `mean_x`,
      LAG(`x`, 1, NULL) OVER (PARTITION BY `y` ORDER BY `z`) AS `lag_x`,
      LEAD(`x`, 1, NULL) OVER (PARTITION BY `y` ORDER BY `z`) AS `lead_x`
    FROM `df`

## 3.8 Calculating quantiles, including the median

So far we’ve seen that we can perform various data manipulations and calculate summary statistics for different database management systems using the same R code. Although the translated SQL has been different, the databases all supported similar approaches to perform these queries.

A case where this is not the case is when we are interested in summarising distributions of the data and estimating quantiles. For example, let’s take estimating the median as an example. Some databases only support calculating the median as an aggregation function similar to how min, mean, and max were calculated above. However, some others only support it as a window function like lead and lag above. Unfortunately this means that for some databases quantiles can only be calculated using the summarise aggregation approach, while in others only the mutate window approach can be used.

__

Show SQL 

__

  * duckdb
  * postgres
  * redshift
  * Snowflake
  * Spark
  * SQL Server


    
    
    lazy_frame(x = c(1,2), con = simulate_duckdb()) %>% 
      summarise(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT MEDIAN(`x`) AS `median`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_duckdb()) %>% 
      mutate(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT `df`.*, MEDIAN(`x`) OVER () AS `median`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_postgres()) %>% 
      summarise(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY `x`) AS `median`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_postgres()) %>% 
      mutate(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    Error in `median()`:
    ! Translation of `median()` in `mutate()` is not supported for
      PostgreSQL.
    ℹ Use a combination of `summarise()` and `left_join()` instead:
      `df %>% left_join(summarise(<col> = median(x, na.rm = TRUE)))`.
    
    
    lazy_frame(x = c(1,2), con = simulate_redshift()) %>% 
      summarise(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY `x`) AS `median`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_redshift()) %>% 
      mutate(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    Error in `median()`:
    ! Translation of `median()` in `mutate()` is not supported for
      PostgreSQL.
    ℹ Use a combination of `summarise()` and `left_join()` instead:
      `df %>% left_join(summarise(<col> = median(x, na.rm = TRUE)))`.
    
    
    lazy_frame(x = c(1,2), con = simulate_snowflake()) %>% 
      summarise(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY `x`) AS `median`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_snowflake()) %>% 
      mutate(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY `x`) OVER () AS `median`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_spark_sql()) %>% 
      summarise(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT MEDIAN(`x`) AS `median`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_spark_sql()) %>% 
      mutate(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT `df`.*, MEDIAN(`x`) OVER () AS `median`
    FROM `df`
    
    
    lazy_frame(x = c(1,2), con = simulate_mssql()) %>% 
      summarise(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    Error in `median()`:
    ! Translation of `median()` in `summarise()` is not supported for SQL
      Server.
    ℹ Use a combination of `distinct()` and `mutate()` for the same result:
      `mutate(<col> = median(x, na.rm = TRUE)) %>% distinct(<col>)`
    
    
    lazy_frame(x = c(1,2), con = simulate_mssql()) %>% 
      mutate(median = median(x, na.rm = TRUE)) |> 
      show_query()__
    
    
    <SQL>
    SELECT
      `df`.*,
      PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY `x`) OVER () AS `median`
    FROM `df`

[ __ 2 Core verbs for analytic pipelines utilising a database ](./tidyverse_verbs.html)

[ 4 Building analytic pipelines for a data model __](./dbplyr_packages.html)
