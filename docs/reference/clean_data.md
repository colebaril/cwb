# clean_data

A function to tidy data

## Usage

``` r
clean_data(
  df,
  clean_names = TRUE,
  trim_chars = TRUE,
  empty_to_na = TRUE,
  standardize_case = c("none", "lower", "upper", "title"),
  remove_special_chars = FALSE,
  collapse_rare_levels = FALSE,
  coerce_date = FALSE,
  flag_outliers = FALSE,
  drop_empty_rows = TRUE,
  distinct = TRUE,
  drop_missing_threshold = NULL,
  verbose = FALSE,
  return_summary = FALSE
)
```

## Arguments

- df:

  A data frame to clean.

- clean_names:

  Logical. If TRUE, standardizes column names using
  [`janitor::clean_names()`](https://sfirke.github.io/janitor/reference/clean_names.html).
  Default TRUE.

- trim_chars:

  Logical. If TRUE, trims whitespace from all character columns. Default
  TRUE.

- empty_to_na:

  Logical. If TRUE, converts empty strings "" to NA in character
  columns. Default TRUE.

- standardize_case:

  Character. One of "none", "lower", "upper", "title". Adjusts
  character/factor casing. Default "none".

- remove_special_chars:

  Logical. If TRUE, removes punctuation/special characters from
  character columns. Default FALSE.

- collapse_rare_levels:

  Logical. If TRUE, lumps rare factor levels into "Other". Default
  FALSE.

- coerce_date:

  Logical. If TRUE, converts date-like character columns to Date.
  Default FALSE.

- flag_outliers:

  Logical. If TRUE, flags numeric outliers. Default FALSE.

- drop_empty_rows:

  Logical. If TRUE, removes rows where all columns are NA. Default TRUE.

- distinct:

  Logical. If TRUE, removes exact duplicate rows. Default TRUE.

- drop_missing_threshold:

  Numeric 0–1. Remove columns with more than this fraction of missing
  values. Default NULL (disabled).

- verbose:

  Logical. If TRUE, prints summary of cleaning actions. Default FALSE.

- return_summary:

  Logical. If TRUE, returns a list with cleaned df and summary of
  actions. Default FALSE.

## Value

A cleaned data frame / tibble, or a list with df and summary if
`return_summary = TRUE`.

## Examples

``` r
df <- tibble::tibble(
  "First Name" = c(" Alice ", "Bob", "", "CHARLIE", "dave", "Eve", NA, "Bob", 
  "Bob"),
  "Last Name" = c("Smith", "Jones", "O'Neil", "Brown", "Miller", "O'Brien", 
  "", "Jones", "Jones"),
  "Score" = c(10, 5000, 15, 20, 12, -999, 14, 5000, 5000),  # includes outlier
  "Enrollment Date" = c("2025-01-01", "20241215", "2025/02/01", "", NA, 
  "01-03-2025", "2025-01-01", "2024-12-15", "2024-12-15"),
  "Grade" = c("A", "b", "C", "A", "B", "", "A", "b", "b"),
  "Comments!" = c("Good", " Excellent ", "", "Needs work", NA, "Good!", 
  "Average", " Excellent ", " Excellent "),
  "EmptyCol" = c(NA, NA, NA, NA, NA, NA, NA, NA, NA)
)
clean_data(df, trim_chars = TRUE, empty_to_na = TRUE)
#> # A tibble: 8 × 7
#>   first_name last_name score enrollment_date grade comments   empty_col
#>   <chr>      <chr>     <dbl> <chr>           <chr> <chr>      <lgl>    
#> 1 Alice      Smith        10 2025-01-01      A     Good       NA       
#> 2 Bob        Jones      5000 20241215        b     Excellent  NA       
#> 3 NA         O'Neil       15 2025/02/01      C     NA         NA       
#> 4 CHARLIE    Brown        20 NA              A     Needs work NA       
#> 5 dave       Miller       12 NA              B     NA         NA       
#> 6 Eve        O'Brien    -999 01-03-2025      NA    Good!      NA       
#> 7 NA         NA           14 2025-01-01      A     Average    NA       
#> 8 Bob        Jones      5000 2024-12-15      b     Excellent  NA       
```
