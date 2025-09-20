# Get the names of all International Classification of Diseases (ICD) 10 codes — availableICD10 • CodelistGenerator

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

# Get the names of all International Classification of Diseases (ICD) 10 codes

`availableICD10.Rd`

Get the names of all International Classification of Diseases (ICD) 10 codes

## Usage
    
    
    availableICD10(cdm, level = [c](https://rdrr.io/r/base/c.html)("ICD10 Chapter", "ICD10 SubChapter"))

## Arguments

cdm
    

A cdm reference via CDMConnector.

level
    

Can be either "ICD10 Chapter", "ICD10 SubChapter", "ICD10 Hierarchy", or "ICD10 Code".

## Value

A vector containing the names of all ICD-10 codes for the chosen level(s) found in the concept table of cdm.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    availableICD10(cdm)
    #> [1] "Diseases of the musculoskeletal system and connective tissue"
    #> [2] "Arthropathies"                                               
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
