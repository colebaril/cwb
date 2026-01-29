#' theme_cole()
#'
#' A `ggplot2` theme styled to resemble old parchment and ink, giving plots
#' a vintage, manuscript-like appearance.
#' @param remove_grid Logical. If TRUE, removes all grid lines.
#' @param show_axis_lines Shows axis lines, text, titles and ticks. c("all", "bottom", "top", "right", "left"); default: 
#' c("bottom", "left"). 
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
#' library(palmerpenguins)
#' 
#' ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
#'   geom_point(shape = 21) +
#'   labs(title = "Flipper Length vs. Bill Length",
#'        subtitle = "Lorem ipsum") +
#'   theme_cole(show_axis_lines = c("bottom", "left"), remove_grid = TRUE, dark = TRUE) +
#'   add_caption_cwb() 
#'   
#'   
#' ggplot(penguins, aes(flipper_length_mm, bill_length_mm, fill = species, group = species)) +
#'   geom_point(shape = 21) +
#'   labs(title = "Flipper Length vs. Bill Length",
#'        subtitle = "Lorem ipsum") +
#'   theme_cole(show_axis_lines = c("bottom", "left"), remove_grid = FALSE) +
#'   add_caption_cwb() 
#'
#' @export
#' @import ggplot2

theme_cole <- function(base_size = 12, 
                       base_family = "sans", 
                       remove_grid = FALSE, 
                       show_axis_lines = c("bottom", "left"),  
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
  
  if (!is.null(show_axis_lines)) {
    
    # Resolve "all" shortcut
    axes <- if ("all" %in% show_axis_lines) {
      c("bottom", "top", "left", "right")
    } else {
      show_axis_lines
    }
    
    # Determine line color based on dark mode
    line_color <- if (dark) "white" else "black"
    
    # Add axis lines and conditionally remove text/ticks/titles
    th <- th + ggplot2::theme(
      # X axes
      axis.line.x.bottom = if ("bottom" %in% axes) ggplot2::element_line(color = line_color) else ggplot2::element_blank(),
      axis.line.x.top    = if ("top"    %in% axes) ggplot2::element_line(color = line_color) else ggplot2::element_blank(),
      axis.text.x.bottom = if ("bottom" %in% axes) ggplot2::element_text() else ggplot2::element_blank(),
      axis.text.x.top    = if ("top"    %in% axes) ggplot2::element_text() else ggplot2::element_blank(),
      axis.ticks.x.bottom = if ("bottom" %in% axes) ggplot2::element_line() else ggplot2::element_blank(),
      axis.ticks.x.top    = if ("top"    %in% axes) ggplot2::element_line() else ggplot2::element_blank(),
      axis.title.x.bottom = if ("bottom" %in% axes) ggplot2::element_text() else ggplot2::element_blank(),
      axis.title.x.top    = if ("top"    %in% axes) ggplot2::element_text() else ggplot2::element_blank(),
      
      # Y axes
      axis.line.y.left  = if ("left"  %in% axes) ggplot2::element_line(color = line_color) else ggplot2::element_blank(),
      axis.line.y.right = if ("right" %in% axes) ggplot2::element_line(color = line_color) else ggplot2::element_blank(),
      axis.text.y.left  = if ("left"  %in% axes) ggplot2::element_text() else ggplot2::element_blank(),
      axis.text.y.right = if ("right" %in% axes) ggplot2::element_text() else ggplot2::element_blank(),
      axis.ticks.y.left  = if ("left"  %in% axes) ggplot2::element_line() else ggplot2::element_blank(),
      axis.ticks.y.right = if ("right" %in% axes) ggplot2::element_line() else ggplot2::element_blank(),
      axis.title.y.left  = if ("left"  %in% axes) ggplot2::element_text() else ggplot2::element_blank(),
      axis.title.y.right = if ("right" %in% axes) ggplot2::element_text() else ggplot2::element_blank(),
      
      # Remove panel border
      panel.border = ggplot2::element_blank()
    )
    
    # Automatically create secondary axes if top/right requested
    sec_axes <- list()
    if ("top" %in% axes)   sec_axes$x <- ggplot2::dup_axis()
    if ("right" %in% axes) sec_axes$y <- ggplot2::dup_axis()
    
    # Return secondary axes as scales if needed
    if (length(sec_axes) > 0) {
      th <- list(th,
                 if (!is.null(sec_axes$x)) ggplot2::scale_x_continuous(sec.axis = sec_axes$x) else NULL,
                 if (!is.null(sec_axes$y)) ggplot2::scale_y_continuous(sec.axis = sec_axes$y) else NULL
      )
    }
    
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
