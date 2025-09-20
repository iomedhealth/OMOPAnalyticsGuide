# Validate conceptSet argument. It can either be a list, a codelist, a concept set expression or a codelist with details. The output will always be a codelist. — validateConceptSetArgument • omopgenerics

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate conceptSet argument. It can either be a list, a codelist, a concept set expression or a codelist with details. The output will always be a codelist.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateConceptSetArgument.Rd`

Validate conceptSet argument. It can either be a list, a codelist, a concept set expression or a codelist with details. The output will always be a codelist.

## Usage
    
    
    validateConceptSetArgument(
      conceptSet,
      cdm = NULL,
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

conceptSet
    

It can be either a named list of concepts or a codelist, codelist_with_details or concept_set_expression object.

cdm
    

A cdm_reference object, needed if a concept_set_expression is provided.

validation
    

How to perform validation: "error", "warning".

call
    

A call argument to pass to cli functions.

## Value

A codelist object.

## Examples
    
    
    conceptSet <- [list](https://rdrr.io/r/base/list.html)(disease_x = [c](https://rdrr.io/r/base/c.html)(1L, 2L))
    validateConceptSetArgument(conceptSet)
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - disease_x (2 codes)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
