# plots_grid.R

#' plots_grid
#'
#' Combine a list of \code{ggplot2} objects into a single grid layout using \code{patchwork}.
#'
#' @param plots A list of \code{ggplot2} objects.
#' @param ncol The number of columns in the grid (default = 3).
#'
#' @return A \code{patchwork} / \code{ggplot2} object showing all input plots arranged.
#'
#' @examples
#' \dontrun{
#'   library(ggplot2)
#'   p1 <- ggplot(mtcars, aes(x = hp)) + geom_histogram()
#'   p2 <- ggplot(mtcars, aes(x = mpg)) + geom_histogram()
#'
#'   combined <- plots_grid(list(p1, p2), ncol = 2)
#'   print(combined)
#' }
plots_grid <- function(plots, ncol = 3) {
  # Use patchwork with double-colon
  combined_plots <- patchwork::wrap_plots(plots, ncol = ncol) +
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
