# Stratify a codelist by route category. — stratifyByRouteCategory • CodelistGenerator

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

# Stratify a codelist by route category.

`stratifyByRouteCategory.Rd`

Stratify a codelist by route category.

## Usage
    
    
    stratifyByRouteCategory(x, cdm, keepOriginal = FALSE)

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

keepOriginal
    

Whether to keep the original codelist and append the stratify (if TRUE) or just return the stratified codelist (if FALSE).

## Value

The codelist with the required stratifications, as different elements of the list.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [list](https://rdrr.io/r/base/list.html)("concepts" = [c](https://rdrr.io/r/base/c.html)(20,21))
    new_codes <- stratifyByRouteCategory(x = codes,
                                         cdm = cdm,
                                         keepOriginal = TRUE)
    #> Warning: ! `codelist` casted to integers.
    #> Warning: ! `codelist` casted to integers.
    new_codes
    #> 
    #> ── 3 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - concepts (2 codes)
    #> - concepts_topical (1 codes)
    #> - concepts_transmucosal_nasal (1 codes)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
