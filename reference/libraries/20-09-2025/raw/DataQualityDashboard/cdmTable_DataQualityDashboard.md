# cdmTable • DataQualityDashboard

Toggle navigation [DataQualityDashboard](../../index.html) 2.7.0

  * [ ](../../index.html)
  * [Get started](../../articles/DataQualityDashboard.html)
  * [Reference](../../reference/index.html)
  * Articles 
    * [DQ Check Failure Thresholds](../../articles/Thresholds.html)
    * [DQ Check Statuses](../../articles/CheckStatusDefinitions.html)
    * [Adding a New Data Quality Check](../../articles/AddNewCheck.html)
    * [DQD for Cohorts](../../articles/DqdForCohorts.html)
    * [SQL-only Mode](../../articles/SqlOnly.html)
  * Data Quality Check Types 
    * [Index](../../articles/checkIndex.html)
    * [cdmTable](../../articles/checks/cdmTable.html)
    * [cdmField](../../articles/checks/cdmField.html)
    * [cdmDatatype](../../articles/checks/cdmDatatype.html)
    * [isPrimaryKey](../../articles/checks/isPrimaryKey.html)
    * [isForeignKey](../../articles/checks/isForeignKey.html)
    * [isRequired](../../articles/checks/isRequired.html)
    * [fkDomain](../../articles/checks/fkDomain.html)
    * [fkClass](../../articles/checks/fkClass.html)
    * [measurePersonCompleteness](../../articles/checks/measurePersonCompleteness.html)
    * [measureValueCompleteness](../../articles/checks/measureValueCompleteness.html)
    * [isStandardValidConcept](../../articles/checks/isStandardValidConcept.html)
    * [standardConceptRecordCompleteness](../../articles/checks/standardConceptRecordCompleteness.html)
    * [sourceConceptRecordCompleteness](../../articles/checks/sourceConceptRecordCompleteness.html)
    * [sourceValueCompleteness](../../articles/checks/sourceValueCompleteness.html)
    * [plausibleAfterBirth](../../articles/checks/plausibleAfterBirth.html)
    * [plausibleBeforeDeath](../../articles/checks/plausibleBeforeDeath.html)
    * [plausibleStartBeforeEnd](../../articles/checks/plausibleStartBeforeEnd.html)
    * [plausibleValueHigh](../../articles/checks/plausibleValueHigh.html)
    * [plausibleValueLow](../../articles/checks/plausibleValueLow.html)
    * [withinVisitDates](../../articles/checks/withinVisitDates.html)
    * [measureConditionEraCompleteness](../../articles/checks/measureConditionEraCompleteness.html)
    * [measureObservationPeriodOverlap](../../articles/checks/measureObservationPeriodOverlap.html)
    * [plausibleUnitConceptIds](../../articles/checks/plausibleUnitConceptIds.html)
    * [plausibleGenderUseDescendants](../../articles/checks/plausibleGenderUseDescendants.html)
  * [Changelog](../../news/index.html)


  * [![](https://ohdsi.github.io/Hades/images/hadesMini.png)](https://ohdsi.github.io/Hades)
  * [ ](https://github.com/OHDSI/DataQualityDashboard/)



# cdmTable

#### John Gresh, Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/cdmTable.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/cdmTable.Rmd)

`cdmTable.Rmd`

## Summary

**Level** : Table check  
**Context** : Verification  
**Category** : Conformance  
**Subcategory** : Relational  
**Severity** : Fatal 💀  


## Description

A yes or no value indicating if the **cdmTable** table is present in the database.

## Definition

This check verifies if a table is present as specified in the CDM specification for the relevant CDM version.

  * _Numerator_ : If the table is present, the numerator of the check result will be 0; if the table is absent the check will throw an error
  * _Denominator_ : The denominator is always a placeholder value of 1
  * _Related CDM Convention(s)_ : Listed tables in [CDM table specs](https://ohdsi.github.io/CommonDataModel/index.html)
  * _CDM Fields/Tables_ : By default, this check runs on all tables in the CDM
  * _Default Threshold Value_ : 0%



## User Guidance

This check failure must be resolved to avoid errors in downstream tools/analyses. OHDSI tools assume a complete set of OMOP CDM tables, as may anyone designing an analysis on OMOP data. Even if you don’t intend to populate a table, it should still be present in the database.

There are 3 possible causes for this check failure:

  * The wrong CDM version was specified in `executeDqChecks`
  * The table does not exist in the database
  * The table has the wrong name



Before taking any action to investigate/fix the failure, make sure the CDM version you specified when running `executeDqChecks` matches the version of your CDM. Some tables were added between CDM versions 5.3 and 5.4 so it’s important you’re running DQD with the correct configuration. If the versions _do_ match, there is most likely an issue with the ETL.

### ETL Developers

To resolve the failure, you will need to amend the code/process that creates the table (e.g. DDL script). Make sure you know whether the table is missing altogether or if it has the wrong name. In the latter case, the table should be renamed/replaced with the correctly named table. Reference the CDM documentation to confirm correct table naming.

### Data Users

Missing tables must be added to the CDM even if they are empty. This can be done using the CDM DDL scripts available in the [CommonDataModel GitHub repo](https://github.com/OHDSI/CommonDataModel). If a table has the wrong name, rename it or create a new table with the correct name and migrate the other table’s data there.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
