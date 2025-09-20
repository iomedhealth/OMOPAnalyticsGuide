# Create a header for gt and flextable objects — formatHeader • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Create a header for gt and flextable objects

Source: [`R/formatHeader.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatHeader.R)

`formatHeader.Rd`

Pivots a `<summarised_result>` object based on the column names in header, generating specific column names for subsequent header formatting in formatTable function.

## Usage
    
    
    formatHeader(
      result,
      header,
      delim = "\n",
      includeHeaderName = TRUE,
      includeHeaderKey = TRUE
    )

## Arguments

result
    

A `<summarised_result>`.

header
    

Names of the variables to make headers.

delim
    

Delimiter to use to separate headers.

includeHeaderName
    

Whether to include the column name as header.

includeHeaderKey
    

Whether to include the header key (header, header_name, header_level) before each header type in the column names.

## Value

A tibble with rows pivotted into columns with key names for subsequent header formatting.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    
    result |>
      formatHeader(
        header = [c](https://rdrr.io/r/base/c.html)(
          "Study cohorts", "group_level", "Study strata", "strata_name",
          "strata_level"
        ),
        includeHeaderName = FALSE
      )
    #> # A tibble: 7 × 27
    #>   result_id cdm_name group_name  variable_name   variable_level estimate_name
    #>       <int> <chr>    <chr>       <chr>           <chr>          <chr>        
    #> 1         1 mock     cohort_name number subjects NA             count        
    #> 2         1 mock     cohort_name age             NA             mean         
    #> 3         1 mock     cohort_name age             NA             sd           
    #> 4         1 mock     cohort_name Medications     Amoxiciline    count        
    #> 5         1 mock     cohort_name Medications     Amoxiciline    percentage   
    #> 6         1 mock     cohort_name Medications     Ibuprofen      count        
    #> 7         1 mock     cohort_name Medications     Ibuprofen      percentage   
    #> # ℹ 21 more variables: estimate_type <chr>, additional_name <chr>,
    #> #   additional_level <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]overall\n[header_level]overall` <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]age_group &&& sex\n[header_level]<40 &&& Male` <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]age_group &&& sex\n[header_level]>=40 &&& Male` <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]age_group &&& sex\n[header_level]<40 &&& Female` <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]age_group &&& sex\n[header_level]>=40 &&& Female` <chr>, …
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
