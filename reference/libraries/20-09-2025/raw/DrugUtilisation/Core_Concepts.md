# Page: Core Concepts

# Core Concepts

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.Rbuildignore](.Rbuildignore)
- [CRAN-SUBMISSION](CRAN-SUBMISSION)
- [DESCRIPTION](DESCRIPTION)
- [NAMESPACE](NAMESPACE)
- [NEWS.md](NEWS.md)
- [R/summariseDrugUtilisation.R](R/summariseDrugUtilisation.R)
- [_pkgdown.yml](_pkgdown.yml)
- [cran-comments.md](cran-comments.md)
- [inst/CITATION](inst/CITATION)
- [man/DrugUtilisation-package.Rd](man/DrugUtilisation-package.Rd)
- [man/reexports.Rd](man/reexports.Rd)
- [vignettes/.gitignore](vignettes/.gitignore)
- [vignettes/create_cohorts.Rmd](vignettes/create_cohorts.Rmd)
- [vignettes/mock_data.Rmd](vignettes/mock_data.Rmd)

</details>



This document explains the fundamental concepts and architectural patterns that underlie the DrugUtilisation package. It covers the OMOP CDM integration model, cohort-centric analysis approach, core data structures, and key terminology used throughout the package.

For specific guidance on cohort creation and management, see [Cohort Management](#4). For details on analysis functions and outputs, see [Drug Utilisation Analysis](#5) and [Output and Visualization](#8).

## OMOP CDM Foundation

The DrugUtilisation package is built around the **Observational Medical Outcomes Partnership (OMOP) Common Data Model**. All functionality assumes data is structured according to OMOP CDM specifications, with the package providing a high-level interface for drug utilization research.

```mermaid
graph TB
    subgraph "OMOP CDM Tables"
        PERSON["person<br/>Patient demographics"]
        OBS_PERIOD["observation_period<br/>Patient observation windows"]
        DRUG_EXP["drug_exposure<br/>Drug prescriptions/dispensations"]
        CONDITION["condition_occurrence<br/>Medical conditions"]
        CONCEPT["concept<br/>Standardized vocabularies"]
        CONCEPT_ANC["concept_ancestor<br/>Concept hierarchies"]
        DRUG_STR["drug_strength<br/>Drug dosing information"]
    end
    
    subgraph "DrugUtilisation Interface"
        CDM_REF["cdm_reference<br/>Database connection object"]
        COHORT_TBL["cohort_table<br/>Generated patient cohorts"]
        ANALYSIS["Analysis Functions<br/>Drug utilization calculations"]
    end
    
    subgraph "R Package Ecosystem"
        CDMCONN["CDMConnector<br/>Database interface"]
        OMOPGEN["omopgenerics<br/>OMOP standards & validation"]
        PATPROF["PatientProfiles<br/>Patient-level operations"]
    end
    
    PERSON --> CDM_REF
    OBS_PERIOD --> CDM_REF
    DRUG_EXP --> CDM_REF
    CONDITION --> CDM_REF
    CONCEPT --> CDM_REF
    CONCEPT_ANC --> CDM_REF
    DRUG_STR --> CDM_REF
    
    CDM_REF --> COHORT_TBL
    COHORT_TBL --> ANALYSIS
    
    CDMCONN --> CDM_REF
    OMOPGEN --> COHORT_TBL
    PATPROF --> ANALYSIS
```

The package operates on `cdm_reference` objects that provide access to OMOP CDM tables through database connections. All analysis begins with these standardized data structures.

**Sources:** [DESCRIPTION:1-93](), [vignettes/create_cohorts.Rmd:37-49]()

## Cohort-Centric Analysis Model

The core analytical paradigm is **cohort-centric**: all drug utilization analysis begins with defining patient cohorts that represent specific study populations. Cohorts are then refined through inclusion criteria and analyzed for drug utilization patterns.

```mermaid
graph LR
    subgraph "Cohort Generation"
        CONCEPTSET["conceptSet<br/>Drug definitions"]
        GAPERA["gapEra<br/>Episode consolidation"]
        GEN_FUNC["generateDrugUtilisationCohortSet<br/>generateIngredientCohortSet<br/>generateAtcCohortSet"]
    end
    
    subgraph "Cohort Refinement"
        REQ_WASH["requirePriorDrugWashout"]
        REQ_FIRST["requireIsFirstDrugEntry"] 
        REQ_OBS["requireObservationBeforeDrug"]
        REQ_DATE["requireDrugInDateRange"]
    end
    
    subgraph "Analysis Layer"
        ADD_FUNCS["addDrugUtilisation<br/>addIndication<br/>addTreatment"]
        SUM_FUNCS["summariseDrugUtilisation<br/>summariseIndication<br/>summariseTreatment"]
    end
    
    CONCEPTSET --> GEN_FUNC
    GAPERA --> GEN_FUNC
    GEN_FUNC --> REQ_WASH
    REQ_WASH --> REQ_FIRST
    REQ_FIRST --> REQ_OBS  
    REQ_OBS --> REQ_DATE
    REQ_DATE --> ADD_FUNCS
    ADD_FUNCS --> SUM_FUNCS
```

### Key Cohort Concepts

- **conceptSet**: Defines which drug concepts to include using concept IDs, ATC codes, or ingredient names
- **gapEra**: Specifies maximum gap (in days) between drug exposures before treating them as separate episodes
- **cohort_table**: Standard OMOP cohort structure with `subject_id`, `cohort_start_date`, `cohort_end_date`

**Sources:** [vignettes/create_cohorts.Rmd:52-57](), [vignettes/create_cohorts.Rmd:108-221](), [NAMESPACE:26-28]()

## Core Data Structures

The package works with several key data structures that flow through the analysis pipeline:

### Primary Data Objects

| Structure | Purpose | Key Attributes |
|-----------|---------|----------------|
| `cdm_reference` | Database connection to OMOP CDM | Contains all OMOP tables |
| `cohort_table` | Patient cohorts with OMOP validation | `subject_id`, `cohort_start_date`, `cohort_end_date` |
| `conceptSet` | Drug concept definitions | Named list of concept IDs or expressions |
| `summarised_result` | Standardized analysis output | Results from all `summarise*` functions |

```mermaid
graph TB
    subgraph "Input Data Structures"
        CDM["cdm_reference<br/>{person, drug_exposure, concept, ...}"]
        CS["conceptSet<br/>{drug_concepts: [id1, id2, ...]}"]
    end
    
    subgraph "Intermediate Structures" 
        COH_RAW["cohort_table (raw)<br/>{subject_id, cohort_start_date, cohort_end_date}"]
        COH_REF["cohort_table (refined)<br/>+ inclusion criteria applied"]
        ENR_COH["enriched cohort<br/>+ drug utilization variables"]
    end
    
    subgraph "Output Structures"
        SUM_RES["summarised_result<br/>standardized analysis output"]
        TABLES["formatted tables<br/>gt_tbl, flextable"]
        PLOTS["ggplot objects<br/>visualizations"]
    end
    
    CDM --> COH_RAW
    CS --> COH_RAW
    COH_RAW --> COH_REF
    COH_REF --> ENR_COH
    ENR_COH --> SUM_RES
    SUM_RES --> TABLES
    SUM_RES --> PLOTS
```

### Cohort Attributes

All cohort objects maintain standardized attributes accessible through `omopgenerics` functions:

- `settings()`: Parameters used in cohort generation
- `cohortCount()`: Number of subjects and records per cohort
- `attrition()`: Detailed inclusion/exclusion criteria tracking
- `cohortCodelist()`: Concept sets used for each cohort definition

**Sources:** [vignettes/create_cohorts.Rmd:267-273](), [man/reexports.Rd:6-18](), [R/summariseDrugUtilisation.R:102-112]()

## Analysis Patterns

The package implements a consistent **two-phase analysis pattern** across all functionality:

### Phase 1: Add Functions (Patient-Level)
Functions that add variables to individual patient records in cohorts:

```mermaid
graph LR
    subgraph "Add Functions"
        ADD_DU["addDrugUtilisation<br/>Individual drug metrics"]
        ADD_IND["addIndication<br/>Medical indications"]
        ADD_TREAT["addTreatment<br/>Treatment patterns"]
        ADD_REST["addDrugRestart<br/>Restart events"]
    end
    
    subgraph "Individual Variables Added"
        METRICS["number_exposures_X<br/>days_exposed_X<br/>initial_quantity_X<br/>cumulative_dose_X"]
        INDIC["indication_X_Y<br/>per time window"]
        TREAT_VAR["treatment_X_Y<br/>concurrent treatments"] 
        RESTART["drug_restart_X<br/>switch events"]
    end
    
    ADD_DU --> METRICS
    ADD_IND --> INDIC
    ADD_TREAT --> TREAT_VAR
    ADD_REST --> RESTART
```

### Phase 2: Summarise Functions (Population-Level)
Functions that aggregate patient-level data into population summaries:

```mermaid
graph LR
    subgraph "Summarise Functions"
        SUM_DU["summariseDrugUtilisation"]
        SUM_IND["summariseIndication"] 
        SUM_TREAT["summariseTreatment"]
        SUM_REST["summariseDrugRestart"]
    end
    
    subgraph "Population Statistics"
        STATS["mean, median, sd, q25, q75<br/>count_missing, percentage_missing"]
        COUNTS["proportions and counts<br/>stratified by characteristics"]
    end
    
    SUM_DU --> STATS
    SUM_IND --> COUNTS  
    SUM_TREAT --> COUNTS
    SUM_REST --> COUNTS
```

All `summarise*` functions return standardized `summarised_result` objects that can be processed by table and plot generation functions.

**Sources:** [NAMESPACE:3-16](), [NAMESPACE:46-58](), [R/summariseDrugUtilisation.R:51-73]()

## Function Naming Conventions

The package follows consistent naming patterns that reflect functionality:

| Pattern | Purpose | Examples |
|---------|---------|----------|
| `generate*` | Create new cohorts | `generateDrugUtilisationCohortSet`, `generateIngredientCohortSet` |
| `require*` | Apply inclusion criteria | `requirePriorDrugWashout`, `requireIsFirstDrugEntry` |
| `add*` | Add patient-level variables | `addDrugUtilisation`, `addIndication` |
| `summarise*` | Create population summaries | `summariseDrugUtilisation`, `summariseIndication` |
| `table*` | Generate formatted tables | `tableDrugUtilisation`, `tableIndication` |
| `plot*` | Create visualizations | `plotDrugUtilisation`, `plotIndication` |

**Sources:** [NAMESPACE:26-58](), [_pkgdown.yml:19-92]()

## Package Ecosystem Integration

DrugUtilisation integrates deeply with the **DARWIN EU ecosystem** of R packages for OMOP CDM analysis:

```mermaid
graph TB
    subgraph "Core Dependencies"
        OMOPGEN["omopgenerics<br/>OMOP standards & validation"]
        CDMCONN["CDMConnector<br/>Database connections"]
        PATPROF["PatientProfiles<br/>Patient-level operations"] 
        CODEGEN["CodelistGenerator<br/>Concept set creation"]
    end
    
    subgraph "DrugUtilisation"
        CORE["Core Functions<br/>Drug utilization analysis"]
    end
    
    subgraph "Output Dependencies"
        VISOMOP["visOmopResults<br/>Standardized visualization"]
        GGPLOT["ggplot2<br/>Graphics engine"]
        TABLES["gt, flextable<br/>Table formatting"]
    end
    
    OMOPGEN --> CORE
    CDMCONN --> CORE
    PATPROF --> CORE
    CODEGEN --> CORE
    
    CORE --> VISOMOP
    CORE --> GGPLOT
    CORE --> TABLES
```

### Key Integration Points

- **omopgenerics**: Provides `cohort_table` validation, `summarised_result` standards, and utility functions
- **CDMConnector**: Enables database connections and OMOP CDM table access
- **PatientProfiles**: Supplies patient-level data manipulation functions
- **CodelistGenerator**: Creates concept sets from ATC codes, ingredient names, and hierarchies
- **visOmopResults**: Handles standardized visualization of analysis results

**Sources:** [DESCRIPTION:73-85](), [NAMESPACE:60-78]()

## Key Terminology

| Term | Definition |
|------|------------|
| **Episode/Era** | Drug exposures collapsed by `gapEra` parameter to represent treatment periods |
| **Incident Use** | First drug exposure after washout period (new users) |
| **Prevalent Use** | Any drug exposure regardless of prior history |
| **Index Date** | Reference date for analysis, typically `cohort_start_date` |
| **Censor Date** | End date for follow-up, typically `cohort_end_date` |
| **Concept Set** | Collection of OMOP concept IDs defining drugs of interest |
| **Washout Period** | Required time without drug exposure before incident use |

**Sources:** [vignettes/create_cohorts.Rmd:108-221](), [R/summariseDrugUtilisation.R:28-31]()