# Changelog • CodelistGenerator

Skip to contents

[CodelistGenerator](../index.html) 3.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Getting the OMOP CDM vocabularies](../articles/a01_GettingOmopCdmVocabularies.html)
    * [Exploring the OMOP CDM vocabulary tables](../articles/a02_ExploreCDMvocabulary.html)
    * [Generate a candidate codelist](../articles/a03_GenerateCandidateCodelist.html)
    * [Generating vocabulary based codelists for medications](../articles/a04_GenerateVocabularyBasedCodelist.html)
    * [Generating vocabulary based codelists for conditions](../articles/a04b_icd_codes.html)
    * [Extract codelists from JSON files](../articles/a05_ExtractCodelistFromJSONfile.html)
    * [Compare, subset or stratify codelists](../articles/a06_CreateSubsetsFromCodelist.html)
    * [Codelist diagnostics](../articles/a07_RunCodelistDiagnostics.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Changelog

## CodelistGenerator 3.0

CRAN release: 2024-05-31

  * Add function getRelationshipId
  * Add functions summariseAchillesCodeUse (replaces achillesCodeUse), summariseOrphanCodes (replaces findOrphanCodes), tableAchillesCodeUse, tableCodeUse, tableCohortCodeUse, tableOrphanCodes.



## CodelistGenerator 2.2.3

CRAN release: 2024-03-08

  * Fix for forthcoming breaking change in dependency omopgenerics



## CodelistGenerator 2.2.2

CRAN release: 2024-02-14

  * Fix for edge case with multiple exclusion criteria



## CodelistGenerator 2.2.1

CRAN release: 2024-02-07

  * Working with omopgenerics



## CodelistGenerator 2.2.0

CRAN release: 2024-01-25

  * Added functions findOrphanCodes, restrictToCodesInUse, sourceCodesInUse.
  * Speed improvements in getCandidateCodes from doing search in place (e.g. on database side).
  * Dropped explicit support of an Arrow cdm.



## CodelistGenerator 2.1.1

CRAN release: 2023-11-20

  * Improved support of device domain.



## CodelistGenerator 2.0.0

CRAN release: 2023-10-09

  * Simplified the interface of getCandidateCodes, with a number of arguments removed.
  * Added function summariseCohortCodeUse.



## CodelistGenerator 1.7.0

CRAN release: 2023-08-16

  * Added function codesFromCohort.



## CodelistGenerator 1.6.0

CRAN release: 2023-07-07

  * Improved getICD10StandardCodes function.
  * Added function codesFromConceptSet.



## CodelistGenerator 1.5.0

CRAN release: 2023-06-13

  * Require CDMConnector v1.0.0 or above.



## CodelistGenerator 1.4.0

CRAN release: 2023-06-06

  * Added function summariseCodeUse.



## CodelistGenerator 1.3.0

CRAN release: 2023-05-30

  * Added function getICD10StandardCodes.



## CodelistGenerator 1.2.0

CRAN release: 2023-05-04

  * Added functions getATCCodes and getDrugIngredientCodes.



## CodelistGenerator 1.1.0

CRAN release: 2023-04-01

  * Added exactMatch and includeSequela options to getCandidateCodes function.



## CodelistGenerator 1.0.0

CRAN release: 2023-02-07

  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
