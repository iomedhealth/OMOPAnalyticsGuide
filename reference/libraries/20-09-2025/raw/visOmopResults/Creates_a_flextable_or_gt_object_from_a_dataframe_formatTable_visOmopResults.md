# Creates a flextable or gt object from a dataframe — formatTable • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Creates a flextable or gt object from a dataframe

Source: [`R/formatTable.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatTable.R)

`formatTable.Rd`

Creates a flextable object from a dataframe using a delimiter to span the header, and allows to easily customise table style.

## Usage
    
    
    formatTable(
      x,
      type = "gt",
      delim = "\n",
      style = "default",
      na = "-",
      title = NULL,
      subtitle = NULL,
      caption = NULL,
      groupColumn = NULL,
      groupAsColumn = FALSE,
      groupOrder = NULL,
      merge = NULL
    )

## Arguments

x
    

A dataframe.

type
    

The desired format of the output table. See `[tableType()](tableType.html)` for allowed options. If "tibble", no formatting will be applied.

delim
    

Delimiter.

style
    

Named list that specifies how to style the different parts of the gt or flextable table generated. Accepted style entries are: title, subtitle, header, header_name, header_level, column_name, group_label, and body. Alternatively, use "default" to get visOmopResults style, or NULL for gt/flextable style. Keep in mind that styling code is different for gt and flextable. Additionally, "datatable" and "reactable" have their own style functions. To see style options for each table type use `[tableStyle()](tableStyle.html)`.

na
    

How to display missing values. Not used for "datatable" and "reactable".

title
    

Title of the table, or NULL for no title. Not used for "datatable".

subtitle
    

Subtitle of the table, or NULL for no subtitle. Not used for "datatable" and "reactable".

caption
    

Caption for the table, or NULL for no caption. Text in markdown formatting style (e.g. `*Your caption here*` for caption in italics). Not used for "reactable".

groupColumn
    

Specifies the columns to use for group labels. By default, the new group name will be a combination of the column names, joined by "_". To assign a custom group name, provide a named list such as: list(`newGroupName` = c("variable_name", "variable_level"))

groupAsColumn
    

Whether to display the group labels as a column (TRUE) or rows (FALSE). Not used for "datatable" and "reactable"

groupOrder
    

Order in which to display group labels. Not used for "datatable" and "reactable".

merge
    

Names of the columns to merge vertically when consecutive row cells have identical values. Alternatively, use "all_columns" to apply this merging to all columns, or use NULL to indicate no merging. Not used for "datatable" and "reactable".

## Value

A flextable object.

A flextable or gt object.

## Examples
    
    
    # Example 1
    [mockSummarisedResult](mockSummarisedResult.html)() |>
      [formatEstimateValue](formatEstimateValue.html)(decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 1)) |>
      [formatHeader](formatHeader.html)(
        header = [c](https://rdrr.io/r/base/c.html)("Study strata", "strata_name", "strata_level"),
        includeHeaderName = FALSE
      ) |>
      formatTable(
        type = "flextable",
        style = "default",
        na = "--",
        title = "fxTable example",
        subtitle = NULL,
        caption = NULL,
        groupColumn = "group_level",
        groupAsColumn = TRUE,
        groupOrder = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
        merge = "all_columns"
      )
    
    
    fxTable example  
    ---  
    group_level| result_id| cdm_name| group_name| variable_name| variable_level| estimate_name| estimate_type| additional_name| additional_level| Study strata  
    overall| age_group &&& sex| sex| age_group  
    overall| <40 &&& Male| >=40 &&& Male| <40 &&& Female| >=40 &&& Female| Male| Female| <40| >=40  
    cohort1| 1| mock| cohort_name| number subjects| --| count| integer| overall| overall| 2,655,087| 3,721,239| 5,728,534| 9,082,078| 2,016,819| 8,983,897| 9,446,753| 6,607,978| 6,291,140  
    | | | age| --| mean| numeric| overall| overall| 38.0| 77.7| 93.5| 21.2| 65.2| 12.6| 26.7| 38.6| 1.3  
    | | | | | sd| numeric| overall| overall| 7.9| 1.1| 7.2| 4.1| 8.2| 6.5| 7.8| 5.5| 5.3  
    | | | Medications| Amoxiciline| count| integer| overall| overall| 7,068| 9,947| 31,627| 51,863| 66,201| 40,683| 91,288| 29,360| 45,907  
    | | | | | percentage| percentage| overall| overall| 34.668348915875| 33.3774930797517| 47.6351245073602| 89.2198335845023| 86.4339470630512| 38.9989543473348| 77.7320698834956| 96.0617997217923| 43.4659484773874  
    | | | | Ibuprofen| count| integer| overall| overall| 23,963| 5,893| 64,229| 87,627| 77,891| 79,731| 45,527| 41,008| 81,087  
    | | | | | percentage| percentage| overall| overall| 92.4074469832703| 59.876096714288| 97.6170694921166| 73.1792511884123| 35.6726912083104| 43.1473690550774| 14.8211560677737| 1.30775754805654| 71.5566066093743  
    cohort2| 1| mock| cohort_name| number subjects| --| count| integer| overall| overall| 617,863| 2,059,746| 1,765,568| 6,870,228| 3,841,037| 7,698,414| 4,976,992| 7,176,185| 9,919,061  
    | | | age| --| mean| numeric| overall| overall| 38.2| 87.0| 34.0| 48.2| 60.0| 49.4| 18.6| 82.7| 66.8  
    | | | | | sd| numeric| overall| overall| 7.9| 0.2| 4.8| 7.3| 6.9| 4.8| 8.6| 4.4| 2.4  
    | | | Medications| Amoxiciline| count| integer| overall| overall| 33,239| 65,087| 25,802| 47,855| 76,631| 8,425| 87,532| 33,907| 83,944  
    | | | | | percentage| percentage| overall| overall| 71.2514678714797| 39.9994368897751| 32.5352151878178| 75.7087148027495| 20.2692255144939| 71.1121222469956| 12.1691921027377| 24.5488513959572| 14.330437942408  
    | | | | Ibuprofen| count| integer| overall| overall| 60,493| 65,472| 35,320| 27,026| 99,268| 63,349| 21,321| 12,937| 47,812  
    | | | | | percentage| percentage| overall| overall| 10.3184235747904| 44.6284348610789| 64.0101045137271| 99.1838620044291| 49.5593577856198| 48.4349524369463| 17.3442334868014| 75.4820944508538| 45.3895489219576  
      
    
    # Example 2
    [mockSummarisedResult](mockSummarisedResult.html)() |>
      [formatEstimateValue](formatEstimateValue.html)(decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 1)) |>
      [formatHeader](formatHeader.html)(header = [c](https://rdrr.io/r/base/c.html)("Study strata", "strata_name", "strata_level"),
                  includeHeaderName = FALSE) |>
      formatTable(
        type = "gt",
        style = [list](https://rdrr.io/r/base/list.html)("header" = [list](https://rdrr.io/r/base/list.html)(
          gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "#d9d9d9"),
          gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold")),
          "header_level" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "#e1e1e1"),
                                gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold")),
          "column_name" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold")),
          "title" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold"),
                         gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "#c8c8c8")),
          "group_label" = gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "#e1e1e1")),
        na = "--",
        title = "gtTable example",
        subtitle = NULL,
        caption = NULL,
        groupColumn = "group_level",
        groupAsColumn = FALSE,
        groupOrder = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
        merge = "all_columns"
      )
    
    
    
    
      gtTable example
          
    ---  
    
          | 
            Study strata
          
          
    result_id
          | cdm_name
          | group_name
          | variable_name
          | variable_level
          | estimate_name
          | estimate_type
          | additional_name
          | additional_level
          | 
            overall
          
          | 
            age_group &&& sex
          
          | 
            sex
          
          | 
            age_group
          
          
    overall
          | <40 &&& Male
          | >=40 &&& Male
          | <40 &&& Female
          | >=40 &&& Female
          | Male
          | Female
          | <40
          | >=40
          
    cohort1
          
    1
    | mock
    | cohort_name
    | number subjects
    | --
    | count
    | integer
    | overall
    | overall
    | 2,655,087
    | 3,721,239
    | 5,728,534
    | 9,082,078
    | 2,016,819
    | 8,983,897
    | 9,446,753
    | 6,607,978
    | 6,291,140  
    
    | 
    | 
    | age
    | --
    | mean
    | numeric
    | overall
    | overall
    | 38.0
    | 77.7
    | 93.5
    | 21.2
    | 65.2
    | 12.6
    | 26.7
    | 38.6
    | 1.3  
    
    | 
    | 
    | 
    | 
    | sd
    | numeric
    | overall
    | overall
    | 7.9
    | 1.1
    | 7.2
    | 4.1
    | 8.2
    | 6.5
    | 7.8
    | 5.5
    | 5.3  
    
    | 
    | 
    | Medications
    | Amoxiciline
    | count
    | integer
    | overall
    | overall
    | 7,068
    | 9,947
    | 31,627
    | 51,863
    | 66,201
    | 40,683
    | 91,288
    | 29,360
    | 45,907  
    
    | 
    | 
    | 
    | 
    | percentage
    | percentage
    | overall
    | overall
    | 34.668348915875
    | 33.3774930797517
    | 47.6351245073602
    | 89.2198335845023
    | 86.4339470630512
    | 38.9989543473348
    | 77.7320698834956
    | 96.0617997217923
    | 43.4659484773874  
    
    | 
    | 
    | 
    | Ibuprofen
    | count
    | integer
    | overall
    | overall
    | 23,963
    | 5,893
    | 64,229
    | 87,627
    | 77,891
    | 79,731
    | 45,527
    | 41,008
    | 81,087  
    
    | 
    | 
    | 
    | 
    | percentage
    | percentage
    | overall
    | overall
    | 92.4074469832703
    | 59.876096714288
    | 97.6170694921166
    | 73.1792511884123
    | 35.6726912083104
    | 43.1473690550774
    | 14.8211560677737
    | 1.30775754805654
    | 71.5566066093743  
    cohort2
          
    1
    | mock
    | cohort_name
    | number subjects
    | --
    | count
    | integer
    | overall
    | overall
    | 617,863
    | 2,059,746
    | 1,765,568
    | 6,870,228
    | 3,841,037
    | 7,698,414
    | 4,976,992
    | 7,176,185
    | 9,919,061  
    
    | 
    | 
    | age
    | --
    | mean
    | numeric
    | overall
    | overall
    | 38.2
    | 87.0
    | 34.0
    | 48.2
    | 60.0
    | 49.4
    | 18.6
    | 82.7
    | 66.8  
    
    | 
    | 
    | 
    | 
    | sd
    | numeric
    | overall
    | overall
    | 7.9
    | 0.2
    | 4.8
    | 7.3
    | 6.9
    | 4.8
    | 8.6
    | 4.4
    | 2.4  
    
    | 
    | 
    | Medications
    | Amoxiciline
    | count
    | integer
    | overall
    | overall
    | 33,239
    | 65,087
    | 25,802
    | 47,855
    | 76,631
    | 8,425
    | 87,532
    | 33,907
    | 83,944  
    
    | 
    | 
    | 
    | 
    | percentage
    | percentage
    | overall
    | overall
    | 71.2514678714797
    | 39.9994368897751
    | 32.5352151878178
    | 75.7087148027495
    | 20.2692255144939
    | 71.1121222469956
    | 12.1691921027377
    | 24.5488513959572
    | 14.330437942408  
    
    | 
    | 
    | 
    | Ibuprofen
    | count
    | integer
    | overall
    | overall
    | 60,493
    | 65,472
    | 35,320
    | 27,026
    | 99,268
    | 63,349
    | 21,321
    | 12,937
    | 47,812  
    
    | 
    | 
    | 
    | 
    | percentage
    | percentage
    | overall
    | overall
    | 10.3184235747904
    | 44.6284348610789
    | 64.0101045137271
    | 99.1838620044291
    | 49.5593577856198
    | 48.4349524369463
    | 17.3442334868014
    | 75.4820944508538
    | 45.3895489219576  
      
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
