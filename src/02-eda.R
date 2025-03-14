# Importing required packages for analysis. Suppress warnings and startup messages the first time libraries are loaded
library(tidyverse) # Data wrangling and visualization
library(patchwork) # Combine plots
library(vcd) # For Cramér’s V
library(docopt)

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
# Creating bar plots for each categorical variable in the dataset
for (var in categorical_vars) {
  p <- ggplot(diabetes_train, aes(x = !!sym(var), fill = as.factor(Diabetes_binary))) +
    geom_bar(position = "fill") + 
    scale_fill_manual(values = c("#FF9999", "#66B2FF")) + 
    labs(title = paste("Diabetes Binary by", var),
         x = var,
         y = "Proportion",
         fill = "Diabetes Binary") +
    theme_minimal() + 
    theme(
      axis.text = element_text(size = 30),  
      axis.title = element_text(size = 30), 
      plot.title = element_text(size = 35, face = "bold")
    )
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
    theme_minimal() + 
    theme(
      axis.text = element_text(size = 30),  
      axis.title = element_text(size = 30), 
      plot.title = element_text(size = 35, face = "bold")
    )
  density_plots[[var]] <- p
}

all_plots = c(bar_plots, density_plots)
num_cols = 3

# Combining all of the plots into a 3 x 7 grid
combined_plots <- wrap_plots(c(bar_plots, density_plots), ncol = num_cols) + 
  plot_layout(guides = "collect") +
  plot_annotation(
    title = "Figure 1. Distribution of Diabetes Binary by Various Variables",
    subtitle = "This figure shows the distribution of the binary diabetes outcome across different variables, including binary and continuous variables.",
    theme = theme(
      plot.title = element_text(size = 50, face = "bold"),
      plot.subtitle = element_text(size = 40),
      axis.title = element_text(size = 30),
      axis.text = element_text(size = 30),
      )
    )

# WRITE combined_plots
ggsave("combined_plots.png", combined_plots, width = 50, height = 50, dpi = 300, limitsize = FALSE)

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
# WRITE cramer_chi_results_sorted
cramer_chi_results_sorted <- cramer_chi_results %>% arrange(desc(CramersV))

