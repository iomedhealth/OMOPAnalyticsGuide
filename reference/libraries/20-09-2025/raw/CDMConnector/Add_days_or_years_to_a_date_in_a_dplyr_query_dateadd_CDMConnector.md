# Add days or years to a date in a dplyr query — dateadd • CDMConnector

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

# Add days or years to a date in a dplyr query

Source: [`R/dateadd.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/dateadd.R)

`dateadd.Rd`

This function must be "unquoted" using the "bang bang" operator (!!). See example.

## Usage
    
    
    dateadd(date, number, interval = "day")

## Arguments

date
    

The name of a date column in the database table as a character string

number
    

The number of units to add. Can be a positive or negative whole number.

interval
    

The units to add. Must be either "day" (default) or "year"

## Value

Platform specific SQL that can be used in a dplyr query.

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)())
    date_tbl <- dplyr::[copy_to](https://dplyr.tidyverse.org/reference/copy_to.html)(con, [data.frame](https://rdrr.io/r/base/data.frame.html)(date1 = [as.Date](https://rdrr.io/r/base/as.Date.html)("1999-01-01")),
                               name = "tmpdate", overwrite = TRUE, temporary = TRUE)
    
    df <- date_tbl [%>%](pipe.html)
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(date2 = !!dateadd("date1", 1, interval = "year")) [%>%](pipe.html)
      dplyr::[collect](https://dplyr.tidyverse.org/reference/compute.html)()
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
