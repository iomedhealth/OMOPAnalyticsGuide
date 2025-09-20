# as.Date dbplyr translation wrapper — asDate • CDMConnector

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

# as.Date dbplyr translation wrapper

Source: [`R/dateadd.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/dateadd.R)

`asDate.Rd`

This is a workaround for using as.Date inside dplyr verbs against a database backend. This function should only be used inside dplyr verbs where the first argument is a database table reference. `asDate` must be unquoted with !! inside dplyr verbs (see example).

## Usage
    
    
    asDate(x)

## Arguments

x
    

an R expression

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(odbc::[odbc](https://odbc.r-dbi.org/reference/dbConnect-OdbcDriver-method.html)(), "Oracle")
    date_tbl <- dplyr::[copy_to](https://dplyr.tidyverse.org/reference/copy_to.html)(con,
                               [data.frame](https://rdrr.io/r/base/data.frame.html)(y = 2000L, m = 10L, d = 10L),
                               name = "tmp",
                               temporary = TRUE)
    
    df <- date_tbl [%>%](pipe.html)
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(date_from_parts = !!asDate([paste0](https://rdrr.io/r/base/paste.html)(
        .data$y, "/",
        .data$m, "/",
        .data$d
      ))) [%>%](pipe.html)
      dplyr::[collect](https://dplyr.tidyverse.org/reference/compute.html)()
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
