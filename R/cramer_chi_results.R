#' Table of chi-squared test results
#' 
#' Run chi-squared tests and calculate Cramer's V independently for each feature
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#'
#' @return Data frame with 1 row per variable and 7 columns:
#'    - Variable: Name of categorical variable.
#'    - Statistic: Chi-squared test statistic. 
#'    - DF: Degrees of freedom.
#'    - p_value: p-value from chi-squared test.
#'    - Expected_Min: Minimum expected value.
#'    - Expected_Max: Maximum expected value.
#'    - CramersV: Cramer's V statistic.
#' @export
#' @examples
#' cramer_chi_results(mtcars, c("cyl", "gear"), "mpg")

cramer_chi_results <- function(df, categorical_vars, target_col) {
  if (nrow(df) == 0) {
    stop("Insufficient data: the dataframe is empty.")
  }
  
  if (!is.character(categorical_vars)) {
    stop("categorical_vars must be a character vector of column names.")
  }
  
  missing_vars <- setdiff(categorical_vars, colnames(df))
  if (length(missing_vars) > 0) {
    stop(paste("The following variables are not present in the dataframe:", paste(missing_vars, collapse = ", ")))
  }
  
  cramer_chi_results <- purrr::map_dfr(categorical_vars, function(var) {
    tbl <- table(df[[var]], df[[target_col]])
    test_result <- stats::chisq.test(tbl)
    cv <- vcd::assocstats(tbl)$cramer
    tibble::tibble(
      Variable = var,
      Statistic = test_result$statistic,
      DF = test_result$parameter,
      p_value = test_result$p.value,
      Expected_Min = min(test_result$expected),
      Expected_Max = max(test_result$expected),
      CramersV = cv
    )
  })
  
  return(dplyr::arrange(cramer_chi_results, dplyr::desc(CramersV)))
}