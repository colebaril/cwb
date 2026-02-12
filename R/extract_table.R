#' Look for and extract a table anywhere within an Excel sheet.
#'
#' @description
#' Searches an Excel sheet for a table whose header contains a known start
#' column. The table may appear anywhere in the sheet.
#'
#' @param path Path to Excel file
#' @param sheet Sheet name or index
#' @param start_column Name of first expected column
#' @param last_column Optional name of last expected column
#' @param search_until_empty_header Logical; auto-detect column end
#' @param max_empty_rows Number of consecutive empty rows tolerated
#' @param na_values Values treated as NA
#' @param safely Logical; if TRUE, return empty tibble on failure
#' @param id_cols Logical; add file/sheet metadata columns
#' @param quiet Logical; suppress messages
#' @param ... Arguments to be passed directly to `reader`
#'
#' @return A tibble
#' @export
extract_table <- function(
    path,
    sheet = 1,
    start_column,
    last_column = NULL,
    search_until_empty_header = TRUE,
    max_empty_rows = 2,
    na_values = c("", NA),
    table_mode = c("first", "all"),
    safely = TRUE,
    id_cols = TRUE,
    quiet = FALSE,
    ...
) {
  
  table_mode <- match.arg(table_mode)
  
  out <- tryCatch(
    extract_table_impl(
      path = path,
      sheet = sheet,
      start_column = start_column,
      last_column = last_column,
      search_until_empty_header = search_until_empty_header,
      max_empty_rows = max_empty_rows,
      na_values = na_values,
      table_mode = table_mode
    ),
    error = function(e) {
      if (!safely) stop(e)
      if (!quiet) message("Skipping: ", basename(path), " / ", sheet, ". No table starting with '", start_column, "' found.")
      list()
    }
  )
  
  if (length(out) == 0) {
    return(tibble::tibble())
  }
  
  out <- purrr::imap(out, function(tbl, i) {
    if (id_cols && nrow(tbl) > 0) {
      dplyr::mutate(
        tbl,
        .file = basename(path),
        .sheet = sheet,
        .table_id = i,
        .before = 1
      )
    } else {
      tbl
    }
  })
  
  dplyr::bind_rows(out)
}


