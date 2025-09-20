# Summarise code use in patient-level data. — summariseCodeUse • CodelistGenerator

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
