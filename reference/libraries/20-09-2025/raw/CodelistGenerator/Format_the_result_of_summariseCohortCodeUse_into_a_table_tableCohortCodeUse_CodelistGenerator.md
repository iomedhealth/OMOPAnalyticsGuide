# Format the result of summariseCohortCodeUse into a table. — tableCohortCodeUse • CodelistGenerator

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
