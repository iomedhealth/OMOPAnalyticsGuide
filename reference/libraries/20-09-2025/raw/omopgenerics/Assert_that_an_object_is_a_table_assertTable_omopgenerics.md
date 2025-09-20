# Assert that an object is a table. — assertTable • omopgenerics

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



# Assert that an object is a table.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertTable.Rd`

Assert that an object is a table.

## Usage
    
    
    assertTable(
      x,
      class = NULL,
      numberColumns = NULL,
      numberRows = NULL,
      columns = [character](https://rdrr.io/r/base/character.html)(),
      allowExtraColumns = TRUE,
      null = FALSE,
      unique = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Variable to check.

class
    

A class that the table must have: "tbl", "data.fram", "tbl_sql", ...

numberColumns
    

Number of columns that it has to contain.

numberRows
    

Number of rows that it has to contain.

columns
    

Name of the columns required.

allowExtraColumns
    

Whether extra columns are allowed.

null
    

Whether it can be NULL.

unique
    

Whether it has to contain unique rows.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
