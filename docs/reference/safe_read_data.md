# Safely read a data file with consistent output

Reads a data file using a user-supplied reader function, returning a
tibble along with any error message encountered during import. This is
useful when batch-reading many files where some may be malformed or
inconsistent.

## Usage

``` r
safe_read_data(
  file,
  reader,
  cols = NULL,
  sheet = NULL,
  sheet_pattern = NULL,
  ...
)
```

## Arguments

- file:

  Character string. Path to the file to be read.

- reader:

  Function used to read the file (e.g.,
  [`readr::read_csv`](https://readr.tidyverse.org/reference/read_delim.html),
  [`readxl::read_excel`](https://readxl.tidyverse.org/reference/read_excel.html)).
  The function must take `file` as its first argument.

- cols:

  Optional character vector of column names to enforce in the output.
  Missing columns will be added and filled with `NA`, and extra columns
  will be dropped.

- sheet:

  The sheet to be selected if static name.

- sheet_pattern:

  Optional regex pattern to select the sheet by name.

- ...:

  Additional arguments passed directly to `reader()`.

## Value

A named list with the following elements:

- data:

  A tibble containing the imported data, or `NULL` if an error occurred.

- error:

  `NULL` if the file was read successfully; otherwise, a character
  string containing the error message.

- file:

  The input file path.

## Examples

``` r
if (FALSE) { # \dontrun{
files <- c("data/a.csv", "data/b.csv")

results <- lapply(
  files,
  safe_read_data,
  reader = readr::read_csv,
  cols = c("id", "value", "date")
)

# Extract successfully read data
good_data <- purrr::keep(results, ~ is.null(.x$error))
} # }
```
