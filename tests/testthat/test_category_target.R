library(testthat)
source("~/work/R/category_target.R")

# Sample data frame with various categorical and mixed-type variables
case_1 <- data.frame(
  a = c(1, 2, 3, 4, 5),  # Numeric variable with unique values
  b = c("z", "y", "z", "x", NA),  # Categorical variable with one repeated value and an NA
  c = c(TRUE, FALSE, TRUE, TRUE, FALSE),  # Boolean variable
  d = c(4L, 4L, 3L, NA, NA),  # Integer variable with some missing values
  e = c(TRUE, TRUE, TRUE, TRUE, TRUE),  # Boolean variable, all TRUE
  f = c(NaN, NaN, NaN, NaN, NaN),  # Column filled with NaN
  g = c(NA, NA, NA, NA, NA),  # Column filled with NA
  h = c(NA, TRUE, 1, "1", 1L),  # Mixed-type variable with multiple representations of "1"
  i = c(1, "1", TRUE, FALSE, "FALSE"),  # Mixed-type variable with logical and string representations
  stringsAsFactors = FALSE
)

# Expected cases
test_that("Unique numeric values should have equal proportions", {
  result <- category_target(case_1, a)
  expect_equal(result[["a"]], c(1, 2, 3, 4, 5))
  expect_equal(result[["Count"]], rep(1, 5))
  expect_equal(result[["Proportion"]], rep(0.2, 5))
})

test_that("Categorical variable with one repeated value and an NA", {
  result <- category_target(case_1, b)
  expect_equal(result[["b"]], c("x", "y", "z", NA))
  expect_equal(result[["Count"]], c(1, 1, 2, 1))
  expect_equal(result[["Proportion"]], c(0.2, 0.2, 0.4, 0.2))
})

test_that("Boolean variable should correctly count TRUE and FALSE values", {
  result <- category_target(case_1, c)
  expect_equal(result[["c"]], c(FALSE, TRUE))
  expect_equal(result[["Count"]], c(2, 3))
  expect_equal(result[["Proportion"]], c(0.4, 0.6))
})

test_that("Integer variable with missing values", {
  result <- category_target(case_1, d)
  expect_equal(result[["d"]], c(3L, 4L, NA))
  expect_equal(result[["Count"]], c(1, 2, 2))
  expect_equal(result[["Proportion"]], c(0.2, 0.4, 0.4))
})

test_that("Boolean variable with all TRUE values should return single category", {
  result <- category_target(case_1, e)
  expect_equal(result[["e"]], c(TRUE))
  expect_equal(result[["Count"]], c(5))
  expect_equal(result[["Proportion"]], c(1))
})

# Edge cases
test_that("Column containing only NaN values should return NaN category", {
  result <- category_target(case_1, f)
  expect_equal(result[["f"]], c(NaN))
  expect_equal(result[["Count"]], c(5))
  expect_equal(result[["Proportion"]], c(1))
})

test_that("Column containing NA values should return NA category", {
  result <- category_target(case_1, g)
  expect_equal(result[["g"]], c(NA))
  expect_equal(result[["Count"]], c(5))
  expect_equal(result[["Proportion"]], c(1))
})

test_that("Mixed-type variable with multiple representations of 1", {
  result <- category_target(case_1, h)
  expect_equal(result[["h"]], c("1", TRUE, NA))
  expect_equal(result[["Count"]], c(3, 1, 1))
  expect_equal(result[["Proportion"]], c(0.6, 0.2, 0.2))
})

test_that("Mixed-type variable with varying representations of FALSE and TRUE", {
  result <- category_target(case_1, i)
  expect_equal(result[["i"]], c("1", FALSE, TRUE))
  expect_equal(result[["Count"]], c(2, 2, 1))
  expect_equal(result[["Proportion"]], c(0.4, 0.4, 0.2))
})

# Error case
test_that("Empty data frame should return an error", {
  empty_df <- data.frame()
  expect_error(category_target(empty_df, "a"), "Input data cannot be empty")
})
