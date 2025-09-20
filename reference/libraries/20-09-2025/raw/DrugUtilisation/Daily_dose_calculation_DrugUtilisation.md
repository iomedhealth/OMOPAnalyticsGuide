# Daily dose calculation • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# Daily dose calculation

Source: [`vignettes/daily_dose_calculation.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/daily_dose_calculation.Rmd)

`daily_dose_calculation.Rmd`

## Introduction

In this vignette is assessed how daily dose is calculated in the DrugUtilisation package. This function is used internally in `[addDrugUtilisation()](../reference/addDrugUtilisation.html)`.

### Daily dose

Daily dose is always computed at the ingredient level. So we can calculate the daily dose for each record in _drug exposure_ table for each given ingredient. Then the first step to calculate the daily dose for a given drug record and an ingredient concept id is to examine the relationship between drug concept id and ingredient concept id through the _drug strength_ table:
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividuals = 100, seed = 123456)
    cdm$drug_strength |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 12
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ drug_concept_id             <int> 1125315, 1125360, 1503297, 1503327, 150332…
    #> $ ingredient_concept_id       <int> 1125315, 1125315, 1503297, 1503297, 150329…
    #> $ amount_value                <dbl> NA, 5.0e+02, NA, 1.0e+03, 5.0e+02, NA, NA,…
    #> $ amount_unit_concept_id      <int> 8576, 8576, 8576, 8576, 8576, 8510, NA, NA…
    #> $ numerator_value             <dbl> NA, NA, NA, NA, NA, NA, 100, 300, NA, NA, …
    #> $ numerator_unit_concept_id   <int> NA, NA, NA, NA, NA, NA, 8510, 8510, NA, NA…
    #> $ denominator_value           <dbl> NA, NA, NA, NA, NA, NA, NA, 3, NA, NA, NA,…
    #> $ denominator_unit_concept_id <int> NA, NA, NA, NA, NA, NA, 8587, 8587, NA, NA…
    #> $ box_size                    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ valid_start_date            <date> 1-01-19, 1-01-19, 1-01-19, 1-01-19, 1-01-…
    #> $ valid_end_date              <date> 31-12-20, 31-12-20, 31-12-20, 31-12-20, 3…
    #> $ invalid_reason              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…

You can read the documentation of the _drug strength_ table and description of the different fields here: <https://www.ohdsi.org/web/wiki/doku.php?id=documentation:cdm:drug_strength>.

Not all drug concept ids and ingredient concept ids can be related, if no relation is found then daily dose is considered as `NA`.

Using vocabulary version: “v5.0 31-AUG-23” there exist 2,980,115 relationships between a drug concept id and an ingredient concept id. These relationships can be classified into **128** different patterns. Patterns are identified of combinations of 6 variables:

  * _amount_ : Whether the amount_value field is numeric or NA.
  * _amount_unit_ : The unit of the amount field.
  * _numerator_ : Whether the numerator_value field is numeric or NA.
  * _numerator_unit_ : The unit of the numerator field.
  * _denominator_ : Whether the denominator_value field is numeric or NA.
  * _denominator_unit_ : The unit of the denominator field.



These 128 combinations were analysed to see if they could be used to compute daily dose. **41 viable** patterns were identified, these patterns covered a total of 2,514,608 (84%) relationships between drug concept id and ingredient concept id. The patterns were classified into 4 different formulas:

  1. **Time based with denominator**



This formula was applied for the following 3 patterns that cover 8,044 (<1%) relationships:

pattern_id | amount | amount_unit | numerator | numerator_unit | denominator | denominator_unit  
---|---|---|---|---|---|---  
1 |  |  | number | microgram | number | hour  
2 |  |  | number | milligram | number | hour  
3 |  |  | number | unit | number | hour  
  
The formula in this case will be as follows:

if (denominator > 24)→daily dose=24⋅numeratordenominatorif (denominator≤24)→daily dose=numerator \begin{aligned} \text{if (denominator > 24)} &\rightarrow \text{daily dose} = 24 \cdot \frac{\text{numerator}}{\text{denominator}} \\\ \text{if (denominator} \leq 24) &\rightarrow \text{daily dose} = \text{numerator} \end{aligned} 

Note that daily dose has always unit associated in this case it will be determined by the `numerator_unit` field.

  2. **Time based no denominator**



This formula was applied for the following 2 patterns that cover 5,611 (<1%) relationships:

pattern_id | amount | amount_unit | numerator | numerator_unit | denominator | denominator_unit  
---|---|---|---|---|---|---  
4 |  |  | number | microgram |  | hour  
5 |  |  | number | milligram |  | hour  
  
The formula in this case will be as follows:

daily dose=24⋅numerator\begin{equation} \textrm{daily dose} = 24 \cdot numerator \end{equation}

In this case unit will be determined by the `numerator_unit` field.

  3. **Fixed amount formulation**



This formula was applied for the following 6 patterns that cover 1,102,435 (37%) relationships:

pattern_id | amount | amount_unit | numerator | numerator_unit | denominator | denominator_unit  
---|---|---|---|---|---|---  
6 | number | international unit |  |  |  |   
7 | number | microgram |  |  |  |   
8 | number | milliequivalent |  |  |  |   
9 | number | milligram |  |  |  |   
10 | number | milliliter |  |  |  |   
11 | number | unit |  |  |  |   
  
The formula in this case will be as follows:

daily dose=quantity⋅amountdaysexposed\begin{equation} \textrm{daily dose} = \frac{quantity \cdot amount}{days\: exposed} \end{equation}

In this case unit will be determined by the `amount_unit` field.

  4. **Concentration formulation**



This formula was applied for the following 30 patterns that cover 1,398,518 (47%) relationships:

pattern_id | amount | amount_unit | numerator | numerator_unit | denominator | denominator_unit  
---|---|---|---|---|---|---  
12 |  |  | number | international unit | number | milligram  
13 |  |  | number | international unit | number | milliliter  
14 |  |  | number | milliequivalent | number | milliliter  
15 |  |  | number | milligram | number | Actuation  
16 |  |  | number | milligram | number | liter  
17 |  |  | number | milligram | number | milligram  
18 |  |  | number | milligram | number | milliliter  
19 |  |  | number | milligram | number | square centimeter  
20 |  |  | number | milliliter | number | milligram  
21 |  |  | number | milliliter | number | milliliter  
22 |  |  | number | unit | number | Actuation  
23 |  |  | number | unit | number | milligram  
24 |  |  | number | unit | number | milliliter  
25 |  |  | number | unit | number | square centimeter  
26 |  |  | number | international unit |  | milligram  
27 |  |  | number | international unit |  | milliliter  
28 |  |  | number | mega-international unit |  | milliliter  
29 |  |  | number | milliequivalent |  | milligram  
30 |  |  | number | milliequivalent |  | milliliter  
31 |  |  | number | milligram |  | Actuation  
32 |  |  | number | milligram |  | liter  
33 |  |  | number | milligram |  | milligram  
34 |  |  | number | milligram |  | milliliter  
35 |  |  | number | milligram |  | square centimeter  
36 |  |  | number | milliliter |  | milligram  
37 |  |  | number | milliliter |  | milliliter  
38 |  |  | number | unit |  | Actuation  
39 |  |  | number | unit |  | milligram  
40 |  |  | number | unit |  | milliliter  
41 |  |  | number | unit |  | square centimeter  
  
The formula in this case will be as follows:

daily dose=quantity⋅numeratordaysexposed\begin{equation} \textrm{daily dose} = \frac{quantity \cdot numerator}{days\: exposed} \end{equation}

In this case unit will be determined by the `numerator_unit` field.

For formulas (3) and (4) quantity is obtained from the `quantity` column of the _drug exposure_ table and time exposed is obtained as the difference in days between `drug_exposure_start_date` and `drug_exposure_end_date` plus one.

The described formulas and patterns can be found in the exported `patternsWithFormula` data set:
    
    
    patternsWithFormula |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 41
    #> Columns: 9
    #> $ pattern_id       <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16…
    #> $ amount           <chr> NA, NA, NA, NA, NA, "number", "number", "number", "nu…
    #> $ amount_unit      <chr> NA, NA, NA, NA, NA, "international unit", "microgram"…
    #> $ numerator        <chr> "number", "number", "number", "number", "number", NA,…
    #> $ numerator_unit   <chr> "microgram", "milligram", "unit", "microgram", "milli…
    #> $ denominator      <chr> "number", "number", "number", NA, NA, NA, NA, NA, NA,…
    #> $ denominator_unit <chr> "hour", "hour", "hour", "hour", "hour", NA, NA, NA, N…
    #> $ formula_name     <chr> "time based with denominator", "time based with denom…
    #> $ formula          <chr> "if (denominator>24) {numerator * 24 / denominator} e…

The described formulas were validated into 5 different databases and the results were included in an article. Please refer to it for more details on dose calculations: [Calculating daily dose in the Observational Medical Outcomes Partnership Common Data Model](https://doi.org/10.1002/pds.5809).

### Finding out the pattern information using patternTable() function

The user could also find the patterns used in the `drug_strength` table. The output will also include a column of potentially valid and invalid combinations. The idea of a pattern to provide a platform to associate each drug in the `drug_strength` table with its constituent ingredients.
    
    
    [patternTable](../reference/patternTable.html)(cdm) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 5
    #> Columns: 12
    #> $ pattern_id                  <dbl> 9, 18, 24, 40, NA
    #> $ formula_name                <chr> "fixed amount formulation", "concentration…
    #> $ validity                    <chr> "pattern with formula", "pattern with form…
    #> $ number_concepts             <dbl> 7, 1, 1, 1, 4
    #> $ number_ingredients          <dbl> 4, 1, 1, 1, 4
    #> $ number_records              <dbl> 169, 34, 32, 35, 25
    #> $ amount_numeric              <dbl> 1, 0, 0, 0, NA
    #> $ amount_unit_concept_id      <dbl> 8576, NA, NA, NA, NA
    #> $ numerator_numeric           <dbl> 0, 1, 1, 1, NA
    #> $ numerator_unit_concept_id   <dbl> NA, 8576, 8510, 8510, NA
    #> $ denominator_numeric         <dbl> 0, 1, 1, 0, NA
    #> $ denominator_unit_concept_id <dbl> NA, 8587, 8587, 8587, NA

The output has three important columns, namely `number_concepts`, `number_ingredients` and `number_records`, which corresponds to count of distinct concepts in the patterns, count of distinct ingredients involved and overall count of records in the patterns respectively. The `pattern_id` column can be used to relate the patterns with the `patternsWithFormula` data set.

### Finding out the dose coverage using summariseDoseCoverage() function

This package also provides a functionality to check the coverage daily dose computation for chosen concept sets and ingredients. Let’s take _acetaminophen_ as an example.
    
    
    [summariseDoseCoverage](../reference/summariseDoseCoverage.html)(cdm = cdm, ingredientConceptId = 1125315) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 56
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "ingredient_name", "ingredient_name", "ingredient_nam…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "Missing dose", "Missing dose", "da…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count_missing", "percentage_missing", "mean…
    #> $ estimate_type    <chr> "integer", "integer", "percentage", "numeric", "numer…
    #> $ estimate_value   <chr> "78", "0", "0", "14949.800361887", "99310.1784420234"…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

The output will summarise the usage of _acetaminophen_ in the database. For example, overall there are 7878 records of _acetaminophen_ and for all of them daily dose can be calculated. By default the output will also include the mean, median, lower and upper quartiles and standard deviation of the daily dose of _acetaminophen_ calculated as explained above. The results will also be stratified by unit, route and pattern (which we saw in `patternsWithFormula` data set).

Different routes are documented in the **CodelistGenerator** package. Route is defined at the concept (`drug_concept_id`) level, there exist an equivalence between each concept and a route. You can stratify a codelist using the function: `[CodelistGenerator::stratifyByRouteCategory()](https://darwin-eu.github.io/CodelistGenerator/reference/stratifyByRouteCategory.html)`.

To better inspect the content of the output of `[summariseDoseCoverage()](../reference/summariseDoseCoverage.html)` we can create a gt table like so:
    
    
    coverageResult <- [summariseDoseCoverage](../reference/summariseDoseCoverage.html)(cdm = cdm, ingredientConceptId = 1125315)
    [tableDoseCoverage](../reference/tableDoseCoverage.html)(coverageResult)

|  Variable name  
---|---  
|  number records |  Missing dose |  daily_dose  
Unit | Route | Pattern id |  Estimate name  
N | N (%) | Mean (SD) | Median (Q25 - Q75)  
DUS MOCK; acetaminophen  
overall | overall | overall | 78 | 0 (0.00 %) | 14,949.80 (99,310.18) | 234.38 (19.68 - 1,264.66)  
milligram | overall | overall | 78 | 0 (0.00 %) | 14,949.80 (99,310.18) | 234.38 (19.68 - 1,264.66)  
| oral | overall | 18 | 0 (0.00 %) | 182.38 (294.08) | 41.03 (15.69 - 237.42)  
| topical | overall | 60 | 0 (0.00 %) | 19,380.03 (113,070.32) | 308.61 (28.48 - 1,962.38)  
| oral | 9 | 18 | 0 (0.00 %) | 182.38 (294.08) | 41.03 (15.69 - 237.42)  
| topical | 18 | 34 | 0 (0.00 %) | 32,837.73 (149,637.62) | 1,066.79 (243.71 - 4,339.96)  
|  | 9 | 26 | 0 (0.00 %) | 1,781.50 (6,876.01) | 49.95 (4.96 - 268.87)  
  
The user also has the freedom to customize the gt table output. For example the following will suppress the `cdmName`:
    
    
    [tableDoseCoverage](../reference/tableDoseCoverage.html)(coverageResult, groupColumn = "ingredient_name", hide = "cdm_name")

|  Variable name  
---|---  
|  number records |  Missing dose |  daily_dose  
Sample size | Unit | Route | Pattern id | Variable level |  Estimate name  
N | N (%) | Mean (SD) | Median (Q25 - Q75)  
acetaminophen  
Inf | overall | overall | overall | - | 78 | 0 (0.00 %) | 14,949.80 (99,310.18) | 234.38 (19.68 - 1,264.66)  
| milligram | overall | overall | - | 78 | 0 (0.00 %) | 14,949.80 (99,310.18) | 234.38 (19.68 - 1,264.66)  
|  | oral | overall | - | 18 | 0 (0.00 %) | 182.38 (294.08) | 41.03 (15.69 - 237.42)  
|  | topical | overall | - | 60 | 0 (0.00 %) | 19,380.03 (113,070.32) | 308.61 (28.48 - 1,962.38)  
|  | oral | 9 | - | 18 | 0 (0.00 %) | 182.38 (294.08) | 41.03 (15.69 - 237.42)  
|  | topical | 18 | - | 34 | 0 (0.00 %) | 32,837.73 (149,637.62) | 1,066.79 (243.71 - 4,339.96)  
|  |  | 9 | - | 26 | 0 (0.00 %) | 1,781.50 (6,876.01) | 49.95 (4.96 - 268.87)  
  
## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
