# Changelog • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/NEWS.md)

## visOmopResults 1.2.0

CRAN release: 2025-09-02

  * Support `tinytable`
  * Add argument `style` for plots
  * Add function `[setGlobalPlotOptions()](../reference/setGlobalPlotOptions.html)` to set global arguments to plots
  * Add function `[setGlobalTableOptions()](../reference/setGlobalTableOptions.html)` to set global arguments to tables
  * Union borders from merged cells in flextable



## visOmopResults 1.1.1

CRAN release: 2025-06-19

  * Fix that all table types were required to be installed even if not used
  * `columnOrder` when non-table columns passed, throw warning instead of error
  * `columnOrder` when missing table columns adds them at the end instead of throwing error



## visOmopResults 1.1.0

CRAN release: 2025-05-21

  * Support `reactable`
  * Add darwin style



## visOmopResults 1.0.2

CRAN release: 2025-03-06

  * Header pivotting - warning and addition of needed columns to get unique estimates in cells
  * Fixed headers in datatable
  * Show min cell counts only for counts, set the other estimates to NA



## visOmopResults 1.0.1

CRAN release: 2025-02-27

  * Obscure percentage when there are less than five counts
  * `formatMinCellCount` function



## visOmopResults 1.0.0

CRAN release: 2025-01-15

  * Stable release of the package
  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
