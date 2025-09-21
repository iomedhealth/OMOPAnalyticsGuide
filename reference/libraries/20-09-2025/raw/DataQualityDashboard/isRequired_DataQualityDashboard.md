# isRequired • DataQualityDashboard

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



# isRequired

#### Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/isRequired.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/isRequired.Rmd)

`isRequired.Rmd`

## Summary

**Level** : Field check  
**Context** : Validation  
**Category** : Conformance  
**Subcategory** : Relational  
**Severity** : Fatal 💀  


## Description

The number and percent of records with a NULL value in the **cdmFieldName** of the **cdmTableName** that is considered not nullable

## Definition

This check is meant to ensure that all NOT NULL constraints specified in the CDM version are followed.

  * _Numerator_ : The number of rows with a NULL value in the column
  * _Denominator_ : The total number of rows in the table
  * _Related CDM Convention(s)_ : “Required” flag in [CDM table specs](https://ohdsi.github.io/CommonDataModel/index.html)
  * _CDM Fields/Tables_ : By default, this check runs on all Required fields in the CDM
  * _Default Threshold Value_ : 0%



## User Guidance

A failure in this check means that NULL values have ended up in a column which should not contain any NULL values. There is a wide variety of potential causes for this issue depending on the column in question; your source data; and your ETL code. Regardless of its cause, it is mandatory to fix the issue by ensuring there are no failures of this check – OHDSI tools/analyses expect required columns to be non-NULL in all rows.

### Violated rows query
    
    
    SELECT 
      '@cdmTableName.@cdmFieldName' AS violating_field, 
      cdmTable.* 
    FROM @schema.@cdmTableName cdmTable
    WHERE cdmTable.@cdmFieldName IS NULL

### ETL Developers

Recommended actions:

  * To catch this issue further upstream, consider adding a not-null constraint on the column in your database (if possible)
  * Fill in the missing values: 
    * In some columns, placeholder values are acceptable to replace missing values. For example, in rows for which there is no _source_value or no standard concept mapping, the value 0 should be placed in the _concept_id column
    * Similarly, the CDM documentation suggests derivation/imputation strategies for certain columns. For example, the visit_end_date column is required but several options for deriving a placeholder are provided: <https://ohdsi.github.io/CommonDataModel/cdm54.html#VISIT_OCCURRENCE>. Consult the documentation for similar conventions on other columns
    * For missing values in columns in which it is not acceptable to add a placeholder or derived value (i.e. primary & foreign keys other than concept IDs), there is likely a corresponding ETL error which needs to be fixed
  * If you are unable to fill in the missing value for a record according to the CDM conventions, it is best to remove the record from your database. It is recommended to document this action for data users, especially if you need to do this for more than a handful of records and/or if there is a pattern to the missing data



### Data Users

This is a critical failure as it can impact joins and calculations involving required fields which assume all values are non-NULL. Events missing a concept, start date, or person ID will not be able to be included in cohorts. Rows missing a primary key violate fundamental database integrity principles and could cause a host of downstream issues. It is also possible that some tools or analysis code have assumptions around the availability of data in required columns which may throw errors due to missing values.

If your data provider is unable or unwilling to address the issue and only a small proportion of rows are affected, proceed at your own risk with the dataset. If you do so, it is a best practice to interrogate whether the affected rows could have played any role in your analysis. If a large proportion of rows are affected, the dataset should not be used until the issue is fixed.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
