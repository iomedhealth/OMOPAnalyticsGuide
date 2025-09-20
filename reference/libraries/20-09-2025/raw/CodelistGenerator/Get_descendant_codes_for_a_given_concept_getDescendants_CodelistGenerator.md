# Get descendant codes for a given concept — getDescendants • CodelistGenerator

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

# Get descendant codes for a given concept

`getDescendants.Rd`

Get descendant codes for a given concept

## Usage
    
    
    getDescendants(
      cdm,
      conceptId,
      withAncestor = FALSE,
      ingredientRange = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      doseForm = NULL
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

conceptId
    

concept_id to search

withAncestor
    

If TRUE, return column with ancestor. In case of multiple ancestors, concepts will be separated by ";".

ingredientRange
    

Used to restrict descendant codes to those associated with a specific number of drug ingredients. Must be a vector of length two with the first element the minimum number of ingredients allowed and the second the maximum. A value of c(2, 2) would restrict to only concepts associated with two ingredients.

doseForm
    

Only codes with the specified dose form will be returned. If NULL, descendant codes will be returned regardless of dose form. Use 'getDoseForm()' to see the available dose forms.

## Value

The descendants of a given concept id.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getDescendants(cdm = cdm, conceptId = 1)
    #> # A tibble: 5 × 10
    #>   concept_id concept_name             domain_id vocabulary_id standard_concept
    #>        <int> <chr>                    <chr>     <chr>         <chr>           
    #> 1          1 Musculoskeletal disorder Condition SNOMED        S               
    #> 2          2 Osteoarthrosis           Condition SNOMED        S               
    #> 3          3 Arthritis                Condition SNOMED        S               
    #> 4          4 Osteoarthritis of knee   Condition SNOMED        S               
    #> 5          5 Osteoarthritis of hip    Condition SNOMED        S               
    #> # ℹ 5 more variables: concept_class_id <chr>, concept_code <chr>,
    #> #   valid_start_date <date>, valid_end_date <date>, invalid_reason <chr>
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
