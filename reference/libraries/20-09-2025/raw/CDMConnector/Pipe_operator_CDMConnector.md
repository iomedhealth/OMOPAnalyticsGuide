# Pipe operator — %>% • CDMConnector

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

# Pipe operator

Source: [`R/utils.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/utils.R)

`pipe.Rd`

Pipe operator

## Usage
    
    
    lhs %>% rhs

## Arguments

lhs
    

A value or the magrittr placeholder.

rhs
    

A function call using the magrittr semantics.

## Value

The result of calling `rhs(lhs)`.

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
