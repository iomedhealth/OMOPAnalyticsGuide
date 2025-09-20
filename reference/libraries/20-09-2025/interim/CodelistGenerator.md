# Content from https://darwin-eu.github.io/CodelistGenerator/


---

## Content from https://darwin-eu.github.io/CodelistGenerator/

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/index.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/index.html

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

# Package index

### Search for codes following a systematic search strategy

`[getCandidateCodes()](getCandidateCodes.html)`
    Generate a candidate codelist

### Create vocabulary-based codelists

`[getDrugIngredientCodes()](getDrugIngredientCodes.html)`
    Get descendant codes of drug ingredients

`[getATCCodes()](getATCCodes.html)`
    Get the descendant codes of Anatomical Therapeutic Chemical (ATC) classification codes

`[getICD10StandardCodes()](getICD10StandardCodes.html)`
    Get corresponding standard codes for International Classification of Diseases (ICD) 10 codes

### Run codelist diagnostics

`[summariseAchillesCodeUse()](summariseAchillesCodeUse.html)`
    Summarise code use from achilles counts.

`[summariseCodeUse()](summariseCodeUse.html)`
    Summarise code use in patient-level data.

`[summariseCohortCodeUse()](summariseCohortCodeUse.html)`
    Summarise code use among a cohort in the cdm reference

`[summariseOrphanCodes()](summariseOrphanCodes.html)`
    Find orphan codes related to a codelist using achilles counts and, if available, PHOEBE concept recommendations

`[summariseUnmappedCodes()](summariseUnmappedCodes.html)`
    Find unmapped concepts related to codelist

### Present codelist diagnostics results in a table

`[tableAchillesCodeUse()](tableAchillesCodeUse.html)`
    Format the result of summariseAchillesCodeUse into a table

`[tableCodeUse()](tableCodeUse.html)`
    Format the result of summariseCodeUse into a table.

`[tableCohortCodeUse()](tableCohortCodeUse.html)`
    Format the result of summariseCohortCodeUse into a table.

`[tableOrphanCodes()](tableOrphanCodes.html)`
    Format the result of summariseOrphanCodes into a table

`[tableUnmappedCodes()](tableUnmappedCodes.html)`
    Format the result of summariseUnmappedCodeUse into a table

### Extract codelists from JSON files

`[codesFromCohort()](codesFromCohort.html)`
    Get concept ids from JSON files containing cohort definitions

`[codesFromConceptSet()](codesFromConceptSet.html)`
    Get concept ids from JSON files containing concept sets

### Codelist utility functions

`[compareCodelists()](compareCodelists.html)`
    Compare overlap between two sets of codes

`[subsetToCodesInUse()](subsetToCodesInUse.html)`
    Filter a codelist to keep only the codes being used in patient records

`[subsetOnRouteCategory()](subsetOnRouteCategory.html)`
    Subset a codelist to only those with a particular route category

`[subsetOnDoseUnit()](subsetOnDoseUnit.html)`
    Subset a codelist to only those with a particular dose unit.

`[subsetOnDomain()](subsetOnDomain.html)`
    Subset a codelist to only those codes from a particular domain.

`[stratifyByRouteCategory()](stratifyByRouteCategory.html)`
    Stratify a codelist by route category.

`[stratifyByDoseUnit()](stratifyByDoseUnit.html)`
    Stratify a codelist by dose unit.

`[stratifyByConcept()](stratifyByConcept.html)`
    Stratify a codelist by the concepts included within it.

`[getMappings()](getMappings.html)`
    Show mappings from non-standard vocabularies to standard.

### Vocabulary utility functions

`[getVocabVersion()](getVocabVersion.html)`
    Get the version of the vocabulary used in the cdm

`[getVocabularies()](getVocabularies.html)`
    Get the vocabularies available in the cdm

`[getConceptClassId()](getConceptClassId.html)`
    Get the concept classes used in a given set of domains

`[getDomains()](getDomains.html)`
    Get the domains available in the cdm

`[getDescendants()](getDescendants.html)`
    Get descendant codes for a given concept

`[getDoseForm()](getDoseForm.html)`
    Get the dose forms available for drug concepts

`[getRouteCategories()](getRouteCategories.html)`
    Get available drug routes

`[getDoseUnit()](getDoseUnit.html)`
    Get available dose units

`[getRelationshipId()](getRelationshipId.html)`
    Get available relationships between concepts

`[codesInUse()](codesInUse.html)`
    Get the concepts being used in patient records

`[sourceCodesInUse()](sourceCodesInUse.html)`
    Get the source codes being used in patient records

`[availableATC()](availableATC.html)`
    Get the names of all available Anatomical Therapeutic Chemical (ATC) classification codes

`[availableICD10()](availableICD10.html)`
    Get the names of all International Classification of Diseases (ICD) 10 codes

`[availableIngredients()](availableIngredients.html)`
    Get the names of all available drug ingredients

### Create a mock dataset that contains vocabulary tables

`[mockVocabRef()](mockVocabRef.html)`
    Generate example vocabulary database

`[buildAchillesTables()](buildAchillesTables.html)`
    Add the achilles tables with specified analyses

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/articles/a01_GettingOmopCdmVocabularies.html

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

# Getting the OMOP CDM vocabularies

`a01_GettingOmopCdmVocabularies.Rmd`

When working with the CodelistGenerator we normally have two options of how to interact with the OMOP CDM vocabulary tables.

The first is to connect to a “live” database with patient data in the OMOP CDM format. As part of this OMOP CDM dataset we will have a version of vocabularies that corresponds to the concepts being used in the patient records we have in the various clinical tables. This is useful in that we will be working with the same vocabularies that are being used for clinical records in this dataset. However, if working on a study with multiple data partners we should take note that other data partners may be using different vocabulary versions.

The second option is to create a standalone database with just a set of OMOP CDM vocabulary tables. This is convenient because we can choose whichever version and vocabularies we want. However, we will need to keep in mind that this can differ to the version used for a particular dataset.

## Connect to an existing OMOP CDM database

If you already have access to a database with data in the OMOP CDM format, you can use CodelistGenerator by first creating a cdm reference which will include the vocabulary tables.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    db <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(db, 
                      cdmSchema = "main", 
                      writeSchema = "main", 
                      writePrefix = "cg_")
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of Synthea ────────────────────────────────────
    #> • omop tables: person, observation_period, visit_occurrence, visit_detail,
    #> condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
    #> measurement, observation, death, note, note_nlp, specimen, fact_relationship,
    #> location, care_site, provider, payer_plan_period, cost, drug_era, dose_era,
    #> condition_era, metadata, cdm_source, concept, vocabulary, domain,
    #> concept_class, concept_relationship, relationship, concept_synonym,
    #> concept_ancestor, source_to_concept_map, drug_strength
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

We can see that we know have various OMOP CDM vocabulary tables we can work with.
    
    
    cdm$concept |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 10
    #> Database: DuckDB v1.2.1 [unknown@Linux 6.8.0-1021-azure:R 4.4.3//tmp/RtmpJFx2G8/file218b2eb4f3b6.duckdb]
    #> $ concept_id       <int> 35208414, 1118088, 40213201, 1557272, 4336464, 429588…
    #> $ concept_name     <chr> "Gastrointestinal hemorrhage, unspecified", "celecoxi…
    #> $ domain_id        <chr> "Condition", "Drug", "Drug", "Drug", "Procedure", "Pr…
    #> $ vocabulary_id    <chr> "ICD10CM", "RxNorm", "CVX", "RxNorm", "SNOMED", "SNOM…
    #> $ concept_class_id <chr> "4-char billing code", "Branded Drug", "CVX", "Ingred…
    #> $ standard_concept <chr> NA, "S", "S", "S", "S", "S", "S", "S", NA, NA, "S", "…
    #> $ concept_code     <chr> "K92.2", "213469", "33", "46041", "232717009", "76601…
    #> $ valid_start_date <date> 2007-01-01, 1970-01-01, 2008-12-01, 1970-01-01, 1970…
    #> $ valid_end_date   <date> 2099-12-31, 2099-12-31, 2099-12-31, 2099-12-31, 2099…
    #> $ invalid_reason   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    cdm$concept_relationship |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.2.1 [unknown@Linux 6.8.0-1021-azure:R 4.4.3//tmp/RtmpJFx2G8/file218b2eb4f3b6.duckdb]
    #> $ concept_id_1     <int> 192671, 1118088, 1569708, 35208414, 35208414, 4016235…
    #> $ concept_id_2     <int> 35208414, 44923712, 35208414, 192671, 1569708, 450118…
    #> $ relationship_id  <chr> "Mapped from", "Mapped from", "Subsumes", "Maps to", …
    #> $ valid_start_date <date> 1970-01-01, 1970-01-01, 2016-03-25, 1970-01-01, 2016…
    #> $ valid_end_date   <date> 2099-12-31, 2099-12-31, 2099-12-31, 2099-12-31, 2099…
    #> $ invalid_reason   <chr> NA, NA, NA, NA, NA, NA, NA, NA
    cdm$concept_ancestor |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.2.1 [unknown@Linux 6.8.0-1021-azure:R 4.4.3//tmp/RtmpJFx2G8/file218b2eb4f3b6.duckdb]
    #> $ ancestor_concept_id      <int> 4180628, 4179141, 21500574, 21505770, 2150396…
    #> $ descendant_concept_id    <int> 313217, 4146173, 1118084, 1119510, 40162522, …
    #> $ min_levels_of_separation <int> 5, 2, 4, 0, 5, 4, 0, 4, 2, 2, 0, 0, 0, 0, 0, …
    #> $ max_levels_of_separation <int> 6, 2, 4, 0, 6, 4, 0, 4, 2, 2, 0, 0, 0, 0, 0, …
    cdm$concept_synonym |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 3
    #> Database: DuckDB v1.2.1 [unknown@Linux 6.8.0-1021-azure:R 4.4.3//tmp/RtmpJFx2G8/file218b2eb4f3b6.duckdb]
    #> $ concept_id           <int> 964261, 1322184, 441267, 1718412, 4336464, 410212…
    #> $ concept_synonym_name <chr> "cyanocobalamin 5000 MCG/ML Injectable Solution",…
    #> $ language_concept_id  <int> 4180186, 4180186, 4180186, 4180186, 4180186, 4180…
    cdm$drug_strength |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 12
    #> Database: DuckDB v1.2.1 [unknown@Linux 6.8.0-1021-azure:R 4.4.3//tmp/RtmpJFx2G8/file218b2eb4f3b6.duckdb]
    #> $ drug_concept_id             <int> 
    #> $ ingredient_concept_id       <int> 
    #> $ amount_value                <dbl> 
    #> $ amount_unit_concept_id      <int> 
    #> $ numerator_value             <dbl> 
    #> $ numerator_unit_concept_id   <int> 
    #> $ denominator_value           <dbl> 
    #> $ denominator_unit_concept_id <int> 
    #> $ box_size                    <int> 
    #> $ valid_start_date            <date> 
    #> $ valid_end_date              <date> 
    #> $ invalid_reason              <chr>

It is important to remember that our results will be tied to the vocabulary version used when this OMOP CDM database was created. Moreover, we should also take note of which vocabularies were included. A couple of CodelistGenerator utility functions can help us find this information.
    
    
    [getVocabVersion](../reference/getVocabVersion.html)(cdm)
    #> [1] "v5.0 18-JAN-19"
    
    
    [getVocabularies](../reference/getVocabularies.html)(cdm)
    #> [1] "CVX"     "Gender"  "ICD10CM" "LOINC"   "NDC"     "None"    "RxNorm" 
    #> [8] "SNOMED"  "Visit"

## Create a local vocabulary database

If you don’t have access to an OMOP CDM database or if you want to work with a specific vocabulary version and set of vocabularies then you can create your own vocabulary database.

### Download vocabularies from athena

Your first step will be to get the vocabulary tables for the OMOP CDM. For this go to <https://athena.ohdsi.org/>. From here you can, after creating a free account, download the vocabularies. By default you will be getting the latest version and a default set of vocabularies. You can though choose to download an older version and expand your selection of vocabularies. In general we would suggest to select all available vocabularies.

### Create a duckdb database

After downloading the vocabularies you will have a set of csvs (along with a tool to add the CPT-4 codes if you wish). To quickly create a duckdb vocab database you could use the following code. Here, after pointing to the unzipped folder containg the csvs, we’ll read each table into memory and write them to a duckdb database which we’ll save in the same folder. We’ll also add an empty person and observation period table so that you can create a cdm reference at the end.
    
    
    [library](https://rdrr.io/r/base/library.html)([readr](https://readr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    vocab_folder <- here() # add path to directory
    
    # read in files
    concept <- [read_delim](https://readr.tidyverse.org/reference/read_delim.html)(here(vocab_folder, "CONCEPT.csv"),
                          "\t",
                          escape_double = FALSE, trim_ws = TRUE
    )
    concept_relationship <- [read_delim](https://readr.tidyverse.org/reference/read_delim.html)(here(vocab_folder, "CONCEPT_RELATIONSHIP.csv"),
                                       "\t",
                                       escape_double = FALSE, trim_ws = TRUE
    )
    concept_ancestor <- [read_delim](https://readr.tidyverse.org/reference/read_delim.html)(here(vocab_folder, "CONCEPT_ANCESTOR.csv"),
                                   "\t",
                                   escape_double = FALSE, trim_ws = TRUE
    )
    concept_synonym <- [read_delim](https://readr.tidyverse.org/reference/read_delim.html)(here(vocab_folder, "CONCEPT_SYNONYM.csv"),
                                  "\t",
                                  escape_double = FALSE, trim_ws = TRUE
    )
    vocabulary <- [read_delim](https://readr.tidyverse.org/reference/read_delim.html)(here(vocab_folder, "VOCABULARY.csv"), "\t",
                             escape_double = FALSE, trim_ws = TRUE
    )
    
    # write to duckdb
    db <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), here(vocab_folder,"vocab.duckdb"))
    [dbWriteTable](https://dbi.r-dbi.org/reference/dbWriteTable.html)(db, "concept", concept, overwrite = TRUE)
    [dbWriteTable](https://dbi.r-dbi.org/reference/dbWriteTable.html)(db, "concept_relationship", concept_relationship, overwrite = TRUE)
    [dbWriteTable](https://dbi.r-dbi.org/reference/dbWriteTable.html)(db, "concept_ancestor", concept_ancestor, overwrite = TRUE)
    [dbWriteTable](https://dbi.r-dbi.org/reference/dbWriteTable.html)(db, "concept_synonym", concept_synonym, overwrite = TRUE)
    [dbWriteTable](https://dbi.r-dbi.org/reference/dbWriteTable.html)(db, "vocabulary", vocabulary, overwrite = TRUE)
    # add empty person and observation period tables
    person_cols <- [omopColumns](https://darwin-eu.github.io/omopgenerics/reference/omopColumns.html)("person")
    person <- [data.frame](https://rdrr.io/r/base/data.frame.html)([matrix](https://rdrr.io/r/base/matrix.html)(ncol = [length](https://rdrr.io/r/base/length.html)(person_cols), nrow = 0))
    [colnames](https://rdrr.io/r/base/colnames.html)(person) <- person_cols
    [dbWriteTable](https://dbi.r-dbi.org/reference/dbWriteTable.html)(db, "person", person, overwrite = TRUE)
    observation_period_cols <- [omopColumns](https://darwin-eu.github.io/omopgenerics/reference/omopColumns.html)("observation_period")
    observation_period <- [data.frame](https://rdrr.io/r/base/data.frame.html)([matrix](https://rdrr.io/r/base/matrix.html)(ncol = [length](https://rdrr.io/r/base/length.html)(observation_period_cols), nrow = 0))
    [colnames](https://rdrr.io/r/base/colnames.html)(observation_period) <- observation_period_cols
    [dbWriteTable](https://dbi.r-dbi.org/reference/dbWriteTable.html)(db, "observation_period", observation_period, overwrite = TRUE)
    [dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(db)

Now we could create a cdm reference to our OMOP CDM vocabulary database.
    
    
    db <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), here(vocab_folder,"vocab.duckdb"))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(db, "main", "main", cdmName = "vocabularise", .softValidation = TRUE)

This vocabulary only database can be then used for the various functions for identifying codes of interest. However, as it doesn’t contain patient-level records it won’t be relevant for functions summarising the use of codes, etc. Here we have shown how to make a local duckdb database, but a similar approach could also be used for other database management systems.

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/articles/a02_ExploreCDMvocabulary.html

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

# Exploring the OMOP CDM vocabulary tables

`a02_ExploreCDMvocabulary.Rmd`

In this vignette, we will explore the functions that help us delve into the vocabularies used in our database. These functions allow us to explore the different vocabularies and concepts characteristics.

First of all, we will load the required packages and a eunomia database.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    # Connect to the database and create the cdm object
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                      cdmName = "Eunomia Synpuf",
                      cdmSchema   = "main",
                      writeSchema = "main", 
                      achillesSchema = "main")

Note that we have included [achilles tables](https://github.com/OHDSI/Achilles) in our cdm reference, which are used for some of the analyses.

## Vocabulary characteristics

We can first start by getting the vocabulary version of our CDM object:
    
    
    [getVocabVersion](../reference/getVocabVersion.html)(cdm)
    #> [1] "v5.0 06-AUG-21"

And the available vocabularies, which correspond to the column _vocabulary_id_ from the concept table:
    
    
    [getVocabularies](../reference/getVocabularies.html)(cdm)
    #>  [1] "APC"                  "ATC"                  "BDPM"                
    #>  [4] "CMS Place of Service" "Cohort"               "Concept Class"       
    #>  [7] "Condition Type"       "CPT4"                 "Currency"            
    #> [10] "Death Type"           "Device Type"          "Domain"              
    #> [13] "DPD"                  "DRG"                  "Drug Type"           
    #> [16] "Ethnicity"            "Gemscript"            "Gender"              
    #> [19] "HCPCS"                "HES Specialty"        "ICD10"               
    #> [22] "ICD10CM"              "ICD9CM"               "ICD9Proc"            
    #> [25] "LOINC"                "MDC"                  "Meas Type"           
    #> [28] "Multilex"             "Multum"               "NDC"                 
    #> [31] "NDFRT"                "None"                 "Note Type"           
    #> [34] "NUCC"                 "Obs Period Type"      "Observation Type"    
    #> [37] "OPCS4"                "OXMIS"                "PCORNet"             
    #> [40] "Procedure Type"       "Provider"             "Race"                
    #> [43] "Read"                 "Relationship"         "Revenue Code"        
    #> [46] "RxNorm"               "RxNorm Extension"     "SMQ"                 
    #> [49] "SNOMED"               "SPL"                  "Supplier"            
    #> [52] "UCUM"                 "VA Class"             "VA Product"          
    #> [55] "Visit"                "Visit Type"           "Vocabulary"

## Domains

We can also explore the domains that our CDM object has, which is the column _domain_id_ from the concept table:
    
    
    [getDomains](../reference/getDomains.html)(cdm)
    #>  [1] "Drug"                "Device"              "Meas Value"         
    #>  [4] "Procedure"           "Provider"            "Metadata"           
    #>  [7] "Ethnicity"           "Race"                "Gender"             
    #> [10] "Relationship"        "Specimen"            "Route"              
    #> [13] "Spec Disease Status" "Currency"            "Observation"        
    #> [16] "Unit"                "Condition"           "Visit"              
    #> [19] "Measurement"         "Spec Anatomic Site"  "Meas Value Operator"
    #> [22] "Revenue Code"

or restrict the search among _standard_ concepts:
    
    
    [getDomains](../reference/getDomains.html)(cdm, 
               standardConcept = "Standard")
    #>  [1] "Observation"         "Condition"           "Visit"              
    #>  [4] "Unit"                "Measurement"         "Spec Anatomic Site" 
    #>  [7] "Revenue Code"        "Meas Value Operator" "Specimen"           
    #> [10] "Route"               "Relationship"        "Currency"           
    #> [13] "Spec Disease Status" "Drug"                "Device"             
    #> [16] "Procedure"           "Meas Value"          "Gender"             
    #> [19] "Race"                "Provider"            "Metadata"           
    #> [22] "Ethnicity"

## Concept class

We can further explore the different classes that we have (reported in _concept_class_id_ column from the concept table):
    
    
    [getConceptClassId](../reference/getConceptClassId.html)(cdm)
    #>  [1] "2-dig nonbill code"   "3-dig billing code"   "3-dig nonbill code"  
    #>  [4] "4-dig billing code"   "Admitting Source"     "Answer"              
    #>  [7] "APC"                  "Attribute"            "Body Structure"      
    #> [10] "Branded Drug"         "Branded Drug Box"     "Branded Drug Comp"   
    #> [13] "Branded Drug Form"    "Branded Pack"         "Branded Pack Box"    
    #> [16] "Canonical Unit"       "Claims Attachment"    "Clinical Drug"       
    #> [19] "Clinical Drug Box"    "Clinical Drug Comp"   "Clinical Drug Form"  
    #> [22] "Clinical Finding"     "Clinical Observation" "Clinical Pack"       
    #> [25] "Clinical Pack Box"    "Context-dependent"    "CPT4"                
    #> [28] "CPT4 Hierarchy"       "CPT4 Modifier"        "Currency"            
    #> [31] "Device"               "Discharge Status"     "Disposition"         
    #> [34] "Doc Kind"             "Doc Role"             "Doc Setting"         
    #> [37] "Doc Subject Matter"   "Doc Type of Service"  "Dose Form"           
    #> [40] "Ethnicity"            "Event"                "Gemscript"           
    #> [43] "Gemscript THIN"       "Gender"               "HCPCS"               
    #> [46] "HCPCS Modifier"       "Ingredient"           "Lab Test"            
    #> [49] "Linkage Assertion"    "Location"             "Marketed Product"    
    #> [52] "MDC"                  "Morph Abnormality"    "MS-DRG"              
    #> [55] "Observable Entity"    "Observation"          "Organism"            
    #> [58] "Pharma/Biol Product"  "Physical Force"       "Physical Object"     
    #> [61] "Physician Specialty"  "Procedure"            "Provider"            
    #> [64] "Qualifier Value"      "Quant Branded Box"    "Quant Branded Drug"  
    #> [67] "Quant Clinical Box"   "Quant Clinical Drug"  "Race"                
    #> [70] "Relationship"         "Revenue Code"         "Social Context"      
    #> [73] "Specimen"             "Staging / Scales"     "Substance"           
    #> [76] "Survey"               "Unit"                 "Visit"

Or restrict the search among _non-standard_ concepts with _condition_ domain:
    
    
    [getConceptClassId](../reference/getConceptClassId.html)(cdm, 
                      standardConcept = "Non-standard", 
                      domain = "Condition")
    #>  [1] "3-char billing code"  "3-char nonbill code"  "3-dig billing code"  
    #>  [4] "3-dig billing E code" "3-dig billing V code" "3-dig nonbill code"  
    #>  [7] "3-dig nonbill E code" "3-dig nonbill V code" "4-char billing code" 
    #> [10] "4-char nonbill code"  "4-dig billing code"   "4-dig billing E code"
    #> [13] "4-dig billing V code" "4-dig nonbill code"   "4-dig nonbill V code"
    #> [16] "5-char billing code"  "5-char nonbill code"  "5-dig billing code"  
    #> [19] "5-dig billing V code" "6-char billing code"  "6-char nonbill code" 
    #> [22] "7-char billing code"  "Admin Concept"        "Clinical Finding"    
    #> [25] "Context-dependent"    "Event"                "ICD10 code"          
    #> [28] "ICD10 Hierarchy"      "ICD10 SubChapter"     "ICD9CM code"         
    #> [31] "Morph Abnormality"    "Navi Concept"         "Observable Entity"   
    #> [34] "Organism"             "OXMIS"                "Pharma/Biol Product" 
    #> [37] "Physical Object"      "Procedure"            "Qualifier Value"     
    #> [40] "Read"                 "SMQ"                  "Social Context"      
    #> [43] "Staging / Scales"     "Substance"

## Relationships

We can also explore the different relationships that are present in our CDM:
    
    
    [getRelationshipId](../reference/getRelationshipId.html)(cdm)
    #>  [1] "Asso finding of"   "Asso with finding" "Due to of"        
    #>  [4] "Finding asso with" "Followed by"       "Follows"          
    #>  [7] "Has asso finding"  "Has due to"        "Has manifestation"
    #> [10] "Is a"              "Manifestation of"  "Mapped from"      
    #> [13] "Maps to"           "Occurs after"      "Occurs before"    
    #> [16] "Subsumes"

Or narrow the search among _standard_ concepts with domain _observation_ :
    
    
    [getRelationshipId](../reference/getRelationshipId.html)(cdm,
                      standardConcept1 = "standard",
                      standardConcept2 = "standard",
                      domains1 = "observation",
                      domains2 = "observation")
    #>   [1] "Access of"            "Admin method of"      "Asso finding of"     
    #>   [4] "Asso morph of"        "Asso proc of"         "Asso with finding"   
    #>   [7] "Basic dose form of"   "Causative agent of"   "Characterizes"       
    #>  [10] "Clinical course of"   "Component of"         "Contained in panel"  
    #>  [13] "CPT4 - SNOMED cat"    "CPT4 - SNOMED eq"     "Dir morph of"        
    #>  [16] "Dir subst of"         "Disp dose form of"    "Dose form of"        
    #>  [19] "DRG - MDC cat"        "Due to of"            "Energy used by"      
    #>  [22] "Finding asso with"    "Finding context of"   "Finding inform of"   
    #>  [25] "Focus of"             "Has access"           "Has admin method"    
    #>  [28] "Has asso finding"     "Has asso morph"       "Has asso proc"       
    #>  [31] "Has basic dose form"  "Has causative agent"  "Has clinical course" 
    #>  [34] "Has component"        "Has dir morph"        "Has dir subst"       
    #>  [37] "Has disp dose form"   "Has dose form"        "Has due to"          
    #>  [40] "Has finding context"  "Has focus"            "Has intended site"   
    #>  [43] "Has intent"           "Has interprets"       "Has laterality"      
    #>  [46] "Has method"           "Has modification"     "Has occurrence"      
    #>  [49] "Has pathology"        "Has priority"         "Has proc context"    
    #>  [52] "Has proc duration"    "Has proc morph"       "Has process output"  
    #>  [55] "Has property"         "Has recipient cat"    "Has relat context"   
    #>  [58] "Has release charact"  "Has scale type"       "Has severity"        
    #>  [61] "Has spec active ing"  "Has state of matter"  "Has technique"       
    #>  [64] "Has temp finding"     "Has temporal context" "Has time aspect"     
    #>  [67] "Has transformation"   "Intended site of"     "Intent of"           
    #>  [70] "Interprets of"        "Is a"                 "Is characterized by" 
    #>  [73] "Laterality of"        "Mapped from"          "Maps to"             
    #>  [76] "Maps to value"        "MDC cat - DRG"        "Method of"           
    #>  [79] "Modification of"      "Occurrence of"        "Panel contains"      
    #>  [82] "Pathology of"         "Plays role"           "Priority of"         
    #>  [85] "Proc context of"      "Proc duration of"     "Proc morph of"       
    #>  [88] "Process output of"    "Property of"          "Recipient cat of"    
    #>  [91] "Relat context of"     "Relative to"          "Relative to of"      
    #>  [94] "Release charact of"   "Role played by"       "Scale type of"       
    #>  [97] "Severity of"          "SNOMED - CPT4 eq"     "SNOMED cat - CPT4"   
    #> [100] "Spec active ing of"   "State of matter of"   "Subst used by"       
    #> [103] "Subsumes"             "Technique of"         "Temp related to"     
    #> [106] "Temporal context of"  "Time aspect of"       "Transformation of"   
    #> [109] "Using energy"         "Using finding inform" "Using subst"         
    #> [112] "Value mapped from"

## Codes in use

Finally, we can easily get those codes that are in use (that means, that are recorded at least one time in the database):
    
    
    result <- [sourceCodesInUse](../reference/sourceCodesInUse.html)(cdm)
    [head](https://rdrr.io/r/utils/head.html)(result, n = 5) # Only the first 5 will be shown
    #> [1] 2615322 2615756 2615740 2614783 2615349

Notice that [achilles tables](https://github.com/OHDSI/Achilles) are used in this function. If you CDM does not have them loaded, an empty result will be returned.

And we can restrict the search within specific CDM tables (for example, _condition_occurrence_ and _device_exposure_ table):
    
    
    result <- [sourceCodesInUse](../reference/sourceCodesInUse.html)(cdm, table = [c](https://rdrr.io/r/base/c.html)("device_exposure", "condition_occurrence"))
    [head](https://rdrr.io/r/utils/head.html)(result, n = 5) # Only the first 5 will be shown
    #> [1] 44837444 44823465 44835527 44831602 44823910

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/articles/a03_GenerateCandidateCodelist.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/articles/a04_GenerateVocabularyBasedCodelist.html

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

# Generating vocabulary based codelists for medications

`a04_GenerateVocabularyBasedCodelist.Rmd`

In this vignette, we will explore how to generate codelists for medications using the OMOP CDM vocabulary tables. To begin, let’s load the necessary packages and create a cdm reference using Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    # Connect to the database and create the cdm object
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                     [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                      cdmName = "Eunomia Synpuf",
                      cdmSchema = "main",
                      writeSchema = "main",
                      achillesSchema = "main")

## Ingredient based codelists

The `[getDrugIngredientCodes()](../reference/getDrugIngredientCodes.html)` function can be used to generate the medication codelists based on ingredient codes.

We can see that we have many drug ingredients for which we could create codelists.
    
    
    [availableIngredients](../reference/availableIngredients.html)(cdm) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:15440] "Abies Nigra" "Achyranthes Calea" "Adamas" ...

We will likely be interested in some specific drug ingredients of interest. Say for example we would like a codelist for acetaminophen then we can get this easily enough.
    
    
    acetaminophen_codes <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen")
    )
    
    acetaminophen_codes
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - 161_acetaminophen (23935 codes)

Notice that either the concept name or the concept ID can be specified to find the relevant codes.
    
    
    acetaminophen_codes <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = 1125315
    )
    
    acetaminophen_codes
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - 161_acetaminophen (23935 codes)

Instead of getting back all concepts for acetaminophen, we can use the `ingredientRange` argument to return only concepts associated with acetaminophen and at least one more drug ingredient (i.e. combination therapies). Here instead of returning a codelist with only the concept IDs, we will get them with details so that we can see concept names.
    
    
    acetaminophen_two_or_more_ingredients <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = "acetaminophen",
      ingredientRange = [c](https://rdrr.io/r/base/c.html)(2, Inf),
      type = "codelist_with_details"
    )
    
    acetaminophen_two_or_more_ingredients
    #> 
    #> ── 1 codelist with details ─────────────────────────────────────────────────────
    #> 
    #> - 161_acetaminophen (15309 codes)
    
    acetaminophen_two_or_more_ingredients[[1]] |> 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("concept_name") |> 
      [head](https://rdrr.io/r/utils/head.html)(n = 5) # Only the first five will be shown
    #> [1] "acetaminophen 325 MG / methocarbamol 400 MG Oral Tablet [AMETO]"            
    #> [2] "acetaminophen 325 MG / methocarbamol 400 MG Oral Tablet [METOPEN]"          
    #> [3] "acetaminophen 325 MG / methocarbamol 400 MG Oral Tablet [METOPEN] by Mirae" 
    #> [4] "acetaminophen 325 MG / methocarbamol 400 MG Oral Tablet [METVA]"            
    #> [5] "acetaminophen 325 MG / methocarbamol 400 MG Oral Tablet [METVA] by Kyungnam"

Or we could instead only return concepts associated with acetaminophen and no other drug ingredient.
    
    
    acetaminophen_one_ingredient <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = "acetaminophen",
      ingredientRange = [c](https://rdrr.io/r/base/c.html)(1, 1),
      type = "codelist_with_details"
    )
    
    acetaminophen_one_ingredient
    #> 
    #> ── 1 codelist with details ─────────────────────────────────────────────────────
    #> 
    #> - 161_acetaminophen (8626 codes)
    
    acetaminophen_one_ingredient[[1]] |> 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("concept_name") |> 
      [head](https://rdrr.io/r/utils/head.html)(n = 5) # Only the first five will be shown
    #> [1] "acetaminophen"                          
    #> [2] "acetaminophen 120 MG Rectal Suppository"
    #> [3] "acetaminophen 325 MG Oral Capsule"      
    #> [4] "acetaminophen 325 MG Rectal Suppository"
    #> [5] "acetaminophen 500 MG Oral Capsule"

### Restrict to a specific dose form

Perhaps we are just interested in a particular dose form. We can see that there are many available.
    
    
    [getDoseForm](../reference/getDoseForm.html)(cdm) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:185] "Augmented Topical Cream" "Augmented Topical Gel" ...

We can choose one or more of these to restrict to a particular dose form when finding our relevant codes. Here, for example, we only include codes with a dose form of injection.
    
    
    acetaminophen_injections <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = "acetaminophen",
      doseForm = "injection",
      type = "codelist_with_details"
    )
    
    acetaminophen_injections[[1]] |> 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("concept_name") |> 
      [head](https://rdrr.io/r/utils/head.html)(n = 5) 
    #> [1] "100 ML Acetaminophen 10 MG/ML Injection [Perfalgan] by Bristol Myers Squibb"
    #> [2] "100 ML Acetaminophen 10 MG/ML Injection by Actavis"                         
    #> [3] "Acetaminophen 10 MG/ML Injection [PARACETAMOL MACOPHARMA] Box of 50"        
    #> [4] "Acetaminophen 10 MG/ML Injection [PARACETAMOL B BRAUN]"                     
    #> [5] "Acetaminophen Injection [PARACETAMOL ACTAVIS]"

### Restrict to a specific dose unit

Similarly, we can might also want to restrict to a specific dose unit. Again we have a number of options available in our vocabularies.
    
    
    [getDoseUnit](../reference/getDoseUnit.html)(cdm) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:30] "50% cell culture infectious dose" ...

Here we’ll just include codes with a dose unit of milligram.
    
    
    acetaminophen_miligram <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = "acetaminophen",
      doseUnit = "milligram",
      type = "codelist_with_details"
    )
    
    acetaminophen_miligram[[1]] |> 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("concept_name") |> 
      [head](https://rdrr.io/r/utils/head.html)(n = 5) 
    #> [1] "Acetaminophen / Tramadol Oral Tablet [TRAMADOL/PARACETAMOL TEVA]"                                        
    #> [2] "Acetaminophen / Tramadol Oral Tablet [Ran-Tramadol/Acet]"                                                
    #> [3] "Acetaminophen / Pseudoephedrine Oral Capsule [VICKS]"                                                    
    #> [4] "Acetaminophen / Phenylephrine Oral Powder [Theraflu]"                                                    
    #> [5] "Acetaminophen / Ascorbic Acid / Pheniramine / Phenylephrine Oral Capsule [Hot Relief-Extra Strength Pck]"

### Restrict to a specific route

Lastly, we can restrict to a specific route category. We can see we again have a number of options.
    
    
    [getRouteCategories](../reference/getRouteCategories.html)(cdm) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:12] "implant" "inhalable" "injectable" "oral" "topical" ...

Here we’ll include only concepts with a route category of inhalable.
    
    
    acetaminophen_inhalable <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = "acetaminophen",
      routeCategory = "inhalable",
      type = "codelist_with_details"
    )
    
    acetaminophen_inhalable[[1]] |> 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("concept_name") |> 
      [head](https://rdrr.io/r/utils/head.html)(n = 5) 
    #> [1] "acetaminophen 300 MG Inhalation Powder"
    #> [2] "acetaminophen 120 MG Inhalation Powder"
    #> [3] "acetaminophen Inhalation Powder"

### Search multiple ingredients

The previous examples have focused on single drug ingredient, acetaminophen. We can though specify multiple ingredients, in which case we will get a codelist back for each.
    
    
    acetaminophen_heparin_codes <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "heparin")
      )
    
    acetaminophen_heparin_codes
    #> 
    #> ── 2 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - 161_acetaminophen (23935 codes)
    #> - 5224_heparin (6981 codes)

And if we don´t specify an ingredient, we will get a codelist for every drug ingredient in the vocabularies!

## ATC based codelists

Analogous to `[getDrugIngredientCodes()](../reference/getDrugIngredientCodes.html)`, `[getATCCodes()](../reference/getATCCodes.html)` can be used to generate a codelist based on a particular ATC class.

With ATC we have five levels of the classification which we could be interested in. The first level is the broadest while the fifth is the narrowest.
    
    
    [availableATC](../reference/availableATC.html)(cdm, level = [c](https://rdrr.io/r/base/c.html)("ATC 1st")) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:14] "ALIMENTARY TRACT AND METABOLISM" ...
    [availableATC](../reference/availableATC.html)(cdm, level = [c](https://rdrr.io/r/base/c.html)("ATC 2nd")) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:94] "STOMATOLOGICAL PREPARATIONS" ...
    [availableATC](../reference/availableATC.html)(cdm, level = [c](https://rdrr.io/r/base/c.html)("ATC 3rd")) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:267] "STOMATOLOGICAL PREPARATIONS" "ANTACIDS" ...
    [availableATC](../reference/availableATC.html)(cdm, level = [c](https://rdrr.io/r/base/c.html)("ATC 4th")) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:890] "Other hematological agents" ...
    [availableATC](../reference/availableATC.html)(cdm, level = [c](https://rdrr.io/r/base/c.html)("ATC 5th")) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:5131] "insulin degludec and insulin aspart; parenteral" ...

In this example, we will produce an ATC level 1 codelist based on Alimentary Tract and Metabolism Drugs.
    
    
    atc_codelist <- [getATCCodes](../reference/getATCCodes.html)(
      cdm = cdm,
      level = "ATC 1st",
      name = "alimentary tract and metabolism"
    )
    
    atc_codelist
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - A_alimentary_tract_and_metabolism (211265 codes)

Similarly as with `[getDrugIngredientCodes()](../reference/getDrugIngredientCodes.html)`, we can use `nameStyle` to specify the name of the elements in the list, `type` argument to obtain a codelist with details, the `doseForm` argument to restrict to specific dose forms, the `doseUnit` argument to restrict to specific dose unit, and the `routeCategory` argument to restrict to specific route categories.

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/articles/a04b_icd_codes.html

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

# Generating vocabulary based codelists for conditions

`a04b_icd_codes.Rmd`

## Introduction: Creating a vocabulary-based codelist for conditions

In this vignette, we will explore how to generate codelists for conditions using the OMOP CDM vocabulary tables. We should note at the start that there are many more caveats with creating conditions codelists based on vocabularies compared to medications. In particular hierarchies to group medications are a lot more black and white than with conditions. With that being said we can generate some vocabulary based codelists for conditions. For this we will use ICD10 as the foundation for grouping condition-related codes.

To begin, let’s load the necessary packages and create a cdm reference using Eunomia mock data.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    # Connect to the database and create the cdm object
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                     [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                      cdmName = "Eunomia Synpuf",
                      cdmSchema = "main",
                      writeSchema = "main",
                      achillesSchema = "main")

We can see that our ICD10 codes come at four different levels of granularity, with chapters the broadest and codes the narrowest.
    
    
    [availableICD10](../reference/availableICD10.html)(cdm, level = "ICD10 Chapter") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:22] "Certain infectious and parasitic diseases" "Neoplasms" ...
    [availableICD10](../reference/availableICD10.html)(cdm, level = "ICD10 SubChapter") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:274] "Intestinal infectious diseases" "Tuberculosis" ...
    [availableICD10](../reference/availableICD10.html)(cdm, level = "ICD10 Hierarchy") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:2093] "Other salmonella infections" ...
    [availableICD10](../reference/availableICD10.html)(cdm, level = "ICD10 Code") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  chr [1:14130] "Enteropathogenic Escherichia coli infection" ...

## ICD10 chapter codelists

We can use `[getICD10StandardCodes()](../reference/getICD10StandardCodes.html)` to generate condition codelists based on ICD10 chapters. As ICD10 is a non-standard vocabulary in the OMOP CDM, this function returns standard concepts associated with these ICD10 chapters and subchapters directly via a mapping from them or indirectly from being a descendant concept of a code that is mapped from them. It is important to note that `[getICD10StandardCodes()](../reference/getICD10StandardCodes.html)` will only return results if the ICD codes are included in the vocabulary tables.

We can start by getting a codelist for each of the chapters. For each of these our result will be the standard OMOP CDM concepts. So, as ICD10 is non-standard, we’ll first identify ICD10 codes of interest and then map across to their standard equivalents (using the concept relationship table).
    
    
    icd_chapters <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(cdm = cdm,
                                          level = "ICD10 Chapter")
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    icd_chapters |> [length](https://rdrr.io/r/base/length.html)()
    #> [1] 22
    icd_chapters
    #> 
    #> ── 22 codelists ────────────────────────────────────────────────────────────────
    #> 
    #> - i_certain_infectious_and_parasitic_diseases (65191 codes)
    #> - ii_neoplasms (16262 codes)
    #> - iii_diseases_of_the_blood_and_blood_forming_organs_and_certain_disorders_involving_the_immune_mechanism (6604 codes)
    #> - iv_endocrine_nutritional_and_metabolic_diseases (13483 codes)
    #> - ix_diseases_of_the_circulatory_system (38407 codes)
    #> - v_mental_and_behavioural_disorders (4602 codes)
    #> along with 16 more codelists

Instead of getting all of the chapters, we could instead specify one of interest. Here, for example, we will try to generate a codelist for mental and behavioural disorders (ICD chapter V).
    
    
    mental_and_behavioural_disorders <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "Mental and behavioural disorders",
      level = "ICD10 Chapter"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    mental_and_behavioural_disorders
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - v_mental_and_behavioural_disorders (4602 codes)

## ICD10 subchapter codelists

Instead of the chapter level, we could instead use ICD10 sub-chapters. Again we can get codelists for all sub-chapters, and we’ll have many more than at the chapter level.
    
    
    icd_subchapters <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      level = "ICD10 SubChapter"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    icd_subchapters |> [length](https://rdrr.io/r/base/length.html)()
    #> [1] 260
    icd_subchapters
    #> 
    #> ── 260 codelists ───────────────────────────────────────────────────────────────
    #> 
    #> - a00_a09_intestinal_infectious_diseases (1532 codes)
    #> - a15_a19_tuberculosis (440 codes)
    #> - a20_a28_certain_zoonotic_bacterial_diseases (5891 codes)
    #> - a30_a49_other_bacterial_diseases (4324 codes)
    #> - a50_a64_infections_with_a_predominantly_sexual_mode_of_transmission (11944 codes)
    #> - a65_a69_other_spirochaetal_diseases (490 codes)
    #> along with 254 more codelists

Or again we could specify particular sub-chapters of interest. Here we’ll get codes for Mood [affective] disorders (ICD10 F30-F39).
    
    
    mood_affective_disorders <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "Mood [affective] disorders", 
      level = "ICD10 SubChapter"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    mood_affective_disorders
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - f30_f39_mood_affective_disorders (822 codes)

## ICD10 hierarchy codelists

We can move one level below and get codelists for all the hierarchy codes. Again we’ll have more granularity and many more codes.
    
    
    icd_hierarchy <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      level = "ICD10 Hierarchy"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    icd_hierarchy |> [length](https://rdrr.io/r/base/length.html)()
    #> [1] 1588
    icd_hierarchy
    #> 
    #> ── 1588 codelists ──────────────────────────────────────────────────────────────
    #> 
    #> - a00_cholera (7 codes)
    #> - a01_typhoid_and_paratyphoid_fevers (11 codes)
    #> - a02_other_salmonella_infections (42 codes)
    #> - a03_shigellosis (11 codes)
    #> - a04_other_bacterial_intestinal_infections (48 codes)
    #> - a05_other_bacterial_foodborne_intoxications_not_elsewhere_classified (22 codes)
    #> along with 1582 more codelists

And we can get codes for Persistent mood [affective] disorders (ICD10 F34).
    
    
    persistent_mood_affective_disorders   <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "Persistent mood [affective] disorders", 
      level = "ICD10 Hierarchy"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    persistent_mood_affective_disorders
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - f34_persistent_mood_affective_disorders (374 codes)

## ICD10 code codelists

Our last option for level is the most granular, the ICD10 code. Now we’ll get even more codelists.
    
    
    icd_code <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      level = "ICD10 Code"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    icd_code |> [length](https://rdrr.io/r/base/length.html)()
    #> [1] 13723
    icd_hierarchy
    #> 
    #> ── 1588 codelists ──────────────────────────────────────────────────────────────
    #> 
    #> - a00_cholera (7 codes)
    #> - a01_typhoid_and_paratyphoid_fevers (11 codes)
    #> - a02_other_salmonella_infections (42 codes)
    #> - a03_shigellosis (11 codes)
    #> - a04_other_bacterial_intestinal_infections (48 codes)
    #> - a05_other_bacterial_foodborne_intoxications_not_elsewhere_classified (22 codes)
    #> along with 1582 more codelists

And now we could create a codelist just for dysthymia.
    
    
    dysthymia   <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "dysthymia", 
      level = "ICD10 Code"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    dysthymia
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - f341_dysthymia (10 codes)

## Additional options

As well as different ICD10 levels we have some more options when creating these codelists.

### Include descendants

By default when we map from ICD10 to standard codes we will also include the descendants of the standard code. We can instead just return the direct mappings themselves without descendants.
    
    
    dysthymia_descendants <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "dysthymia", 
      level = "ICD10 Code",
      includeDescendants = TRUE
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    dysthymia_descendants
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - f341_dysthymia (10 codes)
    
    dysthymia_no_descendants <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "dysthymia", 
      level = "ICD10 Code",
      includeDescendants = FALSE
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    dysthymia_no_descendants
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - f341_dysthymia (1 codes)

Unsurprisingly when we include descendants we’ll include additional codes.
    
    
    [compareCodelists](../reference/compareCodelists.html)(dysthymia_no_descendants, 
                     dysthymia_descendants) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(codelist == "Both") |> 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("concept_id")
    #> [1] 433440
    
    [compareCodelists](../reference/compareCodelists.html)(dysthymia_no_descendants, 
                     dysthymia_descendants) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(codelist == "Only codelist 2") |> 
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("concept_id")
    #> [1] 4307951 4057218 4096229 4150047 4336980 4195680 4263770 4224639 4243308

### Name style

By default we’ll get back a list with name styled as `"{concept_code}_{concept_name}"`. We could though instead use only the concept name for naming our codelists.
    
    
    dysthymia <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "dysthymia", 
      level = "ICD10 Code",
      nameStyle = "{concept_name}"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    dysthymia
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - dysthymia (10 codes)

### Codelist or codelist with details

Lastly, we have flexibility about the type of object returned. By default we’ll have a codelist with just concept IDs of interest. But we could instead get these with additional information such as their name, vocabulary, and so on.
    
    
    dysthymia <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "dysthymia", 
      level = "ICD10 Code",
      type = "codelist"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    dysthymia[[1]] |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #>  int [1:10] 4307951 4057218 4096229 4150047 4336980 4195680 4263770 4224639 433440 4243308
    
    
    dysthymia <- [getICD10StandardCodes](../reference/getICD10StandardCodes.html)(
      cdm = cdm,
      name = "dysthymia", 
      level = "ICD10 Code",
      type = "codelist_with_details"
    )
    #> Getting non-standard ICD10 concepts
    #> Mapping from non-standard to standard concepts
    #> Getting descendant concepts
    dysthymia[[1]] |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 10
    #> Columns: 6
    #> $ name          <chr> "f341_dysthymia", "f341_dysthymia", "f341_dysthymia", "f…
    #> $ concept_id    <int> 4057218, 4336980, 4096229, 4150047, 4195680, 4224639, 42…
    #> $ concept_code  <chr> "19694002", "87842000", "2506003", "3109008", "67711008"…
    #> $ concept_name  <chr> "Late onset dysthymia", "Generalized neuromuscular exhau…
    #> $ domain_id     <chr> "Condition", "Condition", "Condition", "Condition", "Con…
    #> $ vocabulary_id <chr> "SNOMED", "SNOMED", "SNOMED", "SNOMED", "SNOMED", "SNOME…

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/articles/a05_ExtractCodelistFromJSONfile.html

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

# Extract codelists from JSON files

`a05_ExtractCodelistFromJSONfile.Rmd`

## Extracting codelists from JSON files

In this vignette, we will explore the functions that help us to generate codelists from JSON files. There are two main types of JSON files we can work with:

  * _Concept sets_ : These files usually contain a set of concepts that are grouped together based on a common definition or a clinical meaning. Each concept set may include inclusion/exclusion rules, descendants, and mapping criteria to define the exact scope of concepts included.
  * _Cohorts_ : These files define cohorts, which are groups of individuals meeting specific criteria for inclusion in a study. The cohort definitions also include embedded concept sets, logic criteria, time windows, and other metadata needed for cohort construction.



In the following sections, we will explore how to use specific functions to extract the codelists generated by these two type of JSON files. Specifically, we will delve into:

  * `[codesFromConceptSet()](../reference/codesFromConceptSet.html)`: to extract concept IDs directly from a concept set JSON.
  * `[codesFromCohort()](../reference/codesFromCohort.html)`: to extract concept IDs from the concept sets embedded within a cohort definition JSON.



Hence, we will start by loading the necessary packages, creating a mock cdm, and saving the mock json files we are going to use to reproduce the example.
    
    
    # Loading necessary files
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([jsonlite](https://jeroen.r-universe.dev/jsonlite))
    
    # Creating mock cdm
    cdm <- [mockVocabRef](../reference/mockVocabRef.html)()
    
    # Reading mock json files
    arthritis_desc <- [fromJSON](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)([system.file](https://rdrr.io/r/base/system.file.html)("concepts_for_mock/arthritis_desc.json", package = "CodelistGenerator")) |> [toJSON](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)(pretty = TRUE, auto_unbox = TRUE)
    arthritis_no_desc <- [fromJSON](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)([system.file](https://rdrr.io/r/base/system.file.html)("concepts_for_mock/arthritis_no_desc.json", package = "CodelistGenerator")) |> [toJSON](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)(pretty = TRUE, auto_unbox = TRUE)
    arthritis_with_excluded <- [fromJSON](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)([system.file](https://rdrr.io/r/base/system.file.html)("concepts_for_mock/arthritis_with_excluded.json", package = "CodelistGenerator")) |> [toJSON](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)(pretty = TRUE, auto_unbox = TRUE)
    arthritis_desc_cohort <- [fromJSON](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)([system.file](https://rdrr.io/r/base/system.file.html)("cohorts_for_mock/oa_desc.json", package = "CodelistGenerator")) |> [toJSON](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)(pretty = TRUE, auto_unbox = TRUE)

Bear in mind that the structure of the vocabulary in our mock cdm is the following ![](Figures%2F1.png)

## Codes from concept sets JSON files

Now, we are going to extract the concept ids provided a concept set JSON file
    
    
    concepts <- [codesFromConceptSet](../reference/codesFromConceptSet.html)(cdm, 
                        path =  [system.file](https://rdrr.io/r/base/system.file.html)(package = "CodelistGenerator","concepts_for_mock"),
                        type = "codelist_with_details")

Notice that we have used the argument `type` to define the output as `codelist_with_details`, but we could also obtain a simple `codelist`. Let’s have a look at the codelist we have just upload, which contain a set of concept ids to define **arthritis** :
    
    
    concepts
    #> 
    #> ── 3 codelists with details ────────────────────────────────────────────────────
    #> 
    #> - arthritis_desc (3 codes)
    #> - arthritis_no_desc (1 codes)
    #> - arthritis_with_excluded (2 codes)

### Include descendants

Let’s have a look at the first json file, named “arthritis_desc”
    
    
    arthritis_desc
    #> {
    #>   "items": [
    #>     {
    #>       "concept": {
    #>         "CONCEPT_ID": 3
    #>       },
    #>       "isExcluded": false,
    #>       "includeDescendants": true,
    #>       "includeMapped": false
    #>     }
    #>   ]
    #> }

Notice that in this codelist, we have `concept_id=3` and `includeDescendants=TRUE`, so the final codelist we have obtained using `[codesFromConceptSet()](../reference/codesFromConceptSet.html)` is
    
    
    concepts$arthritis_desc
    #> # A tibble: 3 × 5
    #>   concept_id concept_name           domain_id vocabulary_id standard_concept
    #>        <int> <chr>                  <chr>     <chr>         <chr>           
    #> 1          3 Arthritis              Condition SNOMED        standard        
    #> 2          5 Osteoarthritis of hip  Condition SNOMED        standard        
    #> 3          4 Osteoarthritis of knee Condition SNOMED        standard

Note that `cdm` is one of the arguments because it is used to get the descendants (if needed) the result can vary `cdm` to `cdm` if different vocabulary versions are used.

### Exclude descendants

If descendants are set to exclude in the json file, the function will not provide the descendants:
    
    
    arthritis_no_desc
    #> {
    #>   "items": [
    #>     {
    #>       "concept": {
    #>         "CONCEPT_ID": 3
    #>       },
    #>       "isExcluded": false,
    #>       "includeDescendants": false,
    #>       "includeMapped": false
    #>     }
    #>   ]
    #> }
    
    concepts$arthritis_no_desc
    #> # A tibble: 1 × 5
    #>   concept_id concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>        <chr>     <chr>         <chr>           
    #> 1          3 Arthritis    Condition SNOMED        standard

### Exclude concepts

It can be that the json file specifies concepts that must be excluded. This will also be taken into account when creating the final codelist using `[codesFromConceptSet()](../reference/codesFromConceptSet.html)`:
    
    
    arthritis_with_excluded
    #> {
    #>   "items": [
    #>     {
    #>       "concept": {
    #>         "CONCEPT_ID": 3
    #>       },
    #>       "isExcluded": false,
    #>       "includeDescendants": true,
    #>       "includeMapped": false
    #>     },
    #>     {
    #>       "concept": {
    #>         "CONCEPT_ID": 4
    #>       },
    #>       "isExcluded": true,
    #>       "includeDescendants": false,
    #>       "includeMapped": false
    #>     }
    #>   ]
    #> }
    
    concepts$arthritis_with_excluded
    #> # A tibble: 2 × 5
    #>   concept_id concept_name          domain_id vocabulary_id standard_concept
    #>        <int> <chr>                 <chr>     <chr>         <chr>           
    #> 1          3 Arthritis             Condition SNOMED        standard        
    #> 2          5 Osteoarthritis of hip Condition SNOMED        standard

## Codes from cohort JSON files

Now, we are going to extract the concept ids provided a cohort JSON file. To do that, we just need to provide the path where we saved the json files:
    
    
    concepts <- [codesFromCohort](../reference/codesFromCohort.html)(cdm, 
                        path =  [system.file](https://rdrr.io/r/base/system.file.html)(package = "CodelistGenerator","cohorts_for_mock"),
                        type = "codelist_with_details")
    concepts <- [newCodelistWithDetails](https://darwin-eu.github.io/omopgenerics/reference/newCodelistWithDetails.html)([list](https://rdrr.io/r/base/list.html)("arthritis" = concepts$arthritis))

Let’s have a look at the codelist we have just upload:
    
    
    arthritis_desc_cohort
    #> {
    #>   "ConceptSets": [
    #>     {
    #>       "id": 0,
    #>       "name": "arthritis",
    #>       "expression": {
    #>         "items": [
    #>           {
    #>             "concept": {
    #>               "CONCEPT_CLASS_ID": "Clinical Finding",
    #>               "CONCEPT_CODE": "396275006",
    #>               "CONCEPT_ID": 3,
    #>               "CONCEPT_NAME": "Arthritis",
    #>               "DOMAIN_ID": "Condition",
    #>               "INVALID_REASON": "V",
    #>               "INVALID_REASON_CAPTION": "Valid",
    #>               "STANDARD_CONCEPT": "S",
    #>               "STANDARD_CONCEPT_CAPTION": "Standard",
    #>               "VOCABULARY_ID": "SNOMED"
    #>             },
    #>             "includeDescendants": true
    #>           }
    #>         ]
    #>       }
    #>     },
    #>     {
    #>       "id": 1,
    #>       "name": "Other",
    #>       "expression": {
    #>         "items": [
    #>           {
    #>             "concept": {
    #>               "CONCEPT_CLASS_ID": "Clinical Finding",
    #>               "CONCEPT_CODE": "422504002",
    #>               "CONCEPT_ID": 5,
    #>               "CONCEPT_NAME": "Osteoarthritis of hip",
    #>               "DOMAIN_ID": "Condition",
    #>               "INVALID_REASON": "V",
    #>               "INVALID_REASON_CAPTION": "Valid",
    #>               "STANDARD_CONCEPT": "S",
    #>               "STANDARD_CONCEPT_CAPTION": "Standard",
    #>               "VOCABULARY_ID": "SNOMED"
    #>             }
    #>           }
    #>         ]
    #>       }
    #>     }
    #>   ],
    #>   "PrimaryCriteria": {
    #>     "CriteriaList": [
    #>       {
    #>         "ConditionOccurrence": {
    #>           "CodesetId": 0
    #>         },
    #>         "Observation": {}
    #>       },
    #>       {
    #>         "ConditionOccurrence": {},
    #>         "Observation": {
    #>           "CodesetId": 0
    #>         }
    #>       },
    #>       {
    #>         "ConditionOccurrence": {
    #>           "CodesetId": 1
    #>         },
    #>         "Observation": {}
    #>       }
    #>     ],
    #>     "ObservationWindow": {
    #>       "PriorDays": 0,
    #>       "PostDays": 0
    #>     },
    #>     "PrimaryCriteriaLimit": {
    #>       "Type": "First"
    #>     }
    #>   },
    #>   "QualifiedLimit": {
    #>     "Type": "First"
    #>   },
    #>   "ExpressionLimit": {
    #>     "Type": "First"
    #>   },
    #>   "InclusionRules": [],
    #>   "CensoringCriteria": [],
    #>   "CollapseSettings": {
    #>     "CollapseType": "ERA",
    #>     "EraPad": 0
    #>   },
    #>   "CensorWindow": {},
    #>   "cdmVersionRange": ">=5.0.0"
    #> }
    
    concepts$arthritis
    #> # A tibble: 3 × 5
    #>   concept_id concept_name           domain_id vocabulary_id standard_concept
    #>        <int> <chr>                  <chr>     <chr>         <chr>           
    #> 1          3 Arthritis              Condition SNOMED        standard        
    #> 2          5 Osteoarthritis of hip  Condition SNOMED        standard        
    #> 3          4 Osteoarthritis of knee Condition SNOMED        standard

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/articles/a06_CreateSubsetsFromCodelist.html

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

# Compare, subset or stratify codelists

`a06_CreateSubsetsFromCodelist.Rmd`

## Introduction: Generate codelist subsets, exploring codelist utility functions

This vignette introduces a set of functions designed to manipulate and explore codelists within an OMOP CDM. Specifically, we will learn how to:

  * **Subset a codelist** to keep only codes meeting a certain criteria.
  * **Stratify a codelist** based on attributes like dose unit or route of administration.
  * **Compare two codelists** to identify shared and unique concepts.



First of all, we will load the required packages and connect to a mock database.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    # Connect to the database and create the cdm object
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                      cdmName = "Eunomia Synpuf",
                      cdmSchema   = "main",
                      writeSchema = "main", 
                      achillesSchema = "main")

We will start by generating a codelist for _acetaminophen_ using `[getDrugIngredientCodes()](../reference/getDrugIngredientCodes.html)`
    
    
    acetaminophen <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(cdm,
                                            name = "acetaminophen",
                                            nameStyle = "{concept_name}",
                                            type = "codelist")

### Subsetting a Codelist

Subsetting a codelist will allow us to reduce a codelist to only those concepts that meet certain conditions.

#### Subset to Codes in Use

This function keeps only those codes observed in the database with at least a specified frequency (`minimumCount`) and in the table specified (`table`). Note that this function depends on ACHILLES tables being available in your CDM object.
    
    
    acetaminophen_in_use <- [subsetToCodesInUse](../reference/subsetToCodesInUse.html)(x = acetaminophen, 
                                               cdm, 
                                               minimumCount = 0,
                                               table = "drug_exposure")
    acetaminophen_in_use # Only the first 5 concepts will be shown
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (228 codes)

#### Subset by Domain

We will now subset to those concepts that have `domain = "Drug"`. Remember that, to see the domains available in the cdm, you can use `getDomains(cdm)`.
    
    
    acetaminophen_drug <- [subsetOnDomain](../reference/subsetOnDomain.html)(acetaminophen_in_use, cdm, domain = "Drug")
    
    acetaminophen_drug
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (228 codes)

We can use the `negate` argument to exclude concepts with a certain domain:
    
    
    acetaminophen_no_drug <- [subsetOnDomain](../reference/subsetOnDomain.html)(acetaminophen_in_use, cdm, domain = "Drug", negate = TRUE)
    
    acetaminophen_no_drug
    #> 
    #> ── 0 codelists ─────────────────────────────────────────────────────────────────

#### Subset on Dose Unit

We will now filter to only include concepts with specified dose units. Remember that you can use `getDoseUnit(cdm)` to explore the dose units available in your cdm.
    
    
    acetaminophen_mg_unit <- [subsetOnDoseUnit](../reference/subsetOnDoseUnit.html)(acetaminophen_drug, cdm, [c](https://rdrr.io/r/base/c.html)("milligram", "unit"))
    acetaminophen_mg_unit
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (228 codes)

As before, we can use argument `negate = TRUE` to exclude instead.

#### Subset on route category

We will now subset to those concepts that do not have an “unclassified_route” or “transmucosal_rectal”:
    
    
    acetaminophen_route <- [subsetOnRouteCategory](../reference/subsetOnRouteCategory.html)(acetaminophen_mg_unit, 
                                                 cdm, [c](https://rdrr.io/r/base/c.html)("transmucosal_rectal","unclassified_route"), 
                                                 negate = TRUE)
    acetaminophen_route
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (221 codes)

### Stratify codelist

Instead of filtering, stratification allows us to split a codelist into subgroups based on defined vocabulary properties.

#### Stratify by Dose Unit
    
    
    acetaminophen_doses <- [stratifyByDoseUnit](../reference/stratifyByDoseUnit.html)(acetaminophen, cdm, keepOriginal = TRUE)
    
    acetaminophen_doses
    #> 
    #> ── 4 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen (23935 codes)
    #> - acetaminophen_milligram (22256 codes)
    #> - acetaminophen_unit (1 codes)
    #> - acetaminophen_unkown_dose_unit (1679 codes)

#### Stratify by Route Category
    
    
    acetaminophen_routes <- [stratifyByRouteCategory](../reference/stratifyByRouteCategory.html)(acetaminophen, cdm)
    
    acetaminophen_routes
    #> 
    #> ── 6 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - acetaminophen_inhalable (3 codes)
    #> - acetaminophen_injectable (689 codes)
    #> - acetaminophen_oral (17219 codes)
    #> - acetaminophen_topical (6 codes)
    #> - acetaminophen_transmucosal_rectal (1459 codes)
    #> - acetaminophen_unclassified_route (4559 codes)

### Compare codelists

Now we will compare two codelists to identify overlapping and unique codes.
    
    
    acetaminophen <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(cdm, 
                                               name = "acetaminophen", 
                                               nameStyle = "{concept_name}",
                                               type = "codelist_with_details")
    hydrocodone <- [getDrugIngredientCodes](../reference/getDrugIngredientCodes.html)(cdm, 
                                          name = "hydrocodone", 
                                          doseUnit = "milligram", 
                                          nameStyle = "{concept_name}",
                                          type = "codelist_with_details")

Compare the two sets:
    
    
    comparison <- [compareCodelists](../reference/compareCodelists.html)(acetaminophen$acetaminophen, hydrocodone$hydrocodone)
    
    comparison |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 25,469
    #> Columns: 5
    #> $ concept_id   <int> 1124009, 1125315, 1125320, 1125321, 1125357, 1125358, 112…
    #> $ concept_name <chr> "acetaminophen 635 MG / phenyltoloxamine citrate 55 MG Or…
    #> $ codelist_1   <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ codelist_2   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ codelist     <chr> "Only codelist 1", "Only codelist 1", "Only codelist 1", …
    
    comparison |> [filter](https://dplyr.tidyverse.org/reference/filter.html)(codelist == "Both")
    #> # A tibble: 253 × 5
    #>    concept_id concept_name                        codelist_1 codelist_2 codelist
    #>         <int> <chr>                                    <dbl>      <dbl> <chr>   
    #>  1    1129026 acetaminophen 500 MG / hydrocodone…          1          1 Both    
    #>  2   40002683 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #>  3   40002684 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #>  4   40002685 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #>  5   40002686 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #>  6   40002687 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #>  7   40002688 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #>  8   40002689 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #>  9   40002690 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #> 10   40002691 acetaminophen / hydrocodone Oral C…          1          1 Both    
    #> # ℹ 243 more rows

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/articles/a07_RunCodelistDiagnostics.html

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

# Codelist diagnostics

`a07_RunCodelistDiagnostics.Rmd`

This vignette presents a set of functions to explore the use of codes in a codelist. We will cover the following key functions:

  * `[summariseAchillesCodeUse()](../reference/summariseAchillesCodeUse.html)`: Summarises the code use using ACHILLES tables.
  * `[summariseCodeUse()](../reference/summariseCodeUse.html)`: Summarises the code use in patient-level data.
  * `[summariseOrphanCodes()](../reference/summariseOrphanCodes.html)`: Identifies orphan codes related to a codelist using ACHILLES tables.
  * `[summariseUnmappedCodes()](../reference/summariseUnmappedCodes.html)`: Identifies unmapped concepts related to the codelist.
  * `[summariseCohortCodeUse()](../reference/summariseCohortCodeUse.html)`: Evaluates codelist usage within a cohort.



Let’s start by loading the required packages, connecting to a mock database, and generating a codelist for example purposes. We’ll use `[getCandidateCodes()](../reference/getCandidateCodes.html)` to find our codes.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    # Connect to the database and create the cdm object
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                      cdmName = "Eunomia Synpuf",
                      cdmSchema   = "main",
                      writeSchema = "main", 
                      achillesSchema = "main")
    
    # Create a codelist for depression
    depression <- [getCandidateCodes](../reference/getCandidateCodes.html)(cdm,
                                    keywords = "depression")
    depression <- [list](https://rdrr.io/r/base/list.html)("depression" = depression$concept_id)

## Running Diagnostics in a Codelist

### Summarise Code Use Using ACHILLES Tables

This function uses ACHILLES summary tables to count the number of records and persons associated with each concept in a codelist. Notice that it requires that ACHILLES tables are available in the CDM.
    
    
    achilles_code_use <- [summariseAchillesCodeUse](../reference/summariseAchillesCodeUse.html)(depression, 
                                                  cdm, 
                                                  countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"))

From this, we will obtain a [summarised result](https://darwin-eu.github.io/omopgenerics/articles/summarised_result.html) object. We can easily visualise the results using `[tableAchillesCodeUse()](../reference/tableAchillesCodeUse.html)`:
    
    
    [tableAchillesCodeUse](../reference/tableAchillesCodeUse.html)(achilles_code_use,
                         type = "gt")

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Domain ID | Standard concept name | Standard concept ID | Standard concept | Vocabulary ID |  Estimate name  
Record count | Person count  
depression | condition | Arteriosclerotic dementia with depression | 374326 | standard | SNOMED | 19 | 11  
|  | Presenile dementia with depression | 377527 | standard | SNOMED | 10 | 10  
|  | Senile dementia with depression | 379784 | standard | SNOMED | 21 | 18  
|  | Severe bipolar II disorder, most recent episode major depressive, in partial remission | 4283219 | standard | SNOMED | 10 | 10  
|  | Recurrent major depressive episodes | 432285 | standard | SNOMED | 60 | 41  
|  | Recurrent major depressive episodes, moderate | 432883 | standard | SNOMED | 203 | 88  
|  | Recurrent major depressive episodes, severe, with psychosis | 434911 | standard | SNOMED | 61 | 31  
|  | Bipolar affective disorder, currently depressed, moderate | 437528 | standard | SNOMED | 11 | 9  
|  | Severe major depression, single episode, with psychotic features | 438406 | standard | SNOMED | 10 | 9  
|  | Recurrent major depressive episodes, mild | 438998 | standard | SNOMED | 27 | 24  
|  | Bipolar affective disorder, currently depressed, in full remission | 439251 | standard | SNOMED | 13 | 13  
|  | Bipolar affective disorder, currently depressed, mild | 439253 | standard | SNOMED | 16 | 16  
|  | Severe major depression, single episode, without psychotic features | 441534 | standard | SNOMED | 25 | 18  
  
Notice that concepts with zero counts will not appear in the result table.

## Summarise Code Use Using Patient-Level Data

This function performs a similar task as above but directly queries patient-level data, making it usable even if ACHILLES tables are not available. It can be configured to stratify results by concept (`byConcept`), by year (`byYear`), by sex (`bySex`), or by age group (`byAgeGroup`). We can further specify a specific time period (`dateRange`).
    
    
    code_use <- [summariseCodeUse](../reference/summariseCodeUse.html)(depression,
                                 cdm,
                                 countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"),
                                 byYear  = FALSE,
                                 bySex   = FALSE,
                                 ageGroup =  [list](https://rdrr.io/r/base/list.html)("<=50" = [c](https://rdrr.io/r/base/c.html)(0,50), ">50" = [c](https://rdrr.io/r/base/c.html)(51,Inf)),
                                 dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2020-01-01")))
    
    [tableCodeUse](../reference/tableCodeUse.html)(code_use, type = "gt")

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Age group | Standard concept name | Standard concept ID | Source concept name | Source concept ID | Source concept value | Domain ID | Date range end | Date range start |  Estimate name  
Record count | Person count  
depression | overall | overall | - | NA | NA | NA | NA | 2020-01-01 | 2010-01-01 | 92 | 58  
|  | Severe bipolar II disorder, most recent episode major depressive, in partial remission | 4283219 | Bipolar I disorder, most recent episode (or current) depressed, in partial or unspecified remission | 44820721 | 29655 | condition | 2020-01-01 | 2010-01-01 | 1 | 1  
|  | Severe major depression, single episode, with psychotic features | 438406 | Major depressive affective disorder, single episode, severe, specified as with psychotic behavior | 44820717 | 29624 | condition | 2020-01-01 | 2010-01-01 | 3 | 3  
|  | Bipolar affective disorder, currently depressed, moderate | 437528 | Bipolar I disorder, most recent episode (or current) depressed, moderate | 44835786 | 29652 | condition | 2020-01-01 | 2010-01-01 | 2 | 2  
|  | Recurrent major depressive episodes | 432285 | Major depressive affective disorder, recurrent episode, unspecified | 44831089 | 29630 | condition | 2020-01-01 | 2010-01-01 | 7 | 6  
|  | Bipolar affective disorder, currently depressed, in full remission | 439251 | Bipolar I disorder, most recent episode (or current) depressed, in full remission | 44822977 | 29656 | condition | 2020-01-01 | 2010-01-01 | 3 | 3  
|  | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, severe, without mention of psychotic behavior | 44835785 | 29633 | condition | 2020-01-01 | 2010-01-01 | 15 | 14  
|  | Recurrent major depressive episodes, severe, with psychosis | 434911 | Major depressive affective disorder, recurrent episode, severe, specified as with psychotic behavior | 44827655 | 29634 | condition | 2020-01-01 | 2010-01-01 | 13 | 6  
|  | Presenile dementia with depression | 377527 | Presenile dementia with depressive features | 44836954 | 29013 | condition | 2020-01-01 | 2010-01-01 | 3 | 3  
|  | Severe major depression, single episode, without psychotic features | 441534 | Major depressive affective disorder, single episode, severe, without mention of psychotic behavior | 44835784 | 29623 | condition | 2020-01-01 | 2010-01-01 | 5 | 5  
|  | Arteriosclerotic dementia with depression | 374326 | Vascular dementia, with depressed mood | 44829914 | 29043 | condition | 2020-01-01 | 2010-01-01 | 4 | 2  
|  | Bipolar affective disorder, currently depressed, mild | 439253 | Bipolar I disorder, most recent episode (or current) depressed, mild | 44826500 | 29651 | condition | 2020-01-01 | 2010-01-01 | 2 | 2  
|  | Recurrent major depressive episodes, mild | 438998 | Major depressive affective disorder, recurrent episode, mild | 44829923 | 29631 | condition | 2020-01-01 | 2010-01-01 | 8 | 6  
|  | Senile dementia with depression | 379784 | Senile dementia with depressive features | 44819534 | 29021 | condition | 2020-01-01 | 2010-01-01 | 3 | 3  
|  | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, moderate | 44831090 | 29632 | condition | 2020-01-01 | 2010-01-01 | 23 | 17  
| >50 | overall | - | NA | NA | NA | NA | 2020-01-01 | 2010-01-01 | 82 | 51  
| <=50 | overall | - | NA | NA | NA | NA | 2020-01-01 | 2010-01-01 | 10 | 7  
| >50 | Recurrent major depressive episodes, severe, with psychosis | 434911 | Major depressive affective disorder, recurrent episode, severe, specified as with psychotic behavior | 44827655 | 29634 | condition | 2020-01-01 | 2010-01-01 | 13 | 6  
|  | Severe major depression, single episode, with psychotic features | 438406 | Major depressive affective disorder, single episode, severe, specified as with psychotic behavior | 44820717 | 29624 | condition | 2020-01-01 | 2010-01-01 | 3 | 3  
|  | Presenile dementia with depression | 377527 | Presenile dementia with depressive features | 44836954 | 29013 | condition | 2020-01-01 | 2010-01-01 | 3 | 3  
| <=50 | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, severe, without mention of psychotic behavior | 44835785 | 29633 | condition | 2020-01-01 | 2010-01-01 | 2 | 2  
| >50 | Recurrent major depressive episodes | 432285 | Major depressive affective disorder, recurrent episode, unspecified | 44831089 | 29630 | condition | 2020-01-01 | 2010-01-01 | 6 | 5  
| <=50 | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, moderate | 44831090 | 29632 | condition | 2020-01-01 | 2010-01-01 | 3 | 2  
| >50 | Recurrent major depressive episodes, mild | 438998 | Major depressive affective disorder, recurrent episode, mild | 44829923 | 29631 | condition | 2020-01-01 | 2010-01-01 | 8 | 6  
| <=50 | Recurrent major depressive episodes | 432285 | Major depressive affective disorder, recurrent episode, unspecified | 44831089 | 29630 | condition | 2020-01-01 | 2010-01-01 | 1 | 1  
|  | Severe major depression, single episode, without psychotic features | 441534 | Major depressive affective disorder, single episode, severe, without mention of psychotic behavior | 44835784 | 29623 | condition | 2020-01-01 | 2010-01-01 | 1 | 1  
|  | Bipolar affective disorder, currently depressed, in full remission | 439251 | Bipolar I disorder, most recent episode (or current) depressed, in full remission | 44822977 | 29656 | condition | 2020-01-01 | 2010-01-01 | 1 | 1  
| >50 | Bipolar affective disorder, currently depressed, mild | 439253 | Bipolar I disorder, most recent episode (or current) depressed, mild | 44826500 | 29651 | condition | 2020-01-01 | 2010-01-01 | 2 | 2  
|  | Senile dementia with depression | 379784 | Senile dementia with depressive features | 44819534 | 29021 | condition | 2020-01-01 | 2010-01-01 | 3 | 3  
|  | Severe bipolar II disorder, most recent episode major depressive, in partial remission | 4283219 | Bipolar I disorder, most recent episode (or current) depressed, in partial or unspecified remission | 44820721 | 29655 | condition | 2020-01-01 | 2010-01-01 | 1 | 1  
|  | Arteriosclerotic dementia with depression | 374326 | Vascular dementia, with depressed mood | 44829914 | 29043 | condition | 2020-01-01 | 2010-01-01 | 2 | 1  
|  | Bipolar affective disorder, currently depressed, in full remission | 439251 | Bipolar I disorder, most recent episode (or current) depressed, in full remission | 44822977 | 29656 | condition | 2020-01-01 | 2010-01-01 | 2 | 2  
| <=50 | Arteriosclerotic dementia with depression | 374326 | Vascular dementia, with depressed mood | 44829914 | 29043 | condition | 2020-01-01 | 2010-01-01 | 2 | 1  
| >50 | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, severe, without mention of psychotic behavior | 44835785 | 29633 | condition | 2020-01-01 | 2010-01-01 | 13 | 12  
|  |  |  | Major depressive affective disorder, recurrent episode, moderate | 44831090 | 29632 | condition | 2020-01-01 | 2010-01-01 | 20 | 15  
|  | Severe major depression, single episode, without psychotic features | 441534 | Major depressive affective disorder, single episode, severe, without mention of psychotic behavior | 44835784 | 29623 | condition | 2020-01-01 | 2010-01-01 | 4 | 4  
|  | Bipolar affective disorder, currently depressed, moderate | 437528 | Bipolar I disorder, most recent episode (or current) depressed, moderate | 44835786 | 29652 | condition | 2020-01-01 | 2010-01-01 | 2 | 2  
  
## Identify Orphan Codes

Orphan codes are concepts that might be related to our codelist but that have not been included. It can be used to ensure that we have not missed any important concepts. Notice that this function uses ACHILLES tables.

`[summariseOrphanCodes()](../reference/summariseOrphanCodes.html)` will look for descendants (via _concept_descendants_ table), ancestors (via _concept_ancestor_ table), and concepts related to the codes included in the codelist (via _concept_relationship_ table). Additionally, if the cdm contains PHOEBE tables (_concept_recommended_ table), they will also be used.
    
    
    orphan <- [summariseOrphanCodes](../reference/summariseOrphanCodes.html)(depression, cdm)
    [tableOrphanCodes](../reference/tableOrphanCodes.html)(orphan, type = "gt")

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Domain ID | Standard concept name | Standard concept ID | Standard concept | Vocabulary ID |  Estimate name  
Record count | Person count  
depression | condition | Electrocardiogram abnormal | 320536 | standard | SNOMED | 106 | 95  
|  | Disorder of brain | 372887 | standard | SNOMED | 82 | 61  
|  | Central nervous system complication | 373087 | standard | SNOMED | 3 | 3  
|  | Disorder of the central nervous system | 376106 | standard | SNOMED | 19 | 17  
|  | Presenile dementia | 378125 | standard | SNOMED | 13 | 12  
|  | Cerebrovascular disease | 381591 | standard | SNOMED | 47 | 44  
|  | Emotional state finding | 4025215 | standard | SNOMED | 4 | 4  
|  | General finding of observation of patient | 4041283 | standard | SNOMED | 4 | 4  
|  | Mental disorders during pregnancy, childbirth and the puerperium | 4060424 | standard | SNOMED | 1 | 1  
| procedure | Surgical procedure | 4301351 | standard | SNOMED | 2 | 2  
| condition | Single major depressive episode | 432284 | non-standard | SNOMED | 64 | 45  
|  | Bipolar I disorder | 432876 | standard | SNOMED | 28 | 22  
|  | Single major depressive episode, in full remission | 433750 | non-standard | SNOMED | 7 | 7  
|  | Schizophrenia | 435783 | standard | SNOMED | 52 | 42  
|  | Psychotic disorder | 436073 | standard | SNOMED | 110 | 79  
|  | Bipolar disorder | 436665 | standard | SNOMED | 129 | 83  
|  | Single major depressive episode, mild | 436945 | non-standard | SNOMED | 14 | 12  
|  | Single major depressive episode, moderate | 437837 | non-standard | SNOMED | 27 | 24  
|  | Atypical depressive disorder | 438727 | standard | SNOMED | 9 | 9  
|  | Viral disease | 440029 | standard | SNOMED | 25 | 20  
|  | Recurrent major depressive episodes, in full remission | 440075 | non-standard | SNOMED | 32 | 20  
|  | Depressive disorder | 440383 | standard | SNOMED | 440 | 288  
|  | Anxiety disorder | 442077 | standard | SNOMED | 257 | 189  
  
## Identify Unmapped Codes

This function identifies codes that are conceptually linked to the codelist but that are not mapped.
    
    
    unmapped <- [summariseUnmappedCodes](../reference/summariseUnmappedCodes.html)(depression, cdm)
    [tableUnmappedCodes](../reference/tableUnmappedCodes.html)(unmapped, type = "gt")
    #> # A tibble: 0 × 0

## Run Diagnostics within a Cohort

You can also evaluate how the codelist is used within a specific cohort. First, we will define a cohort using the `[conceptCohort()](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)` function from CohortConstructor package.
    
    
    cdm[["depression"]] <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm, 
                                         conceptSet = depression, 
                                         name = "depression")

Then, we can summarise the code use within this cohort:
    
    
    cohort_code_use <- [summariseCohortCodeUse](../reference/summariseCohortCodeUse.html)(depression, 
                                              cdm,
                                              cohortTable = "depression",
                                              countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"))
    [tableCohortCodeUse](../reference/tableCohortCodeUse.html)(cohort_code_use)

|  Database name  
---|---  
|  Eunomia Synpuf  
Cohort name | Codelist name | Standard concept name | Standard concept ID | Source concept name | Source concept ID | Source concept value | Domain ID |  Estimate name  
Person count | Record count  
depression | depression | Arteriosclerotic dementia with depression | 374326 | Vascular dementia, with depressed mood | 44829914 | 29043 | condition | 11 | 52  
|  | Bipolar affective disorder, currently depressed, in full remission | 439251 | Bipolar I disorder, most recent episode (or current) depressed, in full remission | 44822977 | 29656 | condition | 13 | 48  
|  | Bipolar affective disorder, currently depressed, mild | 439253 | Bipolar I disorder, most recent episode (or current) depressed, mild | 44826500 | 29651 | condition | 16 | 53  
|  | Bipolar affective disorder, currently depressed, moderate | 437528 | Bipolar I disorder, most recent episode (or current) depressed, moderate | 44835786 | 29652 | condition | 9 | 32  
|  | Presenile dementia with depression | 377527 | Presenile dementia with depressive features | 44836954 | 29013 | condition | 10 | 24  
|  | Recurrent major depressive episodes | 432285 | Major depressive affective disorder, recurrent episode, unspecified | 44831089 | 29630 | condition | 41 | 160  
|  | Recurrent major depressive episodes, mild | 438998 | Major depressive affective disorder, recurrent episode, mild | 44829923 | 29631 | condition | 24 | 96  
|  | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, moderate | 44831090 | 29632 | condition | 48 | 341  
|  |  |  | Major depressive affective disorder, recurrent episode, severe, without mention of psychotic behavior | 44835785 | 29633 | condition | 53 | 432  
|  | Recurrent major depressive episodes, severe, with psychosis | 434911 | Major depressive affective disorder, recurrent episode, severe, specified as with psychotic behavior | 44827655 | 29634 | condition | 31 | 276  
|  | Senile dementia with depression | 379784 | Senile dementia with depressive features | 44819534 | 29021 | condition | 18 | 48  
|  | Severe bipolar II disorder, most recent episode major depressive, in partial remission | 4283219 | Bipolar I disorder, most recent episode (or current) depressed, in partial or unspecified remission | 44820721 | 29655 | condition | 10 | 25  
|  | Severe major depression, single episode, with psychotic features | 438406 | Major depressive affective disorder, single episode, severe, specified as with psychotic behavior | 44820717 | 29624 | condition | 9 | 38  
|  | Severe major depression, single episode, without psychotic features | 441534 | Major depressive affective disorder, single episode, severe, without mention of psychotic behavior | 44835784 | 29623 | condition | 18 | 77  
|  | overall | - | NA | NA | NA | NA | 182 | 1,702  
  
### Summarise Code Use at Cohort Entry

Use the `timing` argument to restrict diagnostics to codes used at the entry date of the cohort.
    
    
    cohort_code_use <- [summariseCohortCodeUse](../reference/summariseCohortCodeUse.html)(depression, 
                                              cdm,
                                              cohortTable = "depression",
                                              countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"),
                                              timing = "entry")
    [tableCohortCodeUse](../reference/tableCohortCodeUse.html)(cohort_code_use)

|  Database name  
---|---  
|  Eunomia Synpuf  
Cohort name | Codelist name | Standard concept name | Standard concept ID | Source concept name | Source concept ID | Source concept value | Domain ID |  Estimate name  
Person count | Record count  
depression | depression | Arteriosclerotic dementia with depression | 374326 | Vascular dementia, with depressed mood | 44829914 | 29043 | condition | 11 | 19  
|  | Bipolar affective disorder, currently depressed, in full remission | 439251 | Bipolar I disorder, most recent episode (or current) depressed, in full remission | 44822977 | 29656 | condition | 13 | 13  
|  | Bipolar affective disorder, currently depressed, mild | 439253 | Bipolar I disorder, most recent episode (or current) depressed, mild | 44826500 | 29651 | condition | 16 | 16  
|  | Bipolar affective disorder, currently depressed, moderate | 437528 | Bipolar I disorder, most recent episode (or current) depressed, moderate | 44835786 | 29652 | condition | 9 | 11  
|  | Presenile dementia with depression | 377527 | Presenile dementia with depressive features | 44836954 | 29013 | condition | 10 | 10  
|  | Recurrent major depressive episodes | 432285 | Major depressive affective disorder, recurrent episode, unspecified | 44831089 | 29630 | condition | 41 | 60  
|  | Recurrent major depressive episodes, mild | 438998 | Major depressive affective disorder, recurrent episode, mild | 44829923 | 29631 | condition | 24 | 27  
|  | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, moderate | 44831090 | 29632 | condition | 48 | 85  
|  |  |  | Major depressive affective disorder, recurrent episode, severe, without mention of psychotic behavior | 44835785 | 29633 | condition | 53 | 118  
|  | Recurrent major depressive episodes, severe, with psychosis | 434911 | Major depressive affective disorder, recurrent episode, severe, specified as with psychotic behavior | 44827655 | 29634 | condition | 31 | 61  
|  | Senile dementia with depression | 379784 | Senile dementia with depressive features | 44819534 | 29021 | condition | 18 | 21  
|  | Severe bipolar II disorder, most recent episode major depressive, in partial remission | 4283219 | Bipolar I disorder, most recent episode (or current) depressed, in partial or unspecified remission | 44820721 | 29655 | condition | 10 | 10  
|  | Severe major depression, single episode, with psychotic features | 438406 | Major depressive affective disorder, single episode, severe, specified as with psychotic behavior | 44820717 | 29624 | condition | 9 | 10  
|  | Severe major depression, single episode, without psychotic features | 441534 | Major depressive affective disorder, single episode, severe, without mention of psychotic behavior | 44835784 | 29623 | condition | 18 | 25  
|  | overall | - | NA | NA | NA | NA | 182 | 486  
  
### Stratify Cohort-Level Diagnostics

You can also stratify cohort code use results by year (`byYear`), by sex (`bySex`), or by age group (`byAgeGroup`):
    
    
    cohort_code_use <- [summariseCohortCodeUse](../reference/summariseCohortCodeUse.html)(depression, 
                                              cdm,
                                              cohortTable = "depression",
                                              countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"),
                                              byYear = FALSE,
                                              bySex = TRUE,
                                              ageGroup = NULL)
    [tableCohortCodeUse](../reference/tableCohortCodeUse.html)(cohort_code_use)

|  Database name  
---|---  
|  Eunomia Synpuf  
Cohort name | Codelist name | Sex | Standard concept name | Standard concept ID | Source concept name | Source concept ID | Source concept value | Domain ID |  Estimate name  
Person count | Record count  
depression | depression | overall | Arteriosclerotic dementia with depression | 374326 | Vascular dementia, with depressed mood | 44829914 | 29043 | condition | 11 | 52  
|  |  | Bipolar affective disorder, currently depressed, in full remission | 439251 | Bipolar I disorder, most recent episode (or current) depressed, in full remission | 44822977 | 29656 | condition | 13 | 48  
|  |  | Bipolar affective disorder, currently depressed, mild | 439253 | Bipolar I disorder, most recent episode (or current) depressed, mild | 44826500 | 29651 | condition | 16 | 53  
|  |  | Bipolar affective disorder, currently depressed, moderate | 437528 | Bipolar I disorder, most recent episode (or current) depressed, moderate | 44835786 | 29652 | condition | 9 | 32  
|  |  | Presenile dementia with depression | 377527 | Presenile dementia with depressive features | 44836954 | 29013 | condition | 10 | 24  
|  |  | Recurrent major depressive episodes | 432285 | Major depressive affective disorder, recurrent episode, unspecified | 44831089 | 29630 | condition | 41 | 160  
|  |  | Recurrent major depressive episodes, mild | 438998 | Major depressive affective disorder, recurrent episode, mild | 44829923 | 29631 | condition | 24 | 96  
|  |  | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, moderate | 44831090 | 29632 | condition | 48 | 341  
|  |  |  |  | Major depressive affective disorder, recurrent episode, severe, without mention of psychotic behavior | 44835785 | 29633 | condition | 53 | 432  
|  |  | Recurrent major depressive episodes, severe, with psychosis | 434911 | Major depressive affective disorder, recurrent episode, severe, specified as with psychotic behavior | 44827655 | 29634 | condition | 31 | 276  
|  |  | Senile dementia with depression | 379784 | Senile dementia with depressive features | 44819534 | 29021 | condition | 18 | 48  
|  |  | Severe bipolar II disorder, most recent episode major depressive, in partial remission | 4283219 | Bipolar I disorder, most recent episode (or current) depressed, in partial or unspecified remission | 44820721 | 29655 | condition | 10 | 25  
|  |  | Severe major depression, single episode, with psychotic features | 438406 | Major depressive affective disorder, single episode, severe, specified as with psychotic behavior | 44820717 | 29624 | condition | 9 | 38  
|  |  | Severe major depression, single episode, without psychotic features | 441534 | Major depressive affective disorder, single episode, severe, without mention of psychotic behavior | 44835784 | 29623 | condition | 18 | 77  
|  |  | overall | - | NA | NA | NA | NA | 182 | 1,702  
|  | Female | Arteriosclerotic dementia with depression | 374326 | Vascular dementia, with depressed mood | 44829914 | 29043 | condition | 3 | 26  
|  |  | Bipolar affective disorder, currently depressed, in full remission | 439251 | Bipolar I disorder, most recent episode (or current) depressed, in full remission | 44822977 | 29656 | condition | 7 | 25  
|  |  | Bipolar affective disorder, currently depressed, mild | 439253 | Bipolar I disorder, most recent episode (or current) depressed, mild | 44826500 | 29651 | condition | 5 | 20  
|  |  | Bipolar affective disorder, currently depressed, moderate | 437528 | Bipolar I disorder, most recent episode (or current) depressed, moderate | 44835786 | 29652 | condition | 5 | 13  
|  |  | Presenile dementia with depression | 377527 | Presenile dementia with depressive features | 44836954 | 29013 | condition | 3 | 7  
|  |  | Recurrent major depressive episodes | 432285 | Major depressive affective disorder, recurrent episode, unspecified | 44831089 | 29630 | condition | 27 | 100  
|  |  | Recurrent major depressive episodes, mild | 438998 | Major depressive affective disorder, recurrent episode, mild | 44829923 | 29631 | condition | 10 | 43  
|  |  | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, moderate | 44831090 | 29632 | condition | 27 | 117  
|  |  |  |  | Major depressive affective disorder, recurrent episode, severe, without mention of psychotic behavior | 44835785 | 29633 | condition | 25 | 178  
|  |  | Recurrent major depressive episodes, severe, with psychosis | 434911 | Major depressive affective disorder, recurrent episode, severe, specified as with psychotic behavior | 44827655 | 29634 | condition | 15 | 105  
|  |  | Senile dementia with depression | 379784 | Senile dementia with depressive features | 44819534 | 29021 | condition | 9 | 17  
|  |  | Severe bipolar II disorder, most recent episode major depressive, in partial remission | 4283219 | Bipolar I disorder, most recent episode (or current) depressed, in partial or unspecified remission | 44820721 | 29655 | condition | 6 | 20  
|  |  | Severe major depression, single episode, with psychotic features | 438406 | Major depressive affective disorder, single episode, severe, specified as with psychotic behavior | 44820717 | 29624 | condition | 6 | 33  
|  |  | Severe major depression, single episode, without psychotic features | 441534 | Major depressive affective disorder, single episode, severe, without mention of psychotic behavior | 44835784 | 29623 | condition | 13 | 66  
|  |  | overall | - | NA | NA | NA | NA | 97 | 770  
|  | Male | Arteriosclerotic dementia with depression | 374326 | Vascular dementia, with depressed mood | 44829914 | 29043 | condition | 8 | 26  
|  |  | Bipolar affective disorder, currently depressed, in full remission | 439251 | Bipolar I disorder, most recent episode (or current) depressed, in full remission | 44822977 | 29656 | condition | 6 | 23  
|  |  | Bipolar affective disorder, currently depressed, mild | 439253 | Bipolar I disorder, most recent episode (or current) depressed, mild | 44826500 | 29651 | condition | 11 | 33  
|  |  | Bipolar affective disorder, currently depressed, moderate | 437528 | Bipolar I disorder, most recent episode (or current) depressed, moderate | 44835786 | 29652 | condition | 4 | 19  
|  |  | Presenile dementia with depression | 377527 | Presenile dementia with depressive features | 44836954 | 29013 | condition | 7 | 17  
|  |  | Recurrent major depressive episodes | 432285 | Major depressive affective disorder, recurrent episode, unspecified | 44831089 | 29630 | condition | 14 | 60  
|  |  | Recurrent major depressive episodes, mild | 438998 | Major depressive affective disorder, recurrent episode, mild | 44829923 | 29631 | condition | 14 | 53  
|  |  | Recurrent major depressive episodes, moderate | 432883 | Major depressive affective disorder, recurrent episode, moderate | 44831090 | 29632 | condition | 21 | 224  
|  |  |  |  | Major depressive affective disorder, recurrent episode, severe, without mention of psychotic behavior | 44835785 | 29633 | condition | 28 | 254  
|  |  | Recurrent major depressive episodes, severe, with psychosis | 434911 | Major depressive affective disorder, recurrent episode, severe, specified as with psychotic behavior | 44827655 | 29634 | condition | 16 | 171  
|  |  | Senile dementia with depression | 379784 | Senile dementia with depressive features | 44819534 | 29021 | condition | 9 | 31  
|  |  | Severe bipolar II disorder, most recent episode major depressive, in partial remission | 4283219 | Bipolar I disorder, most recent episode (or current) depressed, in partial or unspecified remission | 44820721 | 29655 | condition | 4 | 5  
|  |  | Severe major depression, single episode, with psychotic features | 438406 | Major depressive affective disorder, single episode, severe, specified as with psychotic behavior | 44820717 | 29624 | condition | 3 | 5  
|  |  | Severe major depression, single episode, without psychotic features | 441534 | Major depressive affective disorder, single episode, severe, without mention of psychotic behavior | 44835784 | 29623 | condition | 5 | 11  
|  |  | overall | - | NA | NA | NA | NA | 85 | 932  
  
## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/news/index.html

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

# Changelog

## CodelistGenerator 3.0

CRAN release: 2024-05-31

  * Add function getRelationshipId
  * Add functions summariseAchillesCodeUse (replaces achillesCodeUse), summariseOrphanCodes (replaces findOrphanCodes), tableAchillesCodeUse, tableCodeUse, tableCohortCodeUse, tableOrphanCodes.



## CodelistGenerator 2.2.3

CRAN release: 2024-03-08

  * Fix for forthcoming breaking change in dependency omopgenerics



## CodelistGenerator 2.2.2

CRAN release: 2024-02-14

  * Fix for edge case with multiple exclusion criteria



## CodelistGenerator 2.2.1

CRAN release: 2024-02-07

  * Working with omopgenerics



## CodelistGenerator 2.2.0

CRAN release: 2024-01-25

  * Added functions findOrphanCodes, restrictToCodesInUse, sourceCodesInUse.
  * Speed improvements in getCandidateCodes from doing search in place (e.g. on database side).
  * Dropped explicit support of an Arrow cdm.



## CodelistGenerator 2.1.1

CRAN release: 2023-11-20

  * Improved support of device domain.



## CodelistGenerator 2.0.0

CRAN release: 2023-10-09

  * Simplified the interface of getCandidateCodes, with a number of arguments removed.
  * Added function summariseCohortCodeUse.



## CodelistGenerator 1.7.0

CRAN release: 2023-08-16

  * Added function codesFromCohort.



## CodelistGenerator 1.6.0

CRAN release: 2023-07-07

  * Improved getICD10StandardCodes function.
  * Added function codesFromConceptSet.



## CodelistGenerator 1.5.0

CRAN release: 2023-06-13

  * Require CDMConnector v1.0.0 or above.



## CodelistGenerator 1.4.0

CRAN release: 2023-06-06

  * Added function summariseCodeUse.



## CodelistGenerator 1.3.0

CRAN release: 2023-05-30

  * Added function getICD10StandardCodes.



## CodelistGenerator 1.2.0

CRAN release: 2023-05-04

  * Added functions getATCCodes and getDrugIngredientCodes.



## CodelistGenerator 1.1.0

CRAN release: 2023-04-01

  * Added exactMatch and includeSequela options to getCandidateCodes function.



## CodelistGenerator 1.0.0

CRAN release: 2023-02-07

  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getVocabVersion.html

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

# Get the version of the vocabulary used in the cdm

`getVocabVersion.Rd`

Get the version of the vocabulary used in the cdm

## Usage
    
    
    getVocabVersion(cdm)

## Arguments

cdm
    

A cdm reference via CDMConnector.

## Value

The vocabulary version being used in the cdm.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getVocabVersion(cdm = cdm)
    #> [1] "v5.0 22-JUN-22"
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html

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

# Get descendant codes of drug ingredients

`getDrugIngredientCodes.Rd`

Get descendant codes of drug ingredients

## Usage
    
    
    getDrugIngredientCodes(
      cdm,
      name = NULL,
      nameStyle = "{concept_code}_{concept_name}",
      doseForm = NULL,
      doseUnit = NULL,
      routeCategory = NULL,
      ingredientRange = [c](https://rdrr.io/r/base/c.html)(1, Inf),
      type = "codelist"
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

name
    

Names of ingredients of interest. For example, c("acetaminophen", "codeine"), would result in a list of length two with the descendant concepts for these two particular drug ingredients. Users can also specify the concept ID instead of the name (e.g., c(1125315, 42948451)) using a numeric vector.

nameStyle
    

Name style to apply to returned list. Can be one of `"{concept_code}"`,`"{concept_id}"`, `"{concept_name}"`, or a combination (i.e., `"{concept_code}_{concept_name}"`).

doseForm
    

Only codes with the specified dose form will be returned. If NULL, descendant codes will be returned regardless of dose form. Use 'getDoseForm()' to see the available dose forms.

doseUnit
    

Only codes with the specified dose unit will be returned. If NULL, descendant codes will be returned regardless of dose unit Use 'getDoseUnit()' to see the available dose units.

routeCategory
    

Only codes with the specified route will be returned. If NULL, descendant codes will be returned regardless of route category. Use getRoutes() to find the available route categories.

ingredientRange
    

Used to restrict descendant codes to those associated with a specific number of drug ingredients. Must be a vector of length two with the first element the minimum number of ingredients allowed and the second the maximum. A value of c(2, 2) would restrict to only concepts associated with two ingredients.

type
    

Can be "codelist" or "codelist_with_details".

## Value

Concepts with their format based on the type argument.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getDrugIngredientCodes(cdm = cdm, name = "Adalimumab",
                           nameStyle = "{concept_name}")
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - adalimumab (2 codes)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getCandidateCodes.html

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

`getCandidateCodes.Rd`

This function generates a set of codes that can be considered for creating a phenotype using the OMOP CDM.

## Usage
    
    
    getCandidateCodes(
      cdm,
      keywords,
      exclude = NULL,
      domains = "Condition",
      standardConcept = "Standard",
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeDescendants = TRUE,
      includeAncestor = FALSE
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

keywords
    

Character vector of words to search for. Where more than one word is given (e.g. "knee osteoarthritis"), all combinations of those words should be identified positions (e.g. "osteoarthritis of knee") should be identified.

exclude
    

Character vector of words to identify concepts to exclude.

domains
    

Character vector with one or more of the OMOP CDM domain. If NULL, all supported domains are included: Condition, Drug, Procedure, Device, Observation, and Measurement.

standardConcept
    

Character vector with one or more of "Standard", "Classification", and "Non-standard". These correspond to the flags used for the standard_concept field in the concept table of the cdm.

searchInSynonyms
    

Either TRUE or FALSE. If TRUE the code will also search using both the primary name in the concept table and synonyms from the concept synonym table.

searchNonStandard
    

Either TRUE or FALSE. If TRUE the code will also search via non-standard concepts.

includeDescendants
    

Either TRUE or FALSE. If TRUE descendant concepts of identified concepts will be included in the candidate codelist. If FALSE only direct mappings from ICD-10 codes to standard codes will be returned.

includeAncestor
    

Either TRUE or FALSE. If TRUE the direct ancestor concepts of identified concepts will be included in the candidate codelist.

## Value

A tibble with the information on the potential codes of interest.

## Examples
    
    
    # \donttest{
    cdm <- CodelistGenerator::[mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    CodelistGenerator::getCandidateCodes(
      cdm = cdm,
      keywords = "osteoarthritis"
     )
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    #> # A tibble: 2 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          4 From initial… Osteoarthri… Condition SNOMED        S               
    #> 2          5 From initial… Osteoarthri… Condition SNOMED        S               
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/summariseCodeUse.html

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

# Summarise code use in patient-level data.

`summariseCodeUse.Rd`

Summarise code use in patient-level data.

## Usage
    
    
    summariseCodeUse(
      x,
      cdm,
      countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"),
      byConcept = TRUE,
      byYear = FALSE,
      bySex = FALSE,
      ageGroup = NULL,
      dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA))
    )

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

countBy
    

Either "record" for record-level counts or "person" for person-level counts.

byConcept
    

TRUE or FALSE. If TRUE code use will be summarised by concept.

byYear
    

TRUE or FALSE. If TRUE code use will be summarised by year.

bySex
    

TRUE or FALSE. If TRUE code use will be summarised by sex.

ageGroup
    

If not NULL, a list of ageGroup vectors of length two.

dateRange
    

Two dates. The first indicating the earliest cohort start date and the second indicating the latest possible cohort end date. If NULL or the first date is set as missing, the earliest observation_start_date in the observation_period table will be used for the former. If NULL or the second date is set as missing, the latest observation_end_date in the observation_period table will be used for the latter.

## Value

A tibble with count results overall and, if specified, by strata.

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(),
                          dbdir = CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con,
                                    cdmSchema = "main",
                                    writeSchema = "main")
    acetiminophen <- [c](https://rdrr.io/r/base/c.html)(1125315,  1127433, 40229134,
    40231925, 40162522, 19133768,  1127078)
    poliovirus_vaccine <- [c](https://rdrr.io/r/base/c.html)(40213160)
    cs <- [list](https://rdrr.io/r/base/list.html)(acetiminophen = acetiminophen,
              poliovirus_vaccine = poliovirus_vaccine)
    results <- summariseCodeUse(cs,cdm = cdm)
    results
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/tableCodeUse.html

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

# Format the result of summariseCodeUse into a table.

`tableCodeUse.Rd`

Format the result of summariseCodeUse into a table.

## Usage
    
    
    tableCodeUse(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "estimate_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [character](https://rdrr.io/r/base/character.html)(),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A `<summarised_result>` with results of the type "code_use".

type
    

Type of desired formatted table. To see supported formats use visOmopResults::tableType().

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "codelist_name", "standard_concept_name", "standard_concept_id", "estimate_name", "source_concept_name", "source_concept_id", "domain_id". If results are stratified, "year", "sex", "age_group" can also be used. Alternatively, it can include other names to use as overall header labels.

groupColumn
    

Variables to use as group labels. Allowed columns are: "cdm_name", "codelist_name", "standard_concept_name", "standard_concept_id", "estimate_name", "source_concept_name", "source_concept_id", "domain_id". If results are stratified, "year", "sex", "age_group" can also be used. These cannot be used in header.

hide
    

Table columns to exclude, options are: "cdm_name", "codelist_name", "year", "sex", "age_group", "standard_concept_name", "standard_concept_id", "estimate_name", "source_concept_name", "source_concept_id", "domain_id". If results are stratified, "year", "sex", "age_group" can also be used. These cannot be used in header or groupColumn.

.options
    

Named list with additional formatting options. visOmopResults::tableOptions() shows allowed arguments and their default values.

## Value

A table with a formatted version of the summariseCodeUse result.

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(),
                          dbdir = CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con,
                                    cdmSchema = "main",
                                    writeSchema = "main")
    acetiminophen <- [c](https://rdrr.io/r/base/c.html)(1125315,  1127433, 40229134,
    40231925, 40162522, 19133768,  1127078)
    poliovirus_vaccine <- [c](https://rdrr.io/r/base/c.html)(40213160)
    cs <- [list](https://rdrr.io/r/base/list.html)(acetiminophen = acetiminophen,
              poliovirus_vaccine = poliovirus_vaccine)
    results <- [summariseCodeUse](summariseCodeUse.html)(cs,cdm = cdm)
    tableCodeUse(results)
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/LICENSE.html

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

# Apache License

_Version 2.0, January 2004_ _<<http://www.apache.org/licenses/>>_

### Terms and Conditions for use, reproduction, and distribution

#### 1\. Definitions

“License” shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

“Licensor” shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.

“Legal Entity” shall mean the union of the acting entity and all other entities that control, are controlled by, or are under common control with that entity. For the purposes of this definition, “control” means **(i)** the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or **(ii)** ownership of fifty percent (50%) or more of the outstanding shares, or **(iii)** beneficial ownership of such entity.

“You” (or “Your”) shall mean an individual or Legal Entity exercising permissions granted by this License.

“Source” form shall mean the preferred form for making modifications, including but not limited to software source code, documentation source, and configuration files.

“Object” form shall mean any form resulting from mechanical transformation or translation of a Source form, including but not limited to compiled object code, generated documentation, and conversions to other media types.

“Work” shall mean the work of authorship, whether in Source or Object form, made available under the License, as indicated by a copyright notice that is included in or attached to the work (an example is provided in the Appendix below).

“Derivative Works” shall mean any work, whether in Source or Object form, that is based on (or derived from) the Work and for which the editorial revisions, annotations, elaborations, or other modifications represent, as a whole, an original work of authorship. For the purposes of this License, Derivative Works shall not include works that remain separable from, or merely link (or bind by name) to the interfaces of, the Work and Derivative Works thereof.

“Contribution” shall mean any work of authorship, including the original version of the Work and any modifications or additions to that Work or Derivative Works thereof, that is intentionally submitted to Licensor for inclusion in the Work by the copyright owner or by an individual or Legal Entity authorized to submit on behalf of the copyright owner. For the purposes of this definition, “submitted” means any form of electronic, verbal, or written communication sent to the Licensor or its representatives, including but not limited to communication on electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, the Licensor for the purpose of discussing and improving the Work, but excluding communication that is conspicuously marked or otherwise designated in writing by the copyright owner as “Not a Contribution.”

“Contributor” shall mean Licensor and any individual or Legal Entity on behalf of whom a Contribution has been received by Licensor and subsequently incorporated within the Work.

#### 2\. Grant of Copyright License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare Derivative Works of, publicly display, publicly perform, sublicense, and distribute the Work and such Derivative Works in Source or Object form.

#### 3\. Grant of Patent License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this section) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work, where such license applies only to those patent claims licensable by such Contributor that are necessarily infringed by their Contribution(s) alone or by combination of their Contribution(s) with the Work to which such Contribution(s) was submitted. If You institute patent litigation against any entity (including a cross-claim or counterclaim in a lawsuit) alleging that the Work or a Contribution incorporated within the Work constitutes direct or contributory patent infringement, then any patent licenses granted to You under this License for that Work shall terminate as of the date such litigation is filed.

#### 4\. Redistribution

You may reproduce and distribute copies of the Work or Derivative Works thereof in any medium, with or without modifications, and in Source or Object form, provided that You meet the following conditions:

  * **(a)** You must give any other recipients of the Work or Derivative Works a copy of this License; and
  * **(b)** You must cause any modified files to carry prominent notices stating that You changed the files; and
  * **(c)** You must retain, in the Source form of any Derivative Works that You distribute, all copyright, patent, trademark, and attribution notices from the Source form of the Work, excluding those notices that do not pertain to any part of the Derivative Works; and
  * **(d)** If the Work includes a “NOTICE” text file as part of its distribution, then any Derivative Works that You distribute must include a readable copy of the attribution notices contained within such NOTICE file, excluding those notices that do not pertain to any part of the Derivative Works, in at least one of the following places: within a NOTICE text file distributed as part of the Derivative Works; within the Source form or documentation, if provided along with the Derivative Works; or, within a display generated by the Derivative Works, if and wherever such third-party notices normally appear. The contents of the NOTICE file are for informational purposes only and do not modify the License. You may add Your own attribution notices within Derivative Works that You distribute, alongside or as an addendum to the NOTICE text from the Work, provided that such additional attribution notices cannot be construed as modifying the License.



You may add Your own copyright statement to Your modifications and may provide additional or different license terms and conditions for use, reproduction, or distribution of Your modifications, or for any such Derivative Works as a whole, provided Your use, reproduction, and distribution of the Work otherwise complies with the conditions stated in this License.

#### 5\. Submission of Contributions

Unless You explicitly state otherwise, any Contribution intentionally submitted for inclusion in the Work by You to the Licensor shall be under the terms and conditions of this License, without any additional terms or conditions. Notwithstanding the above, nothing herein shall supersede or modify the terms of any separate license agreement you may have executed with Licensor regarding such Contributions.

#### 6\. Trademarks

This License does not grant permission to use the trade names, trademarks, service marks, or product names of the Licensor, except as required for reasonable and customary use in describing the origin of the Work and reproducing the content of the NOTICE file.

#### 7\. Disclaimer of Warranty

Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.

#### 8\. Limitation of Liability

In no event and under no legal theory, whether in tort (including negligence), contract, or otherwise, unless required by applicable law (such as deliberate and grossly negligent acts) or agreed to in writing, shall any Contributor be liable to You for damages, including any direct, indirect, special, incidental, or consequential damages of any character arising as a result of this License or out of the use or inability to use the Work (including but not limited to damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses), even if such Contributor has been advised of the possibility of such damages.

#### 9\. Accepting Warranty or Additional Liability

While redistributing the Work or Derivative Works thereof, You may choose to offer, and charge a fee for, acceptance of support, warranty, indemnity, or other liability obligations and/or rights consistent with this License. However, in accepting such obligations, You may act only on Your own behalf and on Your sole responsibility, not on behalf of any other Contributor, and only if You agree to indemnify, defend, and hold each Contributor harmless for any liability incurred by, or claims asserted against, such Contributor by reason of your accepting any such warranty or additional liability.

_END OF TERMS AND CONDITIONS_

### APPENDIX: How to apply the Apache License to your work

To apply the Apache License to your work, attach the following boilerplate notice, with the fields enclosed by brackets `[]` replaced with your own identifying information. (Don’t include the brackets!) The text should be enclosed in the appropriate comment syntax for the file format. We also recommend that a file or class name and description of purpose be included on the same “printed page” as the copyright notice for easier identification within third-party archives.
    
    
    Copyright [yyyy] [name of copyright owner]
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
      http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/CONTRIBUTING.html

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

# Contributing to CodelistGenerator

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated.

## Contributing code or documentation

> This package has been developed as part of the DARWIN EU(R) project and is closed to external contributions.

Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

#### Documenting the package

Run the below to update and check package documentation:
    
    
    devtools::document() 
    devtools::run_examples()
    devtools::build_readme()
    devtools::build_vignettes()
    devtools::check_man()

Note that `devtools::check_man()` should not return any warnings. If your commit is limited to only package documentation, running the above should be sufficient (although running `devtools::check()` will always generally be a good idea before submitting a pull request.

#### Run tests

Before starting to contribute any code, first make sure the package tests are all passing. If not raise an issue before going any further (although please first make sure you have all the packages from imports and suggests installed). As you then contribute code, make sure that all the current tests and any you add continue to pass. All package tests can be run together with:
    
    
    devtools::test()

Code to add new functionality should be accompanied by tests. Code coverage can be checked using:
    
    
    # note, you may first have to detach the package
    # detach("package:CodelistGenerator", unload=TRUE)
    devtools::test_coverage()

#### Adhere to code style

Please adhere to the code style when adding any new code. Do not though restyle any code unrelated to your pull request as this will make code review more difficult.
    
    
    lintr::lint_package(".",
                        linters = lintr::linters_with_defaults(
                          lintr::object_name_linter(styles = "camelCase")
                        )
    )

#### Run check() before opening a pull request

Before opening any pull request please make sure to run:
    
    
    devtools::check() 

No warnings should be seen.

If the package is on CRAN or is close to being submitted to CRAN then please also run:
    
    
    rcmdcheck::rcmdcheck(args = [c](https://rdrr.io/r/base/c.html)("--no-manual", "--as-cran"))
    devtools::check_win_devel()

Also it can be worth checking spelling and any urls
    
    
    spelling::[spell_check_package](https://docs.ropensci.org/spelling//reference/spell_check_package.html)()
    urlchecker::url_check()

#### Precompute vignette data

The search results presented in the vignettes are precomputed against a database with a full vocabulary. If making changes that will affect these results, they should be recomputed. Note you may need to change the database connection details in this script.
    
    
    [source](https://rdrr.io/r/base/source.html)(here::here("extras", "precomputeVignetteData.R"))

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/authors.html

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

# Authors and Citation

## Authors

  * **Edward Burn**. Author, maintainer. [](https://orcid.org/0000-0002-9286-1128)

  * **Marti Catala**. Contributor. [](https://orcid.org/0000-0003-3308-9905)

  * **Xihang Chen**. Author. [](https://orcid.org/0009-0001-8112-8959)

  * **Nuria Mercade-Besora**. Author. [](https://orcid.org/0009-0006-7948-3747)

  * **Mike Du**. Contributor. [](https://orcid.org/0000-0002-9517-8834)

  * **Danielle Newby**. Contributor. [](https://orcid.org/0000-0002-3001-1478)

  * **Marta Alcalde-Herraiz**. Contributor. [](https://orcid.org/0009-0002-4405-1814)




## Citation

Burn E, Chen X, Mercade-Besora N (2025). _CodelistGenerator: Identify Relevant Clinical Codes and Evaluate Their Use_. R package version 3.5.0, <https://darwin-eu.github.io/CodelistGenerator/>. 
    
    
    @Manual{,
      title = {CodelistGenerator: Identify Relevant Clinical Codes and Evaluate Their Use},
      author = {Edward Burn and Xihang Chen and Nuria Mercade-Besora},
      year = {2025},
      note = {R package version 3.5.0},
      url = {https://darwin-eu.github.io/CodelistGenerator/},
    }

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getATCCodes.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getICD10StandardCodes.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/summariseAchillesCodeUse.html

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

# Summarise code use from achilles counts.

`summariseAchillesCodeUse.Rd`

Summarise code use from achilles counts.

## Usage
    
    
    summariseAchillesCodeUse(x, cdm, countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"))

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

countBy
    

Either "record" for record-level counts or "person" for person-level counts.

## Value

A tibble with summarised counts.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    oa <- [getCandidateCodes](getCandidateCodes.html)(cdm = cdm, keywords = "osteoarthritis")
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    result_achilles <- summariseAchillesCodeUse([list](https://rdrr.io/r/base/list.html)(oa = oa$concept_id), cdm = cdm)
    #> 
    result_achilles
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name    group_level strata_name strata_level
    #>       <int> <chr>    <chr>         <chr>       <chr>       <chr>       
    #> 1         1 mock     codelist_name oa          domain_id   condition   
    #> 2         1 mock     codelist_name oa          domain_id   condition   
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/summariseCohortCodeUse.html

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

# Summarise code use among a cohort in the cdm reference

`summariseCohortCodeUse.Rd`

Summarise code use among a cohort in the cdm reference

## Usage
    
    
    summariseCohortCodeUse(
      x,
      cdm,
      cohortTable,
      cohortId = NULL,
      timing = "any",
      countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"),
      byConcept = TRUE,
      byYear = FALSE,
      bySex = FALSE,
      ageGroup = NULL
    )

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

cohortTable
    

A cohort table from the cdm reference.

cohortId
    

A vector of cohort IDs to include

timing
    

When to assess the code use relative cohort dates. This can be "any"(code use any time by individuals in the cohort) or "entry" (code use on individuals' cohort start date).

countBy
    

Either "record" for record-level counts or "person" for person-level counts.

byConcept
    

TRUE or FALSE. If TRUE code use will be summarised by concept.

byYear
    

TRUE or FALSE. If TRUE code use will be summarised by year.

bySex
    

TRUE or FALSE. If TRUE code use will be summarised by sex.

ageGroup
    

If not NULL, a list of ageGroup vectors of length two.

## Value

A tibble with results overall and, if specified, by strata

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(),
                     dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con,
                     cdmSchema = "main",
                     writeSchema = "main")
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                      conceptSet = [list](https://rdrr.io/r/base/list.html)(a = 260139,
                                        b = 1127433),
                      name = "cohorts",
                      end = "observation_period_end_date",
                      overwrite = TRUE)
    
    results_cohort_mult <-
    summariseCohortCodeUse([list](https://rdrr.io/r/base/list.html)(cs = [c](https://rdrr.io/r/base/c.html)(260139,19133873)),
                          cdm = cdm,
                          cohortTable = "cohorts",
                          timing = "entry")
    
    results_cohort_mult
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/summariseUnmappedCodes.html

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

# Find unmapped concepts related to codelist

`summariseUnmappedCodes.Rd`

Find unmapped concepts related to codelist

## Usage
    
    
    summariseUnmappedCodes(
      x,
      cdm,
      table = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "device_exposure", "drug_exposure", "measurement",
        "observation", "procedure_occurrence")
    )

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

table
    

Names of clinical tables in which to search for unmapped codes. Can be one or more of "condition_occurrence", "device_exposure", "drug_exposure", "measurement", "observation", and "procedure_occurrence".

## Value

A summarised result of unmapped concepts related to given codelist.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [list](https://rdrr.io/r/base/list.html)("Musculoskeletal disorder" = 1)
    cdm <- omopgenerics::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "condition_occurrence",
    dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(person_id = 1,
                  condition_occurrence_id = 1,
                  condition_concept_id = 0,
                  condition_start_date  = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
                  condition_type_concept_id  = NA,
                  condition_source_concept_id = 7))
    summariseUnmappedCodes(x = [list](https://rdrr.io/r/base/list.html)("osteoarthritis" = 2), cdm = cdm,
    table = "condition_occurrence")
    #> Warning: ! `codelist` casted to integers.
    #> Searching for unmapped codes related to osteoarthritis
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name    group_level    strata_name strata_level
    #>       <int> <chr>    <chr>         <chr>          <chr>       <chr>       
    #> 1         1 mock     codelist_name osteoarthritis overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/tableAchillesCodeUse.html

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

# Format the result of summariseAchillesCodeUse into a table

`tableAchillesCodeUse.Rd`

Format the result of summariseAchillesCodeUse into a table

## Usage
    
    
    tableAchillesCodeUse(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "estimate_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [character](https://rdrr.io/r/base/character.html)(),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A `<summarised_result>` with results of the type "achilles_code_use".

type
    

Type of desired formatted table. To see supported formats use visOmopResults::tableType().

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". Alternatively, it can include other names to use as overall header labels.

groupColumn
    

Variables to use as group labels. Allowed columns are: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". These cannot be used in header.

hide
    

Table columns to exclude, options are: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". These cannot be used in header or groupColumn.

.options
    

Named list with additional formatting options. visOmopResults::tableOptions() shows allowed arguments and their default values.

## Value

A table with a formatted version of the summariseCohortCodeUse result.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    oa <- [getCandidateCodes](getCandidateCodes.html)(cdm = cdm, keywords = "osteoarthritis")
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    result_achilles <- [summariseAchillesCodeUse](summariseAchillesCodeUse.html)([list](https://rdrr.io/r/base/list.html)(oa = oa$concept_id), cdm = cdm)
    #> 
    tableAchillesCodeUse(result_achilles)
    
    
    
    
      
          | 
            Database name
          
          
    ---|---  
    
          | 
            mock
          
          
    Codelist name
          | Domain ID
          | Standard concept name
          | Standard concept ID
          | Standard concept
          | Vocabulary ID
          | 
            Estimate name
          
          
    Record count
          
    oa
    | condition
    | Osteoarthritis of knee
    | 4
    | standard
    | SNOMED
    | 400  
    
    | 
    | Osteoarthritis of hip
    | 5
    | standard
    | SNOMED
    | 200  
      
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/tableCohortCodeUse.html

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

# Format the result of summariseCohortCodeUse into a table.

`tableCohortCodeUse.Rd`

Format the result of summariseCohortCodeUse into a table.

## Usage
    
    
    tableCohortCodeUse(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "estimate_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [c](https://rdrr.io/r/base/c.html)("timing"),
      .options = [list](https://rdrr.io/r/base/list.html)(),
      timing = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

result
    

A `<summarised_result>` with results of the type "cohort_code_use".

type
    

Type of desired formatted table. To see supported formats use visOmopResults::tableType().

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "codelist_name", "standard_concept_name", "standard_concept_id", "estimate_name", "source_concept_name", "source_concept_id", "domain_id". If results are stratified, "year", "sex", "age_group" can also be used. Alternatively, it can include other names to use as overall header labels.

groupColumn
    

Variables to use as group labels. Allowed columns are: "cdm_name", "codelist_name", "standard_concept_name", "standard_concept_id", "estimate_name", "source_concept_name", "source_concept_id", "domain_id". If results are stratified, "year", "sex", "age_group" can also be used. These cannot be used in header.

hide
    

Table columns to exclude, options are: "cdm_name", "codelist_name", "year", "sex", "age_group", "standard_concept_name", "standard_concept_id", "estimate_name", "source_concept_name", "source_concept_id", "domain_id". If results are stratified, "year", "sex", "age_group" can also be used. These cannot be used in header or groupColumn.

.options
    

Named list with additional formatting options. visOmopResults::tableOptions() shows allowed arguments and their default values.

timing
    

deprecated.

## Value

A table with a formatted version of the summariseCohortCodeUse result.

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(),
                          dbdir = CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con,
                                      cdmSchema = "main",
                                      writeSchema = "main")
    cdm <- CDMConnector::[generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
    conceptSet = [list](https://rdrr.io/r/base/list.html)(a = 260139,
                      b = 1127433),
                      name = "cohorts",
                      end = "observation_period_end_date",
                      overwrite = TRUE)
    
    results_cohort_mult <-
    [summariseCohortCodeUse](summariseCohortCodeUse.html)([list](https://rdrr.io/r/base/list.html)(cs = [c](https://rdrr.io/r/base/c.html)(260139,19133873)),
                          cdm = cdm,
                          cohortTable = "cohorts",
                          timing = "entry")
    
    tableCohortCodeUse(results_cohort_mult)
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/tableOrphanCodes.html

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

# Format the result of summariseOrphanCodes into a table

`tableOrphanCodes.Rd`

Format the result of summariseOrphanCodes into a table

## Usage
    
    
    tableOrphanCodes(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "estimate_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [character](https://rdrr.io/r/base/character.html)(),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A `<summarised_result>` with results of the type "orphan_codes".

type
    

Type of desired formatted table. To see supported formats use visOmopResults::tableType().

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". Alternatively, it can include other names to use as overall header labels.

groupColumn
    

Variables to use as group labels. Allowed columns are: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". These cannot be used in header.

hide
    

Table columns to exclude, options are: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". These cannot be used in header or groupColumn.

.options
    

Named list with additional formatting options. visOmopResults::tableOptions() shows allowed arguments and their default values.

## Value

A table with a formatted version of the summariseOrphanCodes result.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [getCandidateCodes](getCandidateCodes.html)(cdm = cdm,
    keywords = "Musculoskeletal disorder",
    domains = "Condition",
    includeDescendants = FALSE)
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Search completed. Finishing up.
    #> ✔ 1 candidate concept identified
    #> Time taken: 0 minutes and 0 seconds
    
    orphan_codes <- [summariseOrphanCodes](summariseOrphanCodes.html)(x = [list](https://rdrr.io/r/base/list.html)("msk" = codes$concept_id),
    cdm = cdm)
    #> PHOEBE results not available
    #> ℹ The concept_recommended table is not present in the cdm.
    #> Getting orphan codes for msk
    #> 
    
    tableOrphanCodes(orphan_codes)
    
    
    
    
      
          | 
            Database name
          
          
    ---|---  
    
          | 
            mock
          
          
    Codelist name
          | Domain ID
          | Standard concept name
          | Standard concept ID
          | Standard concept
          | Vocabulary ID
          | 
            Estimate name
          
          
    Record count
          
    msk
    | condition
    | Osteoarthritis of knee
    | 4
    | standard
    | SNOMED
    | 400  
    
    | 
    | Osteoarthritis of hip
    | 5
    | standard
    | SNOMED
    | 200  
      
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/tableUnmappedCodes.html

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

# Format the result of summariseUnmappedCodeUse into a table

`tableUnmappedCodes.Rd`

Format the result of summariseUnmappedCodeUse into a table

## Usage
    
    
    tableUnmappedCodes(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "estimate_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [character](https://rdrr.io/r/base/character.html)(),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A `<summarised_result>` with results of the type "umapped_codes".

type
    

Type of desired formatted table. To see supported formats use visOmopResults::tableType().

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". Alternatively, it can include other names to use as overall header labels.

groupColumn
    

Variables to use as group labels. Allowed columns are: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". These cannot be used in header.

hide
    

Table columns to exclude, options are: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". These cannot be used in header or groupColumn.

.options
    

Named list with additional formatting options. visOmopResults::tableOptions() shows allowed arguments and their default values.

## Value

A table with a formatted version of the summariseUnmappedCodes result.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [list](https://rdrr.io/r/base/list.html)("Musculoskeletal disorder" = 1)
    cdm <- omopgenerics::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "condition_occurrence",
    dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(person_id = 1,
                  condition_occurrence_id = 1,
                  condition_concept_id = 0,
                  condition_start_date  = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
                  condition_type_concept_id  = NA,
                  condition_source_concept_id = 7))
    unmapped_codes <- [summariseUnmappedCodes](summariseUnmappedCodes.html)(x = [list](https://rdrr.io/r/base/list.html)("osteoarthritis" = 2),
    cdm = cdm, table = "condition_occurrence")
    #> Warning: ! `codelist` casted to integers.
    #> Searching for unmapped codes related to osteoarthritis
    tableUnmappedCodes(unmapped_codes)
    
    
    
    
      
          | 
            Database name
          
          
    ---|---  
    
          | 
            mock
          
          
    Codelist name
          | Unmapped concept name
          | Unmapped concept ID
          | 
            Estimate name
          
          
    Record count
          
    osteoarthritis
    | Degenerative arthropathy
    | 7
    | 1  
      
    
    cdm <- omopgenerics::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(
     cdm,
     "measurement",
     dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
       person_id = 1,
       measurement_id = 1,
       measurement_concept_id = 0,
       measurement_date  = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
       measurement_type_concept_id  = NA,
       measurement_source_concept_id = 7
     )
    )
    table <- [summariseUnmappedCodes](summariseUnmappedCodes.html)(x = [list](https://rdrr.io/r/base/list.html)("cs" = 2),
                                   cdm = cdm,
                                   table = [c](https://rdrr.io/r/base/c.html)("measurement"))
    #> Warning: ! `codelist` casted to integers.
    #> Searching for unmapped codes related to cs
    tableUnmappedCodes(unmapped_codes)
    
    
    
    
      
          | 
            Database name
          
          
    ---|---  
    
          | 
            mock
          
          
    Codelist name
          | Unmapped concept name
          | Unmapped concept ID
          | 
            Estimate name
          
          
    Record count
          
    osteoarthritis
    | Degenerative arthropathy
    | 7
    | 1  
      
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/codesFromCohort.html

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

# Get concept ids from JSON files containing cohort definitions

`codesFromCohort.Rd`

Get concept ids from JSON files containing cohort definitions

## Usage
    
    
    codesFromCohort(path, cdm, type = [c](https://rdrr.io/r/base/c.html)("codelist"))

## Arguments

path
    

Path to a file or folder containing JSONs of cohort definitions.

cdm
    

A cdm reference via CDMConnector.

type
    

Can be "codelist", "codelist_with_details" or "concept_set_expression".

## Value

Named list with concept_ids for each concept set.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    x <- codesFromCohort(cdm = cdm,
                         path =  [system.file](https://rdrr.io/r/base/system.file.html)(package = "CodelistGenerator",
                         "cohorts_for_mock"))
    x
    #> 
    #> ── 3 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - OA no descendants (1 codes)
    #> - Other (1 codes)
    #> - arthritis (3 codes)
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/codesFromConceptSet.html

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

# Get concept ids from JSON files containing concept sets

`codesFromConceptSet.Rd`

Get concept ids from JSON files containing concept sets

## Usage
    
    
    codesFromConceptSet(path, cdm, type = [c](https://rdrr.io/r/base/c.html)("codelist"))

## Arguments

path
    

Path to a file or folder containing JSONs of concept sets.

cdm
    

A cdm reference via CDMConnector.

type
    

Can be "codelist", "codelist_with_details" or "concept_set_expression".

## Value

Named list with concept_ids for each concept set.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    x <- codesFromConceptSet(cdm = cdm,
                             path =  [system.file](https://rdrr.io/r/base/system.file.html)(package = "CodelistGenerator",
                             "concepts_for_mock"))
    x
    #> 
    #> ── 3 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - arthritis_desc (3 codes)
    #> - arthritis_no_desc (1 codes)
    #> - arthritis_with_excluded (2 codes)
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/compareCodelists.html

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

# Compare overlap between two sets of codes

`compareCodelists.Rd`

Compare overlap between two sets of codes

## Usage
    
    
    compareCodelists(codelist1, codelist2)

## Arguments

codelist1
    

Output of getCandidateCodes or a codelist

codelist2
    

Output of getCandidateCodes.

## Value

Tibble with information on the overlap of codes in both codelists.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes1 <- [getCandidateCodes](getCandidateCodes.html)(
     cdm = cdm,
     keywords = "Arthritis",
     domains = "Condition",
     includeDescendants = TRUE
    )
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 3 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    codes2 <- [getCandidateCodes](getCandidateCodes.html)(
     cdm = cdm,
     keywords = [c](https://rdrr.io/r/base/c.html)("knee osteoarthritis", "arthrosis"),
     domains = "Condition",
     includeDescendants = TRUE
    )
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    compareCodelists(
     codelist1 = codes1,
     codelist2 = codes2
    )
    #> # A tibble: 4 × 5
    #>   concept_id concept_name           codelist_1 codelist_2 codelist       
    #>        <int> <chr>                       <dbl>      <dbl> <chr>          
    #> 1          3 Arthritis                       1         NA Only codelist 1
    #> 2          4 Osteoarthritis of knee          1          1 Both           
    #> 3          5 Osteoarthritis of hip           1         NA Only codelist 1
    #> 4          2 Osteoarthrosis                 NA          1 Only codelist 2
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/subsetToCodesInUse.html

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

# Filter a codelist to keep only the codes being used in patient records

`subsetToCodesInUse.Rd`

Filter a codelist to keep only the codes being used in patient records

## Usage
    
    
    subsetToCodesInUse(
      x,
      cdm,
      minimumCount = 0L,
      table = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "device_exposure", "drug_exposure", "measurement",
        "observation", "procedure_occurrence", "visit_occurrence")
    )

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

minimumCount
    

Any codes with a frequency under this will be removed.

table
    

cdm table of interest.

## Value

The filtered codelist with only the codes used in the database

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [getCandidateCodes](getCandidateCodes.html)(cdm = cdm,
                               keywords = "arthritis",
                               domains = "Condition",
                               includeDescendants = FALSE)
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Search completed. Finishing up.
    #> ✔ 3 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    x <- subsetToCodesInUse([list](https://rdrr.io/r/base/list.html)("cs1" = codes$concept_id,
                                   "cs2" = 999),
                                    cdm = cdm)
    #> No codes from codelist cs2 found in the database
    
    x
    #> $cs1
    #> [1] 5 4
    #> 
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/subsetOnRouteCategory.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/subsetOnDoseUnit.html

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

# Subset a codelist to only those with a particular dose unit.

`subsetOnDoseUnit.Rd`

Subset a codelist to only those with a particular dose unit.

## Usage
    
    
    subsetOnDoseUnit(x, cdm, doseUnit, negate = FALSE)

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

doseUnit
    

Only codes with the specified dose unit will be returned. If NULL, descendant codes will be returned regardless of dose unit Use 'getDoseUnit()' to see the available dose units.

negate
    

If FALSE, only concepts with the dose unit specified will be returned. If TRUE, concepts with the dose unit specified will be excluded.

## Value

The codelist with only those concepts associated with the dose unit (if negate = FALSE) or codelist without those concepts associated with the dose unit(if negate = TRUE).

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- subsetOnDoseUnit(x = [list](https://rdrr.io/r/base/list.html)("codes" = [c](https://rdrr.io/r/base/c.html)(20,21)),
                              cdm = cdm,
                              doseUnit = [c](https://rdrr.io/r/base/c.html)("milligram"))
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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/subsetOnDomain.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/stratifyByRouteCategory.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/stratifyByDoseUnit.html

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

# Stratify a codelist by dose unit.

`stratifyByDoseUnit.Rd`

Stratify a codelist by dose unit.

## Usage
    
    
    stratifyByDoseUnit(x, cdm, keepOriginal = FALSE)

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
    new_codes <- stratifyByDoseUnit(x = codes,
                                    cdm = cdm,
                                    keepOriginal = TRUE)
    #> Warning: ! `codelist` casted to integers.
    new_codes
    #> 
    #> ── 3 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - concepts (2 codes)
    #> - concepts_milligram (1 codes)
    #> - concepts_percent (1 codes)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/stratifyByConcept.html

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

# Stratify a codelist by the concepts included within it.

`stratifyByConcept.Rd`

Stratify a codelist by the concepts included within it.

## Usage
    
    
    stratifyByConcept(x, cdm, keepOriginal = FALSE)

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

keepOriginal
    

Whether to keep the original codelist and append the stratify (if TRUE) or just return the stratified codelist (if FALSE).

## Value

The codelist or a codelist with details with the required stratifications, as different elements of the list.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [list](https://rdrr.io/r/base/list.html)("concepts" = [c](https://rdrr.io/r/base/c.html)(20,21))
    new_codes <- stratifyByConcept(x = codes,
                                   cdm = cdm,
                                   keepOriginal = TRUE)
    #> Warning: ! `codelist` casted to integers.
    new_codes
    #> 
    #> ── 3 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - concepts (2 codes)
    #> - concepts_glucagon_nasal_powder (1 codes)
    #> - concepts_nitrogen_topical_liquefied_gas (1 codes)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getMappings.html

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

# Show mappings from non-standard vocabularies to standard.

`getMappings.Rd`

Show mappings from non-standard vocabularies to standard.

## Usage
    
    
    getMappings(
      candidateCodelist,
      cdm = NULL,
      nonStandardVocabularies = [c](https://rdrr.io/r/base/c.html)("ATC", "ICD10CM", "ICD10PCS", "ICD9CM", "ICD9Proc",
        "LOINC", "OPCS4", "Read", "RxNorm", "RxNorm Extension", "SNOMED")
    )

## Arguments

candidateCodelist
    

Dataframe.

cdm
    

A cdm reference via CDMConnector.

nonStandardVocabularies
    

Character vector.

## Value

Tibble with the information of potential standard to non-standard mappings for the codelist of interest.

## Examples
    
    
    # \donttest{
    cdm <- CodelistGenerator::[mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- CodelistGenerator::[getCandidateCodes](getCandidateCodes.html)(
      cdm = cdm,
      keywords = "osteoarthritis"
    )
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    CodelistGenerator::getMappings(
      cdm = cdm,
      candidateCodelist = codes,
      nonStandardVocabularies = "READ"
    )
    #> # A tibble: 1 × 7
    #>   standard_concept_id standard_concept_name  standard_vocabulary_id
    #>                 <int> <chr>                  <chr>                 
    #> 1                   4 Osteoarthritis of knee SNOMED                
    #> # ℹ 4 more variables: non_standard_concept_id <int>,
    #> #   non_standard_concept_name <chr>, non_standard_concept_code <chr>,
    #> #   non_standard_vocabulary_id <chr>
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getVocabularies.html

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

# Get the vocabularies available in the cdm

`getVocabularies.Rd`

Get the vocabularies available in the cdm

## Usage
    
    
    getVocabularies(cdm)

## Arguments

cdm
    

A cdm reference via CDMConnector.

## Value

Names of available vocabularies.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getVocabularies(cdm = cdm)
    #> [1] "ATC"    "ICD10"  "LOINC"  "OMOP"   "Read"   "RxNorm" "SNOMED" "UCUM"  
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getConceptClassId.html

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

# Get the concept classes used in a given set of domains

`getConceptClassId.Rd`

Get the concept classes used in a given set of domains

## Usage
    
    
    getConceptClassId(cdm, standardConcept = "Standard", domain = NULL)

## Arguments

cdm
    

A cdm reference via CDMConnector.

standardConcept
    

Character vector with one or more of "Standard", "Classification", and "Non-standard". These correspond to the flags used for the standard_concept field in the concept table of the cdm.

domain
    

Character vector with one or more of the OMOP CDM domains. The results will be restricted to the given domains. Check the available ones by running getDomains(). If NULL, all supported domains are included: Condition, Drug, Procedure, Device, Observation, and Measurement.

## Value

The concept classes used for the requested domains.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getConceptClassId(cdm = cdm, domain = "drug")
    #> [1] "Clinical Drug Form" "Drug"               "Ingredient"        
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getDomains.html

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

# Get the domains available in the cdm

`getDomains.Rd`

Get the domains available in the cdm

## Usage
    
    
    getDomains(cdm, standardConcept = "Standard")

## Arguments

cdm
    

A cdm reference via CDMConnector.

standardConcept
    

Character vector with one or more of "Standard", "Classification", and "Non-standard". These correspond to the flags used for the standard_concept field in the concept table of the cdm.

## Value

A vector with the domains of the cdm.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getDomains(cdm = cdm)
    #> [1] "Condition"   "Observation" "Drug"        "Unit"       
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getDescendants.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getDoseForm.html

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

# Get the dose forms available for drug concepts

`getDoseForm.Rd`

Get the dose forms available for drug concepts

## Usage
    
    
    getDoseForm(cdm)

## Arguments

cdm
    

A cdm reference via CDMConnector.

## Value

The dose forms available for drug concepts.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getDoseForm(cdm = cdm)
    #> [1] "Injectable"            "Injection"             "Nasal Powder"         
    #> [4] "Topical Liquefied Gas"
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getRouteCategories.html

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

# Get available drug routes

`getRouteCategories.Rd`

Get the dose form categories available in the database (see https://doi.org/10.1002/pds.5809) for more details on how routes were classified).

## Usage
    
    
    getRouteCategories(cdm)

## Arguments

cdm
    

A cdm reference via CDMConnector.

## Value

A character vector with all available routes.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    
    getRouteCategories(cdm)
    #> [1] "topical"            "transmucosal_nasal" "unclassified_route"
    
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getDoseUnit.html

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

# Get available dose units

`getDoseUnit.Rd`

Get the dose form categories available in the database (see https://doi.org/10.1002/pds.5809 for more details on how routes were classified).

## Usage
    
    
    getDoseUnit(cdm)

## Arguments

cdm
    

A cdm reference via CDMConnector.

## Value

A character vector with available routes.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    
    getDoseUnit(cdm)
    #> [1] "milligram" "percent"  
    
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/getRelationshipId.html

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

# Get available relationships between concepts

`getRelationshipId.Rd`

Get available relationships between concepts

## Usage
    
    
    getRelationshipId(
      cdm,
      standardConcept1 = "standard",
      standardConcept2 = "standard",
      domains1 = "condition",
      domains2 = "condition"
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

standardConcept1
    

Character vector with one or more of "Standard", "Classification", and "Non-standard". These correspond to the flags used for the standard_concept field in the concept table of the cdm.

standardConcept2
    

Character vector with one or more of "Standard", "Classification", and "Non-standard". These correspond to the flags used for the standard_concept field in the concept table of the cdm.

domains1
    

Character vector with one or more of the OMOP CDM domain.

domains2
    

Character vector with one or more of the OMOP CDM domain.

## Value

A character vector with unique concept relationship values.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getRelationshipId(cdm = cdm)
    #> [1] "Due to of"
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/codesInUse.html

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

# Get the concepts being used in patient records

`codesInUse.Rd`

Get the concepts being used in patient records

## Usage
    
    
    codesInUse(
      cdm,
      minimumCount = 0L,
      table = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "device_exposure", "drug_exposure", "measurement",
        "observation", "procedure_occurrence", "visit_occurrence")
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

minimumCount
    

Any codes with a frequency under this will be removed.

table
    

cdm table of interest.

## Value

A list of integers indicating codes being used in the database.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    x <- codesInUse(cdm = cdm)
    x
    #> [1] 5 9 4
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/sourceCodesInUse.html

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

# Get the source codes being used in patient records

`sourceCodesInUse.Rd`

Get the source codes being used in patient records

## Usage
    
    
    sourceCodesInUse(
      cdm,
      table = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "device_exposure", "drug_exposure", "measurement",
        "observation", "procedure_occurrence", "visit_occurrence")
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

table
    

cdm table of interest.

## Value

A list of source codes used in the database.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    x <- sourceCodesInUse(cdm = cdm)
    x
    #> integer(0)
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/availableATC.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/availableICD10.html

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

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/availableIngredients.html

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

# Get the names of all available drug ingredients

`availableIngredients.Rd`

Get the names of all available drug ingredients

## Usage
    
    
    availableIngredients(cdm)

## Arguments

cdm
    

A cdm reference via CDMConnector.

## Value

A vector containing the concept names for all ingredient level codes found in the concept table of cdm.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    availableIngredients(cdm)
    #> [1] "Adalimumab"       "Other ingredient"
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/mockVocabRef.html

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

# Generate example vocabulary database

`mockVocabRef.Rd`

Generate example vocabulary database

## Usage
    
    
    mockVocabRef(backend = "data_frame")

## Arguments

backend
    

'database' (duckdb) or 'data_frame'.

## Value

cdm reference with mock vocabulary.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- mockVocabRef()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of mock ────────────────────────────────────────
    #> • omop tables: person, concept, concept_ancestor, concept_synonym,
    #> concept_relationship, vocabulary, drug_strength, observation_period, cdm_source
    #> • cohort tables: -
    #> • achilles tables: achilles_analysis, achilles_results, achilles_results_dist
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.

---

## Content from https://darwin-eu.github.io/CodelistGenerator/reference/buildAchillesTables.html

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

# Add the achilles tables with specified analyses

`buildAchillesTables.Rd`

If the cdm reference does not contain the achilles tables, this function will create them for the analyses used by other functions in the package.

## Usage
    
    
    buildAchillesTables(cdm, achillesId = NULL)

## Arguments

cdm
    

A cdm reference via CDMConnector.

achillesId
    

A vector of achilles ids. If NULL default analysis will be used.

## Value

The cdm_reference object with the achilles tables populated.

## Examples
    
    
    # \donttest{
    dbName <- "GiBleed"
    CDMConnector::[requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)(dbName)
    #> ℹ `EUNOMIA_DATA_FOLDER` set to: /tmp/RtmpXq4e42.
    #> 
    #> Download completed!
    con <- duckdb::dbConnect(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)(dbName))
    #> Creating CDM database /tmp/RtmpXq4e42/GiBleed_5.3.zip
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchema = "main", writeSchema = "main"
    )
    
    cdm <- buildAchillesTables(cdm = cdm)
    #> ℹ Creating empty achilles_analysis table.
    #> ℹ Creating empty achilles_results table.
    #> ℹ Creating empty achilles_results_dist table.
    #> ℹ  1 of 21: Get achilles result for Number of persons with at least one visit
    #>   occurrence, by visit_concept_id.
    #> ℹ  2 of 21: Get achilles result for Number of visit occurrence records, by
    #>   visit_concept_id.
    #> ℹ  3 of 21: Get achilles result for Number of visit_occurrence records by
    #>   visit_source_concept_id.
    #> ℹ  4 of 21: Get achilles result for Number of persons with at least one
    #>   condition occurrence, by condition_concept_id.
    #> ℹ  5 of 21: Get achilles result for Number of condition occurrence records, by
    #>   condition_concept_id.
    #> ℹ  6 of 21: Get achilles result for Number of condition_occurrence records by
    #>   condition_source_concept_id.
    #> ℹ  7 of 21: Get achilles result for Number of persons with at least one
    #>   procedure occurrence, by procedure_concept_id.
    #> ℹ  8 of 21: Get achilles result for Number of procedure occurrence records, by
    #>   procedure_concept_id.
    #> ℹ  9 of 21: Get achilles result for Number of procedure_occurrence records by
    #>   procedure_source_concept_id.
    #> ℹ 10 of 21: Get achilles result for Number of persons with at least one drug
    #>   exposure, by drug_concept_id.
    #> ℹ 11 of 21: Get achilles result for Number of drug exposure records, by
    #>   drug_concept_id.
    #> ℹ 12 of 21: Get achilles result for Number of drug_exposure records by
    #>   drug_source_concept_id.
    #> ℹ 13 of 21: Get achilles result for Number of persons with at least one
    #>   observation occurrence, by observation_concept_id.
    #> ℹ 14 of 21: Get achilles result for Number of observation occurrence records,
    #>   by observation_concept_id.
    #> ℹ 15 of 21: Get achilles result for Number of observation records by
    #>   observation_source_concept_id.
    #> ℹ 16 of 21: Get achilles result for Number of persons with at least one
    #>   measurement occurrence, by measurement_concept_id.
    #> ℹ 17 of 21: Get achilles result for Number of measurement occurrence records,
    #>   by measurement_concept_id.
    #> ℹ 18 of 21: Get achilles result for Number of measurement records by
    #>   measurement_source_concept_id.
    #> ℹ 19 of 21: Get achilles result for Number of persons with at least one device
    #>   exposure, by device_concept_id.
    #> ℹ 20 of 21: Get achilles result for Number of device exposure records, by
    #>   device_concept_id.
    #> ℹ 21 of 21: Get achilles result for Number of device_exposure records by
    #>   device_source_concept_id.
    
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
