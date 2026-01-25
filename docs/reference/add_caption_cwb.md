# add_caption_cwb

Add a social media caption to a ggplot or gt table.

## Usage

``` r
add_caption_cwb(
  type = c("plot", "table"),
  include_data_source = FALSE,
  data_source = NULL,
  github_username = "colebaril",
  bluesky_username = "@colebaril.ca"
)
```

## Arguments

- type:

  Either "plot" or "table"

- include_data_source:

  Boolean; whether to include data source

- data_source:

  The source of the data

- github_username:

  Your GitHub username (default: "colebaril")

- bluesky_username:

  Your Bluesky username

## Value

A ggplot or gt object with a caption applied
