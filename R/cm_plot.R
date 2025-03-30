#' Create and save a confusion matrix plot
#'
#' This function creates a confusion matrix plot and saves it to the specified file path.
#'
#' @param conf_matrix_df A data frame or tibble containing the confusion matrix results. This would have columns "Prediction", "Truth" and "Freq".
#' @param output_path A character string specifying the file path to save the confusion matrix plot.
#'
#' @return A ggplot2 object displaying a tile heatmap of the confusion matrix.
#'
#' @export
#' 
#' @examples
#' # Example usage:
#' # Assuming you have a confusion matrix object from yardstick::conf_mat
#' cm_plot(cm, "confusion_matrix_plot.png")
#' 
cm_plot <- function(conf_matrix_df, output_path) {
  
  if(!interactive()) pdf(NULL)
  
  output_plot <- ggplot2::ggplot(
    conf_matrix_df,
    ggplot2::aes(
      x = Prediction,
      y = Truth,
      fill = Freq
    )
  ) +
    ggplot2::geom_tile() +
    ggplot2::geom_text(
      ggplot2::aes(label = Freq),
      size = 5,
      color = "black"
    ) +
    ggplot2::scale_fill_gradient(low = "white", high = "blue") +
    ggplot2::labs(
      x = "Predicted Class",
      y = "True Class",
      fill = "Count"
    ) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold"),
      plot.subtitle = ggplot2::element_text(size = 12),
      axis.title = ggplot2::element_text(size = 12),
      axis.text = ggplot2::element_text(size = 10),
      plot.background = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    ) +
    ggplot2::guides(fill = "none")
  
  ggplot2::ggsave(output_path, output_plot, width = 8, height = 8, dpi = 300, limitsize = FALSE)
  
  return(output_plot)
}


