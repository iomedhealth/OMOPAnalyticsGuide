# withinVisitDates • DataQualityDashboard

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



# withinVisitDates

#### Clair Blacketer

#### 2025-08-27

Source: [`vignettes/checks/withinVisitDates.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/withinVisitDates.Rmd)

`withinVisitDates.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Plausibility  
**Subcategory** :  
**Severity** : Characterization ✔

## Description

The number and percent of records that occur one week before the corresponding `visit_start_date` or one week after the corresponding `visit_end_date`

## Definition

  * _Numerator_ : The number of rows in a table where the event date occurs more than 7 days prior to the corresponding visit start date or more than 7 days after the corresponding visit end date.
  * _Denominator_ : The total number of rows in the table with a corresponding visit (linked through `visit_occurrence_id`)
  * _Related CDM Convention(s)_ : There is no explicit convention tied to this check. However, the CDM documentation describes the `visit_occurrence_id` foreign key in the event tables as “The visit during which the  occurred.” The underlying assumption is that if a record is tied to a visit, then the date of the record should fall in some reasonable time period around the visit dates. This gives a week of leeway on either side for physician notes or other activities related to a visit to be recorded.  

  * _CDM Fields/Tables_ : This check runs on all event tables: `CONDITION_OCCURRENCE`, `PROCEDURE_OCCURRENCE`, `DRUG_EXPOSURE`, `DEVICE_EXPOSURE`, `MEASUREMENT`, `NOTE`, `OBSERVATION`, and `VISIT_DETAIL`. It will check either the `X_date` or `X_start_date` fields for alignment with corresponding `VISIT_OCCURRENCE` dates by linking on the `visit_occurrence_id`. (**Note:** For VISIT_DETAIL it will check both the visit_detail_start_date and visit_detail_end_date. The default threshold for these two checks is 1%.)
  * _Default Threshold Value_ : 
    * 1% for `VISIT_DETAIL`
    * 5% for all other tables



## User Guidance

There is no explicit convention that describes how events should align temporally with the visits they correspond to. This check is meant to identify egregious mismatches in dates that could signify an incorrect date field was used in the ETL or that the data should be used with caution if there is no reason for the mismatch (history of a condition, for example).

If this check fails the first action should be to investigate the failing rows for any patterns. The main query to find failing rows is below:

### Violated rows query
    
    
    SELECT 
      '@cdmTableName.@cdmFieldName' AS violating_field,  
      vo.visit_start_date, vo.visit_end_date, vo.person_id, 
      cdmTable.* 
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable 
    JOIN @cdmDatabaseSchema.visit_occurrence vo 
      ON cdmTable.visit_occurrence_id = vo.visit_occurrence_id 
    WHERE cdmTable.@cdmFieldName < dateadd(day, -7, vo.visit_start_date) 
      OR cdmTable.@cdmFieldName > dateadd(day, 7, vo.visit_end_date) 

### ETL Developers

The first step is to investigate whether visit and event indeed should be linked - e.g., do they belong to the same person; how far are the dates apart; is it possible the event was recorded during the visit. If they should be linked, then the next step is to investigate which of the event date and visit date is accurate.

One suggestion would be to identify if all of the failures are due to many events all having the same date. In some institutions there is a default date given to events in the case where a date is not given. Should this be the problem, the first step should be to identify if there is a different date field in the native data that can be used. If not, considerations should be made to determine if the rows should be dropped. Without a correct date it is challenging to use such events in health outcomes research.

Another reason for the discrepancy could be that the wrong date has been used for events. For instance, in some systems a diagnosis could have both an ‘observation date’ and an ‘administration date’. If the physician is updating records at a later date, the administration date can be later than the actual date the diagnosis was observed. In those cases, the observation date has to be used. If there is only an administration date, it is in some cases arguable to use the visit date for the diagnosis date.

Another suggestion would be to investigate if the failures are related to ‘History of’ conditions. It is often the case that a patient’s history is recorded during a visit, in which case they may report a diagnosis date prior to the given visit. In some cases it may be appropriate to conserve these records; the decision to do so will depend on the reliability of the recorded date in your source data.

### Data Users

If the failure percentage of withinVisitDates is high, a data user should be careful with using the data. This check might indicate a larger underlying conformance issue with either the event dates or linkage with visits. At the same time, there might be a valid reason why events do not happen within 7 days of the linked visit.

Make sure to understand why this check fails. Specifically, be careful when using such data in outcomes research. Without specific dates for an event, it is challenging to determine if an adverse event occurred after a drug exposure, for example.

Note that this check specifically compares event dates to `VISIT_OCCURRENCE` dates. There is no equivalent check for `VISIT_DETAIL` that verifies whether the event date is within (a week of) the visit detail start and end dates.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
