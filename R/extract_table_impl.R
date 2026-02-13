extract_table_impl <- function(
    path,
    sheet,
    start_column,
    last_column = NULL,
    search_until_empty_header = TRUE,
    max_empty_rows = 2,
    na_values = c("", NA),
    table_mode = c("first", "all"),
    verbose = TRUE
) {
  
  table_mode <- match.arg(table_mode)
  
  if(verbose) message("\nReading sheet '", sheet, "' from file: ", basename(path))
  raw <- readxl::read_excel(
    path = path,
    sheet = sheet,
    col_names = FALSE,
    na = na_values
  ) |> suppressMessages()
  
  raw_chr <- dplyr::mutate(raw, dplyr::across(dplyr::everything(), as.character))
  
  # --- Find all header rows ---
  header_rows <- which(apply(raw_chr, 1, function(x) start_column %in% x))
  if(length(header_rows) == 0) {
    if(verbose) message("Skipping: ", basename(path), " / ", sheet, ". No table starting with '", start_column, "' found.")
    return(NULL)
  }
  if(table_mode == "first") header_rows <- header_rows[1]
  
  tables <- vector("list", length(header_rows))
  
  # Helper: fill merged headers for column names
  fill_merged_headers <- function(headers) {
    headers_filled <- headers
    for(i in seq_along(headers_filled)) {
      if(is.na(headers_filled[[i]]) || headers_filled[[i]] == "") {
        headers_filled[[i]] <- headers_filled[[i-1]]
      }
    }
    headers_filled
  }
  
  for(i in seq_along(header_rows)) {
    
    # --- Start a log vector for this table ---
    log_lines <- character()
    log_lines <- c(log_lines, paste0("=== Sheet: ", sheet, " | Table ", i, " ==="))
    
    header_row <- header_rows[i]
    headers_row <- raw_chr[header_row, , drop = FALSE]
    start_col_idx <- which(headers_row == start_column)[1]
    
    if(any(is.na(headers_row))) {
      log_lines <- c(log_lines,
                     "Merged or empty header cells detected. Scanning forward to detect table columns...")
    }
    
    # --- Determine column range ---
    if(!is.null(last_column)) {
      end_col_idx <- which(headers_row == last_column)[1]
      if(is.na(end_col_idx)) stop("last_column not found.")
      log_lines <- c(log_lines,
                     paste0("Using supplied last_column '", last_column, "' at index ", end_col_idx))
    } else if(search_until_empty_header) {
      
      end_col_idx <- start_col_idx
      empty_run <- 0
      max_empty_cols <- 3
      merged_detected <- FALSE
      
      while(end_col_idx < ncol(headers_row)) {
        next_val <- headers_row[[1, end_col_idx + 1]]
        if(is.na(next_val) || next_val == "") {
          empty_run <- empty_run + 1
          merged_detected <- TRUE
          if(empty_run > max_empty_cols) break
        } else {
          empty_run <- 0
        }
        end_col_idx <- end_col_idx + 1
      }
      
      if(merged_detected) {
        log_lines <- c(log_lines,
                       "Merged or empty header cells detected. Consider supplying 'last_column'.")
      }
      
      log_lines <- c(log_lines, paste0("Auto-detected end column at index ", end_col_idx))
      
    } else {
      end_col_idx <- ncol(headers_row)
      log_lines <- c(log_lines, "Using full row for columns (no last_column supplied).")
    }
    
    col_range <- start_col_idx:end_col_idx
    
    # --- Fill merged headers ---
    col_names <- fill_merged_headers(as.character(headers_row[1, col_range]))
    
    # --- Extract candidate rows (start after header row) ---
    start_row <- header_row + 1
    end_row <- if(i < length(header_rows)) header_rows[i + 1] - 1 else nrow(raw)
    data <- raw[start_row:end_row, col_range, drop = FALSE]
    
    # --- Row termination ---
    if(nrow(data) > 0) {
      is_terminator <- apply(data, 1, function(x) {
        row_chr <- as.character(x)
        is_empty <- all(is.na(row_chr) | row_chr == "")
        is_repeat_header <- identical(row_chr, col_names)
        is_empty || is_repeat_header
      })
      
      runs <- rle(is_terminator)
      run_ends <- cumsum(runs$lengths)
      
      cutoff <- NA_integer_
      for(j in seq_along(runs$values)) {
        if(runs$values[j] && runs$lengths[j] >= max_empty_rows) {
          cutoff <- run_ends[j] - max_empty_rows
          break
        }
      }
      
      if(!is.na(cutoff)) {
        log_lines <- c(log_lines, paste0("Trimming table at row ", start_row + cutoff - 1))
        data <- data[seq_len(max(cutoff, 0)), , drop = FALSE]
      }
    }
    
    # --- Assign column names ---
    colnames(data) <- col_names
    
    # --- Remove fully empty columns ---
    non_empty_cols <- vapply(data, function(col) any(!is.na(col) & col != ""), logical(1))
    data <- data[, non_empty_cols, drop = FALSE]
    
    # --- Make column names unique after removing empty columns ---
    colnames(data) <- make.unique(colnames(data))
    
    # --- Convert to tibble ---
    tables[[i]] <- tibble::as_tibble(data)
    
    # --- Attach the original merged header row as an attribute ---
    attr(tables[[i]], "merged_header") <- headers_row[1, col_range]
    
    log_lines <- c(log_lines, paste0("Extracted ", nrow(data), " rows and ", ncol(data), " columns."))
    
    # --- Print all log lines for this table together ---
    if(verbose) cat(paste0(log_lines, collapse = "\n"), "\n\n")
  }
  
  tables
}
