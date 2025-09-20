# Quantile calculation using dbplyr — summariseQuantile • CDMConnector

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

# Quantile calculation using dbplyr

Source: [`R/summariseQuantile.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/summariseQuantile.R)

`summariseQuantile.Rd`

This function provides DBMS independent syntax for quantiles estimation. Can be used by itself or in combination with `[mutate()](https://dplyr.tidyverse.org/reference/mutate.html)` when calculating other aggregate metrics (min, max, mean).

`summarise_quantile()`, `summarize_quantile()`, `summariseQuantile()` and `summarizeQuantile()` are synonyms.

## Usage
    
    
    summariseQuantile(.data, x = NULL, probs, nameSuffix = "value")

## Arguments

.data
    

lazy data frame backed by a database query.

x
    

column name whose sample quantiles are wanted.

probs
    

numeric vector of probabilities with values in [0,1].

nameSuffix
    

character; is appended to numerical quantile value as a column name part.

## Value

An object of the same type as '.data'

## Details

Implemented quantiles estimation algorithm returns values analogous to `quantile{stats}` with argument `type = 1`. See discussion in Hyndman and Fan (1996). Results differ from `PERCENTILE_CONT` natively implemented in various DBMS, where returned values are equal to `quantile{stats}` with default argument `type = 7`

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)())
    mtcars_tbl <- dplyr::[copy_to](https://dplyr.tidyverse.org/reference/copy_to.html)(con, mtcars, name = "tmp", overwrite = TRUE, temporary = TRUE)
    
    df <- mtcars_tbl [%>%](pipe.html)
     dplyr::[group_by](https://dplyr.tidyverse.org/reference/group_by.html)(cyl) [%>%](pipe.html)
     dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(mean = [mean](https://rdrr.io/r/base/mean.html)(mpg, na.rm = TRUE)) [%>%](pipe.html)
     summariseQuantile(mpg, probs = [c](https://rdrr.io/r/base/c.html)(0, 0.2, 0.4, 0.6, 0.8, 1),
                       nameSuffix = "quant") [%>%](pipe.html)
     dplyr::[collect](https://dplyr.tidyverse.org/reference/compute.html)()
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
