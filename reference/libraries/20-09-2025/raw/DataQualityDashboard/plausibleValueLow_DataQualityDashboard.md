# plausibleValueLow • DataQualityDashboard

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



# plausibleValueLow

#### Dymytry Dymshyts

#### 2025-08-27

Source: [`vignettes/checks/plausibleValueLow.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/plausibleValueLow.Rmd)

`plausibleValueLow.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Plausibility  
**Subcategory** : Atemporal  
**Severity** : Characterization ✔

## Description

The number and percent of records with a value in the @cdmFieldName field of the @cdmTableName table less than @plausibleValueLow.

## Definition

  * _Numerator_ : The number of rows in a table where the checked field value is lower than some expected value.
  * _Denominator_ : The number of rows in a table where the checked field is not null.
  * _Related CDM Convention(s)_ : None. This check evaluates plausibility of values against common sense and known healthcare industry conventions.
  * _CDM Fields/Tables_ : 
    * All date and datetime fields (compared to 1/1/1950)
    * `PERSON.day_of_birth` (compared to 1)
    * `PERSON.month_of_birth` (compared to 1)
    * `PERSON.year_of_birth` (compared to 1850)
    * `PERSON.birth_datetime` (compared to 1/1/1850)
    * `CDM_SOURCE.cdm_release_date`, `CDM_SOURCE.source_release_date` (compared to 1/1/2000)
    * `DRUG_EXPOSURE.days_supply` (compared to 1)
    * `DRUG_EXPOSURE.quantity` (compared to 0.0000001)
    * `DRUG_EXPOSURE.refills` (compared to 0)
    * `DEVICE_EXPOSURE.quantity`, `SPECIMEN.quantity`, `PROCEDURE_OCCURRENCE.quantity` (compared to 1)
    * `DRUG_ERA.dose_value`, `DRUG_ERA.gap_days` (compared to 0)
    * `DRUG_ERA.drug_exposure_count` (compared to 1)
  * _Default Threshold Value_ : 1%



## User Guidance

This check counts the number of records that have a value in the specified field that is lower than some expected value. Failures of this check might represent true data anomalies, but especially in the case when the failure percentage is high, something may be afoot in the ETL pipeline.

Use this query to inspect rows with an implausibly high value:

### Violated rows query
    
    
    SELECT 
      '@cdmTableName.@cdmFieldName' AS violating_field,  
      cdmTable.* 
    FROM @schema.@cdmTableName cdmTable 
    WHERE cdmTable.@cdmFieldName < @plausibleValueHigh 

_See guidance for[plausibleValueHigh](plausibleValueHigh.html) for detailed investigation instructions (swapping out “high” for “low” and “>” for “<” where appropriate)._

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
