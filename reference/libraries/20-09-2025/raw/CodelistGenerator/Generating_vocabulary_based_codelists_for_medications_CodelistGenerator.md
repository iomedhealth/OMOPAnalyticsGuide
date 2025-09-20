# Generating vocabulary based codelists for medications • CodelistGenerator

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
