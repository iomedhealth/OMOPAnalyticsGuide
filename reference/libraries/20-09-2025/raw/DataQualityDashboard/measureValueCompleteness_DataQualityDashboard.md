# measureValueCompleteness • DataQualityDashboard

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



# measureValueCompleteness

#### Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/measureValueCompleteness.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/measureValueCompleteness.Rmd)

`measureValueCompleteness.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Completeness  
**Subcategory** :  
**Severity** : Characterization ✔

## Description

The number and percent of records with a NULL value in the @cdmFieldName of the @cdmTableName.

## Definition

  * _Numerator_ : The number of rows with a NULL value in the field.
  * _Denominator_ : The total number of rows in the table.
  * _Related CDM Convention(s)_ : None. This check should be used to check local expectations about completeness of a field given characteristics of the source data.
  * _CDM Fields/Tables_ : All fields in all event tables.
  * _Default Threshold Value_ : 
    * 0% for required fields
    * 100% for all others



## User Guidance

This check’s primary purpose is to characterize completeness of non-required fields in the OMOP CDM. It is most useful when the failure threshold for each non-required field is customized to expectations based on the source data being transformed into OMOP. In this case, the check can be used to catch unexpected missingness due to ETL errors. However, in all cases, this check will serve as a useful characterization to help data users understand if a CDM contains the right data for a given analysis.

While the failure threshold is set to 0 for required fields, note that this is duplicative with the `isRequired` check - and fixing one failure will resolve the other!

### Violated rows query

Use this SQL query to inspect rows with a missing value in a given field:
    
    
    SELECT  
      '@cdmTableName.@cdmFieldName' AS violating_field,  
      cdmTable.*  
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable       
    WHERE cdmTable.@cdmFieldName IS NULL 

### ETL Developers

Failures of this check on required fields are redundant with failures of `isRequired`. See [isRequired documentation](isRequired.html) for more information.

ETL developers have 2 main options for the use of this check on non-required fields:

  * The check threshold may be left on 100% for non-required fields such that the check will never fail. The check result can be used simply to understand completeness for these fields
  * The check threshold may be set to an appropriate value corresponding to completeness expectations for each field given what’s available in the source data. The check may be disabled for fields known not to exist in the source data. Other fields may be set to whichever threshold is deemed worthy of investigation



Unexpectedly missing values should be investigated for a potential root cause in the ETL. If a threshold has been adjusted to account for expected missingness, this should be clearly communicated to data users so that they can know when and when not to expect data to be present in each field.

### Data Users

This check informs you of the level of missing data in each column of the CDM. If data is missing in a required column, see the `isRequired` documentation for more information.

The interpretation of a check failure on a non-required column will depend on the context. In some cases, the threshold for this check will have been very deliberately set, and any failure should be cause for concern unless justified and explained by your ETL provider. In other cases, even if the check fails it may not be worrisome if the check result is in line with your expectations given the source of the data. When in doubt, utilize the inspection query above to ensure you can explain the missing values.

Of course, if there is a failure on a non-required field you know that you will not need in your analysis (for example, missing drug quantity in an analysis not utilizing drug data), the check failure may be safely ignored.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
