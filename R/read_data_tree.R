#' Read all data files from a folder tree safely
#'
#' Recursively reads multiple data files (CSV, Excel, etc.) from a directory tree.
#' Automatically handles errors, enforces column names, and combines multiple sheets
#' from Excel files. Always returns a tibble with consistent columns.
#'
#' @param path Character. Base directory to search for data files.
#' @param reader Function. Reader function for the file type (e.g., `readr::read_csv`, `readxl::read_excel`).
#' @param cols Character vector or NULL. Columns to enforce; missing columns will be added as NA.
#' @param ext Character vector or NULL. File extensions to include (e.g., c("csv", "xlsx")). Case-insensitive.
#' @param include Character vector or NULL. Patterns that must be present in the file path.
#' @param exclude Character vector or NULL. Patterns that must NOT be present in the file path.
#' @param recursive Logical. Whether to include subfolders. Default TRUE.
#' @param sheet Character vector or NULL. Specific sheet names to read (Excel only).
#' @param sheet_pattern Character or NULL. Regex pattern to match sheets (Excel only).
#' @param ... Additional arguments passed directly to `reader()`.
#' @return A tibble combining all successfully read files (with columns enforced and source_file added).
#' @export
read_data_tree <- function(path,
                           reader,
                           cols = NULL,
                           ext = NULL,
                           include = NULL,
                           exclude = NULL,
                           recursive = TRUE,
                           sheet = NULL,
                           sheet_pattern = NULL,
                           ...) {
  
  # List files
  files <- list_data_files(
    path = path,
    ext = ext,
    include = include,
    exclude = exclude,
    recursive = recursive,
    return_list = TRUE
  )
  
  if (length(files) == 0) {
    warning("No files found in path: ", path)
    return(tibble::tibble())
  }
  
  # Read all files safely
  results <- purrr::map(
    files,
    safe_read_data,
    reader = reader,
    cols = cols,
    sheet = sheet,
    sheet_pattern = sheet_pattern,
    ...
  )
  
  # Keep only successful reads
  success <- purrr::keep(results, ~ is.null(.x$error))
  
  if (length(success) == 0) {
    warning("No files were read successfully")
    return(tibble::tibble())
  }
  
  # Combine all data into one tibble
  combined <- purrr::map_dfr(
    success,
    ~ dplyr::mutate(.x$data, source_file = .x$file)
  )
  
  # Ensure all enforced columns exist
  if (!is.null(cols)) {
    for (col in setdiff(cols, names(combined))) combined[[col]] <- NA
    combined <- combined[, c(cols, setdiff(names(combined), cols)), drop = FALSE]
  }
  
  combined
}




