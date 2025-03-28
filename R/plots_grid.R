# R/plots_grid.R

library(patchwork)
library(ggplot2)

# Function to arrange multiple plots into a grid
plots_grid <- function(plot_list, num_cols = 3) {
  return(
    wrap_plots(plot_list, ncol = num_cols) +
      plot_layout(guides = "collect") +
      plot_annotation(
        theme = theme(
          plot.title = element_text(size = 50, face = "bold"),
          plot.subtitle = element_text(size = 40),
          axis.title = element_text(size = 30),
          axis.text = element_text(size = 30)
        )
      )
  )
}
