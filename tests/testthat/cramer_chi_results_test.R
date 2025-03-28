library(testthat)
library(dplyr)
library(purrr)
library(vcd)
library(tibble)

source("R/cramer_chi_results.R")

# Sample Data
set.seed(123)
df <- tibble::tibble(
  Category1 = sample(c("A", "B", "C"), 100, replace = TRUE),
  Category2 = sample(c("X", "Y"), 100, replace = TRUE),
  Target = sample(c("Yes", "No"), 100, replace = TRUE)
)

# Unit Tests
test_that("cramer_chi_results returns expected structure", {
  categorical_vars <- c("Category1", "Category2")
  result <- cramer_chi_results(df, categorical_vars, "Target")
  
  testthat::expect_s3_class(result, "tbl_df")  # Check if result is a tibble
  testthat::expect_true(all(c("Variable", "Statistic", "DF", "p_value", "Expected_Min", "Expected_Max", "CramersV") %in% colnames(result)))
  testthat::expect_equal(nrow(result), length(categorical_vars))  # Should return results for each categorical variable
})


test_that("cramer_chi_results calculates valid chi-square values", {
  categorical_vars <- c("Category1", "Category2")
  result <- cramer_chi_results(df, categorical_vars, "Target")
  
  testthat::expect_true(all(result$p_value >= 0 & result$p_value <= 1))  # p-value should be between 0 and 1
  testthat::expect_true(all(result$CramersV >= 0 & result$CramersV <= 1))  # Cramer's V should be between 0 and 1
})

test_that("cramer_chi_results handles empty input gracefully", {
  empty_df <- tibble::tibble(Category1 = character(), Target = character())
  testthat::expect_error(cramer_chi_results(empty_df, "Category1", "Target"), "Insufficient data")
})
