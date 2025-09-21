# Page: Development and Testing

# Development and Testing

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.Rbuildignore](.Rbuildignore)
- [.github/.gitignore](.github/.gitignore)
- [tests/testthat/setup.R](tests/testthat/setup.R)
- [tests/testthat/test-calculateNotApplicableStatus.R](tests/testthat/test-calculateNotApplicableStatus.R)
- [tests/testthat/test-helpers.R](tests/testthat/test-helpers.R)

</details>



This page provides an overview of the development environment and testing infrastructure for the DataQualityDashboard package. It covers the testing framework architecture, development workflow, and key configuration files that support package development and maintenance.

For detailed information about the testing framework and test execution, see [Testing Framework](#9.1). For information about continuous integration and build processes, see [CI/CD and Build Process](#9.2).

## Development Environment Overview

The DataQualityDashboard package uses a comprehensive testing framework built on `testthat` with specialized infrastructure for database testing. The development workflow supports both local development using `devtools` and automated testing through continuous integration.

## Testing Architecture

The testing system is designed to validate data quality checks against real OMOP CDM databases using the Eunomia synthetic dataset:

```mermaid
graph TB
    subgraph "Test Environment Setup"
        SETUP["setup.R<br/>Test Configuration"]
        JDBC_DRIVERS["JDBC Driver Downloads<br/>PostgreSQL, SQL Server, Oracle, Redshift"]
        EUNOMIA_CONN["Eunomia Connection Details<br/>connectionDetailsEunomia"]
        EUNOMIA_NA["Eunomia NA Test Connection<br/>connectionDetailsEunomiaNaChecks"]
    end
    
    subgraph "Test Categories"
        STATUS_TESTS["Status Calculation Tests<br/>test-calculateNotApplicableStatus.R"]
        HELPER_TESTS["Helper Function Tests<br/>test-helpers.R"]
        INTEGRATION_TESTS["Integration Tests<br/>(Multiple test files)"]
    end
    
    subgraph "Test Database Operations"
        TABLE_EMPTY["Empty Table Testing<br/>DELETE FROM DEVICE_EXPOSURE"]
        BACKUP_RESTORE["Table Backup/Restore<br/>CREATE TABLE...BACK AS SELECT"]
        DATA_MANIPULATION["Test Data Setup<br/>INSERT/DELETE operations"]
    end
    
    subgraph "Development Tools"
        DEVTOOLS_SHIM["Devtools SQL Shim<br/>Symbolic link creation"]
        INSTALL_CHECK["Installation Validation<br/>is_installed, ensure_installed"]
        CONNECTION_OBS["Connection Observer<br/>options(connectionObserver = NULL)"]
    end
    
    SETUP --> JDBC_DRIVERS
    SETUP --> EUNOMIA_CONN
    SETUP --> EUNOMIA_NA
    
    EUNOMIA_CONN --> STATUS_TESTS
    EUNOMIA_NA --> STATUS_TESTS
    EUNOMIA_CONN --> HELPER_TESTS
    
    STATUS_TESTS --> TABLE_EMPTY
    STATUS_TESTS --> BACKUP_RESTORE
    STATUS_TESTS --> DATA_MANIPULATION
    
    HELPER_TESTS --> DEVTOOLS_SHIM
    HELPER_TESTS --> INSTALL_CHECK
    HELPER_TESTS --> CONNECTION_OBS
```

Sources: [tests/testthat/setup.R:1-18](), [tests/testthat/test-calculateNotApplicableStatus.R:1-92](), [tests/testthat/test-helpers.R:1-19]()

## Development Workflow

The development process integrates multiple tools and environments to support both local development and package distribution:

```mermaid
graph LR
    subgraph "Local Development"
        DEVTOOLS["devtools::load_all()<br/>devtools::test()"]
        SQL_SHIM["SQL Folder Symbolic Link<br/>R.utils::createLink"]
        LOCAL_TEST["Local Test Execution<br/>testthat framework"]
    end
    
    subgraph "Package Build System"
        RBUILDIGNORE[".Rbuildignore<br/>Build exclusions"]
        PACKAGE_ROOT["Package Root<br/>system.file detection"]
        BUILD_ARTIFACTS["Build Artifacts<br/>Excluded files/folders"]
    end
    
    subgraph "CI/CD Environment"
        GITHUB_CONFIG[".github/.gitignore<br/>CI artifacts"]
        JDBC_ENV["JDBC Driver Management<br/>DONT_DOWNLOAD_JDBC_DRIVERS"]
        JAR_FOLDER["Driver Location<br/>DATABASECONNECTOR_JAR_FOLDER"]
    end
    
    subgraph "Database Testing Infrastructure"
        EUNOMIA_DB["Eunomia Test Database<br/>Synthetic OMOP CDM"]
        DRIVER_DOWNLOAD["downloadJdbcDrivers<br/>Multiple DB platforms"]
        CONNECTION_MGMT["Connection Management<br/>connect/disconnect patterns"]
    end
    
    DEVTOOLS --> SQL_SHIM
    DEVTOOLS --> LOCAL_TEST
    SQL_SHIM --> PACKAGE_ROOT
    
    RBUILDIGNORE --> BUILD_ARTIFACTS
    PACKAGE_ROOT --> BUILD_ARTIFACTS
    
    GITHUB_CONFIG --> JDBC_ENV
    JDBC_ENV --> JAR_FOLDER
    JAR_FOLDER --> DRIVER_DOWNLOAD
    
    LOCAL_TEST --> EUNOMIA_DB
    DRIVER_DOWNLOAD --> EUNOMIA_DB
    EUNOMIA_DB --> CONNECTION_MGMT
```

Sources: [tests/testthat/test-helpers.R:9-17](), [tests/testthat/setup.R:1-10](), [.Rbuildignore:1-13](), [.github/.gitignore:1-2]()

## Key Testing Components

### Test Setup and Configuration

The testing infrastructure is initialized through `setup.R`, which handles:

| Component | Purpose | Configuration |
|-----------|---------|---------------|
| JDBC Drivers | Database connectivity | Downloads drivers for PostgreSQL, SQL Server, Oracle, Redshift |
| Eunomia Connections | Test database access | `connectionDetailsEunomia`, `cdmDatabaseSchemaEunomia` |
| NA Test Connections | Isolated testing environment | `connectionDetailsEunomiaNaChecks` for destructive tests |

### Test Categories

The test suite includes several specialized test categories:

- **Status Calculation Tests**: Validate `calculateNotApplicableStatus` logic with empty tables and missing data scenarios
- **Helper Function Tests**: Test utility functions like `is_installed` and `ensure_installed`
- **Integration Tests**: Full workflow testing using `executeDqChecks` with various parameter combinations

### Database Test Patterns

The testing framework employs sophisticated database manipulation patterns:

```mermaid
graph TD
    subgraph "Test Data Manipulation Patterns"
        BACKUP["Table Backup<br/>CREATE TABLE X_BACK AS SELECT * FROM X"]
        DELETE_DATA["Remove Test Data<br/>DELETE FROM table_name"]
        EXECUTE_TEST["Run DQ Checks<br/>executeDqChecks()"]
        RESTORE["Restore Data<br/>INSERT INTO X SELECT * FROM X_BACK"]
        CLEANUP["Clean Up<br/>DROP TABLE X_BACK"]
    end
    
    subgraph "Test Validation"
        CHECK_NA["Validate Not Applicable<br/>expect_true(r$notApplicable == 1)"]
        CHECK_FAILED["Validate Failed Status<br/>expect_true(r$failed == 1)"]
        RESULT_FILTER["Filter Results<br/>checkName, tableName conditions"]
    end
    
    BACKUP --> DELETE_DATA
    DELETE_DATA --> EXECUTE_TEST
    EXECUTE_TEST --> RESULT_FILTER
    RESULT_FILTER --> CHECK_NA
    RESULT_FILTER --> CHECK_FAILED
    EXECUTE_TEST --> RESTORE
    RESTORE --> CLEANUP
```

Sources: [tests/testthat/test-calculateNotApplicableStatus.R:33-58](), [tests/testthat/test-calculateNotApplicableStatus.R:65-91]()

## Development Tools and Configuration

### Package Build Configuration

The `.Rbuildignore` file excludes development and documentation files from the built package:

- Project files (`.Rproj`, `.Rproj.user`)
- Development directories (`extras`, `man-roxygen`, `docs`)
- Version control (`.git`)
- CI/CD configuration (`.github`)
- Documentation artifacts (`inst/doc/*.pdf`)

### Development Environment Detection

The testing framework includes special handling for development environments:

- Detects `devtools::load_all()` usage through `DEVTOOLS_LOAD` environment variable
- Creates symbolic links for SQL resources when running in development mode
- Sets `use.devtools.sql_shim` option for development-specific behavior

Sources: [tests/testthat/test-helpers.R:11-17](), [.Rbuildignore:1-13]()

## Environment Variables and Configuration

The system uses several environment variables to control testing behavior:

| Variable | Purpose | Values |
|----------|---------|---------|
| `DONT_DOWNLOAD_JDBC_DRIVERS` | Skip JDBC driver downloads | `"TRUE"` to skip |
| `DATABASECONNECTOR_JAR_FOLDER` | Pre-existing driver location | Path to JAR files |
| `DEVTOOLS_LOAD` | Development mode detection | `"true"` when using devtools |

Sources: [tests/testthat/setup.R:1-10](), [tests/testthat/test-helpers.R:11-12]()