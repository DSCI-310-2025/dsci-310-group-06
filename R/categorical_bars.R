#' List of Bar Plots
#'
#' Create a list of bar plots for each categorical variable in a data frame. 
#' The proportions for each categorical variable are grouped by a different fill 
#' color.
#'
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#' @param cat_vars A vector containing the string name(s) of each **categorical** variable to plot on the x-axis.
#' @param target_col Column of interest to plot each variable against (object).
#' @param title_size Size of each plot's title (Default = 30).
#' @param axis_size Size of each plot's axes (Default = 35).
#'
#' @return A list containing \code{ggplot2} object(s) (bar plots).
#' 
#' @export
#'
#' @examples
#' \dontrun{
#'   # Generate bar plots for categorical variables from the mtcars dataset
#'   bar_plots <- categorical_bars(
#'     data_frame = mtcars,
#'     cat_vars = c("cyl", "gear"),
#'     target_col = "am",
#'     title_size = 25,
#'     axis_size = 20
#'   )
#'   # Display the first bar plot
#'   print(bar_plots[["cyl"]])
#' }
#' 
categorical_bars <- function(data_frame, cat_vars, target_col, title_size = 30, axis_size = 35) {
  bar_plots <- list()
  
  for (var in cat_vars) {
    p <- ggplot2::ggplot(data_frame, aes(x = !!sym(var), fill = as.factor(!!sym(target_col)))) +
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
