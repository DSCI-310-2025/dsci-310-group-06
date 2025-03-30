library(ggplot2)
#' quantitative_density
#'
#' Create a density plot of a numeric variable, filled by another variable.
#'
#' @param data A data frame containing the variables of interest.
#' @param noncat_vars A character string specifying the name of the **non-categorical** column to plot on the x-axis.
#' @param target_col Column of interest to plot each non-categorical variable against
#' @param title_size Size of each plot's title (Default = 30)
#' @param axis_size Size of each plot's axes (Default = 35)
#'
#' @return A \code{ggplot2} object (density plot).
#'
#' @examples
#' \dontrun{
#'   data <- data.frame(
#'     BMI = rnorm(10, mean = 25, sd = 5),
#'     Diabetes_binary = sample(0:1, 10, replace = TRUE)
#'   )
#'   p <- quantitative_density(data, "BMI", "Diabetes_binary")
#'   print(p)
#' }
#' 
quantitative_density <- function(data, noncat_vars, target_col, title_size = 35, axis_size = 30) {
  density_plots <- list()

  for (var in noncat_vars) {
    p <- ggplot(data, aes(x = !!sym(var), fill = as.factor(!!sym(target_col)))) +
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

