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

# (1) No empty observations
agent <- agent %>%
  pointblank::rows_complete()

# (2) Missingness threshold - stop if more than 10% missing
agent <- agent %>%
  pointblank::col_vals_not_null(
    columns = everything(),
    actions = action_levels(stop_at = 0.1)
  )

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