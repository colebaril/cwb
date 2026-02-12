# Look for and extract a table anywhere within an Excel sheet.

Searches an Excel sheet for a table whose header contains a known start
column. The table may appear anywhere in the sheet.

## Usage

``` r
extract_table(
  path,
  sheet = 1,
  start_column,
  last_column = NULL,
  search_until_empty_header = TRUE,
  max_empty_rows = 2,
  na_values = c("", NA),
  table_mode = c("first", "all"),
  safely = TRUE,
  id_cols = TRUE,
  quiet = FALSE,
  ...
)
```

## Arguments

- path:

  Path to Excel file

- sheet:

  Sheet name or index

- start_column:

  Name of first expected column

- last_column:

  Optional name of last expected column

- search_until_empty_header:

  Logical; auto-detect column end

- max_empty_rows:

  Number of consecutive empty rows tolerated

- na_values:

  Values treated as NA

- safely:

  Logical; if TRUE, return empty tibble on failure

- id_cols:

  Logical; add file/sheet metadata columns

- quiet:

  Logical; suppress messages

- ...:

  Arguments to be passed directly to `reader`

## Value

A tibble
