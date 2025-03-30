library(testthat)
source("~/work/R/lr_pipeline.R")

# Sample testing data frames
df <- data.frame(
  Diabetes_binary = factor(sample(0:1, 100, replace = TRUE)),
  v1 = rnorm(100),
  v2 = rnorm(100)
  )

df_small <- data.frame(
  Diabetes_binary = sample(0:1, 5, replace = TRUE),
  v1 = rnorm(5) 
)

# Expected cases
test_that("lr_pipeline function should return a valid workflow object", {
  output_path <- tempfile(fileext = ".rds")
  model <- lr_pipeline(df, "Diabetes_binary", 5, 10, "recall", output_path)
  
  expect_s3_class(model, "workflow")
})

test_that("Pipeline model is trained and contains a fitted model", {
  model <- lr_pipeline(df, "Diabetes_binary", 5, 10, "recall", output_path)
  fitted_model <- workflows::extract_fit_parsnip(model)
  
  best_lambda <- fitted_model$spec$args$penalty
  coefficients <- coef(fitted_model$fit, s = best_lambda)  

  expect_false(is.null(fitted_model))
  expect_true(length(coefficients) > 0)
  expect_true(any(coefficients != 0))
})

# Edge cases
test_that("Dataframe input into pipeline function should have more than 1 row", {
  df_single <- data.frame(
    Diabetes_binary = 0, 
    v1 = 1, 
    v2 = 2
    )
  
  expect_error(lr_pipeline(df_single, "Diabetes_Binary", 5, 10, "recall", output_path))
})

# Error cases
test_that("lr_pipeline function should run without errors", {
  output_path <- tempfile(fileext = ".rds")
  
  expect_error(
    lr_pipeline(df, "Diabetes_binary", 5, 10, "recall", output_path),
    NA
  )
})

test_that("Pipeline object is not empty", {
  output_path <- tempfile(fileext = ".rds")
  pipeline_object <- lr_pipeline(df, "Diabetes_binary", 5, 10, "recall", output_path)
  
  expect_false(is.null(pipeline_object))
  expect_true(length(pipeline_object) > 0)
})

test_that("Pipeline returns error if there are more folds than samples", {
  expect_error(lr_pipeline(df_small, "Diabetes_binary", 10, 10, "recall", output_path))
})
