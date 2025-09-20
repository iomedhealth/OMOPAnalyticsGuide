# Subset a codelist to only those with a particular route category — subsetOnRouteCategory • CodelistGenerator

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

# Subset a codelist to only those with a particular route category

`subsetOnRouteCategory.Rd`

Subset a codelist to only those with a particular route category

## Usage
    
    
    subsetOnRouteCategory(x, cdm, routeCategory, negate = FALSE)

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

routeCategory
    

Only codes with the specified route will be returned. If NULL, descendant codes will be returned regardless of route category. Use getRoutes() to find the available route categories.

negate
    

If FALSE, only concepts with the routeCategory specified will be returned. If TRUE, concepts with the routeCategory specified will be excluded.

## Value

The codelist with only those concepts associated with the specified route categories (if negate is FALSE) or the codelist without those concepts associated with the specified route categories (if negate is TRUE).

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- subsetOnRouteCategory(
                  x = [list](https://rdrr.io/r/base/list.html)("codes" = [c](https://rdrr.io/r/base/c.html)(20,21)),
                  cdm = cdm,
                  routeCategory = "topical")
    #> Warning: ! `codelist` casted to integers.
    codes
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - codes (1 codes)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
