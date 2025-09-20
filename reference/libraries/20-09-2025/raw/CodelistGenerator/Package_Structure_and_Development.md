# Page: Package Structure and Development

# Package Structure and Development

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.gitignore](.gitignore)
- [NAMESPACE](NAMESPACE)
- [R/tableUnmappedCodes.R](R/tableUnmappedCodes.R)
- [_pkgdown.yml](_pkgdown.yml)
- [cran-comments.md](cran-comments.md)

</details>



This document covers the internal architecture of the CodelistGenerator R package, including its modular organization, exported function structure, dependency relationships, and development setup. For information about specific functional capabilities, see the individual module documentation pages ([2](#2) through [7](#7)).

## Package Architecture Overview

The CodelistGenerator package is structured as a collection of specialized modules that work together to provide comprehensive codelist generation and analysis capabilities for OMOP CDM data. The package follows R packaging best practices with clear separation of concerns and well-defined interfaces.

### Package Module Structure

```mermaid
graph TB
    subgraph "CodelistGenerator Package"
        subgraph "Core Generation Module"
            getCandidateCodes["getCandidateCodes"]
            getDrugIngredientCodes["getDrugIngredientCodes"]
            getATCCodes["getATCCodes"]
            getICD10StandardCodes["getICD10StandardCodes"]
        end
        
        subgraph "Import/Export Module"
            codesFromCohort["codesFromCohort"]
            codesFromConceptSet["codesFromConceptSet"]
            exportCodelist["exportCodelist"]
            exportConceptSetExpression["exportConceptSetExpression"]
            importCodelist["importCodelist"]
            importConceptSetExpression["importConceptSetExpression"]
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
        
        subgraph "Manipulation Module"
            stratifyByConcept["stratifyByConcept"]
            stratifyByDoseUnit["stratifyByDoseUnit"]
            stratifyByRouteCategory["stratifyByRouteCategory"]
            subsetOnDomain["subsetOnDomain"]
            subsetOnDoseUnit["subsetOnDoseUnit"]
            subsetOnRouteCategory["subsetOnRouteCategory"]
            subsetToCodesInUse["subsetToCodesInUse"]
            compareCodelists["compareCodelists"]
            getMappings["getMappings"]
        end
        
        subgraph "Vocabulary Utils Module"
            getVocabVersion["getVocabVersion"]
            getVocabularies["getVocabularies"]
            getConceptClassId["getConceptClassId"]
            getDomains["getDomains"]
            getDescendants["getDescendants"]
            getDoseForm["getDoseForm"]
            getRouteCategories["getRouteCategories"]
            getDoseUnit["getDoseUnit"]
            getRelationshipId["getRelationshipId"]
            codesInUse["codesInUse"]
            sourceCodesInUse["sourceCodesInUse"]
            availableATC["availableATC"]
            availableICD10["availableICD10"]
            availableIngredients["availableIngredients"]
        end
        
        subgraph "Testing Utils Module"
            mockVocabRef["mockVocabRef"]
            buildAchillesTables["buildAchillesTables"]
        end
        
        subgraph "Data Structure Module"
            newCodelist["newCodelist"]
            newCodelistWithDetails["newCodelistWithDetails"]
            newConceptSetExpression["newConceptSetExpression"]
            cohortCodelist["cohortCodelist"]
        end
    end
```

**Package Module Organization**: The package exports 49 functions organized into 7 logical modules. Each module has a specific responsibility: generation creates new codelists, analysis summarizes usage patterns, presentation formats results, manipulation transforms existing codelists, vocabulary utilities provide OMOP vocabulary operations, testing utilities support development, and data structures provide object constructors.

Sources: [NAMESPACE:1-63](), [_pkgdown.yml:10-68]()

## Dependency Architecture

The CodelistGenerator package integrates with the broader DARWIN EU ecosystem through well-defined dependency relationships and import patterns.

### External Dependencies

```mermaid
graph LR
    subgraph "DARWIN EU Ecosystem"
        omopgenerics["omopgenerics"]
        CDMConnector["CDMConnector"]
        visOmopResults["visOmopResults"]
    end
    
    subgraph "R Core Ecosystem"
        rlang["rlang"]
        dplyr["dplyr"]
        stringr["stringr"]
        purrr["purrr"]
        cli["cli"]
    end
    
    subgraph "CodelistGenerator"
        DataStructures["Data Structure Functions"]
        ImportExport["Import/Export Functions"]
        Presentation["Presentation Functions"]
        CoreLogic["Core Logic Functions"]
    end
    
    omopgenerics --> DataStructures
    omopgenerics --> ImportExport
    visOmopResults --> Presentation
    CDMConnector --> CoreLogic
    
    rlang --> CoreLogic
    dplyr --> CoreLogic
    stringr --> Presentation
    purrr --> Presentation
    cli --> Presentation
```

**Dependency Structure**: The package imports 9 functions from `omopgenerics` for data structure compatibility, uses `:=`, `.data`, and `.env` from `rlang` for safe evaluation, and integrates with `visOmopResults` for table formatting. Database connectivity is provided through the broader ecosystem via `CDMConnector`.

Sources: [NAMESPACE:52-62](), [R/tableUnmappedCodes.R:57]()

### Function Import Pattern

| Package | Imported Functions | Purpose |
|---------|-------------------|---------|
| `omopgenerics` | `cohortCodelist`, `exportCodelist`, `exportConceptSetExpression`, `importCodelist`, `importConceptSetExpression`, `newCodelist`, `newCodelistWithDetails`, `newConceptSetExpression`, `sourceCodesInUse` | OMOP data structure compatibility |
| `rlang` | `:=`, `.data`, `.env` | Safe non-standard evaluation |
| `visOmopResults` | (conditional) | Table formatting and presentation |

Sources: [NAMESPACE:52-62](), [R/tableUnmappedCodes.R:57]()

## Exported Function Organization

The package exports are organized following a systematic functional grouping that reflects the package's modular architecture.

### Export Categories

```mermaid
graph TD
    subgraph "Generation Exports"
        getCandidateCodes_export["getCandidateCodes"]
        getDrugIngredientCodes_export["getDrugIngredientCodes"]
        getATCCodes_export["getATCCodes"]
        getICD10StandardCodes_export["getICD10StandardCodes"]
    end
    
    subgraph "Analysis Exports"
        summariseCodeUse_export["summariseCodeUse"]
        summariseAchillesCodeUse_export["summariseAchillesCodeUse"]
        summariseCohortCodeUse_export["summariseCohortCodeUse"]
        summariseOrphanCodes_export["summariseOrphanCodes"]
        summariseUnmappedCodes_export["summariseUnmappedCodes"]
    end
    
    subgraph "Presentation Exports"
        tableCodeUse_export["tableCodeUse"]
        tableAchillesCodeUse_export["tableAchillesCodeUse"]
        tableCohortCodeUse_export["tableCohortCodeUse"]
        tableOrphanCodes_export["tableOrphanCodes"]
        tableUnmappedCodes_export["tableUnmappedCodes"]
    end
    
    subgraph "Manipulation Exports"
        stratifyByConcept_export["stratifyByConcept"]
        stratifyByDoseUnit_export["stratifyByDoseUnit"]
        stratifyByRouteCategory_export["stratifyByRouteCategory"]
        subsetOnDomain_export["subsetOnDomain"]
        subsetOnDoseUnit_export["subsetOnDoseUnit"]
        subsetOnRouteCategory_export["subsetOnRouteCategory"]
        subsetToCodesInUse_export["subsetToCodesInUse"]
        compareCodelists_export["compareCodelists"]
        getMappings_export["getMappings"]
    end
    
    subgraph "Vocabulary Exports"
        getVocabularies_export["getVocabularies"]
        getDomains_export["getDomains"]
        getConceptClassId_export["getConceptClassId"]
        getRelationshipId_export["getRelationshipId"]
        getDescendants_export["getDescendants"]
        availableATC_export["availableATC"]
        availableICD10_export["availableICD10"]
        availableIngredients_export["availableIngredients"]
        codesInUse_export["codesInUse"]
    end
    
    subgraph "Utility Exports"
        mockVocabRef_export["mockVocabRef"]
        buildAchillesTables_export["buildAchillesTables"]
        newCodelist_export["newCodelist"]
        newCodelistWithDetails_export["newCodelistWithDetails"]
        newConceptSetExpression_export["newConceptSetExpression"]
    end
```

**Export Organization**: The 49 exported functions follow a consistent naming pattern where analysis functions use `summarise*` prefix, presentation functions use `table*` prefix, manipulation functions use `stratify*` or `subset*` prefixes, and utility functions have descriptive names. This creates a predictable API surface.

Sources: [NAMESPACE:3-51](), [_pkgdown.yml:11-67]()

## Development Structure

The package follows standard R package development practices with additional configurations for CRAN submission and continuous integration.

### Development File Structure

```mermaid
graph TB
    subgraph "Package Root"
        NAMESPACE_file["NAMESPACE"]
        DESCRIPTION_file["DESCRIPTION"]
        pkgdown_yml["_pkgdown.yml"]
        gitignore_file[".gitignore"]
        cran_comments["cran-comments.md"]
    end
    
    subgraph "R Source Directory"
        function_files["Function Implementation Files"]
        internal_functions["Internal Helper Functions"]
        documentation["Roxygen2 Documentation"]
    end
    
    subgraph "Development Artifacts"
        docs_dir["docs/ (ignored)"]
        inst_doc["inst/doc (ignored)"]
        test_databases["Test SQLite Files (ignored)"]
        jar_files["JDBC JAR Files (ignored)"]
        extra_files["extras/ Directory"]
    end
    
    subgraph "Testing Infrastructure"
        testthat_dir["tests/testthat/"]
        mock_vocab["Mock Vocabulary Data"]
        test_utilities["Test Helper Functions"]
    end
    
    NAMESPACE_file --> function_files
    pkgdown_yml --> documentation
    gitignore_file --> docs_dir
    gitignore_file --> test_databases
    gitignore_file --> jar_files
```

**Development Configuration**: The package uses `roxygen2` for documentation generation, `pkgdown` for website generation, and maintains CRAN-ready structure. Development artifacts like documentation builds, test databases, and JDBC drivers are excluded from version control.

Sources: [.gitignore:1-23](), [_pkgdown.yml:1-68](), [cran-comments.md:1-4]()

### Testing and Mock Data Strategy

The package includes comprehensive testing infrastructure with mock vocabulary references for development and testing without requiring full OMOP CDM database access.

| Component | Purpose | Files |
|-----------|---------|-------|
| `mockVocabRef` | Creates mock vocabulary tables for testing | Exported function |
| `buildAchillesTables` | Creates Achilles tables for testing | Exported function |
| Test SQLite files | Local test databases (ignored in git) | `vocab.sqlite`, `db.sqlite` |
| JDBC drivers | Database connectivity for integration tests | `*.jar` files (ignored) |

**Mock Data Architecture**: The `mockVocabRef` and `buildAchillesTables` functions provide complete mock OMOP vocabulary and Achilles table structures, enabling comprehensive testing without requiring access to real OMOP CDM databases. This supports both unit testing and development workflows.

Sources: [NAMESPACE:30](), [NAMESPACE:6](), [.gitignore:4-6](), [.gitignore:13-14]()