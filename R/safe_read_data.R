#' Safely read a data file with consistent output
#'
#' Reads a data file using a user-supplied reader function, returning a tibble
#' along with any error message encountered during import. This is useful when
#' batch-reading many files where some may be malformed or inconsistent.
#'
#' @param file Character string. Path to the file to be read.
#'
#' @param reader Function used to read the file (e.g., `readr::read_csv`,
#'   `readxl::read_excel`). The function must take `file` as its first argument.
#'
#' @param cols Optional character vector of column names to enforce in the
#'   output. Missing columns will be added and filled with `NA`, and extra
#'   columns will be dropped.
#' @param sheet The sheet to be selected if static name.
#' If not NULL, only the explicitly specified sheet will be read for all files.
#' @param sheet_pattern Optional regex pattern to select the sheet by name.
#' If not NULL, all sheets matching the pattern will be attempted to be read.
#' @param anti_sheet_pattern Character or NULL. Regex pattern to exclude sheets (Excel only)
#' @param ... Additional arguments passed directly to `reader()`.
#'
#' @return A named list with the following elements:
#' \describe{
#'   \item{data}{A tibble containing the imported data, or `NULL` if an error occurred.}
#'   \item{error}{`NULL` if the file was read successfully; otherwise, a character
#'   string containing the error message.}
#'   \item{file}{The input file path.}
#' }
#'
#' @examples
#' \dontrun{
#' files <- c("data/a.csv", "data/b.csv")
#'
#' results <- lapply(
#'   files,
#'   safe_read_data,
#'   reader = readr::read_csv,
#'   cols = c("id", "value", "date")
#' )
#'
#' # Extract successfully read data
#' good_data <- purrr::keep(results, ~ is.null(.x$error))
#' }
#'
#' @export
safe_read_data <- function(file,
                           reader,
                           cols = NULL,
                           sheet = NULL,
                           sheet_pattern = NULL,
                           anti_sheet_pattern = NULL,
                           ...) {
  
  is_table_reader <- isTRUE(attr(reader, "table_reader"))
  is_excel <- tools::file_ext(file) %in% c("xls", "xlsx", "xlsm")
  
  if (!is_excel && (!is.null(sheet) || !is.null(sheet_pattern))) {
    warning("sheet arguments ignored for non-Excel file: ", file)
  }
  
  tryCatch({
    
    if (is_excel && !is_table_reader) {
      
      all_sheets <- readxl::excel_sheets(file)
      
      # --- Determine candidate sheets ---
      sheets_to_read <- all_sheets
      
      if (!is.null(sheet_pattern)) {
        sheets_to_read <- sheets_to_read[
          grepl(sheet_pattern, sheets_to_read, ignore.case = TRUE)
        ]
      }
      
      if (!is.null(anti_sheet_pattern)) {
        sheets_to_read <- sheets_to_read[
          !grepl(anti_sheet_pattern, sheets_to_read, ignore.case = TRUE)
        ]
      }
      
      # Explicit sheet overrides patterns
      if (!is.null(sheet)) {
        if (!sheet %in% all_sheets) {
          stop("Sheet '", sheet, "' not found in ", file)
        }
        sheets_to_read <- sheet
      }
      
      
      if (length(sheets_to_read) == 0) {
        stop("No sheets matched selection criteria in ", file)
      }
      
      dat <- purrr::map_dfr(
        sheets_to_read,
        function(s) {
          tmp <- reader(file, sheet = s, ...)
          dplyr::mutate(tmp, dplyr::across(everything(), as.character))
        },
        .id = "sheet_name"
      )
      
      dat <- dplyr::mutate(dat, sheet_name = sheets_to_read[as.numeric(sheet_name)])
      
    } else {
      dat <- reader(file, ...)
    }
    
    dat <- tibble::as_tibble(dat)
    
    if (!is.null(cols)) {
      for (col in setdiff(cols, names(dat))) dat[[col]] <- NA
      dat <- dat[, c(cols, setdiff(names(dat), cols)), drop = FALSE]
    }
    
    list(data = dat, error = NULL, file = file)
    
  }, error = function(e) {
    list(data = NULL, error = e$message, file = file)
  })
}





