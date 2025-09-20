# Create mock CDM reference with survival::mgus2 dataset — mockMGUS2cdm • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Create mock CDM reference with survival::mgus2 dataset

`mockMGUS2cdm.Rd`

Create mock CDM reference with survival::mgus2 dataset

## Usage
    
    
    mockMGUS2cdm()

## Value

CDM reference containing data from the survival::mgus2 dataset

## Examples
    
    
     # \donttest{
    cdm <- mockMGUS2cdm()
    cdm$person
    #> # Source:   table<person> [?? x 7]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    person_id gender_concept_id year_of_birth month_of_birth day_of_birth
    #>        <int>             <int>         <int>          <int>        <int>
    #>  1         1              8532          1980             10            5
    #>  2         2              8532          1967             10           15
    #>  3         3              8507          1979              9           29
    #>  4         4              8507          1976             10           25
    #>  5         5              8532          1972             10            3
    #>  6         6              8507          1989             10            3
    #>  7         7              8532          1973             10            4
    #>  8         8              8532          1973             10            6
    #>  9         9              8532          1993             10            7
    #> 10        10              8532          1980             10           14
    #> # ℹ more rows
    #> # ℹ 2 more variables: race_concept_id <int>, ethnicity_concept_id <int>
    # }
    

## On this page

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
