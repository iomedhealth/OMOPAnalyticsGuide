# Applying requirements related to other cohorts, concept sets, or tables • CohortConstructor

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Applying requirements related to other cohorts, concept sets, or tables

Source: [`vignettes/a04_require_intersections.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a04_require_intersections.Rmd)

`a04_require_intersections.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([visOmopResults](https://darwin-eu.github.io/visOmopResults/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

For this example we’ll use the Eunomia synthetic data from the CDMConnector package.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating a cohort of warfarin users.
    
    
    warfarin_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm, "warfarin")
    cdm$warfarin <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = warfarin_codes, 
                                     name = "warfarin")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$warfarin)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            137             137

As well as our warfarin cohort, let’s also make another cohort containing individuals with a record of a GI bleed. Later we’ll use this cohort when specifying inclusion/ exclusion criteria.
    
    
    cdm$gi_bleed <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm,  
                                  conceptSet = [list](https://rdrr.io/r/base/list.html)("gi_bleed" = 192671L),
                                  name = "gi_bleed")

## Restrictions on cohort presence

We could require that individuals in our medication cohorts are seen (or not seen) in another cohort. To do this we can use the `[requireCohortIntersect()](../reference/requireCohortIntersect.html)` function. Here, for example, we require that individuals have one or more intersections with the GI bleed cohort.
    
    
    cdm$warfarin_gi_bleed <- cdm$warfarin  |>
      [requireCohortIntersect](../reference/requireCohortIntersect.html)(intersections = [c](https://rdrr.io/r/base/c.html)(1,Inf),
                             targetCohortTable = "gi_bleed", 
                             targetCohortId = 1,
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0), 
                             name = "warfarin_gi_bleed")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_gi_bleed)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

The flow chart above illustrates the changes to the cohort of users of acetaminophen when restricted to only include individuals who have at least one record in the GI bleed cohort before their start date for acetaminophen.

Instead of requiring that individuals have a record in the GI bleed cohort, we could instead require that they don’t. In this case we can again use the `[requireCohortIntersect()](../reference/requireCohortIntersect.html)` function, but this time we set the intersections argument to 0 so as to require individuals’ absence in this other cohort.
    
    
    cdm$warfarin_no_gi_bleed <- cdm$warfarin |>
      [requireCohortIntersect](../reference/requireCohortIntersect.html)(intersections = 0,
                             targetCohortTable = "gi_bleed", 
                             targetCohortId = 1,
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0), 
                             name = "warfarin_no_gi_bleed") 
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_no_gi_bleed)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Restrictions on concept presence

We could require that individuals in our medication cohorts have been seen (or not seen) to have events related to a concept list. To do this we can use the `[requireConceptIntersect()](../reference/requireConceptIntersect.html)` function, allowing us to filter our cohort based on whether they have or have not had events of GI bleeding before they entered the cohort.
    
    
    cdm$warfarin_gi_bleed <- cdm$warfarin  |>
      [requireConceptIntersect](../reference/requireConceptIntersect.html)(conceptSet = [list](https://rdrr.io/r/base/list.html)("gi_bleed" = 192671), 
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0), 
                             name = "warfarin_gi_bleed")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_gi_bleed)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

The flow chart above illustrates the changes to cohort 1 when restricted to only include individuals who have had events of GI bleeding at least once before the cohort start date. 2,296 individuals and 8,765 records were excluded.

Instead of requiring that individuals have events of GI bleeding, we could instead require that they don’t have any events of it. In this case we can again use the `[requireConceptIntersect()](../reference/requireConceptIntersect.html)` function, but this time set the intersections argument to 0 to require individuals without past events of GI bleeding.
    
    
    cdm$warfarin_no_gi_bleed <- cdm$warfarin  |>
      [requireConceptIntersect](../reference/requireConceptIntersect.html)(intersections = 0,
                             conceptSet = [list](https://rdrr.io/r/base/list.html)("gi_bleed" = 192671), 
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0), 
                             name = "warfarin_no_gi_bleed")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_no_gi_bleed)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Restrictions on presence in clinical tables

We can also impose requirements around individuals presence (or absence) in clinical tables in the OMOP CDM using the `[requireTableIntersect()](../reference/requireTableIntersect.html)` function. Here for example we reuire that individuals in our warfarin cohort have at least one prior record in the visit occurrence table.
    
    
    cdm$warfarin_visit <- cdm$warfarin  |>
      [requireTableIntersect](../reference/requireTableIntersect.html)(tableName = "visit_occurrence",
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1), 
                             name = "warfarin_visit")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_visit)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
