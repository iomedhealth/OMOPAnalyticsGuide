# Package index • CohortConstructor

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Package index

### Build base cohorts

`[conceptCohort()](conceptCohort.html)`
    Create cohorts based on a concept set

`[deathCohort()](deathCohort.html)`
    Create cohort based on the death table

`[demographicsCohort()](demographicsCohort.html)`
    Create cohorts based on patient demographics

`[measurementCohort()](measurementCohort.html)`
    Create measurement-based cohorts

### Apply cohort table related requirements

`[requireMinCohortCount()](requireMinCohortCount.html)`
    Filter cohorts to keep only records for those with a minimum amount of subjects

`[requireInDateRange()](requireInDateRange.html)`
    Require that an index date is within a date range

`[requireDuration()](requireDuration.html)`
    Require cohort entries last for a certain number of days

`[requireIsFirstEntry()](requireIsFirstEntry.html)`
    Restrict cohort to first entry

`[requireIsLastEntry()](requireIsLastEntry.html)`
    Restrict cohort to last entry per person

`[requireIsEntry()](requireIsEntry.html)`
    Restrict cohort to specific entry

### Impose singular demographic requirements on existing cohorts

`[requireAge()](requireAge.html)`
    Restrict cohort on age

`[requireSex()](requireSex.html)`
    Restrict cohort on sex

`[requirePriorObservation()](requirePriorObservation.html)`
    Restrict cohort on prior observation

`[requireFutureObservation()](requireFutureObservation.html)`
    Restrict cohort on future observation

### Impose multiple demographic requirements on existing cohorts

`[requireDemographics()](requireDemographics.html)`
    Restrict cohort on patient demographics

### Impose requirements of presence or absence in other cohorts, concept sets, or table

`[requireCohortIntersect()](requireCohortIntersect.html)`
    Require cohort subjects are present (or absence) in another cohort

`[requireConceptIntersect()](requireConceptIntersect.html)`
    Require cohort subjects to have (or not have) events of a concept list

`[requireTableIntersect()](requireTableIntersect.html)`
    Require cohort subjects are present in another clinical table

### Update cohort start and end dates

`[entryAtFirstDate()](entryAtFirstDate.html)`
    Update cohort start date to be the first date from of a set of column dates

`[entryAtLastDate()](entryAtLastDate.html)`
    Set cohort start date to the last of a set of column dates

`[exitAtDeath()](exitAtDeath.html)`
    Set cohort end date to death date

`[exitAtFirstDate()](exitAtFirstDate.html)`
    Set cohort end date to the first of a set of column dates

`[exitAtLastDate()](exitAtLastDate.html)`
    Set cohort end date to the last of a set of column dates

`[exitAtObservationEnd()](exitAtObservationEnd.html)`
    Set cohort end date to end of observation

`[padCohortDate()](padCohortDate.html)`
    Set cohort start or cohort end

`[padCohortEnd()](padCohortEnd.html)`
    Add days to cohort end

`[padCohortStart()](padCohortStart.html)`
    Add days to cohort start

`[trimDemographics()](trimDemographics.html)`
    Trim cohort on patient demographics

`[trimToDateRange()](trimToDateRange.html)`
    Trim cohort dates to be within a date range

### Concatanate cohort entries

`[collapseCohorts()](collapseCohorts.html)`
    Collapse cohort entries using a certain gap to concatenate records.

### Filter cohorts

`[subsetCohorts()](subsetCohorts.html)`
    Generate a cohort table keeping a subset of cohorts.

`[sampleCohorts()](sampleCohorts.html)`
    Sample a cohort table for a given number of individuals.

### Copy cohorts

`[copyCohorts()](copyCohorts.html)`
    Copy a cohort table

### Split cohorts

`[yearCohorts()](yearCohorts.html)`
    Generate a new cohort table restricting cohort entries to certain years

`[stratifyCohorts()](stratifyCohorts.html)`
    Create a new cohort table from stratifying an existing one

### Combine cohorts

`[intersectCohorts()](intersectCohorts.html)`
    Generate a combination cohort set between the intersection of different cohorts.

`[unionCohorts()](unionCohorts.html)`
    Generate cohort from the union of different cohorts

### Match cohorts

`[matchCohorts()](matchCohorts.html)`
    Generate a new cohort matched cohort

### Mock data

`[mockCohortConstructor()](mockCohortConstructor.html)`
    Function to create a mock cdm reference for CohortConstructor

### Package benchmark

`[benchmarkCohortConstructor()](benchmarkCohortConstructor.html)`
    Run benchmark of CohortConstructor package

`[benchmarkData](benchmarkData.html)`
    Benchmarking results

### Utility functions

`[renameCohort()](renameCohort.html)`
    Utility function to change the name of a cohort.

`[addCohortTableIndex()](addCohortTableIndex.html)`
    Add an index to a cohort table

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
