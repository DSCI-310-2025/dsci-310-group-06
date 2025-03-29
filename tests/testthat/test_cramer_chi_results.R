library(testthat)
library(tibble)

source("work/R/cramer_chi_results.R")

set.seed(100)
df <- tibble::tibble(
  Category1 = sample(c("A", "B", "C", "D"), 100, replace = TRUE),
  Category2 = sample(c("X", "Y"), 100, replace = TRUE),
  Category3 = sample(c(1, 2, 4.5), 100, replace = TRUE),
  Category4 = sample(c(1L, 2L, 3L), 100, replace = TRUE),
  Target = sample(c("Yes", "No"), 100, replace = TRUE)
)

empty_df <- tibble::tibble(Category1 = character(), Target = character())

# Unit Tests
test_that("cramer_chi_results returns expected structure", {
  categorical_vars <- c("Category1", "Category2")
  result <- cramer_chi_results(df, categorical_vars, "Target")
  
  testthat::expect_s3_class(result, "tbl_df")  # Check if result is a tibble
  testthat::expect_true(all(c("Variable", "Statistic", "DF", "p_value", "Expected_Min", "Expected_Max", "CramersV") %in% colnames(result)))
  testthat::expect_equal(nrow(result), length(categorical_vars))  # Should return results for each categorical variable
})

test_that("cramer_chi_results calculates valid column values", {
  categorical_vars <- c("Category1", "Category2")
  result <- cramer_chi_results(df, categorical_vars, "Target")
  
  testthat::expect_true(all(result$p_value >= 0 & result$p_value <= 1))  # p-value should be between 0 and 1
  testthat::expect_true(all(result$CramersV >= 0 & result$CramersV <= 1))  # Cramer's V should be between 0 and 1
  testthat::expect_true(all(result$Statistic > 0))  # Chi-square statistic should be positive
  testthat::expect_true(all(result$DF > 0))  # Degrees of freedom should be positive
})

test_that("cramer_chi_results handles empty input gracefully", {
  empty_df <- tibble::tibble(Category1 = character(), Target = character())
  testthat::expect_error(cramer_chi_results(empty_df, "Category1", "Target"), "Insufficient data: the dataframe is empty.")
})

test_that("cramer_chi_results handles incorrect input gracefully", {
  testthat::expect_error(cramer_chi_results(df, c("Category3", "Category4"), "Target"), "The following variables are not categorical: Category3, Category4")
})

test_that("cramer_chi_results returns consistent results with fixed seed", {
  categorical_vars <- c("Category1", "Category2")
  
  set.seed(100)
  result1 <- cramer_chi_results(df, categorical_vars, "Target")
  
  set.seed(100)
  result2 <- cramer_chi_results(df, categorical_vars, "Target")
  
  expect_equal(result1, result2)
})
