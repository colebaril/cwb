# Utilities

------------------------------------------------------------------------

## Overview

This vignette covers general utility functions included in the package:

- [`cite_packages()`](https://colebaril.github.io/trashpanda/reference/cite_packages.md)
  – generates formatted citations for loaded packages
- [`load_quarto_theme()`](https://colebaril.github.io/trashpanda/reference/load_quarto_theme.md)
  – loads a precompiled Quarto CSS theme into your project

These utilities help manage reproducibility and presentation styling.

------------------------------------------------------------------------

## 1. Citing Packages with `cite_packages()`

[`cite_packages()`](https://colebaril.github.io/trashpanda/reference/cite_packages.md)
prints package citations in either R Markdown/Quarto style or plain text
for the console. By default, it cites all currently loaded packages.

### Example: Markdown/Quarto citations

``` r
library(pacman)
# load some packages
p_load(trashpanda, ggplot2, dplyr, purrr)

cite_packages(format = "rmd")
```

1.  Wickham H, Henry L (2026). *purrr: Functional Programming Tools*.
    <doi:10.32614/CRAN.package.purrr>
    <https://doi.org/10.32614/CRAN.package.purrr>, R package version
    1.2.1, <https://CRAN.R-project.org/package=purrr>.

2.  Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr:
    A Grammar of Data Manipulation*. <doi:10.32614/CRAN.package.dplyr>
    <https://doi.org/10.32614/CRAN.package.dplyr>, R package version
    1.1.4, <https://CRAN.R-project.org/package=dplyr>.

3.  Wickham H (2016). *ggplot2: Elegant Graphics for Data Analysis*.
    Springer-Verlag New York. ISBN 978-3-319-24277-4,
    <https://ggplot2.tidyverse.org>.

4.  Baril C (2026). *trashpanda: Cole’s personal collection of R
    functions, themes, and palettes*. R package version 0.0.1, commit
    14145a48ec656cb89aa5ca8a60aeb12a5c89b085,
    <https://github.com/colebaril/trashpanda>.

5.  Rinker TW, Kurkiewicz D (2018). *pacman: Package Management for R*.
    version 0.5.0, <http://github.com/trinker/pacman>.

Output is formatted for direct copy-paste into R Markdown or Quarto
documents.

### Example: Plain text for console

``` r
cite_packages(format = "text")
```

    ## [[1]]
    ## Wickham H, Henry L (2026). _purrr: Functional Programming Tools_.
    ## doi:10.32614/CRAN.package.purrr
    ## <https://doi.org/10.32614/CRAN.package.purrr>, R package version 1.2.1,
    ## <https://CRAN.R-project.org/package=purrr>.
    ## 
    ## [[2]]
    ## Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A
    ## Grammar of Data Manipulation_. doi:10.32614/CRAN.package.dplyr
    ## <https://doi.org/10.32614/CRAN.package.dplyr>, R package version 1.1.4,
    ## <https://CRAN.R-project.org/package=dplyr>.
    ## 
    ## [[3]]
    ## Wickham H (2016). _ggplot2: Elegant Graphics for Data Analysis_.
    ## Springer-Verlag New York. ISBN 978-3-319-24277-4,
    ## <https://ggplot2.tidyverse.org>.
    ## 
    ## [[4]]
    ## Baril C (2026). _trashpanda: Cole's personal collection of R functions,
    ## themes, and palettes_. R package version 0.0.1, commit
    ## 14145a48ec656cb89aa5ca8a60aeb12a5c89b085,
    ## <https://github.com/colebaril/trashpanda>.
    ## 
    ## [[5]]
    ## Rinker TW, Kurkiewicz D (2018). _pacman: Package Management for R_.
    ## version 0.5.0, <http://github.com/trinker/pacman>.

This prints citations in plain text, suitable for scripts or reports.

> Note: Packages without a registered citation will generate a warning.

------------------------------------------------------------------------

## 2. Loading a Quarto theme with `load_quarto_theme()`

[`load_quarto_theme()`](https://colebaril.github.io/trashpanda/reference/load_quarto_theme.md)
copies a precompiled CSS file from the package into your project so you
can use it in Quarto presentations with `revealjs`.

### Example: load the dark theme

``` r
css_path <- load_quarto_theme(name = "dark")
```

    ## CSS theme 'dark' is already in 'styles'. You can use it in your Quarto YAML:
    ##   css: C:/Projects/trashpanda/vignettes/styles/trashpanda-dark.css

``` r
# Use in Quarto YAML:
# css: styles/trashpanda-dark.css
```

### Example: load the light theme into a custom folder

``` r
css_path <- load_quarto_theme(name = "light", dest_folder = "styles/custom", overwrite = TRUE)
```

    ## CSS theme 'light' has been copied to 'styles/custom'. You can now use it in your Quarto YAML:
    ##   css: C:/Projects/trashpanda/vignettes/styles/custom/trashpanda-light.css

This ensures consistent styling for slides without manually copying
files.

------------------------------------------------------------------------

## Summary

The utilities vignette demonstrates:

- How to create reproducible citations with
  [`cite_packages()`](https://colebaril.github.io/trashpanda/reference/cite_packages.md)
- How to integrate precompiled Trashpanda Quarto themes into your
  projects with
  [`load_quarto_theme()`](https://colebaril.github.io/trashpanda/reference/load_quarto_theme.md)

These tools complement the visualization and workflow functions in the
package, supporting reproducible research and presentation-ready
outputs.
