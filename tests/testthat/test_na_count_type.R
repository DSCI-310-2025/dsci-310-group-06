library(testthat)

source("work/R/na_count_type.R")

case_0 <- data.frame(
  a = c(1, 2, 2, NA, 5),
  b = c(1, 2, 3, NA, 3),
  stringsAsFactors = FALSE
)

case_1 <- data.frame(
  a = c(1, 2, 3, NA, 5),
  b = c("x", "y", "z", "x", NA),
  c = c(TRUE, FALSE, NA, TRUE, FALSE),
  d = c(3L, 4L, 4L, NA, NA),
  stringsAsFactors = FALSE
)

case_2 <- data.frame(
  a = c(1, 2, 3, NA, 5),
  b = c("x", "y", "z", "x", NA),
  c = c(TRUE, FALSE, NA, TRUE, FALSE),
  d = c(3L, 4L, 4L, NA, NA),
  stringsAsFactors = TRUE
)

case_3 <- data.frame(
  e = c(NA, NA, NA, NA, NA),
  f = c(NaN, NaN, NaN, NaN, NaN),
  stringsAsFactors = FALSE
)

case_4 <- data.frame(
  e = c(list("1", "a"), list(TRUE, 2)),
  stringsAsFactors = FALSE
)

case_5 <- data.frame(
  e = c(0.5, "2", TRUE, 1L, NA, NaN),
  f = c(0.5, 2, TRUE, 1L, NA, NaN),
  g = c(0L, 2L, TRUE, 1L, NA, NaN),
  h = c(0L, 0L, TRUE, 1L, NA, NaN),
  stringsAsFactors = FALSE
)

test_that("Monotype test", {
  result <- na_count_type(case_0)
  expect_equal(as.numeric(result["NA_Count",]), c(1, 1))
  expect_equal(as.numeric(result["Distinct_Count",]), c(4, 4))
  expect_equal(as.vector(result["Current_Data_Type",]), c("double", "double"))
  expect_is(result, "matrix")
  expect_type(result, "character")
})

test_that("Multitype test", {
  result <- na_count_type(case_1)
  expect_equal(as.numeric(result["NA_Count",]), c(1, 1, 1, 2))
  expect_equal(as.numeric(result["Distinct_Count",]), c(5, 4, 3, 3))
  expect_equal(as.vector(result["Current_Data_Type",]), c("double", "character", "logical", "integer"))
  expect_is(result, "matrix")
  expect_type(result, "character")
})

test_that("stringsAsFactors is TRUE", {
  result <- na_count_type(case_2)
  expect_equal(as.numeric(result["NA_Count",]), c(1, 1, 1, 2))
  expect_equal(as.numeric(result["Distinct_Count",]), c(5, 4, 3, 3))
  expect_equal(as.vector(result["Current_Data_Type",]), c("double", "integer", "logical", "integer"))
  expect_is(result, "matrix")
  expect_type(result, "character")
})

test_that("NA, NaN only", {
  result <- na_count_type(case_3)
  expect_equal(as.numeric(result["NA_Count",]), c(5, 5))
  expect_equal(as.numeric(result["Distinct_Count",]), c(1, 1))
  expect_equal(as.vector(result["Current_Data_Type",]), c("logical", "double"))
  expect_is(result, "matrix")
  expect_type(result, "character")
})

test_that("Each list item becomes column", {
  result <- na_count_type(case_4)
  expect_equal(as.numeric(result["NA_Count",]), c(0, 0, 0, 0))
  expect_equal(as.numeric(result["Distinct_Count",]), c(1, 1, 1, 1))
  expect_equal(as.vector(result["Current_Data_Type",]), c("character", "character", "logical", "double"))
  expect_is(result, "matrix")
  expect_type(result, "character")
})

test_that("Mixed within columns", {
  result <- na_count_type(case_5)
  expect_equal(as.numeric(result["NA_Count",]), c(1, 2, 2, 2))
  expect_equal(as.numeric(result["Distinct_Count",]), c(6, 5, 5, 4))
  expect_equal(as.vector(result["Current_Data_Type",]), c("character", "double", "double", "double"))
  expect_is(result, "matrix")
  expect_type(result, "character")
})

# test_that("NULL only", {
#   result <- na_count_type(case_6)
# #   expect_equal(as.numeric(result["NA_Count",]), 0)
# #   expect_equal(as.numeric(result["Distinct_Count",]), 0)
#   expect_equal(as.vector(result["Current_Data_Type",]), list())
#   expect_is(result$e, "NULL")
#   expect_is(result$f, "NULL")
#   expect_type(result, "list")
# })
