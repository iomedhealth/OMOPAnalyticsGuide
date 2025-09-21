# Convert JSON results file case — convertJsonResultsFileCase • DataQualityDashboard

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



# Convert JSON results file case

Source: [`R/convertResultsCase.R`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/R/convertResultsCase.R)

`convertJsonResultsFileCase.Rd`

Convert a DQD JSON results file between camelcase and (all-caps) snakecase. Enables viewing of pre-v.2.1.0 results files in later DQD versions, and vice versa
    
    
    convertJsonResultsFileCase(
      jsonFilePath,
      writeToFile,
      outputFolder = NA,
      outputFile = "",
      targetCase
    )

## Arguments

jsonFilePath
    

Path to the JSON results file to be converted

writeToFile
    

Whether or not to write the converted results back to a file (must be either TRUE or FALSE)

outputFolder
    

The folder to output the converted JSON results file to

outputFile
    

(OPTIONAL) File to write converted results JSON object to. Default is name of input file with a "_camel" or "_snake" postfix

targetCase
    

Case into which the results file parameters should be converted (must be either "camel" or "snake")

## Value

DQD results object (a named list)

## Contents

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
