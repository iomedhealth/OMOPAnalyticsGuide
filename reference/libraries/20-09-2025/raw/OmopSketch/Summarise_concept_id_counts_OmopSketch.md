# Summarise concept id counts • OmopSketch

Skip to contents

[OmopSketch](../index.html) 0.5.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Summarise clinical tables records](../articles/summarise_clinical_tables_records.html)
    * [Summarise concept id counts](../articles/summarise_concept_id_counts.html)
    * [Summarise observation period](../articles/summarise_observation_period.html)
    * [Characterisation of OMOP CDM](../articles/characterisation.html)
    * [Summarise missing data](../articles/missing_data.html)
    * [Summarise database characteristics](../articles/database_characteristics.html)
  * [Changelog](../news/index.html)
  * [Characterisation synthetic datasets](https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/)


  *   * [](https://github.com/OHDSI/OmopSketch/)



![](../logo.png)

# Summarise concept id counts

Source: [`vignettes/summarise_concept_id_counts.Rmd`](https://github.com/OHDSI/OmopSketch/blob/main/vignettes/summarise_concept_id_counts.Rmd)

`summarise_concept_id_counts.Rmd`

## Introduction

In this vignette, we will explore the _OmopSketch_ functions designed to provide information about the number of counts of concepts in tables. Specifically, there are two key functions that facilitate this, `[summariseConceptIdCounts()](../reference/summariseConceptIdCounts.html)` and `[tableConceptIdCounts()](../reference/tableConceptIdCounts.html)`. The former one creates a summary statistics results with the number of counts per each concept in the clinical table, and the latter one displays the result in a table.

### Create a mock cdm

Let’s see an example of the previous functions. To start with, we will load essential packages and create a mock cdm using `[mockOmopSketch()](../reference/mockOmopSketch.html)`.
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    
    
    cdm <- [mockOmopSketch](../reference/mockOmopSketch.html)()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mockOmopSketch ─────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, condition_occurrence, death, device_exposure, drug_exposure,
    #> drug_strength, measurement, observation, observation_period, person,
    #> procedure_occurrence, visit_occurrence, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

## Summarise concept id counts

We now use the `[summariseConceptIdCounts()](../reference/summariseConceptIdCounts.html)` function from the OmopSketch package to retrieve counts for each concept id and name, as well as for each source concept id and name, across the clinical tables.
    
    
    [summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm, omopTableName = "drug_exposure") |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(group_level, variable_name, variable_level, estimate_name, estimate_value, additional_name, additional_level) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 216
    #> Columns: 7
    #> $ group_level      <chr> "drug_exposure", "drug_exposure", "drug_exposure", "d…
    #> $ variable_name    <chr> "pneumococcal polysaccharide vaccine, 23 valent", "Al…
    #> $ variable_level   <chr> "40213201", "1557272", "40213160", "1149380", "402132…
    #> $ estimate_name    <chr> "count_records", "count_records", "count_records", "c…
    #> $ estimate_value   <chr> "100", "100", "100", "100", "100", "100", "100", "100…
    #> $ additional_name  <chr> "source_concept_id &&& source_concept_name", "source_…
    #> $ additional_level <chr> "0 &&& No matching concept", "0 &&& No matching conce…

By default, the function returns the number of records (`estimate_name == "count_records"`) for each concept_id. To include counts by person, you can set the `countBy` argument to `"person"` or to c`("record", "person")` to obtain both record and person counts.
    
    
    [summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm,
      omopTableName = "drug_exposure",
      countBy = [c](https://rdrr.io/r/base/c.html)("record", "person")
    ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)( variable_name, estimate_name, estimate_value) 
    #> # A tibble: 432 × 3
    #>    variable_name                                    estimate_name estimate_value
    #>    <chr>                                            <chr>         <chr>         
    #>  1 Midazolam                                        count_records 100           
    #>  2 Midazolam                                        count_subjec… 66            
    #>  3 Diclofenac Sodium 75 MG Delayed Release Oral Ta… count_records 100           
    #>  4 Diclofenac Sodium 75 MG Delayed Release Oral Ta… count_subjec… 61            
    #>  5 tetanus and diphtheria toxoids, adsorbed, prese… count_records 100           
    #>  6 tetanus and diphtheria toxoids, adsorbed, prese… count_subjec… 66            
    #>  7 Diazepam                                         count_records 100           
    #>  8 Diazepam                                         count_subjec… 62            
    #>  9 Astemizole                                       count_records 100           
    #> 10 Astemizole                                       count_subjec… 63            
    #> # ℹ 422 more rows

Further stratification can be applied using the `interval`, `sex`, and `ageGroup` arguments. The interval argument supports “overall” (no time stratification), “years”, “quarters”, or “months”.
    
    
    [summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm,
      omopTableName = "condition_occurrence",
      countBy = "person",
      interval = "years",
      sex = TRUE,
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<=50" = [c](https://rdrr.io/r/base/c.html)(0, 50), ">50" = [c](https://rdrr.io/r/base/c.html)(51, Inf))
    ) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(group_level, strata_level, variable_name, estimate_name, additional_level) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 17,266
    #> Columns: 5
    #> $ group_level      <chr> "condition_occurrence", "condition_occurrence", "cond…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Laceration of hand", "Laceration of foot", "Bullet w…
    #> $ estimate_name    <chr> "count_subjects", "count_subjects", "count_subjects",…
    #> $ additional_level <chr> "0 &&& No matching concept", "0 &&& No matching conce…

We can also filter the clinical table to a specific time window by setting the dateRange argument.
    
    
    summarisedResult <- [summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm,
                                                 omopTableName = "condition_occurrence",
                                                 dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1990-01-01", "2010-01-01"))) 
    summarisedResult |>
      omopgenerics::[settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)()|>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1
    #> Columns: 10
    #> $ result_id          <int> 1
    #> $ result_type        <chr> "summarise_concept_id_counts"
    #> $ package_name       <chr> "OmopSketch"
    #> $ package_version    <chr> "0.5.1"
    #> $ group              <chr> "omop_table"
    #> $ strata             <chr> ""
    #> $ additional         <chr> "source_concept_id &&& source_concept_name"
    #> $ min_cell_count     <chr> "0"
    #> $ study_period_end   <chr> "2010-01-01"
    #> $ study_period_start <chr> "1990-01-01"

Finally, you can summarise concept counts on a subset of records by specifying the `sample` argument.
    
    
    [summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm,
                             omopTableName = "condition_occurrence",
                             sample = 50) |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(group_level, variable_name, estimate_name) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 38
    #> Columns: 3
    #> $ group_level   <chr> "condition_occurrence", "condition_occurrence", "conditi…
    #> $ variable_name <chr> "Escherichia coli urinary tract infection", "Childhood a…
    #> $ estimate_name <chr> "count_records", "count_records", "count_records", "coun…

### Display the results

Finally, concept counts can be visualised using `[tableConceptIdCounts()](../reference/tableConceptIdCounts.html)`. By default, it generates an interactive [reactable](https://glin.github.io/reactable/) table, but [DT](https://rstudio.github.io/DT/) datatables are also supported.
    
    
    result <- [summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm,
      omopTableName = "measurement",
      countBy = "record"
    ) 
    [tableConceptIdCounts](../reference/tableConceptIdCounts.html)(result, type = "reactable")
    
    
    [tableConceptIdCounts](../reference/tableConceptIdCounts.html)(result, type = "datatable")

The `display` argument in tableConceptIdCounts() controls which concept counts are shown. Available options include `display = "overall"`. It is the default option and it shows both standard and source concept counts.
    
    
    [tableConceptIdCounts](../reference/tableConceptIdCounts.html)(result, display = "overall")

If `display = "standard"` the table shows only **standard** concept_id and concept_name counts.
    
    
    [tableConceptIdCounts](../reference/tableConceptIdCounts.html)(result, display = "standard")

If `display = "source"` the table shows only **source** concept_id and concept_name counts.
    
    
    [tableConceptIdCounts](../reference/tableConceptIdCounts.html)(result, display = "source")
    #> Warning: Values from `estimate_value` are not uniquely identified; output will contain
    #> list-cols.
    #> • Use `values_fn = list` to suppress this warning.
    #> • Use `values_fn = {summary_fun}` to summarise duplicates.
    #> • Use the following dplyr code to identify duplicates.
    #>   {data} |>
    #>   dplyr::summarise(n = dplyr::n(), .by = c(cdm_name, group_level,
    #>   source_concept_name, source_concept_id, result_id, group_name, estimate_type,
    #>   estimate_name)) |>
    #>   dplyr::filter(n > 1L)

If `display = "missing source"` the table shows only counts for concept ids that are missing a corresponding source concept id.
    
    
    [tableConceptIdCounts](../reference/tableConceptIdCounts.html)(result, display = "missing source")

If `display = "missing standard"` the table shows only counts for source concept ids that are missing a mapped standard concept id.
    
    
    [tableConceptIdCounts](../reference/tableConceptIdCounts.html)(result, display = "missing standard")
    #> Warning: `result` does not contain any `summarise_concept_id_counts`
    #> data.

### Display the most frequent concepts

You can use the `[tableTopConceptCounts()](../reference/tableTopConceptCounts.html)` function to display the most frequent concepts in a OMOP CDM table in formatted table. By default, the function returns a [gt](https://gt.rstudio.com/) table, but you can also choose from other output formats, including [flextable](https://davidgohel.github.io/flextable/), [datatable](https://rstudio.github.io/DT/), and [reactable](https://glin.github.io/reactable/).
    
    
    result <- [summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm,
      omopTableName = "drug_exposure",
      countBy = "record"
    ) 
    [tableTopConceptCounts](../reference/tableTopConceptCounts.html)(result, type = "gt")

Top |  Cdm name  
---|---  
mockOmopSketch  
drug_exposure  
1 | Standard: Midazolam (708298)   
Source: No matching concept (0)   
100  
2 | Standard: Diclofenac Sodium 75 MG Delayed Release Oral Tablet (40162359)   
Source: No matching concept (0)   
100  
3 | Standard: tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use (40213227)   
Source: No matching concept (0)   
100  
4 | Standard: Diazepam (723013)   
Source: No matching concept (0)   
100  
5 | Standard: Astemizole (1150770)   
Source: No matching concept (0)   
100  
6 | Standard: hepatitis B vaccine, adult dosage (40213306)   
Source: No matching concept (0)   
100  
7 | Standard: Penicillin G (1728416)   
Source: No matching concept (0)   
100  
8 | Standard: Phenazopyridine (933724)   
Source: No matching concept (0)   
100  
9 | Standard: 3 ML Amiodarone hydrochloride 50 MG/ML Prefilled Syringe (1310034)   
Source: No matching concept (0)   
100  
10 | Standard: Alendronic acid 10 MG Oral Tablet (40173590)   
Source: No matching concept (0)   
100  
  
#### Customising the number of top concepts

By default, the function shows the top 10 concepts. You can change this using the `top` argument:
    
    
    [tableTopConceptCounts](../reference/tableTopConceptCounts.html)(result, top = 5)

Top |  Cdm name  
---|---  
mockOmopSketch  
drug_exposure  
1 | Standard: Midazolam (708298)   
Source: No matching concept (0)   
100  
2 | Standard: Diclofenac Sodium 75 MG Delayed Release Oral Tablet (40162359)   
Source: No matching concept (0)   
100  
3 | Standard: tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use (40213227)   
Source: No matching concept (0)   
100  
4 | Standard: Diazepam (723013)   
Source: No matching concept (0)   
100  
5 | Standard: Astemizole (1150770)   
Source: No matching concept (0)   
100  
  
#### Choosing the count type

If your summary includes both record and person counts, you must specify which type to display using the `countBy` argument:
    
    
    result <- [summariseConceptIdCounts](../reference/summariseConceptIdCounts.html)(cdm,
      omopTableName = "drug_exposure",
      countBy = [c](https://rdrr.io/r/base/c.html)("record", "person")
    ) 
    [tableTopConceptCounts](../reference/tableTopConceptCounts.html)(result, countBy = "person")

Top |  Cdm name  
---|---  
mockOmopSketch  
drug_exposure  
1 | Standard: {28 (Norethindrone 0.35 MG Oral Tablet) } Pack [Camila 28 Day] (19127922)   
Source: No matching concept (0)   
73  
2 | Standard: 1 ML medroxyprogesterone acetate 150 MG/ML Injection (40224805)   
Source: No matching concept (0)   
71  
3 | Standard: Chlorpheniramine Maleate 4 MG Oral Tablet (43012036)   
Source: No matching concept (0)   
71  
4 | Standard: 120 ACTUAT Fluticasone propionate 0.044 MG/ACTUAT Metered Dose Inhaler (40169216)   
Source: No matching concept (0)   
71  
5 | Standard: Piperacillin (1746114)   
Source: No matching concept (0)   
70  
6 | Standard: Sodium Chloride (967823)   
Source: No matching concept (0)   
70  
7 | Standard: Tacrine (836654)   
Source: No matching concept (0)   
70  
8 | Standard: norgestimate (1515774)   
Source: No matching concept (0)   
70  
9 | Standard: Propofol (753626)   
Source: No matching concept (0)   
69  
10 | Standard: Terfenadine (1150836)   
Source: No matching concept (0)   
69  
  
## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
