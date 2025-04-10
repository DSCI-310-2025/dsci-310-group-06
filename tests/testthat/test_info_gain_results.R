library(testthat)
source("~/work/R/info_gain_results.R")

# Create a simple test dataset
test_data <- tibble::tibble(
  A = c("low", "high", "medium", "low", "medium"),
  B = c(1, 2, 1, 2, 3),
  C = c("yes", "no", "yes", "yes", "no"),
  target = c("class1", "class2", "class1", "class1", "class2")
)

# Expected Case
test_that("info_gain returns a sorted data frame object with correct column names", {
  result <- info_gain(test_data, target ~ .)
  
  expect_s3_class(result, "data.frame")
  expect_named(result, c("Variable", "Information_Gain"))
  expect_true(all(result$Information_Gain == sort(result$Information_Gain, decreasing = TRUE)))
})

test_that("info_gain returns numeric Information_Gain", {
  result <- info_gain(test_data, target ~ .)
  
  expect_true(is.numeric(result$Information_Gain))
})

test_that("info_gain returns a non-empty result", {
  result <- info_gain(test_data, target ~ .)
  
  expect_gt(nrow(result), 0)
})

# Edge Cases
test_that("info_gain works with a dataset with one predictor", {
  single_var_data <- test_data %>% dplyr::select(target, A)
  result <- info_gain(single_var_data, target ~ .)
  
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1)
  expect_equal(result$Variable, "A")
})

test_that("info_gain works with numeric-only predictors", {
  numeric_data <- tibble::tibble(
    x1 = rnorm(10),
    x2 = rnorm(10),
    y = sample(c("yes", "no"), 10, replace = TRUE)
  )
  result <- info_gain(numeric_data, y ~ .)
  
  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), 2)
})

# Error Cases
test_that("Empty data frame should return an error", {
  empty_df <- data.frame()
  
  expect_error(info_gain(empty_df, target ~ .), "Input data cannot be empty")
})

test_that("info_gain runs without errors for valid input", {
  result <- tryCatch({
    info_gain(test_data, target ~ .)
  }, error = function(e) {
    return(e)
  })
  
  expect_false(inherits(result, "error"))
})
