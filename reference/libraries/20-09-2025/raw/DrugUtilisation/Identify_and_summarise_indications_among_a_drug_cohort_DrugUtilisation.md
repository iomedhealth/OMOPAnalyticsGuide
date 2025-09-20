# Identify and summarise indications among a drug cohort • DrugUtilisation

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

# Identify and summarise indications among a drug cohort

Source: [`vignettes/indication.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/indication.Rmd)

`indication.Rmd`

## Introduction

In this vignette, we demonstrate the functionality provided by the DrugUtilisation package to help understand the indications of patients in a drug cohort.

The DrugUtilisation package is designed to work with data in the OMOP CDM format, so our first step is to create a reference to the data using the DBI and CDMConnector packages.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con,
      cdmSchema = "main",
      writeSchema = "main"
    )

### Create a drug utilisation cohort

We will use _acetaminophen_ as our example drug. We’ll start by creating a cohort of acetaminophen users. Here we’ll include all acetaminophen records using a gap era of 7 days, but as we’ve seen in the previous vignette we could have also applied various other inclusion criteria.
    
    
    cdm <- [generateIngredientCohortSet](../reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      name = "acetaminophen_users",
      ingredient = "acetaminophen",
      gapEra = 7
    )

Note that `addIndication` works with a cohort as input, in this example we will use drug cohorts created with `generateDrugUtilisationCohortSet` but the input cohorts can be generated using many other ways.

### Create a indication cohort

Next we will create a set of indication cohorts. In this case we will create cohorts for sinusitis and bronchitis using `[CDMConnector::generateConceptCohortSet()](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)`.
    
    
    indications <- [list](https://rdrr.io/r/base/list.html)(
      sinusitis = [c](https://rdrr.io/r/base/c.html)(257012, 4294548, 40481087),
      bronchitis = [c](https://rdrr.io/r/base/c.html)(260139, 258780)
    )
    
    cdm <- CDMConnector::[generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm, name = "indications_cohort", indications, end = 0
    )
    cdm

## Add indications with addIndication() function

Now that we have these two cohort tables, one with our drug cohort and another with our indications cohort, we can assess patient indications. For this we will specify a time window around the drug cohort start date for which we identify any intersection with the indication cohort. We can add this information as a new variable on our cohort table. This function will add a new column per window provided with the label of the indication.
    
    
    cdm[["acetaminophen_users"]] <- cdm[["acetaminophen_users"]] |>
      [addIndication](../reference/addIndication.html)(
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-30, 0)),
        indexDate = "cohort_start_date"
      )
    cdm[["acetaminophen_users"]] |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 2498, 2693, 3144, 3170, 3376, 3376, 3376, 3443, 3…
    #> $ cohort_start_date    <date> 1986-10-17, 2006-03-27, 1965-05-02, 1979-05-15, …
    #> $ cohort_end_date      <date> 1986-11-14, 2006-04-17, 1965-05-16, 1979-05-29, …
    #> $ indication_m30_to_0  <chr> "none", "none", "none", "none", "bronchitis", "no…

We can see that individuals are classified as having sinusistis (without bronchitis), bronchitis (without sinusitis), sinusitis and bronchitis, or no observed indication.
    
    
    cdm[["acetaminophen_users"]] |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_m30_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_m30_to_0          n
    #>   <chr>                    <dbl>
    #> 1 bronchitis                2527
    #> 2 sinusitis                   18
    #> 3 none                     11351
    #> 4 bronchitis and sinusitis     3

As well as the indication cohort table, we can also use the clinical tables in the OMOP CDM to identify other, unknown, indications. Here we consider anyone who is not in an indication cohort but has a record in the condition occurrence table to have an “unknown” indication. We can see that many of the people previously considered to have no indication are now considered as having an unknown indication as they have a condition occurrence record in the 30 days up to their drug initiation.
    
    
    cdm[["acetaminophen_users"]] |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(!"indication_m30_to_0") |>
      [addIndication](../reference/addIndication.html)(
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-30, 0)),
        unknownIndicationTable = "condition_occurrence"
      ) |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_m30_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_m30_to_0          n
    #>   <chr>                    <dbl>
    #> 1 bronchitis                2527
    #> 2 sinusitis                   18
    #> 3 unknown                  11344
    #> 4 bronchitis and sinusitis     3
    #> 5 none                         7

We can add indications for multiple time windows. Unsurprisingly we find more potential indications for wider windows (although this will likely increase our risk of false positives).
    
    
    cdm[["acetaminophen_users"]] <- cdm[["acetaminophen_users"]] |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(!"indication_m30_to_0") |>
      [addIndication](../reference/addIndication.html)(
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(-30, 0), [c](https://rdrr.io/r/base/c.html)(-365, 0)),
        unknownIndicationTable = "condition_occurrence"
      )
    cdm[["acetaminophen_users"]] |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_0_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_0_to_0     n
    #>   <chr>             <dbl>
    #> 1 unknown           11211
    #> 2 none                163
    #> 3 sinusitis             1
    #> 4 bronchitis         2524
    cdm[["acetaminophen_users"]] |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_m30_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_m30_to_0          n
    #>   <chr>                    <dbl>
    #> 1 bronchitis                2527
    #> 2 sinusitis                   18
    #> 3 unknown                  11344
    #> 4 none                         7
    #> 5 bronchitis and sinusitis     3
    cdm[["acetaminophen_users"]] |>
      dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(indication_m365_to_0) |>
      dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 2]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpb2lpYP/file23ff1a618bc3.duckdb]
    #>   indication_m365_to_0         n
    #>   <chr>                    <dbl>
    #> 1 bronchitis                2615
    #> 2 sinusitis                  211
    #> 3 unknown                  10968
    #> 4 bronchitis and sinusitis   101
    #> 5 none                         4

### Summarise indications with summariseIndication()

Instead of adding variables with indications like above, we could instead obtain a general summary of observed indications. `summariseIndication` has similar arguments to `[addIndication()](../reference/addIndication.html)`, but returns a summary result of the indication.
    
    
    indicationSummary <- cdm[["acetaminophen_users"]] |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(!dplyr::[starts_with](https://tidyselect.r-lib.org/reference/starts_with.html)("indication")) |>
      [summariseIndication](../reference/summariseIndication.html)(
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(-30, 0), [c](https://rdrr.io/r/base/c.html)(-365, 0)),
        unknownIndicationTable = [c](https://rdrr.io/r/base/c.html)("condition_occurrence")
      )

We can then easily create a plot or a table of the results
    
    
    [tableIndication](../reference/tableIndication.html)(indicationSummary)

|  CDM name  
---|---  
|  Synthea  
Indication | Estimate name |  Cohort name  
acetaminophen  
Indication on index date  
bronchitis | N (%) | 2,524 (18.16 %)  
sinusitis | N (%) | 1 (0.01 %)  
bronchitis and sinusitis | N (%) | 0 (0.00 %)  
unknown | N (%) | 11,211 (80.66 %)  
none | N (%) | 163 (1.17 %)  
not in observation | N (%) | 0 (0.00 %)  
Indication from 30 days before to the index date  
bronchitis | N (%) | 2,527 (18.18 %)  
sinusitis | N (%) | 18 (0.13 %)  
bronchitis and sinusitis | N (%) | 3 (0.02 %)  
unknown | N (%) | 11,344 (81.62 %)  
none | N (%) | 7 (0.05 %)  
not in observation | N (%) | 0 (0.00 %)  
Indication from 365 days before to the index date  
bronchitis | N (%) | 2,615 (18.81 %)  
sinusitis | N (%) | 211 (1.52 %)  
bronchitis and sinusitis | N (%) | 101 (0.73 %)  
unknown | N (%) | 10,968 (78.91 %)  
none | N (%) | 4 (0.03 %)  
not in observation | N (%) | 0 (0.00 %)  
      
    
    [plotIndication](../reference/plotIndication.html)(indicationSummary)

![](indication_files/figure-html/unnamed-chunk-10-1.png)

As well as getting these overall results, we can also stratify the results by some variables of interest. For example, here we stratify our results by age groups and sex.
    
    
    indicationSummaryStratified <- cdm[["acetaminophen_users"]] |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(!dplyr::[starts_with](https://tidyselect.r-lib.org/reference/starts_with.html)("indication")) |>
      PatientProfiles::[addDemographics](https://darwin-eu.github.io/PatientProfiles/reference/addDemographics.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 19), [c](https://rdrr.io/r/base/c.html)(20, 150))) |>
      [summariseIndication](../reference/summariseIndication.html)(
        strata = [list](https://rdrr.io/r/base/list.html)("age_group", "sex"),
        indicationCohortName = "indications_cohort",
        indicationWindow = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(-30, 0), [c](https://rdrr.io/r/base/c.html)(-365, 0)),
        unknownIndicationTable = [c](https://rdrr.io/r/base/c.html)("condition_occurrence")
      )
    
    
    [tableIndication](../reference/tableIndication.html)(indicationSummaryStratified)

|  CDM name  
---|---  
|  Synthea  
|  Cohort name  
|  acetaminophen  
|  Age group  
|  overall |  0 to 19 |  20 to 150 |  overall  
Indication | Estimate name |  Sex  
overall | overall | overall | Female | Male  
Indication on index date  
bronchitis | N (%) | 2,524 (18.16 %) | 1,823 (29.90 %) | 701 (8.98 %) | 1,290 (18.42 %) | 1,234 (17.90 %)  
sinusitis | N (%) | 1 (0.01 %) | 1 (0.02 %) | 0 (0.00 %) | 0 (0.00 %) | 1 (0.01 %)  
bronchitis and sinusitis | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
unknown | N (%) | 11,211 (80.66 %) | 4,242 (69.59 %) | 6,969 (89.31 %) | 5,619 (80.23 %) | 5,592 (81.10 %)  
none | N (%) | 163 (1.17 %) | 30 (0.49 %) | 133 (1.70 %) | 95 (1.36 %) | 68 (0.99 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
Indication from 30 days before to the index date  
bronchitis | N (%) | 2,527 (18.18 %) | 1,826 (29.95 %) | 701 (8.98 %) | 1,291 (18.43 %) | 1,236 (17.93 %)  
sinusitis | N (%) | 18 (0.13 %) | 15 (0.25 %) | 3 (0.04 %) | 11 (0.16 %) | 7 (0.10 %)  
bronchitis and sinusitis | N (%) | 3 (0.02 %) | 2 (0.03 %) | 1 (0.01 %) | 1 (0.01 %) | 2 (0.03 %)  
unknown | N (%) | 11,344 (81.62 %) | 4,253 (69.77 %) | 7,091 (90.88 %) | 5,701 (81.40 %) | 5,643 (81.84 %)  
none | N (%) | 7 (0.05 %) | 0 (0.00 %) | 7 (0.09 %) | 0 (0.00 %) | 7 (0.10 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
Indication from 365 days before to the index date  
bronchitis | N (%) | 2,615 (18.81 %) | 1,883 (30.89 %) | 732 (9.38 %) | 1,353 (19.32 %) | 1,262 (18.30 %)  
sinusitis | N (%) | 211 (1.52 %) | 191 (3.13 %) | 20 (0.26 %) | 108 (1.54 %) | 103 (1.49 %)  
bronchitis and sinusitis | N (%) | 101 (0.73 %) | 96 (1.57 %) | 5 (0.06 %) | 39 (0.56 %) | 62 (0.90 %)  
unknown | N (%) | 10,968 (78.91 %) | 3,926 (64.40 %) | 7,042 (90.25 %) | 5,504 (78.58 %) | 5,464 (79.25 %)  
none | N (%) | 4 (0.03 %) | 0 (0.00 %) | 4 (0.05 %) | 0 (0.00 %) | 4 (0.06 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
      
    
    indicationSummaryStratified |>
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Indication on index date") |>
      [plotIndication](../reference/plotIndication.html)(
        facet = . ~ age_group + sex,
        colour = "variable_level"
      )

![](indication_files/figure-html/unnamed-chunk-13-1.png)

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
