# isPrimaryKey • DataQualityDashboard

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



# isPrimaryKey

#### John Gresh, Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/isPrimaryKey.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/isPrimaryKey.Rmd)

`isPrimaryKey.Rmd`

## Summary

**Level** : Field check  
**Context** : Verification  
**Category** : Conformance  
**Subcategory** : Relational  
**Severity** : Fatal 💀  


## Description

The number and percent of records that have a duplicate value in the **cdmFieldName** field of the **cdmTableName**.

## Definition

This check will make sure that all primary keys as specified in the CDM version are truly unique keys. While this issue should generally be prevented by primary key database constraints, some database management systems such as Redshift do not enforce these constraints.

  * _Numerator_ : The number of values in the column that appear in more than 1 row
  * _Denominator_ : The total number of rows in the table
  * _Related CDM Convention(s)_ : Primary Key flag in [CDM table specs](https://ohdsi.github.io/CommonDataModel/index.html)
  * _CDM Fields/Tables_ : By default, this check runs on all primary key columns in the CDM
  * _Default Threshold Value_ : 0%



## User Guidance

Multiple values for a primary key must be corrected. Failure to have unique values for a primary key will result in incorrect results being returned for queries that use these fields. This is especially true for joins - joins on columns where multiple records are found where a single record is assumed will result in inflation of the result set (“fanning”). Also, some analytic frameworks may raise errors if more than one record is found for an entity expected to be unique.

### Violated rows query
    
    
    SELECT 
      '@cdmTableName.@cdmFieldName' AS violating_field,  
      cdmTable.*,
      COUNT_BIG(*) OVER (PARTITION BY @cdmTableName.@cdmFieldName) AS dupe_count
    FROM @cdmDatabaseSchema.@cdmTableName
    WHERE dupe_count > 1
    ORDER BY dupe_count DESC;

### ETL Developers

In some cases, a primary key error could arise from a 1:1 relationship modeled in the CDM that is modeled as a 1:n relationship in the source system. For example, a single person could have multiple patient identifiers in a source system. In most cases the multiple records need to be collapsed into a single record.

Deduplication and merging of duplicate patient datasets is a non-trivial process, and the intent of the multiple patient records needs be ascertained prior to making design decisions. For example, multiple records could exist for the same patient in a claims system who was covered by the insurer during one period as a member of a first group and then later re-entered the system as new member of a different group (e.g. new employer). In other cases multiple records could indicate updates to the original record and the latest record could be considered the “correct” information.

### Data Users

Whenever possible, the ETL developer / data provider should be involved in resolving a primary key error as this represents a critical failure in the ETL process. Depending on the nature of the error, you may be able to remove duplicate rows from a table to resolve the error; however, proceed at your own risk as these duplicates could be the sign of a deeper issue that needs to be resolved further upstream.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
