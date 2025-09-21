# isForeignKey • DataQualityDashboard

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



# isForeignKey

#### Dmytry Dymshyts, Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/isForeignKey.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/isForeignKey.Rmd)

`isForeignKey.Rmd`

## Summary

**Level** : Field check  
**Context** : Verification  
**Category** : Conformance  
**Subcategory** : Relational  
**Severity** : Fatal 💀  


## Description

The number and percent of records that have a value in the **cdmFieldName** field in the **cdmTableName** table that does not exist in the **fkTableName** table.

## Definition

This check will make sure that all foreign keys as specified in the CDM version have a value in the related primary key field. While this issue should generally be prevented by foreign key database constraints, some database management systems such as Redshift do not enforce such constraints.

  * _Numerator_ : The number of non-null values in the foreign key column that do not exist in its corresponding primary key column
  * _Denominator_ : The total number of records in the table
  * _Related CDM Convention(s)_ : Foreign Key flag in [CDM table specs](https://ohdsi.github.io/CommonDataModel/index.html)
  * _CDM Fields/Tables_ : By default, this check runs on foreign key columns in the CDM
  * _Default Threshold Value_ : 0%



## User Guidance

This check failure must be resolved. Failures in various fields could impact analysis in many different ways, for example:

  * If some important event or qualifier (for example, type concept) is encoded by a non-existent concept, it can’t be included in a concept set or be a part of cohort definition or feature
  * If an event is linked to a non-existent person, it can’t be included in any cohort definition or analysis
  * If an event is linked to a non-existent visit, it will be missed in visit-level cohort definition logic



Many CDM columns are foreign keys to the `concept_id` column in the `CONCEPT` table. See below for suggested investigation steps for concept ID-related foreign key check failures:

  * An `_concept_id` missing from the CONCEPT table might be the result of an error in `SOURCE_TO_CONCEPT_MAP`; you may check it this way:



### Violated rows query
    
    
    SELECT *
    FROM @vocabSchema.source_to_concept_map 
      LEFT JOIN @vocabSchema.concept ON concept.concept_id = source_to_concept_map.target_concept_id
    WHERE concept.concept_id IS NULL;

  * Other types of concept-related errors can be investigated by inspecting the source values for impacted rows as follows:


    
    
    -- @cdmTableName.@cdmFieldName is the _concept_id or _source_concept_id field in a CDM table
    -- Inspect the contents of the _source_value field to investigate the source of the error
    
    SELECT 
      '@cdmTableName.@cdmFieldName' AS violating_field,  
      cdmTable.*,
      COUNT(*) OVER(PARTITION BY '@cdmTableName.@cdmFieldName') AS num_violations_per_concept
    FROM @cdmSchema.@cdmTableName  
      LEFT JOIN @vocabSchema.concept on @cdmTableName.@cdmFieldName = concept.concept_id  
    WHERE concept.concept_id IS NULL
    ORDER BY num_violations_per_concept DESC; 

  * 2-billion concepts are a common source of foreign key issues; for example, a check failure may arise if these concepts are used in some tables but not fully represented in all relevant vocabulary tables (CONCEPT, CONCEPT_RELATIONSHIP, etc.)
  * Similarly, make sure to check any hard-coded concept mappings in the ETL as a potential source of the issue



When an entry is missing from one of the other CDM tables (LOCATION, PERSON, PROVIDER, VISIT_DETAIL, VISIT_OCCURRENCE, PAYER_PLAN_PERIOD, NOTE, CARE_SITE, EPISODE), this likely originates from binding / key generation errors in the ETL.

### ETL Developers

As above, mapping or binding logic needs to be amended in your ETL in order to resolve this error.

### Data Users

Few options are available to correct this error without amending the ETL code that populated your OMOP CDM. If a limited proportion of rows are impacted, you could consider dropping them from your database; however, do so at your own risk and only if you are confident that doing so will not have a significant impact on the downstream use cases of your CDM. A less aggressive approach could be to retain the affected rows and document the scope of their impact (in order to resolve the check failure, nullable values can be set to NULL and non-nullable concept ID values to 0). However, it is strongly recommended to pursue resolution further upstream in the ETL.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
