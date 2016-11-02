#!/usr/bin/env Rscript

suppressMessages({
  library(trac2gh)
  library(gsubfn)
})

con <- file("stdin", blocking=TRUE)
open(con)

l <- readLines(con)

# Data
# Must be 'd'
{{{issue_data}}}

# Function
# must be f(x, db=d)
{{{link_issue_function}}}

r <- gsubfn("#[0-9]+", f, l)


cat(r, file=stdout())
