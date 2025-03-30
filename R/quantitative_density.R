#' List of Density Plots
#'
#' Create a list of quantitative density plots for each non-categorical variable
#' in a data frame. The density area for each variable are mapped to a different
#' fill color.
#' 
#' @param data_frame A data frame or data frame extension (e.g. a tibble).
#' @param noncat_vars A vector containing the string name(s) of each **non-categorical** variable to plot on the x-axis.
#' @param target_col Column of interest to plot each variable against (object).
#' @param title_size Size of each plot's title (Default = 30).
#' @param axis_size Size of each plot's axes (Default = 35).
#'
#' @return A list containing \code{ggplot2} object(s) (density plots).
#' 
#' @export
#'
#' @examples
#' \dontrun{
#'   # Generate density plots for non-categorical variables from the mtcars dataset
#'   density_plots <- quantitative_density(
#'     data_frame = mtcars,
#'     noncat_vars = c("mpg", "hp", "wt"),
#'     target_col = "am",
#'     title_size = 25,
#'     axis_size = 20
#'   )
#'   # Display the first density plot
#'   print(density_plots[["mpg"]])
#' }
#'   
quantitative_density <- function(data_frame, noncat_vars, target_col, title_size = 35, axis_size = 30) {
  density_plots <- list()
  
  for (var in noncat_vars) {
    p <- ggplot2::ggplot(data_frame, aes(x = !!sym(var), fill = as.factor(!!sym(target_col)))) +
      geom_density(alpha = 0.5) +
      scale_fill_manual(values = c("#FF9999", "#66B2FF")) +
      labs(title = paste("Diabetes Binary by", var),
           x = var,
           y = "Density",
           fill = "Diabetes Binary") +
      theme_minimal() + 
      theme(
        axis.text = element_text(size = axis_size),
        axis.title = element_text(size = axis_size),
        plot.title = element_text(size = title_size, face = "bold")
      )
    density_plots[[var]] <- p
  }
  return(density_plots)
}
