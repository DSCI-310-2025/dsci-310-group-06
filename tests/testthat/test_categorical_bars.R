library(testthat)
source("~/work/R/categorical_bars.R")

library(testthat)
library(ggplot2)

# Sample testing data frame
test_df <- data.frame(
  v1 = factor(c(4, 6, 6, 8, 4)),
  v2 = factor(c(3, 4, 5, 4, 3)),
  target = factor(c(0, 1, 1, 0, 1))
)

# Expected/base cases
test_that("categorical_bars returns a list of ggplot objects", {
  result <- categorical_bars(
    data_frame = test_df,
    cat_vars = c("v1", "v2"),
    target_col = "target"
  )
  
  expect_type(result, "list")
  expect_true(all(sapply(result, inherits, "gg")) )
})

test_that("categorical_bars returns a plot for each categorical variable", {
  result <- categorical_bars(
    data_frame = test_df,
    cat_vars = c("v1", "v2"),
    target_col = "target"
  )
  
  expect_length(result, 2)
})

test_that("categorical_bars plot titles and axis labels are correct", {
  result <- categorical_bars(
    data_frame = test_df,
    cat_vars = c("v1"),
    target_col = "target"
  )
  
  expect_true(grepl("Diabetes Binary by v1", result[["v1"]]$labels$title))
  
  # Check axis labels
  expect_equal(result[["v1"]]$labels$x, "v1")
  expect_equal(result[["v1"]]$labels$y, "Proportion")
})

test_that("categorical_bars title and axis text sizes are correct", {
  result <- categorical_bars(
    data_frame = test_df,
    cat_vars = c("v1"),
    target_col = "target"
  )
  
  expect_equal(result[["v1"]]$theme$plot.title$size, 30)  # Default title_size
  expect_equal(result[["v1"]]$theme$axis.text$size, 35)  # Default axis_size
})

# Edge cases
test_that("categorical_bars handles empty dataframe correctly", {
  result <- categorical_bars(
    data_frame = data.frame(),
    cat_vars = c("v1"),
    target_col = "target"
  )
  
  expect_length(result, 0)
})

test_that("categorical_bars handles non-existing categorical variable (not in data
          frame)", {
  result <- categorical_bars(
    data_frame = test_df,
    cat_vars = c("non_existing_var"),
    target_col = "target"
  )
  
  expect_length(result, 0)
})

# Error case
test_that("Check if target_col is specified", {
  test_df_missing_target <- data.frame(
    v1 = factor(c(1, 2, 3, 4, 5)),
    v2 = factor(c(6, 7, 8, 9, 10))
  )
  
  # Expect an error when 'target_col' is missing in the data
  expect_error(
    categorical_bars(
      data_frame = test_df_missing_target,
      cat_vars = c("v1", "v2")
    ),
    "Target column must be specified."
  )
})

test_that("Check if cat_vars is specified", {
  test_df_missing_target <- data.frame(
    v1 = factor(c(1, 2, 3, 4, 5)),
    v2 = factor(c(6, 7, 8, 9, 10))
  )
  
  # Expect an error when 'cat_vars' is missing
  expect_error(
    categorical_bars(
      data_frame = test_df_missing_target,
      cat_vars = NULL,
      target_col = "v1"
    ),
    "Categorical variables must be specified."
  )
})