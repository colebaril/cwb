# Cole's colour scales

Apply a palette to a ggplot colour or fill scale.

## Usage

``` r
scale_cwb(
  palette,
  type = c("d", "c"),
  aesthetics = c("colour", "fill"),
  name = NULL,
  ...
)
```

## Arguments

- palette:

  Name of the palette (e.g., "arcane_flame").

- type:

  Scale type: "d" for discrete or "c" for continuous.

- aesthetics:

  Aesthetic to apply ("colour" or "fill").

- name:

  Legend title.

- ...:

  Additional arguments passed to ggplot2 scale functions.

## Value

A ggplot2 scale object.

## Examples

``` r
library(ggplot2)
library(trashpanda)
ggplot(mpg, aes(class, fill = class)) +
  geom_bar() +
  scale_cwb(palette = "eldritch_night", type = "d", aesthetics = "fill")


ggplot(mpg, aes(displ, hwy, colour = hwy)) +
  geom_point(size = 3) +
  scale_cwb(palette = "mystic_ocean", type = "c", aesthetics = "colour")
```
