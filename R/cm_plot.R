# cm_plot.R

#' cm_plot
#'
#' Plot a confusion matrix from a \code{yardstick::conf_mat()} (or from 
#' \code{caret::confusionMatrix}, with minor modifications).
#'
#' @param conf_matrix A confusion matrix object. Typically from yardstick::conf_mat() 
#'   (with columns "Prediction" and "Truth" in conf_matrix$table).
#'
#' @return A \code{ggplot2} object displaying a tile heatmap of the confusion matrix.
#'
#' @examples
#' \dontrun{
#'   library(yardstick)
#'   df <- data.frame(
#'     truth = factor(c(0, 0, 1, 1)),
#'     estimate = factor(c(0, 1, 0, 1))
#'   )
#'   cm <- yardstick::conf_mat(df, truth = truth, estimate = estimate)
#'   p <- cm_plot(cm)
#'   print(p)
#' }
cm_plot <- function(conf_matrix) {
  # conf_matrix$table is a data frame with columns "Prediction", "Truth", "Freq" for yardstick.
  cm_df <- as.data.frame(conf_matrix$table)
  
  # If using caret::confusionMatrix, you'd do something like:
  # if (is.matrix(conf_matrix$table)) {
  #   library(tibble)
  #   library(tidyr)
  #   cm_df <- as.data.frame(conf_matrix$table) %>%
  #     tibble::rownames_to_column("Truth") %>%
  #     tidyr::pivot_longer(
  #       cols = -Truth,
  #       names_to = "Prediction",
  #       values_to = "Freq"
  #     )
  # } else {
  #   cm_df <- as.data.frame(conf_matrix$table)
  # }
  
  p <- ggplot2::ggplot(
    cm_df,
    ggplot2::aes(
      x = Prediction,
      y = Truth,
      fill = Freq
    )
  ) +
    ggplot2::geom_tile() +
    ggplot2::geom_text(
      ggplot2::aes(label = Freq),
      size = 10,
      color = "black"
    ) +
    ggplot2::scale_fill_gradient(low = "white", high = "blue") +
    ggplot2::labs(
      title = "Confusion Matrix",
      x = "Predicted Class",
      y = "True Class"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text = ggplot2::element_text(size = 15),
      axis.title = ggplot2::element_text(size = 20)
    )
  
  return(p)
}


