# Exploring the OMOP CDM vocabulary tables • CodelistGenerator

Skip to contents

[CodelistGenerator](../index.html) 3.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Getting the OMOP CDM vocabularies](../articles/a01_GettingOmopCdmVocabularies.html)
    * [Exploring the OMOP CDM vocabulary tables](../articles/a02_ExploreCDMvocabulary.html)
    * [Generate a candidate codelist](../articles/a03_GenerateCandidateCodelist.html)
    * [Generating vocabulary based codelists for medications](../articles/a04_GenerateVocabularyBasedCodelist.html)
    * [Generating vocabulary based codelists for conditions](../articles/a04b_icd_codes.html)
    * [Extract codelists from JSON files](../articles/a05_ExtractCodelistFromJSONfile.html)
    * [Compare, subset or stratify codelists](../articles/a06_CreateSubsetsFromCodelist.html)
    * [Codelist diagnostics](../articles/a07_RunCodelistDiagnostics.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Exploring the OMOP CDM vocabulary tables

`a02_ExploreCDMvocabulary.Rmd`

In this vignette, we will explore the functions that help us delve into the vocabularies used in our database. These functions allow us to explore the different vocabularies and concepts characteristics.

First of all, we will load the required packages and a eunomia database.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    # Connect to the database and create the cdm object
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                      cdmName = "Eunomia Synpuf",
                      cdmSchema   = "main",
                      writeSchema = "main", 
                      achillesSchema = "main")

Note that we have included [achilles tables](https://github.com/OHDSI/Achilles) in our cdm reference, which are used for some of the analyses.

## Vocabulary characteristics

We can first start by getting the vocabulary version of our CDM object:
    
    
    [getVocabVersion](../reference/getVocabVersion.html)(cdm)
    #> [1] "v5.0 06-AUG-21"

And the available vocabularies, which correspond to the column _vocabulary_id_ from the concept table:
    
    
    [getVocabularies](../reference/getVocabularies.html)(cdm)
    #>  [1] "APC"                  "ATC"                  "BDPM"                
    #>  [4] "CMS Place of Service" "Cohort"               "Concept Class"       
    #>  [7] "Condition Type"       "CPT4"                 "Currency"            
    #> [10] "Death Type"           "Device Type"          "Domain"              
    #> [13] "DPD"                  "DRG"                  "Drug Type"           
    #> [16] "Ethnicity"            "Gemscript"            "Gender"              
    #> [19] "HCPCS"                "HES Specialty"        "ICD10"               
    #> [22] "ICD10CM"              "ICD9CM"               "ICD9Proc"            
    #> [25] "LOINC"                "MDC"                  "Meas Type"           
    #> [28] "Multilex"             "Multum"               "NDC"                 
    #> [31] "NDFRT"                "None"                 "Note Type"           
    #> [34] "NUCC"                 "Obs Period Type"      "Observation Type"    
    #> [37] "OPCS4"                "OXMIS"                "PCORNet"             
    #> [40] "Procedure Type"       "Provider"             "Race"                
    #> [43] "Read"                 "Relationship"         "Revenue Code"        
    #> [46] "RxNorm"               "RxNorm Extension"     "SMQ"                 
    #> [49] "SNOMED"               "SPL"                  "Supplier"            
    #> [52] "UCUM"                 "VA Class"             "VA Product"          
    #> [55] "Visit"                "Visit Type"           "Vocabulary"

## Domains

We can also explore the domains that our CDM object has, which is the column _domain_id_ from the concept table:
    
    
    [getDomains](../reference/getDomains.html)(cdm)
    #>  [1] "Drug"                "Device"              "Meas Value"         
    #>  [4] "Procedure"           "Provider"            "Metadata"           
    #>  [7] "Ethnicity"           "Race"                "Gender"             
    #> [10] "Relationship"        "Specimen"            "Route"              
    #> [13] "Spec Disease Status" "Currency"            "Observation"        
    #> [16] "Unit"                "Condition"           "Visit"              
    #> [19] "Measurement"         "Spec Anatomic Site"  "Meas Value Operator"
    #> [22] "Revenue Code"

or restrict the search among _standard_ concepts:
    
    
    [getDomains](../reference/getDomains.html)(cdm, 
               standardConcept = "Standard")
    #>  [1] "Observation"         "Condition"           "Visit"              
    #>  [4] "Unit"                "Measurement"         "Spec Anatomic Site" 
    #>  [7] "Revenue Code"        "Meas Value Operator" "Specimen"           
    #> [10] "Route"               "Relationship"        "Currency"           
    #> [13] "Spec Disease Status" "Drug"                "Device"             
    #> [16] "Procedure"           "Meas Value"          "Gender"             
    #> [19] "Race"                "Provider"            "Metadata"           
    #> [22] "Ethnicity"

## Concept class

We can further explore the different classes that we have (reported in _concept_class_id_ column from the concept table):
    
    
    [getConceptClassId](../reference/getConceptClassId.html)(cdm)
    #>  [1] "2-dig nonbill code"   "3-dig billing code"   "3-dig nonbill code"  
    #>  [4] "4-dig billing code"   "Admitting Source"     "Answer"              
    #>  [7] "APC"                  "Attribute"            "Body Structure"      
    #> [10] "Branded Drug"         "Branded Drug Box"     "Branded Drug Comp"   
    #> [13] "Branded Drug Form"    "Branded Pack"         "Branded Pack Box"    
    #> [16] "Canonical Unit"       "Claims Attachment"    "Clinical Drug"       
    #> [19] "Clinical Drug Box"    "Clinical Drug Comp"   "Clinical Drug Form"  
    #> [22] "Clinical Finding"     "Clinical Observation" "Clinical Pack"       
    #> [25] "Clinical Pack Box"    "Context-dependent"    "CPT4"                
    #> [28] "CPT4 Hierarchy"       "CPT4 Modifier"        "Currency"            
    #> [31] "Device"               "Discharge Status"     "Disposition"         
    #> [34] "Doc Kind"             "Doc Role"             "Doc Setting"         
    #> [37] "Doc Subject Matter"   "Doc Type of Service"  "Dose Form"           
    #> [40] "Ethnicity"            "Event"                "Gemscript"           
    #> [43] "Gemscript THIN"       "Gender"               "HCPCS"               
    #> [46] "HCPCS Modifier"       "Ingredient"           "Lab Test"            
    #> [49] "Linkage Assertion"    "Location"             "Marketed Product"    
    #> [52] "MDC"                  "Morph Abnormality"    "MS-DRG"              
    #> [55] "Observable Entity"    "Observation"          "Organism"            
    #> [58] "Pharma/Biol Product"  "Physical Force"       "Physical Object"     
    #> [61] "Physician Specialty"  "Procedure"            "Provider"            
    #> [64] "Qualifier Value"      "Quant Branded Box"    "Quant Branded Drug"  
    #> [67] "Quant Clinical Box"   "Quant Clinical Drug"  "Race"                
    #> [70] "Relationship"         "Revenue Code"         "Social Context"      
    #> [73] "Specimen"             "Staging / Scales"     "Substance"           
    #> [76] "Survey"               "Unit"                 "Visit"

Or restrict the search among _non-standard_ concepts with _condition_ domain:
    
    
    [getConceptClassId](../reference/getConceptClassId.html)(cdm, 
                      standardConcept = "Non-standard", 
                      domain = "Condition")
    #>  [1] "3-char billing code"  "3-char nonbill code"  "3-dig billing code"  
    #>  [4] "3-dig billing E code" "3-dig billing V code" "3-dig nonbill code"  
    #>  [7] "3-dig nonbill E code" "3-dig nonbill V code" "4-char billing code" 
    #> [10] "4-char nonbill code"  "4-dig billing code"   "4-dig billing E code"
    #> [13] "4-dig billing V code" "4-dig nonbill code"   "4-dig nonbill V code"
    #> [16] "5-char billing code"  "5-char nonbill code"  "5-dig billing code"  
    #> [19] "5-dig billing V code" "6-char billing code"  "6-char nonbill code" 
    #> [22] "7-char billing code"  "Admin Concept"        "Clinical Finding"    
    #> [25] "Context-dependent"    "Event"                "ICD10 code"          
    #> [28] "ICD10 Hierarchy"      "ICD10 SubChapter"     "ICD9CM code"         
    #> [31] "Morph Abnormality"    "Navi Concept"         "Observable Entity"   
    #> [34] "Organism"             "OXMIS"                "Pharma/Biol Product" 
    #> [37] "Physical Object"      "Procedure"            "Qualifier Value"     
    #> [40] "Read"                 "SMQ"                  "Social Context"      
    #> [43] "Staging / Scales"     "Substance"

## Relationships

We can also explore the different relationships that are present in our CDM:
    
    
    [getRelationshipId](../reference/getRelationshipId.html)(cdm)
    #>  [1] "Asso finding of"   "Asso with finding" "Due to of"        
    #>  [4] "Finding asso with" "Followed by"       "Follows"          
    #>  [7] "Has asso finding"  "Has due to"        "Has manifestation"
    #> [10] "Is a"              "Manifestation of"  "Mapped from"      
    #> [13] "Maps to"           "Occurs after"      "Occurs before"    
    #> [16] "Subsumes"

Or narrow the search among _standard_ concepts with domain _observation_ :
    
    
    [getRelationshipId](../reference/getRelationshipId.html)(cdm,
                      standardConcept1 = "standard",
                      standardConcept2 = "standard",
                      domains1 = "observation",
                      domains2 = "observation")
    #>   [1] "Access of"            "Admin method of"      "Asso finding of"     
    #>   [4] "Asso morph of"        "Asso proc of"         "Asso with finding"   
    #>   [7] "Basic dose form of"   "Causative agent of"   "Characterizes"       
    #>  [10] "Clinical course of"   "Component of"         "Contained in panel"  
    #>  [13] "CPT4 - SNOMED cat"    "CPT4 - SNOMED eq"     "Dir morph of"        
    #>  [16] "Dir subst of"         "Disp dose form of"    "Dose form of"        
    #>  [19] "DRG - MDC cat"        "Due to of"            "Energy used by"      
    #>  [22] "Finding asso with"    "Finding context of"   "Finding inform of"   
    #>  [25] "Focus of"             "Has access"           "Has admin method"    
    #>  [28] "Has asso finding"     "Has asso morph"       "Has asso proc"       
    #>  [31] "Has basic dose form"  "Has causative agent"  "Has clinical course" 
    #>  [34] "Has component"        "Has dir morph"        "Has dir subst"       
    #>  [37] "Has disp dose form"   "Has dose form"        "Has due to"          
    #>  [40] "Has finding context"  "Has focus"            "Has intended site"   
    #>  [43] "Has intent"           "Has interprets"       "Has laterality"      
    #>  [46] "Has method"           "Has modification"     "Has occurrence"      
    #>  [49] "Has pathology"        "Has priority"         "Has proc context"    
    #>  [52] "Has proc duration"    "Has proc morph"       "Has process output"  
    #>  [55] "Has property"         "Has recipient cat"    "Has relat context"   
    #>  [58] "Has release charact"  "Has scale type"       "Has severity"        
    #>  [61] "Has spec active ing"  "Has state of matter"  "Has technique"       
    #>  [64] "Has temp finding"     "Has temporal context" "Has time aspect"     
    #>  [67] "Has transformation"   "Intended site of"     "Intent of"           
    #>  [70] "Interprets of"        "Is a"                 "Is characterized by" 
    #>  [73] "Laterality of"        "Mapped from"          "Maps to"             
    #>  [76] "Maps to value"        "MDC cat - DRG"        "Method of"           
    #>  [79] "Modification of"      "Occurrence of"        "Panel contains"      
    #>  [82] "Pathology of"         "Plays role"           "Priority of"         
    #>  [85] "Proc context of"      "Proc duration of"     "Proc morph of"       
    #>  [88] "Process output of"    "Property of"          "Recipient cat of"    
    #>  [91] "Relat context of"     "Relative to"          "Relative to of"      
    #>  [94] "Release charact of"   "Role played by"       "Scale type of"       
    #>  [97] "Severity of"          "SNOMED - CPT4 eq"     "SNOMED cat - CPT4"   
    #> [100] "Spec active ing of"   "State of matter of"   "Subst used by"       
    #> [103] "Subsumes"             "Technique of"         "Temp related to"     
    #> [106] "Temporal context of"  "Time aspect of"       "Transformation of"   
    #> [109] "Using energy"         "Using finding inform" "Using subst"         
    #> [112] "Value mapped from"

## Codes in use

Finally, we can easily get those codes that are in use (that means, that are recorded at least one time in the database):
    
    
    result <- [sourceCodesInUse](../reference/sourceCodesInUse.html)(cdm)
    [head](https://rdrr.io/r/utils/head.html)(result, n = 5) # Only the first 5 will be shown
    #> [1] 2615322 2615756 2615740 2614783 2615349

Notice that [achilles tables](https://github.com/OHDSI/Achilles) are used in this function. If you CDM does not have them loaded, an empty result will be returned.

And we can restrict the search within specific CDM tables (for example, _condition_occurrence_ and _device_exposure_ table):
    
    
    result <- [sourceCodesInUse](../reference/sourceCodesInUse.html)(cdm, table = [c](https://rdrr.io/r/base/c.html)("device_exposure", "condition_occurrence"))
    [head](https://rdrr.io/r/utils/head.html)(result, n = 5) # Only the first 5 will be shown
    #> [1] 44837444 44823465 44835527 44831602 44823910

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
