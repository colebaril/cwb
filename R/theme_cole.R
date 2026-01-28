#' theme_cole()
#'
#' A `ggplot2` theme styled to resemble old parchment and ink, giving plots
#' a vintage, manuscript-like appearance.
#' @param remove_grid Logical. If TRUE, removes all grid lines.
#' @param axes_only Logical. If TRUE, only x and y axis lines will be drawn.
#' @param base_size Base text size. Default 12.
#' @param base_family Base font family. Default "sans".
#' @param dark Logical. If TRUE, plot is transformed to a dark theme.
#' @return A `ggplot2` theme object that can be added to ggplot plots.
#' @details
#' This theme adjusts panel backgrounds, grid lines, and text colors to
#' evoke the look of old parchment and handwritten ink. Works with `ggplot2` plots.
#'
#' @examples
#' library(ggplot2)
#' library(cwb)
#' library(penguins)
#' ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
#'   geom_point(shape = 21) +
#'   labs(title = "Flipper Length vs. Bill Length",
#'        subtitle = "test test test") +
#'   theme_cole(axes_only = TRUE, remove_grid = TRUE, dark = TRUE) +
#'   add_caption_cwb() 
#'   
#'   
#' ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
#'   geom_point(shape = 21) +
#'   labs(title = "Flipper Length vs. Bill Length",
#'        subtitle = "test test test") +
#'   theme_cole(axes_only = TRUE, remove_grid = FALSE) +
#'   add_caption_cwb() 
#'
#' @export
#' @import ggplot2

theme_cole <- function(base_size = 12, 
                       base_family = "sans", 
                       remove_grid = FALSE, 
                       axes_only = FALSE, 
                       dark = FALSE) {
  
  th <- theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.title.position = "plot",
      plot.title = ggplot2::element_text(face = "bold", size = base_size * 1.5, hjust = 0.5),
      plot.subtitle = ggplot2::element_text(margin = ggplot2::margin(b = 8), hjust = 0.5),
      axis.title = ggplot2::element_text(face = "bold"),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(b = 8)),
      strip.text = ggplot2::element_text(face = "bold"),
      plot.margin = ggplot2::margin(12, 12, 12, 12),
      legend.title = ggplot2::element_text(face = "bold", size = base_size * 1.2),
      legend.text = ggplot2::element_text(size = base_size * 1.1)
    )
  
  if (remove_grid) {
    th <- th + theme(
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank()
    )
  }
  
  if (axes_only) {
    th <- th + ggplot2::theme(
      axis.line.x.bottom = ggplot2::element_line(),
      axis.line.y.left   = ggplot2::element_line(),
      axis.line.x.top    = ggplot2::element_blank(),
      axis.line.y.right  = ggplot2::element_blank(),
      panel.border       = ggplot2::element_blank()
    )
  }
  
  if (dark) {
    th <- th + ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "#222222", color = NA),
      panel.background = ggplot2::element_rect(fill = "#222222", color = NA),
      panel.grid.major = ggplot2::element_line(color = "#555555"),
      panel.grid.minor = ggplot2::element_line(color = "#444444"),
      axis.text = ggplot2::element_text(color = "white"),
      axis.title = ggplot2::element_text(color = "white"),
      plot.title = ggplot2::element_text(color = "white"),
      plot.subtitle = ggplot2::element_text(color = "white"),
      strip.text = ggplot2::element_text(color = "white"),
      legend.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(color = "white"),
      legend.title = ggplot2::element_text(color = "white"),
      axis.line.x.bottom = element_line(color = "white"),
      axis.line.y.left   = element_line(color = "white")

    )
  }
  
  return(th)
}
