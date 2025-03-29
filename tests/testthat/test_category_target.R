library(testthat)

source("work/R/category_target.R")

case_1 <- data.frame(
  a = c(1, 2, 3, 4, 5),
  b = c("z", "y", "z", "x", NA),
  c = c(TRUE, FALSE, TRUE, TRUE, FALSE),
  d = c(4L, 4L, 3L, NA, NA),
  e = c(TRUE, TRUE, TRUE, TRUE, TRUE),
  f = c(NaN, NaN, NaN, NaN, NaN),
  g = c(NA, NA, NA, NA, NA),
  h = c(NA, TRUE, 1, "1", 1L),
  i = c(1, "1", TRUE, FALSE, "FALSE"),
  stringsAsFactors = FALSE
)

test_that("All distinct, doubles", {
  result_1 <- category_target(case_1, a)
  expect_equal(result_1[["a"]], c(1, 2, 3, 4, 5))
  expect_equal(result_1[["Count"]], c(1, 1, 1, 1, 1))
  expect_equal(result_1[["Proportion"]], c(0.2, 0.2, 0.2, 0.2, 0.2))
})

test_that("1 repeat, characters", {
  result_1 <- category_target(case_1, b)
  expect_equal(result_1[["b"]], c("x", "y", "z", NA))
  expect_equal(result_1[["Count"]], c(1, 1, 2, 1))
  expect_equal(result_1[["Proportion"]], c(0.2, 0.2, 0.4, 0.2))
})

test_that("booleans", {
  result_1 <- category_target(case_1, c)
  expect_equal(result_1[["c"]], c(FALSE, TRUE))
  expect_equal(result_1[["Count"]], c(2, 3))
  expect_equal(result_1[["Proportion"]], c(0.4, 0.6))
})

test_that("integers", {
  result_1 <- category_target(case_1, d)
  expect_equal(result_1[["d"]], c(3L, 4L, NA))
  expect_equal(result_1[["Count"]], c(1, 2, 2))
  expect_equal(result_1[["Proportion"]], c(0.2, 0.4, 0.4))
})

test_that("booleans, all TRUE", {
  result_1 <- category_target(case_1, e)
  expect_equal(result_1[["e"]], c(TRUE))
  expect_equal(result_1[["Count"]], c(5))
  expect_equal(result_1[["Proportion"]], c(1))
})

test_that("NaN", {
  result_1 <- category_target(case_1, f)
  expect_equal(result_1[["f"]], c(NaN))
  expect_equal(result_1[["Count"]], c(5))
  expect_equal(result_1[["Proportion"]], c(1))
})

test_that("NA", {
  result_1 <- category_target(case_1, g)
  expect_equal(result_1[["g"]], c(NA))
  expect_equal(result_1[["Count"]], c(5))
  expect_equal(result_1[["Proportion"]], c(1))
})

test_that("Mixed, 1 in multiple types", {
  result_1 <- category_target(case_1, h)
  expect_equal(result_1[["h"]], c("1", TRUE, NA))
  expect_equal(result_1[["Count"]], c(3, 1, 1))
  expect_equal(result_1[["Proportion"]], c(0.6, 0.2, 0.2))
})

test_that("Mixed, more FALSE than TRUE", {
  result_1 <- category_target(case_1, i)
  expect_equal(result_1[["i"]], c("1", FALSE, TRUE))
  expect_equal(result_1[["Count"]], c(2, 2, 1))
  expect_equal(result_1[["Proportion"]], c(0.4, 0.4, 0.2))
})
