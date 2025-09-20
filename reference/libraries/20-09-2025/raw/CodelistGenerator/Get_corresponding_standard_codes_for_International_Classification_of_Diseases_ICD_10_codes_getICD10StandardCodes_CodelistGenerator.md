# Get corresponding standard codes for International Classification of Diseases (ICD) 10 codes — getICD10StandardCodes • CodelistGenerator

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

# Get corresponding standard codes for International Classification of Diseases (ICD) 10 codes

`getICD10StandardCodes.Rd`

Get corresponding standard codes for International Classification of Diseases (ICD) 10 codes

## Usage
    
    
    getICD10StandardCodes(
      cdm,
      level = [c](https://rdrr.io/r/base/c.html)("ICD10 Chapter", "ICD10 SubChapter"),
      name = NULL,
      nameStyle = "{concept_code}_{concept_name}",
      includeDescendants = TRUE,
      type = "codelist"
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

level
    

Can be either "ICD10 Chapter", "ICD10 SubChapter", "ICD10 Hierarchy", or "ICD10 Code".

name
    

Name of chapter or sub-chapter of interest. If NULL, all will be considered.

nameStyle
    

Name style to apply to returned list. Can be one of `"{concept_code}"`,`"{concept_id}"`, `"{concept_name}"`, or a combination (i.e., `"{concept_code}_{concept_name}"`).

includeDescendants
    

Either TRUE or FALSE. If TRUE descendant concepts of identified concepts will be included in the candidate codelist. If FALSE only direct mappings from ICD-10 codes to standard codes will be returned.

type
    

Can be "codelist" or "codelist_with_details".

## Value

A named list, with each element containing the corresponding standard codes (and descendants) of ICD chapters and sub-chapters.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getICD10StandardCodes(cdm = cdm, level = [c](https://rdrr.io/r/base/c.html)(
      "ICD10 Chapter",
      "ICD10 SubChapter"
    ))
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    #> 
    #> ── 2 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - 1234_arthropathies (3 codes)
    #> - 1234_diseases_of_the_musculoskeletal_system_and_connective_tissue (3 codes)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
