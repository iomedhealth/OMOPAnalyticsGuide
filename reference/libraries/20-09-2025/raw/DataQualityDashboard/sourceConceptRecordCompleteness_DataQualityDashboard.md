# sourceConceptRecordCompleteness • DataQualityDashboard

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



# sourceConceptRecordCompleteness

#### Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/sourceConceptRecordCompleteness.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/sourceConceptRecordCompleteness.Rmd)

`sourceConceptRecordCompleteness.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Completeness  
**Subcategory** :  
**Severity** : CDM convention ⚠  


## Description

The number and percent of records with a value of 0 in the source concept field @cdmFieldName in the @cdmTableName table.

NB: In non-required fields, missing values are also counted as failures when a source value is available.

## Definition

  * _Numerator_ : The number of rows with a value of 0 in the `_source_concept_id` source concept field. For non-required fields, also includes rows where the `_source_concept_id` field is NULL and the corresponding `_source_value` field is not NULL.
  * _Denominator_ : The total number of rows in the table where the `_source_concept_id` field is not NULL or, for non-required fields, the corresponding `_source_value` field is not NULL.
  * _Related CDM Convention(s)_ : [Source concept mapping](https://ohdsi.github.io/CommonDataModel/dataModelConventions.html#Fields)
  * _CDM Fields/Tables_ : All source concept ID (`_source_concept_id`) columns in all event tables.
  * _Default Threshold Value_ : 
    * 10% for source concept ID columns in condition, drug, measurement, procedure, device, and observation tables
    * 100% for all other source concept ID columns



## User Guidance

Source concept mapping is an important part of the OMOP concept mapping process which allows data users insight into the provenance of the data they are analyzing. It’s important to populate the source concept ID field for all source values that exist in the OMOP vocabulary. Failures of this check should be well-understood and documented so that data users can plan accordingly in the case missing data might impact their analysis.

### ETL Developers

Recall that the `_source_concept_id` columns should contain the OMOP concept representing the exact code used in the source data for a given record: “If the <_source_value> is coded in the source data using an OMOP supported vocabulary put the concept id representing the source value here.”

A failure of this check usually indicates a failure to map a source value to an OMOP concept. In some cases, such a failure can and should be remediated in the concept-mapping step of the ETL. In other cases, it may represent a mapping that currently is not possible to implement.

To investigate the failure, run the following query:
    
    
    SELECT  
      concept.concept_name AS standard_concept_name, 
      cdmTable._concept_id, -- standard concept ID field for the table 
      c2.concept_name AS source_value_concept_name, 
      cdmTable._source_value, -- source value field for the table 
      COUNT(*) 
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable 
    LEFT JOIN @vocabDatabaseSchema.concept ON concept.concept_id = cdmTable._concept_id 
    -- WARNING this join may cause fanning if a source value exists in multiple vocabularies 
    LEFT JOIN @vocabDatabaseSchema.concept c2 ON concept.concept_code = cdmTable._source_value 
    AND c2.domain_id = <Domain of cdmTable> 
    WHERE cdmTable.@cdmFieldName = 0  
    GROUP BY 1,2,3 
    ORDER BY 4 DESC 

The query results will give you a summary of the source codes which failed to map to an OMOP concept. Inspecting this data should give you an initial idea of what might be going on.

If source values return legitimate matches on concept_code, it’s possible that there is an error in the concept mapping step of your ETL. Please note that while the `_source_concept_id` fields are technically not required, it is highly recommended to populate them with OMOP concepts whenever possible. This will greatly aid analysts in understanding the provenance of the data.

If source values do NOT return matches on concept_code and you are NOT handling concept mapping locally for a non-OMOP source vocabulary, then you likely have a malformed source code or one that does not exist in the OMOP vocabulary. Please see the documentation in the [standardConceptRecordCompleteness](standardConceptRecordCompleteness.html) page for instructions on how to handle this scenario.

### Data Users

Since most standard OHDSI analytic workflows rely on the standard concept field and not the source concept field, failures of this check will not necessarily impact your analysis. However, having the source concept will give you a better understanding of the provenance of the code and highlight potential issues where meaning is lost due to mapping to a standard concept.

Utilize the investigation queries above to understand the scope and impact of the mapping failures on your specific analytic use case. If none of the affected codes seem to be relevant for your analysis, it may be acceptable to ignore the failure. However, since it is not always possible to understand exactly what a given source value represents, you should proceed with caution and confirm any findings with your ETL provider if possible.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
