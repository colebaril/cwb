# cast_safe_df()

Safely run a function and return a consistent data frame Executes any
function while handling errors and empty outputs gracefully. Returns a
tibble with the original results, plus `context` and `error` columns.

## Usage

``` r
cast_safe_df(
  fun,
  ...,
  context = NULL,
  placeholder = tibble::tibble(result = NA)
)
```

## Arguments

- fun:

  A function to execute.

- ...:

  Arguments passed to `fun`.

- context:

  Optional character string describing the context of this call (e.g.,
  filename or input value). Defaults to `NULL`.

- placeholder:

  A tibble to return if the function fails or returns an empty data
  frame. Defaults to `tibble(result = NA)`.

## Value

A tibble containing:

- result:

  The output of the function (or placeholder if failed).

- context:

  The context string provided.

- error:

  The error message if the function failed, otherwise `NA`.

## Details

This function is useful for safely executing functions that may fail on
some inputs, such as reading multiple files where some may be missing or
malformed. It ensures that the output is always a tibble and can be
safely combined using
[`purrr::map_df()`](https://purrr.tidyverse.org/reference/map_dfr.html).

## Examples

``` r
library(tibble)
library(purrr)
library(readr)

# Example 1: math function with possible errors
f <- function(x) {
  if (x == 0) stop("Cannot divide by zero!")
  10 / x
}
nums <- -1:1
out <- map_df(nums, ~ cast_safe_df(
  f, .x,
  context = paste("value =", .x),
  placeholder = tibble(result = NA_real_)
))
#> Warning: Error in value = 0: Cannot divide by zero!
print(out)
#> # A tibble: 3 × 3
#>   result context    error                 
#>    <dbl> <chr>      <chr>                 
#> 1    -10 value = -1 NA                    
#> 2     NA value = 0  Cannot divide by zero!
#> 3     10 value = 1  NA                    

# Example 2: reading multiple files safely
df <- map_df(list.files(pattern = ".csv", full.names = TRUE),
             ~ cast_safe_df(readr::read_csv, .x,
                           col_names = FALSE,
                           show_col_types = FALSE,
                           context = basename(.x),
                           placeholder = tibble(X1 = NA_character_)))
```
