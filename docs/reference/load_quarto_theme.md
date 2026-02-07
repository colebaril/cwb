# Load a Trashpanda Quarto theme into the current project

Copies a precompiled CSS theme into the project 'styles/' folder for use
in Quarto presentations with revealjs.

## Usage

``` r
load_quarto_theme(
  name = c("dark", "light"),
  dest_folder = "styles",
  overwrite = FALSE
)
```

## Arguments

- name:

  Theme name ("dark", "light")

- dest_folder:

  Destination folder in project (default: "styles")

- overwrite:

  Whether to overwrite if the CSS already exists (default: FALSE)

## Value

Relative path to the CSS file in your project
