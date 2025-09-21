# measurePersonCompleteness • DataQualityDashboard

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



# measurePersonCompleteness

#### Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/measurePersonCompleteness.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/measurePersonCompleteness.Rmd)

`measurePersonCompleteness.Rmd`

## Summary

**Level** : TABLE  
**Context** : Validation  
**Category** : Completeness  
**Subcategory** :  
**Severity** : CDM convention ⚠ (for observation period), Characterization ✔ (for all other tables)

## Description

The number and percent of persons in the CDM that do not have at least one record in the @cdmTableName table.

## Definition

  * _Numerator_ : The number of persons with 0 rows in a given CDM table.
  * _Denominator_ : The total number of persons in the `PERSON` table.
  * _Related CDM Convention(s)_ : Each Person needs to have at least one `OBSERVATION_PERIOD` record. Otherwise, CDM conventions do not dictate any rules for person completeness.
  * _CDM Fields/Tables_ : By default, this check runs on all tables with a foreign key to the `PERSON` table.
  * _Default Threshold Value_ : 
    * 0% for `OBSERVATION_PERIOD`
    * 95% or 100% for other tables



## User Guidance

For most tables, this check is a characterization of the completeness of various data types in the source data. However, in the case of `OBSERVATION_PERIOD`, this check should actually be considered a CDM convention check as it is used to enforce the requirement that all persons have at least one observation period. A failure of this check on the `OBSERVATION_PERIOD` table is a serious issue as persons without an `OBSERVATION_PERIOD` cannot be included in any standard OHDSI analysis.

Run the following query to obtain a list of persons who had no data in a given table. From this list of person_ids you may join to other tables in the CDM to understand trends in these individuals’ data which may provide clues as to the root cause of the issue.

### Violated rows query
    
    
    SELECT 
        cdmTable.* 
    FROM @cdmDatabaseSchema.person cdmTable
        LEFT JOIN @schema.@cdmTableName cdmTable2 
            ON cdmTable.person_id = cdmTable2.person_id
    WHERE cdmTable2.person_id IS NULL

### ETL Developers

#### Observation period

All persons in the CDM must have an observation period; OHDSI analytics tools only operate on persons with observable time, as represented by one or more observation periods. Persons missing observation periods may represent a bug in the ETL code which generates observation periods. Alternatively, some persons may have no observable time in the source data. These persons should be removed from the CDM.

#### All other tables

Action on persons missing records in other clinical event tables will depend on the characteristics of the source database. In certain cases, missingness is expected – some persons may just not have a given type of data available in the source. For instance, in most data sources, one would expect most patients to have at least one visit, diagnosis, and drug, while one would _not_ expect every single patient to have had a medical device.

Various ETL issues may result in persons missing records in a given event table:

  * Mis-mapping of domains, resulting in the placement of records in the incorrect table  

  * Incorrect parsing of source data, resulting in loss of valid records
  * Failure of an ETL step, resulting in an empty table



If more persons than expected are missing data in a given table, run the violated rows SQL snippet to retrieve these persons’ person_ids, and inspect these persons’ other clinical event data in the CDM for trends. You may also use `person_source_value` to trace back to these persons’ source data to identify source data records potentially missed by the ETL.

### Data Users

Severe failures, such as unexpected nearly empty tables, must be fixed by the ETL team before a dataset can be used. Note as well that any person missing an observation period will not be able to be included in any analysis using OHDSI tools.

Failures with a result close to the specified failure threshold may be accepted, at your own risk and only if the result matches your understanding of the source data. The violated rows SQL may be used to inspect the full records for persons missing data in a given table in order to validate your expectations or point to potential issues in the ETL which need to be resolved.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
