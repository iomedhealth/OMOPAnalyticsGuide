# Run benchmark of drug utilisation cohort generation — benchmarkDrugUtilisation • DrugUtilisation

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

# Run benchmark of drug utilisation cohort generation

Source: [`R/benchmarkDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/benchmarkDrugUtilisation.R)

`benchmarkDrugUtilisation.Rd`

Run benchmark of drug utilisation cohort generation

## Usage
    
    
    benchmarkDrugUtilisation(
      cdm,
      ingredient = "acetaminophen",
      alternativeIngredient = [c](https://rdrr.io/r/base/c.html)("ibuprofen", "aspirin", "diclofenac"),
      indicationCohort = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object.

ingredient
    

Name of ingredient to benchmark.

alternativeIngredient
    

Name of ingredients to use as alternative treatments.

indicationCohort
    

Name of a cohort in the cdm_reference object to use as indicatiomn.

## Value

A summarise_result object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    #> ℹ `EUNOMIA_DATA_FOLDER` set to: /tmp/Rtmp2H2pze.
    #> 
    #> Download completed!
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()))
    #> Creating CDM database /tmp/Rtmp2H2pze/GiBleed_5.3.zip
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    timings <- benchmarkDrugUtilisation(cdm)
    #> 03-07-2025 14:01:05 Benchmark get necessary concepts
    #> 03-07-2025 14:01:05 Benchmark generateDrugUtilisation
    #> 03-07-2025 14:01:08 Benchmark generateDrugUtilisation with numberExposures and
    #> daysPrescribed
    #> 03-07-2025 14:01:11 Benchmark require
    #> 03-07-2025 14:01:13 Benchmark generateIngredientCohortSet
    #> 03-07-2025 14:01:18 Benchmark summariseDrugUtilisation
    #> 03-07-2025 14:01:24 Benchmark summariseDrugRestart
    #> 03-07-2025 14:01:26 Benchmark summariseProportionOfPatientsCovered
    #> 03-07-2025 14:01:31 Benchmark summariseTreatment
    #> 03-07-2025 14:01:34 Benchmark drop created tables
    
    timings
    #> # A tibble: 10 × 13
    #>    result_id cdm_name group_name group_level            strata_name strata_level
    #>        <int> <chr>    <chr>      <chr>                  <chr>       <chr>       
    #>  1         1 Synthea  task       get necessary concepts overall     overall     
    #>  2         1 Synthea  task       generateDrugUtilisati… overall     overall     
    #>  3         1 Synthea  task       generateDrugUtilisati… overall     overall     
    #>  4         1 Synthea  task       require                overall     overall     
    #>  5         1 Synthea  task       generateIngredientCoh… overall     overall     
    #>  6         1 Synthea  task       summariseDrugUtilisat… overall     overall     
    #>  7         1 Synthea  task       summariseDrugRestart   overall     overall     
    #>  8         1 Synthea  task       summariseProportionOf… overall     overall     
    #>  9         1 Synthea  task       summariseTreatment     overall     overall     
    #> 10         1 Synthea  task       drop created tables    overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
