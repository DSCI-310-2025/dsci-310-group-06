library(testthat)

source("R/col_to_factor.R")
source("R/na_count_type.R")

case_1 <- data.frame(
  a = c(1, 2, 3, NA, 5),
  b = c("x", "y", "z", "x", NA),
  c = c(TRUE, FALSE, NA, TRUE, FALSE),
  d = c(3L, 4L, 4L, NA, NA),
  stringsAsFactors = FALSE
)

case_2 <- data.frame(
  e = c(NA, NA, NA, NA, NA),
  f = c(NaN, NaN, NaN, NaN, NaN),
  stringsAsFactors = FALSE
)

case_3 <- data.frame(
  e = c(0.5, "2", TRUE, 1L, NA, NaN),
  f = c(0.5, 2, TRUE, 1L, NA, NaN),
  g = c(0L, 2L, TRUE, 1L, NA, NaN),
  h = c(0L, 0L, TRUE, 1L, NA, NaN),
  stringsAsFactors = FALSE
)

test_that("Factor ONLY characters", {
  result_1 <- na_count_type(case_1)
  expect_equal(as.numeric(result_1["NA_Count",]), c(1, 1, 1, 2))
  expect_equal(as.numeric(result_1["Distinct_Count",]), c(5, 4, 3, 3))
  expect_equal(as.vector(result_1["Current_Data_Type",]), c("double", "character", "logical", "integer"))

  result_2 <- na_count_type(col_to_factor(case_1))
  expect_equal(as.numeric(result_2["NA_Count",]), c(1, 1, 1, 2))
  expect_equal(as.numeric(result_2["Distinct_Count",]), c(5, 4, 3, 3))
  expect_equal(as.vector(result_2["Current_Data_Type",]), c("double", "integer", "logical", "integer"))
})

test_that("NA, NaN only", {
  result_1 <- na_count_type(case_2)
  expect_equal(as.numeric(result_1["NA_Count",]), c(5, 5))
  expect_equal(as.numeric(result_1["Distinct_Count",]), c(1, 1))
  expect_equal(as.vector(result_1["Current_Data_Type",]), c("logical", "double"))

  result_2 <- na_count_type(col_to_factor(case_2))
  expect_equal(as.numeric(result_2["NA_Count",]), c(5, 5))
  expect_equal(as.numeric(result_2["Distinct_Count",]), c(1, 1))
  expect_equal(as.vector(result_2["Current_Data_Type",]), c("logical", "double"))
})

test_that("Mixed within columns", {
  result_1 <- na_count_type(case_3)
  expect_equal(as.numeric(result_1["NA_Count",]), c(1, 2, 2, 2))
  expect_equal(as.numeric(result_1["Distinct_Count",]), c(6, 5, 5, 4))
  expect_equal(as.vector(result_1["Current_Data_Type",]), c("character", "double", "double", "double"))

  result_2 <- na_count_type(col_to_factor(case_3))
  expect_equal(as.numeric(result_2["NA_Count",]), c(1, 2, 2, 2))
  expect_equal(as.numeric(result_2["Distinct_Count",]), c(6, 5, 5, 4))
  expect_equal(as.vector(result_2["Current_Data_Type",]), c("integer", "double", "double", "double"))
})
