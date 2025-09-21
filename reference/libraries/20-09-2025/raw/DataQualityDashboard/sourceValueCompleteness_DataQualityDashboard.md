# sourceValueCompleteness • DataQualityDashboard

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



# sourceValueCompleteness

#### Jared Houghtaling, Clair Blacketer

#### 2025-08-27

Source: [`vignettes/checks/sourceValueCompleteness.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/sourceValueCompleteness.Rmd)

`sourceValueCompleteness.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Completeness  
**Subcategory** :  
**Severity** : CDM convention ⚠

## Description

The number and percent of distinct source values in the @cdmFieldName field of the @cdmTableName table mapped to 0.

## Definition

  * _Numerator_ : Distinct `_source_value` entries where the corresponding standard `_concept_id` field is 0.
  * _Denominator_ : Total distinct `_source_value` entries, including NULL, in the respective event table.
  * _Related CDM Convention(s)_ : The OMOP Common Data Model specifies that codes that are present in a native database should be mapped to standard concepts using either the intrinsic mappings defined in the standard vocabularies or extrinsic mappings defined by the data owner or ETL development team. Note also that variations of this check logic are also used in the [EHDEN CDM Inspection Report](https://github.com/EHDEN/CdmInspection) package, as well as the [AresIndexer](https://github.com/OHDSI/AresIndexer) package for generating indices of unmapped codes.  

  * _CDM Fields/Tables_ : Runs on all event tables that have `_source_value` fields.
  * _Default Threshold Value_ : 
    * 10% for `_source_value` fields in condition, measurement, procedure, drug, visit.
    * 100% for all other fields



## User Guidance

This check will look at all distinct source values in the specified field and calculate how many are mapped to a standard concept of 0. This check should be used in conjunction with the [standardConceptRecordCompleteness](standardConceptRecordCompleteness.html) check to identify potential mapping issues in the ETL.  


This check is a good measure of the overall mapping rate within each domain. For example, a table may have high standardConceptRecordCompleteness (that is, a large percentage of records with a non-zero standard concept) but a low score on this check. This would indicate that the “long tail” of rarer codes have not been mapped while more common codes have good mapping coverage. It is always important to interrogate the results of these two checks together to ensure complete understanding of vocabulary mapping in your CDM.

The following SQL can be used to summarize unmapped source values by record count in a given CDM table:

### Violated rows query
    
    
    SELECT DISTINCT 
      cdmTable.@cdmFieldName,
      COUNT(*)
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable
    WHERE cdmTable.@standardConceptFieldName = 0
    GROUP BY 1
    ORDER BY 2 DESC

### ETL Developers

Fails of this check are (most often) related directly to semantic mapping. First, the ETL developer should investigate if a source vocabulary is present in the native data that was not accounted for in the ETL document and/or code. This is most likely if the unmapped source values are codes rather than text values. Second, the source-to-concept-map file or table should be updated to link the unmapped source values with domain-appropriate concepts.

### Data Users

When this check fails, source data granularity is being lost; not all of the information related to a particular event or modifier is being captured in OMOP CDM format. Although the information about an event may exist in the source value field, it cannot easily be used in downstream analytics processes that rely on standard OMOP concepts.

**Please see the[standardConceptRecordCompleteness](standardConceptRecordCompleteness.html) page for a much more detailed overview of handling mapping quality issues in your OMOP CDM.**

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
