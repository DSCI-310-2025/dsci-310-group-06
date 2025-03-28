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
library(dplyr)
library(vcd)

cramer_chi_results <- function(df, categorical_vars, target_col) {
  cramer_chi_results <- purrr::map_dfr(categorical_vars, function(var) {
    tbl <- table(df[[target_col]], df[[var]])

    if (all(tbl == 0)) {
      stop(paste("Insufficient data"))
    }

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

  return(cramer_chi_results %>% arrange(desc(CramersV)))
}