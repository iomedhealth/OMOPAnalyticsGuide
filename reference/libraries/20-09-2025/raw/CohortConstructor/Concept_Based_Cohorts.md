# Page: Concept-Based Cohorts

# Concept-Based Cohorts

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [CohortConstructor.Rproj](CohortConstructor.Rproj)
- [R/conceptCohort.R](R/conceptCohort.R)
- [man/conceptCohort.Rd](man/conceptCohort.Rd)
- [tests/testthat/test-conceptCohort.R](tests/testthat/test-conceptCohort.R)
- [vignettes/a00_introduction.Rmd](vignettes/a00_introduction.Rmd)
- [vignettes/a01_building_base_cohorts.Rmd](vignettes/a01_building_base_cohorts.Rmd)
- [vignettes/images/pipeline.png](vignettes/images/pipeline.png)

</details>



## Purpose and Scope

This document covers the `conceptCohort()` function, which creates cohorts by identifying patient records from OMOP CDM clinical tables that match specified concept sets. This is one of the four primary approaches for building base cohorts in CohortConstructor.

For information about building cohorts from patient demographics, see [Demographics-Based Cohorts](#3.2). For measurement-based filtering, see [Measurement-Based Cohorts](#3.3). For applying additional requirements to existing cohorts, see [Applying Requirements and Filters](#5).

## Supported OMOP Tables and Workflow

The `conceptCohort()` function searches for records across multiple OMOP CDM clinical tables based on concept domains. The following diagram shows the supported tables and their corresponding domains:

### Supported Clinical Tables

```mermaid
graph TD
    subgraph "OMOP CDM Tables"
        condition_occurrence["condition_occurrence<br/>Domain: Condition"]
        drug_exposure["drug_exposure<br/>Domain: Drug"]
        device_exposure["device_exposure<br/>Domain: Device"]
        measurement["measurement<br/>Domain: Measurement"]
        observation["observation<br/>Domain: Observation"]
        procedure_occurrence["procedure_occurrence<br/>Domain: Procedure"]
        visit_occurrence["visit_occurrence<br/>Domain: Visit"]
    end
    
    subgraph "conceptCohort Function"
        conceptSet["conceptSet<br/>(input parameter)"]
        domainMapping["Domain Mapping<br/>via concept table"]
        tableSearch["Table-specific<br/>Record Search"]
    end
    
    subgraph "Output"
        cohortTable["Cohort Table<br/>with start/end dates"]
    end
    
    conceptSet --> domainMapping
    domainMapping --> condition_occurrence
    domainMapping --> drug_exposure
    domainMapping --> device_exposure
    domainMapping --> measurement
    domainMapping --> observation
    domainMapping --> procedure_occurrence
    domainMapping --> visit_occurrence
    
    condition_occurrence --> tableSearch
    drug_exposure --> tableSearch
    device_exposure --> tableSearch
    measurement --> tableSearch
    observation --> tableSearch
    procedure_occurrence --> tableSearch
    visit_occurrence --> tableSearch
    
    tableSearch --> cohortTable
```

Sources: [R/conceptCohort.R:7-16](), [R/conceptCohort.R:294-295]()

### Concept-to-Table Mapping Process

```mermaid
flowchart LR
    subgraph "Input Processing"
        conceptSet["conceptSet<br/>list(cohort_name = c(concept_ids))"]
        uploadCohortCodelistToCdm["uploadCohortCodelistToCdm()"]
        conceptTable["concept table<br/>domain_id lookup"]
    end
    
    subgraph "Domain Processing"
        domainsData["domainsData<br/>(internal mapping)"]
        getDomainCohort["getDomainCohort()"]
        unerafiedConceptCohort["unerafiedConceptCohort()"]
    end
    
    subgraph "Record Retrieval"
        tableJoin["Inner join with<br/>clinical tables"]
        recordCollection["Record collection<br/>by domain"]
        unionAll["Union all domains<br/>Reduce()"]
    end
    
    conceptSet --> uploadCohortCodelistToCdm
    uploadCohortCodelistToCdm --> conceptTable
    conceptTable --> domainsData
    domainsData --> getDomainCohort
    getDomainCohort --> unerafiedConceptCohort
    unerafiedConceptCohort --> tableJoin
    tableJoin --> recordCollection
    recordCollection --> unionAll
```

Sources: [R/conceptCohort.R:128-134](), [R/conceptCohort.R:185-196](), [R/conceptCohort.R:278-382]()

## Key Parameters and Configuration

The `conceptCohort()` function provides several configuration options that control how cohorts are built:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `conceptSet` | list | required | Named list of concept IDs for each cohort |
| `exit` | character | "event_end_date" | How cohort end date is defined |
| `overlap` | character | "merge" | How overlapping records are handled |
| `inObservation` | logical | TRUE | Whether to require records within observation periods |
| `table` | character | NULL | Specific OMOP table(s) to search |
| `useSourceFields` | logical | FALSE | Whether to include source concept fields |
| `subsetCohort` | character | NULL | Existing cohort to restrict individuals |
| `subsetCohortId` | integer | NULL | Specific cohort IDs from subset cohort |

Sources: [R/conceptCohort.R:85-94](), [man/conceptCohort.Rd:20-56]()

### Exit Date Configuration

The `exit` parameter determines how cohort end dates are calculated:

```mermaid
graph TD
    subgraph "Exit Date Options"
        eventEndDate["exit = 'event_end_date'<br/>(default)"]
        eventStartDate["exit = 'event_start_date'"]
    end
    
    subgraph "Record Processing"
        clinicalRecord["Clinical Record<br/>start_date, end_date"]
        exitLogic["Exit Date Logic<br/>unerafiedConceptCohort()"]
    end
    
    subgraph "Cohort Output"
        cohortEndDate1["cohort_end_date =<br/>clinical_record_end_date"]
        cohortEndDate2["cohort_end_date =<br/>clinical_record_start_date"]
    end
    
    eventEndDate --> exitLogic
    eventStartDate --> exitLogic
    clinicalRecord --> exitLogic
    
    exitLogic --> cohortEndDate1
    exitLogic --> cohortEndDate2
```

Sources: [R/conceptCohort.R:315-319](), [tests/testthat/test-conceptCohort.R:547-581]()

## Overlap Handling Strategies

When multiple clinical records for the same individual overlap in time, `conceptCohort()` provides two strategies for handling them:

### Merge Strategy (Default)

```mermaid
gantt
    title Overlap Handling: merge
    dateFormat YYYY-MM-DD
    axisFormat %m/%d
    
    section Individual Records
    Record 1    :2020-01-01, 2020-01-10
    Record 2    :2020-01-05, 2020-01-15
    Record 3    :2020-01-12, 2020-01-20
    
    section Merged Result
    Merged Cohort Entry :crit, 2020-01-01, 2020-01-20
```

### Extend Strategy

```mermaid
gantt
    title Overlap Handling: extend
    dateFormat YYYY-MM-DD
    axisFormat %m/%d
    
    section Individual Records
    Record 1 (10 days)   :2020-01-01, 2020-01-10
    Record 2 (11 days)   :2020-01-05, 2020-01-15
    Record 3 (9 days)    :2020-01-12, 2020-01-20
    
    section Extended Result
    Extended Entry (30 days) :crit, 2020-01-01, 2020-01-30
```

Sources: [R/conceptCohort.R:242-258](), [R/conceptCohort.R:641-708](), [tests/testthat/test-conceptCohort.R:705-889]()

### Overlap Implementation Details

```mermaid
flowchart TB
    subgraph "Overlap Processing"
        overlapParam["overlap parameter<br/>('merge' or 'extend')"]
        mergeLogic["joinOverlap()<br/>gap = 0"]
        extendLogic["extendOverlap()<br/>sum durations"]
        hasOverlap["hasOverlap()<br/>check function"]
    end
    
    subgraph "Post-Processing"
        fulfillCohortReqs["fulfillCohortReqs()<br/>re-apply requirements"]
        attritionRecord["recordCohortAttrition()<br/>track changes"]
    end
    
    overlapParam --> mergeLogic
    overlapParam --> extendLogic
    extendLogic --> hasOverlap
    hasOverlap --> fulfillCohortReqs
    mergeLogic --> attritionRecord
    extendLogic --> attritionRecord
    fulfillCohortReqs --> attritionRecord
```

Sources: [R/conceptCohort.R:242-258](), [R/conceptCohort.R:710-729]()

## Implementation Details

### Core Function Workflow

The `conceptCohort()` function follows a structured workflow implemented across several internal functions:

```mermaid
flowchart TD
    subgraph "Input Validation"
        validateInputs["Input validation<br/>validateNameArgument()<br/>validateCdmArgument()<br/>validateConceptSetArgument()"]
    end
    
    subgraph "Concept Set Processing"
        conceptSetToCohortSet["conceptSetToCohortSet()"]
        conceptSetToCohortCodelist["conceptSetToCohortCodelist()"]
        uploadCohortCodelist["uploadCohortCodelistToCdm()"]
    end
    
    subgraph "Record Retrieval"
        unerafiedConceptCohort["unerafiedConceptCohort()"]
        getDomainCohort["getDomainCohort()"]
        domainLoop["Domain-specific<br/>record collection"]
    end
    
    subgraph "Cohort Requirements"
        fulfillCohortReqs["fulfillCohortReqs()"]
        overlapHandling["Overlap handling<br/>(merge/extend)"]
        newCohortTable["newCohortTable()"]
    end
    
    validateInputs --> conceptSetToCohortSet
    conceptSetToCohortSet --> conceptSetToCohortCodelist
    conceptSetToCohortCodelist --> uploadCohortCodelist
    uploadCohortCodelist --> unerafiedConceptCohort
    unerafiedConceptCohort --> getDomainCohort
    getDomainCohort --> domainLoop
    domainLoop --> fulfillCohortReqs
    fulfillCohortReqs --> overlapHandling
    overlapHandling --> newCohortTable
```

Sources: [R/conceptCohort.R:96-109](), [R/conceptCohort.R:117-124](), [R/conceptCohort.R:185-196]()

### Cohort Requirements Processing

The `fulfillCohortReqs()` function ensures that all cohort entries meet OMOP CDM cohort table requirements:

```mermaid
flowchart LR
    subgraph "Observation Period Handling"
        inObservationTrue["inObservation = TRUE<br/>Drop records outside<br/>observation periods"]
        inObservationFalse["inObservation = FALSE<br/>Trim records to<br/>observation boundaries"]
    end
    
    subgraph "Data Quality Checks"
        personJoin["Join with person table<br/>Require non-missing<br/>gender_concept_id<br/>year_of_birth"]
        dateValidation["Date validation<br/>start <= end<br/>non-missing dates"]
    end
    
    subgraph "Attrition Tracking"
        recordAttrition["recordCohortAttrition()<br/>Track exclusions<br/>at each step"]
    end
    
    inObservationTrue --> personJoin
    inObservationFalse --> personJoin
    personJoin --> dateValidation
    dateValidation --> recordAttrition
```

Sources: [R/conceptCohort.R:384-510](), [R/conceptCohort.R:442-462](), [R/conceptCohort.R:490-509]()

### Domain-Specific Record Processing

For each supported domain, records are retrieved using domain-specific logic:

```mermaid
flowchart TD
    subgraph "Domain Configuration"
        domainsData["domainsData<br/>(internal data)"]
        tableMapping["table mapping<br/>start/end columns<br/>concept_id columns"]
    end
    
    subgraph "Record Selection"
        standardConcepts["Standard concept_id<br/>fields (default)"]
        sourceConcepts["Source concept_id<br/>fields (if useSourceFields)"]
        subsetFiltering["Subset filtering<br/>(if subsetCohort)"]
    end
    
    subgraph "Output Generation"
        recordUnion["Union all<br/>matching records"]
        cohortCompute["Compute final<br/>cohort table"]
    end
    
    domainsData --> tableMapping
    tableMapping --> standardConcepts
    tableMapping --> sourceConcepts
    standardConcepts --> subsetFiltering
    sourceConcepts --> subsetFiltering
    subsetFiltering --> recordUnion
    recordUnion --> cohortCompute
```

Sources: [R/conceptCohort.R:602-639](), [R/conceptCohort.R:324-342](), [R/conceptCohort.R:357-381]()