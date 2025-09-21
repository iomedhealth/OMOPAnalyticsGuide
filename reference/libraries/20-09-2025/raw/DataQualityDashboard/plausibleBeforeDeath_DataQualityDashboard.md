# plausibleBeforeDeath • DataQualityDashboard

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



# plausibleBeforeDeath

#### Maxim Moinat

#### 2025-08-27

Source: [`vignettes/checks/plausibleBeforeDeath.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/plausibleBeforeDeath.Rmd)

`plausibleBeforeDeath.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Plausibility  
**Subcategory** : Temporal  
**Severity** : Characterization ✔

## Description

The number and percent of records with a date value in the **cdmFieldName** field of the **cdmTableName** table that occurs more than 60 days after death. Note that this check replaces the previous `plausibleDuringLife` check.

## Definition

A record violates this check if the date is more than 60 days after the death date of the person, allowing administrative records directly after death.

  * _Numerator_ : The number of records where date in **cdmFieldName** is more than 60 days after the persons’ death date.
  * _Denominator_ : Total number of records of persons with a death date, in the **cdmTableName**.
  * _Related CDM Convention(s)_ : -Not linked to a convention-
  * _CDM Fields/Tables_ : This check runs on all date and datetime fields.
  * _Default Threshold Value_ : 1%



## User Guidance

Events are expected to occur between birth and death. The check `plausibleAfterbirth` checks for the former, this check for the latter. The 60-day period is a conservative estimate of the time it takes for administrative records to be updated after a person’s death. By default, both start and end dates are checked.

### Violated rows query
    
    
    SELECT 
        '@cdmTableName.@cdmFieldName' AS violating_field, 
        cdmTable.*
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable
    JOIN @cdmDatabaseSchema.death de 
        ON cdmTable.person_id = de.person_id
    WHERE cdmTable.@cdmFieldName IS NOT NULL 
        AND CAST(cdmTable.@cdmFieldName AS DATE) > DATEADD(day, 60, de.death_date)

### ETL Developers

Start dates after death are likely to be source data issues, and failing this check should trigger investigation of the source data quality. End dates after death can occur due to derivation logic. For example, a drug exposure can be prescribed as being continued long after death. In such cases, it is recommended to update the logic to end the prescription at death.

### Data Users

For most studies, a low number of violating records will have limited impact on data use as it could be caused by lagging administrative records. However, it might signify a larger data quality issue. Note that the percentage violating records reported is among records from death persons and such might be slightly inflated if comparing to the overall population.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
