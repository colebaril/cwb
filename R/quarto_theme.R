#' trashpanda Quarto revealjs themes
#'
#' @param name Theme name: "dark", "light"
#' @export
trashpanda_quarto_theme <- function(name = c("dark", "light", "serif")) {
  name <- match.arg(name)
  
  system.file(
    "quarto", "revealjs",
    paste0("panda-", name, ".scss"),
    package = "trashpanda"
  )
}
