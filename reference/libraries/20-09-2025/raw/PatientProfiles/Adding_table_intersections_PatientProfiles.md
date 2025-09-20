# Adding table intersections • PatientProfiles

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

# Adding table intersections

Source: [`vignettes/table-intersect.Rmd`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/vignettes/table-intersect.Rmd)

`table-intersect.Rmd`

So far we’ve seen that we can add variables indicating intersections based on cohorts or concept sets. One additional option we have is to simply add an intersection based on a table.

Let’s again create a cohort containing people with an ankle sprain.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    CDMConnector::[requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(),
      dbdir = CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()
    )
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
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         99 1959-08-21        1959-09-18     
    #>  2                    1        331 1948-08-28        1948-10-02     
    #>  3                    1        399 1999-03-30        1999-05-04     
    #>  4                    1        404 1962-06-04        1962-07-09     
    #>  5                    1        744 1972-04-12        1972-05-03     
    #>  6                    1        895 1962-11-21        1962-12-05     
    #>  7                    1       1022 2005-12-21        2006-01-11     
    #>  8                    1       1510 1968-05-13        1968-05-27     
    #>  9                    1       1641 1967-04-20        1967-05-11     
    #> 10                    1       1670 2002-10-26        2002-11-16     
    #> # ℹ more rows
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "condition_occurrence",
        window = [c](https://rdrr.io/r/base/c.html)(-30, -1)
      ) |>
      [tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [?? x 1]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #>       n
    #>   <dbl>
    #> 1  1915

We can use table intersection functions to check whether someone had a record in the drug exposure table in the 30 days before their ankle sprain. If we set targetStartDate to “drug_exposure_start_date” and targetEndDate to “drug_exposure_end_date” we are checking whether an individual had an ongoing drug exposure record in the window.
    
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        targetStartDate = "drug_exposure_start_date",
        targetEndDate = "drug_exposure_end_date",
        window = [c](https://rdrr.io/r/base/c.html)(-30, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id    <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id              <int> 4572, 5200, 2097, 2651, 4026, 4820, 3386, 1107…
    #> $ cohort_start_date       <date> 1977-11-08, 1960-08-20, 1982-11-04, 1951-06-2…
    #> $ cohort_end_date         <date> 1977-12-13, 1960-09-03, 1982-12-02, 1951-07-2…
    #> $ drug_exposure_m30_to_m1 <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…

Meanwhile if we set we set targetStartDate to “drug_exposure_start_date” and targetEndDate to “drug_exposure_start_date” we will instead be checking whether they had a drug exposure record that started during the window.
    
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(-30, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id    <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id              <int> 4572, 5200, 2097, 2651, 4026, 4820, 3386, 1107…
    #> $ cohort_start_date       <date> 1977-11-08, 1960-08-20, 1982-11-04, 1951-06-2…
    #> $ cohort_end_date         <date> 1977-12-13, 1960-09-03, 1982-12-02, 1951-07-2…
    #> $ drug_exposure_m30_to_m1 <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…

As before, instead of a flag, we could also add count, date, or days variables.
    
    
    cdm$ankle_sprain |>
      [addTableIntersectCount](../reference/addTableIntersectCount.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        window = [c](https://rdrr.io/r/base/c.html)(-180, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id               <int> 99, 1641, 4563, 4572, 5200, 2235, 2243, 2425,…
    #> $ cohort_start_date        <date> 1959-08-21, 1967-04-20, 1980-04-17, 1977-11-…
    #> $ cohort_end_date          <date> 1959-09-18, 1967-05-11, 1980-05-15, 1977-12-…
    #> $ drug_exposure_m180_to_m1 <dbl> 4, 2, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    
    cdm$ankle_sprain |>
      [addTableIntersectDate](../reference/addTableIntersectDate.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-180, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id               <int> 99, 1641, 4572, 5200, 2235, 2243, 2425, 2988,…
    #> $ cohort_start_date        <date> 1959-08-21, 1967-04-20, 1977-11-08, 1960-08-…
    #> $ cohort_end_date          <date> 1959-09-18, 1967-05-11, 1977-12-13, 1960-09-…
    #> $ drug_exposure_m180_to_m1 <date> 1959-07-04, 1967-02-07, 1977-10-18, 1960-07-…
    
    
    cdm$ankle_sprain |>
      [addTableIntersectDate](../reference/addTableIntersectDate.html)(
        tableName = "drug_exposure",
        indexDate = "cohort_start_date",
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-180, -1)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id               <int> 99, 1641, 4572, 5200, 2235, 2243, 2425, 2988,…
    #> $ cohort_start_date        <date> 1959-08-21, 1967-04-20, 1977-11-08, 1960-08-…
    #> $ cohort_end_date          <date> 1959-09-18, 1967-05-11, 1977-12-13, 1960-09-…
    #> $ drug_exposure_m180_to_m1 <date> 1959-07-04, 1967-02-07, 1977-10-18, 1960-07-…

In these examples we’ve been adding intersections using the entire drug exposure concept table. However, we could have subsetted it before adding our table intersection. For example, let’s say we want to add a variable for acetaminophen use among our ankle sprain cohort. As we’ve seen before we could use a cohort or concept set for this, but now we have another option - subset the drug exposure table down to acetaminophen records and add a table intersection.
    
    
    acetaminophen_cs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen")
    )
    
    cdm$acetaminophen_records <- cdm$drug_exposure |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(drug_concept_id [%in%](https://rdrr.io/r/base/match.html) !!acetaminophen_cs[[1]]) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)()
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "acetaminophen_records",
        indexDate = "cohort_start_date",
        targetStartDate = "drug_exposure_start_date",
        targetEndDate = "drug_exposure_end_date",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id              <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    #> $ subject_id                        <int> 99, 331, 399, 404, 744, 895, 1022, 1…
    #> $ cohort_start_date                 <date> 1959-08-21, 1948-08-28, 1999-03-30,…
    #> $ cohort_end_date                   <date> 1959-09-18, 1948-10-02, 1999-05-04,…
    #> $ acetaminophen_records_minf_to_inf <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …

Beyond this table intersection provides a means if implementing a wide range of custom analyses. One more example to show this is provided below, where we check whether individuals have a measurement or procedure record on the date of their ankle sprain.
    
    
    cdm$proc_or_meas <- [union_all](https://dplyr.tidyverse.org/reference/setops.html)(
      cdm$procedure_occurrence |>
        [select](https://dplyr.tidyverse.org/reference/select.html)("person_id",
          "record_date" = "procedure_date"
        ),
      cdm$measurement |>
        [select](https://dplyr.tidyverse.org/reference/select.html)("person_id",
          "record_date" = "measurement_date"
        )
    ) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)()
    
    cdm$ankle_sprain |>
      [addTableIntersectFlag](../reference/addTableIntersectFlag.html)(
        tableName = "proc_or_meas",
        indexDate = "cohort_start_date",
        targetStartDate = "record_date",
        targetEndDate = "record_date",
        window = [c](https://rdrr.io/r/base/c.html)(0, 0)
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 5
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1//tmp/RtmpJz8EBi/file279f6e87e637.duckdb]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 99, 331, 399, 404, 744, 895, 1022, 1510, 1641, 16…
    #> $ cohort_start_date    <date> 1959-08-21, 1948-08-28, 1999-03-30, 1962-06-04, …
    #> $ cohort_end_date      <date> 1959-09-18, 1948-10-02, 1999-05-04, 1962-07-09, …
    #> $ proc_or_meas_0_to_0  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
