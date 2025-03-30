#' quantitative_density
#'
#' Create a density plot of a numeric variable, filled by another variable.
#'
#' @param data A data frame containing the variables of interest.
#' @param var A character string specifying the name of the *numeric* column to plot on the x-axis.
#' @param fill_var A character string specifying the name of the variable by which densities are filled.
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
quantitative_density <- function(data, var, fill_var) {
  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = !!rlang::sym(var),
      fill = as.factor(!!rlang::sym(fill_var))
    )
  ) +
    ggplot2::geom_density(alpha = 0.5) +
    ggplot2::scale_fill_manual(values = c("#FF9999", "#66B2FF")) +
    ggplot2::labs(
      title = paste("Distribution by", var),
      x = var,
      y = "Density",
      fill = fill_var
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text = ggplot2::element_text(size = 30),
      axis.title = ggplot2::element_text(size = 30),
      plot.title = ggplot2::element_text(size = 35, face = "bold")
    )
  
  return(p)
}
