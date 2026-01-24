#' add_commas
#'
#' Adds commas to large numbers for easier readability.
#'
#' @param x A numeric vector.
#' @return A character vector of the same length as `x` with commas inserted as thousand separators.
#' @export
add_commas <- function(x) {
  format(x, big.mark = ",", scientific = FALSE)
}