# Importing required packages for analysis. Suppress warnings and startup messages the first time libraries are loaded
library(tidyverse) # Data wrangling and visualization
library(tidymodels) # Machine learning tools
library(glmnet) # Fit generalized linear models by penalty

# READ diabetes_train, diabetes_test, lasso_tuned_wflow
diabetes_train <- readr::read_csv("/home/rstudio/work/data/processed/diabetes_train.csv")
diabetes_test <- readr::read_csv("/home/rstudio/work/data/processed/diabetes_test.csv")
lasso_tuned_wflow <- readr::read_rds("/home/rstudio/work/output/lasso_tuned_wflow.RDS")

# Applying to the test set
lasso_preds <- lasso_tuned_wflow %>% predict(diabetes_test)
lasso_probs <- lasso_tuned_wflow %>% predict(diabetes_test, type="prob")
lasso_modelOutputs <- cbind(diabetes_test, lasso_preds, lasso_probs)

classificationMetrics <- metric_set(sens, spec, ppv, npv, accuracy, recall, f_meas)
roc_auc_value <- roc_auc(lasso_modelOutputs, truth = Diabetes_binary, .pred_1, event_level = "second")

lasso_metrics <- rbind(classificationMetrics(lasso_modelOutputs, truth = Diabetes_binary, estimate = .pred_class, event_level = "second"),
                       roc_auc_value)

# WRITE lasso_metrics
write_csv(lasso_metrics, "/home/rstudio/work/data/processed/lasso_metrics.csv")

options(repr.plot.width = 8, repr.plot.height = 8)

# Creating the ROC curve
roc_plot <- autoplot(roc_curve(lasso_modelOutputs, Diabetes_binary, .pred_1, event_level = "second")) +
  ggtitle("Figure 2. ROC Curve for Lasso Model") +
  labs(subtitle = "Performance of the Lasso Model in Predicting Diabetes State.",
       x = "False Positive Rate (1 - Specificity)",
       y = "True Positive Rate (Sensitivity)") +
  annotate("text", x = 0.7, y = 0.2, label = paste("AUC =", round(roc_auc_value$.estimate, 3)), size = 5, color = "blue") +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

# WRITE roc_plot
ggsave("/home/rstudio/work/output/roc_plot.png", roc_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)

options(repr.plot.width = 8, repr.plot.height = 8)

# Creating the confusion matrix
cm <- conf_mat(lasso_modelOutputs, truth = Diabetes_binary, estimate = .pred_class, event_level = "second")
cm_df <- as.data.frame(cm$table)

cm_plot <- ggplot(cm_df, aes(x = Prediction, y = Truth, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "black", size = 5) +
  scale_fill_gradient(low = "white", high = "#66B2FF") +
  ggtitle("Figure 3. Confusion Matrix for Lasso Model") +
  labs(subtitle = "Performance of the Lasso Model in Predicting diabetic (1) or non-diabetic (0).", 
       x = "Predicted Class", 
       y = "True Class",
       fill = "Count") + 
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.background = element_blank(),
    panel.grid = element_blank()
  ) +
  guides(fill = "none")

# WRITE cm_plot
# WRITE cm_plot
ggsave("/home/rstudio/work/output/cm_plot.png", cm_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)