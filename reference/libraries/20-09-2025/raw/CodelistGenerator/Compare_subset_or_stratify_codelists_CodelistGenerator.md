# Compare, subset or stratify codelists • CodelistGenerator

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
