# Package index • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# Package index

### Generate a set of drug cohorts

Generate a set of drug cohorts using given concepts or vocabulary hierarchies

`[generateDrugUtilisationCohortSet()](generateDrugUtilisationCohortSet.html)`
    Generate a set of drug cohorts based on given concepts

`[generateIngredientCohortSet()](generateIngredientCohortSet.html)`
    Generate a set of drug cohorts based on drug ingredients

`[generateAtcCohortSet()](generateAtcCohortSet.html)`
    Generate a set of drug cohorts based on ATC classification

`[erafyCohort()](erafyCohort.html)`
    Erafy a cohort_table collapsing records separated gapEra days or less.

`[cohortGapEra()](cohortGapEra.html)`
    Get the gapEra used to create a cohort

### Apply inclusion criteria to drug cohorts

Apply inclusion criteria that filter drug cohort entries based on specified rules.

`[requireDrugInDateRange()](requireDrugInDateRange.html)`
    Restrict cohort to only cohort records within a certain date range

`[requireIsFirstDrugEntry()](requireIsFirstDrugEntry.html)`
    Restrict cohort to only the first cohort record per subject

`[requireObservationBeforeDrug()](requireObservationBeforeDrug.html)`
    Restrict cohort to only cohort records with the given amount of prior observation time in the database

`[requirePriorDrugWashout()](requirePriorDrugWashout.html)`
    Restrict cohort to only cohort records with a given amount of time since the last cohort record ended

### Identify and summarise indications for patients in drug cohorts

Indications identified based on their presence in indication cohorts or OMOP CDM clinical tabes.

`[addIndication()](addIndication.html)`
    Add a variable indicating individuals indications

`[summariseIndication()](summariseIndication.html)`
    Summarise the indications of individuals in a drug cohort

`[tableIndication()](tableIndication.html)`
    Create a table showing indication results

`[plotIndication()](plotIndication.html)`
    Generate a plot visualisation (ggplot2) from the output of summariseIndication

### Drug use functions

Drug use functions are used to summarise and obtain the drug use information

`[addDrugUtilisation()](addDrugUtilisation.html)`
    Add new columns with drug use related information

`[summariseDrugUtilisation()](summariseDrugUtilisation.html)`
    This function is used to summarise the dose utilisation table over multiple cohorts.

`[tableDrugUtilisation()](tableDrugUtilisation.html)`
    Format a drug_utilisation object into a visual table.

`[plotDrugUtilisation()](plotDrugUtilisation.html)`
    Plot the results of `summariseDrugUtilisation`

### Drug use individual functions

Drug use functions can be used to add a single estimates

`[addNumberExposures()](addNumberExposures.html)`
    To add a new column with the number of exposures. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addNumberEras()](addNumberEras.html)`
    To add a new column with the number of eras. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addTimeToExposure()](addTimeToExposure.html)`
    To add a new column with the time to exposure. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addDaysExposed()](addDaysExposed.html)`
    To add a new column with the days exposed. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addDaysPrescribed()](addDaysPrescribed.html)`
    To add a new column with the days prescribed. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addInitialExposureDuration()](addInitialExposureDuration.html)`
    To add a new column with the duration of the first exposure. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addInitialQuantity()](addInitialQuantity.html)`
    To add a new column with the initial quantity. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addCumulativeQuantity()](addCumulativeQuantity.html)`
    To add a new column with the cumulative quantity. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addInitialDailyDose()](addInitialDailyDose.html)`
    To add a new column with the initial daily dose. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

`[addCumulativeDose()](addCumulativeDose.html)`
    To add a new column with the cumulative dose. To add multiple columns use `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` for efficiency.

### Summarise treatment persistence using proportion of patients covered (PPC)

Summarise the proportion of patients in the drug cohort over time.

`[summariseProportionOfPatientsCovered()](summariseProportionOfPatientsCovered.html)`
    Summarise proportion Of patients covered

`[tableProportionOfPatientsCovered()](tableProportionOfPatientsCovered.html)`
    Create a table with proportion of patients covered results

`[plotProportionOfPatientsCovered()](plotProportionOfPatientsCovered.html)`
    Plot proportion of patients covered

### Summarise treatments during certain windows

Summarise the use of different treatments during certain windows

`[addTreatment()](addTreatment.html)`
    Add a variable indicating individuals medications

`[summariseTreatment()](summariseTreatment.html)`
    This function is used to summarise treatments received

`[tableTreatment()](tableTreatment.html)`
    Format a summarised_treatment result into a visual table.

`[plotTreatment()](plotTreatment.html)`
    Generate a custom ggplot2 from a summarised_result object generated with summariseTreatment function.

### Summarise treatment restart or switch during certain time

Summarise the restart of a treatment, or switch to another, during certain time

`[addDrugRestart()](addDrugRestart.html)`
    Add drug restart information as a column per follow-up period of interest.

`[summariseDrugRestart()](summariseDrugRestart.html)`
    Summarise the drug restart for each follow-up period of interest.

`[tableDrugRestart()](tableDrugRestart.html)`
    Format a drug_restart object into a visual table.

`[plotDrugRestart()](plotDrugRestart.html)`
    Generate a custom ggplot2 from a summarised_result object generated with summariseDrugRestart() function.

### Daily dose documentation

Functions to assess coverage for the diferent ingredients and document how daily dose is calculated

`[patternsWithFormula](patternsWithFormula.html)`
    Patterns valid to compute daily dose with the associated formula.

`[patternTable()](patternTable.html)`
    Function to create a tibble with the patterns from current drug strength table

`[summariseDoseCoverage()](summariseDoseCoverage.html)`
    Check coverage of daily dose computation in a sample of the cdm for selected concept sets and ingredient

`[tableDoseCoverage()](tableDoseCoverage.html)`
    Format a dose_coverage object into a visual table.

### Complementary functions

Complementary functions

`[benchmarkDrugUtilisation()](benchmarkDrugUtilisation.html)`
    Run benchmark of drug utilisation cohort generation

`[mockDrugUtilisation()](mockDrugUtilisation.html)`
    It creates a mock database for testing DrugUtilisation package

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
