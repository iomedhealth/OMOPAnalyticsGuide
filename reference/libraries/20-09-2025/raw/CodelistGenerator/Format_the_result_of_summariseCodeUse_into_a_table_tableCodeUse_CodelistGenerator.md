# Format the result of summariseCodeUse into a table. — tableCodeUse • CodelistGenerator

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
