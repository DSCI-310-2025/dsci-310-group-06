"This script applies the lasso_tuned_wflow classification analysis model on the diabetes_test dataset

Usage: 04-analysis.R --file_path_test=<file_path_test> --file_path_wflow=<file_path_wflow> --output_path_lasso=<output_path_lasso> --output_path_roc=<output_path_roc> --output_path_cm=<output_path_cm> --output_path_cm_df=<output_path_cm_df>
Options: 
--file_path_test=<file_path_test>       Path to obtain the raw dataset CSV file
--file_path_wflow=<file_path_wflow>     Path to obtain the lasso_tuned_wflow
--output_path_lasso=<output_path_lasso> Path to save the lasso_metrics
--output_path_roc=<output_path_roc>     Path to save the ROC curve
--output_path_cm=<output_path_cm>       Path to save the confusion matrix
--output_path_cm_df=work/output/cm_df.csv
" -> doc

library(tidyverse)  
library(tidymodels) 
library(glmnet)    
library(docopt)
set.seed(6)

opt <- docopt::docopt(doc)

# READ diabetes_test, lasso_tuned_wflow
diabetes_test <- readr::read_csv(opt$file_path_test)
lasso_tuned_wflow <- readr::read_rds(opt$file_path_wflow)

# Applying to the test set
lasso_preds <- lasso_tuned_wflow %>% stats::predict(diabetes_test)
lasso_probs <- lasso_tuned_wflow %>% stats::predict(diabetes_test, type = "prob")
lasso_modelOutputs <- cbind(diabetes_test, lasso_preds, lasso_probs)

# Convert Diabetes_binary to a factor
lasso_modelOutputs$Diabetes_binary <- as.factor(lasso_modelOutputs$Diabetes_binary)

classificationMetrics <- metrics <- yardstick::metric_set(
  sens, 
  ppv, 
  npv, 
  accuracy, 
  recall, 
  f_meas
)

roc_auc_value <- yardstick::roc_auc(lasso_modelOutputs, truth = Diabetes_binary, .pred_1, event_level = "second")

lasso_metrics <- rbind(
  classificationMetrics(lasso_modelOutputs, truth = Diabetes_binary, estimate = .pred_class, event_level = "second"),
  roc_auc_value
)

# WRITE lasso_metrics
readr::write_csv(lasso_metrics, opt$output_path_lasso)

options(repr.plot.width = 8, repr.plot.height = 8)

# Creating the ROC curve
roc_plot <- tune::autoplot(yardstick::roc_curve(lasso_modelOutputs, Diabetes_binary, .pred_1, event_level = "second")) +
  ggplot2::labs(
    x = "False Positive Rate (1 - Specificity)",
    y = "True Positive Rate (Sensitivity)"
  ) +
  ggplot2::annotate("text", x = 0.7, y = 0.2, label = paste("AUC =", round(roc_auc_value$.estimate, 3)), size = 5, color = "blue") +
  ggplot2::theme(
    plot.title = ggplot2::element_text(size = 16, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = 12),
    axis.title = ggplot2::element_text(size = 12),
    axis.text = ggplot2::element_text(size = 10)
  )

# WRITE roc_plot
ggplot2::ggsave(opt$output_path_roc, roc_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)

options(repr.plot.width = 8, repr.plot.height = 8)

# Creating the confusion matrix
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

# WRITE cm_plot
ggplot2::ggsave(opt$output_path_cm, cm_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)

# WRITE cm_df
readr::write_csv(cm_df, opt$output_path_cm_df)