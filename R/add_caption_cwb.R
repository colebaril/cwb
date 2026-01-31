#' Generate social caption for ggplot or gt table
#'
#' Returns a caption string with optional data source and social icons,
#' suitable for passing directly to labs(caption = …) in ggplot.
#'
#' @param include_data_source Logical; whether to include data source
#' @param data_source Character; the source of the data
#' @param github_username Character; GitHub username (default: "colebaril")
#' @param bluesky_username Character; Bluesky username (default: "@colebaril.ca")
#' @return Character string containing HTML caption
#' @export
social_caption <- function(include_data_source = FALSE,
                           data_source = NULL,
                           github_username = "colebaril",
                           bluesky_username = "@colebaril.ca") {
  
  # Load fonts for icons
  sysfonts::font_add(
    family = "Font Awesome 7 Brands", 
    regular = "D:/Projects/fa/fontawesome-free-7.0.1-desktop/otfs/Font Awesome 7 Brands-Regular-400.otf"
  )
  showtext::showtext_auto()
  
  # Font Awesome icons
  github_icon <- "\uf09b"  
  bluesky_icon <- "\ue671"
  
  # Base caption
  caption <- glue::glue(
    "<span style='font-weight:bold; color:#4d4d4d;'>Graphic:</span>
     <span style='font-family:\"Font Awesome 7 Brands\"; color:#4d4d4d;'>{github_icon}</span>
     <span style='color:#4d4d4d;'>{github_username}</span>
     <span style='margin-left:15px;'></span>
     <span style='font-family:\"Font Awesome 7 Brands\"; color:#4d4d4d;'>{bluesky_icon}</span>
     <span style='color:#4d4d4d;'>{bluesky_username}</span>"
  )
  
  # Add Data source if requested
  if (include_data_source && !is.null(data_source)) {
    caption <- glue::glue("{caption}<br>
      <span style='font-weight:bold; color:#4d4d4d;'>Data:</span>
      <span style='color:#4d4d4d;'>{data_source}</span>")
  }
  
  # Remove any accidental literal newlines
  caption <- stringr::str_replace_all(caption, "\n", "")
  
  return(caption)
}