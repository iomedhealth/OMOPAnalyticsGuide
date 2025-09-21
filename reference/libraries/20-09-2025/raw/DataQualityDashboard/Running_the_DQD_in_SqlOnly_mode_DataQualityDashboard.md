# Running the DQD in SqlOnly mode • DataQualityDashboard

Toggle navigation [DataQualityDashboard](../index.html) 2.7.0

  * [ ](../index.html)
  * [Get started](../articles/DataQualityDashboard.html)
  * [Reference](../reference/index.html)
  * Articles 
    * [DQ Check Failure Thresholds](../articles/Thresholds.html)
    * [DQ Check Statuses](../articles/CheckStatusDefinitions.html)
    * [Adding a New Data Quality Check](../articles/AddNewCheck.html)
    * [DQD for Cohorts](../articles/DqdForCohorts.html)
    * [SQL-only Mode](../articles/SqlOnly.html)
  * Data Quality Check Types 
    * [Index](../articles/checkIndex.html)
    * [cdmTable](../articles/checks/cdmTable.html)
    * [cdmField](../articles/checks/cdmField.html)
    * [cdmDatatype](../articles/checks/cdmDatatype.html)
    * [isPrimaryKey](../articles/checks/isPrimaryKey.html)
    * [isForeignKey](../articles/checks/isForeignKey.html)
    * [isRequired](../articles/checks/isRequired.html)
    * [fkDomain](../articles/checks/fkDomain.html)
    * [fkClass](../articles/checks/fkClass.html)
    * [measurePersonCompleteness](../articles/checks/measurePersonCompleteness.html)
    * [measureValueCompleteness](../articles/checks/measureValueCompleteness.html)
    * [isStandardValidConcept](../articles/checks/isStandardValidConcept.html)
    * [standardConceptRecordCompleteness](../articles/checks/standardConceptRecordCompleteness.html)
    * [sourceConceptRecordCompleteness](../articles/checks/sourceConceptRecordCompleteness.html)
    * [sourceValueCompleteness](../articles/checks/sourceValueCompleteness.html)
    * [plausibleAfterBirth](../articles/checks/plausibleAfterBirth.html)
    * [plausibleBeforeDeath](../articles/checks/plausibleBeforeDeath.html)
    * [plausibleStartBeforeEnd](../articles/checks/plausibleStartBeforeEnd.html)
    * [plausibleValueHigh](../articles/checks/plausibleValueHigh.html)
    * [plausibleValueLow](../articles/checks/plausibleValueLow.html)
    * [withinVisitDates](../articles/checks/withinVisitDates.html)
    * [measureConditionEraCompleteness](../articles/checks/measureConditionEraCompleteness.html)
    * [measureObservationPeriodOverlap](../articles/checks/measureObservationPeriodOverlap.html)
    * [plausibleUnitConceptIds](../articles/checks/plausibleUnitConceptIds.html)
    * [plausibleGenderUseDescendants](../articles/checks/plausibleGenderUseDescendants.html)
  * [Changelog](../news/index.html)


  * [![](https://ohdsi.github.io/Hades/images/hadesMini.png)](https://ohdsi.github.io/Hades)
  * [ ](https://github.com/OHDSI/DataQualityDashboard/)



# Running the DQD in SqlOnly mode

#### Maxim Moinat

#### 2025-08-27

Source: [`vignettes/SqlOnly.rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/SqlOnly.rmd)

`SqlOnly.rmd`

## Description

This article describes how to use DQD to generate only the SQL that executes all DataQualityDashboard checks, without actually executing them. There are a few main advantages of running DQD in Sql-only mode:

  * Create queries locally, before sending to server. This allows for generation of the SQL on one machine and execution on another (e.g. when R cannot connect directly to the database server, or you want to run the DQD SQL as part of your ETL).
  * Since these are fully functional queries, this can help with debugging.
  * **[NEW in v2.3.0!]** Performance. If you use `sqlOnlyIncrementalInsert = TRUE` and `sqlOnlyUnionCount > 1`, multiple checks are unioned within a cte in the output SQL query to speed performance. When testing on Spark, this resulted in a 10x or higher performance gain. 
    * Performance for these queries has NOT been benchmarked on all database systems. In order to obtain optimal results in your database you may need to adjust the `sqlOnlyUnionCount` and/or tune database parameters such as indexing and parallelism



The new `sqlOnlyIncrementalInsert` mode generates SQL queries that will actually populate a DQD results table in your database with the results of the checks. There are currently some differences in the result when running these queries, compared to a normal DQD run:

  * If you set `sqlOnlyUnionCount` > 1, if one check results in an error, multiple checks might fail (since the queries are unioned in ctes).
  * The status `not_applicable` is not evaluated. A check fails or passes.
  * The query text is not shown in the results table.
  * Notes from threshold file are not included in results.
  * Execution metadata is not automatically added (total and query execution time; CDM_SOURCE metadata).



Running DQD with `sqlOnly = TRUE` and `sqlOnlyIncrementalInsert = FALSE` will generate SQL queries that can be run to generate the result of each DQ check, but which will not write the results back to the database.

## Generating the “Incremental Insert” DQD SQL

A few things to note:

  * A dummy `connectionDetails` object is needed where only the `dbms` is used during SQL-only execution. 
    * By setting the dbms to ‘sql server’ the output SQL can still be rendered to any other dialect using `SqlRender` (see example below).
  * `sqlOnlyUnionCount` determines the number of check sqls to union in a single query. A smaller number gives more control and progress information, a higher number typically gives a higher performance. Here, 100 is used.


    
    
    [library](https://rdrr.io/r/base/library.html)([DataQualityDashboard](https://github.com/OHDSI/DataQualityDashboard))
    
    # ConnectionDetails object needed for sql dialect
    dbmsConnectionDetails <- DatabaseConnector::[createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(
      dbms = "sql server",  # can be rendered to any dbms upon execution
      pathToDriver = "/"
    )
    
    # Database parameters that are pre-filled in the written queries
    # Use @-syntax if creating a template-sql at execution-time (e.g. "@cdmDatabaseSchema")
    cdmDatabaseSchema <- "@cdmDatabaseSchema"   # the fully qualified database schema name of the CDM
    resultsDatabaseSchema <- "@resultsDatabaseSchema"   # the fully qualified database schema name of the results schema (that you can write to)
    writeTableName <- "@writeTableName"
    
    sqlFolder <- "./results_sql_only"
    cdmSourceName <- "Synthea"
    
    sqlOnly <- TRUE
    sqlOnlyIncrementalInsert <- TRUE    # this will generate an insert SQL query for each check type that will compute check results and insert them into a database table
    sqlOnlyUnionCount <- 100            # this unions up to 100 queries in each insert query
    
    verboseMode <- TRUE
    
    cdmVersion <- "5.4"
    checkLevels <- [c](https://rdrr.io/r/base/c.html)("TABLE", "FIELD", "CONCEPT")
    tablesToExclude <- [c](https://rdrr.io/r/base/c.html)()
    checkNames <- [c](https://rdrr.io/r/base/c.html)()
    
    # Run DQD with sqlOnly=TRUE and sqlOnlyIncrementalInsert=TRUE. This will create a sql file for each check type in the output folder
    DataQualityDashboard::[executeDqChecks](../reference/executeDqChecks.html)(
      connectionDetails = dbmsConnectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      resultsDatabaseSchema = resultsDatabaseSchema,
      writeTableName = writeTableName,
      cdmSourceName = cdmSourceName,
      sqlOnly = sqlOnly,
      sqlOnlyUnionCount = sqlOnlyUnionCount,
      sqlOnlyIncrementalInsert = sqlOnlyIncrementalInsert,
      outputFolder = sqlFolder,
      checkLevels = checkLevels,
      verboseMode = verboseMode,
      cdmVersion = cdmVersion,
      tablesToExclude = tablesToExclude,
      checkNames = checkNames
    )

After running above code, you will end up with a number of sql files in the specified output directory:

  * One sql file per check type: `TABLE|FIELD|CONCEPT_<check_name>.sql`.
  * `ddlDqdResults.sql` with the result table creation query.



The queries can then be run in any SQL client, making sure to run `ddlDqdResults.sql` first. The order of the check queries is not important, and can even be run in parallel. This will run the check, and store the result in the specified `writeTableName`. In order to show this result in the DQD Dashboard Shiny app, this table has to be exported and converted to the .json format. See below for example code of how this can be achieved.

## (OPTIONAL) Execute queries

Below code snippet shows how you can run the generated queries on an OMOP CDM database using OHDSI R packages, and display the results in the DQD Dashboard. Note that this approach uses two non-exported DQD functions (`.summarizeResults`, `.writeResultsToJson`) that are not tested for this purpose. In the future we plan to expand support for incremental-insert mode with a more robust set of public functions. Please reach out with feedback on our [GitHub page](https://github.com/OHDSI/DataQualityDashboard/issues) if you’d like to have input on the development of this new feature!
    
    
    [library](https://rdrr.io/r/base/library.html)([DatabaseConnector](https://ohdsi.github.io/DatabaseConnector/))
    cdmSourceName <- "<YourSourceName>"
    sqlFolder <- "./results_sql_only"
    jsonOutputFolder <- sqlFolder
    jsonOutputFile <- "sql_only_results.json"
    
    dbms <- [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("DBMS")
    server <- [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("DB_SERVER")
    port <- [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("DB_PORT")
    user <- [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("DB_USER")
    password <- [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("DB_PASSWORD")
    pathToDriver <- [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("PATH_TO_DRIVER")
    connectionDetails <- DatabaseConnector::[createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(
      dbms = dbms,
      server = server,
      port = port,
      user = user,
      password = password,
      pathToDriver = pathToDriver
    )
    cdmDatabaseSchema <- '<YourCdmSchemaName>'
    resultsDatabaseSchema <- '<YourResultsSchemaName>'
    writeTableName <- 'dqd_results' # or whatever you want to name your results table
    
    c <- DatabaseConnector::[connect](https://ohdsi.github.io/DatabaseConnector/reference/connect.html)(connectionDetails)
    
    # Create results table
    ddlFile <- [file.path](https://rdrr.io/r/base/file.path.html)(sqlFolder, "ddlDqdResults.sql")
    DatabaseConnector::[renderTranslateExecuteSql](https://ohdsi.github.io/DatabaseConnector/reference/renderTranslateExecuteSql.html)(
      connection = c,
      sql = [readChar](https://rdrr.io/r/base/readChar.html)(ddlFile, [file.info](https://rdrr.io/r/base/file.info.html)(ddlFile)$size),
      resultsDatabaseSchema = resultsDatabaseSchema,
      writeTableName = writeTableName
    )
    
    # Run checks
    dqdSqlFiles <- [Sys.glob](https://rdrr.io/r/base/Sys.glob.html)([file.path](https://rdrr.io/r/base/file.path.html)(sqlFolder, "*.sql"))
    for (dqdSqlFile in dqdSqlFiles) {
      if (dqdSqlFile == ddlFile) {
        next
      }
      [print](https://rdrr.io/r/base/print.html)(dqdSqlFile)
      [tryCatch](https://rdrr.io/r/base/conditions.html)(
        expr = {
          DatabaseConnector::[renderTranslateExecuteSql](https://ohdsi.github.io/DatabaseConnector/reference/renderTranslateExecuteSql.html)(
            connection = c,
            sql = [readChar](https://rdrr.io/r/base/readChar.html)(dqdSqlFile, [file.info](https://rdrr.io/r/base/file.info.html)(dqdSqlFile)$size),
            cdmDatabaseSchema = cdmDatabaseSchema,
            resultsDatabaseSchema = resultsDatabaseSchema,
            writeTableName = writeTableName
          )
        },
        error = function(e) {
         [print](https://rdrr.io/r/base/print.html)([sprintf](https://rdrr.io/r/base/sprintf.html)("Writing table failed for check %s with error %s", dqdSqlFile, e$message))
        }
      )
    }
    
    # Extract results table to JSON file for viewing or secondary use
    
    DataQualityDashboard::[writeDBResultsToJson](../reference/writeDBResultsToJson.html)(
        c,
        connectionDetails,
        resultsDatabaseSchema,
        cdmDatabaseSchema,
        writeTableName,
        jsonOutputFolder,
        jsonOutputFile
      )
    
    
    jsonFilePath <- R.utils::[getAbsolutePath](https://henrikbengtsson.github.io/R.utils/reference/getAbsolutePath.html)([file.path](https://rdrr.io/r/base/file.path.html)(jsonOutputFolder, jsonOutputFile))
    DataQualityDashboard::[viewDqDashboard](../reference/viewDqDashboard.html)(jsonFilePath)

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
