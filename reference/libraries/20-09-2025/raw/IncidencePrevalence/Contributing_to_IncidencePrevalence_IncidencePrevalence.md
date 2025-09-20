# Contributing to IncidencePrevalence • IncidencePrevalence

Skip to contents

[IncidencePrevalence](index.html) 1.2.1

  * [Reference](reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](articles/a07_benchmark.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](logo.png)

# Contributing to IncidencePrevalence

Source: [`.github/CONTRIBUTING.md`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/.github/CONTRIBUTING.md)

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated. Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

## Contributing code or documentation

> This package has been developed as part of the DARWIN EU(R) project and is closed to external contributions.

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
    # detach("package:IncidencePrevalence", unload=TRUE)
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

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
