# Page: Core Mock Data Generation

# Core Mock Data Generation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/mockObservationPeriod.R](R/mockObservationPeriod.R)
- [R/mockPerson.R](R/mockPerson.R)
- [man/mockCohort.Rd](man/mockCohort.Rd)
- [man/mockObservationPeriod.Rd](man/mockObservationPeriod.Rd)
- [man/mockPerson.Rd](man/mockPerson.Rd)
- [paper/code.Rmd](paper/code.Rmd)
- [paper/paper.bib](paper/paper.bib)
- [paper/paper.md](paper/paper.md)

</details>



This document covers the primary workflows and functions for generating mock OMOP CDM data in omock. It provides a comprehensive overview of the two main generation approaches: population-based generation and table-based generation. For specific details about generating basic CDM tables, see [Basic CDM Tables](#3.1). For clinical event table generation, see [Clinical Event Tables](#3.2). For cohort generation specifics, see [Cohort Generation](#3.3).

## Generation Approaches Overview

The omock package provides two primary approaches for creating mock OMOP CDM data, each designed for different use cases and testing scenarios.

### Population-Based Generation Workflow

This approach allows users to specify population characteristics and generates a complete CDM from demographic parameters.

```mermaid
flowchart TD
    A["mockCdmReference()"] --> B["mockVocabularyTables()"]
    B --> C["mockPerson()"]
    C --> D["mockObservationPeriod()"]
    D --> E["mockConditionOccurrence()"]
    D --> F["mockDrugExposure()"]
    D --> G["mockMeasurement()"]
    D --> H["mockObservation()"]
    D --> I["mockCohort()"]
    
    C --> J["person table<br/>with demographics"]
    D --> K["observation_period table<br/>based on birth dates"]
    E --> L["condition_occurrence table"]
    F --> M["drug_exposure table"]
    G --> N["measurement table"]
    H --> O["observation table"]
    I --> P["cohort tables"]
    
    J --> Q["cdm_reference object"]
    K --> Q
    L --> Q
    M --> Q
    N --> Q
    O --> Q
    P --> Q
```

Sources: [paper/paper.md:78-97](), [R/mockPerson.R:39-106](), [R/mockObservationPeriod.R:28-96]()

### Table-Based Generation Workflow

This approach takes user-provided tables and generates supporting CDM structure automatically.

```mermaid
flowchart TD
    A["User Tables<br/>(tibble format)"] --> B["mockCdmFromTables()"]
    B --> C["Extract person_id values"]
    C --> D["Generate person table<br/>for extracted IDs"]
    C --> E["Generate observation_period table<br/>for extracted IDs"]
    B --> F["mockCdmReference()<br/>(if no base CDM)"]
    F --> G["mockVocabularyTables()"]
    
    D --> H["Integrated CDM<br/>with custom tables"]
    E --> H
    G --> H
    A --> H
    
    I["Existing CDM<br/>(optional)"] --> B
    I --> J["Table Overwrite<br/>with warning"]
    J --> H
```

Sources: [paper/paper.md:143-189](), [paper/code.Rmd:39-58]()

## Core Generation Functions Architecture

The generation system is built around a modular architecture where each function adds specific table types to the CDM reference.

```mermaid
graph TB
    subgraph "CDM Initialization"
        A["mockCdmReference()"]
        B["vocabularySet parameter"]
        C["cdmName parameter"]
    end
    
    subgraph "Basic Tables Generation"
        D["mockPerson()<br/>R/mockPerson.R"]
        E["mockObservationPeriod()<br/>R/mockObservationPeriod.R"]
    end
    
    subgraph "Clinical Tables Generation"
        F["mockConditionOccurrence()"]
        G["mockDrugExposure()"]
        H["mockMeasurement()"]
        I["mockObservation()"]
    end
    
    subgraph "Cohort Generation"
        J["mockCohort()<br/>R/mockCohort.R"]
    end
    
    subgraph "Custom Table Integration"
        K["mockCdmFromTables()"]
    end
    
    subgraph "Validation System"
        L["checkInput()<br/>R/checks.R"]
        M["correctCdmFormat()"]
        N["addOtherColumns()"]
    end
    
    A --> D
    B --> A
    C --> A
    D --> E
    E --> F
    E --> G
    E --> H
    E --> I
    E --> J
    
    K --> D
    K --> E
    
    L --> D
    L --> E
    L --> F
    L --> G
    L --> H
    L --> I
    L --> J
    L --> K
    
    M --> D
    M --> E
    N --> D
    N --> E
```

Sources: [paper/paper.md:78-97](), [R/mockPerson.R:44-51](), [R/mockObservationPeriod.R:30]()

## Data Flow and Dependencies

The generation process follows strict dependencies to ensure OMOP CDM compliance and referential integrity.

### Population-Based Generation Data Flow

| Function | Dependencies | Outputs | Key Parameters |
|----------|-------------|---------|----------------|
| `mockCdmReference()` | None | Empty CDM with vocabulary | `cdmName`, `vocabularySet` |
| `mockPerson()` | Empty CDM | `person` table | `nPerson`, `birthRange`, `proportionFemale` |
| `mockObservationPeriod()` | `person` table | `observation_period` table | `seed` |
| Clinical table functions | `person`, `observation_period` | Clinical tables | Varies by function |
| `mockCohort()` | `person`, `observation_period` | Cohort tables | `numberCohorts`, `recordPerson` |

Sources: [man/mockPerson.Rd:6-36](), [man/mockObservationPeriod.Rd:9-16](), [man/mockCohort.Rd:16-44]()

### Table-Based Generation Data Flow

```mermaid
sequenceDiagram
    participant U as "User Tables"
    participant F as "mockCdmFromTables()"
    participant P as "Person ID Extraction"
    participant G as "Table Generation"
    participant V as "Validation"
    participant C as "CDM Assembly"
    
    U->>F: "Provide custom tables<br/>(tibble format)"
    F->>P: "Extract person_id values"
    P->>G: "Generate person table<br/>for extracted IDs"
    P->>G: "Generate observation_period<br/>for extracted IDs"
    G->>V: "Apply correctCdmFormat()"
    G->>V: "Apply addOtherColumns()"
    V->>C: "Integrate with vocabulary tables"
    C->>F: "Return complete CDM object"
```

Sources: [paper/paper.md:143-150]()

## Random Generation and Reproducibility

The generation system uses controlled randomization to ensure realistic but reproducible data.

### Seed Management

All generation functions accept a `seed` parameter for reproducibility:

- **Person Generation**: Controls birth date distribution and gender assignment [R/mockPerson.R:53-55]()
- **Observation Period Generation**: Controls start/end date randomization [R/mockObservationPeriod.R:37-39]()
- **Clinical Table Generation**: Controls event timing and concept assignments

### Date Generation Logic

The observation period generation uses a two-stage randomization process:

1. **Start Date**: Random point between birth date and maximum observation date [R/mockObservationPeriod.R:104-105]()
2. **End Date**: Random point between start date and maximum observation date [R/mockObservationPeriod.R:106-107]()

This ensures realistic observation periods that respect individual lifecycles while maintaining temporal consistency across the CDM.

Sources: [R/mockObservationPeriod.R:102-110]()

## Integration with OMOP Standards

The generation system ensures OMOP CDM compliance through several mechanisms:

### Format Standardization

Each generated table undergoes standardization:
- `correctCdmFormat()` ensures proper column types and constraints
- `addOtherColumns()` adds required OMOP columns not explicitly generated
- Integration with `omopgenerics` package for CDM reference validation

### Vocabulary Integration

The system supports multiple vocabulary sets:
- **Mock vocabularies**: Simplified concept sets for basic testing
- **Eunomia vocabularies**: More complete vocabulary from the Eunomia dataset
- Custom vocabulary integration through the `vocabularySet` parameter

Sources: [R/mockPerson.R:89-90](), [R/mockObservationPeriod.R:83-84](), [paper/paper.md:64-65]()