# theme_spooky()

A minimalist spooky theme for ggplot2. Light background, subtle grid
lines, and muted accents.

## Usage

``` r
theme_spooky()
```

## Value

A `ggplot2` theme object.

## Examples

``` r
library(ggplot2)
library(cwb)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_spooky()

```
