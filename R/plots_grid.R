#' Grid of Plots
#'
#' Facet a list of \code{ggplot2} bar plot objects into a single
#' grid layout using \code{patchwork}. The number of columns in the grid can be
#' specified with `num_cols`.
#'
#' @param bar_plots A list of \code{ggplot2} bar plot objects.
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
#'     )
#'     
#'   # Combine plots into a grid
#'   grid_plot <- plots_grid(bar_plots, num_cols = 2)
#' }
#'
plots_grid <- function(bar_plots, num_cols = 3) {
  
  if (!is.list(bar_plots) || !all(sapply(bar_plots, inherits, "gg"))) {
    stop("'bar_plots' must be a list of ggplot objects.")
  }
  
  combined_plots <- patchwork::wrap_plots(bar_plots, ncol = num_cols) +
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
