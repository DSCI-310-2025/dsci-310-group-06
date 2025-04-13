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
expected_schema <- col_schema(
  "Diabetes_binary",
  "HighBP",
  "HighChol",
  "CholCheck",
  "BMI",
  "Smoker",
  "Stroke",
  "HeartDiseaseorAttack",
  "PhysActivity",
  "Fruits",
  "Veggies",
  "HvyAlcoholConsump",
  "AnyHealthcare",
  "NoDocbcCost",
  "DiffWalk",
  "Sex",
  "Age",
  "Education",
  "Income",
  "MentHlth",
  "PhysHlth",
  "GenHlth")

agent <- agent %>%
  pointblank::col_schema_match(schema = expected_schema)

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
agent <- agent %>%
  pointblank::col_is_numeric(columns = everything())

# (6) No duplicate observations - stop if more than 1% are duplicated
agent <- agent %>%
  pointblank::rows_distinct(
    actions = action_levels(warn_at = 0.01, stop_at = 0.1)
  )

# (7) No outlier or anomalous values
validation_criteria <- list(
  BMI = list(type = "iqr", range = NULL),
  Age = list(type = "range", range = 1:13),
  Education = list(type = "range", range = 1:6),
  Income = list(type = "range", range = 1:13),
  MentHlth = list(type = "range", range = 1:30),
  PhysHlth = list(type = "range", range = 1:30),
  GenHlth = list(type = "range", range = 1:5)
)

all_columns <- colnames(raw_df)
validated_columns <- names(validation_criteria)
non_validated_columns <- setdiff(all_columns, validated_columns)

for (col in names(validation_criteria)) {
  criteria <- validation_criteria[[col]]
  
  if (criteria$type == "iqr") {
    # Calculate IQR bounds for BMI
    q1 <- quantile(raw_df[[col]], 0.25, na.rm = TRUE)
    q3 <- quantile(raw_df[[col]], 0.75, na.rm = TRUE)
    iqr <- q3 - q1
    lower_bound <- q1 - 1.5 * iqr
    upper_bound <- q3 + 1.5 * iqr
    
    agent <- agent %>%
      pointblank::col_vals_between(
        columns = {{ col }},
        left = lower_bound,
        right = upper_bound,
        na_pass = TRUE,
        actions = action_levels(warn_at = 0.1, stop_at = 0.05),
        brief = paste0("Check for outliers in ", col)
      )
  } else if (criteria$type == "range") {
    # Apply range check based on validation criteria
    range_values <- criteria$range
    agent <- agent %>%
      pointblank::col_vals_between(
        columns = {{ col }},
        left = min(range_values),
        right = max(range_values),
        na_pass = TRUE,
        actions = action_levels(warn_at = 0.1, stop_at = 0.05),
        brief = paste0("Check for outliers in ", col, " that are out of the range ", min(range_values), " to ", max(range_values))
      )
  } 
}

for (col in non_validated_columns) {
  agent <- agent %>%
    pointblank::col_vals_between(
      columns = {{ col }},
      left = 0,
      right = 1,
      na_pass = TRUE,
      actions = action_levels(warn_at = 0.1, stop_at = 0.05),
      brief = paste0("Check for outliers in ", col, " that are out of the binary range 0 to 1")
    )
}

# (8) Correct category levels (No string mismatches or single values)

## String mismatches
expected_levels <- list(
  Diabetes_binary = c(0, 1),
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
  Age = 1:13,
  Education = 1:6,
  Income = 1:8,
  MentHlth = 1:30,
  PhysHlth = 1:30,
  GenHlth = 1:5
)

for (col in names(expected_levels)) {
  agent <- agent %>%
    pointblank::col_vals_in_set(
      columns = {{ col }},
      set = expected_levels[[col]],
      actions = action_levels(warn_at = 0.01, stop_at = 0.05),
    )
}

## Singleton values (Cannot find any function in pointblank for this)
categorical_vars <- c("Diabetes_binary", "HighBP", "HighChol", "CholCheck", "Smoker", "Stroke", 
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