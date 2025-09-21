# measureConditionEraCompleteness • DataQualityDashboard

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



# measureConditionEraCompleteness

#### Maxim Moinat

#### 2025-08-27

Source: [`vignettes/checks/measureConditionEraCompleteness.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/measureConditionEraCompleteness.Rmd)

`measureConditionEraCompleteness.Rmd`

## Summary

**Level** : TABLE  
**Context** : Validation  
**Category** : Completeness  
**Subcategory** :  
**Severity** : CDM convention ⚠

## Description

The number and percent of persons that does not have condition_era built successfully, for all persons in `CONDITION_OCCURRENCE` with a non-zero `condition_concept_id`.

## Definition

  * _Numerator_ : Number of unique person_ids that exist in the `CONDITION_OCCURRENCE` table but not in the `CONDITION_ERA` table, excluding persons whose only condition records have `condition_concept_id = 0`.
  * _Denominator_ : Number of unique person_ids in the `CONDITION_OCCURRENCE` table with at least one condition record with a non-zero `condition_concept_id`.
  * _Related CDM Convention(s)_ : Condition Era’s are directly derived from Condition Occurrence.
  * _CDM Fields/Tables_ : `CONDITION_ERA`
  * _Default Threshold Value_ : 0%



## User Guidance

The [Condition Era CDM documentation](https://ohdsi.github.io/CommonDataModel/cdm54.html#condition_era) states that the condition era’s should be derived by combining condition occurrences. This implies that each person with a condition occurrence should have at least a condition era. It does NOT clearly state that the `CONDITION_ERA` table is required when there are condition occurrences. Still, it is has always been a common convention in the OHDSI community to derive condition era. There is currently no THEMIS convention on condition eras.

**Note** : This check excludes condition records where `condition_concept_id = 0` from both numerator and denominator calculations, as it is acceptable that condition eras are not built for these records.

### Violated rows query
    
    
    SELECT DISTINCT 
      co.person_id
    FROM @cdmDatabaseSchema.condition_occurrence co
      LEFT JOIN @cdmDatabaseSchema.condition_era cdmTable 
        ON co.person_id = cdmTable.person_id
    WHERE cdmTable.person_id IS NULL
      AND co.condition_concept_id != 0

### ETL Developers

If this check fails, it is likely that there is an issue with the condition era derivation script. Please review the ETL execution log. It might be that this script was not executed and the condition era table is empty, or it had issues running and the condition era table has been partially populated. If no issues with the ETL run found, the condition era derivation script might have bugs. Please review the code. An example script can be found on [the CDM Documentation page](https://ohdsi.github.io/CommonDataModel/sqlScripts.html#Condition_Eras). In both cases it is advised to truncate the `CONDITION_ERA` table and rerun the derivation script.

### Data Users

The `CONDITION_ERA` table might seem to contain redundant information, as for most uses the `CONDITION_OCCURRENCE` table can be used. However, tools like FeatureExtraction use condition eras to build some covariates and network studies might use cohorts that are based on condition eras. It is therefore important that the `CONDITION_ERA` table is fully populated and captures the same persons as in condition occurrence.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
