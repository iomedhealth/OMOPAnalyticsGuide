# Summarise a cdm_reference object creating a snapshot with the metadata of the cdm_reference object. — summariseOmopSnapshot • OmopSketch

Skip to contents

[OmopSketch](../index.html) 0.5.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Summarise clinical tables records](../articles/summarise_clinical_tables_records.html)
    * [Summarise concept id counts](../articles/summarise_concept_id_counts.html)
    * [Summarise observation period](../articles/summarise_observation_period.html)
    * [Characterisation of OMOP CDM](../articles/characterisation.html)
    * [Summarise missing data](../articles/missing_data.html)
    * [Summarise database characteristics](../articles/database_characteristics.html)
  * [Changelog](../news/index.html)
  * [Characterisation synthetic datasets](https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/)


  *   * [](https://github.com/OHDSI/OmopSketch/)



![](../logo.png)

# Summarise a cdm_reference object creating a snapshot with the metadata of the cdm_reference object.

Source: [`R/summariseOmopSnapshot.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summariseOmopSnapshot.R)

`summariseOmopSnapshot.Rd`

Summarise a cdm_reference object creating a snapshot with the metadata of the cdm_reference object.

## Usage
    
    
    summariseOmopSnapshot(cdm)

## Arguments

cdm
    

A cdm_reference object.

## Value

A summarised_result object that contains the OMOP CDM snapshot information.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)(numberIndividuals = 10)
    
    summariseOmopSnapshot(cdm = cdm)
    #> # A tibble: 18 × 13
    #>    result_id cdm_name       group_name group_level strata_name strata_level
    #>        <int> <chr>          <chr>      <chr>       <chr>       <chr>       
    #>  1         1 mockOmopSketch overall    overall     overall     overall     
    #>  2         1 mockOmopSketch overall    overall     overall     overall     
    #>  3         1 mockOmopSketch overall    overall     overall     overall     
    #>  4         1 mockOmopSketch overall    overall     overall     overall     
    #>  5         1 mockOmopSketch overall    overall     overall     overall     
    #>  6         1 mockOmopSketch overall    overall     overall     overall     
    #>  7         1 mockOmopSketch overall    overall     overall     overall     
    #>  8         1 mockOmopSketch overall    overall     overall     overall     
    #>  9         1 mockOmopSketch overall    overall     overall     overall     
    #> 10         1 mockOmopSketch overall    overall     overall     overall     
    #> 11         1 mockOmopSketch overall    overall     overall     overall     
    #> 12         1 mockOmopSketch overall    overall     overall     overall     
    #> 13         1 mockOmopSketch overall    overall     overall     overall     
    #> 14         1 mockOmopSketch overall    overall     overall     overall     
    #> 15         1 mockOmopSketch overall    overall     overall     overall     
    #> 16         1 mockOmopSketch overall    overall     overall     overall     
    #> 17         1 mockOmopSketch overall    overall     overall     overall     
    #> 18         1 mockOmopSketch overall    overall     overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
