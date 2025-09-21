# Write JSON Results to SQL Table — writeJsonResultsToTable • DataQualityDashboard

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



# Write JSON Results to SQL Table

Source: [`R/writeJsonResultsTo.R`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/R/writeJsonResultsTo.R)

`writeJsonResultsToTable.Rd`

Write JSON Results to SQL Table
    
    
    writeJsonResultsToTable(
      connectionDetails,
      resultsDatabaseSchema,
      jsonFilePath,
      writeTableName = "dqdashboard_results",
      cohortDefinitionId = [c](https://rdrr.io/r/base/c.html)(),
      singleTable = FALSE
    )

## Arguments

connectionDetails
    

A connectionDetails object for connecting to the CDM database

resultsDatabaseSchema
    

The fully qualified database name of the results schema

jsonFilePath
    

Path to the JSON results file generated using the execute function

writeTableName
    

Name of table in the database to write results to

cohortDefinitionId
    

If writing results for a single cohort this is the ID that will be appended to the table name

singleTable
    

If TRUE, writes all results to a single table. If FALSE (default), writes to 3 separate tables by check level (table, field, concept) (NOTE this default behavior will be deprecated in the future)

## Contents

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
