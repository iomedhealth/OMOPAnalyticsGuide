# Extract the day, month or year of a date in a dplyr pipeline — datepart • CDMConnector

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

# Extract the day, month or year of a date in a dplyr pipeline

Source: [`R/dateadd.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/dateadd.R)

`datepart.Rd`

Extract the day, month or year of a date in a dplyr pipeline

## Usage
    
    
    datepart(date, interval = "year", dbms = NULL)

## Arguments

date
    

Character string that represents to a date column.

interval
    

Interval to extract from a date. Valid options are "year", "month", or "day".

dbms
    

Database system, if NULL it is auto detected.

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), ":memory:")
    date_tbl <- dplyr::[copy_to](https://dplyr.tidyverse.org/reference/copy_to.html)(con,
                               [data.frame](https://rdrr.io/r/base/data.frame.html)(birth_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1993-04-19")),
                               name = "tmp",
                               temporary = TRUE)
    df <- date_tbl [%>%](pipe.html)
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(year = !!datepart("birth_date", "year")) [%>%](pipe.html)
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(month = !!datepart("birth_date", "month")) [%>%](pipe.html)
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(day = !!datepart("birth_date", "day")) [%>%](pipe.html)
      dplyr::[collect](https://dplyr.tidyverse.org/reference/compute.html)()
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
