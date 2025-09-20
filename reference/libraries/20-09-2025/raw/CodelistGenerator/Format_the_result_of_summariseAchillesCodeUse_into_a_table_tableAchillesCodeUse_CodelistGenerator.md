# Format the result of summariseAchillesCodeUse into a table — tableAchillesCodeUse • CodelistGenerator

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

# Format the result of summariseAchillesCodeUse into a table

`tableAchillesCodeUse.Rd`

Format the result of summariseAchillesCodeUse into a table

## Usage
    
    
    tableAchillesCodeUse(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "estimate_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [character](https://rdrr.io/r/base/character.html)(),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A `<summarised_result>` with results of the type "achilles_code_use".

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

A table with a formatted version of the summariseCohortCodeUse result.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    oa <- [getCandidateCodes](getCandidateCodes.html)(cdm = cdm, keywords = "osteoarthritis")
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    result_achilles <- [summariseAchillesCodeUse](summariseAchillesCodeUse.html)([list](https://rdrr.io/r/base/list.html)(oa = oa$concept_id), cdm = cdm)
    #> 
    tableAchillesCodeUse(result_achilles)
    
    
    
    
      
          | 
            Database name
          
          
    ---|---  
    
          | 
            mock
          
          
    Codelist name
          | Domain ID
          | Standard concept name
          | Standard concept ID
          | Standard concept
          | Vocabulary ID
          | 
            Estimate name
          
          
    Record count
          
    oa
    | condition
    | Osteoarthritis of knee
    | 4
    | standard
    | SNOMED
    | 400  
    
    | 
    | Osteoarthritis of hip
    | 5
    | standard
    | SNOMED
    | 200  
      
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
