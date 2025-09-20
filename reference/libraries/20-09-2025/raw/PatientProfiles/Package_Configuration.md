# Page: Package Configuration

# Package Configuration

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.Rbuildignore](.Rbuildignore)
- [.gitignore](.gitignore)
- [cran-comments.md](cran-comments.md)
- [inst/WORDLIST](inst/WORDLIST)
- [man/PatientProfiles-package.Rd](man/PatientProfiles-package.Rd)
- [vignettes/.gitignore](vignettes/.gitignore)

</details>



This section covers the build configuration, package structure, and distribution setup for the PatientProfiles R package. It includes details about how the package is structured, what files are included or excluded during build processes, and how the package is configured for distribution through CRAN and other channels.

For information about the continuous integration and testing framework, see [Quality Assurance and CI/CD](#5.2). For details about the internal variable type system, see [Variable Types and Statistical Estimates](#5.1).

## Package Structure and Build System

The PatientProfiles package follows standard R package conventions with additional configuration for modern development workflows. The build system is configured to exclude development artifacts while preserving essential package components.

### Build Exclusions

The `.Rbuildignore` file defines which files and directories are excluded from the package build:

```mermaid
flowchart TD
    subgraph "Source Repository"
        RPROJ["R Project Files<br/>*.Rproj, .Rproj.user"]
        LICENSE_FILES["License Files<br/>LICENSE.md, LICENSE"]
        DEV_DOCS["Development Documentation<br/>README.Rmd, doc/, Meta/"]
        PKGDOWN_CONFIG["Documentation Site Config<br/>_pkgdown.yml, docs/, pkgdown/"]
        GITHUB_CONFIG["GitHub Configuration<br/>.github/"]
        EXTRAS["Extra Materials<br/>extras/, paper/"]
        CRAN_PREP["CRAN Preparation<br/>cran-comments.md, CRAN-SUBMISSION"]
        COVERAGE["Code Coverage<br/>codecov.yml"]
        VIGNETTE_ARTICLES["Vignette Articles<br/>vignettes/articles"]
    end
    
    subgraph "Build Process"
        RBUILDIGNORE[".Rbuildignore<br/>Exclusion Rules"]
    end
    
    subgraph "Built Package"
        CORE_PKG["Core Package Files<br/>R/, man/, DESCRIPTION<br/>NAMESPACE, inst/"]
    end
    
    RPROJ --> RBUILDIGNORE
    LICENSE_FILES --> RBUILDIGNORE
    DEV_DOCS --> RBUILDIGNORE
    PKGDOWN_CONFIG --> RBUILDIGNORE
    GITHUB_CONFIG --> RBUILDIGNORE
    EXTRAS --> RBUILDIGNORE
    CRAN_PREP --> RBUILDIGNORE
    COVERAGE --> RBUILDIGNORE
    VIGNETTE_ARTICLES --> RBUILDIGNORE
    
    RBUILDIGNORE --> CORE_PKG
```

**Sources:** [.Rbuildignore:1-18]()

### Package Metadata Configuration

The package is configured with comprehensive metadata including author information, maintainer details, and links to documentation and issue tracking:

| Field | Configuration |
|-------|--------------|
| Maintainer | Marti Catala (marti.catalasabate@ndorms.ox.ac.uk) |
| Primary Authors | Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora |
| Contributors | Xintong Li, Xihang Chen |
| Documentation | https://darwin-eu.github.io/PatientProfiles/ |
| Issue Tracker | https://github.com/darwin-eu/PatientProfiles/issues |
| Package Logo | Configured for HTML documentation display |

**Sources:** [man/PatientProfiles-package.Rd:7-41]()

## Distribution Configuration

### CRAN Preparation

The package is configured for CRAN distribution with standard quality checks:

```mermaid
flowchart LR
    subgraph "Quality Checks"
        CMD_CHECK["R CMD check<br/>0 errors, 0 warnings, 0 notes"]
        CRAN_COMMENTS["cran-comments.md<br/>Submission Notes"]
    end
    
    subgraph "CRAN Submission"
        NEW_RELEASE["New Release Status<br/>First CRAN Submission"]
        SUBMISSION_RECORD["CRAN-SUBMISSION<br/>Tracking File"]
    end
    
    CMD_CHECK --> NEW_RELEASE
    CRAN_COMMENTS --> NEW_RELEASE
    NEW_RELEASE --> SUBMISSION_RECORD
```

**Sources:** [cran-comments.md:1-6](), [.Rbuildignore:16]()

## Documentation Configuration

### Spell Checking

The package includes a comprehensive wordlist for spell checking technical terms and domain-specific vocabulary:

```mermaid
graph TD
    subgraph "Technical Vocabulary"
        OMOP_TERMS["OMOP CDM Terms<br/>CDM, OMOP, Postgres"]
        FUNC_NAMES["Function Names<br/>addCohortIntersect*<br/>addTableIntersect<br/>summariseCharacteristics"]
        PEOPLE_NAMES["Author Names<br/>Besora, Guell, Mercade"]
        TECH_TERMS["Technical Terms<br/>tibble, ggplot, magrittr<br/>lifecycle, cli"]
    end
    
    subgraph "Configuration"
        WORDLIST["inst/WORDLIST<br/>Spell Check Dictionary"]
    end
    
    OMOP_TERMS --> WORDLIST
    FUNC_NAMES --> WORDLIST
    PEOPLE_NAMES --> WORDLIST
    TECH_TERMS --> WORDLIST
```

The wordlist contains 64 approved terms covering OMOP CDM vocabulary, function names, author names, and R ecosystem packages.

**Sources:** [inst/WORDLIST:1-65]()

## Version Control Configuration

### Git Exclusions

The `.gitignore` configuration excludes build artifacts, temporary files, and generated documentation:

```mermaid
flowchart TD
    subgraph "Development Artifacts"
        R_HISTORY["R History<br/>.Rhistory, .Rapp.history"]
        SESSION_DATA["Session Data<br/>.RData, .RDataTmp"]
        USER_FILES["User-specific<br/>.Ruserdata, .Rproj.user"]
        TEMP_FILES["Temporary Files<br/>*_cache/, *.utf8.md"]
    end
    
    subgraph "Build Outputs"
        TAR_GZ["Package Archive<br/>*.tar.gz"]
        CHECK_OUTPUT["Check Output<br/>*.Rcheck/"]
        VIGNETTE_OUTPUT["Vignette Output<br/>vignettes/*.html, vignettes/*.pdf"]
    end
    
    subgraph "Generated Documentation"
        PKGDOWN_SITE["pkgdown Site<br/>docs/"]
        INST_DOC["Generated Docs<br/>inst/doc, /doc/, /Meta/"]
    end
    
    subgraph "Version Control"
        GITIGNORE[".gitignore<br/>Exclusion Rules"]
    end
    
    R_HISTORY --> GITIGNORE
    SESSION_DATA --> GITIGNORE
    USER_FILES --> GITIGNORE
    TEMP_FILES --> GITIGNORE
    TAR_GZ --> GITIGNORE
    CHECK_OUTPUT --> GITIGNORE
    VIGNETTE_OUTPUT --> GITIGNORE
    PKGDOWN_SITE --> GITIGNORE
    INST_DOC --> GITIGNORE
```

**Sources:** [.gitignore:1-59]()

### Vignette Management

Vignettes have additional version control configuration to exclude generated HTML and R files:

```mermaid
graph LR
    subgraph "Vignette Sources"
        VIG_RMD["*.Rmd Files<br/>Source Vignettes"]
    end
    
    subgraph "Generated Files"
        VIG_HTML["*.html Files<br/>Rendered Output"]
        VIG_R["*.R Files<br/>Extracted Code"]
    end
    
    subgraph "Version Control"
        VIG_GITIGNORE["vignettes/.gitignore<br/>Local Exclusions"]
    end
    
    VIG_HTML --> VIG_GITIGNORE
    VIG_R --> VIG_GITIGNORE
    
    VIG_RMD -.-> VIG_HTML
    VIG_RMD -.-> VIG_R
```

**Sources:** [vignettes/.gitignore:1-3]()

## Quality Assurance Integration

The package configuration integrates with multiple quality assurance systems:

| System | Configuration | Purpose |
|--------|---------------|---------|
| `codecov.yml` | Code coverage reporting | Excluded from package build |
| GitHub Actions | CI/CD workflows in `.github/` | Excluded from package build |
| R CMD check | Standard package validation | Documented in `cran-comments.md` |
| Spell checking | Custom wordlist in `inst/WORDLIST` | Domain-specific vocabulary |

The configuration ensures that quality assurance infrastructure remains available for development while being excluded from the distributed package to minimize size and complexity.

**Sources:** [.Rbuildignore:11](), [.Rbuildignore:15](), [cran-comments.md:1-6](), [inst/WORDLIST:1-65]()