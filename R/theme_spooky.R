#' theme_spooky()
#'
#' A minimalist spooky theme for ggplot2.
#' Light background, subtle grid lines, and muted accents.
#'
#' @return A `ggplot2` theme object.
#'
#' @examples
#' library(ggplot2)
#' library(cwb)
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_spooky()
#'
#' @export
#' @import ggplot2
theme_spooky <- function() {
  theme_bw(base_size = 12,
           paper = "grey80", ink = "black") +
    theme(
      plot.title = element_text(face = "bold", size = 25, hjust = 0.5),
      plot.subtitle = element_text(size = 15, hjust = 0.5),
      plot.caption = element_text(size = 12),
      legend.position = "top",
      legend.key.width = unit(3, "lines"),
      legend.title = element_text(face = "bold", size = 15, hjust = 0.5),
      legend.title.position = "top",
      legend.text = element_text(size = 12)
    )
}
