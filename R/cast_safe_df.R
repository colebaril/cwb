#' cast_safe_df()
#'
#' Safely run a function and return a consistent data frame
#' Executes any function while handling errors and empty outputs gracefully.
#' Returns a tibble with the original results, plus `context` and `error` columns.
#'
#' @param fun A function to execute.
#' @param ... Arguments passed to `fun`.
#' @param context Optional character string describing the context of this call (e.g., filename or input value). Defaults to `NULL`.
#' @param placeholder A tibble to return if the function fails or returns an empty data frame. Defaults to `tibble(result = NA)`.
#'
#' @return A tibble containing:
#' \describe{
#'   \item{result}{The output of the function (or placeholder if failed).}
#'   \item{context}{The context string provided.}
#'   \item{error}{The error message if the function failed, otherwise `NA`.}
#' }
#'
#' @details
#' This function is useful for safely executing functions that may fail on some inputs,
#' such as reading multiple files where some may be missing or malformed. It ensures
#' that the output is always a tibble and can be safely combined using `purrr::map_df()`.
#'
#' @examples
#' library(tibble)
#' library(purrr)
#' library(readr)
#'
#' # Example 1: math function with possible errors
#' f <- function(x) {
#'   if (x == 0) stop("Cannot divide by zero!")
#'   10 / x
#' }
#' nums <- -1:1
#' out <- map_df(nums, ~ cast_safe_df(
#'   f, .x,
#'   context = paste("value =", .x),
#'   placeholder = tibble(result = NA_real_)
#' ))
#' print(out)
#'
#' # Example 2: reading multiple files safely
#' df <- map_df(list.files(pattern = ".csv", full.names = TRUE),
#'              ~ cast_safe_df(readr::read_csv, .x,
#'                            col_names = FALSE,
#'                            show_col_types = FALSE,
#'                            context = basename(.x),
#'                            placeholder = tibble(X1 = NA_character_)))
#'
#' @export

cast_safe_df <- function(fun, ..., context = NULL,
                        placeholder = tibble::tibble(result = NA)) {
  tryCatch(
    {
      res <- fun(...)
      
      # Handle empty data frame
      if (is.data.frame(res) && nrow(res) == 0) {
        res <- placeholder
      }
      
      # Wrap non-data frame outputs
      if (!is.data.frame(res)) {
        res <- tibble::tibble(result = res)
      }
      
      res$context <- context
      res$error <- NA_character_
      res
    },
    error = function(e) {
      warning(sprintf("Error in %s: %s",
                      context %||% "unknown", e$message))
      res <- placeholder
      res$context <- context
      res$error <- e$message
      res
    }
  )
}






    



