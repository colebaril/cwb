#' clean_data
#'
#' A function to tidy data
#'
#' @param df A data frame to clean.
#' @param clean_names Logical. If TRUE, standardizes column names using `janitor::clean_names()`. Default TRUE.
#' @param trim_chars Logical. If TRUE, trims whitespace from all character columns. Default TRUE.
#' @param empty_to_na Logical. If TRUE, converts empty strings "" to NA in character columns. Default TRUE.
#' @param standardize_case Character. One of "none", "lower", "upper", "title". Adjusts character/factor casing. Default "none".
#' @param remove_special_chars Logical. If TRUE, removes punctuation/special characters from character columns. Default FALSE.
#' @param collapse_rare_levels Logical. If TRUE, lumps rare factor levels into "Other". Default FALSE.
#' @param coerce_numeric Logical. If TRUE, converts numeric-looking character columns to numeric. Default FALSE.
#' @param coerce_date Logical. If TRUE, converts date-like character columns to Date. Default FALSE.
#' @param flag_outliers Logical. If TRUE, flags numeric outliers. Default FALSE.
#' @param drop_empty_rows Logical. If TRUE, removes rows where all columns are NA. Default TRUE.
#' @param distinct Logical. If TRUE, removes exact duplicate rows. Default TRUE.
#' @param drop_missing_threshold Numeric 0–1. Remove columns with more than this fraction of missing values. Default NULL (disabled).
#' @param verbose Logical. If TRUE, prints summary of cleaning actions. Default FALSE.
#' @param return_summary Logical. If TRUE, returns a list with cleaned df and summary of actions. Default FALSE.
#' @param coerce_numeric Logical. If TRUE, forces numeric-looking columns to numeric type.
#' @return A cleaned data frame / tibble, or a list with df and summary if `return_summary = TRUE`.
#' @export
#' @import janitor
#' @examples
#' df <- tibble::tibble(
#'   "First Name" = c(" Alice ", "Bob", "", "CHARLIE", "dave", "Eve", NA, "Bob", "Bob"),
#'   "Last Name" = c("Smith", "Jones", "O'Neil", "Brown", "Miller", "O'Brien", "", "Jones", "Jones"),
#'   "Score" = c(10, 5000, 15, 20, 12, -999, 14, 5000, 5000),  # includes outlier
#'   "Enrollment Date" = c("2025-01-01", "20241215", "2025/02/01", "", NA, "01-03-2025", "2025-01-01", "2024-12-15", "2024-12-15"),
#'   "Grade" = c("A", "b", "C", "A", "B", "", "A", "b", "b"),
#'   "Comments!" = c("Good", " Excellent ", "", "Needs work", NA, "Good!", "Average", " Excellent ", " Excellent "),
#'   "EmptyCol" = c(NA, NA, NA, NA, NA, NA, NA, NA, NA)
#' )
#' clean_data(df, trim_chars = TRUE, empty_to_na = TRUE)
clean_data <- function(df,
                        clean_names = TRUE,
                        trim_chars = TRUE,
                        empty_to_na = TRUE,
                        standardize_case = c("none", "lower", "upper", "title"),
                        remove_special_chars = FALSE,
                        collapse_rare_levels = FALSE,
                        coerce_date = FALSE,
                        flag_outliers = FALSE,
                        drop_empty_rows = TRUE,
                        distinct = TRUE,
                        drop_missing_threshold = NULL,
                        verbose = FALSE,
                        return_summary = FALSE) {
  
  standardize_case <- match.arg(standardize_case)
  summary_log <- list()
  
  # 1️⃣ Clean column names
  if (clean_names) {
    df <- janitor::clean_names(df)
    summary_log$clean_names <- TRUE
  }
  
  # 2️⃣ Trim whitespace
  if (trim_chars) {
    df <- dplyr::mutate(df, dplyr::across(where(is.character), ~ stringr::str_trim(.)))
    summary_log$trimmed <- TRUE
  }
  
  # 3️⃣ Convert empty strings to NA
  if (empty_to_na) {
    df <- dplyr::mutate(df, dplyr::across(where(is.character), ~ dplyr::na_if(., "")))
    summary_log$empty_to_na <- TRUE
  }
  
  # 4️⃣ Standardize character/factor case
  if (standardize_case != "none") {
    df <- dplyr::mutate(df, dplyr::across(where(is.character), function(x) {
      switch(standardize_case,
             lower = stringr::str_to_lower(x),
             upper = stringr::str_to_upper(x),
             title = stringr::str_to_title(x),
             x)
    }))
    summary_log$case_standardized <- standardize_case
  }
  
  # 5️⃣ Remove special characters
  if (remove_special_chars) {
    df <- dplyr::mutate(df, dplyr::across(where(is.character), ~ stringr::str_replace_all(., "[[:punct:]]", "")))
    summary_log$special_chars_removed <- TRUE
  }

  
  # 7️⃣ Collapse rare factor levels
  if (collapse_rare_levels && any(vapply(df, is.factor, logical(1)))) {
    df <- dplyr::mutate(df, dplyr::across(where(is.factor), ~ forcats::fct_lump(.x, prop = 0.05)))
    summary_log$collapsed_rare_levels <- TRUE
  }
  
  # 9️⃣ Coerce date
  robust_parse_date_column <- function(col) {
    # If numeric 8-digit → treat as YYYYMMDD
    if (is.numeric(col) && all(!is.na(col) & col >= 10000101 & col <= 99991231)) {
      parsed <- suppressWarnings(lubridate::ymd(as.character(col)))
      if (any(!is.na(parsed))) return(parsed)
    }
    
    # If character and matches date-like pattern
    if (is.character(col) && any(grepl("\\d{8}|\\d{4}[-/]\\d{2}[-/]\\d{2}|\\d{2}[-/]\\d{2}[-/]\\d{4}", col))) {
      parsers <- list(lubridate::ymd, lubridate::dmy, lubridate::mdy)
      for (p in parsers) {
        parsed <- suppressWarnings(p(col))
        if (any(!is.na(parsed))) return(parsed)
      }
    }
    
    # Otherwise, return original column
    return(col)
  }
  
  # Apply robust parser column-wise
  if (coerce_date) {
    df <- dplyr::mutate(df, dplyr::across(everything(), robust_parse_date_column))
    summary_log$coerce_date <- TRUE
  }


  # 🔟 Flag outliers (MAD)
  if (flag_outliers) {
    numeric_cols <- dplyr::select(df, where(is.numeric))
    
    for (col in names(numeric_cols)) {
      x <- df[[col]]
      
      # Skip all-NA
      if (all(is.na(x))) {
        df[[paste0(col, "_outlier_flag")]] <- FALSE
        next
      }
      
      med_x <- median(x, na.rm = TRUE)
      mad_x <- mad(x, na.rm = TRUE)
      
      # Avoid division by zero
      if (mad_x == 0) {
        df[[paste0(col, "_outlier_flag")]] <- FALSE
        next
      }
      
      # Robust z-score
      robust_z <- abs(x - med_x) / mad_x
      
      df[[paste0(col, "_outlier_flag")]] <- ifelse(!is.na(robust_z) & robust_z > 3, TRUE, FALSE)
    }
    
    summary_log$outliers_flagged <- TRUE
  }
  
  
  # 1️⃣1️⃣ Drop empty rows
  if (drop_empty_rows) {
    n_before <- nrow(df)
    df <- dplyr::filter(df, dplyr::if_any(dplyr::everything(), ~ !is.na(.)))
    summary_log$rows_dropped <- n_before - nrow(df)
  }
  
  # 1️⃣2️⃣ Remove exact duplicate rows
  if (distinct) {
    n_before <- nrow(df)
    df <- dplyr::distinct(df)
    summary_log$duplicates_removed <- n_before - nrow(df)
  }

  
  # 1️⃣4️⃣ Drop columns exceeding missing thresholds
  if (!is.null(drop_missing_threshold)) {
    n_before <- ncol(df)
    na_fraction <- colMeans(is.na(df))
    df <- df[, na_fraction <= drop_missing_threshold, drop = FALSE]
    summary_log$cols_removed_high_na <- n_before - ncol(df)
  }
  
  # Verbose
  if (verbose) print(summary_log)
  
  if (return_summary) {
    return(list(df = df, summary = summary_log))
  } else {
    return(df)
  }
}
 