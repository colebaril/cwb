# List data files in nested folders

Recursively list files in a directory, optionally filtering by file
extension, folder or filename patterns, and inclusion/exclusion rules.

## Usage

``` r
list_data_files(
  path,
  ext = NULL,
  include = NULL,
  exclude = NULL,
  recursive = TRUE,
  return_list = FALSE
)
```

## Arguments

- path:

  Character. The base directory to start searching from.

- ext:

  Character vector or NULL. File extensions to include (e.g., c("xls",
  "xlsx", "xlsm")). Case-insensitive. Default is NULL (all extensions).

- include:

  Character vector or NULL. Patterns that must be present in the file
  path. Multiple patterns are AND-ed, i.e., all patterns must match. Can
  include regex expressions. Default is NULL (no include filtering).

- exclude:

  Character vector or NULL. Patterns that must NOT be present in the
  file path. Multiple patterns are OR-ed, i.e., files matching any
  exclude pattern are removed. Can include regex expressions. Default is
  NULL (no exclusion filtering).

- recursive:

  Logical. Should the search include subfolders? Default is TRUE.

- return_list:

  Logical. Whether a list is returned instead of a tibble. Default
  FALSE.

## Value

A tibble with column `file` containing full file paths.

## Examples

``` r
# List all xlsx and xlsm files in any "results" folder for 2024-2026
if (FALSE) { # \dontrun{
list_data_files(
  path = "C:/my_base_dir",
  ext = c("xls","xlsx","xlsm"),
  include = c("results", "2024|2025|2026")
)
} # }
```
