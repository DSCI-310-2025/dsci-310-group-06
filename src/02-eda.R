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

# Categorical variables
categorical_vars <- c("HighBP", "HighChol", "CholCheck", "Smoker", "Stroke", 
                      "HeartDiseaseorAttack", "PhysActivity", "Fruits", "Veggies", 
                      "HvyAlcoholConsump", "AnyHealthcare", "NoDocbcCost", 
                      "DiffWalk", "Sex", "Age", "Education", "Income", "MentHlth", "PhysHlth", "GenHlth")

# Non-categorical variables
noncat_var <- c("BMI")

# Creating bar plots for each categorical variable in the dataset # CONVERT TO FUNCTION categorical_bars (40-55)
source("~/work/R/categorical_bars.R")
bar_plots <- categorical_bars(diabetes_train, categorical_vars, "Diabetes_binary")

# Density plot for BMI # CONVERT TO FUNCTION quantitative_density (58-74)
source("~/work/R/quantitative_density.R")
density_plots <- quantitative_density(diabetes_train, noncat_var, "Diabetes_binary")

source("~/work/R/plots_grid.R")
num_cols <- 3
combined_plots <- plots_grid(bar_plots, density_plots, num_cols)

# WRITE combined_plots
ggplot2::ggsave(opt$output_path_plots, combined_plots, width = 50, height = 50, dpi = 300, limitsize = FALSE)

# Run chi-squared tests independently for each feature # CONVERT TO FUNCTION cramer_chi_results (94-108)
source("~/work/R/cramer_chi_results.R")
cramer_results_sorted <- cramer_chi_results(diabetes_train, categorical_vars, "Diabetes_binary")

# WRITE cramer_chi_results_sorted
readr::write_csv(cramer_results_sorted, opt$output_path_cramers)
