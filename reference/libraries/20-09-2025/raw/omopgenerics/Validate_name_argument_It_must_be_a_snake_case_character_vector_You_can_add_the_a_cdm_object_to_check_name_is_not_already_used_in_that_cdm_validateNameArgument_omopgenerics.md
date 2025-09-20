# Validate name argument. It must be a snake_case character vector. You can add the a cdm object to check name is not already used in that cdm. — validateNameArgument • omopgenerics

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



# Validate name argument. It must be a snake_case character vector. You can add the a cdm object to check `name` is not already used in that cdm.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateNameArgument.Rd`

Validate name argument. It must be a snake_case character vector. You can add the a cdm object to check `name` is not already used in that cdm.

## Usage
    
    
    validateNameArgument(
      name,
      cdm = NULL,
      validation = "error",
      null = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

name
    

Name of a new table to be added to a cdm object.

cdm
    

A cdm_reference object. It will check if a table named name already exists in the cdm.

validation
    

How to perform validation: "error", "warning".

null
    

If TRUE, name can be NULL

call
    

A call argument to pass to cli functions.

## Examples
    
    
    # this is a validate name
    name <- "my_new_table"
    validateNameArgument(name)
    #> [1] "my_new_table"
    
    # this is not
    name <- "myTableNAME"
    validateNameArgument(name, validation = "warning")
    #> Warning: ! `name` was modified: myTableNAME -> my_table_name
    #> [1] "my_table_name"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
