# Package index • PatientProfiles

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Package index

### Add individual patient characteristics

Add patient characteristics to a table in the OMOP Common Data Model

`[addAge()](addAge.html)`
    Compute the age of the individuals at a certain date

`[addSex()](addSex.html)`
    Compute the sex of the individuals

`[addDateOfBirth()](addDateOfBirth.html)`
    Add a column with the individual birth date

`[addPriorObservation()](addPriorObservation.html)`
    Compute the number of days of prior observation in the current observation period at a certain date

`[addFutureObservation()](addFutureObservation.html)`
    Compute the number of days till the end of the observation period at a certain date

`[addInObservation()](addInObservation.html)`
    Indicate if a certain record is within the observation period

### Add multiple individual patient characteristics

Add a set of patient characteristics to a table in the OMOP Common Data Model

`[addDemographics()](addDemographics.html)`
    Compute demographic characteristics at a certain date

### Add death information

Add patient death information to a table in the OMOP Common Data Model

`[addDeathDate()](addDeathDate.html)`
    Add date of death for individuals. Only death within the same observation period than `indexDate` will be observed.

`[addDeathDays()](addDeathDays.html)`
    Add days to death for individuals. Only death within the same observation period than `indexDate` will be observed.

`[addDeathFlag()](addDeathFlag.html)`
    Add flag for death for individuals. Only death within the same observation period than `indexDate` will be observed.

### Add a value from a cohort intersection

Add a variable indicating the intersection between a table in the OMOP Common Data Model and a cohort table.

`[addCohortIntersectCount()](addCohortIntersectCount.html)`
    It creates columns to indicate number of occurrences of intersection with a cohort

`[addCohortIntersectDate()](addCohortIntersectDate.html)`
    Date of cohorts that are present in a certain window

`[addCohortIntersectDays()](addCohortIntersectDays.html)`
    It creates columns to indicate the number of days between the current table and a target cohort

`[addCohortIntersectFlag()](addCohortIntersectFlag.html)`
    It creates columns to indicate the presence of cohorts

### Add a value from a concept intersection

Add a variable indicating the intersection between a table in the OMOP Common Data Model and a concept.

`[addConceptIntersectCount()](addConceptIntersectCount.html)`
    It creates column to indicate the count overlap information between a table and a concept

`[addConceptIntersectDate()](addConceptIntersectDate.html)`
    It creates column to indicate the date overlap information between a table and a concept

`[addConceptIntersectDays()](addConceptIntersectDays.html)`
    It creates column to indicate the days of difference from an index date to a concept

`[addConceptIntersectField()](addConceptIntersectField.html)`
    It adds a custom column (field) from the intersection with a certain table subsetted by concept id. In general it is used to add the first value of a certain measurement.

`[addConceptIntersectFlag()](addConceptIntersectFlag.html)`
    It creates column to indicate the flag overlap information between a table and a concept

### Add a value from an omop standard table intersection

Add a variable indicating the intersection between a table in the OMOP Common Data Model and a standard omop table.

`[addTableIntersectCount()](addTableIntersectCount.html)`
    Compute number of intersect with an omop table.

`[addTableIntersectDate()](addTableIntersectDate.html)`
    Compute date of intersect with an omop table.

`[addTableIntersectDays()](addTableIntersectDays.html)`
    Compute time to intersect with an omop table.

`[addTableIntersectField()](addTableIntersectField.html)`
    Intersecting the cohort with columns of an OMOP table of user's choice. It will add an extra column to the cohort, indicating the intersected entries with the target columns in a window of the user's choice.

`[addTableIntersectFlag()](addTableIntersectFlag.html)`
    Compute a flag intersect with an omop table.

### Query functions

These functions add the same information than their analogous add* function but, the result is not computed into a table.

`[addAgeQuery()](addAgeQuery.html)`
    Query to add the age of the individuals at a certain date

`[addDateOfBirthQuery()](addDateOfBirthQuery.html)`
    Query to add a column with the individual birth date

`[addDemographicsQuery()](addDemographicsQuery.html)`
    Query to add demographic characteristics at a certain date

`[addFutureObservationQuery()](addFutureObservationQuery.html)`
    Query to add the number of days till the end of the observation period at a certain date

`[addInObservationQuery()](addInObservationQuery.html)`
    Query to add a new column to indicate if a certain record is within the observation period

`[addObservationPeriodIdQuery()](addObservationPeriodIdQuery.html)`
    Add the ordinal number of the observation period associated that a given date is in. Result is not computed, only query is added.

`[addPriorObservationQuery()](addPriorObservationQuery.html)`
    Query to add the number of days of prior observation in the current observation period at a certain date

`[addSexQuery()](addSexQuery.html)`
    Query to add the sex of the individuals

### Summarise patient characteristics

Function that allow the user to summarise patient characteristics (characteristics must be added priot the use of the function)

`[summariseResult()](summariseResult.html)`
    Summarise variables using a set of estimate functions. The output will be a formatted summarised_result object.

### Suppress counts of a summarised_result object

Function that allow the user to suppress counts and estimates for a certain minCellCount

`[reexports](reexports.html)` `[suppress](reexports.html)` `[settings](reexports.html)`
    Objects exported from other packages

### Create a mock database with OMOP CDM format data

Function that allow the user to create new OMOP CDM mock data

`[mockDisconnect()](mockDisconnect.html)`
    Function to disconnect from the mock

`[mockPatientProfiles()](mockPatientProfiles.html)`
    It creates a mock database for testing PatientProfiles package

### Other functions

Helper functions

`[benchmarkPatientProfiles()](benchmarkPatientProfiles.html)`
    Benchmark intersections and demographics functions for a certain source (cdm).

`[addCohortName()](addCohortName.html)`
    Add cohort name for each cohort_definition_id

`[addConceptName()](addConceptName.html)`
    Add concept name for each concept_id

`[addCdmName()](addCdmName.html)`
    Add cdm name

`[addCategories()](addCategories.html)`
    Categorize a numeric variable

`[addObservationPeriodId()](addObservationPeriodId.html)`
    Add the ordinal number of the observation period associated that a given date is in.

`[filterCohortId()](filterCohortId.html)`
    Filter a cohort according to cohort_definition_id column, the result is not computed into a table. only a query is added. Used usually as internal functions of other packages.

`[filterInObservation()](filterInObservation.html)`
    Filter the rows of a `cdm_table` to the ones in observation that `indexDate` is in observation.

`[variableTypes()](variableTypes.html)`
    Classify the variables between 5 types: "numeric", "categorical", "binary", "date", or NA.

`[availableEstimates()](availableEstimates.html)`
    Show the available estimates that can be used for the different variable_type supported.

`[startDateColumn()](startDateColumn.html)`
    Get the name of the start date column for a certain table in the cdm

`[endDateColumn()](endDateColumn.html)`
    Get the name of the end date column for a certain table in the cdm

`[sourceConceptIdColumn()](sourceConceptIdColumn.html)`
    Get the name of the source concept_id column for a certain table in the cdm

`[standardConceptIdColumn()](standardConceptIdColumn.html)`
    Get the name of the standard concept_id column for a certain table in the cdm

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
