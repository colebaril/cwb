#' Load a Trashpanda Quarto theme into your project
#'
#' Copies the precompiled CSS theme from the package to your project.
#'
#' @param name Theme name ("dark", "light")
#' @param dest_folder Folder to copy CSS into (default: "styles")
#' @param overwrite Whether to overwrite if CSS already exists (default: TRUE)
#' @return Relative path to the CSS file in your project
#' @export
load_quarto_theme <- function(name = c("dark", "light"),
                                  dest_folder = "styles",
                                  overwrite = TRUE) {
  name <- match.arg(name)
  
  # Get the CSS file from package
  css_file <- system.file(
    "quarto", "revealjs",
    paste0("panda-", name, ".css"),
    package = "trashpanda"
  )
  
  if (css_file == "") stop("CSS theme not found in package.")
  
  # Create destination folder if it doesn't exist
  if (!dir.exists(dest_folder)) dir.create(dest_folder, recursive = TRUE)
  
  # Destination path
  dest_file <- file.path(dest_folder, paste0("trashpanda-", name, ".css"))
  
  # Copy file
  file.copy(css_file, dest_file, overwrite = overwrite)
  
  # Return relative path
  normalizePath(dest_file, winslash = "/", mustWork = FALSE)
}

