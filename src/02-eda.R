"This script conducts exploratory data analysis on the diabetes_train dataset

Usage: 02-eda.R --file_path=<file_path> --output_path_plots=<output_path_plots> --output_path_cramers=<output_path_cramers>
Options:
--file_path=<file_path>                     Path to obtain the raw dataset CSV file
--output_path_plots=<output_path_plots>     Path to save the summary statistics of the target variable before balancing
--output_path_cramers=<output_path_cramers> Path to save the comparison data frame of target variable class distribution before and after balancing
" -> doc

library(tidyverse)
library(patchwork)
library(vcd)
library(docopt)
# Setting the seed for consistent results
set.seed(6)

opt <- docopt::docopt(doc)

# READ diabetes_train
diabetes_train <- readr::read_csv(opt$file_path)

options(repr.plot.width = 30, repr.plot.height = 90, warn = -1)

# Categorical variables
categorical_vars <- c("HighBP", "HighChol", "CholCheck", "Smoker", "Stroke", 
                      "HeartDiseaseorAttack", "PhysActivity", "Fruits", "Veggies", 
                      "HvyAlcoholConsump", "AnyHealthcare", "NoDocbcCost", 
                      "DiffWalk", "Sex", "Age", "Education", "Income", "MentHlth", "PhysHlth", "GenHlth")

# Non-categorical variables
noncat_var <- c("BMI")

# --------------------------------------------------
# inits with empty lists
bar_plots <- list()
density_plots <- list()

# --------------------------------------------------
# Creating bar plots for each categorical variable in the dataset # CONVERT TO FUNCTION (40-55)
for (var in categorical_vars) {
  p <- ggplot2::ggplot(diabetes_train, ggplot2::aes(x = !!rlang::sym(var), fill = as.factor(Diabetes_binary))) +
    ggplot2::geom_bar(position = "fill") + 
    ggplot2::scale_fill_manual(values = c("#FF9999", "#66B2FF")) + 
    ggplot2::labs(title = paste("Diabetes Binary by", var),
                  x = var,
                  y = "Proportion",
                  fill = "Diabetes Binary") +
    ggplot2::theme_minimal() + 
    ggplot2::theme(
      axis.text = ggplot2::element_text(size = 30),  
      axis.title = ggplot2::element_text(size = 30), 
      plot.title = ggplot2::element_text(size = 35, face = "bold")
    )
  bar_plots[[var]] <- p
}

# --------------------------------------------------
# Density plot for BMI # CONVERT TO FUNCTION (58-74)
for (var in noncat_var) {
  p <- ggplot2::ggplot(diabetes_train, ggplot2::aes(x = !!rlang::sym(var), fill = as.factor(Diabetes_binary))) +
    ggplot2::geom_density(alpha = 0.5) +
    ggplot2::scale_fill_manual(values = c("#FF9999", "#66B2FF")) +
    ggplot2::labs(title = paste("Diabetes Binary by", var),
                  x = var,
                  y = "Density",
                  fill = "Diabetes Binary") +
    ggplot2::theme_minimal() + 
    ggplot2::theme(
      axis.text = ggplot2::element_text(size = 30),
      axis.title = ggplot2::element_text(size = 30),
      plot.title = ggplot2::element_text(size = 35, face = "bold")
    )
  density_plots[[var]] <- p
}

all_plots <- c(bar_plots, density_plots)
num_cols <- 3

# Combining all of the plots into a 3 x 7 grid # CONVERT TO FUNCTION (76-89)
combined_plots <- patchwork::wrap_plots(all_plots, ncol = num_cols) + 
  patchwork::plot_layout(guides = "collect") +
  patchwork::plot_annotation(
    theme = ggplot2::theme(
      plot.title = ggplot2::element_text(size = 50, face = "bold"),
      plot.subtitle = ggplot2::element_text(size = 40),
      axis.title = ggplot2::element_text(size = 30),
      axis.text = ggplot2::element_text(size = 30)
    )
  )

# WRITE combined_plots
ggplot2::ggsave(opt$output_path_plots, combined_plots, width = 50, height = 50, dpi = 300, limitsize = FALSE)

# Run chi-squared tests independently for each feature
cramer_chi_results <- purrr::map_dfr(categorical_vars, function(var) {
  tbl <- table(diabetes_train$Diabetes_binary, diabetes_train[[var]])
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

# Arrange the results by p-value (from smallest to largest)
cramer_chi_results_sorted <- cramer_chi_results %>% dplyr::arrange(dplyr::desc(CramersV))

# WRITE cramer_chi_results_sorted
readr::write_csv(cramer_chi_results_sorted, opt$output_path_cramers)
