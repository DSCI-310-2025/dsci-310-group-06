#' Summarise dataframe columns.
#' 
#' Given input dataframe, for each column, check for NA values, distinct
#' counts of each variable, and the current data types. For each variable,
#' NULL with be treated as a column of NA
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#'
#' @return Data frame with 1 row per variable and 3 columns:
#'    - NA_Count: Number of "NA" values within each variable.
#'    - Distinct_Count: Number of distinct values for each variable.
#'    - Current_Data_Type: Current data type for each variable.
#' @export
#' @examples
#' \dontrun{
#'   na_count_type(mtcars)
#' }
na_count_type <- function(data_frame) {
  data_frame <- as.data.frame(data_frame)
  return(
    rbind(
      NA_Count = sapply(data_frame, function(x) sum(is.na(x))),
      Distinct_Count = sapply(data_frame, function(x) dplyr::n_distinct(x)),
      Current_Data_Type = sapply(data_frame, typeof)
    )
  )
}