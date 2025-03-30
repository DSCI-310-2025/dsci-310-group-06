# plots_grid.R

#' plots_grid
#'
#' Combine a list of \code{ggplot2} objects into a single grid layout using \code{patchwork}.
#'
#' @param bar_plots A list of bar plot objects.
#' @param density_plots A list of quantitative density plot objects.
#' @param num_cols The number of columns in the grid (Default = 3).
#'
#' @return A \code{patchwork} / \code{ggplot2} object showing all input plots arranged.
#'
#' @examples

plots_grid <- function(bar_plots, density_plots, num_cols = 3) {
  all_plots <- c(bar_plots, density_plots)
  
  # Create the combined plot grid with specified number of columns
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
  
  return(combined_plots)
}