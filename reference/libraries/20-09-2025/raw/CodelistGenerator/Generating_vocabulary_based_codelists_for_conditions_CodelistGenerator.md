# Generating vocabulary based codelists for conditions • CodelistGenerator

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
