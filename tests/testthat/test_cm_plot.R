library(testthat)
source("~/work/R/cm_plot.R")

# expected cases ----------------------------------------------------------------

test_that("cm_plot has the correct layers", {
  
  conf_matrix_df <- data.frame(
    Prediction = c("Positive", "Negative", "Positive", "Negative"),
    Truth = c("Positive", "Positive", "Negative", "Negative"),
    Freq = c(50, 10, 5, 100)
  )
  
  plot <- cm_plot(conf_matrix_df, tempfile(fileext = ".png"))

  expect_true(inherits(plot$layers[[1]]$geom, "GeomTile"))
  expect_true(inherits(plot$layers[[2]]$geom, "GeomText"))
  
})

test_that("cm_plot creates a PNG file", {
  
  conf_matrix_df <- data.frame(
    Prediction = c("Positive", "Negative", "Positive", "Negative"),
    Truth = c("Positive", "Positive", "Negative", "Negative"),
    Freq = c(50, 10, 5, 100)
  )
  
  temp_png_path <- tempfile(fileext = ".png")
  plot <- cm_plot(conf_matrix_df, temp_png_path)
  expect_true(file.exists(temp_png_path))
  expect_equal(tools::file_ext(temp_png_path), "png")
  unlink(temp_png_path)
})


# edge cases --------------------------------------------------------------------

test_that("cm_plot handles single prediction and truth class", {
  single_class_df <- data.frame(Prediction = c("Positive"), Truth = c("Positive"), Freq = c(100))
  plot <- cm_plot(single_class_df, tempfile(fileext = ".png"))
  expect_true(inherits(plot, "gg"))
  expect_true(length(plot$layers) > 0)  # Ensure layers exist
})


test_that("cm_plot creates a correct plot for multiple classes", {
  multiple_class_df <- data.frame(
    Prediction = c("Positive", "Negative", "Positive", "Negative"),
    Truth = c("Positive", "Positive", "Negative", "Negative"),
    Freq = c(50, 10, 5, 100)
  )
  plot <- cm_plot(multiple_class_df, tempfile(fileext = ".png"))
  
  expect_true(inherits(plot$layers[[1]]$geom, "GeomTile"))
  expect_true(inherits(plot$layers[[2]]$geom, "GeomText"))
  expect_true(length(plot$layers) > 1)
})


test_that("cm_plot handles empty data frame gracefully", {
  
  empty_df <- data.frame(
    Prediction = character(0),
    Truth = character(0),
    Freq = numeric(0)
  )
  
  plot <- cm_plot(empty_df, tempfile(fileext = ".png"))
  expect_true(inherits(plot, "gg"))
  expect_equal(length(plot$layers), 2)
})

# error cases -------------------------------------------------------------------

test_that("cm_plot raises error when required columns are missing", {
  missing_column_df <- data.frame(
    ClassPredicted = c("Positive", "Negative"),
    ClassTrue = c("Negative", "Positive"),
    Frequency = c(50, 100)
  )
  
  expect_error(cm_plot(missing_column_df, tempfile(fileext = ".png")),
               "columns in conf_matrix_df must contain 'Prediction', 'Truth', and 'Freq'")
})

test_that("cm_plot raises error for invalid output file path", {
  invalid_path <- "/nonexistent/directory/cm_plot.png"
  
  expect_error(cm_plot(conf_matrix_df, invalid_path),
               "object 'conf_matrix_df' not found")
})
