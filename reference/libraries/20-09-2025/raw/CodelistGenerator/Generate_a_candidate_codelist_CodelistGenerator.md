# Generate a candidate codelist • CodelistGenerator

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

# Generate a candidate codelist

`a03_GenerateCandidateCodelist.Rmd`

In this example we will create a candidate codelist for osteoarthritis, exploring how different search strategies may impact our final codelist. First, let’s load the necessary packages and create a cdm reference using mock data.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    cdm <- [mockVocabRef](../reference/mockVocabRef.html)()

The mock data has the following hypothetical concepts and relationships:

![](Figures%2F1.png)

## Search for keyword match

We will start by creating a codelist with keywords match. Let’s say that we want to find those codes that contain “Musculoskeletal disorder” in their concept_name: ![](Figures%2F2.png)
    
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Musculoskeletal disorder",
      domains = "Condition", 
      standardConcept = "Standard",
      includeDescendants = FALSE,
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 1 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          1 From initial… Musculoskel… Condition SNOMED        S

Note that we could also identify it based on a partial match or based on all combinations match.
    
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Musculoskeletal",
      domains = "Condition",
      standardConcept = "Standard",
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeDescendants = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 1 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          1 From initial… Musculoskel… Condition SNOMED        S
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Disorder musculoskeletal",
      domains = "Condition",
      standardConcept = "Standard",
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeDescendants = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 1 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          1 From initial… Musculoskel… Condition SNOMED        S

Notice that currently we are only looking for concepts with `domain = "Condition"`. However, we can expand the search to all domains using `domain = NULL`.

## Include non-standard concepts

Now we will include standard and non-standard concepts in our initial search. By setting `standardConcept = c("Non-standard", "Standard")`, we allow the function to return, in the final candidate codelist, both the non-standard and standard codes that have been found.

![](Figures%2F3.png)
    
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Musculoskeletal disorder",
      domains = "Condition",
      standardConcept = [c](https://rdrr.io/r/base/c.html)("Non-standard", "Standard"),
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeDescendants = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 2 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          1 From initial… Musculoskel… Condition SNOMED        S               
    #> 2         24 From initial… Other muscu… Condition SNOMED        NA

## Multiple search terms

We can also search for multiple keywords simultaneously, capturing all of them with the following search:

![](Figures%2F4.png)
    
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = [c](https://rdrr.io/r/base/c.html)(
        "Musculoskeletal disorder",
        "arthritis"
      ),
      domains = "Condition",
      standardConcept = [c](https://rdrr.io/r/base/c.html)("Standard"),
      includeDescendants = FALSE,
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 4 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          1 From initial… Musculoskel… Condition SNOMED        S               
    #> 2          3 From initial… Arthritis    Condition SNOMED        S               
    #> 3          4 From initial… Osteoarthri… Condition SNOMED        S               
    #> 4          5 From initial… Osteoarthri… Condition SNOMED        S

## Add descendants

Now we will include the descendants of an identified code using `includeDescendants` argument ![](Figures%2F5.png)
    
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Musculoskeletal disorder",
      domains = "Condition",
      standardConcept = "Standard",
      includeDescendants = TRUE,
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 5 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          1 From initial… Musculoskel… Condition SNOMED        S               
    #> 2          2 From descend… Osteoarthro… Condition SNOMED        S               
    #> 3          3 From descend… Arthritis    Condition SNOMED        S               
    #> 4          4 From descend… Osteoarthri… Condition SNOMED        S               
    #> 5          5 From descend… Osteoarthri… Condition SNOMED        S

Notice that now, in the column `found_from`, we can see that we have obtain `concept_id=1` from an initial search, and `concept_id_=c(2,3,4,5)` when searching for descendants of concept_id 1.

## With exclusions

We can also exclude specific keywords using the argument `exclude`

![](Figures%2F6.png)
    
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Musculoskeletal disorder",
      domains = "Condition",
      exclude = [c](https://rdrr.io/r/base/c.html)("Osteoarthrosis", "knee"),
      standardConcept = "Standard",
      includeDescendants = TRUE,
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 3 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          1 From initial… Musculoskel… Condition SNOMED        S               
    #> 2          3 From descend… Arthritis    Condition SNOMED        S               
    #> 3          5 From descend… Osteoarthri… Condition SNOMED        S

## Add ancestor

To include the ancestors one level above the identified concepts, we can use the argument `includeAncestor` ![](Figures%2F7.png)
    
    
    codes <- [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Osteoarthritis of knee",
      includeAncestor = TRUE,
      domains = "Condition",
      standardConcept = "Standard",
      includeDescendants = TRUE,
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
    )
    
    codes
    #> # A tibble: 2 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          4 From initial… Osteoarthri… Condition SNOMED        S               
    #> 2          3 From ancestor Arthritis    Condition SNOMED        S

## Search using synonyms

We can also pick up codes based on their synonyms. For example, **Osteoarthrosis** has a synonym of **Arthritis**. ![](Figures%2F8.png)
    
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "osteoarthrosis",
      domains = "Condition",
      searchInSynonyms = TRUE,
      standardConcept = "Standard",
      includeDescendants = FALSE,
      searchNonStandard = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 2 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          2 From initial… Osteoarthro… Condition SNOMED        S               
    #> 2          3 In synonyms   Arthritis    Condition SNOMED        S

Notice that if `includeDescendants = TRUE`, **Arthritis** descendants will also be included: ![](Figures%2F9.png)
    
    
    [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "osteoarthrosis",
      domains = "Condition",
      searchInSynonyms = TRUE,
      standardConcept = "Standard",
      includeDescendants = TRUE,
      searchNonStandard = FALSE,
      includeAncestor = FALSE
    )
    #> # A tibble: 4 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          2 From initial… Osteoarthro… Condition SNOMED        S               
    #> 2          3 In synonyms   Arthritis    Condition SNOMED        S               
    #> 3          4 From descend… Osteoarthri… Condition SNOMED        S               
    #> 4          5 From descend… Osteoarthri… Condition SNOMED        S

## Search via non-standard

We can also pick up concepts associated with our keyword via non-standard search. ![](Figures%2F10.png)
    
    
    codes1 <- [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Degenerative",
      domains = "Condition",
      standardConcept = "Standard",
      searchNonStandard = TRUE,
      includeDescendants = FALSE,
      searchInSynonyms = FALSE,
      includeAncestor = FALSE
    )
    codes1
    #> # A tibble: 1 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          2 From non-sta… Osteoarthro… Condition SNOMED        S

Let’s take a moment to focus on the `standardConcept` and `searchNonStandard` arguments to clarify the difference between them. `standardConcept` specifies whether we want only standard concepts or also include non-standard concepts in the final candidate codelist. `searchNonStandard` determines whether we want to search for keywords among non-standard concepts.

In the previous example, since we set `standardConcept = "Standard"`, we retrieved the code for **Osteoarthrosis** from the non-standard search. However, we did not obtain the non-standard code **degenerative arthropathy** from the initial search. If we allow non-standard concepts in the final candidate codelist, we would retireve both codes:

![](Figures%2F11.png)
    
    
    codes2 <- [getCandidateCodes](../reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "Degenerative",
      domains = "Condition",
      standardConcept = [c](https://rdrr.io/r/base/c.html)("Non-standard", "Standard"),
      searchNonStandard = FALSE,
      includeDescendants = FALSE,
      searchInSynonyms = FALSE,
      includeAncestor = FALSE
    )
    codes2
    #> # A tibble: 1 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          7 From initial… Degenerativ… Condition Read          NA

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
