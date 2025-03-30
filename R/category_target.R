#' Counts and Proportions of Categorical Variables
#' 
#' Given an input dataframe with a categorical variable, return the number and
#' proportion of instances with each category value, in alphabetical
#' (for characters and logical) or numerical (for integers) order
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#' @param cat_var A categorical variable (object) within data_frame.
#'
#' @return A data frame with 1 rows per category and 2 columns:
#'    - Count: Number of occurrances of each category in cat_var.
#'    - Proportion: Proportion of each category relative to the total number of rows in the data frame.
#'    
#' @export
#' 
#' @examples
#' \dontrun{
#'   category_target(ToothGrowth, ToothGrowth$supp)
#' }
#' 
category_target <- function(data_frame, cat_var) {
  
  if (is.null(data_frame) || nrow(data_frame) == 0) {
    stop("Input data cannot be empty")
  }
  
  return(
    target_result <- data_frame %>%
      dplyr::group_by({{cat_var}}) %>%
      dplyr::summarise(Count = dplyr::n(), Proportion = dplyr::n() / nrow(data_frame)) %>%
      dplyr::ungroup()
  )
}