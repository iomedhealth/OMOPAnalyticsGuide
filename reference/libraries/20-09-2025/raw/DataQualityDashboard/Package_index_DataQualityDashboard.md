# Package index • DataQualityDashboard

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



# Reference

## Execution 

Function for running data quality checks  
---  
`[executeDqChecks()](executeDqChecks.html)` | Execute DQ checks  
`[writeJsonResultsToTable()](writeJsonResultsToTable.html)` | Write JSON Results to SQL Table  
  
## View Dashboard 

Function for viewing the data quality dashboard  
`[viewDqDashboard()](viewDqDashboard.html)` | View DQ Dashboard  
  
## Re-evaluate Thresholds 

Function to take a set of DQD results and re-evaluate them against new thresholds  
`[reEvaluateThresholds()](reEvaluateThresholds.html)` | Re-evaluate Thresholds  
  
## List all DQD Checks 

Function to list all checks run by the application  
`[listDqChecks()](listDqChecks.html)` | List DQ checks  
  
## Write DQD results to a CSV 

Function to write the JSON results to a csv file  
`[writeJsonResultsToCsv()](writeJsonResultsToCsv.html)` | Write JSON Results to CSV file  
  
## Convert results JSON file case 

Function to convert the case of a results JSON file between snakecase and camelcase  
`[convertJsonResultsFileCase()](convertJsonResultsFileCase.html)` | Convert JSON results file case  
  
## Write database results to a JSON file 

Function to write DQD results from a database table into a JSON file  
`[writeDBResultsToJson()](writeDBResultsToJson.html)` | Write DQD results database table to json  
  
## Contents

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
