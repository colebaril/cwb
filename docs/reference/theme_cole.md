# theme_cole()

A `ggplot2` theme styled to resemble old parchment and ink, giving plots
a vintage, manuscript-like appearance.

## Usage

``` r
theme_cole(
  base_size = 12,
  base_family = "sans",
  remove_grid = FALSE,
  show_axis_lines = c("bottom", "left"),
  dark = FALSE
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

  Shows axis lines, text, titles and ticks. c("all", "bottom", "top",
  "right", "left"); default: c("bottom", "left").

- dark:

  Logical. If TRUE, plot is transformed to a dark theme.

## Value

A `ggplot2` theme object that can be added to ggplot plots.

## Details

This theme adjusts panel backgrounds, grid lines, and text colors to
evoke the look of old parchment and handwritten ink. Works with
`ggplot2` plots.

## Examples

``` r
library(ggplot2)
library(cwb)
library(palmerpenguins)
ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
  geom_point(shape = 21) +
  labs(title = "Flipper Length vs. Bill Length",
       subtitle = "test test test") +
  theme_cole(axes_only = TRUE, remove_grid = TRUE, dark = TRUE) +
  add_caption_cwb() 
#> Error in theme_cole(axes_only = TRUE, remove_grid = TRUE, dark = TRUE): unused argument (axes_only = TRUE)
  
  
ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
  geom_point(shape = 21) +
  labs(title = "Flipper Length vs. Bill Length",
       subtitle = "test test test") +
  theme_cole(axes_only = TRUE, remove_grid = FALSE) +
  add_caption_cwb() 
#> Error in theme_cole(axes_only = TRUE, remove_grid = FALSE): unused argument (axes_only = TRUE)
```
