#' Grid of Plots
#'
#' Combine a list or mulitple lists of \code{ggplot2} objects into a single
#' grid layout using \code{patchwork}. The number of columns in the grid can be
#' specified with `num_cols`.
#'
#' @param bar_plots A list of bar plot \code{ggplot2} objects.
#' @param density_plots A list of quantitative density plot \code{ggplot2} objects.
#' @param num_cols The number of columns in the grid (Default = 3).
#'
#' @return A \code{patchwork} / \code{ggplot2} object showing all input plots arranged.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#'   # Generate example bar plots
#'   bar_plots <- categorical_bars(
#'     data_frame = mtcars,
#'     cat_vars = c("cyl", "gear"),
#'     target_col = "am"
#'   )
#'   # Generate example density plots
#'   density_plots <- quantitative_density(
#'     data_frame = mtcars,
#'     noncat_vars = c("mpg", "hp", "wt"),
#'     target_col = "am"
#'   )
#'   # Combine plots into a grid
#'   grid_plot <- plots_grid(bar_plots, density_plots, num_cols = 2)
#' }
#'
plots_grid <- function(bar_plots, density_plots, num_cols = 3) {
  all_plots <- c(bar_plots, density_plots)
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
