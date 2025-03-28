# R/imbalance_target.R

library(dplyr)
library(vcd)

# Function to compute imbalance in the target variable
imbalance_target <- function(df, categorical_vars, target_col) {
  cramer_chi_results <- purrr::map_dfr(categorical_vars, function(var) {
    tbl <- table(df[[target_col]], df[[var]])
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
