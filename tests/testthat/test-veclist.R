context("Testing veclist()")


test_that("veclist works", {
  x <- 1:5
  y <- 5:1
  
  veclist(x, y)
  veclist(1, 2)
})