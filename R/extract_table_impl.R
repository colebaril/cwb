extract_table_impl <- function(
    path,
    sheet,
    start_column,
    last_column = NULL,
    search_until_empty_header = TRUE,
    max_empty_rows = 2,
    na_values = c("", NA),
    table_mode = c("first", "all")
) {
  
  table_mode <- match.arg(table_mode)
  
  raw <- readxl::read_excel(
    path = path,
    sheet = sheet,
    col_names = FALSE,
    na = na_values
  )
  
  raw_chr <- dplyr::mutate(raw, dplyr::across(dplyr::everything(), as.character))
  
  # --- Find all header rows ---
  header_rows <- which(
    apply(raw_chr, 1, function(x) start_column %in% x)
  )
  
  if (length(header_rows) == 0) {
    stop("start_column not found in sheet.")
  }
  
  if (table_mode == "first") {
    header_rows <- header_rows[1]
  }
  
  tables <- vector("list", length(header_rows))
  
  for (i in seq_along(header_rows)) {
    
    header_row <- header_rows[i]
    headers <- raw_chr[header_row, , drop = FALSE]
    start_col_idx <- which(headers == start_column)[1]
    
    # --- Determine column range ---
    if (!is.null(last_column)) {
      end_col_idx <- which(headers == last_column)[1]
      if (is.na(end_col_idx)) stop("last_column not found.")
    } else if (search_until_empty_header) {
      end_col_idx <- start_col_idx
      while (
        end_col_idx < ncol(headers) &&
        !is.na(headers[[1, end_col_idx + 1]]) &&
        headers[[1, end_col_idx + 1]] != ""
      ) {
        end_col_idx <- end_col_idx + 1
      }
    } else {
      end_col_idx <- ncol(headers)
    }
    
    col_range <- start_col_idx:end_col_idx
    col_names <- headers[1, col_range]
    header_signature <- as.character(col_names)
    
    # --- Extract candidate rows ---
    start_row <- header_row + 1
    end_row <- if (i < length(header_rows)) {
      header_rows[i + 1] - 1
    } else {
      nrow(raw)
    }
    
    data <- raw[start_row:end_row, col_range, drop = FALSE]
    
    # --- Row termination ---
    is_terminator <- apply(data, 1, function(x) {
      row_chr <- as.character(x)
      is_empty <- all(is.na(row_chr) | row_chr == "")
      is_repeat_header <- identical(row_chr, header_signature)
      is_empty || is_repeat_header
    })
    
    runs <- rle(is_terminator)
    run_ends <- cumsum(runs$lengths)
    
    cutoff <- NA_integer_
    for (j in seq_along(runs$values)) {
      if (runs$values[j] && runs$lengths[j] >= max_empty_rows) {
        cutoff <- run_ends[j] - max_empty_rows
        break
      }
    }
    
    if (!is.na(cutoff)) {
      data <- data[seq_len(max(cutoff, 0)), , drop = FALSE]
    }
    
    colnames(data) <- col_names
    tables[[i]] <- tibble::as_tibble(data)
  }
  
  tables
}


