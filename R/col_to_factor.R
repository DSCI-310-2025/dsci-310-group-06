#' Convert categorical/binary variable columns into factors
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble)
#'    with categorical/binary variables
#'
#' @return Data frame with categorical/binary variables converted into factors
#' @export
#' @examples
#' na_count_type()
col_to_factor <- function(data_frame) {
  return(
    data_frame %>%
      dplyr::mutate(dplyr::across(where(is.character), ~ factor(.)))
  )
}