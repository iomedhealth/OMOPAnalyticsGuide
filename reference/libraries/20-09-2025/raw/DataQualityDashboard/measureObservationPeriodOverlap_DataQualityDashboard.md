# measureObservationPeriodOverlap • DataQualityDashboard

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



# measureObservationPeriodOverlap

#### Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/measureObservationPeriodOverlap.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/measureObservationPeriodOverlap.Rmd)

`measureObservationPeriodOverlap.Rmd`

## Summary

**Level** : Table check  
**Context** : Verification  
**Category** : Plausibility  
**Subcategory** : Temporal  
**Severity** : Fatal 💀  


## Description

The number and percent of persons that have overlapping or back-to-back observation periods.

## Definition

This check verifies that observation periods for each person do not overlap or have gaps of only one day between them. According to the OMOP CDM specification, observation periods should not overlap or be back-to-back to each other.

  * _Numerator_ : The number of persons who have at least one pair of overlapping or back-to-back observation periods
  * _Denominator_ : The total number of persons with observation periods
  * _Related CDM Convention(s)_ : “Any two overlapping or adjacent OBSERVATION_PERIOD records have to be merged into one” from [CDM specification](https://ohdsi.github.io/CommonDataModel/cdm54.html#observation_period)
  * _CDM Fields/Tables_ : `OBSERVATION_PERIOD`
  * _Default Threshold Value_ : 0%



## User Guidance

A failure in this check indicates that there are persons in the database who have overlapping or back-to-back observation periods, which violates the OMOP CDM specification. Such observation periods will lead to critical errors in analytics as all OHDSI tools assume that observation periods do not overlap.

### Violated rows query

You may use the following SQL query to identify the specific persons with overlapping observation periods:
    
    
    SELECT DISTINCT
        cdmTable.person_id,
        cdmTable.observation_period_start_date,
        cdmTable.observation_period_end_date,
        cdmTable2.observation_period_start_date AS overlap_start,
        cdmTable2.observation_period_end_date AS overlap_end,
        CASE 
            WHEN cdmTable.observation_period_start_date <= cdmTable2.observation_period_end_date 
                AND cdmTable.observation_period_end_date >= cdmTable2.observation_period_start_date
            THEN 'Overlapping'
            WHEN DATEADD(day, 1, cdmTable.observation_period_end_date) = cdmTable2.observation_period_start_date
                OR DATEADD(day, 1, cdmTable2.observation_period_end_date) = cdmTable.observation_period_start_date
            THEN 'Back-to-back'
        END AS violation_type
    FROM @cdmDatabaseSchema.observation_period cdmTable
    JOIN @cdmDatabaseSchema.observation_period cdmTable2 
        ON cdmTable.person_id = cdmTable2.person_id
        AND cdmTable.observation_period_id != cdmTable2.observation_period_id
    WHERE (cdmTable.observation_period_start_date <= cdmTable2.observation_period_end_date 
        AND cdmTable.observation_period_end_date >= cdmTable2.observation_period_start_date)
        OR (DATEADD(day, 1, cdmTable.observation_period_end_date) = cdmTable2.observation_period_start_date)
        OR (DATEADD(day, 1, cdmTable2.observation_period_end_date) = cdmTable.observation_period_start_date)
    ORDER BY cdmTable.person_id, cdmTable.observation_period_start_date

### ETL Developers

If this check fails, you should investigate the root cause to determine if the issue originates in the source data or if it is the result of an ETL bug. Logic will need to be added to the ETL to correctly merge overlapping or back-to-back periods of observed time, and/or to handle bad data from the source. This is a fatal check and all failures must be resolved before the CDM can be used.

**Examples of violations:**

  1. **Overlapping periods** : 
     * Period 1: 2020-01-01 to 2020-06-30
     * Period 2: 2020-05-01 to 2020-12-31
     * These overlap from 2020-05-01 to 2020-06-30
  2. **Back-to-back periods** : 
     * Period 1: 2020-01-01 to 2020-06-30  

     * Period 2: 2020-07-01 to 2020-12-31
     * These are back-to-back (one ends exactly one day before the other starts)



Both scenarios should be merged into a single period from 2020-01-01 to 2020-12-31.

### Data Users

An OMOP CDM with overlapping or adjacent observation periods should not be used. OHDSI tools assume that observation periods do not overlap, and as such will return errors or incorrect results; for example, cohort entry criteria and calculation of person-time will be executed incorrectly.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
