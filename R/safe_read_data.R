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
#'
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
                           ...) {
  
  is_excel <- tools::file_ext(file) %in% c("xls", "xlsx", "xlsm")
  
  # Warn if sheets are passed for non-Excel
  if (!is_excel && (!is.null(sheet) || !is.null(sheet_pattern))) {
    warning("sheet arguments ignored for non-Excel file: ", file)
  }
  
  tryCatch({
    
    sheets_to_read <- NULL
    
    if (is_excel) {
      all_sheets <- readxl::excel_sheets(file)
      
      if (!is.null(sheet_pattern)) {
        # regex match
        sheets_to_read <- all_sheets[grepl(sheet_pattern, all_sheets, ignore.case = TRUE)]
      } else if (!is.null(sheet)) {
        sheets_to_read <- sheet
      } else {
        sheets_to_read <- all_sheets
      }
      
      if (length(sheets_to_read) == 0) {
        stop("No sheets matched sheet_pattern in ", file)
      }
      
      # read each sheet safely
      dat <- purrr::map_dfr(
        sheets_to_read,
        function(s) {
          tmp <- reader(file, sheet = s, ...)
          # Convert all columns to character to avoid bind_rows type issues
          tmp <- dplyr::mutate(tmp, dplyr::across(.cols = everything(), .fns = as.character))
        },
        .id = "sheet_name"
      )
      
      # replace numeric .id with actual sheet names
      dat <- dplyr::mutate(dat, sheet_name = sheets_to_read[as.numeric(sheet_name)])
      
    } else {
      dat <- reader(file, ...)
    }
    
    dat <- tibble::as_tibble(dat)
    
    # enforce columns safely
    if (!is.null(cols)) {
      # add missing columns as NA (without coercing types)
      for (col in setdiff(cols, names(dat))) dat[[col]] <- NA
      # reorder columns: user-specified first, then others (including sheet_name)
      dat <- dat[, c(cols, setdiff(names(dat), cols)), drop = FALSE]
    }
    
    list(data = dat, error = NULL, file = file)
    
  }, error = function(e) {
    list(data = NULL, error = e$message, file = file)
  })
}




