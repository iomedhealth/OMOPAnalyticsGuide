# Adding concept intersections • PatientProfiles

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Adding concept intersections

Source: [`vignettes/concept-intersect.Rmd`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/vignettes/concept-intersect.Rmd)

`concept-intersect.Rmd`

## Introduction

Concept sets play an important role when working with data in the format of the OMOP CDM. They can be used to create cohorts after which, as we’ve seen in the previous vignette, we can identify intersections between the cohorts. PatientProfiles adds another option for working with concept sets which is use them for adding associated variables directly without first having to create a cohort.

It is important to note, and is explained more below, that results may differ when generating a cohort and then identifying intersections between two cohorts compared to working directly with concept sets. The creation of cohorts will involve the collapsing of overlapping records as well as imposing certain requirements such as only including records that were observed during an individuals observation period. When adding variables based on concept sets we will be working directly with record-level data in the OMOP CDM clinical tables.

## Adding variables from concept sets

For this vignette we’ll use the Eunomia synthetic dataset. First lets create our cohort of interest, individuals with an ankle sprain.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    CDMConnector::[requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main")
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "all",
      overwrite = TRUE
    )
    
    cdm$ankle_sprain
    #> # Source:   table<ankle_sprain> [?? x 4]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1        673 1978-09-28        1978-10-12     
    #>  2                    1        673 2012-05-26        2012-06-16     
    #>  3                    1        775 1948-03-28        1948-04-25     
    #>  4                    1        883 1975-09-30        1975-10-14     
    #>  5                    1       1149 2004-12-21        2005-01-04     
    #>  6                    1       1432 1984-05-28        1984-06-25     
    #>  7                    1       1623 1952-08-23        1952-09-20     
    #>  8                    1       1703 1995-09-02        1995-09-30     
    #>  9                    1       1819 1991-06-10        1991-07-08     
    #> 10                    1       1964 2009-04-25        2009-05-23     
    #> # ℹ more rows

Now let’s say we’re interested in summarising use of acetaminophen among our ankle sprain cohort. We can start by identifying the relevant concepts.
    
    
    acetaminophen_cs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen")
    )
    
    acetaminophen_cs
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - 161_acetaminophen (7 codes)

Once we have our codes for acetaminophen we can create variables based on these. As with cohort intersections, PatientProfiles provides four types of functions for concept intersections.

First, we can add a binary flag variable indicating whether an individual had a record of acetaminophen on the day of their ankle sprain or up to 30 days afterwards.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectFlag](../reference/addConceptIntersectFlag.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 30)
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                  <int> 673, 883, 1432, 1703, 3381, 3488, 3604, 36…
    #> $ cohort_start_date           <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…
    #> $ cohort_end_date             <date> 1978-10-12, 1975-10-14, 1984-06-25, 1995-…
    #> $ `161_acetaminophen_0_to_30` <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …

Second, we can count the number of records of acetaminophen in this same window for each individual.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectCount](../reference/addConceptIntersectCount.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 30)
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                  <int> 673, 883, 1432, 1703, 3381, 3488, 3604, 36…
    #> $ cohort_start_date           <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…
    #> $ cohort_end_date             <date> 1978-10-12, 1975-10-14, 1984-06-25, 1995-…
    #> $ `161_acetaminophen_0_to_30` <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …

Third, we could identify the first start date of acetaminophen in this window.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectDate](../reference/addConceptIntersectDate.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 30),
        order = "first"
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                  <int> 673, 883, 1432, 1703, 3381, 3488, 3604, 36…
    #> $ cohort_start_date           <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…
    #> $ cohort_end_date             <date> 1978-10-12, 1975-10-14, 1984-06-25, 1995-…
    #> $ `161_acetaminophen_0_to_30` <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…

Or fourth, we can get the number of days to the start date of acetaminophen in the window.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectDays](../reference/addConceptIntersectDays.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 30),
        order = "first"
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                  <int> 673, 883, 1432, 1703, 3381, 3488, 3604, 36…
    #> $ cohort_start_date           <date> 1978-09-28, 1975-09-30, 1984-05-28, 1995-…
    #> $ cohort_end_date             <date> 1978-10-12, 1975-10-14, 1984-06-25, 1995-…
    #> $ `161_acetaminophen_0_to_30` <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …

## Adding multiple concept based variables

We can add more than one variable at a time when using these functions. For example, we might want to add variables for multiple time windows.
    
    
    cdm$ankle_sprain |>
      [addConceptIntersectFlag](../reference/addConceptIntersectFlag.html)(
        conceptSet = acetaminophen_cs,
        indexDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)(
          [c](https://rdrr.io/r/base/c.html)(-Inf, -1),
          [c](https://rdrr.io/r/base/c.html)(0, 0),
          [c](https://rdrr.io/r/base/c.html)(1, Inf)
        )
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 7
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id           <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                     <int> 673, 673, 775, 883, 1149, 1432, 1623, 1…
    #> $ cohort_start_date              <date> 1978-09-28, 2012-05-26, 1948-03-28, 19…
    #> $ cohort_end_date                <date> 1978-10-12, 2012-06-16, 1948-04-25, 19…
    #> $ `161_acetaminophen_minf_to_m1` <dbl> 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, …
    #> $ `161_acetaminophen_0_to_0`     <dbl> 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, …
    #> $ `161_acetaminophen_1_to_inf`   <dbl> 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NA,…

Or we might want to get variables for multiple drug ingredients of interest.
    
    
    meds_cs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)(
        "acetaminophen",
        "amoxicillin",
        "aspirin",
        "heparin",
        "morphine",
        "oxycodone",
        "warfarin"
      )
    )
    
    cdm$ankle_sprain |>
      [addConceptIntersectFlag](../reference/addConceptIntersectFlag.html)(
        conceptSet = meds_cs,
        indexDate = "cohort_start_date",
        window = [list](https://rdrr.io/r/base/list.html)(
          [c](https://rdrr.io/r/base/c.html)(-Inf, -1),
          [c](https://rdrr.io/r/base/c.html)(0, 0)
        )
      ) |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 18
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/Rtmpjx3bqx/file26dad219dc2.duckdb]
    #> $ cohort_definition_id           <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                     <int> 525, 3158, 576, 5063, 759, 1941, 1415, …
    #> $ cohort_start_date              <date> 2000-09-17, 1971-09-18, 1999-06-28, 19…
    #> $ cohort_end_date                <date> 2000-10-08, 1971-10-16, 1999-07-12, 19…
    #> $ `7052_morphine_minf_to_m1`     <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `723_amoxicillin_minf_to_m1`   <dbl> 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, …
    #> $ `7804_oxycodone_minf_to_m1`    <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, …
    #> $ `5224_heparin_minf_to_m1`      <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `723_amoxicillin_0_to_0`       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `1191_aspirin_minf_to_m1`      <dbl> 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, …
    #> $ `161_acetaminophen_minf_to_m1` <dbl> 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, …
    #> $ `11289_warfarin_minf_to_m1`    <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `161_acetaminophen_0_to_0`     <dbl> 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, …
    #> $ `1191_aspirin_0_to_0`          <dbl> 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, …
    #> $ `11289_warfarin_0_to_0`        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `5224_heparin_0_to_0`          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `7052_morphine_0_to_0`         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    #> $ `7804_oxycodone_0_to_0`        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …

## Cohort-based versus concept-based intersections

In the previous vignette we saw that we can add an intersection variable using a cohort we have created. Meanwhile in this vignette we see that we can instead create an intersection variable using a concept set directly. It is important to note that under some circumstances these two approaches can lead to different results.

When creating a cohort we combine overlapping records, as cohort entries cannot overlap. Thus when adding an intersection count, `[addCohortIntersectCount()](../reference/addCohortIntersectCount.html)` will return a count of cohort entries in the window of interest while `[addConceptIntersectCount()](../reference/addConceptIntersectCount.html)` will return a count of records withing the window. We can see the impact for acetaminophen for our example data below, where we have slightly more records than cohort entries.
    
    
    acetaminophen_cs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen")
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "acetaminophen",
      conceptSet = acetaminophen_cs,
      end = "event_end_date",
      limit = "all"
    )
    
    dplyr::[bind_rows](https://dplyr.tidyverse.org/reference/bind_rows.html)(
      cdm$ankle_sprain |>
        [addCohortIntersectCount](../reference/addCohortIntersectCount.html)(
          targetCohortTable = "acetaminophen",
          window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
        ) |>
        dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(`161_acetaminophen_minf_to_inf`) |>
        dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)() |>
        dplyr::[collect](https://dplyr.tidyverse.org/reference/compute.html)() |>
        dplyr::[arrange](https://dplyr.tidyverse.org/reference/arrange.html)([desc](https://dplyr.tidyverse.org/reference/desc.html)(`161_acetaminophen_minf_to_inf`)) |>
        dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(type = "cohort"),
      cdm$ankle_sprain |>
        [addConceptIntersectCount](../reference/addConceptIntersectCount.html)(
          conceptSet = acetaminophen_cs,
          window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
        ) |>
        dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(`161_acetaminophen_minf_to_inf`) |>
        dplyr::[tally](https://dplyr.tidyverse.org/reference/count.html)() |>
        dplyr::[collect](https://dplyr.tidyverse.org/reference/compute.html)() |>
        dplyr::[arrange](https://dplyr.tidyverse.org/reference/arrange.html)([desc](https://dplyr.tidyverse.org/reference/desc.html)(`161_acetaminophen_minf_to_inf`)) |>
        dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(type = "concept_set")
    ) |>
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_col](https://ggplot2.tidyverse.org/reference/geom_bar.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(`161_acetaminophen_minf_to_inf`, n, fill = type),
        position = "dodge"
      ) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(
        legend.title = [element_blank](https://ggplot2.tidyverse.org/reference/element.html)(),
        legend.position = "top"
      )

![](concept-intersect_files/figure-html/unnamed-chunk-10-1.png)

Additional differences between cohort and concept set intersections may also result from cohort table rules. For example, cohort tables will typically omit any records that occur outside an individual´s observation time (as defined in the observation period window). Such records, however, would not be excluded when adding a concept based intersection.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
