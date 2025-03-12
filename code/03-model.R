# Importing required packages for analysis. Suppress warnings and startup messages the first time libraries are loaded
library(tidyverse) # Data wrangling and visualization
library(tidymodels) # Machine learning tools
library(glmnet) # Fit generalized linear models by penalty

# READ diabetes_train, diabetes_test
diabetes_train <- readr::read_csv("/home/rstudio/work/data/processed/diabetes_train.csv")
diabetes_test <- readr::read_csv("/home/rstudio/work/data/processed/diabetes_test.csv")

# Selecting only the features we determined from 3.2. EDA - Feature Selection and Visualization
diabetes_train_filtered <- diabetes_train %>%
  select(Diabetes_binary, GenHlth, HighBP, Age, HighChol, DiffWalk)

# Pipeline for logistic regression 
lr_mod <- logistic_reg(penalty = tune(), mixture = 1) %>% 
    set_engine("glmnet") %>%
    set_mode("classification")

folds <- vfold_cv(diabetes_train_filtered, v=5)

lr_recipe <- recipe(Diabetes_binary ~ ., data = diabetes_train_filtered) %>%
  step_dummy(all_nominal_predictors(), -all_ordered()) %>% 
  step_normalize(all_predictors())

lr_workflow <- workflow() %>%
  add_recipe(lr_recipe)

# Tuning with cross-validation set for penalty
lambda_grid <- grid_max_entropy(penalty(), size = 10)

lasso_grid <- tune_grid(lr_workflow %>% add_model(lr_mod),
                        resamples = folds,
                        grid = lambda_grid,
                        metrics = metric_set(recall))

# Choosing the metric with the highest recall
highest_auc <- lasso_grid %>% select_best(metric = "recall")

lasso_tuned_wflow <- finalize_workflow(lr_workflow %>% 
                                         add_model(lr_mod),highest_auc) %>%
  fit(data = diabetes_train_filtered)

# WRITE lasso_tuned_wflow
write_rds(lasso_tuned_wflow, "/home/rstudio/work/output/lasso_tuned_wflow.RDS")