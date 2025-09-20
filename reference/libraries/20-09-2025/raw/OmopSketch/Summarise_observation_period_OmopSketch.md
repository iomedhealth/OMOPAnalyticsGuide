# Summarise observation period • OmopSketch

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

# Summarise observation period

Source: [`vignettes/summarise_observation_period.Rmd`](https://github.com/OHDSI/OmopSketch/blob/main/vignettes/summarise_observation_period.Rmd)

`summarise_observation_period.Rmd`

## Introduction

In this vignette, we will explore the _OmopSketch_ functions designed to provide an overview of the `observation_period` table. Specifically, there are six key functions that facilitate this:

  * `[summariseObservationPeriod()](../reference/summariseObservationPeriod.html)`, `[plotObservationPeriod()](../reference/plotObservationPeriod.html)` and `[tableObservationPeriod()](../reference/tableObservationPeriod.html)`: Use them to get some overall statistics describing the `observation_period` table
  * `[summariseInObservation()](../reference/summariseInObservation.html)`, `[plotInObservation()](../reference/plotInObservation.html)`, `[tableInObservation()](../reference/tableInObservation.html)`: Use them to summarise the trend in the number of records, individuals, person-days and females in observation during specific intervals of time and how the median age varies.



### Create a mock cdm

Let’s see an example of its functionalities. To start with, we will load essential packages and create a mock cdm using the mockOmopSketch() database.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    # Connect to mock database
    cdm <- [mockOmopSketch](../reference/mockOmopSketch.html)()

## Summarise observation periods

Let’s now use the `[summariseObservationPeriod()](../reference/summariseObservationPeriod.html)` function from the OmopSketch package to help us have an overview of one of the `observation_period` table, including some statistics such as the `Number of subjects` and `Duration in days` for each observation period (e.g., 1st, 2nd)
    
    
    summarisedResult <- [summariseObservationPeriod](../reference/summariseObservationPeriod.html)(cdm = cdm)
    
    summarisedResult
    #> # A tibble: 3,126 × 13
    #>    result_id cdm_name       group_name      group_level strata_name strata_level
    #>        <int> <chr>          <chr>           <chr>       <chr>       <chr>       
    #>  1         1 mockOmopSketch observation_pe… all         overall     overall     
    #>  2         1 mockOmopSketch observation_pe… all         overall     overall     
    #>  3         1 mockOmopSketch observation_pe… all         overall     overall     
    #>  4         1 mockOmopSketch observation_pe… all         overall     overall     
    #>  5         1 mockOmopSketch observation_pe… all         overall     overall     
    #>  6         1 mockOmopSketch observation_pe… all         overall     overall     
    #>  7         1 mockOmopSketch observation_pe… all         overall     overall     
    #>  8         1 mockOmopSketch observation_pe… all         overall     overall     
    #>  9         1 mockOmopSketch observation_pe… all         overall     overall     
    #> 10         1 mockOmopSketch observation_pe… all         overall     overall     
    #> # ℹ 3,116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>

Notice that the output is in the summarised result format.

We can use the arguments to specify which statistics we want to perform. For example, use the argument `estimates` to indicate which estimates you are interested regarding the `Duration in days` of the observation period.
    
    
    summarisedResult <- [summariseObservationPeriod](../reference/summariseObservationPeriod.html)(
      cdm = cdm,
      estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd", "q05", "q95")
    )
    
    summarisedResult |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Duration in days") |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(group_level, variable_name, estimate_name, estimate_value)
    #> # A tibble: 8 × 4
    #>   group_level variable_name    estimate_name estimate_value  
    #>   <chr>       <chr>            <chr>         <chr>           
    #> 1 all         Duration in days mean          3459.34         
    #> 2 all         Duration in days sd            3586.96925956871
    #> 3 all         Duration in days q05           45              
    #> 4 all         Duration in days q95           9766            
    #> 5 1st         Duration in days mean          3459.34         
    #> 6 1st         Duration in days sd            3586.96925956871
    #> 7 1st         Duration in days q05           45              
    #> 8 1st         Duration in days q95           9766

Additionally, you can stratify the results by sex and age groups, and specify a date range of interest:
    
    
    summarisedResult <- [summariseObservationPeriod](../reference/summariseObservationPeriod.html)(
      cdm = cdm,
      estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd", "q05", "q95"),
      sex = TRUE,
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<35" = [c](https://rdrr.io/r/base/c.html)(0, 34), ">=35" = [c](https://rdrr.io/r/base/c.html)(35, Inf)),
      dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1970-01-01", "2010-01-01"))
    )

Notice that, by default, the “overall” group will be also included, as well as crossed strata (that means, sex == “Female” and ageGroup == “>35”).

### Tidy the summarised object

`[tableObservationPeriod()](../reference/tableObservationPeriod.html)` will help you to create a table (see supported types with: visOmopResults::tableType()). By default it creates a [gt](https://gt.rstudio.com/) table.
    
    
    summarisedResult <- [summariseObservationPeriod](../reference/summariseObservationPeriod.html)(
      cdm = cdm,
      estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd", "q05", "q95"),
      sex = TRUE
    )
    
    summarisedResult |>
      [tableObservationPeriod](../reference/tableObservationPeriod.html)()
    #> ℹ <median> [<q25> - <q75>] has not been formatted.

Observation period ordinal | Variable name | Variable level | Estimate name |  CDM name  
---|---|---|---|---  
mockOmopSketch  
overall  
all | Records per person | - | mean (sd) | 1.00 (0.00)  
| Duration in days | - | mean (sd) | 3,459.34 (3,586.97)  
| Number records | - | N | 100  
| Number subjects | - | N | 100  
| Type concept id | Unknown type concept: NA | N (%) | 100 (100.00%)  
| Subjects not in person table | - | N (%) | 0 (0.00%)  
| End date before start date | - | N (%) | 0 (0.00%)  
| Start date before birth date | - | N (%) | 0 (0.00%)  
| Column name | observation_period_id | N missing data (%) | 0 (0.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
|  | person_id | N missing data (%) | 0 (0.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
|  | observation_period_start_date | N missing data (%) | 0 (0.00%)  
|  | observation_period_end_date | N missing data (%) | 0 (0.00%)  
|  | period_type_concept_id | N missing data (%) | 100 (100.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
1st | Duration in days | - | mean (sd) | 3,459.34 (3,586.97)  
| Number subjects | - | N | 100  
Female  
all | Records per person | - | mean (sd) | 1.00 (0.00)  
| Duration in days | - | mean (sd) | 3,886.02 (3,922.09)  
| Number records | - | N | 57  
| Number subjects | - | N | 57  
| Type concept id | Unknown type concept: NA | N (%) | 57 (100.00%)  
| Column name | observation_period_id | N missing data (%) | 0 (0.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
|  | person_id | N missing data (%) | 0 (0.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
|  | observation_period_start_date | N missing data (%) | 0 (0.00%)  
|  | observation_period_end_date | N missing data (%) | 0 (0.00%)  
|  | period_type_concept_id | N missing data (%) | 57 (100.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
1st | Duration in days | - | mean (sd) | 3,886.02 (3,922.09)  
| Number subjects | - | N | 57  
Male  
all | Records per person | - | mean (sd) | 1.00 (0.00)  
| Duration in days | - | mean (sd) | 2,893.74 (3,040.21)  
| Number records | - | N | 43  
| Number subjects | - | N | 43  
| Type concept id | Unknown type concept: NA | N (%) | 43 (100.00%)  
| Column name | observation_period_id | N missing data (%) | 0 (0.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
|  | person_id | N missing data (%) | 0 (0.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
|  | observation_period_start_date | N missing data (%) | 0 (0.00%)  
|  | observation_period_end_date | N missing data (%) | 0 (0.00%)  
|  | period_type_concept_id | N missing data (%) | 43 (100.00%)  
|  |  | N zeros (%) | 0 (0.00%)  
1st | Duration in days | - | mean (sd) | 2,893.74 (3,040.21)  
| Number subjects | - | N | 43  
  
### Visualise the results

Finally, we can visualise the result using `[plotObservationPeriod()](../reference/plotObservationPeriod.html)`.
    
    
    summarisedResult <- [summariseObservationPeriod](../reference/summariseObservationPeriod.html)(cdm = cdm)
    
    [plotObservationPeriod](../reference/plotObservationPeriod.html)(
      result = summarisedResult,
      variableName = "Number subjects",
      plotType = "barplot"
    )

![](summarise_observation_period_files/figure-html/unnamed-chunk-7-1.png)

Note that either `Number subjects` or `Duration in days` can be plotted. For `Number of subjects`, the plot type can be `barplot`, whereas for `Duration in days`, the plot type can be `barplot`, `boxplot`, or `densityplot`.”

Additionally, if results were stratified by sex or age group, we can further use `facet` or `colour` arguments to highlight the different results in the plot. To help us identify by which variables we can colour or facet by, we can use [visOmopResult](https://darwin-eu.github.io/visOmopResults/) package.
    
    
    summarisedResult <- [summariseObservationPeriod](../reference/summariseObservationPeriod.html)(cdm = cdm, sex = TRUE)
    [plotObservationPeriod](../reference/plotObservationPeriod.html)(
      result = summarisedResult,
      variableName = "Duration in days",
      plotType = "boxplot",
      facet = "sex"
    )

![](summarise_observation_period_files/figure-html/unnamed-chunk-8-1.png)
    
    
    
    summarisedResult <- [summariseObservationPeriod](../reference/summariseObservationPeriod.html)(
      cdm = cdm,
      sex = TRUE,
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<35" = [c](https://rdrr.io/r/base/c.html)(0, 34), ">=35" = [c](https://rdrr.io/r/base/c.html)(35, Inf))
    )
    [plotObservationPeriod](../reference/plotObservationPeriod.html)(summarisedResult,
      colour = "sex",
      facet = "age_group"
    )

![](summarise_observation_period_files/figure-html/unnamed-chunk-8-2.png)

## Summarise in observation

OmopSketch can also help you to summarise the number of records in observation during specific intervals of time.
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period,
      interval = "years"
    )
    
    summarisedResult |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(variable_name, estimate_name, estimate_value, additional_name, additional_level)
    #> # A tibble: 132 × 5
    #>    variable_name   estimate_name estimate_value additional_name additional_level
    #>    <chr>           <chr>         <chr>          <chr>           <chr>           
    #>  1 Records in obs… count         1              time_interval   1955-01-01 to 1…
    #>  2 Records in obs… percentage    1.00           time_interval   1955-01-01 to 1…
    #>  3 Records in obs… count         2              time_interval   1956-01-01 to 1…
    #>  4 Records in obs… percentage    2.00           time_interval   1956-01-01 to 1…
    #>  5 Records in obs… count         3              time_interval   1957-01-01 to 1…
    #>  6 Records in obs… percentage    3.00           time_interval   1957-01-01 to 1…
    #>  7 Records in obs… count         4              time_interval   1958-01-01 to 1…
    #>  8 Records in obs… percentage    4.00           time_interval   1958-01-01 to 1…
    #>  9 Records in obs… count         4              time_interval   1959-01-01 to 1…
    #> 10 Records in obs… percentage    4.00           time_interval   1959-01-01 to 1…
    #> # ℹ 122 more rows

Note that you can adjust the time interval period using the `interval` argument, which can be set to either “years”, “quarters”, “months” or “overall” (default value).
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period,
      interval = "months"
    )

Along with the number of records in observation, you can also calculate the number of person-days by setting the `output` argument to c(“record”, “person-days”).
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period, 
                                               output = [c](https://rdrr.io/r/base/c.html)("record", "person-days"))                                        
    
    
    summarisedResult |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(variable_name, estimate_name, estimate_value, additional_name, additional_level)
    #> # A tibble: 4 × 5
    #>   variable_name    estimate_name estimate_value additional_name additional_level
    #>   <chr>            <chr>         <chr>          <chr>           <chr>           
    #> 1 Records in obse… count         100            overall         overall         
    #> 2 Person-days      count         345934         overall         overall         
    #> 3 Records in obse… percentage    100.00         overall         overall         
    #> 4 Person-days      percentage    100.00         overall         overall

We can further stratify our counts by sex (setting argument `sex = TRUE`) or by age (providing an age group). Notice that in both cases, the function will automatically create a group called _overall_ with all the sex groups and all the age groups. We can also define a date range of interest to filter the `observation_period` table accordingly.
    
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period, 
                                               output = [c](https://rdrr.io/r/base/c.html)("record", "person-days"),
                                               interval = "quarters",
                                               sex = TRUE, 
                                               ageGroup = [list](https://rdrr.io/r/base/list.html)("<35" = [c](https://rdrr.io/r/base/c.html)(0, 34), ">=35" = [c](https://rdrr.io/r/base/c.html)(35, Inf)), 
                                               dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1970-01-01", "2010-01-01")))                                        
    
    
    summarisedResult |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)

You can include additional output metrics by them to the output argument:

If `output = "person"`, the trend in the number of individuals in observation is returned.
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period, 
                                               output = [c](https://rdrr.io/r/base/c.html)("person"),
                                               interval = "years",
                                               sex = TRUE, 
                                               ageGroup = [list](https://rdrr.io/r/base/list.html)("<35" = [c](https://rdrr.io/r/base/c.html)(0, 34), ">=35" = [c](https://rdrr.io/r/base/c.html)(35, Inf)), 
                                               )                                        
    
    
    summarisedResult |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)
    #> # A tibble: 968 × 6
    #>    strata_level variable_name       estimate_name estimate_value additional_name
    #>    <chr>        <chr>               <chr>         <chr>          <chr>          
    #>  1 overall      Subjects in observ… count         1              time_interval  
    #>  2 Male         Subjects in observ… count         1              time_interval  
    #>  3 <35          Subjects in observ… count         1              time_interval  
    #>  4 Male &&& <35 Subjects in observ… count         1              time_interval  
    #>  5 overall      Subjects in observ… percentage    1.00           time_interval  
    #>  6 Male         Subjects in observ… percentage    1.00           time_interval  
    #>  7 <35          Subjects in observ… percentage    1.00           time_interval  
    #>  8 Male &&& <35 Subjects in observ… percentage    1.00           time_interval  
    #>  9 overall      Subjects in observ… count         2              time_interval  
    #> 10 Male         Subjects in observ… count         2              time_interval  
    #> # ℹ 958 more rows
    #> # ℹ 1 more variable: additional_level <chr>

If `output = "sex"`, the trend in the number of females in observation is returned. If `sex = TRUE` is specified, this stratification is ignored.
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period, 
                                               output = [c](https://rdrr.io/r/base/c.html)("sex"),
                                               interval = "years",
                                               sex = TRUE, 
                                               ageGroup = [list](https://rdrr.io/r/base/list.html)("<35" = [c](https://rdrr.io/r/base/c.html)(0, 34), ">=35" = [c](https://rdrr.io/r/base/c.html)(35, Inf)), 
                                               )                                        
    
    
    summarisedResult |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)
    #> # A tibble: 314 × 6
    #>    strata_level variable_name       estimate_name estimate_value additional_name
    #>    <chr>        <chr>               <chr>         <chr>          <chr>          
    #>  1 overall      Females in observa… count         1              time_interval  
    #>  2 <35          Females in observa… count         1              time_interval  
    #>  3 overall      Females in observa… percentage    1.00           time_interval  
    #>  4 <35          Females in observa… percentage    1.00           time_interval  
    #>  5 overall      Females in observa… count         1              time_interval  
    #>  6 <35          Females in observa… count         1              time_interval  
    #>  7 overall      Females in observa… percentage    1.00           time_interval  
    #>  8 <35          Females in observa… percentage    1.00           time_interval  
    #>  9 overall      Females in observa… count         1              time_interval  
    #> 10 <35          Females in observa… count         1              time_interval  
    #> # ℹ 304 more rows
    #> # ℹ 1 more variable: additional_level <chr>

If `output = "age`, the trend in the median age of the population in observation is calculated. If `ageGroup` and `interval` are both specified, the age is computed at the beginning of the interval or of the observation period, whichever is more recent.
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(
      observationPeriod = cdm$observation_period, 
      output = [c](https://rdrr.io/r/base/c.html)("age"),
      interval = "years",
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<35" = [c](https://rdrr.io/r/base/c.html)(0, 34), ">=35" = [c](https://rdrr.io/r/base/c.html)(35, Inf)) 
    )                                        
    
    
    summarisedResult |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(strata_level, variable_name, estimate_name, estimate_value, additional_name, additional_level)
    #> # A tibble: 165 × 6
    #>    strata_level variable_name      estimate_name estimate_value additional_name
    #>    <chr>        <chr>              <chr>         <chr>          <chr>          
    #>  1 overall      Age in observation median        1              time_interval  
    #>  2 <35          Age in observation median        1              time_interval  
    #>  3 overall      Age in observation median        1              time_interval  
    #>  4 <35          Age in observation median        1              time_interval  
    #>  5 overall      Age in observation median        2              time_interval  
    #>  6 <35          Age in observation median        2              time_interval  
    #>  7 overall      Age in observation median        2              time_interval  
    #>  8 <35          Age in observation median        2              time_interval  
    #>  9 overall      Age in observation median        3              time_interval  
    #> 10 <35          Age in observation median        3              time_interval  
    #> # ℹ 155 more rows
    #> # ℹ 1 more variable: additional_level <chr>

### Tidy the summarised object

`tableInObservartion()` will help you to create a table of type [gt](https://gt.rstudio.com/), [reactable](https://glin.github.io/reactable/) or [datatable](https://rstudio.github.io/DT/). By default it creates a [gt](https://gt.rstudio.com/) table.
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period, 
                                               output = [c](https://rdrr.io/r/base/c.html)("person", "person-days", "sex"),
                                               sex = TRUE)
    
    summarisedResult |>
      [tableInObservation](../reference/tableInObservation.html)(type = "gt")

Variable name | Sex | Estimate name |  Database name  
---|---|---|---  
mockOmopSketch  
episode; observation_period  
Subjects in observation | overall | N (%) | 100 (100.00%)  
| Female | N (%) | 57 (57.00%)  
| Male | N (%) | 43 (43.00%)  
Females in observation | overall | N (%) | 57 (57.00%)  
Person-days | overall | N (%) | 345,934 (100.00%)  
| Female | N (%) | 221,503 (64.03%)  
| Male | N (%) | 124,431 (35.97%)  
  
### Visualise the results

Finally, we can visualise the trend using `[plotInObservation()](../reference/plotInObservation.html)`.
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period,
      interval = "years"
    )
    [plotInObservation](../reference/plotInObservation.html)(summarisedResult)

![](summarise_observation_period_files/figure-html/unnamed-chunk-17-1.png)

Notice that one output at a time can be plotted. If more outputs have been included in the summarised result, you will have to filter to only include one variable at time.

Additionally, if results were stratified by sex or age group, we can further use `facet` or `colour` arguments to highlight the different results in the plot. To help us identify by which variables we can colour or facet by, we can use [visOmopResult](https://darwin-eu.github.io/visOmopResults/) package.
    
    
    
    summarisedResult <- [summariseInObservation](../reference/summariseInObservation.html)(cdm$observation_period, 
                           interval = "years",
                           output = [c](https://rdrr.io/r/base/c.html)("record", "age"),
                           sex = TRUE,
                           ageGroup = [list](https://rdrr.io/r/base/list.html)("<35" = [c](https://rdrr.io/r/base/c.html)(0, 34), ">=35" = [c](https://rdrr.io/r/base/c.html)(35, Inf))) 
    [plotInObservation](../reference/plotInObservation.html)(summarisedResult |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Age in observation"),
      colour = "sex", 
      facet = "age_group")

![](summarise_observation_period_files/figure-html/unnamed-chunk-18-1.png)

Finally, disconnect from the cdm
    
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
