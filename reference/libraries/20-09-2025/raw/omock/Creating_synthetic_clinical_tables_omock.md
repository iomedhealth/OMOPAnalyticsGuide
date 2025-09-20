# Creating synthetic clinical tables • omock

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Creating synthetic clinical tables

Source: [`vignettes/a01_Creating_synthetic_clinical_tables.Rmd`](https://github.com/ohdsi/omock/blob/main/vignettes/a01_Creating_synthetic_clinical_tables.Rmd)

`a01_Creating_synthetic_clinical_tables.Rmd`

The omock package provides functionality to quickly create a cdm reference containing synthetic data based on population settings specified by the user.

First, let’s load packages required for this vignette.
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

Now, in three lines of code, we can create a cdm reference with a person and observation period table for 1000 people.
    
    
    cdm <- [emptyCdmReference](https://darwin-eu.github.io/omopgenerics/reference/emptyCdmReference.html)(cdmName = "synthetic cdm") |>
      [mockPerson](../reference/mockPerson.html)(nPerson = 1000) |>
      [mockObservationPeriod](../reference/mockObservationPeriod.html)()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of synthetic cdm ───────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    cdm$person |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,000
    #> Columns: 18
    #> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,…
    #> $ gender_concept_id           <int> 8532, 8532, 8532, 8507, 8532, 8507, 8507, …
    #> $ year_of_birth               <int> 1991, 1998, 1981, 1956, 1985, 1961, 1982, …
    #> $ month_of_birth              <int> 10, 11, 5, 2, 2, 6, 1, 3, 2, 5, 3, 6, 2, 1…
    #> $ day_of_birth                <int> 15, 24, 22, 23, 9, 4, 3, 22, 28, 3, 26, 4,…
    #> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ birth_datetime              <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    
    cdm$observation_period |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,000
    #> Columns: 5
    #> $ observation_period_id         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ person_id                     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ observation_period_start_date <date> 2007-03-18, 2005-12-23, 2016-07-23, 201…
    #> $ observation_period_end_date   <date> 2018-05-20, 2014-02-14, 2018-08-23, 201…
    #> $ period_type_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …

We can add further requirements around the population we create. For example we can require that they were born between 1960 and 1980 like so.
    
    
    cdm <- [emptyCdmReference](https://darwin-eu.github.io/omopgenerics/reference/emptyCdmReference.html)(cdmName = "synthetic cdm") |>
      [mockPerson](../reference/mockPerson.html)(
        nPerson = 1000,
        birthRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1960-01-01", "1980-12-31"))
      ) |>
      [mockObservationPeriod](../reference/mockObservationPeriod.html)()
    
    
    cdm$person |>
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() |>
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)([as.integer](https://rdrr.io/r/base/integer.html)(year_of_birth)),
        binwidth = 1, colour = "grey"
      ) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year of birth")

![](a01_Creating_synthetic_clinical_tables_files/figure-html/unnamed-chunk-5-1.png)

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
