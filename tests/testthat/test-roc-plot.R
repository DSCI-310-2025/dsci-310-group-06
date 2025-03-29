library(testthat)
source("work/R/roc_plot.R")

# ------------------------------------------------------------------------------
# Sample data for testing
set.seed(42)
test_data <- data.frame(
  Diabetes_binary = factor(sample(c(0, 1), 100, replace = TRUE)),
  .pred_1 = runif(100)
)

# Extreme probabilities test data
model_outputs_extreme <- data.frame(
  Diabetes_binary = factor(c(1, 0, 1, 1, 0)),
  .pred_1 = c(1, 0, 1, 1, 0)  # Extreme values: 1 and 0
)

# Expected cases ---------------------------------------------------------------

# Test 1: Check if roc_plot returns a valid ggplot object
test_that("roc_plot returns a ggplot object", {
  output_plot <- roc_plot(
    test_data, 
    "Diabetes_binary", 
    ".pred_1", 
    0.85, 
    tempfile(fileext = ".png")
  )
  
  expect_s3_class(output_plot, "gg")
})

test_that("roc_plot returns a ggplot2 object", {
  output_plot <- roc_plot(
    test_data, 
    "Diabetes_binary", 
    ".pred_1", 
    0.85, 
    tempfile(fileext = ".png")
  )
  
  expect_s3_class(output_plot, "ggplot")
})

# Test 2: Check layer structure (GeomPath)
test_that("roc_plot contains GeomPath layer", {
  output_plot <- roc_plot(test_data, "Diabetes_binary", ".pred_1", 0.85, tempfile(fileext = ".png"))
  expect_equal(class(output_plot$layers[[1]]$geom)[1], "GeomPath")
})

# Test 3: Check layer structure (GeomAbline)
test_that("roc_plot contains GeomAbline layer", {
  output_plot <- roc_plot(test_data, "Diabetes_binary", ".pred_1", 0.85, tempfile(fileext = ".png"))
  expect_equal(class(output_plot$layers[[2]]$geom)[1], "GeomAbline")
})

# Test 4: Check layer structure (GeomText)
test_that("roc_plot contains GeomText layer", {
  output_plot <- roc_plot(test_data, "Diabetes_binary", ".pred_1", 0.85, tempfile(fileext = ".png"))
  expect_equal(class(output_plot$layers[[3]]$geom)[1], "GeomText")
})

# Test 5: Check number of layers
test_that("roc_plot has exactly 3 layers", {
  output_plot <- roc_plot(test_data, "Diabetes_binary", ".pred_1", 0.85, tempfile(fileext = ".png"))
  expect_length(output_plot$layers, 3)
})

# Edge cases -------------------------------------------------------------------

# Test 6: AUC value at lower boundary (0)
test_that("AUC value at lower boundary works", {
  expect_silent(roc_plot(test_data, "Diabetes_binary", ".pred_1", 0, tempfile(fileext = ".png")))
})

# Test 7: AUC value at upper boundary (1)
test_that("AUC value at upper boundary works", {
  expect_silent(roc_plot(test_data, "Diabetes_binary", ".pred_1", 1, tempfile(fileext = ".png")))
})

# Test 8: AUC value below lower boundary
test_that("AUC value below lower boundary fails", {
  expect_error(
    roc_plot(test_data, "Diabetes_binary", ".pred_1", -0.000001, tempfile()),
    "AUC value must be between 0 and 1"
  )
})

# Test 9: AUC value above upper boundary
test_that("AUC value above upper boundary fails", {
  expect_error(
    roc_plot(test_data, "Diabetes_binary", ".pred_1", 1.000001, tempfile()),
    "AUC value must be between 0 and 1"
  )
})

# Test 10: Handle extreme predicted probabilities
test_that("ROC plot handles extreme predicted probabilities", {
  expect_error(
    roc_plot(model_outputs_extreme, "Diabetes_binary", ".pred_1", 0.85, "roc_curve_plot.png"),
    NA
  )
})

# Error cases ------------------------------------------------------------------

# Test 11: Empty data frame
test_that("Function handles empty data frame error", {
  expect_error(
    roc_plot(data.frame(), "Diabetes_binary", ".pred_1", 0.85, tempfile(fileext = ".png")),
    "Error: Model outputs or columns cannot be empty."
  )
})

# Test 12: Missing '.pred_1' column
test_that("Function handles missing '.pred_1' column", {
  expect_error(
    roc_plot(data.frame(Diabetes_binary = c(0, 1, 0)), "Diabetes_binary", ".pred_1", 0.85, tempfile(fileext = ".png")),
    "Error: Column '.pred_1' not found in model outputs."
  )
})

# Test 13: Missing 'Diabetes_binary' column
test_that("Function handles missing 'Diabetes_binary' column", {
  expect_error(
    roc_plot(data.frame(.pred_1 = c(0.1, 0.4, 0.6)), "Diabetes_binary", ".pred_1", 0.85, tempfile(fileext = ".png")),
    "Error: Column 'Diabetes_binary' not found in model outputs."
  )
})

# Test 14: Missing AUC value
test_that("Function handles missing AUC value", {
  expect_error(
    roc_plot(data.frame(Diabetes_binary = c(0, 1, 0), .pred_1 = c(0.2, 0.8, 0.5)), "Diabetes_binary", ".pred_1", NA, tempfile(fileext = ".png")),
    "Error: AUC value cannot be missing."
  )
})

# Test 15: Empty output file path
test_that("Function handles empty output file path", {
  expect_error(
    roc_plot(data.frame(Diabetes_binary = c(0, 1, 0), .pred_1 = c(0.2, 0.8, 0.5)), "Diabetes_binary", ".pred_1", 0.85, ""),
    "Error: Output file path cannot be empty."
  )
})
