#' Counts and proportions of categorisation.
#' 
#' Given input dataframe with a categorical variable, return the number and
#' proportion of instances with each category value, in alphabetical
#' (for characters and logical) or numerical (for integers) order
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#' @param cat_var String, name of categorical variable within data_frame
#'
#' @return @return Data frame with 1 rows per category and 2 columns:
#'    - Count: Number of corresponding cat_var values.
#'    - Proportion: Proportion of corresponding cat_var values among all instances.
#' @export
#' @examples
#' category_target(ToothGrowth, supp),

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