"This script constructs the lasso_tuned_wflow classification analysis model 

Usage: 03-model.R --file_path=<file_path> --output_path=<output_path>
Options:
--file_path=<file_path>     Path to obtain the raw dataset CSV file
--output_path=<output_path> Path to save the lasso_tuned_wflow
" -> doc

library(tidyverse)
library(tidymodels)
library(glmnet)
# Setting the seed for consistent results
set.seed(6)

opt <- docopt::docopt(doc)

# READ diabetes_train
diabetes_train <- readr::read_csv(opt$file_path)

# Selecting only the features we determined from 3.2. EDA - Feature Selection and Visualization
diabetes_train_filtered <- diabetes_train %>%
  dplyr::select(Diabetes_binary, GenHlth, HighBP, Age, HighChol, DiffWalk) %>%
  dplyr::mutate(Diabetes_binary = as.factor(Diabetes_binary))

# Pipeline for logistic regression # CONVERT TO FUNCTION (25-45)
lr_mod <- parsnip::logistic_reg(penalty = tune(), mixture = 1) %>%
  parsnip::set_engine("glmnet") %>%
  parsnip::set_mode("classification")

folds <- rsample::vfold_cv(diabetes_train_filtered, v = 5)

lr_recipe <- recipes::recipe(Diabetes_binary ~ ., data = diabetes_train_filtered) %>%
  recipes::step_dummy(recipes::all_nominal_predictors(), -recipes::all_ordered()) %>% 
  recipes::step_normalize(recipes::all_predictors())

lr_workflow <- workflows::workflow() %>%
  workflows::add_recipe(lr_recipe)

# Tuning with cross-validation set for penalty
lambda_grid <- dials::grid_space_filling(penalty(), size = 10)

lasso_grid <- tune::tune_grid(lr_workflow %>% workflows::add_model(lr_mod),
                              resamples = folds,
                              grid = lambda_grid,
                              metrics = metric_set(recall))

# Choosing the metric with the highest recall
highest_auc <- lasso_grid %>% tune::select_best(metric = "recall")

lasso_dialsd_wflow <- tune::finalize_workflow(lr_workflow %>% add_model(lr_mod), highest_auc) %>%
  parsnip::fit(data = diabetes_train_filtered)

# WRITE lasso_dialsd_wflow
readr::write_rds(lasso_dialsd_wflow, opt$output_path)