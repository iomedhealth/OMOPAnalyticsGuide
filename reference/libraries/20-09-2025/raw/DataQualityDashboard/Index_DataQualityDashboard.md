# Index • DataQualityDashboard

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



# Index

#### Clair Blacketer, Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checkIndex.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checkIndex.Rmd)

`checkIndex.Rmd`

This section contains detailed descriptions of the data quality checks included in the DataQualityDashboard package. Each check is described on its own page; click on the check name in the list below or in the dropdown menu above to navigate to the check’s documentation page.

## Introduction

The DataQualityDashboard functions by applying over 20 parameterized check types to a CDM instance, resulting in thousands of resolved, executed, and evaluated individual data quality checks. For example, one check type might be written as

_The number and percent of records with a value in the**cdmFieldName** field of the **cdmTableName** table less than **plausibleValueLow**_.

This would be considered an atemporal plausibility verification check because we are looking for implausibly low values in some field based on internal knowledge. We can use this check type to substitute in values for **cdmFieldName** , **cdmTableName** , and **plausibleValueLow** to create a unique data quality check. If we apply it to PERSON.YEAR_OF_BIRTH here is how that might look:

_The number and percent of records with a value in the**year_of_birth** field of the **PERSON** table less than **1850**._

And, since it is parameterized, we can similarly apply it to DRUG_EXPOSURE.days_supply:

_The number and percent of records with a value in the**days_supply** field of the **DRUG_EXPOSURE** table less than **0**._

Version 1 of the tool includes over 20 different check types organized into Kahn contexts and categories ([link to paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5051581/)). Additionally, each data quality check type is considered either a table check, field check, or concept-level check. Table-level checks are those evaluating the table at a high-level without reference to individual fields, or those that span multiple event tables. These include checks making sure required tables are present or that at least some of the people in the PERSON table have records in the event tables. Field-level checks are those related to specific fields in a table. The majority of the check types in version 1 are field-level checks. These include checks evaluating primary key relationship and those investigating if the concepts in a field conform to the specified domain. Concept-level checks are related to individual concepts. These include checks looking for gender-specific concepts in persons of the wrong gender and plausible values for measurement-unit pairs.

This article will detail each check type, its name, check level, description, definition, and to which Kahn context, category, and subcategory it belongs.

### General guidance

  * These documentation pages are intended to provide a detailed description of each check and guidance for users on how to interpret the results of each check
  * Guidance is provided for both _ETL developers_ and _OMOP CDM users_ (e.g. analysts, data managers, etc). CDM users are strongly encouraged to work with their ETL development team, if possible, to understand and address any check failures attributable to ETL design. However, guidance is also provided in case this is not possible
  * In some cases, SQL snippets are provided to help investigate the cause of a check failure. These snippets are written in OHDSI SQL and can be rendered to run against your OMOP CDM using the [SQLRender](checks/https://ohdsi.github.io/SqlRender/) package. As always, it is also recommended to utilize the “violated rows” SQL (indicated by the comment lines `/*violatedRowsBegin*/` and `/*violatedRowsEnd*/`) from the SQL query displayed in the DQD results viewer for a given check to inspect rows that failed the check



### Checks

  * [cdmTable](checks/cdmTable.html)
  * [cdmField](checks/cdmField.html)
  * [cdmDatatype](checks/cdmDatatype.html)
  * [isPrimaryKey](checks/isPrimaryKey.html)
  * [isForeignKey](checks/isForeignKey.html)
  * [isRequired](checks/isRequired.html)
  * [fkDomain](checks/fkDomain.html)
  * [fkClass](checks/fkClass.html)
  * [measurePersonCompleteness](checks/measurePersonCompleteness.html)
  * [measureConditionEraCompleteness](checks/measureConditionEraCompleteness.html)
  * [measureObservationPeriodOverlap](checks/measureObservationPeriodOverlap.html)
  * [isStandardValidConcept](checks/isStandardValidConcept.html)
  * [measureValueCompleteness](checks/measureValueCompleteness.html)
  * [standardConceptRecordCompleteness](checks/standardConceptRecordCompleteness.html)
  * [sourceConceptRecordCompleteness](checks/sourceConceptRecordCompleteness.html)
  * [sourceValueCompleteness](checks/sourceValueCompleteness.html)
  * [plausibleValueLow](checks/plausibleValueLow.html)
  * [plausibleValueHigh](checks/plausibleValueHigh.html)
  * [withinVisitDates](checks/withinVisitDates.html)
  * [plausibleAfterBirth](checks/plausibleAfterBirth.html)
  * [plausibleBeforeDeath](checks/plausibleBeforeDeath.html)
  * [plausibleStartBeforeEnd](checks/plausibleStartBeforeEnd.html)
  * [plausibleGenderUseDescendants](checks/plausibleGenderUseDescendants.html)
  * [plausibleUnitConceptIds](checks/plausibleUnitConceptIds.html)



Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
