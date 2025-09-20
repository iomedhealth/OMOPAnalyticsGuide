# Package index • omopgenerics

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Package index

### Methods

General methods deffined by omopgenerics

`[attrition()](attrition.html)`
    Get attrition from an object.

`[bind()](bind.html)`
    Bind two or more objects of the same class.

`[settings()](settings.html)`
    Get settings from an object.

`[suppress()](suppress.html)`
    Function to suppress counts in result objects

### Create new objects

To create new omopgenerics S3 classes objects

`[newAchillesTable()](newAchillesTable.html)`
    Create an achilles table from a cdm_table.

`[newCdmReference()](newCdmReference.html)`
    `cdm_reference` objects constructor

`[newCdmSource()](newCdmSource.html)`
    Create a cdm source object.

`[newCdmTable()](newCdmTable.html)`
    Create an cdm table.

`[newCodelist()](newCodelist.html)`
    'codelist' object constructor

`[newCodelistWithDetails()](newCodelistWithDetails.html)`
    'codelist' object constructor

`[newCohortTable()](newCohortTable.html)`
    `cohort_table` objects constructor.

`[newConceptSetExpression()](newConceptSetExpression.html)`
    'concept_set_expression' object constructor

`[newLocalSource()](newLocalSource.html)`
    A new local source for the cdm

`[newOmopTable()](newOmopTable.html)`
    Create an omop table from a cdm table.

`[newSummarisedResult()](newSummarisedResult.html)`
    'summarised_results' object constructor

### Creates empty objects

To create empty omopgenerics S3 classes objects

`[emptyAchillesTable()](emptyAchillesTable.html)`
    Create an empty achilles table

`[emptyCdmReference()](emptyCdmReference.html)`
    Create an empty cdm_reference

`[emptyCodelist()](emptyCodelist.html)`
    Empty `codelist` object.

`[emptyCodelistWithDetails()](emptyCodelistWithDetails.html)`
    Empty `codelist` object.

`[emptyCohortTable()](emptyCohortTable.html)`
    Create an empty cohort_table object

`[emptyConceptSetExpression()](emptyConceptSetExpression.html)`
    Empty `concept_set_expression` object.

`[emptyOmopTable()](emptyOmopTable.html)`
    Create an empty omop table

`[emptySummarisedResult()](emptySummarisedResult.html)`
    Empty `summarised_result` object.

### cdm_reference utility functions

Utility functions for cdm_reference objects

`[cdmClasses()](cdmClasses.html)`
    Separate the cdm tables in classes

`[cdmDisconnect()](cdmDisconnect.html)`
    Disconnect from a cdm object.

`[cdmFromTables()](cdmFromTables.html)`
    Create a cdm object from local tables

`[cdmName()](cdmName.html)`
    Get the name of a cdm_reference associated object

`[cdmReference()](cdmReference.html)`
    Get the `cdm_reference` of a `cdm_table`.

`[cdmSelect()](cdmSelect.html)`
    Restrict the cdm object to a subset of tables.

`[cdmSource()](cdmSource.html)`
    Get the cdmSource of an object.

`[cdmSourceType()](cdmSourceType.html)` deprecated
    Get the source type of a cdm_reference object.

`[cdmTableFromSource()](cdmTableFromSource.html)`
    This is an internal developer focused function that creates a cdm_table from a table that shares the source but it is not a cdm_table. Please use insertTable if you want to insert a table to a cdm_reference object.

`[cdmVersion()](cdmVersion.html)`
    Get the version of an object.

`[listSourceTables()](listSourceTables.html)`
    List tables that can be accessed though a cdm object.

`[dropSourceTable()](dropSourceTable.html)`
    Drop a table from a cdm object.

`[insertTable()](insertTable.html)`
    Insert a table to a cdm object.

`[readSourceTable()](readSourceTable.html)`
    Read a table from the cdm_source and add it to to the cdm.

`[insertCdmTo()](insertCdmTo.html)`
    Insert a cdm_reference object to a different source.

`[getPersonIdentifier()](getPersonIdentifier.html)`
    Get the column name with the person identifier from a table (either subject_id or person_id), it will throw an error if it contains both or neither.

`[`$`(_< cdm_reference>_)](cash-.cdm_reference.html)`
    Subset a cdm reference object.

`[`$<-`(_< cdm_reference>_)](cash-set-.cdm_reference.html)`
    Assign an table to a cdm reference.

`[collect(_< cdm_reference>_)](collect.cdm_reference.html)`
    Retrieves the cdm reference into a local cdm.

`[print(_< cdm_reference>_)](print.cdm_reference.html)`
    Print a CDM reference object

`[`[[`(_< cdm_reference>_)](sub-sub-.cdm_reference.html)`
    Subset a cdm reference object.

`[`[[<-`(_< cdm_reference>_)](sub-subset-.cdm_reference.html)`
    Assign a table to a cdm reference.

`[summary(_< cdm_reference>_)](summary.cdm_reference.html)`
    Summary a cdm reference

`[summary(_< cdm_source>_)](summary.cdm_source.html)`
    Summarise a `cdm_source` object

### cdm_table utility functions

Utility functions for cdm_table objects

`[tableName()](tableName.html)`
    Get the table name of a `cdm_table`.

`[tableSource()](tableSource.html)`
    Get the table source of a `cdm_table`.

`[numberRecords()](numberRecords.html)`
    Count the number of records that a `cdm_table` has.

`[numberSubjects()](numberSubjects.html)`
    Count the number of subjects that a `cdm_table` has.

`[compute(_< cdm_table>_)](compute.cdm_table.html)`
    Store results in a table.

### omop_table utility functions

Utility functions for omop_table objects

`[omopColumns()](omopColumns.html)`
    Required columns that the standard tables in the OMOP Common Data Model must have.

`[omopDataFolder()](omopDataFolder.html)`
    Check or set the OMOP_DATA_FOLDER where the OMOP related data is stored.

`[omopTableFields()](omopTableFields.html)`
    Return a table of omop cdm fields informations

`[omopTables()](omopTables.html)`
    Standard tables that a cdm reference can contain in the OMOP Common Data Model.

### achilles_table utility functions

Utility functions for achilles_table objects

`[achillesColumns()](achillesColumns.html)`
    Required columns for each of the achilles result tables

`[achillesTables()](achillesTables.html)`
    Names of the tables that contain the results of achilles analyses

### cohort_table utility functions

Utility functions for cohort_table objects

`[cohortCodelist()](cohortCodelist.html)`
    Get codelist from a cohort_table object.

`[cohortColumns()](cohortColumns.html)`
    Required columns for a generated cohort set.

`[cohortCount()](cohortCount.html)`
    Get cohort counts from a cohort_table object.

`[cohortTables()](cohortTables.html)`
    Cohort tables that a cdm reference can contain in the OMOP Common Data Model.

`[getCohortId()](getCohortId.html)`
    Get the cohort definition id of a certain name

`[getCohortName()](getCohortName.html)`
    Get the cohort name of a certain cohort definition id

`[recordCohortAttrition()](recordCohortAttrition.html)`
    Update cohort attrition.

`[attrition(_< cohort_table>_)](attrition.cohort_table.html)`
    Get cohort attrition from a cohort_table object.

`[bind(_< cohort_table>_)](bind.cohort_table.html)`
    Bind two or more cohort tables

`[collect(_< cohort_table>_)](collect.cohort_table.html)`
    To collect a `cohort_table` object.

`[settings(_< cohort_table>_)](settings.cohort_table.html)`
    Get cohort settings from a cohort_table object.

`[summary(_< cohort_table>_)](summary.cohort_table.html)`
    Summary a generated cohort set

### summarised_result utility functions

Utility functions for summarised_result objects

`[transformToSummarisedResult()](transformToSummarisedResult.html)`
    Create a <summarised_result> object from a data.frame, given a set of specifications.

`[exportSummarisedResult()](exportSummarisedResult.html)`
    Export a summarised_result object to a csv file.

`[importSummarisedResult()](importSummarisedResult.html)`
    Import a set of summarised results.

`[estimateTypeChoices()](estimateTypeChoices.html)`
    Choices that can be present in `estimate_type` column.

`[resultColumns()](resultColumns.html)`
    Required columns that the result tables must have.

`[resultPackageVersion()](resultPackageVersion.html)`
    Check if different packages version are used for summarise_results object

`[isResultSuppressed()](isResultSuppressed.html)`
    To check whether an object is already suppressed to a certain min cell count.

`[bind(_< summarised_result>_)](bind.summarised_result.html)`
    Bind two or summarised_result objects

`[settings(_< summarised_result>_)](settings.summarised_result.html)`
    Get settings from a summarised_result object.

`[summary(_< summarised_result>_)](summary.summarised_result.html)`
    Summary a summarised_result

`[suppress(_< summarised_result>_)](suppress.summarised_result.html)`
    Function to suppress counts in result objects

`[tidy(_< summarised_result>_)](tidy.summarised_result.html)` experimental
    Turn a `<summarised_result>` object into a tidy tibble

`[filterAdditional()](filterAdditional.html)`
    Filter the additional_name-additional_level pair in a summarised_result

`[filterGroup()](filterGroup.html)`
    Filter the group_name-group_level pair in a summarised_result

`[filterSettings()](filterSettings.html)`
    Filter a `<summarised_result>` using the settings

`[filterStrata()](filterStrata.html)`
    Filter the strata_name-strata_level pair in a summarised_result

`[splitAdditional()](splitAdditional.html)`
    Split additional_name and additional_level columns

`[splitAll()](splitAll.html)`
    Split all pairs name-level into columns.

`[splitGroup()](splitGroup.html)`
    Split group_name and group_level columns

`[splitStrata()](splitStrata.html)`
    Split strata_name and strata_level columns

`[uniteAdditional()](uniteAdditional.html)`
    Unite one or more columns in additional_name-additional_level format

`[uniteGroup()](uniteGroup.html)`
    Unite one or more columns in group_name-group_level format

`[uniteStrata()](uniteStrata.html)`
    Unite one or more columns in strata_name-strata_level format

`[strataColumns()](strataColumns.html)`
    Identify variables in strata_name column

`[additionalColumns()](additionalColumns.html)`
    Identify variables in additional_name column

`[groupColumns()](groupColumns.html)`
    Identify variables in group_name column

`[settingsColumns()](settingsColumns.html)`
    Identify settings columns of a `<summarised_result>`

`[tidyColumns()](tidyColumns.html)`
    Identify tidy columns of a `<summarised_result>`

`[pivotEstimates()](pivotEstimates.html)`
    Set estimates as columns

`[addSettings()](addSettings.html)`
    Add settings columns to a `<summarised_result>` object

### codelist utility functions

Utility functions for codelist objects

`[exportCodelist()](exportCodelist.html)`
    Export a codelist object.

`[exportConceptSetExpression()](exportConceptSetExpression.html)`
    Export a concept set expression.

`[importCodelist()](importCodelist.html)`
    Import a codelist.

`[importConceptSetExpression()](importConceptSetExpression.html)`
    Import a concept set expression.

`[print(_< codelist>_)](print.codelist.html)`
    Print a codelist

`[print(_< codelist_with_details>_)](print.codelist_with_details.html)`
    Print a codelist with details

`[print(_< conceptSetExpression>_)](print.conceptSetExpression.html)`
    Print a concept set expression

### Work with indexes

Methods and functions to work with indexes in database backends.

`[existingIndexes()](existingIndexes.html)` experimental
    Existing indexes in a cdm object

`[expectedIndexes()](expectedIndexes.html)` experimental
    Expected indexes in a cdm object

`[statusIndexes()](statusIndexes.html)` experimental
    Status of the indexes

`[createIndexes()](createIndexes.html)` experimental
    Create the missing indexes

`[createTableIndex()](createTableIndex.html)` experimental
    Create a table index

### Argument validation

To validate input arguments of the functions

`[validateAchillesTable()](validateAchillesTable.html)`
    Validate if a cdm_table is a valid achilles table.

`[validateAgeGroupArgument()](validateAgeGroupArgument.html)`
    Validate the ageGroup argument. It must be a list of two integerish numbers lower age and upper age, both of the must be greater or equal to 0 and lower age must be lower or equal to the upper age. If not named automatic names will be given in the output list.

`[validateCdmArgument()](validateCdmArgument.html)`
    Validate if an object in a valid cdm_reference.

`[validateCdmTable()](validateCdmTable.html)`
    Validate if a table is a valid cdm_table object.

`[validateCohortArgument()](validateCohortArgument.html)`
    Validate a cohort table input.

`[validateCohortIdArgument()](validateCohortIdArgument.html)`
    Validate cohortId argument. CohortId can either be a cohort_definition_id value, a cohort_name or a tidyselect expression referinc to cohort_names. If you want to support tidyselect expressions please use the function as: `validateCohortIdArgument({{cohortId}}, cohort)`.

`[validateColumn()](validateColumn.html)`
    Validate whether a variable points to a certain exiting column in a table.

`[validateConceptSetArgument()](validateConceptSetArgument.html)`
    Validate conceptSet argument. It can either be a list, a codelist, a concept set expression or a codelist with details. The output will always be a codelist.

`[validateNameArgument()](validateNameArgument.html)`
    Validate name argument. It must be a snake_case character vector. You can add the a cdm object to check `name` is not already used in that cdm.

`[validateNameLevel()](validateNameLevel.html)`
    Validate if two columns are valid Name-Level pair.

`[validateNameStyle()](validateNameStyle.html)`
    Validate `nameStyle` argument. If any of the element in `...` has length greater than 1 it must be contained in nameStyle. Note that snake case notation is used.

`[validateNewColumn()](validateNewColumn.html)`
    Validate a new column of a table

`[validateOmopTable()](validateOmopTable.html)`
    Validate an omop_table

`[validateResultArgument()](validateResultArgument.html)`
    Validate if a an object is a valid 'summarised_result' object.

`[validateStrataArgument()](validateStrataArgument.html)`
    To validate a strata list. It makes sure that elements are unique and point to columns in table.

`[validateWindowArgument()](validateWindowArgument.html)`
    Validate a window argument. It must be a list of two elements (window start and window end), both must be integerish and window start must be lower or equal than window end.

### General assertions

To assert that an object fulfills certain criteria

`[assertCharacter()](assertCharacter.html)`
    Assert that an object is a character and fulfill certain conditions.

`[assertChoice()](assertChoice.html)`
    Assert that an object is within a certain oprtions.

`[assertClass()](assertClass.html)`
    Assert that an object has a certain class.

`[assertDate()](assertDate.html)`
    Assert Date

`[assertList()](assertList.html)`
    Assert that an object is a list.

`[assertLogical()](assertLogical.html)`
    Assert that an object is a logical.

`[assertNumeric()](assertNumeric.html)`
    Assert that an object is a numeric.

`[assertTable()](assertTable.html)`
    Assert that an object is a table.

`[assertTrue()](assertTrue.html)`
    Assert that an expression is TRUE.

### Utility functions

`[insertFromSource()](insertFromSource.html)` deprecated
    Convert a table that is not a cdm_table but have the same original source to a cdm_table. This Table is not meant to be used to insert tables in the cdm, please use insertTable instead.

`[sourceType()](sourceType.html)`
    Get the source type of an object.

`[tmpPrefix()](tmpPrefix.html)`
    Create a temporary prefix for tables, that contains a unique prefix that starts with tmp.

`[uniqueId()](uniqueId.html)`
    Get a unique Identifier with a certain number of characters and a prefix.

`[uniqueTableName()](uniqueTableName.html)`
    Create a unique table name

`[isTableEmpty()](isTableEmpty.html)`
    Check if a table is empty or not

`[toSnakeCase()](toSnakeCase.html)`
    Convert a character vector to snake case

`[combineStrata()](combineStrata.html)`
    Provide all combinations of strata levels.

`[createLogFile()](createLogFile.html)`
    Create a log file

`[logMessage()](logMessage.html)`
    Log a message to a logFile

`[summariseLogFile()](summariseLogFile.html)`
    Summarise and extract the information of a log file into a `summarised_result` object.

### Deprecated

Deprecated function that will be eliminated in future releases of the package

`[checkCohortRequirements()](checkCohortRequirements.html)` deprecated
    Check whether a cohort table satisfies requirements

`[dropTable()](dropTable.html)` deprecated
    Drop a table from a cdm object. [![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
