#' Rudimentary MoinMoin wiki to Markdown converter
#' 
#' @param x character vector of texts to convert
#' 
#' @details
#' At this moment handles fenced code blocks only.
#' 
#' @return Translated text.
#' 
#' @export
moinmoin_to_markdown <- function(x) {
  rval <- gsub("\\{\\{\\{|\\}\\}\\}", "```", x)
  rval
}
