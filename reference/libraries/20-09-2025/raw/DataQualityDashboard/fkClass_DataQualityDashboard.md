# fkClass • DataQualityDashboard

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



# fkClass

#### Clair Blacketer, Katy Sadowski

#### 2025-08-27

Source: [`vignettes/checks/fkClass.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/fkClass.Rmd)

`fkClass.Rmd`

## Summary

**Level** : Field check  
**Context** : Verification  
**Category** : Conformance  
**Subcategory** : Computational  
**Severity** : CDM convention ⚠  


## Description

The number and percent of records that have a value in the **cdmFieldName** field in the **cdmTableName** table that do not conform to the **fkClass** class.

## Definition

There is the occasional field in the OMOP CDM that expects not only concepts of a certain domain, but of a certain concept class as well. The best example is the `drug_concept_id` field in the `DRUG_ERA` table. Drug eras represent the span of time a person was exposed to a particular drug _ingredient_ , so all concepts in `DRUG_ERA.drug_concept_id` must be of the drug domain and ingredient class.

  * _Numerator_ : The number of rows in the table where the standard concept ID field contains a concept that does not conform to the specified concept_class_id. This numerator specifically excludes concept_id 0
  * _Denominator_ : The total number of rows in the specified cdm table. This denominator includes rows with concept_id 0
  * _Related CDM Convention(s)_ : This check is specific to [DRUG_ERA](http://ohdsi.github.io/CommonDataModel/cdm54.html#DRUG_ERA) and [DOSE_ERA](http://ohdsi.github.io/CommonDataModel/cdm54.html#DOSE_ERA) as the `drug_concept_id`s in these tables must be ingredients, which are denoted by the concept class ‘ingredient’
  * _CDM Fields/Tables_ : This check is designed to be run on the `drug_concept_id` field in the DRUG_ERA and DOSE_ERA tables
  * _Default Threshold Value_ : 0%



## User Guidance

This check identifies whether records with the correct concepts were written to the correct tables as derived from drug_exposure. If incorrect concepts are allowed to persist, a study package could run on the DRUG_ERA and DOSE_ERA tables but may not produce expected results.

### Violated rows query

You may inspect the violating rows using the following query:
    
    
    -- @cdmTableName.@cdmFieldName is either drug_era.drug_concept_id or dose_era.drug_concept_id
    
    SELECT 
      '@cdmTableName.@cdmFieldName' AS violating_field, 
      co.concept_class_id AS violating_class,
        cdmTable.* 
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable
        LEFT JOIN @vocabDatabaseSchema.concept co ON cdmTable.@cdmFieldName = co.concept_id
    WHERE co.concept_id != 0 
      AND (co.concept_class_id != 'ingredient') 

### ETL Developers

Recommended actions:

  * Identify the specific concepts in the table that have an incorrect concept_class_id
  * Investigate the ETL process that builds the specified era tables. Likely there is an error that is letting records through with the incorrect concept_class_id
  * Ultimately the ETL code should be fixed so that the correct concepts are identified, or the offending records should be removed



### Data Users

Few options are available to correct this error without amending the ETL code that populated your OMOP CDM. If this check is failing it means that there is likely an error in the ETL process that builds the era tables. The DRUG_ERA table is used often in network studies and is meant to identify periods of time where a person is exposed to a specific drug ingredient, allowing for up to 30 days between exposures. If there are records in the DRUG_ERA tables that are not mapped to their ingredient-level ancestor then cohorts and analyses that make use of the DRUG_ERA table will run but they will return unexpected or erroneous results. You may consider dropping the offending rows if you know that they are not needed for analysis, but do so at your own risk.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
