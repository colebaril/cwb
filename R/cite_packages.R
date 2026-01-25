#' cite_packages
#'
#' Cites packages in various formats (e.g., R Markdown/Quarto or plain text).
#'
#' @param format Character, either `"rmd"` for Markdown/Quarto or `"plain_text"` for console output.
#' @param packages Character vector of package names. Defaults to `pacman::p_loaded()`.
#' @return Invisibly returns NULL. Side effect: prints formatted citations.
#' @export
#' @import pacman
#' @import purrr
#' @importFrom utils capture.output citation
cite_packages <- function(format = "rmd",
                          packages = pacman::p_loaded()) {
  
  
  if (!length(packages)) {
    warning("No packages to cite.")
    return(invisible(NULL))
  }
  
  # Gather citations per package
  pkg_citations <- purrr::map(packages, function(pkg) {
    cit <- tryCatch(citation(pkg), error = function(e) NULL)
    if (is.null(cit) || length(cit) == 0) {
      warning("Package '", pkg, "' has no associated citation.", call. = FALSE)
      return(NULL)
    }
    cit
  })
  
  if(format == "rmd")
  
  packages |> 
    map(citation) |>
    list_flatten() |> 
    map(\(x) paste(capture.output(print(x, style = "text")), collapse = "\n")) |>
    purrr::walk2(
      seq_along(pacman::p_loaded()),
      \(txt, i) cat(i, ". ", txt, "\n\n", sep = "")
    )
  
  if(format == "text")
    
  packages |>
    purrr::map(citation) |>      
    print(style = "text")
  
  invisible(NULL)
}
