library(testthat)
source("~/work/R/quantitative_density.R")

#Sample data frames

set.seed(42)

# Typical data with multiple numeric columns
test_data <- data.frame(
  BMI = rnorm(100, mean = 25, sd = 5),
  Age = rnorm(100, mean = 50, sd = 10),
  Diabetes_binary = sample(c(0, 1), 100, replace = TRUE)
)

# Zero rows (but correct column names)
zero_rows_data <- data.frame(
  BMI = numeric(0),
  Diabetes_binary = numeric(0)
)

# Single row of data
single_row_data <- data.frame(
  BMI = 25,
  Diabetes_binary = 1
)

# Target column has only one level
one_level_data <- data.frame(
  BMI = rnorm(10, mean = 25, sd = 5),
  Diabetes_binary = rep(1, 10)  # All 1's
)

# Data with a non-numeric column
non_numeric_data <- data.frame(
  BMI = rnorm(10, mean = 25, sd = 5),
  Gender = sample(c("M", "F"), 10, replace = TRUE),
  Diabetes_binary = sample(c(0, 1), 10, replace = TRUE)
)

# Data with no columns at all (completely empty)
empty_df <- data.frame()






# Test 1 checks return type
test_that("quantitative_density returns a list of ggplot objects", {
  df <- data.frame(
    BMI = rnorm(10, 25, 5),
    Age = rnorm(10, 50, 10),
    Diabetes_binary = sample(0:1, 10, replace = TRUE)
  )
  
  plots <- quantitative_density(df, noncat_vars = c("BMI", "Age"), 
                                target_col = "Diabetes_binary")
  
  # Check that 'plots' is a list
  expect_type(plots, "list")
  # Check that length matches number of vars
  expect_equal(length(plots), 2)
  
  # Each element should be a ggplot object
  purrr::walk(plots, ~expect_s3_class(.x, "ggplot"))
})

## Test 2: Single variable argument test
test_that("quantitative_density works with a single variable", {
  df <- data.frame(
    BMI = rnorm(10, 25, 5),
    Diabetes_binary = sample(0:1, 10, replace = TRUE)
  )
  
  plots <- quantitative_density(df, noncat_vars = "BMI", target_col = "Diabetes_binary")
  
  expect_type(plots, "list")
  expect_equal(length(plots), 1)
  expect_s3_class(plots[["BMI"]], "ggplot")
})

  
# Test 3: Checks labelling 
test_that("quantitative_density sets expected labels", {
  df <- data.frame(
    BMI = rnorm(10, 25, 5),
    Diabetes_binary = sample(0:1, 10, replace = TRUE)
  )
  
  plots <- quantitative_density(df, noncat_vars = "BMI", target_col = "Diabetes_binary")
  p <- plots[["BMI"]]
  
  # Check the plot labels in the ggplot object
  expect_equal(p$labels$title, "Diabetes Binary by BMI")
  expect_equal(p$labels$x, "BMI")
  expect_equal(p$labels$y, "Density")
  expect_equal(p$labels$fill, "Diabetes Binary")
})
 #Test 4: Checks fill

test_that("quantitative_density uses scale_fill_manual", {
  df <- data.frame(
    BMI = rnorm(10, 25, 5),
    Diabetes_binary = sample(0:1, 10, replace = TRUE)
  )
  
  plots <- quantitative_density(df, noncat_vars = "BMI", target_col = "Diabetes_binary")
  p <- plots[["BMI"]]
  
  # Check that scale_fill_manual is included
  used_scales <- sapply(p$scales$scales, function(s) class(s)[1])
  expect_true("ScaleDiscrete" %in% used_scales) # This class typically arises from scale_fill_manual
})

#Edge cases 

test_that("Test 5: Zero rows (but correct columns) returns a plot (possibly empty)", {
  plots <- quantitative_density(
    data = zero_rows_data,
    noncat_vars = "BMI",
    target_col = "Diabetes_binary"
  )
  
  # Should return a list with one ggplot, even though the data is empty
  expect_type(plots, "list")
  expect_equal(length(plots), 1)
  expect_s3_class(plots[["BMI"]], "ggplot")
})

test_that("Test 6: Single row of data returns a plot", {
  plots <- quantitative_density(
    data = single_row_data,
    noncat_vars = "BMI",
    target_col = "Diabetes_binary"
  )
  
  expect_type(plots, "list")
  expect_equal(length(plots), 1)
  expect_s3_class(plots[["BMI"]], "ggplot")
})

test_that("Test 7: Target column with only one level still produces a plot", {
  plots <- quantitative_density(
    data = one_level_data,
    noncat_vars = "BMI",
    target_col = "Diabetes_binary"
  )
  
  expect_type(plots, "list")
  expect_equal(length(plots), 1)
  expect_s3_class(plots[["BMI"]], "ggplot")
})


#Error  cases

test_that("Test 8: Missing target_col in data", {
  missing_target_data <- data.frame(BMI = rnorm(10, 25, 5))

  expect_error(
    quantitative_density(
      data = missing_target_data,
      noncat_vars = "BMI",
      target_col = "Diabetes_binary"
    ),
    "Target column 'Diabetes_binary' not found in data."
  )
})

test_that("Test 9: Missing column in noncat_vars", {
    expect_error(
    quantitative_density(
      data = test_data,
      noncat_vars = "Weight",
      target_col = "Diabetes_binary"
    ),
    "The following vars are missing in data: Weight"
  )
})

test_that("Test 10: Non-numeric variable in noncat_vars", {
  # 'Gender' is non-numeric
  # Actual message: "The following vars are not numeric: Gender"
  expect_error(
    quantitative_density(
      data = non_numeric_data,
      noncat_vars = c("BMI", "Gender"),
      target_col = "Diabetes_binary"
    ),
    "The following vars are not numeric: Gender"
  )
})

test_that("Test 11: Completely empty data frame (no columns, no rows)", {
  expect_error(
    quantitative_density(
      data = empty_df,
      noncat_vars = "BMI",
      target_col = "Diabetes_binary"
    ),
    "Target column 'Diabetes_binary' not found in data."
  )
})

