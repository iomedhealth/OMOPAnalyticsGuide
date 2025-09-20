# Subset a codelist to only those codes from a particular domain. — subsetOnDomain • CodelistGenerator

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

# Subset a codelist to only those codes from a particular domain.

`subsetOnDomain.Rd`

Subset a codelist to only those codes from a particular domain.

## Usage
    
    
    subsetOnDomain(x, cdm, domain, negate = FALSE)

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

domain
    

Character vector with one or more of the OMOP CDM domains. The results will be restricted to the given domains. Check the available ones by running getDomains(). If NULL, all supported domains are included: Condition, Drug, Procedure, Device, Observation, and Measurement.

negate
    

If FALSE, only concepts with the domain specified will be returned. If TRUE, concepts with the domain specified will be excluded.

## Value

The codelist with only those concepts associated with the domain (if negate = FALSE) or the codelist without those concepts associated with the domain (if negate = TRUE).

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- subsetOnDomain(
                  x = [list](https://rdrr.io/r/base/list.html)("codes" = [c](https://rdrr.io/r/base/c.html)(10,13,15)),
                  cdm = cdm,
                  domain = "Drug")
    #> Warning: ! `codelist` casted to integers.
    codes
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - codes (2 codes)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
