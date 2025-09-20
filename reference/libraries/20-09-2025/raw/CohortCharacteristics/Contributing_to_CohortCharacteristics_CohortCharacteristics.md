# Contributing to CohortCharacteristics • CohortCharacteristics

Skip to contents

[CohortCharacteristics](index.html) 1.0.0

  * [Reference](reference/index.html)
  * Articles
    * [Summarise cohort entries](articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](articles/summarise_cohort_timing.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](logo.png)

# Contributing to CohortCharacteristics

Source: [`.github/CONTRIBUTING.md`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/.github/CONTRIBUTING.md)

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated. Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

### Documenting the package

Run the below to update and check package documentation:
    
    
    devtools::document() 
    devtools::run_examples()
    devtools::build_readme()
    devtools::build_vignettes()
    devtools::check_man()

Note that `devtools::check_man()` should not return any warnings. If your commit is limited to only package documentation, running the above should be sufficient (although running `devtools::check()` will always generally be a good idea before submitting a pull request.

### Run tests

Before starting to contribute any code, first make sure the package tests are all passing. If not raise an issue before going any further (although please first make sure you have all the packages from imports and suggests installed). As you then contribute code, make sure that all the current tests and any you add continue to pass. All package tests can be run together with:
    
    
    devtools::test()

Code to add new functionality should be accompanied by tests. Code coverage can be checked using:
    
    
    # note, you may first have to detach the package
    # detach("package:CohortCharacteristics", unload=TRUE)
    devtools::test_coverage()

### Adhere to code style

Please adhere to the code style when adding any new code. Do not though restyle any code unrelated to your pull request as this will make code review more difficult.
    
    
    lintr::lint_package(".",
                        linters = lintr::linters_with_defaults(
                          lintr::object_name_linter(styles = "camelCase")
                        )
    )

### Run check() before opening a pull request

Before opening any pull request please make sure to run:
    
    
    devtools::check() 

No warnings should be seen.

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
