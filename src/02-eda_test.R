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

file_path <- "work/data/processed/diabetes_train.csv"
output_path_plots <- "work/output/combined_plots.png"
output_path_cramers <- "work/output/cramer_chi_results_sorted.csv"

# if (interactive()) {
#   opt <- list(
#    file_path = "work/data/processed/diabetes_train.csv",
#    output_path_plots = "work/output/combined_plots.png",
#    output_path_cramers = "work/output/cramer_chi_results_sorted.csv"
#   )
#} else {
#  opt <- docopt::docopt(doc)
# }

# READ diabetes_train
diabetes_train <- readr::read_csv(file_path)

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
# Creating bar plots for each categorical variable in the dataset # CONVERT TO FUNCTION categorical_bars (40-55)
source("work/R/categorical_bars.R")
bar_plots <- list()  # Initialize an empty list to store plots

for (var in categorical_vars) {
  bar_plots[[var]] <- categorical_bars(
    data       = diabetes_train,
    x_var      = var,
    fill_var   = "Diabetes_binary"
  )
}


# --------------------------------------------------
# Density plot for BMI # CONVERT TO FUNCTION quantitative_density (58-74)
source("work/R/quantitative_density.R")

# Loop over your numeric variables with the abstract function
density_plots <- list()  # Initialize an empty list to store plots

for (var in noncat_var) {
  density_plots[[var]] <- quantitative_density(
    data = diabetes_train, 
    var  = var, 
    fill_var = "Diabetes_binary"
  )
}

all_plots <- c(bar_plots, density_plots)
num_cols <- 3
all_plots
# Combining all of the plots into a facet of plots # CONVERT TO FUNCTION plots_grid (76-89) (Input number of columns)
source("work/R/plots_grid.R")
plots_grid <- function(plots, ncol = 3) {
  library(patchwork)
  wrap_plots(plots, ncol = ncol)
}

#  Combine the bar plots and density plots 
combined_plots <- plots_grid(
  plots = all_plots,
  ncol  = num_cols  
)


# WRITE combined_plots
ggplot2::ggsave(output_path_plots, combined_plots, width = 50, height = 50, dpi = 300, limitsize = FALSE)

# Run chi-squared tests independently for each feature # CONVERT TO FUNCTION cramer_chi_results (94-108)
source("work/R/cramer_chi_results.R")

# create the chi-squared summary

cramer_chi_results_sorted <- cramer_chi_results(
  df = diabetes_train,
  categorical_vars = categorical_vars,
  target_col = "Diabetes_binary"
)

# Arrange the results by p-value (from smallest to largest)
cramer_chi_results_sorted <- cramer_chi_results %>% dplyr::arrange(dplyr::desc(CramersV))

# WRITE cramer_chi_results_sorted
readr::write_csv(cramer_chi_results_sorted, opt$output_path_cramers)
