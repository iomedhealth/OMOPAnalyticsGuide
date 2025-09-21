# Getting Started • DataQualityDashboard

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



# Getting Started

#### Clair Blacketer

#### 2025-08-27

Source: [`vignettes/DataQualityDashboard.rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/DataQualityDashboard.rmd)

`DataQualityDashboard.rmd`

## R Installation
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("remotes")
    remotes::[install_github](https://remotes.r-lib.org/reference/install_github.html)("OHDSI/DataQualityDashboard")

## Note

To view the JSON results in the shiny application the package requires that the CDM_SOURCE table has at least one row with some details about the database. This is to ensure that some metadata is delivered along with the JSON, should it be shared. As a best practice it is recommended to always fill in this table during ETL or at least prior to running the DQD.

## Executing Data Quality Checks
    
    
    
    # fill out the connection details -----------------------------------------------------------------------
    connectionDetails <- DatabaseConnector::[createConnectionDetails](https://ohdsi.github.io/DatabaseConnector/reference/createConnectionDetails.html)(
    dbms = "", 
    user = "", 
    password = "", 
    server = "", 
    port = "", 
    extraSettings = "",
    pathToDriver = ""
    )
    
    cdmDatabaseSchema <- "yourCdmSchema" # the fully qualified database schema name of the CDM
    resultsDatabaseSchema <- "yourResultsSchema" # the fully qualified database schema name of the results schema (that you can write to)
    cdmSourceName <- "Your CDM Source" # a human readable name for your CDM source
    cdmVersion <- "5.4" # the CDM version you are targetting. Currently supports 5.2, 5.3, and 5.4
    
    # determine how many threads (concurrent SQL sessions) to use ----------------------------------------
    numThreads <- 1 # on Redshift, 3 seems to work well
    
    # specify if you want to execute the queries or inspect them ------------------------------------------
    sqlOnly <- FALSE # set to TRUE if you just want to get the SQL scripts and not actually run the queries
    sqlOnlyIncrementalInsert <- FALSE # set to TRUE if you want the generated SQL queries to calculate DQD results and insert them into a database table (@resultsDatabaseSchema.@writeTableName)
    sqlOnlyUnionCount <- 1  # in sqlOnlyIncrementalInsert mode, the number of check sqls to union in a single query; higher numbers can improve performance in some DBMS (e.g. a value of 25 may be 25x faster)
    
    # NOTES specific to sqlOnly <- TRUE option ------------------------------------------------------------
    # 1. You do not need a live database connection.  Instead, connectionDetails only needs these parameters:
    #      connectionDetails <- DatabaseConnector::createConnectionDetails(
    #        dbms = "", # specify your dbms
    #        pathToDriver = "/"
    #      )
    # 2. Since these are fully functional queries, this can help with debugging.
    # 3. In the results output by the sqlOnlyIncrementalInsert queries, placeholders are populated for execution_time, query_text, and warnings/errors; and the NOT_APPLICABLE rules are not applied.
    # 4. In order to use the generated SQL to insert metadata and check results into output table, you must set sqlOnlyIncrementalInsert = TRUE.  Otherwise sqlOnly is backwards compatable with <= v2.2.0, generating queries which run the checks but don't store the results.
    
    
    # where should the results and logs go? ----------------------------------------------------------------
    outputFolder <- "output"
    outputFile <- "results.json"
    
    
    # logging type -------------------------------------------------------------------------------------
    verboseMode <- TRUE # set to FALSE if you don't want the logs to be printed to the console
    
    # write results to table? ------------------------------------------------------------------------------
    writeToTable <- TRUE # set to FALSE if you want to skip writing to a SQL table in the results schema
    
    # specify the name of the results table (used when writeToTable = TRUE and when sqlOnlyIncrementalInsert = TRUE)
    writeTableName <- "dqdashboard_results"
    
    # write results to a csv file? -----------------------------------------------------------------------
    writeToCsv <- FALSE # set to FALSE if you want to skip writing to csv file
    csvFile <- "" # only needed if writeToCsv is set to TRUE
    
    # if writing to table and using Redshift, bulk loading can be initialized -------------------------------
    
    # Sys.setenv("AWS_ACCESS_KEY_ID" = "",
    #            "AWS_SECRET_ACCESS_KEY" = "",
    #            "AWS_DEFAULT_REGION" = "",
    #            "AWS_BUCKET_NAME" = "",
    #            "AWS_OBJECT_KEY" = "",
    #            "AWS_SSE_TYPE" = "AES256",
    #            "USE_MPP_BULK_LOAD" = TRUE)
    
    # which DQ check levels to run -------------------------------------------------------------------
    checkLevels <- [c](https://rdrr.io/r/base/c.html)("TABLE", "FIELD", "CONCEPT")
    
    # which DQ checks to run? ------------------------------------
    checkNames <- [c](https://rdrr.io/r/base/c.html)() # Names can be found in inst/csv/OMOP_CDM_v5.3_Check_Descriptions.csv
    
    # which DQ severity levels to run? ----------------------------
    checkSeverity <- [c](https://rdrr.io/r/base/c.html)("fatal", "convention", "characterization") 
    
    # want to EXCLUDE a pre-specified list of checks? run the following code:
    #
    # checksToExclude <- c() # Names of check types to exclude from your DQD run
    # allChecks <- DataQualityDashboard::listDqChecks()
    # checkNames <- allChecks$checkDescriptions %>%
    #   subset(!(checkName %in% checksToExclude)) %>%
    #   select(checkName)
    
    # which CDM tables to exclude? ------------------------------------
    tablesToExclude <- [c](https://rdrr.io/r/base/c.html)("CONCEPT", "VOCABULARY", "CONCEPT_ANCESTOR", "CONCEPT_RELATIONSHIP", "CONCEPT_CLASS", "CONCEPT_SYNONYM", "RELATIONSHIP", "DOMAIN") # list of CDM table names to skip evaluating checks against; by default DQD excludes the vocab tables
    
    # run the job --------------------------------------------------------------------------------------
    DataQualityDashboard::[executeDqChecks](../reference/executeDqChecks.html)(connectionDetails = connectionDetails, 
                                cdmDatabaseSchema = cdmDatabaseSchema, 
                                resultsDatabaseSchema = resultsDatabaseSchema,
                                cdmSourceName = cdmSourceName, 
                                cdmVersion = cdmVersion,
                                numThreads = numThreads,
                                sqlOnly = sqlOnly, 
                                sqlOnlyUnionCount = sqlOnlyUnionCount,
                                sqlOnlyIncrementalInsert = sqlOnlyIncrementalInsert,
                                outputFolder = outputFolder,
                                outputFile = outputFile,
                                verboseMode = verboseMode,
                                writeToTable = writeToTable,
                                writeToCsv = writeToCsv,
                                csvFile = csvFile,
                                checkLevels = checkLevels,
                    checkSeverity = checkSeverity,
                                tablesToExclude = tablesToExclude,
                                checkNames = checkNames)
    
    # inspect logs ----------------------------------------------------------------------------
    ParallelLogger::[launchLogViewer](https://ohdsi.github.io/ParallelLogger/reference/launchLogViewer.html)(logFileName = [file.path](https://rdrr.io/r/base/file.path.html)(outputFolder, cdmSourceName, 
                                                          [sprintf](https://rdrr.io/r/base/sprintf.html)("log_DqDashboard_%s.txt", cdmSourceName)))
    
    # (OPTIONAL) if you want to write the JSON file to the results table separately -----------------------------
    jsonFilePath <- ""
    DataQualityDashboard::[writeJsonResultsToTable](../reference/writeJsonResultsToTable.html)(connectionDetails = connectionDetails, 
                                                resultsDatabaseSchema = resultsDatabaseSchema, 
                                                jsonFilePath = jsonFilePath)
                                                

## Viewing Results

**Launching Dashboard as Shiny App**
    
    
    # Use the fully-qualified path to the JSON results file
    DataQualityDashboard::[viewDqDashboard](../reference/viewDqDashboard.html)(jsonFilePath)

**Launching on a web server**

If you have npm installed:

  1. Install http-server:


    
    
    npm install -g http-server

  2. Name the output file _results.json_ and place it in inst/shinyApps/www

  3. Go to inst/shinyApps/www, then run:



    
    
    http-server

## View checks

To see description of checks using R, execute the command below:
    
    
    checks <- DataQualityDashboard::[listDqChecks](../reference/listDqChecks.html)(cdmVersion = "5.3") # Put the version of the CDM you are using

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
