# Running the DQD on a Cohort • DataQualityDashboard

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



# Running the DQD on a Cohort

#### Clair Blacketer

#### 2025-08-27

Source: [`vignettes/DqdForCohorts.rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/DqdForCohorts.rmd)

`DqdForCohorts.rmd`

Running the Data Quality Dashboard for a cohort is fairly straightforward. There are two options in the `executeDqChecks` function, `cohortDefinitionId` and `cohortDatabaseSchema`. These options will point the DQD to the schema where the cohort table is located and provide the id of the cohort on which the DQD will be run. By default, the tool assumes that the table being referenced is the standard OHDSI cohort table named **COHORT** with at least the columns **cohort_definition_id** and **subject_id**. For example, if I have a cohort number 123 and the cohort is in the _results_ schema of the _IBM_CCAE_ database, the `executeDqChecks` function would look like this:
    
    
    
    DataQualityDashboard::[executeDqChecks](../reference/executeDqChecks.html)(connectionDetails = connectionDetails, 
                                        cdmDatabaseSchema = cdmDatabaseSchema, 
                                        resultsDatabaseSchema = resultsDatabaseSchema,
                                        cdmSourceName = "IBM_CCAE_cohort_123",
                                        cohortDefinitionId = 123,
                                        cohortDatabaseSchema = "IBM_CCAE.results",
                                        cohortTableName = "cohort",
                                        numThreads = numThreads,
                                        sqlOnly = sqlOnly, 
                                        outputFolder = outputFolder, 
                                        verboseMode = verboseMode,
                                        writeToTable = writeToTable,
                                        writeTableName = "dqdashboard_results_123",
                                        checkLevels = checkLevels,
                                        tablesToExclude = tablesToExclude,
                                        checkNames = checkNames)
                                        

As a note, it is good practice to have the `cdmSourceName` option and the `writeTableName` option reflect the name of the cohort so that the results don’t get confused with those of the entire database.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
