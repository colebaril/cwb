#' List data files in nested folders
#'
#' Recursively list files in a directory, optionally filtering by file extension, 
#' folder or filename patterns, and inclusion/exclusion rules.
#'
#' @param path Character. The base directory to start searching from.
#' @param ext Character vector or NULL. File extensions to include (e.g., c("xls", "xlsx", "xlsm")). Case-insensitive. Default is NULL (all extensions).
#' @param recursive Logical. Should the search include subfolders? Default is TRUE.
#' @param include Character vector or NULL. Patterns that must be present in the file path. Multiple patterns are AND-ed, i.e., all patterns must match. Can include regex expressions. Default is NULL (no include filtering).
#' @param exclude Character vector or NULL. Patterns that must NOT be present in the file path. Multiple patterns are OR-ed, i.e., files matching any exclude pattern are removed. Can include regex expressions. Default is NULL (no exclusion filtering).
#' @param return_list Logical. Whether a list is returned instead of a tibble. Default FALSE.
#' @return A tibble with column `file` containing full file paths.
#' @export
#'
#' @examples
#' # List all xlsx and xlsm files in any "results" folder for 2024-2026
#' \dontrun{
#' list_data_files(
#'   path = "C:/my_base_dir",
#'   ext = c("xls","xlsx","xlsm"),
#'   include = c("results", "2024|2025|2026")
#' )
#' }

list_data_files <- function(path,
                            ext = NULL,
                            include = NULL,
                            exclude = NULL,
                            recursive = TRUE,
                            return_list = FALSE) {
  
  files <- list.files(path, recursive = recursive, full.names = TRUE)
 
  if (!is.null(ext)) {
    ext <- gsub("^\\.", "", ext)
    ext_pattern <- paste0("\\.(", paste(ext, collapse = "|"), ")$")
    files <- files[grepl(ext_pattern, files, ignore.case = TRUE)]
  }
  
  
  keep <- sapply(files, function(f) {
    if (!is.null(include) && !all(sapply(include, function(pat) grepl(pat, f, ignore.case = TRUE)))) {
      return(NA) # exclude if any include pattern missing
    }
    if (!is.null(exclude) && any(sapply(exclude, function(pat) grepl(pat, f, ignore.case = TRUE)))) {
      return(NA) # exclude if any exclude pattern present
    }
    return(f) 
  })
  
  files <- keep[!is.na(keep)]
  
  if(return_list == FALSE){
  tibble::tibble(
    file = files,
    folder = dirname(files),
    filename = basename(files)
  )} else {
  files
  }
}
 