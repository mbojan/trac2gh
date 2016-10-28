# Trim strings off leading and trailing spaces and newlines
trim_garbage <- function(x, what="\n ", ...) {
  re <- paste0("^[", what, "]+", 
               "|",
               "[", what, "]+$")
  gsub(re, "", x, ...)
}



# Create Markdown link
md_link <- function(url, text=as.character(url)) {
  paste0("[", text, "](", url, ")")
}



# NULL to NA
null2na <- function(x) if(is.null(x)) NA else x


# collect vectors to a list concatenating element-by-element
veclist <- function(...) {
  args <- lapply(list(...), as.character)
  lens <- vapply(args, length, numeric(1))
  if( any(lens != lens[1]) )
    stop("arguments have different lengths: ", paste(lens, collapse=", "))
  m <- do.call("cbind", args)
  lapply(
    seq(1, nrow(m)), function(i) m[i,]
  )
}
