"This script conducts exploratory data analysis on the diabetes_train dataset

Usage: 02-eda.R --file_path=<file_path> --r_path_categorical_bars=<r_path_categorical_bars> --r_path_quantitative_density=<r_path_quantitative_density> --r_path_plots_grid=<r_path_plots_grid> --r_path_cramer_chi_results=<r_path_cramer_chi_results> --output_path_plots=<output_path_plots> --output_path_cramers=<output_path_cramers>
Options:
--file_path=<file_path>                                     Path to obtain the raw dataset CSV file
--r_path_categorical_bars=<r_path_categorical_bars>         Path to R script for categorical_bars
--r_path_quantitative_density=<r_path_quantitative_density> Path to R script for density_plots
--r_path_plots_grid=<r_path_plots_grid>                     Path to R script for plots_grid
--r_path_cramer_chi_results=<r_path_cramer_chi_results>     Path to R script for cramer_chi_results
--output_path_plots=<output_path_plots>                     Path to save the summary statistics of the target variable before balancing
--output_path_cramers=<output_path_cramers>                 Path to save the comparison data frame of target variable class distribution before and after balancing
" -> doc

library(tidyverse)
library(patchwork)
library(vcd)
library(docopt)
# Setting the seed for consistent results
set.seed(6)

opt <- docopt::docopt(doc)

# Sourcing required functions
source(opt$r_path_categorical_bars)
source(opt$r_path_quantitative_density)
source(opt$r_path_plots_grid)
source(opt$r_path_cramer_chi_results)

# READ diabetes_train dataset
diabetes_train <- readr::read_rds(opt$file_path)

# Categorical variables
categorical_vars <- c("HighBP", "HighChol", "CholCheck", "Smoker", "Stroke", 
                      "HeartDiseaseorAttack", "PhysActivity", "Fruits", "Veggies", 
                      "HvyAlcoholConsump", "AnyHealthcare", "NoDocbcCost", 
                      "DiffWalk", "Sex", "Age", "Education", "Income", "MentHlth", "PhysHlth", "GenHlth")

# Non-categorical variables
noncat_vars <- c("BMI")

# Creating bar plots for each categorical variable in the dataset
bar_plots <- categorical_bars(diabetes_train, categorical_vars, "Diabetes_binary")

# Density plot for BMI (non-categorical)
density_plots <- quantitative_density(diabetes_train, noncat_vars, "Diabetes_binary")

# Combining all of the plots into a facet of plots (3 columns)
combined_plots <- plots_grid(bar_plots, density_plots, 3)
ggplot2::ggsave(opt$output_path_plots, combined_plots, width = 50, height = 50, dpi = 300, limitsize = FALSE) # WRITE combined_plots

# Run chi-squared tests independently for each feature
cramer_chi_results_sorted <- cramer_chi_results(diabetes_train, categorical_vars, "Diabetes_binary")
readr::write_csv(cramer_chi_results_sorted, opt$output_path_cramers) # WRITE cramer_chi_results_sorted
