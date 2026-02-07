#' Load a Trashpanda Quarto theme into the current project
#'
#' Copies a precompiled CSS theme into the project 'styles/' folder for use in Quarto.
#'
#' @param name Theme name ("dark", "light")
#' @param dest_folder Destination folder in project (default: "styles")
#' @param overwrite Whether to overwrite if the CSS already exists (default: FALSE)
#' @return Relative path to the CSS file in your project
#' @export
load_quarto_theme <- function(name = c("dark", "light"),
                              dest_folder = "styles",
                              overwrite = FALSE) {
  name <- match.arg(name)
  
  # Locate CSS in package
  css_file <- system.file(
    "quarto", "revealjs",
    paste0("panda-", name, ".css"),
    package = "trashpanda"
  )
  
  if (css_file == "") stop(
    sprintf("CSS theme '%s' not found in the Trashpanda package.", name)
  )
  
  # Ensure destination folder exists
  if (!dir.exists(dest_folder)) dir.create(dest_folder, recursive = TRUE)
  
  # Destination path in project
  dest_file <- file.path(dest_folder, paste0("trashpanda-", name, ".css"))
  
  if (file.exists(dest_file) && !overwrite) {
    message(sprintf(
      "CSS theme '%s' is already in '%s'. You can use it in your Quarto YAML:\n  css: %s",
      name, dest_folder, normalizePath(dest_file, winslash = "/", mustWork = FALSE)
    ))
  } else {
    file.copy(css_file, dest_file, overwrite = TRUE)
    message(sprintf(
      "CSS theme '%s' has been copied to '%s'. You can now use it in your Quarto YAML:\n  css: %s",
      name, dest_folder, normalizePath(dest_file, winslash = "/", mustWork = FALSE)
    ))
  }
  
  return(normalizePath(dest_file, winslash = "/", mustWork = FALSE))
}
