# plausibleAfterBirth • DataQualityDashboard

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



# plausibleAfterBirth

#### Maxim Moinat, Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/plausibleAfterBirth.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/plausibleAfterBirth.Rmd)

`plausibleAfterBirth.Rmd`

## Summary

**Level** : Field check  
**Context** : Verification  
**Category** : Plausibility  
**Subcategory** : Temporal  
**Severity** : Characterization ✔

## Description

The number and percent of records with a date value in the **cdmFieldName** field of the **cdmTableName** table that occurs prior to birth. Note that this check replaces the previous `plausibleTemporalAfter` check.

## Definition

This check verifies that events happen after birth. The birthdate is taken from the `person` table, either the `birth_datetime` or composed from `year_of_birth`, `month_of_birth`, `day_of_birth` (taking 1st month/1st day if missing).

  * _Numerator_ : The number of records with a non-null date value that happen prior to birth
  * _Denominator_ : The total number of records in the table with a non-null date value
  * _Related CDM Convention(s)_ : -Not linked to a convention-
  * _CDM Fields/Tables_ : By default, this check runs on all date and datetime fields
  * _Default Threshold Value_ : 1%



## User Guidance

There might be valid reasons why a record has a date value that occurs prior to birth. For example, prenatal observations might be captured or procedures on the mother might be added to the file of the child. Therefore, some failing records are expected and the default threshold of 1% accounts for that.

However, if more records violate this check, there might be an issue with incorrect birthdates or events with a default date. It is recommended to investigate the records that fail this check to determine the cause of the error and set proper dates. If it is impossible to fix, then implement one of these:

  * Aggressive: Remove all patients who have at least one record before birth (if the birthdate of this patient is unreliable).
  * Less aggressive: Remove all rows that happen before birth. Probably this should be chosen as a conventional approach for data clean up (if the event dates are unreliable).
  * Conservative: Keep the records as is (if the date is actually valid, for e.g. prenatal observations).



Make sure to clearly document the choices in your ETL specification.

### Violated rows query

You may also use the “violated rows” SQL query to inspect the violating rows and help diagnose the potential root cause of the issue:
    
    
    SELECT 
        p.birth_datetime, 
        cdmTable.*
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable
        JOIN @cdmDatabaseSchema.person p ON cdmTable.person_id = p.person_id
    WHERE cdmTable.@cdmFieldName < p.birth_datetime, 

or, when birth_datetime is missing change to year, month, day columns:
    
    
    SELECT 
        p.year_of_birth, 
        p.month_of_birth, 
        p.day_of_birth, 
        cdmTable.*
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable
        JOIN @cdmDatabaseSchema.person p ON cdmTable.person_id = p.person_id
    WHERE cdmTable.@cdmFieldName < CAST(CONCAT(
            p.year_of_birth,
            COALESCE(
                RIGHT('0' + CAST(p.month_of_birth AS VARCHAR), 2),
                '01'
            ),
            COALESCE(
                RIGHT('0' + CAST(p.day_of_birth AS VARCHAR), 2),
                '01'
            )
        ) AS DATE)

Also, the length of the time interval between these dates might give you a hint of why the problem appears.
    
    
    select 
        date_difference, 
        COUNT(*)
    FROM (
        SELECT DATEDIFF(
            DAY, 
            @cdmFieldName, 
            COALESCE(
                CAST(p.birth_datetime AS DATE),
                CAST(CONCAT(p.year_of_birth,'-01-01') AS DATE))
            ) AS date_difference
        FROM @cdmTableName ct
            JOIN person p ON ct.person_id = p.person_id 
    ) cte
    WHERE date_difference > 0
    GROUP BY date_difference
    ORDER BY COUNT(*) DESC
    ;

### ETL Developers

As above, if the number of failing records is high, it is recommended to investigate the records that fail this check to determine the underlying cause of the error.

### Data Users

For most studies, violating records will have limited impact on data use. However, this check should be especially considered for studies involving neonatals and/or pregnancy.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
