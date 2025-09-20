# Get the descendant codes of Anatomical Therapeutic Chemical (ATC) classification codes — getATCCodes • CodelistGenerator

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

# Get the descendant codes of Anatomical Therapeutic Chemical (ATC) classification codes

`getATCCodes.Rd`

Get the descendant codes of Anatomical Therapeutic Chemical (ATC) classification codes

## Usage
    
    
    getATCCodes(
      cdm,
      level = [c](https://rdrr.io/r/base/c.html)("ATC 1st"),
      name = NULL,
      nameStyle = "{concept_code}_{concept_name}",
      doseForm = NULL,
      doseUnit = NULL,
      routeCategory = NULL,
      type = "codelist"
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

level
    

ATC level. Can be one or more of "ATC 1st", "ATC 2nd", "ATC 3rd", "ATC 4th", and "ATC 5th".

name
    

ATC name of interest. For example, c("Dermatologicals", "Nervous System"), would result in a list of length two with the descendant concepts for these two particular ATC groups.

nameStyle
    

Name style to apply to returned list. Can be one of `"{concept_code}"`,`"{concept_id}"`, `"{concept_name}"`, or a combination (i.e., `"{concept_code}_{concept_name}"`).

doseForm
    

Only codes with the specified dose form will be returned. If NULL, descendant codes will be returned regardless of dose form. Use 'getDoseForm()' to see the available dose forms.

doseUnit
    

Only codes with the specified dose unit will be returned. If NULL, descendant codes will be returned regardless of dose unit Use 'getDoseUnit()' to see the available dose units.

routeCategory
    

Only codes with the specified route will be returned. If NULL, descendant codes will be returned regardless of route category. Use getRoutes() to find the available route categories.

type
    

Can be "codelist" or "codelist_with_details".

## Value

Concepts with their format based on the type argument

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getATCCodes(cdm = cdm, level = "ATC 1st")
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - 1234_alimentary_tract_and_metabolism (2 codes)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
