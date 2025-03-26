library(dplyr)
#' Counts and proportions of categorisation.
#' 
#' Given input dataframe with a categorical variable, return the number and
#' proportion of instances with each category value.
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#' @param cat_var Categorical variable within data_frame
#'
#' @return @return Data frame with 1 rows per category and 2 columns:
#'    - Count: Number of corresponding cat_var values.
#'    - Proportion: Proportion of corresponding cat_var values among all instances.
#' @export
#' @examples
#' category_target(ToothGrowth, supp),
category_target <- function(data_frame, cat_var) {
  return(
    target_result <- data_frame %>%
      dplyr::group_by(cat_var) %>%
      dplyr::summarise(Count = dplyr::n(), Proportion = dplyr::n() / nrow(data_frame)) %>%
      dplyr::ungroup()
  )
}