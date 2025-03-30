#' Create and save an ROC curve plot
#'
#' This function creates an ROC curve plot and saves it to the specified file path.
#'
#' @param model_outputs A data frame or tibble containing the model outputs
#' @param true_class A character string specifying the column with actual class labels
#' @param predicted_probs A character string specifying the column with predicted probabilities
#' @param roc_auc_value A numeric value representing the AUC from model evaluation
#' @param output_path A character string specifying the file path to save the ROC plot
#'
#' @return A ggplot2 object of the ROC curve.
#'
#' @export
#' @examples
#' # Example usage:
#' # Assuming you have model outputs, true labels, predicted probabilities, and AUC value
#' roc_plot(lasso_model_outputs, "Diabetes_binary", ".pred_1", lasso_metrics$.estimate[lasso_metrics$.metric == "roc_auc"], "roc_curve_plot.png")

roc_plot <- function(model_outputs, true_class, predicted_probs, roc_auc_value, output_path) {
  
  # Check for missing or empty inputs
  if (nrow(model_outputs) == 0 || is.null(model_outputs) || ncol(model_outputs) == 0) {
    stop("Error: Model outputs or columns cannot be empty.")
  }
  
  # Check if the columns exist in model_outputs
  if (!true_class %in% colnames(model_outputs)) {
    stop(paste("Error: Column '", true_class, "' not found in model outputs.", sep = ""))
  }
  
  if (!predicted_probs %in% colnames(model_outputs)) {
    stop(paste("Error: Column '", predicted_probs, "' not found in model outputs.", sep = ""))
  }
  
  # Validate AUC value
  if (is.na(roc_auc_value)) {
    stop("Error: AUC value cannot be missing.")
  }
  if (roc_auc_value < 0 || roc_auc_value > 1) {
    stop("Error: AUC value must be between 0 and 1.")
  }
  
  # Validate output path
  if (output_path == "") {
    stop("Error: Output file path cannot be empty.")
  }
  
  # solve interactive issue
  if(!interactive()) pdf(NULL)
  
  # Create the ROC plot
  roc_curve_data <- yardstick::roc_curve(
    model_outputs, 
    !!rlang::sym(true_class), 
    !!rlang::sym(predicted_probs), 
    event_level = "second"
  )
  
  output_plot <- ggplot2::ggplot(roc_curve_data, 
                                 ggplot2::aes(x = 1 - specificity, y = sensitivity)) +
    ggplot2::geom_path() +
    ggplot2::geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
    ggplot2::geom_text(
      x = 0.7, 
      y = 0.2, 
      label = paste("AUC =", base::round(roc_auc_value, 3)),
      size = 5, 
      color = "blue"
    ) +
    ggplot2::labs(
      x = "False Positive Rate (1 - Specificity)",
      y = "True Positive Rate (Sensitivity)",
      title = "ROC Curve"
    ) +
    ggplot2::theme_minimal()
  
  # Save the ROC plot to the specified file path
  ggplot2::ggsave(output_path, output_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)
  
  # Return the ROC plot object
  return(output_plot)
}