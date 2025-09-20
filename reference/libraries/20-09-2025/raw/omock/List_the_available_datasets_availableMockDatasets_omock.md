# List the available datasets — availableMockDatasets • omock

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# List the available datasets

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`availableMockDatasets.Rd`

List the available datasets

## Usage
    
    
    availableMockDatasets()

## Value

A character vector with the available datasets.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    availableMockDatasets()
    #>  [1] "GiBleed"                             "empty_cdm"                          
    #>  [3] "synpuf-1k_5.3"                       "synpuf-1k_5.4"                      
    #>  [5] "synthea-allergies-10k"               "synthea-anemia-10k"                 
    #>  [7] "synthea-breast_cancer-10k"           "synthea-contraceptives-10k"         
    #>  [9] "synthea-covid19-10k"                 "synthea-covid19-200k"               
    #> [11] "synthea-dermatitis-10k"              "synthea-heart-10k"                  
    #> [13] "synthea-hiv-10k"                     "synthea-lung_cancer-10k"            
    #> [15] "synthea-medications-10k"             "synthea-metabolic_syndrome-10k"     
    #> [17] "synthea-opioid_addiction-10k"        "synthea-rheumatoid_arthritis-10k"   
    #> [19] "synthea-snf-10k"                     "synthea-surgery-10k"                
    #> [21] "synthea-total_joint_replacement-10k" "synthea-veteran_prostate_cancer-10k"
    #> [23] "synthea-veterans-10k"                "synthea-weight_loss-10k"            
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
