# plausibleGenderUseDescendants • DataQualityDashboard

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



# plausibleGenderUseDescendants

#### Katy Sadowski and Dmytry Dymshyts

#### 2025-08-27

Source: [`vignettes/checks/plausibleGenderUseDescendants.Rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/checks/plausibleGenderUseDescendants.Rmd)

`plausibleGenderUseDescendants.Rmd`

## Summary

**Level** : CONCEPT  
**Context** : Validation  
**Category** : Plausibility  
**Subcategory** : Atemporal  
**Severity** : Characterization ✔

## Description

For descendants of CONCEPT_ID conceptId (conceptName), the number and percent of records associated with patients with an implausible gender (correct gender = plausibleGenderUseDescendants).

## Definition

This check will count the number of records for which the person’s gender is implausible given the concept for the record. For a given gender-specific concept (e.g., prostate cancer) and its descendants, the check will identify records for which the associated person has an implausible gender (e.g., a female with prostate cancer). There are currently 4 instances of this check - female condition concepts; male condition concepts; female procedure concepts; and male procedure concepts.

  * _Numerator_ : The number of rows with a gender-specific concept whose associated person has an implausible gender.
  * _Denominator_ : The number of rows with a gender-specific concept.
  * _Related CDM Convention(s)_ : <https://ohdsi.github.io/Themis/populate_gender_concept_id.html>
  * _CDM Fields/Tables_ : `CONDITION_OCURRENCE`, `PROCEDURE_OCCURRENCE`
  * _Default Threshold Value_ : 5%



## User Guidance

A failure of this check indicates one of the following scenarios:

  * The person’s gender is wrong
  * The gender-specific concept is wrong
  * The person changed genders and the concept was plausible at the time it was recorded



### Violated rows query
    
    
    SELECT
      cdmTable.@cdmFieldName,
      cdmTable.@sourceConceptIdField, -- x_source_concept_id for the table of interest (condition_occurrence or procedure_occurrence)
      cdmTable.@sourceValueField, -- x_source_value for the table of interest
      COUNT(*)
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable
      JOIN @cdmDatabaseSchema.person p ON cdmTable.person_id = p.person_id
      JOIN @vocabDatabaseSchema.concept_ancestor ca ON ca.descendant_concept_id = cdmTable.@cdmFieldName
    WHERE ca.ancestor_concept_id IN (@conceptId)
      AND p.gender_concept_id <> {@plausibleGenderUseDescendants == 'Male'} ? {8507} : {8532} 
    GROUP BY 1,2,3

The above query should help to identify if a mapping issue is the cause of the failure. If the source value and source concept ID are correctly mapped to a standard concept, then the issue may be that the person has the incorrect gender, or that the finding is a true data anomaly. Examples of true anomalies include:

  * Occasional stray code (e.g., due to typo in EHR).
  * Newborn codes recorded in the mother’s record (e.g., circumcision).
  * Gender reassignment procedures (e.g., penectomy and prostatectomy in patients with acquired female gender). **NOTE** that this scenario is technically a violation of the OMOP CDM specification, since the CDM requires that the `gender_concept_id` represents a person’s sex at birth. For more information on this convention, see <https://ohdsi.github.io/Themis/populate_gender_concept_id.html>



### ETL Developers

Concept mapping issues must be fixed. Ensure as well that source codes are being correctly extracted from the source data. If the CDM accurately represents the source data, then remaining failures should be documented for users of the CDM.

### Data Users

Persons with implausible gender should not be included in analysis _unless_ it can be confirmed with the data provider that these represent cases of gender reassignment, and your analysis does not assume that the `gender_concept_id` represents sex at birth.

Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
