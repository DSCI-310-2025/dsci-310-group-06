"This script applies the lasso_tuned_wflow classification analysis model on the diabetes_test dataset

Usage: 04-analysis.R --file_path_test=<file_path_test> --file_path_wflow=<file_path_wflow> --output_path_lasso=<output_path_lasso> --output_path_roc=<output_path_roc> --output_path_cm=<output_path_cm> --output_path_cm_df=<output_path_cm_df>
Options: 
--file_path_test=<file_path_test>           Path to obtain the raw dataset CSV file
--file_path_wflow=<file_path_wflow>         Path to obtain the lasso_tuned_wflow
--output_path_lasso=<output_path_lasso>     Path to save the lasso_metrics
--output_path_roc=<output_path_roc>         Path to save the ROC curve
--output_path_cm=<output_path_cm>           Path to save the confusion matrix
--output_path_cm_df=<output_path_cm_df>   Path to save values from the confusion matrix

" -> doc

library(tidyverse)
library(tidymodels)
library(glmnet)
library(docopt)
source("work/R/cm_plot.R")
source("work/R/roc_plot.R")
options(repr.plot.width = 8, repr.plot.height = 8)

set.seed(6)

opt <- docopt::docopt(doc)

# READ diabetes_test, lasso_tuned_wflow
diabetes_test <- readr::read_csv(opt$file_path_test)
lasso_tuned_wflow <- readr::read_rds(opt$file_path_wflow)

# Applying to the test set
lasso_modelOutputs <- diabetes_test %>%
  cbind(lasso_tuned_wflow %>% predict(diabetes_test), 
        lasso_tuned_wflow %>% predict(diabetes_test, type = "prob")) %>%
  mutate(Diabetes_binary = as.factor(Diabetes_binary))

# classification metrics
lasso_metrics <- bind_rows(
  metric_set(sens, ppv, npv, accuracy, recall, f_meas)(
    lasso_modelOutputs,
    truth = Diabetes_binary,
    estimate = .pred_class,
    event_level = "second"
  ),
  roc_auc(
    lasso_modelOutputs,
    truth = Diabetes_binary,
    .pred_1,
    event_level = "second"
  ) %>%
    as_tibble() %>%
    mutate(.metric = "roc_auc") 
) %>%
  select(.metric, .estimator, .estimate)


# WRITE lasso_metrics
readr::write_csv(lasso_metrics, opt$output_path_lasso)


# Creating the ROC curve # CONVERT TO FUNCTION roc_plot
roc_plot(
  model_outputs=lasso_modelOutputs, 
  true_class="Diabetes_binary", 
  predicted_probs=".pred_1", 
  roc_auc_value=lasso_metrics$.estimate[lasso_metrics$.metric == "roc_auc"], 
  output_path=opt$output_path_roc
)


# Creating the confusion matrix # CONVERT TO FUNCTION cm_plot
cm_df <- yardstick::conf_mat(lasso_modelOutputs, truth = Diabetes_binary, estimate = .pred_class, event_level = "second")$table |> 
  as.data.frame()

# write as csv 
readr::write_csv(cm_df,opt$output_path_cm_df)

# create confusion matrix and save as image
confusion_matrix_plot <- cm_plot(cm_df, opt$output_path_cm)
                                 