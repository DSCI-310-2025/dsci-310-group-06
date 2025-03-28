# R/quantitative_density.R

library(ggplot2)

# Function to generate density plots for numerical variables
quantitative_density <- function(df, numerical_vars, target_col) {
  density_plots <- list()
  for (var in numerical_vars) {
    p <- ggplot(df, aes(x = !!rlang::sym(var), fill = as.factor(!!sym(target_col)))) +
      geom_density(alpha = 0.5) +
      scale_fill_manual(values = c("#FF9999", "#66B2FF")) +
      labs(title = paste("Diabetes Binary by", var),
           x = var, y = "Density", fill = "Diabetes Binary") +
      theme_minimal() +
      theme(
        axis.text = element_text(size = 30),
        axis.title = element_text(size = 30),
        plot.title = element_text(size = 35, face = "bold")
      )
    density_plots[[var]] <- p
  }
  return(density_plots)
}
