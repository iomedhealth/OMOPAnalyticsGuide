# Creating target denominator populations • IncidencePrevalence

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

# Creating target denominator populations

Source: [`vignettes/a03_Creating_target_denominator_populations.Rmd`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/vignettes/a03_Creating_target_denominator_populations.Rmd)

`a03_Creating_target_denominator_populations.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

## Using generateDenominatorCohortSet() with a target cohort

As seen in the previous vignette, `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)` can be used to generate denominator populations based on all individuals in the database with individuals included once they satisfy criteria. However, in some case we might want to define a denominator population within a specific population of interest, for example people diagnosed with a condition of interest. The function `[generateTargetDenominatorCohortSet()](../reference/generateTargetDenominatorCohortSet.html)` provides functionality for this.

To provide an example its use, let´s generate 5 example patients.

Here we generate a simulated target cohort table with 5 individuals and 2 different target cohorts to illustrate the following examples. Note, some of the individuals in the database are in an acute asthma cohort.
    
    
    personTable <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"),
      gender_concept_id = [c](https://rdrr.io/r/base/c.html)([rep](https://rdrr.io/r/base/rep.html)("8507", 2), [rep](https://rdrr.io/r/base/rep.html)("8532", 3)),
      year_of_birth = 2000,
      month_of_birth = 06,
      day_of_birth = 01
    )
    observationPeriodTable <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = "1",
      person_id = [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5"),
      observation_period_start_date = [c](https://rdrr.io/r/base/c.html)(
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-12-19"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-04-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2009-04-10"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-08-20"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01")
      ),
      observation_period_end_date = [c](https://rdrr.io/r/base/c.html)(
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2011-06-19"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-11-29"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2016-01-02"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2011-12-11"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2015-06-01")
      )
    )
    
    acute_asthma <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [rep](https://rdrr.io/r/base/rep.html)("1", 5),
      subject_id = [c](https://rdrr.io/r/base/c.html)("3", "3", "5", "5", "2"),
      cohort_start_date = [c](https://rdrr.io/r/base/c.html)(
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2011-01-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2015-06-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2014-10-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-06-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-08-20")
      ),
      cohort_end_date = [c](https://rdrr.io/r/base/c.html)(
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2013-01-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2015-12-31"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2015-04-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-06-01"),
        [as.Date](https://rdrr.io/r/base/as.Date.html)("2005-09-20")
      )
    )
    
    # mock database
    cdm <- [mockIncidencePrevalence](../reference/mockIncidencePrevalence.html)(
      personTable = personTable,
      observationPeriodTable = observationPeriodTable,
      targetCohortTable = acute_asthma
    )

As we´ve already seen, we can get a denominator population without including any particular subset like so
    
    
    cdm <- [generateDenominatorCohortSet](../reference/generateDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator"
    )
    cdm$denominator
    #> # Source:   table<denominator> [?? x 4]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int> <chr>      <date>            <date>         
    #> 1                    1 1          2010-12-19        2011-06-19     
    #> 2                    1 2          2005-04-01        2005-11-29     
    #> 3                    1 3          2009-04-10        2016-01-02     
    #> 4                    1 4          2010-08-20        2011-12-11     
    #> 5                    1 5          2010-01-01        2015-06-01

As we did not specify any study start and end date, the cohort start and end date of our 5 patients correspond to the same registered as observation period.
    
    
    cdm$denominator [%>%](../reference/pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("1", "2", "3", "4", "5")) [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-4-1.png)

But if we use `[generateTargetDenominatorCohortSet()](../reference/generateTargetDenominatorCohortSet.html)` to create a denominator cohort among the individuals in the acute asthma cohort.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma",
      targetCohortTable = "target"
    )

We can see that persons “3” and “5” experienced this condition in two different occasions and contribute time to the denominator population twice, while person “2” contributes one period of time at risk.
    
    
    cdm$denominator_acute_asthma [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-6-1.png)

### Applying cohort restrictions

We can use PatientProfiles to see demographics at time of entry to the target cohort.
    
    
    cdm$target |> 
      PatientProfiles::[addDemographics](https://darwin-eu.github.io/PatientProfiles/reference/addDemographics.html)(indexDate = "cohort_start_date")
    #> # Source:   table<og_001_1753254292> [?? x 8]
    #> # Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date   age sex   
    #>                  <int> <chr>      <date>            <date>          <int> <chr> 
    #> 1                    1 2          2005-08-20        2005-09-20          5 Male  
    #> 2                    1 3          2015-06-01        2015-12-31         15 Female
    #> 3                    1 5          2010-06-01        2010-06-01         10 Female
    #> 4                    1 3          2011-01-01        2013-01-01         10 Female
    #> 5                    1 5          2014-10-01        2015-04-01         14 Female
    #> # ℹ 2 more variables: prior_observation <int>, future_observation <int>

Restrictions based on age, sex, and prior observation, and calendar dates can again be applied like with `[generateDenominatorCohortSet()](../reference/generateDenominatorCohortSet.html)`. However, now we have additional considerations on how these restrictions are implemented. In particular, whether requirements must be fulfilled on the date of target cohort entry or whether we allow people to contribute time once they satisfy time-varying criteria.

This choice is implemented using the `requirementsAtEntry` argument. When this is set to TRUE individuals must satisfy the age and prior observation requirements on their target cohort entry date. In the case below we can see that persons “3” and “5” satisfy the sex and age requirements on their target cohort start dates, although one of the cohort entries is excluded for patient “3” and “5” as they were below the minimum age at their date of cohort entry.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_incident",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target",
      requirementsAtEntry = TRUE
    )
    
    cdm$denominator_acute_asthma_incident [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-8-1.png)

If we change `requirementsAtEntry` to FALSE individuals can now contribute once they the various criteria. Now we can see that we have included an extra period of time of risk for patient “3”. This is because although they were younger than 11 at their cohort entry, we now allow them to contribute time once they have reached the age of 11.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_prevalent",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target",
      requirementsAtEntry = FALSE
    )
    
    cdm$denominator_acute_asthma_prevalent [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-9-1.png)

Similarly, let’s say we are considering multiple, non-overlapping, age groups. Setting requirementsAtEntry to TRUE will mean that an individual will only contribute a given target entry to one of these - the one where they are that age on the day of target cohort entry. However, setting requirementsAtEntry to FALSE would allow an individual to graduate from one age group to another.

As with age, the same will apply when specifying time varying elements such as date criteria and prior observation requirements. For example, if we specify dates using `cohortDateRange` then if requirementsAtEntry is TRUE an individual must enter the target cohort during the date range,

### Specifying time at risk

We can also enforce a time at risk for people to contribute to the denominator. For instance, we might only want to take into account events for people in the target denominator cohort on their first month after cohort entry. This can be achieved by adding the input parameter `timeAtRisk = c(0,30)` when computing the denominator, before any incidence or prevalence calculations.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_2",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target",
      timeAtRisk = [c](https://rdrr.io/r/base/c.html)(0, 30)
    )
    
    cdm$denominator_acute_asthma_2 [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-10-1.png)

Note that this parameter allows the user to input different time at risk values in the same function call. Therefore, if we ask for `timeAtRisk = list(c(0, 30), c(31, 60))`, we will get a denominator cohort of people contributing time up to 30 days following cohort entry, and another one with time from 31 days following cohort entry to 60 days.
    
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_3",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target",
      timeAtRisk = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 30), [c](https://rdrr.io/r/base/c.html)(31, 60))
    )
    
    cdm$denominator_acute_asthma_3 [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      dplyr::[left_join](https://dplyr.tidyverse.org/reference/mutate-joins.html)(
        [attr](https://rdrr.io/r/base/attr.html)(cdm$denominator_acute_asthma_3, "cohort_set") [%>%](../reference/pipe.html)
          dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)([c](https://rdrr.io/r/base/c.html)(
            "cohort_definition_id",
            "time_at_risk"
          )),
        by = "cohort_definition_id",
        copy = TRUE
      ) [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row, colour = time_at_risk)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-11-1.png)

Additionally, observe that this parameter allows us to control the follow-up of these individuals after cohort entry for the denominator cohort, but this is inherently linked to their cohort exit and the end of their observation period. Hence, if we define the target cohort so that individuals are only followed for one month, and we now require `timeAtRisk = c(0,90)`, we will get the same denominator cohort as in the previous example.
    
    
    cdm$target_2 <- cdm$target |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(dif = cohort_end_date - cohort_start_date) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_end_date = dplyr::[if_else](https://dplyr.tidyverse.org/reference/if_else.html)(
        dif > 30,
        clock::[add_days](https://clock.r-lib.org/reference/clock-arithmetic.html)(cohort_start_date, 30),
        cohort_end_date
      )) |>
      dplyr::[select](https://dplyr.tidyverse.org/reference/select.html)(-"dif") |>
      dplyr::[compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "target_2")
    
    cdm <- [generateTargetDenominatorCohortSet](../reference/generateTargetDenominatorCohortSet.html)(
      cdm = cdm,
      name = "denominator_acute_asthma_4",
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(11, 15)),
      sex = "Female",
      daysPriorObservation = 0,
      targetCohortTable = "target_2",
      timeAtRisk = [c](https://rdrr.io/r/base/c.html)(0, 90)
    )
    
    cdm$denominator_acute_asthma_4 [%>%](../reference/pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() [%>%](../reference/pipe.html)
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(row = [row_number](https://dplyr.tidyverse.org/reference/row_number.html)()) [%>%](../reference/pipe.html)
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(cols = [c](https://rdrr.io/r/base/c.html)(
        "cohort_start_date",
        "cohort_end_date"
      )) [%>%](../reference/pipe.html)
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(group = row)) +
      [geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [geom_line](https://ggplot2.tidyverse.org/reference/geom_path.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = value, y = subject_id)) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year")

![](a03_Creating_target_denominator_populations_files/figure-html/unnamed-chunk-12-1.png)

Note that time at risk will always be related to target cohort entry. If we set `requirementsAtEntry` to FALSE and an individual contributes time from 31 days after their target entry date, they wouldn’t contribute any time if timeAtRisk was set to c(0, 30).

## On this page

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
