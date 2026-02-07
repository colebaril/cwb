#' Load a Trashpanda Quarto theme into your project
#'
#' Copies the precompiled CSS theme into your project, automatically compiling SCSS if needed.
#'
#' @param name Theme name ("dark", "light")
#' @param dest_folder Folder to copy CSS into (default: "styles")
#' @param overwrite Whether to overwrite if CSS already exists in the project (default: TRUE)
#' @return Relative path to the CSS file in your project
#' @export
load_quarto_theme <- function(name = c("dark", "light", "serif"),
                              dest_folder = "styles",
                              overwrite = TRUE) {
  name <- match.arg(name)
  
  # Locate CSS in package
  css_file <- system.file(
    "quarto", "revealjs",
    paste0("panda-", name, ".css"),
    package = "trashpanda"
  )
  
  # If CSS does not exist, try to compile SCSS
  if (css_file == "") {
    scss_file <- system.file(
      "quarto", "revealjs",
      paste0("panda-", name, ".scss"),
      package = "trashpanda"
    )
    if (scss_file == "") stop("SCSS theme not found in package.")
    
    if (!requireNamespace("sass", quietly = TRUE)) {
      stop("The 'sass' package is required to compile SCSS. Please install it first.")
    }
    
    css_file <- gsub("\\.scss$", ".css", scss_file)
    
    # Compile SCSS to CSS
    css_content <- sass::sass_file(scss_file)
    writeLines(css_content, css_file)
  }
  
  # Create destination folder if needed
  if (!dir.exists(dest_folder)) dir.create(dest_folder, recursive = TRUE)
  
  # Copy CSS into project
  dest_file <- file.path(dest_folder, paste0("trashpanda-", name, ".css"))
  file.copy(css_file, dest_file, overwrite = overwrite)
  
  # Return relative path
  normalizePath(dest_file, winslash = "/", mustWork = FALSE)
}

