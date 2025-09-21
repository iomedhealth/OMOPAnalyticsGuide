# isStandardValidConcept • DataQualityDashboard

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



# isStandardValidConcept

#### Stephanie Hong, Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/isStandardValidConcept.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/isStandardValidConcept.Rmd)

`isStandardValidConcept.Rmd`

## Summary

**Level** : FIELD  
**Context** : Verification  
**Category** : Conformance  
**Subcategory** : Value  
**Severity** : CDM convention ⚠  


## Description

The number and percent of records that do not have a standard, valid concept in the @cdmFieldName field in the @cdmTableName table.

## Definition

  * _Numerator_ : The number of rows with an `_concept_id` that exists in `CONCEPT.concept_id` but does not equal zero, and has `CONCEPT.standard_concept` != ‘S’ or non-NULL `CONCEPT.invalid_reason`.
  * _Denominator_ : The total number of rows in the table with a non-NULL `_concept_id`.
  * _Related CDM Convention(s)_ : All `_concept_id` columns should contain a standard, valid concept, or 0: <https://ohdsi.github.io/CommonDataModel/dataModelConventions.html#Mapping>.
  * _CDM Fields/Tables_ : All standard concept ID (`_concept_id`) columns in all event tables.
  * _Default Threshold Value_ : 0%



## User Guidance

Failures of this check represent a violation of the fundamental CDM convention requiring all concept IDs to belong to the OMOP standard vocabulary. This is an essential convention in enabling standard analytics. If source codes have not been properly mapped to OMOP standard concepts in a CDM, studies designed using the OMOP standard vocabulary will return inaccurate results for that database.

### ETL Developers

A failure of this check indicates an issue with the concept mapping portion of your ETL, and must be resolved. Ensure that your ETL is only mapping source codes to standard, valid concepts (via the ‘Maps to’ relationship). Note as well that if no standard concept mapping exists for a source code, you MUST populate its `_concept_id` column with 0. See the Book of OHDSI for additional guidance on the concept mapping process: <https://ohdsi.github.io/TheBookOfOhdsi/ExtractTransformLoad.html#step-2-create-the-code-mappings>

You may inspect the failing rows using the following SQL:
    
    
    SELECT  
      '@cdmTableName.@cdmFieldName' AS violating_field,  
      cdmTable.*,
      co.*
    FROM @schema.@cdmTableName cdmTable 
      JOIN @vocabDatabaseSchema.concept co ON cdmTable.@cdmFieldName = co.concept_id 
    WHERE co.concept_id != 0  
      AND (co.standard_concept != 'S' OR co.invalid_reason IS NOT NULL) 

You may build upon this query by joining the `_source_concept_id` column to the concept table and inspecting the source concepts from which the failing non-standard concepts were mapped. If the `_source_concept_id` correctly represents the source code in `_source_value`, the fix will be a matter of ensuring your ETL is correctly using the concept_relationship table to map the source concept ID to a standard concept via the ‘Maps to’ relationship. If you are not populating the `_source_concept_id` column and/or are using an intermediate concept mapping table, you may need to inspect the mappings in your mapper table to ensure they’ve been generated correctly using the ‘Maps to’ relationship for your CDM’s vocabulary version.

Also note that when updating the OMOP vocabularies, previously standard concepts could have been become non-standard and need remapping. Often this remapping can be done programmatically, by following the ‘Maps to’ relationship to the new standard concept.

### Data Users

This check failure means that the failing rows will not be picked up in a standard OHDSI analysis. Especially when participating in network research, where only standard concepts are used, this might result in invalid results. It is highly recommended to work with your ETL team or data provider, if possible, to resolve this issue.

However, you may work around it at your own risk by determining whether or not the affected rows are relevant for your analysis. Here’s an example query you could run to inspect failing rows in the condition_occurrence table:
    
    
    SELECT  
      condition_concept_id AS violating_concept, 
      c1.concept_name AS violating_concept_name, 
      condition_source_concept_id AS source_concept, 
      c2.concept_name AS source_concept_name, 
      c2.vocabulary_id AS source_vocab, 
      condition_source_value, 
      COUNT(*) 
    FROM @cdmDatabaseSchema.condition_occurrence 
      JOIN @vocabDatabaseSchema.concept c1 ON condition_occurrence.condition_concept_id = c1.concept_id 
      LEFT JOIN @vocabDatabaseSchema.concept c2 ON condition_occurrence.condition_source_concept_id = c2.concept_id 
    WHERE c1.concept_id != 0  
      AND (c1.standard_concept != 'S' OR c1.invalid_reason IS NOT NULL) 
    GROUP BY 1,2,3,4,5,6 
    ORDER BY 7 DESC 

If you can confirm by inspecting the source concept and/or source value that the affected rows are not relevant for your analysis, you can proceed with your work and ignore the issue. However, especially if a large number of rows are impacted it’s recommended to act upon these failures as there could potentially be deeper issues with the ETL concept mapping process that need to be fixed.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
