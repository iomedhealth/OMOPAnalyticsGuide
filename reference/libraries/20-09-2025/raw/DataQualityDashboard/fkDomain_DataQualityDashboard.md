# fkDomain • DataQualityDashboard

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



# fkDomain

#### Clair Blacketer, Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/fkDomain.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/fkDomain.Rmd)

`fkDomain.Rmd`

## Summary

**Level** : Field check  
**Context** : Verification  
**Category** : Conformance  
**Subcategory** : Value  
**Severity** : CDM convention ⚠  


## Description

The number and percent of records that have a value in the **cdmFieldName** field in the **cdmTableName** table that do not conform to the **fkDomain** domain.

## Definition

It is often the case that standard concept fields in the OMOP CDM should belong to a certain domain. All possible domains are listed in the vocabulary table DOMAIN and the expected domain for CDM fields are listed as part of the CDM documentation. For example, all concepts in the field PERSON.gender_concept_id should conform to the [_gender_ domain](http://athena.ohdsi.org/search-terms/terms?standardConcept=Standard&domain=Gender&page=1&pageSize=15&query=).

  * _Numerator_ : The number of rows in the table where the standard concept ID field contains a concept that does not conform to the specified `domain_id`. This numerator specifically excludes concept_id 0
  * _Denominator_ : The total number of rows in the table. This denominator includes rows with concept_id 0
  * _Related CDM Convention(s)_ : FK Domain flag in [CDM table specs](https://ohdsi.github.io/CommonDataModel/index.html)
  * _CDM Fields/Tables_ : This check runs on all standard concept ID fields (e.g. `condition_concept_id`; `gender_concept_id`; etc.)
  * _Default Threshold Value_ : 0%



## User Guidance

OHDSI tools and analyses assume that standard concepts in event tables and demographic data conform to the relevant domain. If incorrect concepts are allowed to persist, a study package could run on this table but may not produce expected results.

To assess the impacted rows/tables, you may run a query like the one below:

### Violated rows query
    
    
    -- @cdmTableName.@cdmFieldName is the standard concept ID field in the table
    -- @cdmTableName.@cdmTablePk is the primary key field in the table
    
    SELECT 
      concept.concept_id, 
      concept.domain_id, 
      concept.concept_name, 
      concept.concept_code, 
      COUNT(DISTINCT @cdmTableName.@cdmTablePk), 
      COUNT(DISTINCT @cdmTableName.person_id) 
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable 
      LEFT JOIN @vocabSchema.concept on @cdmTableName.@cdmFieldName = concept.concept_id   
        AND concept.domain_id != {fkDomain} AND concept.concept_id != 0 
    GROUP BY concept.concept_id, concept.domain_id, concept.concept_name, concept.concept_code

### ETL Developers

Recommended actions: - Identify the specific concepts in the table that have an incorrect `domain_id` \- Investigate the ETL process that moves records to the tables based on the standard concept ID domain. Likely there is an error that is letting records through with the incorrect `domain_id` \- Ultimately the ETL process should be improved so that the correct rows are moved to the correct tables based on their domain

### Data Users

If this check is failing it means that there is likely an error in the ETL process that builds the domain tables. If there are records in a table with standard concepts in the wrong domain then cohorts and analyses will run but they will return unexpected or erroneous results.

You may characterize the potential impact of the erroneous domain sorting on your analysis by running a query like the one above. Use the results to see what concepts in a table were incorrectly sorted, and how many events/patients are impacted.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
