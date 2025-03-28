library(testthat)

source("work/R/categorical_bars.R")
# test-categorical_bars.R

test_that("categorical_bars returns a ggplot object", {
  # Minimal example data
  df <- data.frame(
    Group = sample(c("A", "B"), 50, replace = TRUE),
    Outcome = sample(0:1, 50, replace = TRUE)
  )
  
  # Call the function
  p <- categorical_bars(
    data = df,
    x_var = "Group",
    fill_var = "Outcome"
  )
  
  # Test that p is a ggplot object
  expect_s3_class(p, "ggplot")
  
  # You could also check that it has the layers you expect
  expect_equal(length(p$layers), 1)  # one geom_bar
  expect_true("PositionFill" %in% class(p$layers[[1]]$position))
  
  # Check labels
  expect_equal(p$labels$x, "Group")
  expect_equal(p$labels$y, "Proportion")
})


cat("✅ categorical_bars test passed!\n")

