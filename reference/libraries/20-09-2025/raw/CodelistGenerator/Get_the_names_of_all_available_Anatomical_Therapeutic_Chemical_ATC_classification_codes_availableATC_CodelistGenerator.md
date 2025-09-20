# Get the names of all available Anatomical Therapeutic Chemical (ATC) classification codes — availableATC • CodelistGenerator

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

# Get the names of all available Anatomical Therapeutic Chemical (ATC) classification codes

`availableATC.Rd`

Get the names of all available Anatomical Therapeutic Chemical (ATC) classification codes

## Usage
    
    
    availableATC(cdm, level = [c](https://rdrr.io/r/base/c.html)("ATC 1st"))

## Arguments

cdm
    

A cdm reference via CDMConnector.

level
    

ATC level. Can be one or more of "ATC 1st", "ATC 2nd", "ATC 3rd", "ATC 4th", and "ATC 5th".

## Value

A vector containing the names of ATC codes for the chosen level(s) found in the concept table of cdm.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    availableATC(cdm)
    #> [1] "ALIMENTARY TRACT AND METABOLISM"
    # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
