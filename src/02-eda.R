"This script conducts exploratory data analysis on the diabetes_train dataset

Usage: 02-eda.R --file_path=<file_path> --r_path_categorical_bars=<r_path_categorical_bars> --r_path_plots_grid=<r_path_plots_grid> --r_path_cramer_chi_results=<r_path_cramer_chi_results> --r_path_info_gain=<r_path_info_gain> --output_path_plots=<output_path_plots> --output_path_cramers=<output_path_cramers> --output_path_info_gain=<output_path_info_gain>
Options:
--file_path=<file_path>                                     Path to obtain the raw dataset CSV file
--r_path_categorical_bars=<r_path_categorical_bars>         Path to R script for categorical_bars
--r_path_plots_grid=<r_path_plots_grid>                     Path to R script for plots_grid
--r_path_cramer_chi_results=<r_path_cramer_chi_results>     Path to R script for cramer_chi_results
--r_path_info_gain=<r_path_info_gain>                       Path to R script for info_gain
--output_path_plots=<output_path_plots>                     Path to save the summary statistics of the target variable before balancing
--output_path_cramers=<output_path_cramers>                 Path to save the comparison data frame of target variable class distribution before and after balancing
--output_path_info_gain=<output_path_info_gain>             Path to save the data frame of information gain results
" -> doc

library(tidyverse)
library(patchwork)
library(vcd)
library(FSelectorRcpp)
library(docopt)
# Setting the seed for consistent results
set.seed(6)

opt <- docopt::docopt(doc)

# Sourcing required functions
source(opt$r_path_categorical_bars)
source(opt$r_path_plots_grid)
source(opt$r_path_cramer_chi_results)
source(opt$r_path_info_gain)

# READ diabetes_train dataset
diabetes_train <- readr::read_rds(opt$file_path)

# Categorical variables
categorical_vars <- c("HighBP", "HighChol", "CholCheck", "Smoker", "Stroke", 
                      "HeartDiseaseorAttack", "PhysActivity", "Fruits", "Veggies", 
                      "HvyAlcoholConsump", "AnyHealthcare", "NoDocbcCost", 
                      "DiffWalk", "Sex", "Age", "Education", "Income", "MentHlth", 
                      "PhysHlth", "GenHlth", "BinnedBMI")

# Creating bar plots for each categorical variable in the dataset
bar_plots <- categorical_bars(diabetes_train, categorical_vars, "Diabetes_binary")

# Combining all of the plots into a facet of plots (3 columns)
combined_plots <- plots_grid(bar_plots, 3)

# Run chi-squared tests independently for each feature
cramer_chi_results_sorted <- cramer_chi_results(diabetes_train, categorical_vars, "Diabetes_binary")

# Run information gain for each feature
info_table <- info_gain(Diabetes_binary ~ ., data = diabetes_train)

ggplot2::ggsave(opt$output_path_plots, combined_plots, width = 50, height = 50, dpi = 300, limitsize = FALSE) # WRITE combined_plots
readr::write_csv(cramer_chi_results_sorted, opt$output_path_cramers) # WRITE cramer_chi_results_sorted
readr::write_csv(info_table, opt$output_path_info_gain) # WRITE info_table
