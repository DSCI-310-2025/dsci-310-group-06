#' Summarise Data Frame Columns
#' 
#' Given an input data frame, this function checks for the number of missing values
#' (NA), the number of distinct values, and the data type of each variable. `NULL`
#' values will be treated as a column of `NA`
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#'
#' @return Data frame with 1 row per variable and 3 columns:
#'    - NA_Count: Number of "NA" values within each variable.
#'    - Distinct_Count: Number of distinct values for each variable.
#'    - Current_Data_Type: Current data type for each variable.
#'    
#' @export
#' 
#' @examples
#' \dontrun{
#'   # Summarize columns in the mtcars dataset
#'   na_count_type(mtcars)
#' }
#' 
na_count_type <- function(data_frame) {
  if (!is.data.frame(data_frame)) {
    stop("The input must be a data frame")
  }
  data_frame <- as.data.frame(data_frame)
  return(
    rbind(
      NA_Count = sapply(data_frame, function(x) sum(is.na(x))),
      Distinct_Count = sapply(data_frame, function(x) dplyr::n_distinct(x)),
      Current_Data_Type = sapply(data_frame, typeof)
    )
  )
}
