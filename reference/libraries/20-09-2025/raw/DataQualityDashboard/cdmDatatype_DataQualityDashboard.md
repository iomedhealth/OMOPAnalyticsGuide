# cdmDatatype • DataQualityDashboard

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



# cdmDatatype

#### Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/cdmDatatype.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/cdmDatatype.Rmd)

`cdmDatatype.Rmd`

## Summary

**Level** : Field check  
**Context** : Verification  
**Category** : Conformance  
**Subcategory** : Value  
**Severity** : Fatal 💀  


## Description

The number and percent of **cdmFieldName** values in the **cdmTableName** that are not the expected data type based on the specification.

## Definition

At present this check only verifies that integer fields contain integers.

  * _Numerator_ : In some SQL dialects, the numerator of the check will count non-null values that are non-numeric, or are numeric but contain a decimal point. In others, it will count non-null values that contain any non-digit character
  * _Denominator_ : The total number of records in the table
  * _Related CDM Convention(s)_ : Column datatypes in [CDM table specs](https://ohdsi.github.io/CommonDataModel/index.html)
  * _CDM Fields/Tables_ : By default, this check runs on all tables & fields in the CDM
  * _Default Threshold Value_ : 0%



## User Guidance

This check failure must be resolved. OHDSI tools & analyses expect integer columns to be integers and will throw errors and/or suffer performance issues if these columns are of the wrong type.

A failure in this check likely means that the column was created with the incorrect datatype (e.g., in an empty target table); that the data being loaded into the column is of the wrong type (e.g., in a “CREATE TABLE AS”); or that the wrong data was loaded into the column in error (e.g., mis-mapped in ETL).

Check the datatype of the column in your database’s information/system tables. It should match the datatype listed for the column in the CDM specification.

### Violated rows query

You may also use the “violated rows” SQL query to inspect the violating rows and help diagnose the potential root cause of the issue:
    
    
    SELECT  
      '@cdmTableName.@cdmFieldName' AS violating_field,  
      cdmTable.*  
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable 
    WHERE  
      (ISNUMERIC(cdmTable.@cdmFieldName) = 0  
        OR (ISNUMERIC(cdmTable.@cdmFieldName) = 1  
          AND CHARINDEX('.', CAST(ABS(cdmTable.@cdmFieldName) AS varchar)) != 0)) 
      AND cdmTable.@cdmFieldName IS NOT NULL 

### ETL Developer

If the data does not look as expected (e.g., dates in an integer column), trace back to your ETL code to determine the appropriate fix. If the data looks as expected but the column is the wrong type (e.g., string integers in an integer column), update the part of your ETL that creates the table to reflect the correct datatype for the column.

### Data User

If your data supplier is unwilling or unable to fix the issue, you should consider changing the type of the column yourself before using the dataset (though it’s probably a good idea to inspect the column contents first to make sure the data appear as expected - i.e., that this is not a case of the wrong source data being inserted into the column).

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
