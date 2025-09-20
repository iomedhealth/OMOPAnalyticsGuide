# Format the result of summariseUnmappedCodeUse into a table — tableUnmappedCodes • CodelistGenerator

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

# Format the result of summariseUnmappedCodeUse into a table

`tableUnmappedCodes.Rd`

Format the result of summariseUnmappedCodeUse into a table

## Usage
    
    
    tableUnmappedCodes(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "estimate_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [character](https://rdrr.io/r/base/character.html)(),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A `<summarised_result>` with results of the type "umapped_codes".

type
    

Type of desired formatted table. To see supported formats use visOmopResults::tableType().

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The header vector can contain one of the following variables: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". Alternatively, it can include other names to use as overall header labels.

groupColumn
    

Variables to use as group labels. Allowed columns are: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". These cannot be used in header.

hide
    

Table columns to exclude, options are: "cdm_name", "codelist_name", "domain_id", "standard_concept_name", "standard_concept_id", "estimate_name", "standard_concept", "vocabulary_id". These cannot be used in header or groupColumn.

.options
    

Named list with additional formatting options. visOmopResults::tableOptions() shows allowed arguments and their default values.

## Value

A table with a formatted version of the summariseUnmappedCodes result.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [list](https://rdrr.io/r/base/list.html)("Musculoskeletal disorder" = 1)
    cdm <- omopgenerics::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "condition_occurrence",
    dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(person_id = 1,
                  condition_occurrence_id = 1,
                  condition_concept_id = 0,
                  condition_start_date  = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
                  condition_type_concept_id  = NA,
                  condition_source_concept_id = 7))
    unmapped_codes <- [summariseUnmappedCodes](summariseUnmappedCodes.html)(x = [list](https://rdrr.io/r/base/list.html)("osteoarthritis" = 2),
    cdm = cdm, table = "condition_occurrence")
    #> Warning: ! `codelist` casted to integers.
    #> Searching for unmapped codes related to osteoarthritis
    tableUnmappedCodes(unmapped_codes)
    
    
    
    
      
          | 
            Database name
          
          
    ---|---  
    
          | 
            mock
          
          
    Codelist name
          | Unmapped concept name
          | Unmapped concept ID
          | 
            Estimate name
          
          
    Record count
          
    osteoarthritis
    | Degenerative arthropathy
    | 7
    | 1  
      
    
    cdm <- omopgenerics::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(
     cdm,
     "measurement",
     dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
       person_id = 1,
       measurement_id = 1,
       measurement_concept_id = 0,
       measurement_date  = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
       measurement_type_concept_id  = NA,
       measurement_source_concept_id = 7
     )
    )
    table <- [summariseUnmappedCodes](summariseUnmappedCodes.html)(x = [list](https://rdrr.io/r/base/list.html)("cs" = 2),
                                   cdm = cdm,
                                   table = [c](https://rdrr.io/r/base/c.html)("measurement"))
    #> Warning: ! `codelist` casted to integers.
    #> Searching for unmapped codes related to cs
    tableUnmappedCodes(unmapped_codes)
    
    
    
    
      
          | 
            Database name
          
          
    ---|---  
    
          | 
            mock
          
          
    Codelist name
          | Unmapped concept name
          | Unmapped concept ID
          | 
            Estimate name
          
          
    Record count
          
    osteoarthritis
    | Degenerative arthropathy
    | 7
    | 1  
      
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
