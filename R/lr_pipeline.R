#' Logistic Regression Pipeline
#' 
#' Trains and fits a logistic regression model and cross-validates for optimal 
#' hyperparameter values
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#' @param target_col A string specifying the variable of interest.
#' @param vfolds A number specifying the amount of folds used in k-fold cross-validation (Default = 5).
#' @param grid_size A number specifying penalty values to test during model tuning (Default = 10).
#' @param tuning_metric A string specifying the metric used to select for the most optimal model (e.g. "recall").
#' @param output_path String path location to save the model as an RDS object.
#' 
#' @return An RDS object
#'
#' @export
#' 
#' @examples
#' \dontrun{
#'   lr_pipeline(mtcars, "am", vfolds = 5, grid_size = 10, tuning_metric = "recall", output_path = "lasso_tuned_wflow.RDS")
#' }
#' 
lr_pipeline <- function(data, target_col, vfolds = 5, grid_size = 10, tuning_metric, output_path) {
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
  lambda_grid <- dials::grid_space_filling(dials::penalty(), size = grid_size)

  # Perform hyperparameter tuning
  lasso_grid <- tune::tune_grid(
    lr_workflow %>% workflows::add_model(lr_mod),
    resamples = folds,
    grid = lambda_grid,
    metrics = yardstick::metric_set(yardstick::recall)
  )

  # Select the best model based on specified tuning metric
  best_params <- lasso_grid %>% tune::select_best(metric = tuning_metric)

  final_model <- tune::finalize_workflow(lr_workflow %>% workflows::add_model(lr_mod), best_params) %>%
    parsnip::fit(data = data)

  return(final_model)
}
