# Page: Package Architecture

# Package Architecture

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [R/tableUnmappedCodes.R](R/tableUnmappedCodes.R)
- [_pkgdown.yml](_pkgdown.yml)
- [cran-comments.md](cran-comments.md)

</details>



This document provides a comprehensive overview of the CodelistGenerator R package structure, including its modular organization, exported functions, dependency relationships, and internal architecture. It covers the package's 51 exported functions organized into 8 functional modules, dependency management through `omopgenerics` and other packages, and the overall design patterns used throughout the codebase.

For information about specific functionality within each module, see the related pages: [Core Codelist Generation](#2), [Codelist Analysis and Usage](#3), [Codelist Manipulation](#4), [Data Import and Export](#5), and [Vocabulary Utilities](#6).

## Package Structure Overview

The CodelistGenerator package is organized into distinct functional modules that work together to provide comprehensive OMOP CDM codelist generation and analysis capabilities.

### Core Module Architecture

```mermaid
graph TB
    subgraph "CodelistGenerator Package"
        subgraph "Generation Module"
            getCandidateCodes["getCandidateCodes"]
            getDrugIngredientCodes["getDrugIngredientCodes"]
            getATCCodes["getATCCodes"]
            getICD10StandardCodes["getICD10StandardCodes"]
        end
        
        subgraph "Analysis Module"
            summariseCodeUse["summariseCodeUse"]
            summariseAchillesCodeUse["summariseAchillesCodeUse"]
            summariseCohortCodeUse["summariseCohortCodeUse"]
            summariseOrphanCodes["summariseOrphanCodes"]
            summariseUnmappedCodes["summariseUnmappedCodes"]
        end
        
        subgraph "Presentation Module"
            tableCodeUse["tableCodeUse"]
            tableAchillesCodeUse["tableAchillesCodeUse"]
            tableCohortCodeUse["tableCohortCodeUse"]
            tableOrphanCodes["tableOrphanCodes"]
            tableUnmappedCodes["tableUnmappedCodes"]
        end
        
        subgraph "Import/Export Module"
            codesFromCohort["codesFromCohort"]
            codesFromConceptSet["codesFromConceptSet"]
            exportCodelist["exportCodelist"]
            exportConceptSetExpression["exportConceptSetExpression"]
            importCodelist["importCodelist"]
            importConceptSetExpression["importConceptSetExpression"]
        end
        
        subgraph "Manipulation Module"
            stratifyByConcept["stratifyByConcept"]
            stratifyByDoseUnit["stratifyByDoseUnit"]
            stratifyByRouteCategory["stratifyByRouteCategory"]
            subsetOnDomain["subsetOnDomain"]
            subsetOnDoseUnit["subsetOnDoseUnit"]
            subsetOnRouteCategory["subsetOnRouteCategory"]
            subsetToCodesInUse["subsetToCodesInUse"]
            compareCodelists["compareCodelists"]
        end
        
        subgraph "Vocabulary Module"
            getVocabularies["getVocabularies"]
            getDomains["getDomains"]
            getConceptClassId["getConceptClassId"]
            getDescendants["getDescendants"]
            getMappings["getMappings"]
            getRelationshipId["getRelationshipId"]
            getDoseForm["getDoseForm"]
            getDoseUnit["getDoseUnit"]
            getRouteCategories["getRouteCategories"]
            getVocabVersion["getVocabVersion"]
        end
        
        subgraph "Utility Module"
            codesInUse["codesInUse"]
            sourceCodesInUse["sourceCodesInUse"]
            availableATC["availableATC"]
            availableICD10["availableICD10"]
            availableIngredients["availableIngredients"]
        end
        
        subgraph "Testing Module"
            mockVocabRef["mockVocabRef"]
            buildAchillesTables["buildAchillesTables"]
        end
        
        subgraph "Constructor Module"
            newCodelist["newCodelist"]
            newCodelistWithDetails["newCodelistWithDetails"]
            newConceptSetExpression["newConceptSetExpression"]
            cohortCodelist["cohortCodelist"]
        end
    end
```

Sources: [NAMESPACE:1-63](), [_pkgdown.yml:10-68]()

## Exported Function Organization

The package exports 51 functions organized into logical groupings that reflect different stages of the codelist workflow.

### Function Export Breakdown

| Module | Function Count | Primary Purpose |
|--------|----------------|-----------------|
| Generation | 4 | Create new codelists from vocabulary searches |
| Analysis | 5 | Analyze code usage patterns in CDM data |
| Presentation | 5 | Format analysis results into tables |
| Import/Export | 6 | Handle JSON concept sets and codelist serialization |
| Manipulation | 8 | Transform and filter existing codelists |
| Vocabulary | 10 | Explore vocabulary structure and relationships |
| Utility | 5 | Support functions for code availability and usage |
| Testing | 2 | Mock data generation for development |
| Constructor | 4 | Create standardized data objects |
| Other | 2 | Additional exported functions |

### Function Dependencies by Category

```mermaid
graph LR
    subgraph "External Dependencies"
        omopgenerics["omopgenerics"]
        rlang["rlang"]
        visOmopResults["visOmopResults"]
    end
    
    subgraph "Core Functions"
        generation["Generation Functions"]
        vocabulary["Vocabulary Functions"]
        analysis["Analysis Functions"]
        manipulation["Manipulation Functions"]
    end
    
    subgraph "Interface Functions"
        import_export["Import/Export Functions"]
        presentation["Presentation Functions"]
        constructors["Constructor Functions"]
    end
    
    subgraph "Support Functions"
        utility["Utility Functions"]
        testing["Testing Functions"]
    end
    
    omopgenerics --> constructors
    omopgenerics --> import_export
    rlang --> generation
    rlang --> analysis
    rlang --> manipulation
    visOmopResults --> presentation
    
    vocabulary --> generation
    vocabulary --> analysis
    vocabulary --> manipulation
    generation --> analysis
    analysis --> presentation
    constructors --> generation
    constructors --> manipulation
    utility --> generation
    utility --> analysis
    testing --> vocabulary
```

Sources: [NAMESPACE:3-51](), [NAMESPACE:52-62](), [R/tableUnmappedCodes.R:57]()

## Dependency Architecture

The package follows a layered dependency architecture with external packages providing foundational capabilities and internal modules building upon each other.

### External Package Dependencies

```mermaid
graph TB
    subgraph "External R Packages"
        omopgenerics_ext["omopgenerics<br/>Data structures & generics"]
        rlang_ext["rlang<br/>Language utilities"]
        visOmopResults_ext["visOmopResults<br/>Table formatting"]
        CDMConnector_ext["CDMConnector<br/>Database connectivity"]
        cli_ext["cli<br/>User interface"]
        dplyr_ext["dplyr<br/>Data manipulation"]
        stringr_ext["stringr<br/>String processing"]
        purrr_ext["purrr<br/>Functional programming"]
    end
    
    subgraph "CodelistGenerator Imports"
        imported_generics["Imported from omopgenerics:<br/>cohortCodelist<br/>exportCodelist<br/>exportConceptSetExpression<br/>importCodelist<br/>importConceptSetExpression<br/>newCodelist<br/>newCodelistWithDetails<br/>newConceptSetExpression"]
        imported_rlang["Imported from rlang:<br/>:=<br/>.data<br/>.env"]
    end
    
    subgraph "Runtime Dependencies"
        conditional_vis["visOmopResults<br/>(checked at runtime)"]
    end
    
    omopgenerics_ext --> imported_generics
    rlang_ext --> imported_rlang
    visOmopResults_ext --> conditional_vis
```

Sources: [NAMESPACE:52-62](), [R/tableUnmappedCodes.R:57]()

### Internal Module Dependencies

The internal architecture follows a clear hierarchy where lower-level modules provide services to higher-level ones.

```mermaid
graph TB
    subgraph "Foundation Layer"
        vocabulary_internal["Vocabulary Functions<br/>getVocabularies<br/>getDomains<br/>getConceptClassId"]
        utility_internal["Utility Functions<br/>codesInUse<br/>sourceCodesInUse"]
        constructors_internal["Constructor Functions<br/>newCodelist<br/>newCodelistWithDetails"]
    end
    
    subgraph "Core Logic Layer"
        generation_internal["Generation Functions<br/>getCandidateCodes<br/>getDrugIngredientCodes<br/>getATCCodes"]
        manipulation_internal["Manipulation Functions<br/>stratifyByConcept<br/>subsetOnDomain"]
    end
    
    subgraph "Analysis Layer"
        analysis_internal["Analysis Functions<br/>summariseCodeUse<br/>summariseAchillesCodeUse"]
    end
    
    subgraph "Presentation Layer"
        presentation_internal["Presentation Functions<br/>tableCodeUse<br/>tableAchillesCodeUse"]
        export_internal["Export Functions<br/>exportCodelist<br/>exportConceptSetExpression"]
    end
    
    vocabulary_internal --> generation_internal
    vocabulary_internal --> manipulation_internal
    utility_internal --> analysis_internal
    constructors_internal --> generation_internal
    constructors_internal --> manipulation_internal
    generation_internal --> analysis_internal
    manipulation_internal --> analysis_internal
    analysis_internal --> presentation_internal
    analysis_internal --> export_internal
```

Sources: [NAMESPACE:3-51](), [_pkgdown.yml:11-68]()

## Package Documentation Structure

The package documentation is organized to reflect the functional architecture, with clear groupings that help users understand the workflow from generation to analysis to presentation.

### Documentation Organization

| Documentation Group | Functions Included | Purpose |
|---------------------|-------------------|---------|
| Search for codes | `getCandidateCodes` | Systematic vocabulary searching |
| Create vocabulary-based codelists | `getDrugIngredientCodes`, `getATCCodes`, `getICD10StandardCodes` | Specialized codelist generation |
| Run codelist diagnostics | `summariseAchillesCodeUse`, `summariseCodeUse`, `summariseCohortCodeUse`, `summariseOrphanCodes`, `summariseUnmappedCodes` | Usage analysis and validation |
| Present diagnostics in tables | `tableAchillesCodeUse`, `tableCodeUse`, `tableCohortCodeUse`, `tableOrphanCodes`, `tableUnmappedCodes` | Formatted output generation |
| Extract from JSON files | `codesFromCohort`, `codesFromConceptSet` | External data integration |
| Codelist utilities | `compareCodelists`, `subsetToCodesInUse`, `stratifyByRouteCategory`, etc. | Codelist manipulation |
| Vocabulary utilities | `getVocabVersion`, `getVocabularies`, `getDomains`, etc. | Vocabulary exploration |
| Mock dataset creation | `mockVocabRef`, `buildAchillesTables` | Testing and development |

Sources: [_pkgdown.yml:11-68]()

## Design Patterns and Conventions

The package follows consistent design patterns that enhance maintainability and user experience.

### Function Naming Conventions

```mermaid
graph LR
    subgraph "Function Naming Patterns"
        get_pattern["get* Functions<br/>Retrieve data from CDM<br/>getCandidateCodes<br/>getDrugIngredientCodes<br/>getATCCodes"]
        
        summarise_pattern["summarise* Functions<br/>Analyze code usage<br/>summariseCodeUse<br/>summariseAchillesCodeUse<br/>summariseOrphanCodes"]
        
        table_pattern["table* Functions<br/>Format results<br/>tableCodeUse<br/>tableAchillesCodeUse<br/>tableOrphanCodes"]
        
        codes_pattern["codes* Functions<br/>Extract from external<br/>codesFromCohort<br/>codesFromConceptSet<br/>codesInUse"]
        
        subset_pattern["subset* Functions<br/>Filter codelists<br/>subsetOnDomain<br/>subsetOnDoseUnit<br/>subsetToCodesInUse"]
        
        stratify_pattern["stratify* Functions<br/>Split codelists<br/>stratifyByConcept<br/>stratifyByDoseUnit<br/>stratifyByRouteCategory"]
    end
```

Sources: [NAMESPACE:3-51]()

### Object Construction Pattern

The package leverages `omopgenerics` for standardized object construction, ensuring consistency with the broader OMOP ecosystem.

```mermaid
graph TB
    subgraph "Object Construction Flow"
        raw_data["Raw CDM Data"]
        internal_processing["Internal Processing"]
        generic_constructors["omopgenerics Constructors<br/>newCodelist<br/>newCodelistWithDetails<br/>newConceptSetExpression"]
        standardized_objects["Standardized Objects<br/>codelist<br/>codelist_with_details<br/>concept_set_expression"]
    end
    
    raw_data --> internal_processing
    internal_processing --> generic_constructors
    generic_constructors --> standardized_objects
```

Sources: [NAMESPACE:52-59]()

This architecture ensures that CodelistGenerator integrates seamlessly with other packages in the DARWIN EU ecosystem while maintaining clear separation of concerns and consistent user interfaces across all functionality.