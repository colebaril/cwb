# Cole's favourite plot theme

A `ggplot2` theme styled to resemble old parchment and ink, giving plots
a vintage, manuscript-like appearance.

## Usage

``` r
theme_cole(
  base_size = 12,
  base_family = "sans",
  remove_grid = FALSE,
  show_axis_lines = c("bottom", "left"),
  dark = FALSE,
  transparent = FALSE
)
```

## Arguments

- base_size:

  Base text size. Default 12.

- base_family:

  Base font family. Default "sans".

- remove_grid:

  Logical. If TRUE, removes all grid lines.

- show_axis_lines:

  Shows axis lines, text, titles and ticks. Choose from "all", "none",
  "bottom", "top", "right", "left"; default: c("bottom", "left").

- dark:

  Logical. If TRUE, plot is transformed to a dark theme.

- transparent:

  Logical. If TRUE, plot background is transparent.

## Value

A `ggplot2` theme object that can be added to ggplot plots.

## Details

This theme adjusts panel backgrounds, grid lines, and text colors to
evoke the look of old parchment and handwritten ink. Works with
`ggplot2` plots.

## Examples

``` r
library(ggplot2)
library(trashpanda)
library(palmerpenguins)
#> 
#> Attaching package: ‘palmerpenguins’
#> The following objects are masked from ‘package:datasets’:
#> 
#>     penguins, penguins_raw

ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
  geom_point(shape = 21) +
  labs(title = "Flipper Length vs. Bill Length",
       subtitle = "Lorem ipsum") +
  theme_cole(show_axis_lines = c("bottom", "left"), remove_grid = TRUE, dark = TRUE) +
  add_caption_cwb() 
#> Warning: Removed 2 rows containing missing values or values outside the scale range
#> (`geom_point()`).

  
  
ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
  geom_point(shape = 21) +
  labs(title = "Flipper Length vs. Bill Length",
       subtitle = "Lorem ipsum") +
  theme_cole(show_axis_lines = c("bottom", "left"), remove_grid = FALSE) +
  add_caption_cwb() 
#> Warning: Removed 2 rows containing missing values or values outside the scale range
#> (`geom_point()`).

```
