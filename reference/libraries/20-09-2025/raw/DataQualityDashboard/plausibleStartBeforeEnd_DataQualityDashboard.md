# plausibleStartBeforeEnd • DataQualityDashboard

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



# plausibleStartBeforeEnd

#### Maxim Moinat

#### 2025-08-27

Source: [`vignettes/checks/plausibleStartBeforeEnd.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/plausibleStartBeforeEnd.Rmd)

`plausibleStartBeforeEnd.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Plausibility  
**Subcategory** : Temporal  
**Severity** : CDM convention ⚠  


## Description

The number and percent of records with a value in the **cdmFieldName** field of the **cdmTableName** that occurs after the date in the **plausibleStartBeforeEndFieldName**. Note that this check replaces the previous `plausibleTemporalAfter` check.

## Definition

This check is attempting to apply temporal rules within a table, specifically checking that all start dates are before the end dates. For example, in the VISIT_OCCURRENCE table it checks that the VISIT_OCCURRENCE_START_DATE is before VISIT_OCCURRENCE_END_DATE. The start date can be before the end date or equal to the end date. It is applied to the start date field and takes the end date field as a parameter. Both date and datetime fields are checked.

  * _Numerator_ : The number of records where date in **cdmFieldName** is after the date in **plausibleStartBeforeEndFieldName**.
  * _Denominator_ : The total number of records with a non-null start and non-null end date value
  * _Related CDM Convention(s)_ : -Not linked to a convention-
  * _CDM Fields/Tables_ : This check runs on all start date/datetime fields with an end date/datetime in the same table. It also runs on the cdm_source table, comparing `source_release_date` is before `cdm_release_date`.
  * _Default Threshold Value_ : 
    * 0% for the observation_period, vocabulary (valid_start/end_date) and cdm_source tables.
    * 1% for other tables with an end date.



## User Guidance

If the start date is after the end date, it is likely that the data is incorrect or the dates are unreliable.

### Violated rows query
    
    
    SELECT 
      '@cdmTableName.@cdmFieldName' AS violating_field, 
      cdmTable.*
    FROM @schema.@cdmTableName cdmTable
    WHERE cdmTable.@cdmFieldName IS NOT NULL 
    AND cdmTable.@plausibleStartBeforeEndFieldName IS NOT NULL 
    AND cdmTable.@cdmFieldName > cdmTable.@plausibleStartBeforeEndFieldName

### ETL Developers

There main reason for this check to fail is often that the source data is incorrect. If the end date is derived from other data, the calculation might not take into account some edge cases.

Any violating checks should either be removed or corrected. In most cases this can be done by adjusting the end date: - With a few exceptions, the end date is not mandatory and can be left empty. - If the end date is mandatory (notably visit_occurrence and drug_exposure), the end date can be set to the start date if the event. Make sure to document this as it leads to loss of duration information. - If this check fails for the observation_period, it might signify a bigger underlying issue. Please investigate all records for this person in the CDM and source. - If neither the start or end date can be trusted, please remove the record from the CDM.

Make sure to clearly document the choices in your ETL specification.

### Data Users

An start date after the end date gives negative event durations, which might break analyses. Especially take note if this check fails for the `observation_period` table. This means that there are persons with negative observation time. If these persons are included in a cohort, it will potentially skew e.g. survival analyses.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
