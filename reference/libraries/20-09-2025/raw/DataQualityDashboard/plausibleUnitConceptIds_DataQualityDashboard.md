# plausibleUnitConceptIds • DataQualityDashboard

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



# plausibleUnitConceptIds

#### Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/plausibleUnitConceptIds.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/plausibleUnitConceptIds.Rmd)

`plausibleUnitConceptIds.Rmd`

## Summary

**Level** : CONCEPT  
**Context** : Validation  
**Category** : Plausibility  
**Subcategory** : Atemporal  
**Severity** : Characterization ✔

## Description

The number and percent of records for a given CONCEPT_ID @conceptId (@conceptName) with implausible units (i.e., UNIT_CONCEPT_ID NOT IN (@plausibleUnitConceptIds)).

## Definition

  * _Numerator_ : For a given `concept_id`, the number of rows in the measurement table with a non-zero `unit_concept_id` that is not in the list of plausible unit concept ids. 
    * NB, in some cases the only plausible unit is no unit (represented by “-1” in the threshold file) - in this case, a non-null, non-zero `unit_concept_id` will fail this check.
  * _Denominator_ : The total number of rows in the measurement table with a given `concept_id` and a NULL or non-zero `unit_concept_id`.
  * _Related CDM Convention(s)_ : N/A
  * _CDM Fields/Tables_ : `MEASUREMENT`
  * _Default Threshold Value_ : 5%



## User Guidance

A failure of this check indicates one of the following:

  * A measurement record has the incorrect unit
  * A measurement record has a unit when it should not have one
  * The list of plausible unit concept IDs in the threshold file is incomplete (please report this as a DataQualityDashboard bug!)



The above issues could either be due to incorrect data in the source system or incorrect mapping of the unit concept IDs in the ETL process.

### Violated rows query
    
    
    SELECT 
      m.unit_concept_id,
      m.unit_source_concept_id,
      m.unit_source_value,
      COUNT(*)
    FROM @cdmDatabaseSchema.@cdmTableName m
    WHERE m.@cdmFieldName = @conceptId
      AND m.unit_concept_id IS NOT NULL
      /* '-1' stands for the cases when the only plausible unit_concept_id is no unit; 0 prevents flagging rows with a unit_concept_id of 0, which are checked in standardConceptRecordCompleteness */
      AND (
        ('@plausibleUnitConceptIds' = '-1' AND m.unit_concept_id != 0)  
        OR m.unit_concept_id NOT IN (@plausibleUnitConceptIds, 0)
      )
    GROUP BY 1,2,3

Inspect the output of the violated rows query to identify the root cause of the issue. If the `unit_source_value` and/or `unit_source_concept_id` are populated, check them against the list of plausible unit concept IDs to understand if they should have been mapped to one of the plausible standard concepts. If the `unit_source_value` is NULL and the list of plausible unit concept IDs does not include -1, then you may need to check your source data to understand whether or not a unit is available in the source.

### ETL Developers

Ensure that all units available in the source data are being pulled into the CDM and mapped correctly to a standard concept ID. If a unit is available in the source and is being correctly populated & mapped in your ETL but is _not_ present on the list of plausible unit concept IDs, you should verify whether or not the unit is actually plausible - you may need to consult a clinician to do so. If the unit is plausible for the given measurement, please report this as a DataQualityDashboard bug here: <https://github.com/OHDSI/DataQualityDashboard/issues>. If the unit is not plausible, do not change it! Instead, you should document the issue for users of the CDM and discuss with your data provider how to handle the data.

### Data Users

It is generally not recommended to use measurements with implausible units in analyses as it is impossible to determine whether the unit is wrong; the value is wrong; and/or the measurement code is wrong in the source data. If a measurement is missing a `unit_concept_id` due to an ETL issue, and the `unit_source_value` or `unit_source_concept_id` is available, you can utilize these values to perform your analysis. If `unit_source_value` and `unit_source_concept_id` are missing, you may consider consulting with your data provider as to if and when you may be able to infer what the missing unit should be.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
