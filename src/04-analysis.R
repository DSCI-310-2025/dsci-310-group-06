"This script applies the lasso_tuned_wflow classification analysis model on the diabetes_test dataset

Usage: 04-analysis.R --file_path_test=<file_path_test> --file_path_wflow=<file_path_wflow> --r_path_roc_plot=<r_path_roc_plot> --r_path_cm_plot=<r_path_cm_plot> --output_path_lasso=<output_path_lasso> --output_path_roc=<output_path_roc> --output_path_cm=<output_path_cm> --output_path_cm_df=<output_path_cm_df>
Options: 
--file_path_test=<file_path_test>           Path to obtain the raw dataset CSV file
--file_path_wflow=<file_path_wflow>         Path to obtain the lasso_tuned_wflow
--r_path_roc_plot=<r_path_roc_plot>         Path to R script for roc_plot
--r_path_cm_plot=<r_path_cm_plot>           Path to R script for cm_plot
--output_path_lasso=<output_path_lasso>     Path to save the lasso_metrics
--output_path_roc=<output_path_roc>         Path to save the ROC curve
--output_path_cm=<output_path_cm>           Path to save the confusion matrix
--output_path_cm_df=<output_path_cm_df>   Path to save values from the confusion matrix

" -> doc

opt <- docopt::docopt(doc)

library(tidyverse)
library(tidymodels)
library(glmnet)
library(docopt)
source(opt$r_path_roc_plot)
source(opt$r_path_cm_plot)
set.seed(6)



# READ diabetes_test, lasso_tuned_wflow
diabetes_test <- readr::read_rds(opt$file_path_test)
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
options(repr.plot.width = 8, repr.plot.height = 8)

cm <- yardstick::conf_mat(lasso_modelOutputs, truth = Diabetes_binary, estimate = .pred_class, event_level = "second")
cm_df <- as.data.frame(cm$table)

cm_plot <- ggplot2::ggplot(cm_df, ggplot2::aes(x = Prediction, y = Truth, fill = Freq)) +
  ggplot2::geom_tile() +
  ggplot2::geom_text(ggplot2::aes(label = Freq), color = "black", size = 5) +
  ggplot2::scale_fill_gradient(low = "white", high = "#66B2FF") +
  ggplot2::labs(
    x = "Predicted Class",
    y = "True Class",
    fill = "Count"
  ) +
  ggplot2::theme(
    plot.title = ggplot2::element_text(size = 16, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = 12),
    axis.title = ggplot2::element_text(size = 12),
    axis.text = ggplot2::element_text(size = 10),
    plot.background = ggplot2::element_blank(),
    panel.grid = ggplot2::element_blank()
  ) +
  ggplot2::guides(fill = "none")

# confusion_matrix_plot <- cm_plot(cm, "lasso_modelOutputs", "Diabetes_binary", ".pred_class", "Confusion Matrix", "#66B2FF")

# WRITE cm_plot
ggplot2::ggsave(opt$output_path_cm, cm_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)
# ggplot2::ggsave(opt$output_path_cm, confusion_matrix_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)

# WRITE cm_df
readr::write_csv(cm_df, opt$output_path_cm_df)