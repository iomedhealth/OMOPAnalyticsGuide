# Add the achilles tables with specified analyses — buildAchillesTables • CodelistGenerator

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
