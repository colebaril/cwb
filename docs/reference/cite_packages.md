# Cites packages in various formats (e.g., R Markdown/Quarto or plain text).

Cites packages in various formats (e.g., R Markdown/Quarto or plain
text).

## Usage

``` r
cite_packages(format = "rmd", packages = pacman::p_loaded())
```

## Arguments

- format:

  Character, either `"rmd"` for Markdown/Quarto or `"plain_text"` for
  console output.

- packages:

  Character vector of package names. Defaults to
  [`pacman::p_loaded()`](https://rdrr.io/pkg/pacman/man/p_loaded.html).

## Value

Invisibly returns NULL. Side effect: prints formatted citations.
