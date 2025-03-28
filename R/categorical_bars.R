# R/categorical_bars.R

library(ggplot2)

# Function to generate bar plots for categorical variables
categorical_bars <- function(df, categorical_vars, target_col) {
  bar_plots <- list()
  for (var in categorical_vars) {
    p <- ggplot(df, aes(x = !!rlang::sym(var), fill = as.factor(!!sym(target_col)))) +
      geom_bar(position = "fill") +
      scale_fill_manual(values = c("#FF9999", "#66B2FF")) +
      labs(title = paste("Diabetes Binary by", var),
           x = var, y = "Proportion", fill = "Diabetes Binary") +
      theme_minimal() +
      theme(
        axis.text = element_text(size = 30),
        axis.title = element_text(size = 30),
        plot.title = element_text(size = 35, face = "bold")
      )
    bar_plots[[var]] <- p
  }
  return(bar_plots)
}
