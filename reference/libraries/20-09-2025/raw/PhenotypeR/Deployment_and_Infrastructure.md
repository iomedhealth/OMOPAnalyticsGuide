# Page: Deployment and Infrastructure

# Deployment and Infrastructure

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.github/workflows/deploy-shiny.yaml](.github/workflows/deploy-shiny.yaml)
- [extras/createShiny.R](extras/createShiny.R)
- [extras/deployShiny.R](extras/deployShiny.R)
- [extras/docShiny.R](extras/docShiny.R)
- [extras/expectationsForShiny.R](extras/expectationsForShiny.R)
- [extras/shiny_expectations.csv](extras/shiny_expectations.csv)
- [extras/testShiny.R](extras/testShiny.R)

</details>



This document covers the automated deployment pipeline and infrastructure components used to deploy PhenotypeR's Shiny diagnostic application to production. The system uses GitHub Actions for continuous integration and deployment, with shinyapps.io as the hosting platform for interactive web applications.

For information about the Shiny application architecture itself, see [Interactive Visualization System](#3). For development and testing frameworks, see [Development and Testing](#4).

## Deployment Architecture Overview

```mermaid
graph TB
    subgraph "GitHub Repository"
        A["main branch"]
        B["pull_request branches"]
        C[".github/workflows/deploy-shiny.yaml"]
    end
    
    subgraph "GitHub Actions Runner"
        D["ubuntu-latest"]
        E["R 4.3.3 environment"]
        F["pak package manager"]
    end
    
    subgraph "Build Process"
        G["extras/createShiny.R"]
        H["PhenotypeRShiny/ directory"]
        I["renv.lock"]
        J["appData.RData"]
    end
    
    subgraph "Deployment Targets"
        K["shinyapps.io/PhenotypeRShiny"]
        L["shinyapps.io/PhenotypeRShinyTest"]
    end
    
    subgraph "Secrets Management"
        M["SHINYAPPS_TOKEN"]
        N["SHINYAPPS_SECRET"]
    end
    
    A --> C
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    H --> J
    
    A --> K
    B --> L
    
    M --> K
    M --> L
    N --> K
    N --> L
    
    style C fill:#f9f9f9,stroke:#333,stroke-width:2px
    style G fill:#f9f9f9,stroke:#333,stroke-width:2px
    style K fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    style L fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
```

**Sources:** [.github/workflows/deploy-shiny.yaml:1-75](), [extras/createShiny.R:1-41](), [extras/deployShiny.R:1-13]()

## GitHub Actions CI/CD Pipeline

The deployment process is orchestrated by a GitHub Actions workflow that triggers on pushes to main and pull requests. The workflow handles both test deployments for pull requests and production deployments for the main branch.

### Workflow Configuration

| Trigger | Target Environment | App Name |
|---------|-------------------|----------|
| `push` to `main` | Production | `PhenotypeRShiny` |
| `pull_request` | Test | `PhenotypeRShinyTest` |

The workflow uses a matrix strategy with Ubuntu Latest and R version 4.3.3, ensuring consistent deployment environments.

```mermaid
flowchart TD
    A["GitHub Event Trigger"] --> B{"Event Type?"}
    B -->|"push to main"| C["Install PhenotypeR from main"]
    B -->|"pull_request"| D["Install PhenotypeR from branch"]
    
    C --> E["Execute extras/createShiny.R"]
    D --> E
    
    E --> F["Generate PhenotypeRShiny/ directory"]
    F --> G["Initialize renv environment"]
    
    G --> H{"Deployment Target?"}
    H -->|"main branch"| I["Execute extras/docShiny.R"]
    H -->|"pull request"| J["Execute extras/testShiny.R"]
    
    I --> K["Deploy to PhenotypeRShiny"]
    J --> L["Deploy to PhenotypeRShinyTest"]
    
    style E fill:#f9f9f9,stroke:#333,stroke-width:2px
    style I fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    style J fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
```

**Sources:** [.github/workflows/deploy-shiny.yaml:3-74](), [extras/docShiny.R:1-3](), [extras/testShiny.R:1-3]()

### Package Installation Strategy

The workflow implements branch-aware package installation to ensure pull request deployments test the exact code changes being proposed:

- **Pull Requests**: Installs PhenotypeR from the specific branch using `pak::pkg_install('ohdsi/PhenotypeR@$BRANCH_NAME')`
- **Main Branch**: Installs the latest release using `pak::pkg_install("ohdsi/PhenotypeR")`

**Sources:** [.github/workflows/deploy-shiny.yaml:43-53]()

## Shiny Application Generation

The deployment process generates a complete Shiny application with demonstration data through the `createShiny.R` script.

### Mock Data Pipeline

```mermaid
graph LR
    A["omock::mockCdmFromDataset"] --> B["synpuf-1k_5.3 dataset"]
    B --> C["duckdb connection"]
    C --> D["CDMConnector::cdmFromCon"]
    
    D --> E["CohortConstructor::conceptCohort"]
    E --> F["phenotypeDiagnostics"]
    F --> G["shinyDiagnostics"]
    
    H["shiny_expectations.csv"] --> G
    
    G --> I["PhenotypeRShiny/ directory"]
    I --> J["Deployment ready application"]
    
    style E fill:#f9f9f9,stroke:#333,stroke-width:2px
    style F fill:#f9f9f9,stroke:#333,stroke-width:2px
    style G fill:#f9f9f9,stroke:#333,stroke-width:2px
```

**Sources:** [extras/createShiny.R:2-40]()

### Demonstration Cohorts

The system generates four demonstration cohorts from concept sets:

| Cohort Name | Concept IDs | Purpose |
|-------------|-------------|---------|
| `user_of_warfarin` | 1310149L, 40163554L | Anticoagulant usage |
| `user_of_acetaminophen` | 1125315L, 1127078L, 1127433L, 40229134L, 40231925L, 40162522L, 19133768L | Pain medication usage |
| `user_of_morphine` | 1110410L, 35605858L, 40169988L | Opioid usage |
| `measurement_of_prostate_specific_antigen_level` | 2617206L | PSA testing |

**Sources:** [extras/createShiny.R:19-24]()

## Environment Management

### Dependency Management

The deployment process uses `renv` for reproducible R environments:

1. **Initialization**: `renv::init()` creates `renv.lock` in the `PhenotypeRShiny/` directory
2. **Snapshot**: Captures exact package versions used during build
3. **Restoration**: Ensures identical environments across deployments

**Sources:** [.github/workflows/deploy-shiny.yaml:58-60]()

### Secrets and Authentication

Deployment to shinyapps.io requires two environment secrets:

| Secret | Purpose |
|--------|---------|
| `SHINYAPPS_TOKEN` | Authentication token for shinyapps.io API |
| `SHINYAPPS_SECRET` | Secret key for secure communication |

These are configured through `rsconnect::setAccountInfo()` targeting the `dpa-pde-oxford` account.

**Sources:** [extras/deployShiny.R:2-6](), [.github/workflows/deploy-shiny.yaml:65-73]()

## AI-Generated Expectations

The demonstration application includes AI-generated cohort expectations to showcase the expectation comparison functionality.

### Expectation Generation Process

```mermaid
sequenceDiagram
    participant S as "expectationsForShiny.R"
    participant E as "ellmer::chat"
    participant G as "google_gemini"
    participant F as "shiny_expectations.csv"
    
    S->>E: Initialize chat interface
    E->>G: Connect to Gemini API
    S->>E: getCohortExpectations()
    E->>G: Generate expectations for 4 phenotypes
    G->>E: Return structured expectations
    E->>S: Formatted expectation data
    S->>F: Write CSV file
    
    Note over F: 41 expectation records<br/>across 4 cohorts
```

**Sources:** [extras/expectationsForShiny.R:2-10](), [extras/shiny_expectations.csv:1-42]()

### Expectation Data Structure

The generated expectations cover multiple diagnostic categories:

- `cohort_count`: Clinical descriptions and frequency expectations
- `cohort_characteristics`: Age and gender distributions
- `cohort_survival`: Five-year survival estimates
- `compare_cohorts`: Overlap and timing patterns
- `large_scale_characteristics`: Comorbidities, symptoms, and medications

**Sources:** [extras/shiny_expectations.csv:1-42]()

## Deployment Scripts

### Common Deployment Logic

The `deployShiny.R` script provides shared deployment functionality:

```r
rsconnect::setAccountInfo(
  name = "dpa-pde-oxford",
  token = Sys.getenv("SHINYAPPS_TOKEN"),
  secret = Sys.getenv("SHINYAPPS_SECRET")
)
rsconnect::deployApp(
  appDir = file.path(getwd(), "PhenotypeRShiny"),
  appName = appName,
  forceUpdate = TRUE,
  logLevel = "verbose"
)
```

**Sources:** [extras/deployShiny.R:2-12]()

### Environment-Specific Scripts

| Script | App Name | Environment |
|--------|----------|-------------|
| `docShiny.R` | `PhenotypeRShiny` | Production |
| `testShiny.R` | `PhenotypeRShinyTest` | Testing |

Both scripts source the common deployment logic with different `appName` values.

**Sources:** [extras/docShiny.R:2-3](), [extras/testShiny.R:2-3]()

## Concurrency and Resource Management

The workflow implements concurrency controls to prevent conflicting deployments:

```yaml
concurrency:
  group: pr-${{ github.event.pull_request.number || github.run_id }}
  cancel-in-progress: true
```

This ensures that new deployments cancel previous ones for the same pull request, preventing resource conflicts and deployment collisions.

**Sources:** [.github/workflows/deploy-shiny.yaml:17-19]()