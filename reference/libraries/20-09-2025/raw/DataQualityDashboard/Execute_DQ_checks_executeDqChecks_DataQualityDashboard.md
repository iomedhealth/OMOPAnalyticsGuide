# Execute DQ checks — executeDqChecks • DataQualityDashboard

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



# Execute DQ checks

Source: [`R/executeDqChecks.R`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/R/executeDqChecks.R)

`executeDqChecks.Rd`

This function will connect to the database, generate the sql scripts, and run the data quality checks against the database. By default, results will be written to a json file as well as a database table.
    
    
    executeDqChecks(
      connectionDetails,
      cdmDatabaseSchema,
      resultsDatabaseSchema,
      vocabDatabaseSchema = cdmDatabaseSchema,
      cdmSourceName,
      numThreads = 1,
      sqlOnly = FALSE,
      sqlOnlyUnionCount = 1,
      sqlOnlyIncrementalInsert = FALSE,
      outputFolder,
      outputFile = "",
      verboseMode = FALSE,
      writeToTable = TRUE,
      writeTableName = "dqdashboard_results",
      writeToCsv = FALSE,
      csvFile = "",
      checkLevels = [c](https://rdrr.io/r/base/c.html)("TABLE", "FIELD", "CONCEPT"),
      checkNames = [c](https://rdrr.io/r/base/c.html)(),
      checkSeverity = [c](https://rdrr.io/r/base/c.html)("fatal", "convention", "characterization"),
      cohortDefinitionId = [c](https://rdrr.io/r/base/c.html)(),
      cohortDatabaseSchema = resultsDatabaseSchema,
      cohortTableName = "cohort",
      tablesToExclude = [c](https://rdrr.io/r/base/c.html)("CONCEPT", "VOCABULARY", "CONCEPT_ANCESTOR",
        "CONCEPT_RELATIONSHIP", "CONCEPT_CLASS", "CONCEPT_SYNONYM", "RELATIONSHIP", "DOMAIN"),
      cdmVersion = "5.3",
      tableCheckThresholdLoc = "default",
      fieldCheckThresholdLoc = "default",
      conceptCheckThresholdLoc = "default"
    )

## Arguments

connectionDetails
    

A connectionDetails object for connecting to the CDM database

cdmDatabaseSchema
    

The fully qualified database name of the CDM schema

resultsDatabaseSchema
    

The fully qualified database name of the results schema

vocabDatabaseSchema
    

The fully qualified database name of the vocabulary schema (default is to set it as the cdmDatabaseSchema)

cdmSourceName
    

The name of the CDM data source

numThreads
    

The number of concurrent threads to use to execute the queries

sqlOnly
    

Should the SQLs be executed (FALSE) or just returned (TRUE)?

sqlOnlyUnionCount
    

(OPTIONAL) In sqlOnlyIncrementalInsert mode, how many SQL commands to union in each query to insert check results into results table (can speed processing when queries done in parallel). Default is 1.

sqlOnlyIncrementalInsert
    

(OPTIONAL) In sqlOnly mode, boolean to determine whether to generate SQL queries that insert check results and associated metadata into results table. Default is FALSE (for backwards compatibility to <= v2.2.0)

outputFolder
    

The folder to output logs, SQL files, and JSON results file to

outputFile
    

(OPTIONAL) File to write results JSON object

verboseMode
    

Boolean to determine if the console will show all execution steps. Default is FALSE

writeToTable
    

Boolean to indicate if the check results will be written to the dqdashboard_results table in the resultsDatabaseSchema. Default is TRUE

writeTableName
    

The name of the results table. Defaults to `dqdashboard_results`. Used when sqlOnly or writeToTable is True.

writeToCsv
    

Boolean to indicate if the check results will be written to a csv file. Default is FALSE

csvFile
    

(OPTIONAL) CSV file to write results

checkLevels
    

Choose which DQ check levels to execute. Default is all 3 (TABLE, FIELD, CONCEPT)

checkNames
    

(OPTIONAL) Choose which check names to execute. Names can be found in inst/csv/OMOP_CDM_v[cdmVersion]_Check_Descriptions.csv. Note that "cdmTable", "cdmField" and "measureValueCompleteness" are always executed.

checkSeverity
    

Choose which DQ check severity levels to execute. Default is all 3 (fatal, convention, characterization)

cohortDefinitionId
    

The cohort definition id for the cohort you wish to run the DQD on. The package assumes a standard OHDSI cohort table with the fields cohort_definition_id and subject_id.

cohortDatabaseSchema
    

The schema where the cohort table is located.

cohortTableName
    

The name of the cohort table. Defaults to `cohort`.

tablesToExclude
    

(OPTIONAL) Choose which CDM tables to exclude from the execution.

cdmVersion
    

The CDM version to target for the data source. Options are "5.2", "5.3", or "5.4". By default, "5.3" is used.

tableCheckThresholdLoc
    

The location of the threshold file for evaluating the table checks. If not specified the default thresholds will be applied.

fieldCheckThresholdLoc
    

The location of the threshold file for evaluating the field checks. If not specified the default thresholds will be applied.

conceptCheckThresholdLoc
    

The location of the threshold file for evaluating the concept checks. If not specified the default thresholds will be applied.

## Value

If sqlOnly = FALSE, a list object of results

## Contents

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
