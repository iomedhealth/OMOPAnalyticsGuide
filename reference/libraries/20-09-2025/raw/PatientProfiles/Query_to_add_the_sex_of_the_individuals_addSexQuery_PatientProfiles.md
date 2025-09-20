# Query to add the sex of the individuals — addSexQuery • PatientProfiles

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

# Query to add the sex of the individuals

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addSexQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addSex()`, except query is not computed to a table.

## Usage
    
    
    addSexQuery(x, sexName = "sex", missingSexValue = "None")

## Arguments

x
    

Table with individuals in the cdm.

sexName
    

name of the new column to be added.

missingSexValue
    

Value to include if missing sex.

## Value

table x with the added column with sex information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addSexQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date sex   
    #>                   <int>      <int> <date>            <date>          <chr> 
    #>  1                    1          1 1986-09-24        1989-08-06      Female
    #>  2                    3          2 1925-05-20        1927-02-09      Female
    #>  3                    2          3 1985-01-21        1986-09-24      Female
    #>  4                    3          4 1935-06-18        1951-07-26      Female
    #>  5                    1          5 1969-08-15        1975-09-22      Male  
    #>  6                    2          6 1935-01-10        1942-08-07      Female
    #>  7                    1          7 1970-12-07        1971-03-12      Female
    #>  8                    1          8 1965-01-10        1985-11-04      Female
    #>  9                    1          9 1952-06-02        1954-12-07      Female
    #> 10                    2         10 1956-01-29        1958-08-21      Female
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
