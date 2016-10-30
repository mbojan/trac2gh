#!/usr/bin/env Rscript

suppressMessages({
  library(trac2gh)
  library(gsubfn)
})

con <- file("stdin", blocking=TRUE)
open(con)

l <- readLines(con)

# to be dynamically inserted
d <- data.frame(
  id1 = 1:5,
  id2 = 5:1
)

f <- function(x) {
  n <- as.numeric(gsub("#", "", x))
  paste0("hash:", n)
}

r <- gsubfn("#[0-9]+", f, l)


cat(r, file=stdout())
