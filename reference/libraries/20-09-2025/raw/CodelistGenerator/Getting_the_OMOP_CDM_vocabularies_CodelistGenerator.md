# Getting the OMOP CDM vocabularies • CodelistGenerator

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
