# test-plots_grid.R
library(testthat)
source("work/R/plots_grid.R")


# expected cases ---------------------------------------------------------------
test_that("plots_grid combines bar and density plots correctly", {
  # Create dummy ggplot objects for bar and density plots
  bar_plots <- list(ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) + ggplot2::geom_bar())
  density_plots <- list(ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) + ggplot2::geom_density())
  
  # Call the function with these plot lists
  result <- plots_grid(bar_plots, density_plots, num_cols = 2)
  
  # Check if the result is a ggplot object (the return type from patchwork is ggplot)
  expect_s3_class(result, "gg")
})

# edge cases -------------------------------------------------------------------

test_that("plots_grid handles empty plot lists", {
  bar_plots <- list()
  density_plots <- list()
  
  # Call the function with empty plot lists
  result <- plots_grid(bar_plots, density_plots, num_cols = 2)
  
  # Check that the result is still a ggplot object, but effectively empty
  expect_s3_class(result, "gg")
  expect_equal(length(result$layers), 0)
})


test_that("plots_grid handles large num_cols gracefully", {
  bar_plots <- list(ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) + ggplot2::geom_bar())
  density_plots <- list(ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) + ggplot2::geom_density())
  
  # Call the function with a large number of columns
  result <- plots_grid(bar_plots, density_plots, num_cols = 100)
  
  # Check that the result is a ggplot object
  expect_s3_class(result, "gg")
})


# error cases ------------------------------------------------------------------

test_that("plots_grid handles invalid inputs", {
  bar_plots <- NULL
  density_plots <- list(ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) + ggplot2::geom_density())
  
  # Expect an error due to invalid bar_plots input
  expect_error(plots_grid(bar_plots, density_plots), "Both 'bar_plots' and 'density_plots' must be lists of ggplot objects.")
  
  # Testing invalid type for density_plots
  bar_plots <- list(ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg)) + ggplot2::geom_bar())
  density_plots <- "not_a_plot"
  
  # Expect an error due to invalid density_plots input
  expect_error(plots_grid(bar_plots, density_plots), "Both 'bar_plots' and 'density_plots' must be lists of ggplot objects.")
})


