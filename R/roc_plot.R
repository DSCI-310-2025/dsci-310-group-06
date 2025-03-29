library(ggplot2)
#' Create and save an ROC curve plot
#'
#' This function creates an ROC curve plot and saves it to the specified file path.
#'
#' @param model_outputs A data frame or tibble containing the model outputs (e.g., from a tuned model).
#' @param true_class A character string specifying the column with actual class labels (e.g., "Diabetes_binary").
#' @param predicted_probs A character string specifying the column with predicted probabilities (e.g., ".pred_1").
#' @param roc_auc_value A numeric value representing the AUC from model evaluation (e.g., `lasso_metrics$roc_auc$.estimate`).
#' @param output_path A character string specifying the file path to save the ROC plot (e.g., "path/to/roc_curve.png").
#'
#' @return A ggplot object of the ROC curve.
#'
#' @export
#' @examples
#' # Example usage:
#' # Assuming you have model outputs, true labels, predicted probabilities, and AUC value
#' roc_plot(lasso_model_outputs, "Diabetes_binary", ".pred_1", roc_auc_value, "roc_curve_plot.png")

roc_plot <- function(model_outputs, true_class, predicted_probs, roc_auc_value, output_path) {
  
  # Set plot dimensions
  options(repr.plot.width = 8, repr.plot.height = 8)
  
  # Create the ROC plot
  roc_plot <- tune::autoplot(
    yardstick::roc_curve(model_outputs, true_class, predicted_probs, event_level = "second")
  ) +
    ggplot2::labs(
      x = "False Positive Rate (1 - Specificity)",
      y = "True Positive Rate (Sensitivity)"
    ) +
    ggplot2::annotate(
      "text", 
      x = 0.7, 
      y = 0.2, 
      label = paste("AUC =", round(roc_auc_value, 3)),
      size = 5, 
      color = "blue"
    ) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold"),
      plot.subtitle = ggplot2::element_text(size = 12),
      axis.title = ggplot2::element_text(size = 12),
      axis.text = ggplot2::element_text(size = 10)
    )
  
  # Save the ROC plot to the specified file path
  ggplot2::ggsave(output_path, roc_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)
  
  # Return the ROC plot object
  return(roc_plot)
}
