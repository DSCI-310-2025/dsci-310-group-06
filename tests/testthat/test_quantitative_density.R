# test-quantitative_density.R
library(testthat)

source("work/R/quantitative_density.R")

test_that("quantitative_density returns a ggplot object", {
  # Minimal example data
  set.seed(123)
  df <- data.frame(
    BMI = rnorm(50, mean = 25, sd = 5),
    Diabetes_binary = sample(0:1, 50, replace = TRUE)
  )
  
  # Call the function
  p <- quantitative_density(
    data = df,
    var = "BMI",
    fill_var = "Diabetes_binary"
  )
  
  # Test that p is a ggplot object
  expect_s3_class(p, "ggplot")
  
  # Check we have one geom_density layer
  expect_true(any(sapply(p$layers, function(x) inherits(x$geom, "GeomDensity"))))
  
  # Check fill and alpha
  # (No 'alpha' argument is tested by default if you haven't parameterized it,
  #  but you could if you have that in your function.)
  expect_equal(p$labels$x, "BMI")
  expect_equal(p$labels$y, "Density")
})
