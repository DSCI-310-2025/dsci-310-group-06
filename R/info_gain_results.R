#' Calculate and Sort Information Gain for Feature Selection
#' 
#' This function calculates the information gain of each predictor with respect 
#' to a target variable and returns a data frame sorted by importance.
#'
#' @param data A data frame containing the predictors and the target variable.
#' @param formula A formula specifying the target and predictors (e.g., `Diabetes_binary ~ .`).
#'
#' @return A tibble with two columns: `Variable` and `Information_Gain`, sorted in descending order.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' info_gain_table <- info_gain(mtcars, am ~ .)
#' }
#' 
info_gain <- function(data, formula) {
  
  ig <- FSelectorRcpp::information_gain(formula, data = data)
  
  info_sorted <- ig %>%
    dplyr::arrange(dplyr::desc(importance)) %>%
    dplyr::rename(Variable = attributes, Information_Gain = importance)
  
  return(info_sorted)
}