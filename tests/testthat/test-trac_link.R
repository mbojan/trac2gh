context("Generating links to Trac tickets")

test_that("Trac ticket link works for a single ticket ID", {
  bu <- "http://domain.com/trac"
  r <- trac_link_ticket(123, base_url=bu)
  expect_type(r, "character")
  
  pr <- httr::parse_url(r)
  expect_equal(pr$path, paste(c("trac", "ticket", "123"), collapse="/"))
})





test_that("Trac ticket link works for vector of ticket IDs", {
  bu <- "http://domain.com/trac"
  r <- trac_link_ticket(1:5, base_url = bu)
  expect_type(r, "character")
  
  l <- lapply(r, httr::parse_url)
  o <- vapply(l, "[[", character(1), "path")
  e <- paste0("trac/ticket/", 1:5)
  expect_identical(o, e)
})