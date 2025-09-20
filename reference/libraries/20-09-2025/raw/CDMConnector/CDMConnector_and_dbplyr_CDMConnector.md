# CDMConnector and dbplyr • CDMConnector

Skip to contents

[CDMConnector](../index.html) 2.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Getting Started](../articles/a01_getting-started.html)
    * [Working with cohorts](../articles/a02_cohorts.html)
    * [CDMConnector and dbplyr](../articles/a03_dbplyr.html)
    * [DBI connection examples](../articles/a04_DBI_connection_examples.html)
    * [Using CDM attributes](../articles/a06_using_cdm_attributes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CDMConnector/)



![](../logo.png)

# CDMConnector and dbplyr

Source: [`vignettes/a03_dbplyr.Rmd`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/vignettes/a03_dbplyr.Rmd)

`a03_dbplyr.Rmd`

## Set up

First let’s load the required packages for the code in this vignette. If you haven’t already installed them, all the other packages can be installed using ´install.packages()´
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

## Creating the cdm reference

Now let´s connect to a duckdb database with the Eunomia data (<https://github.com/OHDSI/Eunomia>).
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](../reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](../reference/cdmFromCon.html)(con, cdmName = "eunomia", cdmSchema = "main", writeSchema = "main")
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of eunomia ────────────────────────────────────
    #> • omop tables: person, observation_period, visit_occurrence, visit_detail,
    #> condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
    #> measurement, observation, death, note, note_nlp, specimen, fact_relationship,
    #> location, care_site, provider, payer_plan_period, cost, drug_era, dose_era,
    #> condition_era, metadata, cdm_source, concept, vocabulary, domain,
    #> concept_class, concept_relationship, relationship, concept_synonym,
    #> concept_ancestor, source_to_concept_map, drug_strength
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

This cdm object is now what we´ll use going forward. It provides a reference to the OMOP CDM tables. We can see that these tables are still in the database, but now we have a reference to each of the ones we might want to use in our analysis. For example, the person table can be referenced like so

## Putting it all together

Say we want to make a histogram of year of birth in the person table. We can select that variable, bring it into memory, and then use ggplot to make the histogram.
    
    
    cdm$person [%>%](../reference/pipe.html)
      [select](https://dplyr.tidyverse.org/reference/select.html)(year_of_birth) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = year_of_birth)) +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)(bins = 30)

![](a03_dbplyr_files/figure-html/unnamed-chunk-4-1.png)

If we wanted to make a boxplot for length of observation periods we could do the computation on the database side, bring in the new variable into memory, and use ggplot to produce the boxplot
    
    
    cdm$observation_period [%>%](../reference/pipe.html)
      [select](https://dplyr.tidyverse.org/reference/select.html)(observation_period_start_date, observation_period_end_date) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(observation_period = (observation_period_end_date - observation_period_start_date)/365, 25) [%>%](../reference/pipe.html)
      [select](https://dplyr.tidyverse.org/reference/select.html)(observation_period) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = observation_period)) +
      [geom_boxplot](https://ggplot2.tidyverse.org/reference/geom_boxplot.html)()

![](a03_dbplyr_files/figure-html/unnamed-chunk-5-1.png)

## Behind the scenes

We use show_query to check the sql that is being run against duckdb
    
    
    cdm$person [%>%](../reference/pipe.html)
      [tally](https://dplyr.tidyverse.org/reference/count.html)() [%>%](../reference/pipe.html)
      [show_query](https://dplyr.tidyverse.org/reference/explain.html)()
    #> <SQL>
    #> SELECT COUNT(*) AS n
    #> FROM person
    
    
    cdm$person [%>%](../reference/pipe.html)
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)([median](https://rdrr.io/r/stats/median.html)(year_of_birth))[%>%](../reference/pipe.html)
      [show_query](https://dplyr.tidyverse.org/reference/explain.html)()
    #> Warning: Missing values are always removed in SQL aggregation functions.
    #> Use `na.rm = TRUE` to silence this warning
    #> This warning is displayed once every 8 hours.
    #> <SQL>
    #> SELECT MEDIAN(year_of_birth) AS "median(year_of_birth)"
    #> FROM person
    
    
    cdm$person [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(gender = [case_when](https://dplyr.tidyverse.org/reference/case_when.html)(
        gender_concept_id == "8507" ~ "Male",
        gender_concept_id == "8532" ~ "Female",
        TRUE ~ NA_character_))[%>%](../reference/pipe.html)
      [show_query](https://dplyr.tidyverse.org/reference/explain.html)()
    #> <SQL>
    #> SELECT
    #>   person.*,
    #>   CASE
    #> WHEN (gender_concept_id = '8507') THEN 'Male'
    #> WHEN (gender_concept_id = '8532') THEN 'Female'
    #> ELSE NULL
    #> END AS gender
    #> FROM person
    
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
