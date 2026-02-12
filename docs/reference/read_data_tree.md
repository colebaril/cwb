# Read all data files from a folder tree safely

Recursively reads multiple data files (CSV, Excel, etc.) from a
directory tree. Automatically handles errors, enforces column names, and
combines multiple sheets from Excel files. Always returns a tibble with
consistent columns.

## Usage

``` r
read_data_tree(
  path,
  reader,
  cols = NULL,
  ext = NULL,
  include = NULL,
  exclude = NULL,
  recursive = TRUE,
  sheet = NULL,
  sheet_pattern = NULL,
  anti_sheet_pattern = NULL,
  ...
)
```

## Arguments

- path:

  Character. Base directory to search for data files.

- reader:

  Function. Reader function for the file type (e.g.,
  [`readr::read_csv`](https://readr.tidyverse.org/reference/read_delim.html),
  [`readxl::read_excel`](https://readxl.tidyverse.org/reference/read_excel.html)).

- cols:

  Character vector or NULL. Columns to enforce; missing columns will be
  added as NA.

- ext:

  Character vector or NULL. File extensions to include (e.g., c("csv",
  "xlsx")). Case-insensitive.

- include:

  Character vector or NULL. Patterns that must be present in the file
  path.

- exclude:

  Character vector or NULL. Patterns that must NOT be present in the
  file path.

- recursive:

  Logical. Whether to include subfolders. Default TRUE.

- sheet:

  Character vector or NULL. Specific sheet names to read (Excel only).
  If not NULL, only the explicitly specified sheet will be read for all
  files.

- sheet_pattern:

  Character or NULL. Regex pattern to match sheets (Excel only). If not
  NULL, all sheets matching the pattern will be attempted to be read.

- anti_sheet_pattern:

  Character or NULL. Regex pattern to exclude sheets (Excel only)

- ...:

  Additional arguments passed directly to `reader()`.

## Value

A tibble combining all successfully read files (with columns enforced
and source_file added).
