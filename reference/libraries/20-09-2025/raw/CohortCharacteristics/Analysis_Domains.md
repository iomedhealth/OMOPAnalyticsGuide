# Page: Analysis Domains

# Analysis Domains

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [MD5](MD5)
- [NAMESPACE](NAMESPACE)

</details>



This document provides an overview of the five core analysis domains supported by the CohortCharacteristics package. Each domain addresses specific analytical questions about OMOP CDM cohorts and follows a consistent three-tier pattern: summarization → visualization → tabulation. For detailed implementation of each domain, see the individual sections: General Characteristics ([3.1](#3.1)), Cohort Attrition ([3.2](#3.2)), Cohort Overlap ([3.3](#3.3)), Cohort Timing ([3.4](#3.4)), and Large Scale Characteristics ([3.5](#3.5)). For information about the underlying workflow patterns, see Core Analysis Workflow ([2](#2)).

## Analysis Domain Architecture

The CohortCharacteristics package organizes analytical capabilities into distinct domains, each targeting specific research questions about cohort composition, flow, relationships, and temporal patterns.

```mermaid
flowchart TD
    subgraph "Input Layer"
        CDM["OMOP CDM Database"]
        COHORT["Cohort Tables"]
    end
    
    subgraph "Analysis Domains"
        CHAR["General Characteristics<br/>Demographics & Variables"]
        ATTR["Cohort Attrition<br/>Subject Flow Analysis"]
        OVER["Cohort Overlap<br/>Subject Intersections"]
        TIME["Cohort Timing<br/>Temporal Relationships"]
        LSC["Large Scale Characteristics<br/>Concept-level Analysis"]
    end
    
    subgraph "Three-Tier Pattern"
        SUMM["summarise*() Functions<br/>Data Processing & Computation"]
        PLOT["plot*() Functions<br/>Visualization Generation"]
        TABLE["table*() Functions<br/>Formatted Output"]
    end
    
    subgraph "Output Formats"
        VIZ["Interactive Plots<br/>ggplot2, plotly, DiagrammeR"]
        TAB["Formatted Tables<br/>gt, flextable, reactable, DT"]
        EXPORT["Export Options<br/>HTML, PNG, CSV"]
    end
    
    CDM --> CHAR
    CDM --> ATTR
    CDM --> OVER
    CDM --> TIME
    CDM --> LSC
    
    COHORT --> CHAR
    COHORT --> ATTR
    COHORT --> OVER
    COHORT --> TIME
    COHORT --> LSC
    
    CHAR --> SUMM
    ATTR --> SUMM
    OVER --> SUMM
    TIME --> SUMM
    LSC --> SUMM
    
    SUMM --> PLOT
    SUMM --> TABLE
    
    PLOT --> VIZ
    TABLE --> TAB
    
    VIZ --> EXPORT
    TAB --> EXPORT
```

**Analysis Domain Function Architecture**

Sources: [NAMESPACE:1-57](), [R/summariseCharacteristics.R](), [R/summariseCohortAttrition.R](), [R/summariseCohortOverlap.R](), [R/summariseCohortTiming.R](), [R/summariseLargeScaleCharacteristics.R]()

## Function Mapping by Domain

Each analysis domain implements the consistent three-tier pattern through specific function families, providing a standardized interface across different analytical approaches.

```mermaid
graph LR
    subgraph "General Characteristics"
        SC["summariseCharacteristics()"]
        PC["plotCharacteristics()"]
        TC["tableCharacteristics()"]
        SC --> PC
        SC --> TC
    end
    
    subgraph "Cohort Attrition"
        SCA["summariseCohortAttrition()"]
        PCA["plotCohortAttrition()"]
        TCA["tableCohortAttrition()"]
        SCA --> PCA
        SCA --> TCA
    end
    
    subgraph "Cohort Overlap"
        SCO["summariseCohortOverlap()"]
        PCO["plotCohortOverlap()"]
        TCO["tableCohortOverlap()"]
        SCO --> PCO
        SCO --> TCO
    end
    
    subgraph "Cohort Timing"
        SCT["summariseCohortTiming()"]
        PCT["plotCohortTiming()"]
        TCT["tableCohortTiming()"]
        SCT --> PCT
        SCT --> TCT
    end
    
    subgraph "Large Scale Characteristics"
        SLSC["summariseLargeScaleCharacteristics()"]
        PLSC["plotLargeScaleCharacteristics()"]
        PCLSC["plotComparedLargeScaleCharacteristics()"]
        TLSC["tableLargeScaleCharacteristics()"]
        TTLSC["tableTopLargeScaleCharacteristics()"]
        SLSC --> PLSC
        SLSC --> PCLSC
        SLSC --> TLSC
        SLSC --> TTLSC
    end
    
    subgraph "Additional Functions"
        SCC["summariseCohortCount()"]
        PCC["plotCohortCount()"]
        TCC["tableCohortCount()"]
        SCCL["summariseCohortCodelist()"]
        TCCL["tableCohortCodelist()"]
        SCC --> PCC
        SCC --> TCC
    end
```

**Function Implementation Mapping**

Sources: [NAMESPACE:23-38](), [R/plotCharacteristics.R](), [R/plotCohortAttrition.R](), [R/plotCohortOverlap.R](), [R/plotCohortTiming.R](), [R/plotLargeScaleCharacteristics.R](), [R/tableCharacteristics.R](), [R/tableCohortAttrition.R](), [R/tableCohortOverlap.R](), [R/tableCohortTiming.R](), [R/tableLargeScaleCharacteristics.R]()

## Domain Characteristics and Use Cases

Each analysis domain addresses specific research questions and analytical needs within cohort studies.

| Domain | Primary Function | Key Capabilities | Output Types |
|--------|-----------------|------------------|--------------|
| **General Characteristics** | `summariseCharacteristics()` | Demographics, intersections, custom variables | Bar charts, scatter plots, summary tables |
| **Cohort Attrition** | `summariseCohortAttrition()` | Subject flow tracking, exclusion analysis | Flow diagrams, attrition tables |
| **Cohort Overlap** | `summariseCohortOverlap()` | Cross-cohort subject intersections | Bar charts, Venn-style visualizations |
| **Cohort Timing** | `summariseCohortTiming()` | Time-to-event, temporal relationships | Box plots, density plots, timing tables |
| **Large Scale Characteristics** | `summariseLargeScaleCharacteristics()` | Concept frequency, vocabulary analysis | Concept plots, comparison charts, top concept tables |

## Data Processing Flow

The domains share a common data processing pattern while implementing domain-specific analytical logic.

```mermaid
flowchart TD
    subgraph "Data Input Validation"
        INPUT["cohort_table objects<br/>CDM reference validation"]
        VALIDATE["Input checks<br/>omopgenerics validation"]
    end
    
    subgraph "Domain-Specific Processing"
        CHARS["Characteristics Processing<br/>PatientProfiles integration<br/>addSex, addAge, addIntersect*"]
        ATTR["Attrition Processing<br/>Step-by-step filtering<br/>Reason tracking"]
        OVERLAP["Overlap Processing<br/>Cross-cohort matching<br/>Intersection calculations"]
        TIMING["Timing Processing<br/>Date difference calculations<br/>Time window analysis"]
        LSC["Large Scale Processing<br/>Concept frequency analysis<br/>Vocabulary traversal"]
    end
    
    subgraph "Result Standardization"
        RESULT["summarised_result objects<br/>Standardized output format"]
        SETTINGS["Settings metadata<br/>Parameter preservation"]
    end
    
    INPUT --> VALIDATE
    VALIDATE --> CHARS
    VALIDATE --> ATTR
    VALIDATE --> OVERLAP
    VALIDATE --> TIMING
    VALIDATE --> LSC
    
    CHARS --> RESULT
    ATTR --> RESULT
    OVERLAP --> RESULT
    TIMING --> RESULT
    LSC --> RESULT
    
    RESULT --> SETTINGS
```

**Domain Processing Architecture**

Sources: [R/checks.R](), [R/summariseCharacteristics.R](), [R/summariseCohortAttrition.R](), [R/summariseCohortOverlap.R](), [R/summariseCohortTiming.R](), [R/summariseLargeScaleCharacteristics.R]()

## Domain Integration Points

All domains integrate with the broader OMOP ecosystem through standardized interfaces and data structures.

```mermaid
graph TB
    subgraph "External Dependencies"
        PP["PatientProfiles<br/>addSex, addAge<br/>addCohortIntersect*<br/>addTableIntersect*"]
        OG["omopgenerics<br/>summarised_result<br/>Validation functions"]
        VOR["visOmopResults<br/>Plotting & table standards"]
    end
    
    subgraph "CohortCharacteristics Domains"
        D1["General Characteristics"]
        D2["Cohort Attrition"]
        D3["Cohort Overlap"]
        D4["Cohort Timing"]
        D5["Large Scale Characteristics"]
    end
    
    subgraph "Common Utilities"
        UTILS["utilities.R<br/>Helper functions"]
        CHECKS["checks.R<br/>Validation logic"]
        DOC["documentationHelpers.R<br/>Shared documentation"]
    end
    
    PP --> D1
    PP --> D3
    PP --> D4
    PP --> D5
    
    OG --> D1
    OG --> D2
    OG --> D3
    OG --> D4
    OG --> D5
    
    VOR --> D1
    VOR --> D2
    VOR --> D3
    VOR --> D4
    VOR --> D5
    
    UTILS --> D1
    UTILS --> D2
    UTILS --> D3
    UTILS --> D4
    UTILS --> D5
    
    CHECKS --> D1
    CHECKS --> D2
    CHECKS --> D3
    CHECKS --> D4
    CHECKS --> D5
```

**Integration Architecture**

Sources: [R/utilities.R](), [R/checks.R](), [R/documentationHelpers.R](), [NAMESPACE:40-52]()

Each domain builds upon this common foundation while implementing specialized analytical logic. The consistent three-tier pattern ensures that users can apply the same workflow principles across different types of cohort analysis, while domain-specific functions provide the analytical depth required for each research question.