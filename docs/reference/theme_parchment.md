# theme_parchment()

A `ggplot2` theme styled to resemble old parchment and ink, giving plots
a vintage, manuscript-like appearance.

## Usage

``` r
theme_parchment(remove_grid = FALSE)
```

## Arguments

- remove_grid:

  Logical. If TRUE, removes all grid lines.

## Value

A `ggplot2` theme object that can be added to ggplot plots.

## Details

This theme adjusts panel backgrounds, grid lines, and text colors to
evoke the look of old parchment and handwritten ink. Works with
`ggplot2` plots.

## Examples

``` r
library(ggplot2)
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  theme_parchment()

```
