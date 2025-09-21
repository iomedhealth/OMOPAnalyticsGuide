# plausibleValueHigh • DataQualityDashboard

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



# plausibleValueHigh

#### Dymytry Dymshyts

#### 2025-08-27

Source: [`vignettes/checks/plausibleValueHigh.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/plausibleValueHigh.Rmd)

`plausibleValueHigh.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Plausibility  
**Subcategory** : Atemporal  
**Severity** : Characterization ✔

## Description

The number and percent of records with a value in the @cdmFieldName field of the @cdmTableName table greater than @plausibleValueHigh.

## Definition

  * _Numerator_ : The number of rows in a table where the checked field value is higher than some expected value.
  * _Denominator_ : The number of rows in a table where the checked field is not null.
  * _Related CDM Convention(s)_ : None. This check evaluates plausibility of values against common sense and known healthcare industry conventions.
  * _CDM Fields/Tables_ : 
    * All date and datetime fields (compared to today’s date + 1 day)
    * `PERSON.day_of_birth` (compared to 31)
    * `PERSON.month_of_birth` (compared to 12)
    * `PERSON.year_of_birth` (compared to this year + 1 year)
    * `DRUG_EXPOSURE.refills` (compared to 24)
    * `DRUG_EXPOSURE.days_supply` (compared to 365)
    * `DRUG_EXPOSURE.quantity` (compared to 1095)
  * _Default Threshold Value_ : 1%



## User Guidance

This check counts the number of records that have a value in the specified field that is higher than some expected value. Failures of this check might represent true data anomalies, but especially in the case when the failure percentage is high, something may be afoot in the ETL pipeline.

Use this query to inspect rows with an implausibly high value:

### Violated rows query
    
    
    SELECT 
      '@cdmTableName.@cdmFieldName' AS violating_field,  
      cdmTable.* 
    FROM @schema.@cdmTableName cdmTable 
    WHERE cdmTable.@cdmFieldName > @plausibleValueHigh 

### ETL Developers

The investigation approach may differ by the field being checked. For example, for `CONDITION_OCURRENCE.condition_start_date` you might look how much it differs in average, to find a clue as to what happened:
    
    
    SELECT 
      MEDIAN(DATEDIFF(day, condition_start_date, current_date)) 
    FROM condition_occurrence
    WHERE condition_start_date > current_date 
    ; 

Or the discrepancy be associated with specific attributes:
    
    
    SELECT 
      co.condition_concept_id, 
      co.condition_type_concept_id, 
      co.condition_status_concept_id, 
      COUNT(1) 
    FROM condition_occurrence co 
    WHERE condition_start_date > current_date  
    GROUP BY co.condition_concept_id, co.condition_type_concept_id, co.condition_status_concept_id 
    ORDER BY COUNT(1) DESC 
    ; 

There might be several different causes of future dates: typos in the source data, wrong data format used in the conversion, timezone issues in the ETL environment and/or database, etc.

For the `DRUG_EXPOSURE` values, there might be be typos, data processing bugs (for example, if days supply is calculated), or rare true cases when a prescription deviated from standard industry practices.

If the issue is determined to be related to ETL logic, it must be fixed. If it’s a source data issue, work with your data partners and users to determine the best remediation approach. `PERSON` rows with invalid birth dates should be removed from the CDM, as any analysis relying on age will be negatively impacted. Other implausible values should be explainable based on your understanding of the source data if they are to be retained. In some cases event rows may need to be dropped from the CDM if the implausible value is unexplainable and could cause downstream quality issues. Be sure to clearly document any data removal logic in your ETL specification.

### Data Users

The implication of a failure of this check depends on the count of errors and your need for the impacted columns. If it’s a small count, it might just be noise in the data which will unlikely impact an analysis. If the count is large, however, proceed carefully - events with future dates will likely be excluded from your analysis, and drugs with inflated supply values could throw off any analysis considering duration or patterns of treatment.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
