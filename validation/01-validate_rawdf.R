doc <- "This script data validation on the raw dataset

Usage: 01-validate_rawdf --raw_df=<raw_df> --output_report=<output_report>

Options:
  --raw_df=<raw_df>               Path to obtain the raw dataset CSV file
  --output_report=<output_report> Path to output report file
"

library(tidyverse)
library(pointblank)
library(docopt)

# ------------------------------------------------------------------------------
# Read in the df

opt <- docopt::docopt(doc)
raw_df <- readr::read_csv(opt$raw_df)

agent <- pointblank::create_agent(tbl = raw_df)

# ------------------------------------------------------------------------------
# Validations

# (1) Correct data file format

# (2) Correct column names

# (3) No empty observations
agent <- agent %>%
  pointblank::rows_complete()

# (4) Missingness threshold - stop if more than 10% missing
agent <- agent %>%
  pointblank::col_vals_not_null(
    columns = everything(),
    actions = action_levels(warn_at = 0.05, stop_at = 0.1)
  )

# (5) Correct data types in each column

# (6) No duplicate observations

# (7) No outlier or anomalous values
numeric_cols <- raw_df %>% 
  dplyr::select(where(is.numeric)) %>% 
  colnames()

for (col in numeric_cols) {
  q1 <- quantile(raw_df[[col]], 0.25, na.rm = TRUE)
  q3 <- quantile(raw_df[[col]], 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower_bound <- q1 - 1.5 * iqr
  upper_bound <- q3 + 1.5 * iqr

  precond_expr <- rlang::new_formula(
    NULL,
    rlang::expr(. %>% dplyr::filter(!is.na(!!sym(col))))
  )
  agent <- agent %>%
    col_vals_between(
      columns = {{ col }},
      left = lower_bound,
      right = upper_bound,
      na_pass = TRUE,
      preconditions = precond_expr,
      actions = action_levels(warn_at = 0.25, stop_at = 0.05),
      brief = paste0("Check for outliers in ", col),
    )
}

# (8) Correct category levels (No string mismatches or single values)

## String mismatches
expected_levels <- list(
  HighBP = c(0, 1),
  HighChol = c(0, 1),
  CholCheck = c(0, 1),
  Smoker = c(0, 1),
  Stroke = c(0, 1),
  HeartDiseaseorAttack = c(0, 1),
  PhysActivity = c(0, 1),
  Fruits = c(0, 1),
  Veggies = c(0, 1),
  HvyAlcoholConsump = c(0, 1),
  AnyHealthcare = c(0, 1),
  NoDocbcCost = c(0, 1),
  DiffWalk = c(0, 1),
  Sex = c(0, 1),
  Age = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13),
  Education = c(1, 2, 3, 4, 5, 6),
  Income = c(1, 2, 3, 4, 5, 6, 7, 8),
  MentHlth = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
               16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30),
  PhysHlth = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
               16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30),
  GenHlth = c(1, 2, 3, 4, 5)
)

for (col in names(expected_levels)) {
  agent <- agent %>%
    col_vals_in_set(
      columns = {{ col }},
      set = expected_levels[[col]],
      actions = action_levels(warn_at = 0.01, stop_at = 0.05),
    )
}

## Singleton values (Cannot find any function in pointblank for this)
categorical_vars <- c("HighBP", "HighChol", "CholCheck", "Smoker", "Stroke", 
                      "HeartDiseaseorAttack", "PhysActivity", "Fruits", "Veggies",
                      "HvyAlcoholConsump", "AnyHealthcare", "NoDocbcCost", 
                      "DiffWalk", "Sex", "Age", "Education", "Income", "MentHlth",
                      "PhysHlth", "GenHlth")

for (col in categorical_vars) {
  col_counts <- raw_df %>%
    count(.data[[col]]) %>%
    filter(n == 1)

  if (nrow(col_counts) > 0) {
    warning(paste0("Column '", col, "' has singleton categories: ",
                   paste(col_counts[[1]], collapse = ", ")))
  }
}

# ------------------------------------------------------------------------------
# final interrogation

agent <- agent %>%
  pointblank::interrogate()

# ------------------------------------------------------------------------------
# Report output logic in work/reports/
# report error in terminal if issue

pointblank::export_report(agent, filename = opt$output_report)

# Check validation results
if (all(is.na(agent$validation_set$warn) & is.na(agent$validation_set$notify))) {
  message("Validation passed for raw data. Report saved to: ", opt$output_report)
} else {
  warning("Validation issues detected for raw data. Please review the report at: ", opt$output_report)
}