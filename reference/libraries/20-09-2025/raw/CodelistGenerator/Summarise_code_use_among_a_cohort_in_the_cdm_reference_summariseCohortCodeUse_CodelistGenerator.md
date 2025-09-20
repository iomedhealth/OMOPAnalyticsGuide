# Summarise code use among a cohort in the cdm reference — summariseCohortCodeUse • CodelistGenerator

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
