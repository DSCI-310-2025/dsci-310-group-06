"This script loads, cleans, and saves diabetes_train, diabetes_test

Usage: src/01-load_clean.R --python_path=<python_path> --extract_path=<extract_path> --file_path=<file_path> --output_path_raw=<output_path_raw> --output_path_target=<output_path_target> --output_path_bal=<output_path_bal> --output_path_df=<output_path_df> --output_path_train=<output_path_train> --output_path_test=<output_path_test> --output_path_bin=<output_path_bin>

Options:
--python_path=<python_path>                       Path to python executable
--extract_path=<extract_path>                     Path to python script that fetch CDC Diabetes Health Indicators dataset from the UCI Machine Learning Repository
--file_path=<file_path>                           Path to save the raw dataset CSV file
--output_path_raw=<output_path_raw>               Path to save the raw dataset checking results
--output_path_target=<output_path_target>         Path to save the summary statistics of the target variable before balancing
--output_path_bal=<output_path_bal>               Path to save the summary statistics of the target variable after balancing
--output_path_df=<output_path_df>                 Path to save the comparison data frame of target variable class distribution before and after balancing
--output_path_train=<output_path_train>           Path to save the training dataset
--output_path_test=<output_path_test>             Path to save the test dataset
--output_path_bin=<output_path_bin>               Path to save the summary statistics of the binned variable
" -> doc

library(tidyverse)
library(tidymodels)
library(ROSE)
library(docopt)
library(predictdiabetes)

# Setting the seed for consistent results
set.seed(6)

opt <- docopt::docopt(doc)

# This runs the Python script to extract file from UCI
system(paste(opt$python_path, opt$extract_path))

# Reads the downloaded dataset into a variable named raw_diabetes_df
raw_diabetes_df <- readr::read_csv(opt$file_path, show_col_types = FALSE)

# Checking for NA values, distinct counts of each variable, and the current data type
checking_raw_matrix <- predictdiabetes::na_count_type(raw_diabetes_df)

# Converting categorical/binary variables into factors
raw_diabetes_df <- raw_diabetes_df %>%
  dplyr::mutate(dplyr::across(!BMI, ~ factor(.)))

# Checking to see how unbalanced the dataset is with respect to the target variable
target_result <- predictdiabetes::category_target(raw_diabetes_df, Diabetes_binary)

# Using ROSE to balance data by oversampling
balanced_raw_diabetes_df <- ROSE::ROSE(Diabetes_binary ~ ., data = raw_diabetes_df, seed = 123)$data
balanced_target_result <- predictdiabetes::category_target(balanced_raw_diabetes_df, Diabetes_binary)

# Comparing class distribution before and after balancing
balanced_raw_comparision_df <- data.frame(
  Diabetes_binary = target_result$Diabetes_binary,
  Original_Count = target_result$Count,
  Original_Proportion = target_result$Proportion,
  Balanced_Count = balanced_target_result$Count,
  Balanced_Proportion = balanced_target_result$Proportion
)

# Binning numerical BMI into discrete categories
binned_diabetes_df <- balanced_raw_diabetes_df %>%
  dplyr::mutate(BinnedBMI = cut(BMI, breaks = c(-Inf, 18.5, 25, 30, 35, 40, Inf), labels = c(1, 2, 3, 4, 5, 6), right = FALSE)) %>%
  dplyr::select(-BMI)

# Checking to see counts of the binned BMI variable
binned_result <- predictdiabetes::category_target(binned_diabetes_df, BinnedBMI)

# Split data into 75% train, 25% test for machine learning
diabetes_split <- rsample::initial_split(binned_diabetes_df, prop = 0.75, strata = Diabetes_binary)
diabetes_train <- rsample::training(diabetes_split)
diabetes_test <- rsample::testing(diabetes_split)

readr::write_rds(checking_raw_matrix, opt$output_path_raw) # WRITE checking_raw_matrix
readr::write_csv(target_result, opt$output_path_target) # WRITE target_result
readr::write_csv(balanced_target_result, opt$output_path_bal) # WRITE balanced_target_result
readr::write_csv(balanced_raw_comparision_df, opt$output_path_df) # WRITE balanced_raw_comparison_df
readr::write_rds(diabetes_train, opt$output_path_train) # WRITE diabetes_train
readr::write_rds(diabetes_test, opt$output_path_test) # WRITE diabetes_test
readr::write_csv(binned_result, opt$output_path_bin) # WRITE binned_result
