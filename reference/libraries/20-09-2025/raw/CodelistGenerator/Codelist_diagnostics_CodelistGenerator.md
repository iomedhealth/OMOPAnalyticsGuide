# Codelist diagnostics • CodelistGenerator

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
