# categorical_bars.R

#' categorical_bars
#'
#' Create a bar plot of a categorical variable showing proportions grouped by a fill variable.
#'
#' @param data A data frame containing the variables of interest.
#' @param var A character string specifying the name of the **categorical** column to plot on the x-axis.
#' @param fill_var A character string specifying the name of the variable by which bars are filled.
#'
#' @return A \code{ggplot2} object (bar plot).
#'
#' @examples
#' \dontrun{
#'   data <- data.frame(
#'     var1 = rep(c("A", "B"), each = 5),
#'     Diabetes_binary = rep(c(0, 1), times = 5)
#'   )
#'   p <- categorical_bars(data, "var1", "Diabetes_binary")
#'   print(p)
#' }

categorical_bars <- function(data,
                             x_var,
                             fill_var,
                             position = "fill",
                             fill_palette = c("#FF9999", "#66B2FF"),
                             text_size = 14,
                             title_size = 16,
                             plot_title = NULL) {
  
  if (is.null(plot_title)) {
    plot_title <- paste("Proportions by", x_var)
  }
  
  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = as.factor(!!rlang::sym(x_var)),
      fill = as.factor(!!rlang::sym(fill_var))
    )
  ) +
    ggplot2::geom_bar(position = position) +
    ggplot2::scale_fill_manual(values = fill_palette) +
    ggplot2::labs(
      title = plot_title,
      x = x_var,
      y = if (position == "fill") "Proportion" else "Count",
      fill = fill_var
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text  = ggplot2::element_text(size = text_size),
      axis.title = ggplot2::element_text(size = text_size),
      plot.title = ggplot2::element_text(size = title_size, face = "bold")
    )
  
  return(p)
}
