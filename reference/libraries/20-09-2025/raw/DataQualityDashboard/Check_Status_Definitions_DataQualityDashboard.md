# Check Status Definitions • DataQualityDashboard

Toggle navigation [DataQualityDashboard](../index.html) 2.7.0

  * [ ](../index.html)
  * [Get started](../articles/DataQualityDashboard.html)
  * [Reference](../reference/index.html)
  * Articles 
    * [DQ Check Failure Thresholds](../articles/Thresholds.html)
    * [DQ Check Statuses](../articles/CheckStatusDefinitions.html)
    * [Adding a New Data Quality Check](../articles/AddNewCheck.html)
    * [DQD for Cohorts](../articles/DqdForCohorts.html)
    * [SQL-only Mode](../articles/SqlOnly.html)
  * Data Quality Check Types 
    * [Index](../articles/checkIndex.html)
    * [cdmTable](../articles/checks/cdmTable.html)
    * [cdmField](../articles/checks/cdmField.html)
    * [cdmDatatype](../articles/checks/cdmDatatype.html)
    * [isPrimaryKey](../articles/checks/isPrimaryKey.html)
    * [isForeignKey](../articles/checks/isForeignKey.html)
    * [isRequired](../articles/checks/isRequired.html)
    * [fkDomain](../articles/checks/fkDomain.html)
    * [fkClass](../articles/checks/fkClass.html)
    * [measurePersonCompleteness](../articles/checks/measurePersonCompleteness.html)
    * [measureValueCompleteness](../articles/checks/measureValueCompleteness.html)
    * [isStandardValidConcept](../articles/checks/isStandardValidConcept.html)
    * [standardConceptRecordCompleteness](../articles/checks/standardConceptRecordCompleteness.html)
    * [sourceConceptRecordCompleteness](../articles/checks/sourceConceptRecordCompleteness.html)
    * [sourceValueCompleteness](../articles/checks/sourceValueCompleteness.html)
    * [plausibleAfterBirth](../articles/checks/plausibleAfterBirth.html)
    * [plausibleBeforeDeath](../articles/checks/plausibleBeforeDeath.html)
    * [plausibleStartBeforeEnd](../articles/checks/plausibleStartBeforeEnd.html)
    * [plausibleValueHigh](../articles/checks/plausibleValueHigh.html)
    * [plausibleValueLow](../articles/checks/plausibleValueLow.html)
    * [withinVisitDates](../articles/checks/withinVisitDates.html)
    * [measureConditionEraCompleteness](../articles/checks/measureConditionEraCompleteness.html)
    * [measureObservationPeriodOverlap](../articles/checks/measureObservationPeriodOverlap.html)
    * [plausibleUnitConceptIds](../articles/checks/plausibleUnitConceptIds.html)
    * [plausibleGenderUseDescendants](../articles/checks/plausibleGenderUseDescendants.html)
  * [Changelog](../news/index.html)


  * [![](https://ohdsi.github.io/Hades/images/hadesMini.png)](https://ohdsi.github.io/Hades)
  * [ ](https://github.com/OHDSI/DataQualityDashboard/)



# Check Status Definitions

#### Dmitry Ilyn, Maxim Moinat

#### 2025-08-27

Source: [`vignettes/CheckStatusDefinitions.rmd`](https://github.com/OHDSI/DataQualityDashboard/blob/HEAD/vignettes/CheckStatusDefinitions.rmd)

`CheckStatusDefinitions.rmd`

## Introduction

In the DataQualityDashboard v2, new check statuses were introduced: `Error` and `Not Applicable`. These were introduced to more accurately reflect the quality of data contained in a CDM instance, addressing scenarios where pass/fail is not appropriate. The new set of mutually exclusive status states are listed below in priority order:

  * **Is Error:** if a SQL error occurred during execution

  * **Not Applicable:** if DQ check is not applicable for reasons explained in the section below

  * **Failed:** if percent violating rows is greater than the threshold

  * **Passed:** if percent violating rows is smaller than the threshold




## Not Applicable

The results of a DQ check may not be applicable to a given CDM instance depending on the implementation and content of the instance. For example, the DQ check for plausible values of HbA1c lab results would pass with no violations even if there were no results for that lab test in the database. It is not uncommon to have > 1000 DQ checks that do not apply to a given CDM instance. The results from DQ checks that are not applicable skew to overall results. Listed below are the scenarios for which a DQ check result is flagged as notApplicable:

  1. If the cdmTable DQ check determines that a table does not exist in the database, then all DQ checks (except cdm_table) addressing that table are flagged as notApplicable

  2. If a table exists but is empty, then all field level and concept level checks for that table are flagged as notApplicable, except for cdmField checks, which evaluates if the field is defined or not. A cdmField check is marked as notApplicable if the CDM table it refers to does not exist (tested by cdmTable). An empty table is detected when the measureValueCompleteness DQ check for any of the fields in the table returns a denominator count = 0 (numDenominatorRows=0).

  3. If a field is not populated, then all field level and concept level checks except for measureValueCompleteness and isRequired are flagged as notApplicable

     1. A field is not populated if the measureValueCompleteness DQ check finds denominator count > 0 and number of violated rows = denominator count (numDenominatorRows > 0 AND numDenominatorRows = numViolatedRows).

     2. The measureValueCompleteness check is marked as not applicable if:

        1. The CDM table it refers to does not exist or is empty.

        2. The CDM field it refers to does not exist.

     3. The isRequired check is marked as not applicable if:

        1. The CDM table it refers to does not exist or is empty.

        2. The CDM field it refers to does not exist.

  4. Flagging a Concept_ID level DQ check as notApplicable depends on whether the DQ check logic includes a UNIT_CONCEPT_ID. There are two scenarios for DQ checks evaluating specific Concept_ids.

     1. The DQ check does not include a UNIT_CONCEPT_ID (value is null). A DQ check is flagged as notApplicable if there are no instances of the Concept_ID in the table/field. E.g. plausibility checks for specific conditions and gender. Both pregnancy and male do not have UNIT_CONCEPT_IDs.

     2. The DQ check includes a UNIT_CONCEPT_ID. A DQ check is flagged as notApplicable if there are no instances of both concept and unit concept IDs in the table/field. E.g. all DQ checks referencing the concept_ID for HbA1c lab results expressed in mg/dl units will be flagged as notApplicable if there are no instances of that concept_ID in the table/field addressed by the DQ check.




Developed by Katy Sadowski, Clair Blacketer, Maxim Moinat, Ajit Londhe, Anthony Sena, Anthony Molinaro, Frank DeFalco, Pavel Grafkin.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
