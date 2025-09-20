# Page: Testing and Reverse Dependencies

# Testing and Reverse Dependencies

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [cran-comments.md](cran-comments.md)
- [inst/CITATION](inst/CITATION)
- [revdep/.gitignore](revdep/.gitignore)
- [revdep/README.md](revdep/README.md)
- [revdep/cran.md](revdep/cran.md)
- [revdep/failures.md](revdep/failures.md)
- [revdep/problems.md](revdep/problems.md)
- [tests/testthat/test-mockObservationPeriod.R](tests/testthat/test-mockObservationPeriod.R)
- [tests/testthat/test-mockPerson.R](tests/testthat/test-mockPerson.R)

</details>



This page documents the testing infrastructure, reverse dependency management, and CRAN submission process for the omock package. It covers the test suite organization, automated reverse dependency checking workflows, and the current status of dependent packages in the OHDSI ecosystem.

For information about the CI/CD workflows and package validation processes, see [Package Development Workflow](#8.1).

## Test Suite Architecture

The omock package uses the `testthat` framework for comprehensive unit testing. The test suite is organized around individual mock generation functions, with emphasis on reproducibility, input validation, and OMOP CDM compliance.

```mermaid
graph TD
    subgraph "Test Organization"
        A["test-mockPerson.R"]
        B["test-mockObservationPeriod.R"]  
        C["test-mockDrugExposure.R"]
        D["test-mockCohort.R"]
        E["test-mockDatasets.R"]
        F["Additional Test Files"]
    end
    
    subgraph "Test Categories"
        G["Functionality Tests"]
        H["Input Validation Tests"]
        I["Seed Reproducibility Tests"]
        J["Data Quality Tests"]
        K["OMOP Compliance Tests"]
    end
    
    subgraph "Test Infrastructure"
        L["testthat Framework"]
        M["expect_no_error()"]
        N["expect_equal()"]
        O["expect_error()"]
        P["dplyr Validation Chains"]
    end
    
    A --> G
    B --> G
    C --> G
    D --> G
    E --> G
    F --> G
    
    G --> L
    H --> L
    I --> L
    J --> L
    K --> L
    
    L --> M
    L --> N
    L --> O
    L --> P
```

Sources: [tests/testthat/test-mockPerson.R:1-99](), [tests/testthat/test-mockObservationPeriod.R:1-42]()

## Test Patterns and Validation Strategies

The test suite follows consistent patterns across all mock generation functions, emphasizing data integrity and reproducible behavior.

| Test Pattern | Purpose | Example Implementation |
|--------------|---------|----------------------|
| Basic Functionality | Verify core function behavior | `expect_no_error()` with parameter validation |
| Input Validation | Test parameter boundary conditions | Error checking for invalid `nPerson`, `birthRange` |
| Seed Reproducibility | Ensure deterministic output | Compare outputs with same seed values |
| OMOP Compliance | Validate CDM table structure | Check column names against `omopgenerics::omopColumns()` |
| Data Relationships | Verify table linkages | Validate foreign key consistency between tables |

```mermaid
flowchart TD
    subgraph "mockPerson Test Flow"
        A["emptyCdmReference()"] --> B["mockPerson()"]
        B --> C["Validate nPerson Count"]
        B --> D["Check OMOP Columns"]
        B --> E["Verify Birth Date Range"]
        B --> F["Test Gender Distribution"]
        B --> G["Error Condition Tests"]
    end
    
    subgraph "Seed Testing Pattern"
        H["Generate CDM with seed=1"] --> I["Generate CDM without seed"]
        I --> J["Generate CDM with seed=1 again"]
        J --> K["expect_equal(cdm1, cdm3)"]
        K --> L["expect_error(expect_equal(cdm1, cdm2))"]
    end
    
    subgraph "Validation Checks"
        M["omopgenerics::omopColumns()"] --> N["Column Name Validation"]
        O["dplyr::distinct()"] --> P["Record Count Validation"]
        Q["Date Range Logic"] --> R["Birth Date Validation"]
    end
    
    C --> M
    D --> N
    E --> Q
    F --> O
```

Sources: [tests/testthat/test-mockPerson.R:88-98](), [tests/testthat/test-mockObservationPeriod.R:28-41]()

## Reverse Dependency Management

The omock package uses `revdepcheck` to monitor its impact on downstream packages in the OHDSI ecosystem. This automated process checks 9 reverse dependencies to ensure package updates don't break dependent functionality.

```mermaid
graph LR
    subgraph "omock Reverse Dependencies"
        A["omock"] --> B["CodelistGenerator"]
        A --> C["CohortConstructor"] 
        A --> D["PhenotypeR"]
        A --> E["IncidencePrevalence"]
        A --> F["CohortCharacteristics"]
        A --> G["DrugUtilisation"]
        A --> H["TreatmentPatterns"]
        A --> I["PatientProfiles"]
        A --> J["Additional OHDSI Packages"]
    end
    
    subgraph "Check Status"
        K["Successfully Checked: 6"]
        L["Failed to Check: 3"]
        M["New Problems: 0"]
    end
    
    B --> L
    C --> L  
    D --> L
    E --> K
    F --> K
    G --> K
    H --> K
    I --> K
    J --> K
    
    K --> M
    L --> N["Timeout Issues"]
```

Sources: [revdep/cran.md:1-15](), [revdep/README.md:63-73]()

## Reverse Dependency Check Results

The latest reverse dependency check shows a clean status with no new problems introduced by omock updates.

| Package | Version | Status | Issues |
|---------|---------|--------|--------|
| CodelistGenerator | 3.5.0 | Failed | R CMD check timeout |
| CohortConstructor | 0.5.0 | Failed | R CMD check timeout |
| PhenotypeR | 0.2.0 | Failed | R CMD check timeout |
| IncidencePrevalence | Latest | Passed | None |
| CohortCharacteristics | Latest | Passed | None |
| DrugUtilisation | Latest | Passed | None |

```mermaid
flowchart TD
    subgraph "Reverse Dependency Check Process"
        A["revdepcheck::revdep_check()"] --> B["Platform: R 4.3.1 Windows 11"]
        B --> C["Check 9 Packages"]
        C --> D["6 Successful Checks"]
        C --> E["3 Timeout Failures"]
        
        D --> F["No New Problems"]
        E --> G["Infrastructure Issues"]
        G --> H["Not omock-related"]
    end
    
    subgraph "Check Environment"
        I["Windows 11 x64"]
        J["RStudio 2024.12.0"]
        K["English_United Kingdom.utf8"]
        L["Europe/London TZ"]
    end
    
    B --> I
    B --> J
    B --> K
    B --> L
```

Sources: [revdep/README.md:1-17](), [revdep/failures.md:17-70](), [revdep/problems.md:1-1]()

## CRAN Submission Status

The omock package maintains clean CRAN submission status with minimal notes and no errors or warnings.

```mermaid
graph TD
    subgraph "CRAN Check Results"
        A["R CMD check"] --> B["0 errors"]
        A --> C["0 warnings"] 
        A --> D["1 note"]
        
        D --> E["This is a new release"]
    end
    
    subgraph "Package Metadata"
        F["Version: 0.4.0.9000"]
        G["CRAN Status: Clean"]
        H["Citation: DOI 10.32614/CRAN.package.omock"]
    end
    
    B --> G
    C --> G
    E --> G
    
    G --> F
    G --> H
```

Sources: [cran-comments.md:1-6](), [revdep/README.md:20-22](), [inst/CITATION:1-11]()

## Testing Infrastructure Dependencies

The testing ecosystem relies on several key dependencies that ensure comprehensive validation and reproducible test execution.

| Dependency | Version | Purpose |
|------------|---------|---------|
| testthat | Latest | Unit testing framework |
| omopgenerics | 1.3.0 | OMOP CDM compliance validation |
| dplyr | 1.1.4 | Data manipulation in tests |
| rlang | 1.1.5 | Expression evaluation |
| revdepcheck | Latest | Reverse dependency monitoring |

```mermaid
flowchart LR
    subgraph "Core Testing Dependencies"
        A["testthat"] --> B["Unit Test Framework"]
        C["omopgenerics"] --> D["OMOP Validation"]
        E["dplyr"] --> F["Data Verification"]
        G["rlang"] --> H["Expression Handling"]
    end
    
    subgraph "Development Dependencies" 
        I["revdepcheck"] --> J["Reverse Dependency Monitoring"]
        K["pkgdown"] --> L["Documentation Testing"]
        M["covr"] --> N["Code Coverage Analysis"]
    end
    
    subgraph "Test Execution"
        O["R CMD check"] --> P["Package Validation"]
        Q["GitHub Actions"] --> R["Continuous Integration"]
    end
    
    B --> O
    D --> O
    F --> O
    H --> O
    
    J --> Q
    L --> Q
    N --> Q
```

Sources: [revdep/README.md:18-62]()