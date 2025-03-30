"This script constructs the lasso_tuned_wflow classification analysis model 

Usage: 03-model.R --file_path=<file_path> --output_path=<output_path>
Options:
--file_path=<file_path>     Path to obtain the raw dataset CSV file
--output_path=<output_path> Path to save the lasso_tuned_wflow
" -> doc

library(tidyverse)
library(tidymodels)
library(glmnet)
source("~/work/R/lr_pipeline.R")
# Setting the seed for consistent results
set.seed(6)

opt <- docopt::docopt(doc)

# READ diabetes_train
diabetes_train <- readr::read_csv(opt$file_path)

# Selecting only the features we determined from 3.2. EDA - Feature Selection and Visualization
diabetes_train_filtered <- diabetes_train %>%
  dplyr::select(Diabetes_binary, GenHlth, HighBP, Age, HighChol, DiffWalk) %>%
  dplyr::mutate(Diabetes_binary = as.factor(Diabetes_binary))

# Pipeline for logistic regression # CONVERT TO FUNCTION lr_pipeline (25-45)
lasso_tuned_wflow <- lr_pipeline(diabetes_train_filtered, "Diabetes_binary", 5, 10, "recall", "lasso_tuned_wflow.RDS")

# WRITE lasso_tuned_wflow
readr::write_rds(lasso_tuned_wflow, opt$output_path)