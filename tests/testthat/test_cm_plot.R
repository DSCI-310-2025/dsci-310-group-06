# test-cm_plot.R
library(testthat)
source("work/R/cm_plot.R")
test_that("cm_plot returns a ggplot object from a yardstick::conf_mat()", {
  # Minimal example using yardstick
  df <- data.frame(
    truth = factor(c(0, 0, 1, 1, 1)),
    estimate = factor(c(0, 1, 1, 1, 0))
  )
  cm <- yardstick::conf_mat(df, truth = truth, estimate = estimate)
  
  # Call the function
  p <- cm_plot(cm)
  
  # Check it's a ggplot
  expect_s3_class(p, "ggplot")
  
  # Check there's a geom_tile
  expect_true(any(sapply(p$layers, function(x) inherits(x$geom, "GeomTile"))))
  
  # Check the label
  expect_true(any(sapply(p$layers, function(x) inherits(x$geom, "GeomText"))))
  
  # Confirm the fill scale
  expect_true(inherits(p$scales$get_scales("fill"), "ScaleContinuous"))
})
