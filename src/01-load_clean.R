# Importing required packages for analysis. Suppress warnings and startup messages the first time libraries are loaded
# library(tidyverse) # Data wrangling and visualization
# library(tidymodels) # Machine learning tools
library(readr)    # read_csv, write_csv
library(dplyr)    # %>%, mutate, across, group_by, summarise, ungroup
library(tibble)   # as_tibble
library(rsample)  # initial_split, training, testing
library(ROSE)     # ROSE
library(docopt)   # docopt

# 01-load_clean.R --python_path="/venv/bin/python /home/rstudio/work/src/dataset_download.py" --file_path="/home/rstudio/work/data/raw/cdc_diabetes_health_indicators.csv" --output_path_raw="/home/rstudio/work/output/checking_raw_df.csv" --output_path_target="/home/rstudio/work/output/balanced_target_result.csv" --output_path_bal="/home/rstudio/work/output/balanced_target_result.csv" --output_path_df="/home/rstudio/work/data/processed/balanced_raw_comparision_df" --output_path_train="/home/rstudio/work/data/processed/diabetes_train.csv" --output_path_test="/home/rstudio/work/data/processed/diabetes_test.csv"

"This script loads, cleans, saves diabetes_train, diabetes_test

Usage: 01-load_clean.R --python_path=<python_path> --file_path=<file_path> --output_path_raw=<output_path_raw> --output_path_target=<output_path_target> --output_path_bal=<output_path_bal> --output_path_df=<output_path_df> --output_path_train=<output_path_train> --output_path_test=<output_path_test>
" -> doc

opt <- docopt::docopt(doc)

# This runs the Python script to extract file from UCI
system(opt$python_path)

# Reads the downloaded dataset into a variable named raw_diabetes_df
raw_diabetes_df <- readr::read_csv(
  opt$file_path,
  show_col_types = FALSE
)

checking_raw_matrix <- rbind(
  NA_Count = sapply(raw_diabetes_df, function(x) sum(is.na(x))),
  Distinct_Count = sapply(raw_diabetes_df, function(x) dplyr::n_distinct(x)),
  Current_Data_Type = sapply(raw_diabetes_df, typeof)
)
checking_raw_df <- as.data.frame(t(checking_raw_matrix))

# WRITE checking_raw_df
readr::write_csv(checking_raw_df, opt$output_path_raw)

# Converting categorical/binary variables into factors
raw_diabetes_df <- raw_diabetes_df %>%
  dplyr::mutate(dplyr::across(!BMI, ~ factor(.)))

# Checking to see how unbalanced the dataset is with respect to the target variable
target_result <- raw_diabetes_df %>%
  dplyr::group_by(Diabetes_binary) %>%
  dplyr::summarise(Count = dplyr::n(), Proportion = dplyr::n() / nrow(raw_diabetes_df)) %>%
  dplyr::ungroup()

# WRITE target_result
readr::write_csv(target_result, opt$output_path_target)

# Using ROSE to balance data by oversampling
# Setting the seed for consistent results
set.seed(6)
balanced_raw_diabetes_df <- ROSE::ROSE(Diabetes_binary ~ ., data = raw_diabetes_df, seed = 123)$data
balanced_target_result <- balanced_raw_diabetes_df %>%
  dplyr::group_by(Diabetes_binary) %>%
  dplyr::summarise(Count = dplyr::n(), Proportion = dplyr::n() / nrow(balanced_raw_diabetes_df)) %>%
  dplyr::ungroup()

# WRITE balanced_target_result
readr::write_csv(balanced_target_result, opt$output_path_bal)

# Comparing class distribution before and after balancing
balanced_raw_comparision_df <- data.frame(
  Diabetes_binary = target_result$Diabetes_binary,
  Original_Count = target_result$Count,
  Original_Proportion = target_result$Proportion,
  Balanced_Count = balanced_target_result$Count,
  Balanced_Proportion = balanced_target_result$Proportion
)

# WRITE balanced_raw_comparision_df
readr::write_csv(balanced_raw_comparision_df, opt$output_path_df)

# Split data into 75% train, 25% test for machine learning
# Setting the seed for consistent results
set.seed(6)
diabetes_split <- rsample::initial_split(balanced_raw_diabetes_df, prop = 0.75, strata = Diabetes_binary)
diabetes_train <- rsample::training(diabetes_split)
diabetes_test <- rsample::testing(diabetes_split)

# WRITE diabetes_train, diabetes_test
readr::write_csv(diabetes_train, opt$output_path_train)
readr::write_csv(diabetes_test, opt$output_path_test)