---
layout: page
title: CDMConnector
parent: R Package Reference
nav_order: 2
---

# CDMConnector

Provides database connectivity and CDM object management for OMOP databases.

## Database Connection Functions

### Connection Management:

- `cdmFromCon(con, cdmSchema, writeSchema, writePrefix)` - Create CDM reference from database connection
- `dbConnect()` - Establish database connections (via DBI)
- `dbDisconnect()` - Close database connections

### Table Operations:

- `insertTable(cdm, name, table)` - Insert local tibble into CDM
- `dropSourceTable(cdm, name)` - Remove tables from CDM and database
- `compute(name, temporary)` - Materialize query results as temporary or permanent tables
- `listSourceTables(cdm)` - List all available source tables

### Mock Data Functions:

- `mockCdmFromDataset(datasetName)` - Create local CDM from synthetic datasets
- `insertCdmTo(cdm, to)` - Copy CDM to database connection
- `availableMockDatasets()` - List available synthetic datasets
