# Creating denominator cohorts • IncidencePrevalence

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Creating denominator cohorts

Source: [`vignettes/a02_Creating_denominator_populations.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a02_Creating_denominator_populations.Rmd)

`a02_Creating_denominator_populations.Rmd`

## Introduction

Calculating incidence or prevalence requires first identifying an appropriate denominator population. To find such a denominator population (or multiple denominator populations) we can use the `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` function. This function will identify the time that people in the database satisfy a set of criteria related to the study period and individuals´ age, sex, and amount of prior observed history.

When using `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` individuals will enter a denominator population on the respective date of the latest of the following:

  1. Study start date
  2. Date at which they have sufficient prior observation
  3. Date at which they reach a minimum age



They will then exit on the respective date of the earliest of the following:

  1. Study end date
  2. Date at which their observation period ends
  3. The last day in which they have the maximum age



Let´s go through a few examples to make this logic a little more concrete.

#### No specific requirements

The simplest case is that no study start and end dates are specified, no prior history requirement is imposed, nor any age or sex criteria. In this case individuals will enter the denominator population once they have entered the database (start of observation period) and will leave when they exit the database (end of observation period). Note that in some databases a person can have multiple observation periods, in which case their contribution of person time would look like the the last person below.

![](dpop1.png)

#### Specified study period

If we specify a study start and end date then only observation time during this period will be included.

![](dpop2.png)

#### Specified study period and prior history requirement

If we also add some requirement of prior history then somebody will only contribute time at risk once this is reached.

![](dpop3.png)

#### Specified study period, prior history requirement, and age and sex criteria

Lastly we can also impose age and sex criteria, and now individuals will only contribute time when they also satisfy these criteria. Not shown in the below figure is a person´s sex, but we could also stratify a denominator population by this as well.

![](dpop4.png)

## Using generateDenominatorCohortSet()

`[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` is the function we use to identify a set of denominator populations. To demonstrate its use, let´s load the IncidencePrevalence package (along with a couple of packages to help for subsequent plots) and generate 500 example patients using the `[mockIncidencePrevalence()](../reference/mockIncidencePrevalence.html)` function.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(sampleSize = 500)

#### No specific requirements

We can get a denominator population without including any particular requirements like so
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA)),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0
    )
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 1974-04-03        1982-01-16     
    #>  2                    1          6 1990-10-30        1996-06-28     
    #>  3                    1          7 1995-10-09        1997-02-28     
    #>  4                    1          9 1984-04-14        1989-04-07     
    #>  5                    1         11 2004-04-10        2012-09-24     
    #>  6                    1         12 2004-11-14        2007-04-29     
    #>  7                    1         13 2000-06-29        2004-06-13     
    #>  8                    1         15 1995-03-27        2005-09-01     
    #>  9                    1         16 2009-02-24        2011-09-29     
    #> 10                    1         17 2003-04-03        2006-01-26     
    #> # ℹ more rows
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"))
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          4 1974-04-03        1982-01-16

Let´s have a look at the included time of the first five patients. We can see that people enter and leave at different times.

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-9-1.png)

We can also plot a histogram of start and end dates of the 500 simulated patients
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(cohort_start_date),
        colour = "black", fill = "grey"
      )

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-10-1.png)
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(cohort_end_date),
        colour = "black", fill = "grey"
      )

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-11-1.png)

#### Specified study period

We can get specify a study period like so
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 0
    )
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1990-10-30        1996-06-28     
    #>  2                    1          7 1995-10-09        1997-02-28     
    #>  3                    1         11 2004-04-10        2009-12-31     
    #>  4                    1         12 2004-11-14        2007-04-29     
    #>  5                    1         13 2000-06-29        2004-06-13     
    #>  6                    1         15 1995-03-27        2005-09-01     
    #>  7                    1         16 2009-02-24        2009-12-31     
    #>  8                    1         17 2003-04-03        2006-01-26     
    #>  9                    1         21 1991-11-16        2000-05-05     
    #> 10                    1         28 2005-11-16        2007-03-12     
    #> # ℹ more rows
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             97              97
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"))
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>

Now we can see that many more people share the same cohort entry (the study start date) and cohort exit (the study end date).
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(cohort_start_date),
        colour = "black", fill = "grey"
      )

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-13-1.png)
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(cohort_end_date),
        colour = "black", fill = "grey"
      )

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-14-1.png)

#### Specified study period and prior history requirement

We can add some requirement of prior history
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = "Both",
      daysPriorObservation = 365
    )
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1991-10-30        1996-06-28     
    #>  2                    1          7 1996-10-08        1997-02-28     
    #>  3                    1         11 2005-04-10        2009-12-31     
    #>  4                    1         12 2005-11-14        2007-04-29     
    #>  5                    1         13 2001-06-29        2004-06-13     
    #>  6                    1         15 1996-03-26        2005-09-01     
    #>  7                    1         17 2004-04-02        2006-01-26     
    #>  8                    1         21 1992-11-15        2000-05-05     
    #>  9                    1         28 2006-11-16        2007-03-12     
    #> 10                    1         35 1990-01-01        1991-07-05     
    #> # ℹ more rows
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             85              85
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"))
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>

#### Specified study period, prior history requirement, and age and sex criteria

In addition to all the above we could also add some requirements around age and sex. One thing to note is that the age upper limit will include time from a person up to the day before their reach the age upper limit + 1 year. For instance, when the upper limit is 65, that means we will include time from a person up to and including the day before their 66th birthday.
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(18, 65)),
      sex = "Female",
      daysPriorObservation = 365
    )
    cdm$denominator [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 6, 7, 21, 41, 62, 72, 79, 115, 122, 142, 163, 197…
    #> $ cohort_start_date    <date> 1991-10-30, 1996-10-08, 1992-11-15, 1991-11-22, …
    #> $ cohort_end_date      <date> 1996-06-28, 1997-02-28, 2000-05-05, 1992-10-13, …
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             27              27
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"))
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>

#### Multiple options to return multiple denominator populations

More than one age, sex and prior history requirements can be specified at the same time. First, we can take a look at having two age groups. We can see below that those individuals who have their 41st birthday during the study period will go from the first cohort (age_group: 0;40) to the second (age_group: 41;100) on this day.
    
    
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(
      sampleSize = 500,
      earliestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      latestObservationStartDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-01-01"),
      minDaysToObservationEnd = 10000,
      maxDaysToObservationEnd = NULL,
      earliestDateOfBirth = [as.Date](https://rdrr.io/r/base/as.Date.html)("1960-01-01"),
      latestDateOfBirth = [as.Date](https://rdrr.io/r/base/as.Date.html)("1980-01-01")
    )
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 40),
        [c](https://rdrr.io/r/base/c.html)(41, 100)
      ),
      sex = "Both",
      daysPriorObservation = 0
    )
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) !![as.character](https://rdrr.io/r/base/character.html)([seq](https://rdrr.io/r/base/seq.html)(1:30))) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)([settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator),
        by = "cohort_definition_id"
      ) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(subject_id = [factor](https://rdrr.io/r/base/factor.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id))) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = subject_id, y = value, colour = age_group)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(
        legend.position = "top",
        legend.title = [element_blank](https://ggplot2.tidyverse.org/reference/element.html)()
      ) +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Year") +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-17-1.png)

We can then also sex specific denominator cohorts.
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 40),
        [c](https://rdrr.io/r/base/c.html)(41, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = 0
    )
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) !![as.character](https://rdrr.io/r/base/character.html)([seq](https://rdrr.io/r/base/seq.html)(1:15))) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)([settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(subject_id = [factor](https://rdrr.io/r/base/factor.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id))) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = subject_id, y = value, colour = age_group)) +
      [facet_grid](https://ggplot2.tidyverse.org/reference/facet_grid.html)(sex ~ ., space = "free_y") +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(
        legend.position = "top",
        legend.title = [element_blank](https://ggplot2.tidyverse.org/reference/element.html)()
      ) +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Year") +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-18-1.png)

And we could also specifying multiple prior history requirements
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 40),
        [c](https://rdrr.io/r/base/c.html)(41, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = [c](https://rdrr.io/r/base/c.html)(0, 365)
    )
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) !![as.character](https://rdrr.io/r/base/character.html)([seq](https://rdrr.io/r/base/seq.html)(1:8))) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)([settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(subject_id = [factor](https://rdrr.io/r/base/factor.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id))) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(
        x = subject_id, y = value, colour = age_group,
        linetype = sex, shape = sex
      )) +
      [facet_grid](https://ggplot2.tidyverse.org/reference/facet_grid.html)(sex + days_prior_observation ~ .,
        space = "free",
        scales = "free"
      ) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(legend.position = "top") +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Year") +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-19-1.png)

Note, setting requirementInteractions to FALSE would mean that only the first value of other age, sex, and prior history requirements are considered for a given characteristic. In this case the order of the values will be important and generally the first values will be the primary analysis settings while subsequent values are for secondary analyses.
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 40),
        [c](https://rdrr.io/r/base/c.html)(41, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
      daysPriorObservation = [c](https://rdrr.io/r/base/c.html)(0, 365),
      requirementInteractions = FALSE
    )
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) !![as.character](https://rdrr.io/r/base/character.html)([seq](https://rdrr.io/r/base/seq.html)(1:8))) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)([settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator)) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(subject_id = [factor](https://rdrr.io/r/base/factor.html)([as.numeric](https://rdrr.io/r/base/numeric.html)(subject_id))) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(
        x = subject_id, y = value, colour = age_group,
        linetype = sex, shape = sex
      )) +
      [facet_grid](https://ggplot2.tidyverse.org/reference/facet_grid.html)(sex + days_prior_observation ~ .,
        space = "free",
        scales = "free"
      ) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)(position = [position_dodge](https://ggplot2.tidyverse.org/reference/position_dodge.html)(width = 0.5)) +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [theme](https://ggplot2.tidyverse.org/reference/theme.html)(legend.position = "top") +
      [ylab](https://ggplot2.tidyverse.org/reference/labs.html)("Year") +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](a02_Creating_denominator_populations_files/figure-html/unnamed-chunk-20-1.png)

#### Output

`[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` will generate a table with the denominator population, which includes the information on all the individuals who fulfill the given criteria at any point during the study period. It also includes information on the specific start and end dates in which individuals contributed to the denominator population (cohort_start_date and cohort_end_date). Each patient is recorded in a different row. For those databases that allow individuals to have multiple non-overlapping observation periods, one row for each patient and observation period is considered.

Considering the following example, we can see:
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator",
      cohortDateRange = [c](https://rdrr.io/r/base/c.html)([as.Date](https://rdrr.io/r/base/as.Date.html)("1990-01-01"), [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-12-31")),
      ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 18),
        [c](https://rdrr.io/r/base/c.html)(19, 100)
      ),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female"),
      daysPriorObservation = [c](https://rdrr.io/r/base/c.html)(0, 365)
    )
    
    [head](https://rdrr.io/r/utils/head.html)(cdm$denominator, 8)
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    5          2 2004-12-15        2009-12-31     
    #> 2                    5          3 2004-09-24        2009-12-31     
    #> 3                    5          4 2002-06-22        2009-12-31     
    #> 4                    5          5 2001-05-11        2009-12-31     
    #> 5                    5          9 2004-02-27        2009-12-31     
    #> 6                    5         10 2000-01-18        2009-12-31     
    #> 7                    5         12 2004-10-21        2009-12-31     
    #> 8                    5         13 2000-06-29        2009-12-31

The output table will have several attributes. With `[settings()](https://darwin-eu.github.io/omopgenerics/reference/settings.html)` we can see the options used when defining the set of denominator populations. More than one age, sex and prior history requirements can be specified at the same time and each combination of these variables will result in a different cohort, each of which has a corresponding cohort_definition_id. In the above example, we identified 8 different cohorts:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$denominator) [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 8
    #> Columns: 11
    #> $ cohort_definition_id        <int> 1, 2, 3, 4, 5, 6, 7, 8
    #> $ cohort_name                 <chr> "denominator_cohort_1", "denominator_cohor…
    #> $ age_group                   <chr> "0 to 18", "0 to 18", "0 to 18", "0 to 18"…
    #> $ sex                         <chr> "Male", "Male", "Female", "Female", "Male"…
    #> $ days_prior_observation      <dbl> 0, 365, 0, 365, 0, 365, 0, 365
    #> $ start_date                  <date> 1990-01-01, 1990-01-01, 1990-01-01, 1990-0…
    #> $ end_date                    <date> 2009-12-31, 2009-12-31, 2009-12-31, 2009-1…
    #> $ requirements_at_entry       <chr> "FALSE", "FALSE", "FALSE", "FALSE", "FALS…
    #> $ target_cohort_definition_id <int> NA, NA, NA, NA, NA, NA, NA, NA
    #> $ target_cohort_name          <chr> "None", "None", "None", "None", "None", "…
    #> $ time_at_risk                <chr> "0 to Inf", "0 to Inf", "0 to Inf", "0 to …

With `[cohortCount()](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)` we can see the number of individuals who entered each study cohort
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$denominator) [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 8
    #> Columns: 3
    #> $ cohort_definition_id <int> 1, 2, 3, 4, 5, 6, 7, 8
    #> $ number_records       <int> 0, 0, 0, 0, 233, 233, 267, 267
    #> $ number_subjects      <int> 0, 0, 0, 0, 233, 233, 267, 267

With `[attrition()](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)` we can see the number of individuals in the database who were excluded from entering a given denominator population along with the reason (such as missing crucial information or not satisfying the sex or age criteria required, among others):
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$denominator) [%>%](../reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 72
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2…
    #> $ number_records       <int> 500, 500, 500, 500, 500, 500, 500, 233, 0, 500, 5…
    #> $ number_subjects      <int> 500, 500, 500, 500, 500, 500, 500, 233, 0, 500, 5…
    #> $ reason_id            <int> 1, 2, 3, 4, 5, 6, 7, 8, 10, 1, 2, 3, 4, 5, 6, 7, …
    #> $ reason               <chr> "Starting population", "Missing year of birth", "…
    #> $ excluded_records     <int> NA, 0, 0, 0, 0, 0, 0, 267, 233, NA, 0, 0, 0, 0, 0…
    #> $ excluded_subjects    <int> NA, 0, 0, 0, 0, 0, 0, 267, 233, NA, 0, 0, 0, 0, 0…

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
