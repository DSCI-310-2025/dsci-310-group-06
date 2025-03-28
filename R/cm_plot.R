# R/cm_plot.R
install.packages("caret")
library(ggplot2)
library(caret)

# Function to plot a confusion matrix
cm_plot <- function(conf_matrix) {
  cm_df <- as.data.frame(conf_matrix$table)
  
  p <- ggplot(cm_df, aes(x = Prediction, y = Reference, fill = Freq)) +
    geom_tile() +
    geom_text(aes(label = Freq), size = 10, color = "black") +
    scale_fill_gradient(low = "white", high = "blue") +
    labs(title = "Confusion Matrix") +
    theme_minimal() +
    theme(
      axis.text = element_text(size = 15),
      axis.title = element_text(size = 20)
    )
  
  return(p)
}
