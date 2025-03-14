"This script constructs the lasso_tuned_wflow classification analysis model 

Usage: 03-model.R --file_path=<file_path> --output_path=<output_path>
Options:
--file_path=<file_path>     Path to obtain the raw dataset CSV file
--output_path=<output_path> Path to save the lasso_tuned_wflow
" -> doc

library(readr)         # read_csv, write_rds
library(dplyr)         # %>%, select
library(parsnip)       # logistic_reg, set_engine, set_mode
library(rsample)       # vfold_cv
library(recipes)       # recipe, step_dummy, step_normalize
library(workflows)     # workflow, add_recipe, add_model
library(tune)          # tune_grid, grid_max_entropy, metric_set, select_best
library(workflowsets)  # finalize_workflow
library(glmnet)        # Fit generalized linear models by penalty
library(docopt)     # docopt

opt <- docopt::docopt(doc)

# READ diabetes_train
diabetes_train <- readr::read_csv(opt$file_path)

# Selecting only the features we determined from 3.2. EDA - Feature Selection and Visualization
diabetes_train_filtered <- diabetes_train %>%
  dplyr::select(Diabetes_binary, GenHlth, HighBP, Age, HighChol, DiffWalk)

# Pipeline for logistic regression 
lr_mod <- parsnip::logistic_reg(penalty = tune::tune(), mixture = 1) %>% 
    parsnip::set_engine("glmnet") %>%
    parsnip::set_mode("classification")

folds <- rsample::vfold_cv(diabetes_train_filtered, v = 5)

lr_recipe <- recipes::recipe(Diabetes_binary ~ ., data = diabetes_train_filtered) %>%
  recipes::step_dummy(recipes::all_nominal_predictors(), -recipes::all_ordered()) %>% 
  recipes::step_normalize(recipes::all_predictors())

lr_workflow <- workflows::workflow() %>%
  workflows::add_recipe(lr_recipe)

# Tuning with cross-validation set for penalty
lambda_grid <- tune::grid_max_entropy(parsnip::penalty(), size = 10)

lasso_grid <- tune::tune_grid(lr_workflow %>% workflows::add_model(lr_mod),
                              resamples = folds,
                              grid = lambda_grid,
                              metrics = tune::metric_set(recall))

# Choosing the metric with the highest recall
highest_auc <- lasso_grid %>% tune::select_best(metric = "recall")

lasso_tuned_wflow <- workflowsets::finalize_workflow(lr_workflow %>% 
                                                       workflows::add_model(lr_mod), highest_auc) %>%
  parsnip::fit(data = diabetes_train_filtered)

# WRITE lasso_tuned_wflow
readr::write_rds(lasso_tuned_wflow, opt$output_path)