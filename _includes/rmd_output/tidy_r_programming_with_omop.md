
This RMD contains the code examples from the Tidyverse and OMOP CDM
guide.

## Chapter 1: A first analysis using data in a database

``` r
# Load the libraries
library(dplyr)
library(dbplyr)
library(ggplot2)
library(DBI)
library(duckdb)
```

### Inserting Data into a Database

``` r
# Create an in-memory duckdb database
db <- dbConnect(drv = duckdb())

# Write the iris dataframe to a table named "iris" in the database
dbWriteTable(db, "iris", iris)

# You can see the tables in the database
dbListTables(db)
```

    ## [1] "iris"

### From R to SQL: The Power of `dbplyr`

``` r
# Create a reference to the `iris` table in the database
iris_db <- tbl(db, "iris")

# Get a summary of sepal length by species
iris_db |>
  group_by(Species) |>
  summarise(
    n = n(),
    mean_sepal_length = mean(Sepal.Length, na.rm = TRUE)
  )
```

    ## # Source:   SQL [?? x 3]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##   Species        n mean_sepal_length
    ##   <fct>      <dbl>             <dbl>
    ## 1 setosa        50              5.01
    ## 2 versicolor    50              5.94
    ## 3 virginica     50              6.59

### Bringing Data into R for Visualization

``` r
iris_db |>
  select("Species", "Sepal.Length") |>
  collect() |> # This brings the data from the database into an R dataframe
  ggplot(aes(x = `Sepal.Length`, fill = Species)) +
  geom_histogram(binwidth = 0.2, colour = "black") +
  facet_wrap(~Species, ncol = 1) +
  theme_bw()
```

![](/assets/images/rmd_output/visualization-1.png)<!-- -->

### Disconnecting from the Database

``` r
dbDisconnect(db)
```

## Chapter 2: Core verbs for analytic pipelines utilising a database

``` r
# Create database
db <- dbConnect(duckdb())

# Split iris into two tables: species info and measurements
species_info <- iris |> select(Species) |> distinct() |> mutate(species_id = row_number())
measurements <- iris |> left_join(species_info, by = "Species")

# Write tables
dbWriteTable(db, "species_info", species_info)
dbWriteTable(db, "measurements", measurements)

# Create lazy references
species_db <- tbl(db, "species_info")
measurements_db <- tbl(db, "measurements")
```

### Selecting Rows: `filter()` and `distinct()`

``` r
measurements_db |>
  filter(Sepal.Length > 5) |>
  select(Species, Sepal.Length)
```

    ## # Source:   SQL [?? x 2]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##    Species Sepal.Length
    ##    <fct>          <dbl>
    ##  1 setosa           5.1
    ##  2 setosa           5.4
    ##  3 setosa           5.4
    ##  4 setosa           5.8
    ##  5 setosa           5.7
    ##  6 setosa           5.4
    ##  7 setosa           5.1
    ##  8 setosa           5.7
    ##  9 setosa           5.1
    ## 10 setosa           5.4
    ## # ℹ more rows

``` r
measurements_db |>
  distinct(Species)
```

    ## # Source:   SQL [?? x 1]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##   Species   
    ##   <fct>     
    ## 1 setosa    
    ## 2 versicolor
    ## 3 virginica

### Ordering Rows: `arrange()`

``` r
measurements_db |>
  arrange(desc(Sepal.Length)) |>
  select(Species, Sepal.Length)
```

    ## # Source:     SQL [?? x 2]
    ## # Database:   DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ## # Ordered by: desc(Sepal.Length)
    ##    Species   Sepal.Length
    ##    <fct>            <dbl>
    ##  1 virginica          7.9
    ##  2 virginica          7.7
    ##  3 virginica          7.7
    ##  4 virginica          7.7
    ##  5 virginica          7.7
    ##  6 virginica          7.6
    ##  7 virginica          7.4
    ##  8 virginica          7.3
    ##  9 virginica          7.2
    ## 10 virginica          7.2
    ## # ℹ more rows

### Column Transformation: `mutate()`, `select()`, `rename()`

``` r
measurements_db |>
  mutate(
    sepal_ratio = Sepal.Length / Sepal.Width,
    is_large = Sepal.Length > 6
  ) |>
  select(Species, sepal_ratio, is_large)
```

    ## # Source:   SQL [?? x 3]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##    Species sepal_ratio is_large
    ##    <fct>         <dbl> <lgl>   
    ##  1 setosa         1.46 FALSE   
    ##  2 setosa         1.63 FALSE   
    ##  3 setosa         1.47 FALSE   
    ##  4 setosa         1.48 FALSE   
    ##  5 setosa         1.39 FALSE   
    ##  6 setosa         1.38 FALSE   
    ##  7 setosa         1.35 FALSE   
    ##  8 setosa         1.47 FALSE   
    ##  9 setosa         1.52 FALSE   
    ## 10 setosa         1.58 FALSE   
    ## # ℹ more rows

``` r
measurements_db |>
  select(Species, Sepal.Length, Petal.Length)
```

    ## # Source:   SQL [?? x 3]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##    Species Sepal.Length Petal.Length
    ##    <fct>          <dbl>        <dbl>
    ##  1 setosa           5.1          1.4
    ##  2 setosa           4.9          1.4
    ##  3 setosa           4.7          1.3
    ##  4 setosa           4.6          1.5
    ##  5 setosa           5            1.4
    ##  6 setosa           5.4          1.7
    ##  7 setosa           4.6          1.4
    ##  8 setosa           5            1.5
    ##  9 setosa           4.4          1.4
    ## 10 setosa           4.9          1.5
    ## # ℹ more rows

``` r
measurements_db |>
  rename(sepal_length = Sepal.Length)
```

    ## # Source:   SQL [?? x 6]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##    sepal_length Sepal.Width Petal.Length Petal.Width Species species_id
    ##           <dbl>       <dbl>        <dbl>       <dbl> <fct>        <int>
    ##  1          5.1         3.5          1.4         0.2 setosa           1
    ##  2          4.9         3            1.4         0.2 setosa           1
    ##  3          4.7         3.2          1.3         0.2 setosa           1
    ##  4          4.6         3.1          1.5         0.2 setosa           1
    ##  5          5           3.6          1.4         0.2 setosa           1
    ##  6          5.4         3.9          1.7         0.4 setosa           1
    ##  7          4.6         3.4          1.4         0.3 setosa           1
    ##  8          5           3.4          1.5         0.2 setosa           1
    ##  9          4.4         2.9          1.4         0.2 setosa           1
    ## 10          4.9         3.1          1.5         0.1 setosa           1
    ## # ℹ more rows

### Grouping and Aggregation: `group_by()`, `summarise()`, `count()`

``` r
measurements_db |>
  group_by(Species) |>
  summarise(
    avg_sepal = mean(Sepal.Length, na.rm = TRUE),
    count = n()
  )
```

    ## # Source:   SQL [?? x 3]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##   Species    avg_sepal count
    ##   <fct>          <dbl> <dbl>
    ## 1 setosa          5.01    50
    ## 2 versicolor      5.94    50
    ## 3 virginica       6.59    50

``` r
measurements_db |>
  count(Species, sort = TRUE)
```

    ## # Source:     SQL [?? x 2]
    ## # Database:   DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ## # Ordered by: desc(n)
    ##   Species        n
    ##   <fct>      <dbl>
    ## 1 setosa        50
    ## 2 versicolor    50
    ## 3 virginica     50

### Joining Tables

``` r
measurements_db |>
  left_join(species_db, by = "Species") |>
  select(Species, Sepal.Length)
```

    ## # Source:   SQL [?? x 2]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##    Species Sepal.Length
    ##    <fct>          <dbl>
    ##  1 setosa           5.1
    ##  2 setosa           4.9
    ##  3 setosa           4.7
    ##  4 setosa           4.6
    ##  5 setosa           5  
    ##  6 setosa           5.4
    ##  7 setosa           4.6
    ##  8 setosa           5  
    ##  9 setosa           4.4
    ## 10 setosa           4.9
    ## # ℹ more rows

### Constructing a Tidy Analytic Dataset

``` r
analytic_dataset <- measurements_db |>
  group_by(Species) |>
  summarise(
    avg_sepal_length = mean(Sepal.Length, na.rm = TRUE),
    avg_petal_length = mean(Petal.Length, na.rm = TRUE),
    total_measurements = n()
  ) |>
  arrange(desc(avg_sepal_length))

# Collect for analysis
analytic_dataset |> collect()
```

    ## # A tibble: 3 × 4
    ##   Species    avg_sepal_length avg_petal_length total_measurements
    ##   <fct>                 <dbl>            <dbl>              <dbl>
    ## 1 virginica              6.59             5.55                 50
    ## 2 versicolor             5.94             4.26                 50
    ## 3 setosa                 5.01             1.46                 50

## Chapter 3: Supported expressions for database queries

### Logical Comparisons and Operators

``` r
measurements_db |> filter(Sepal.Length > 5 & Petal.Length > 3)
```

    ## # Source:   SQL [?? x 6]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species    species_id
    ##           <dbl>       <dbl>        <dbl>       <dbl> <fct>           <int>
    ##  1          7           3.2          4.7         1.4 versicolor          2
    ##  2          6.4         3.2          4.5         1.5 versicolor          2
    ##  3          6.9         3.1          4.9         1.5 versicolor          2
    ##  4          5.5         2.3          4           1.3 versicolor          2
    ##  5          6.5         2.8          4.6         1.5 versicolor          2
    ##  6          5.7         2.8          4.5         1.3 versicolor          2
    ##  7          6.3         3.3          4.7         1.6 versicolor          2
    ##  8          6.6         2.9          4.6         1.3 versicolor          2
    ##  9          5.2         2.7          3.9         1.4 versicolor          2
    ## 10          5.9         3            4.2         1.5 versicolor          2
    ## # ℹ more rows

### Conditional Statements

``` r
measurements_db |>
  mutate(
    size_category = case_when(
      Sepal.Length < 5 ~ "small",
      Sepal.Length <= 6 ~ "medium",
      TRUE ~ "large"
    )
  )
```

    ## # Source:   SQL [?? x 7]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species species_id
    ##           <dbl>       <dbl>        <dbl>       <dbl> <fct>        <int>
    ##  1          5.1         3.5          1.4         0.2 setosa           1
    ##  2          4.9         3            1.4         0.2 setosa           1
    ##  3          4.7         3.2          1.3         0.2 setosa           1
    ##  4          4.6         3.1          1.5         0.2 setosa           1
    ##  5          5           3.6          1.4         0.2 setosa           1
    ##  6          5.4         3.9          1.7         0.4 setosa           1
    ##  7          4.6         3.4          1.4         0.3 setosa           1
    ##  8          5           3.4          1.5         0.2 setosa           1
    ##  9          4.4         2.9          1.4         0.2 setosa           1
    ## 10          4.9         3.1          1.5         0.1 setosa           1
    ## # ℹ more rows
    ## # ℹ 1 more variable: size_category <chr>

### String Functions

``` r
species_db |>
  mutate(
    species_upper = toupper(Species),
    species_length = nchar(Species),
    species_substr = substr(Species, 1, 3)
  )
```

    ## # Source:   SQL [?? x 5]
    ## # Database: DuckDB 1.4.0 [gabriel.maeztu@Darwin 25.0.0:R 4.5.1/:memory:]
    ##   Species    species_id species_upper species_length species_substr
    ##   <fct>           <int> <chr>                  <dbl> <chr>         
    ## 1 setosa              1 SETOSA                     6 set           
    ## 2 versicolor          2 VERSICOLOR                10 ver           
    ## 3 virginica           3 VIRGINICA                  9 vir

## Chapter 4: Building analytic pipelines for a data model

### Example: Analyzing Iris Measurements

``` r
# Step 1: Filter and prepare data
iris_performance <- measurements_db |>
  filter(!is.na(Sepal.Length), !is.na(Petal.Length))

# Step 2: Calculate metrics
performance_metrics <- iris_performance |>
  mutate(
    sepal_petal_ratio = Sepal.Length / Petal.Length,
    is_large_flower = as.numeric(Sepal.Length > 6)
  ) |>
  group_by(Species) |>
  summarise(
    total_flowers = n(),
    avg_sepal_petal_ratio = mean(sepal_petal_ratio, na.rm = TRUE),
    large_percentage = mean(is_large_flower, na.rm = TRUE) * 100
  )

# Step 3: Filter for significant groups
significant_species <- performance_metrics |>
  filter(total_flowers >= 40) |>
  arrange(desc(avg_sepal_petal_ratio))

# Collect results
results <- significant_species |> collect()
```

### Creating Reusable Functions

``` r
calculate_ratios <- function(measurements_tbl) {
  measurements_tbl |>
    mutate(
      sepal_petal_ratio = Sepal.Length / Petal.Length,
      is_large = as.numeric(Sepal.Length > 6)
    ) |>
    summarise(
      total = n(),
      avg_ratio = mean(sepal_petal_ratio, na.rm = TRUE),
      large_pct = mean(is_large, na.rm = TRUE)
    )
}

# Use the function
species_ratios <- measurements_db |>
  group_by(Species) |>
  calculate_ratios()
```
