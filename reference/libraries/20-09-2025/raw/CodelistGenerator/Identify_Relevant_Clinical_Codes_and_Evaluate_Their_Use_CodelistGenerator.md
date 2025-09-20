# Identify Relevant Clinical Codes and Evaluate Their Use • CodelistGenerator

Skip to contents

[CodelistGenerator](index.html) 3.5.0

  * [Reference](reference/index.html)
  * Articles
    * [Getting the OMOP CDM vocabularies](articles/a01_GettingOmopCdmVocabularies.html)
    * [Exploring the OMOP CDM vocabulary tables](articles/a02_ExploreCDMvocabulary.html)
    * [Generate a candidate codelist](articles/a03_GenerateCandidateCodelist.html)
    * [Generating vocabulary based codelists for medications](articles/a04_GenerateVocabularyBasedCodelist.html)
    * [Generating vocabulary based codelists for conditions](articles/a04b_icd_codes.html)
    * [Extract codelists from JSON files](articles/a05_ExtractCodelistFromJSONfile.html)
    * [Compare, subset or stratify codelists](articles/a06_CreateSubsetsFromCodelist.html)
    * [Codelist diagnostics](articles/a07_RunCodelistDiagnostics.html)
  * [Changelog](news/index.html)




![](logo.png)

# CodelistGenerator 

## Installation

You can install CodelistGenerator from CRAN
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("CodelistGenerator")

Or you can also install the development version of CodelistGenerator
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("remotes")
    remotes::install_github("darwin-eu/CodelistGenerator")

## Example usage
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))

For this example we’ll use the Eunomia dataset (which only contains a subset of the OMOP CDM vocabularies)
    
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    db <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(db, 
                      cdmSchema = "main", 
                      writeSchema = "main", 
                      writePrefix = "cg_")

## Exploring the OMOP CDM Vocabulary tables

OMOP CDM vocabularies are frequently updated, and we can identify the version of the vocabulary of our Eunomia data
    
    
    [getVocabVersion](reference/getVocabVersion.html)(cdm = cdm)
    #> [1] "v5.0 18-JAN-19"

## Vocabulary based codelists using CodelistGenerator

CodelistGenerator provides functions to extract code lists based on vocabulary hierarchies. One example is `getDrugIngredientCodes, which we can use, for example, to get the concept IDs used to represent aspirin and diclofenac.
    
    
    ing <- [getDrugIngredientCodes](reference/getDrugIngredientCodes.html)(cdm = cdm, 
                           name = [c](https://rdrr.io/r/base/c.html)("aspirin", "diclofenac"),
                           nameStyle = "{concept_name}")
    ing
    #> 
    #> - aspirin (2 codes)
    #> - diclofenac (1 codes)
    ing$aspirin
    #> [1] 19059056  1112807
    ing$diclofenac
    #> [1] 1124300

## Systematic search using CodelistGenerator

CodelistGenerator can also support systematic searches of the vocabulary tables to support codelist development. A little like the process for a systematic review, the idea is that for a specified search strategy, CodelistGenerator will identify a set of concepts that may be relevant, with these then being screened to remove any irrelevant codes by clinical experts.

We can do a simple search for asthma
    
    
    asthma_codes1 <- [getCandidateCodes](reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "asthma",
      domains = "Condition"
    ) 
    asthma_codes1 |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 6
    #> $ concept_id       <int> 4051466, 317009
    #> $ found_from       <chr> "From initial search", "From initial search"
    #> $ concept_name     <chr> "Childhood asthma", "Asthma"
    #> $ domain_id        <chr> "Condition", "Condition"
    #> $ vocabulary_id    <chr> "SNOMED", "SNOMED"
    #> $ standard_concept <chr> "S", "S"

But perhaps we want to exclude certain concepts as part of the search strategy, in this case we can add these like so
    
    
    asthma_codes2 <- [getCandidateCodes](reference/getCandidateCodes.html)(
      cdm = cdm,
      keywords = "asthma",
      exclude = "childhood",
      domains = "Condition"
    ) 
    asthma_codes2 |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1
    #> Columns: 6
    #> $ concept_id       <int> 317009
    #> $ found_from       <chr> "From initial search"
    #> $ concept_name     <chr> "Asthma"
    #> $ domain_id        <chr> "Condition"
    #> $ vocabulary_id    <chr> "SNOMED"
    #> $ standard_concept <chr> "S"

## Summarising code use

As well as functions for finding codes, we also have functions to summarise their use. Here for
    
    
    [library](https://rdrr.io/r/base/library.html)([flextable](https://ardata-fr.github.io/flextable-book/))
    asthma_code_use <- [summariseCodeUse](reference/summariseCodeUse.html)([list](https://rdrr.io/r/base/list.html)("asthma" = asthma_codes1$concept_id),
      cdm = cdm
    )
    [tableCodeUse](reference/tableCodeUse.html)(asthma_code_use, type = "flextable")

![](reference/figures/README-unnamed-chunk-8-1.png)

## Links

  * [View on CRAN](https://cloud.r-project.org/package=CodelistGenerator)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Community

  * [Contributing guide](CONTRIBUTING.html)



## Citation

  * [Citing CodelistGenerator](authors.html#citation)



## Developers

  * Edward Burn   
Author, maintainer  [](https://orcid.org/0000-0002-9286-1128)
  * Xihang Chen   
Author  [](https://orcid.org/0009-0001-8112-8959)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * [More about authors...](authors.html)



## Dev status

  * [![CRAN status](https://www.r-pkg.org/badges/version/CodelistGenerator)](https://CRAN.R-project.org/package=CodelistGenerator)
  * [![codecov.io](https://codecov.io/github/darwin-eu/CodelistGenerator/coverage.svg?branch=main)](https://app.codecov.io/github/darwin-eu/CodelistGenerator?branch=main)
  * [![R-CMD-check](https://github.com/darwin-eu/CodelistGenerator/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/CodelistGenerator/actions)
  * [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)



Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
