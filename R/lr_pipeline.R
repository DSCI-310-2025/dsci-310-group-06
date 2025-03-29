library(tidymodels)
#' Trains a logistic regression model and cross-validates for optimal hyperparameter values
#'
#' @param data A data frame containing the variables of interest.
#' @param target_col Column which contains the target variable.
#' @param vfolds The number of folds used in k-fold cross-validation.
#' @param grid_size Number of penalty values to test during model tuning.
#' @param tuning_metric Metric used to select for the most optimal model (recall, etc.).
#' @param output_path The specific path to save the model object.
#' 
#' @return An RDS object
#'
#' @export
#' @examples
#' # Example usage:
#' lr_pipeline(diabetes_train_filtered, "Diabetes_binary", 5, 10, "recall", "lasso_dialsd_wflow.RDS")

lr_pipeline <- function(data, target_col, vfolds, grid_size, tuning_metric, output_path) {
  lr_mod <- parsnip::logistic_reg(penalty = tune(), mixture = 1) %>%
    parsnip::set_engine("glmnet") %>%
    parsnip::set_mode("classification")
  
  folds <- rsample::vfold_cv(data, v = vfolds)
  
  lr_recipe <- recipes::recipe(reformulate(".", target_col), data = data) %>%
    recipes::step_dummy(recipes::all_nominal_predictors(), -recipes::all_ordered()) %>%
    recipes::step_normalize(recipes::all_predictors())
  
  lr_workflow <- workflows::workflow() %>%
    workflows::add_recipe(lr_recipe)
  
  # Define a tuning grid for the penalty parameter
  lambda_grid <- dials::grid_space_filling(penalty(), size = grid_size)
  
  # Perform hyperparameter tuning
  lasso_grid <- tune::tune_grid(
    lr_workflow %>% workflows::add_model(lr_mod),
    resamples = folds,
    grid = lambda_grid,
    metrics = metric_set(recall)
  )
  
  # Select the best model based on specified tuning metric
  best_params <- lasso_grid %>% tune::select_best(metric = tuning_metric)
  
  # Finalize and fit the workflow
  final_model <- tune::finalize_workflow(lr_workflow %>% add_model(lr_mod), best_params) %>%
    parsnip::fit(data = data)
  
  # Save the fitted model
  readr::write_rds(final_model, output_path)
  
  return(final_model)
}

