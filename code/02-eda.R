# Importing required packages for analysis. Suppress warnings and startup messages the first time libraries are loaded
library(tidyverse) # Data wrangling and visualization
library(tidymodels) # Machine learning tools
library(glmnet) # Fit generalized linear models by penalty
library(patchwork) # Combine plots
library(ROSE) # Random Over-Sampling Examples for dataset balancing
library(vcd) # For Cramér’s V

options(repr.plot.width = 15, repr.plot.height = 10, warn = -1)

# READ diabetes_train, diabetes_test

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
# Creating bar plots for each categorical variable in the dataset
for (var in categorical_vars) {
  p <- ggplot(diabetes_train, aes(x = !!sym(var), fill = as.factor(Diabetes_binary))) +
    geom_bar(position = "fill") + 
    scale_fill_manual(values = c("#FF9999", "#66B2FF")) + 
    labs(title = paste("Diabetes Binary by", var),
         x = var,
         y = "Proportion",
         fill = "Diabetes Binary") +
    theme_minimal()
  bar_plots[[var]] <- p
}

# --------------------------------------------------
# Density plot for BMI
for (var in noncat_var) {
  p <- ggplot(diabetes_train, aes(x = !!sym(var), fill = as.factor(Diabetes_binary))) +
    geom_density(alpha = 0.5) +
    scale_fill_manual(values = c("#FF9999", "#66B2FF")) + 
    labs(title = paste("Diabetes Binary by", var),
         x = var,
         y = "Density",
         fill = "Diabetes Binary") +
    theme_minimal()
  density_plots[[var]] <- p
}

options(repr.plot.width = 20, repr.plot.height = 12)

# Combining all of the plots into a 3 x 7 grid
combined_plots <- wrap_plots(c(bar_plots, density_plots), ncol = 3, nrow = 7) + 
  plot_annotation(
    title = "Figure 1. Distribution of Diabetes Binary by Various Variables",
    subtitle = "This figure shows the distribution of the binary diabetes outcome across different variables, including binary and continuous variables.",
    theme =   theme(
      plot.title = element_text(size = 16, face = "bold"),
      plot.subtitle = element_text(size = 12),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 10)
    )
  )

# WRITE combined_plots

# Run chi-squared tests independently for each feature
cramer_chi_results <- map_dfr(categorical_vars, function(var) {
  tbl <- table(diabetes_train$Diabetes_binary, diabetes_train[[var]])
  test_result <- chisq.test(tbl)
  cv <- assocstats(tbl)$cramer
  tibble(
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
cramer_chi_results_sorted <- cramer_chi_results %>% arrange(desc(CramersV))

# WRITE cramer_chi_results_sorted

