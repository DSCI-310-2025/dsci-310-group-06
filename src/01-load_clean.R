"This script loads, cleans, and saves diabetes_train, diabetes_test

Usage: src/01-load_clean.R --python_path=<python_path> --extract_path=<extract_path> --file_path=<file_path> --r_na_count_type_path=<r_na_count_type_path> --r_col_to_factor_path=<r_col_to_factor_path> --r_category_target_path=<r_category_target_path> --output_path_raw=<output_path_raw> --output_path_target=<output_path_target> --output_path_bal=<output_path_bal> --output_path_df=<output_path_df> --output_path_train=<output_path_train> --output_path_test=<output_path_test>

Options:
--python_path=<python_path>                   Path to python executable
--extract_path=<extract_path>                 Path to python script that fetch CDC Diabetes Health Indicators dataset from the UCI Machine Learning Repository
--file_path=<file_path>                       Path to save the raw dataset CSV file
--r_na_count_type_path=<r_na_count_type_path> Path to R script for na_count_type
--r_col_to_factor_path=<r_col_to_factor_path> Path to R script for col_to_factor
--r_category_target_path=<r_category_target_path> Path to R script for category_target
--output_path_raw=<output_path_raw>           Path to save the raw dataset checking results
--output_path_target=<output_path_target>     Path to save the summary statistics of the target variable before balancing
--output_path_bal=<output_path_bal>           Path to save the summary statistics of the target variable after balancing
--output_path_df=<output_path_df>             Path to save the comparison data frame of target variable class distribution before and after balancing
--output_path_train=<output_path_train>       Path to save the training dataset
--output_path_test=<output_path_test>         Path to save the test dataset
" -> doc

library(tidyverse)
library(tidymodels)
library(ROSE)
library(docopt)
# Setting the seed for consistent results
set.seed(6)

opt <- docopt::docopt(doc)

# This runs the Python script to extract file from UCI
system(paste(opt$python_path, opt$extract_path))

# Reads the downloaded dataset into a variable named raw_diabetes_df
raw_diabetes_df <- readr::read_csv(opt$file_path, show_col_types = FALSE)

source(opt$r_na_count_type_path)
source(opt$r_col_to_factor_path)
source(opt$r_category_target_path)

# Checking for NA values, distinct counts of each variable, and the current data type # CONVERT TO FUNCTION na_count_type (33-37)
# checking_raw_matrix <- rbind(
#   NA_Count = sapply(raw_diabetes_df, function(x) sum(is.na(x))),
#   Distinct_Count = sapply(raw_diabetes_df, function(x) n_distinct(x)),
#   Current_Data_Type = sapply(raw_diabetes_df, typeof)
# )
checking_raw_matrix <- na_count_type(raw_diabetes_df)

# WRITE checking_raw_matrix
readr::write_rds(checking_raw_matrix, opt$output_path_raw)

# Converting categorical/binary variables into factors # CONVERT TO FUNCTION col_to_factor() (43-44)
# raw_diabetes_df <- raw_diabetes_df %>%
#   dplyr::mutate(dplyr::across(!BMI, ~ factor(.)))
raw_diabetes_df <- col_to_factor(raw_diabetes_df)

# Checking to see how unbalanced the dataset is with respect to the target variable # CONVERT TO FUNCTION category_target (47-50)
# target_result <- raw_diabetes_df %>%
#   dplyr::group_by(Diabetes_binary) %>%
#   dplyr::summarise(Count = dplyr::n(), Proportion = dplyr::n() / nrow(raw_diabetes_df)) %>%
#   dplyr::ungroup()
target_result <- category_target(raw_diabetes_df, Diabetes_binary)

# WRITE target_result
readr::write_csv(target_result, opt$output_path_target)

# Using ROSE to balance data by oversampling
balanced_raw_diabetes_df <- ROSE::ROSE(Diabetes_binary ~ ., data = raw_diabetes_df, seed = 123)$data
# balanced_target_result <- balanced_raw_diabetes_df %>%
#   dplyr::group_by(Diabetes_binary) %>%
#   dplyr::summarise(Count = dplyr::n(), Proportion = dplyr::n() / nrow(balanced_raw_diabetes_df)) %>%
#   dplyr::ungroup()
balanced_target_result <- category_target(balanced_raw_diabetes_df, Diabetes_binary)

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
diabetes_split <- rsample::initial_split(balanced_raw_diabetes_df, prop = 0.75, strata = Diabetes_binary)
diabetes_train <- rsample::training(diabetes_split)
diabetes_test <- rsample::testing(diabetes_split)

# WRITE diabetes_train, diabetes_test
readr::write_csv(diabetes_train, opt$output_path_train)
readr::write_csv(diabetes_test, opt$output_path_test)
