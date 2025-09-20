# Package index • CodelistGenerator

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

# Package index

### Search for codes following a systematic search strategy

`[getCandidateCodes()](getCandidateCodes.html)`
    Generate a candidate codelist

### Create vocabulary-based codelists

`[getDrugIngredientCodes()](getDrugIngredientCodes.html)`
    Get descendant codes of drug ingredients

`[getATCCodes()](getATCCodes.html)`
    Get the descendant codes of Anatomical Therapeutic Chemical (ATC) classification codes

`[getICD10StandardCodes()](getICD10StandardCodes.html)`
    Get corresponding standard codes for International Classification of Diseases (ICD) 10 codes

### Run codelist diagnostics

`[summariseAchillesCodeUse()](summariseAchillesCodeUse.html)`
    Summarise code use from achilles counts.

`[summariseCodeUse()](summariseCodeUse.html)`
    Summarise code use in patient-level data.

`[summariseCohortCodeUse()](summariseCohortCodeUse.html)`
    Summarise code use among a cohort in the cdm reference

`[summariseOrphanCodes()](summariseOrphanCodes.html)`
    Find orphan codes related to a codelist using achilles counts and, if available, PHOEBE concept recommendations

`[summariseUnmappedCodes()](summariseUnmappedCodes.html)`
    Find unmapped concepts related to codelist

### Present codelist diagnostics results in a table

`[tableAchillesCodeUse()](tableAchillesCodeUse.html)`
    Format the result of summariseAchillesCodeUse into a table

`[tableCodeUse()](tableCodeUse.html)`
    Format the result of summariseCodeUse into a table.

`[tableCohortCodeUse()](tableCohortCodeUse.html)`
    Format the result of summariseCohortCodeUse into a table.

`[tableOrphanCodes()](tableOrphanCodes.html)`
    Format the result of summariseOrphanCodes into a table

`[tableUnmappedCodes()](tableUnmappedCodes.html)`
    Format the result of summariseUnmappedCodeUse into a table

### Extract codelists from JSON files

`[codesFromCohort()](codesFromCohort.html)`
    Get concept ids from JSON files containing cohort definitions

`[codesFromConceptSet()](codesFromConceptSet.html)`
    Get concept ids from JSON files containing concept sets

### Codelist utility functions

`[compareCodelists()](compareCodelists.html)`
    Compare overlap between two sets of codes

`[subsetToCodesInUse()](subsetToCodesInUse.html)`
    Filter a codelist to keep only the codes being used in patient records

`[subsetOnRouteCategory()](subsetOnRouteCategory.html)`
    Subset a codelist to only those with a particular route category

`[subsetOnDoseUnit()](subsetOnDoseUnit.html)`
    Subset a codelist to only those with a particular dose unit.

`[subsetOnDomain()](subsetOnDomain.html)`
    Subset a codelist to only those codes from a particular domain.

`[stratifyByRouteCategory()](stratifyByRouteCategory.html)`
    Stratify a codelist by route category.

`[stratifyByDoseUnit()](stratifyByDoseUnit.html)`
    Stratify a codelist by dose unit.

`[stratifyByConcept()](stratifyByConcept.html)`
    Stratify a codelist by the concepts included within it.

`[getMappings()](getMappings.html)`
    Show mappings from non-standard vocabularies to standard.

### Vocabulary utility functions

`[getVocabVersion()](getVocabVersion.html)`
    Get the version of the vocabulary used in the cdm

`[getVocabularies()](getVocabularies.html)`
    Get the vocabularies available in the cdm

`[getConceptClassId()](getConceptClassId.html)`
    Get the concept classes used in a given set of domains

`[getDomains()](getDomains.html)`
    Get the domains available in the cdm

`[getDescendants()](getDescendants.html)`
    Get descendant codes for a given concept

`[getDoseForm()](getDoseForm.html)`
    Get the dose forms available for drug concepts

`[getRouteCategories()](getRouteCategories.html)`
    Get available drug routes

`[getDoseUnit()](getDoseUnit.html)`
    Get available dose units

`[getRelationshipId()](getRelationshipId.html)`
    Get available relationships between concepts

`[codesInUse()](codesInUse.html)`
    Get the concepts being used in patient records

`[sourceCodesInUse()](sourceCodesInUse.html)`
    Get the source codes being used in patient records

`[availableATC()](availableATC.html)`
    Get the names of all available Anatomical Therapeutic Chemical (ATC) classification codes

`[availableICD10()](availableICD10.html)`
    Get the names of all International Classification of Diseases (ICD) 10 codes

`[availableIngredients()](availableIngredients.html)`
    Get the names of all available drug ingredients

### Create a mock dataset that contains vocabulary tables

`[mockVocabRef()](mockVocabRef.html)`
    Generate example vocabulary database

`[buildAchillesTables()](buildAchillesTables.html)`
    Add the achilles tables with specified analyses

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
