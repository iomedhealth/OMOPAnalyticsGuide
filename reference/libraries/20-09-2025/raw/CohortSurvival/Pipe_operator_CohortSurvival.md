# Pipe operator — %>% • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Pipe operator

`pipe.Rd`

See `magrittr::%>%` for details.

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

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
