# test-plots_grid.R
library(testthat)

source("work/R/plots_grid.R")

install.packages("vdiffr")

test_that("plots_grid combines multiple ggplot objects", {
  # We make two quick plots
  p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(x = hp)) + 
    ggplot2::geom_histogram(bins = 10)
  p2 <- ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) + 
    ggplot2::geom_histogram(bins = 10)
  
  # Call your function with a list of plots
  combined <- plots_grid(plots = list(p1, p2), ncol = 2)
  
  # Check that combined is indeed patchwork or gg object
  # Typically, patchwork results still inherit "ggplot" for printing
  expect_true(inherits(combined, c("patchwork", "gg", "ggplot")))
  
  # Optionally, we can check the structure
  # patchwork doesn't have a standard test for layers, so
  # we'll just confirm that it can be printed without error
  vdiffr::expect_doppelganger("plots_grid layout", combined)
  # ^ This uses the vdiffr package to ensure the output doesn't unexpectedly change.
})
