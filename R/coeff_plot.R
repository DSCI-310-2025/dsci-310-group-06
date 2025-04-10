#' Plot LASSO Model Coefficients
#'
#' This function extracts the LASSO model coefficients from a fitted model,
#' arranges them by importance, and creates a bar plot to visualize the coefficients.
#'
#' @param model A trained LASSO model object.
#' 
#' @return A `ggplot` object with the bar plot of LASSO model coefficients.
#
#' @export
#' 
#' @examples
#' 
coeff_plot <- function(model) {
  
  # Extract coefficients using workflows and broom
  lasso_coefs <- model %>%
    workflows::extract_fit_parsnip() %>%
    broom::tidy()
  
  lasso_coefs_summarized <- lasso_coefs %>%
    arrange(desc(estimate))

  cf_plot <- ggplot(lasso_coefs_summarized, aes(x = reorder(term, estimate), y = estimate)) +
          geom_bar(stat = "identity", fill = "#1f77b4") +
          coord_flip() +
          labs(x = "Feature", y = "Coefficient") +
          theme_minimal()
  
  return(cf_plot)
}
