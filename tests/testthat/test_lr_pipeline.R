library(testthat)

source("~/work/R/lr_pipeline.R")

test_that("lr_pipeline should run without errors", {
  df <- data.frame(
    Diabetes_binary = factor(sample(0:1, 100, replace = TRUE)),
    v1 = rnorm(100),
    v2 = rnorm(100)
  )
  
  output_path <- tempfile(fileext = ".rds")
  
  expect_error(
    lr_pipeline(df, "Diabetes_binary", 5, 10, "recall", output_path),
    NA
  )
})

test_that("lr_pipeline should return a valid workflow object", {
  df <- data.frame(
    Diabetes_binary = factor(sample(0:1, 100, replace = TRUE)),
    v1 = rnorm(100),
    v2 = rnorm(100)
  )
  
  output_path <- tempfile(fileext = ".rds")
  model <- lr_pipeline(df, "Diabetes_binary", 5, 10, "recall", output_path)
  
  expect_s3_class(model, "workflow")
})

test_that("lr_pipeline should created a valid RDS file in the output directory", {
  df <- data.frame(
    Diabetes_binary = factor(sample(0:1, 100, replace = TRUE)),
    v1 = rnorm(100),
    v2 = rnorm(100)
  )
  
  output_path <- tempfile(fileext = ".rds")
  lr_pipeline(df, "Diabetes_binary", 5, 10, "recall", output_path)
  
  expect_true(file.exists(output_path))
})