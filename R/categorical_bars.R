#' categorical_bars
#'
#' Create a bar plot of a categorical variable showing proportions grouped by a fill variable.
#'
#' @param data A data frame containing the variables of interest.
#' @param categorical_vars A character string specifying the name of the **categorical** column to plot on the x-axis.
#' @param target_col Column of interest to plot each categorical variable against
#' @param title_size Size of each plot's title (Default = 30)
#' @param axis_size Size of each plot's axes (Default = 35)
#'
#' @return A \code{ggplot2} object (bar plot).
#'
#' @examples

categorical_bars <- function(data, categorical_vars, target_col, title_size = 30, axis_size = 35) {
  bar_plots <- list()
  
  for (var in categorical_vars) {
    p <- ggplot2::ggplot(data, aes(x = !!sym(var), fill = as.factor(!!sym(target_col)))) +
      geom_bar(position = "fill") + 
      scale_fill_manual(values = c("#FF9999", "#66B2FF")) + 
      labs(title = paste("Diabetes Binary by", var),
           x = var,
           y = "Proportion",
           fill = "Diabetes Binary") +
      theme_minimal() + 
      theme(
        axis.text = element_text(size = axis_size),
        axis.title = element_text(size = axis_size),
        plot.title = element_text(size = title_size, face = "bold")
      )
    bar_plots[[var]] <- p
  }
  
  return(bar_plots)
}