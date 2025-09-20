# DBI connection examples • CDMConnector

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

# DBI connection examples

Source: [`vignettes/a04_DBI_connection_examples.Rmd`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/vignettes/a04_DBI_connection_examples.Rmd)

`a04_DBI_connection_examples.Rmd`

The following connection examples are provided for reference.

### Postgres

Connect to Postgres using the RPostgres package.
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(RPostgres::[Postgres](https://rpostgres.r-dbi.org/reference/Postgres.html)(),
                          dbname = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_DBNAME"),
                          host = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_HOST"),
                          user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_USER"),
                          password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_PASSWORD"))
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_CDM_SCHEMA"), 
                      writeSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_SCRATCH_SCHEMA"))
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)

Connect to Postgres using DatabaseConnector (version 7 or later).
    
    
    
    [library](https://rdrr.io/r/base/library.html)([DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/))
    connectionDetails <- [createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(dbms = "postgresql",
                                                 server = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_SERVER"),
                                                 user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_USER"),
                                                 password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_PASSWORD"))
    
    
    con <- [connect](https://ohdsi.github.io/DatabaseConnector/reference/connect.html)(connectionDetails)
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_CDM_SCHEMA"), 
                      writeSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_POSTGRESQL_SCRATCH_SCHEMA"))
    
    [disconnect](https://ohdsi.github.io/DatabaseConnector/reference/disconnect.html)(con)

### Redshift

Connect to Redshift using the RPostgres package.
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(RPostgres::[Redshift](https://rpostgres.r-dbi.org/reference/Redshift.html)(),
                          dbname   = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_DBNAME"),
                          host     = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_HOST"),
                          port     = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_PORT"),
                          user     = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_USER"),
                          password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_PASSWORD"))
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_CDM_SCHEMA"), 
                      writeSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_SCRATCH_SCHEMA"))
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)

Connect to Redshift using the DatabaseConnector package (version 7 or later).
    
    
    [library](https://rdrr.io/r/base/library.html)([DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/))  
    
    connectionDetails <- [createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(dbms = "redshift",
                                                 server = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_SERVER"),
                                                 user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_USER"),
                                                 password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_PASSWORD"),
                                                 port = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_PORT"))
    con <- [connect](https://ohdsi.github.io/DatabaseConnector/reference/connect.html)(connectionDetails)
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_CDM_SCHEMA"), 
                      writeSchema = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_REDSHIFT_SCRATCH_SCHEMA"))
    
    [disconnect](https://ohdsi.github.io/DatabaseConnector/reference/disconnect.html)(con)

### SQL Server

Using odbc with SQL Server requires driver setup described [here](https://solutions.posit.co/connections/db/r-packages/odbc/). Note, you’ll likely need to [download the ODBC Driver for SQL Server](https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver16).
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(odbc::[odbc](https://odbc.r-dbi.org/reference/dbConnect-OdbcDriver-method.html)(),
                          Driver   = "ODBC Driver 18 for SQL Server",
                          Server   = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_SQL_SERVER_SERVER"),
                          Database = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_SQL_SERVER_CDM_DATABASE"),
                          UID      = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_SQL_SERVER_USER"),
                          PWD      = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_SQL_SERVER_PASSWORD"),
                          TrustServerCertificate="yes",
                          Port     = 1433)
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                        cdmSchema = [c](https://rdrr.io/r/base/c.html)("cdmv54", "dbo"), 
                        writeSchema =  [c](https://rdrr.io/r/base/c.html)("tempdb", "dbo"))
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)

The connection to SQL Server can be simplified by configuring a DSN. See [here](https://www.r-bloggers.com/2018/05/setting-up-an-odbc-connection-with-ms-sql-server-on-windows/) for instructions on how to set up the DSN. If we named it “SQL”, our connection is then simplified to.
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(odbc::[odbc](https://odbc.r-dbi.org/reference/dbConnect-OdbcDriver-method.html)(), "SQL")
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                        cdmSchema = [c](https://rdrr.io/r/base/c.html)("tempdb", "dbo"), 
                        writeSchema =  [c](https://rdrr.io/r/base/c.html)("ATLAS", "RESULTS"))
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)

Connect to SQL Server using the DatabaseConnector package (version 7 or later).
    
    
    [library](https://rdrr.io/r/base/library.html)([DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/))
    connectionDetails <- [createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(
      dbms = "sql server",
      server = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_SQL_SERVER_SERVER"),
      user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_SQL_SERVER_USER"),
      password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_SQL_SERVER_PASSWORD"),
      port = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("CDM5_SQL_SERVER_PORT")
    )
    
    con <- [connect](https://ohdsi.github.io/DatabaseConnector/reference/connect.html)(connectionDetails)
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema = [c](https://rdrr.io/r/base/c.html)("cdmv54", "dbo"), 
                      writeSchema =  [c](https://rdrr.io/r/base/c.html)("tempdb", "dbo"))
    
    [disconnect](https://ohdsi.github.io/DatabaseConnector/reference/disconnect.html)(con)

### Snowflake

We can use the odbc package to connect to snowflake.
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(odbc::[odbc](https://odbc.r-dbi.org/reference/dbConnect-OdbcDriver-method.html)(),
                              SERVER = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_SERVER"),
                              UID = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_USER"),
                              PWD = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_PASSWORD"),
                              DATABASE = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_DATABASE"),
                              WAREHOUSE = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_WAREHOUSE"),
                              DRIVER = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_DRIVER"))
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema =  [c](https://rdrr.io/r/base/c.html)("OMOP_SYNTHETIC_DATASET", "CDM53"), 
                      writeSchema =  [c](https://rdrr.io/r/base/c.html)("ATLAS", "RESULTS"))
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)

Note, as with SQL server we could set up a DSN to simplify this connection as described [here](https://docs.snowflake.com/developer-guide/odbc/odbc-windows) for windows and [here](https://docs.snowflake.com/developer-guide/odbc/odbc-mac) for macOS.

Connect to Snowflake using the DatabaseConnector package (version 7 or later).

Your connection string will look something like `jdbc:snowflake://asdf.snowflakecomputing.com?db=DBNAME&warehouse=COMPUTE_WH`
    
    
    [library](https://rdrr.io/r/base/library.html)([DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/))
    
    connectionDetails <- [createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(
      dbms = "snowflake",
      connectionString = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_CONNECTION_STRING"),
      user = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_USER"),
      password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("SNOWFLAKE_PASSWORD")
    )
    
    con <- [connect](https://ohdsi.github.io/DatabaseConnector/reference/connect.html)(connectionDetails)
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema =  [c](https://rdrr.io/r/base/c.html)("OMOP_SYNTHETIC_DATASET", "CDM53"), 
                      writeSchema =  [c](https://rdrr.io/r/base/c.html)("ATLAS", "RESULTS"))
    
    [disconnect](https://ohdsi.github.io/DatabaseConnector/reference/disconnect.html)(con)

### Databricks/Spark

To connect to Databricks using ODBC please follow the instructions here: <https://solutions.posit.co/connections/db/databases/databricks/>

You will need to set two environment variables in your .Renviron file: DATABRICKS_HOST=“[Your organization’s Host URL]” DATABRICKS_TOKEN=“[Your personal Databricks token]”

Create or open the .Renviron file by running `[usethis::edit_r_environ()](https://usethis.r-lib.org/reference/edit.html)`
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(
      odbc::[databricks](https://odbc.r-dbi.org/reference/databricks.html)(),
      httpPath = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("DATABRICKS_HTTPPATH"),
      useNativeQuery = FALSE
    )
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema =  "gibleed", 
                      writeSchema = "scratch")
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)

To connect to Databricks using DatabaseConnector use the following example. The connection will look something like `"jdbc:databricks://asdf.cloud.databricks.com/default;transportMode=http;ssl=1;AuthMech=3;httpPath=/sql/1.0/warehouses/6"`

The password should be your databricks token.
    
    
    [library](https://rdrr.io/r/base/library.html)([DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/))
    
    connectionDetails <- [createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(
      dbms = "spark",
      user = "token",
      password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)('DATABRICKS_TOKEN'),
      connectionString = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)('DATABRICKS_CONNECTION_STRING')
    )
    
    con <- [connect](https://ohdsi.github.io/DatabaseConnector/reference/connect.html)(connectionDetails)
    
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema =  "gibleed", 
                      writeSchema = "scratch")
    
    [disconnect](https://ohdsi.github.io/DatabaseConnector/reference/disconnect.html)(con)

We can ignore the “ERROR StatusLogger Unrecognized format/conversion specifier” messages as these have to do with the log format.

### Duckdb

Duckdb is an in-process database similar to SQLite. We use the duckdb package to connect. The `dbdir` argument should point to the database file location.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          dbdir = [eunomiaDir](../reference/eunomiaDir.html)("GiBleed"))
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema = "main", 
                      writeSchema = "main")
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)

We can also use DatabaseConnector to connect to duckdb. In the example the `server` argument points to the duckdb file location.
    
    
    [library](https://rdrr.io/r/base/library.html)([DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/))
    connectionDetails <- [createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(
      "duckdb", 
      server = CDMConnector::[eunomiaDir](../reference/eunomiaDir.html)("GiBleed"))
    
    con <- [connect](https://ohdsi.github.io/DatabaseConnector/reference/connect.html)(connectionDetails)
    
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, 
                      cdmSchema = "main", 
                      writeSchema = "main")
    
    
    [disconnect](https://ohdsi.github.io/DatabaseConnector/reference/disconnect.html)(con)

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
