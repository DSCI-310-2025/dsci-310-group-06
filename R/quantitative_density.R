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

quantitative_density <- function(data_frame, noncat_vars, target_col, title_size = 35, axis_size = 30) {
  density_plots <- list()

  # 1. Check that target_col is in data
  if (!target_col %in% colnames(data)) {
    stop(sprintf("Target column '%s' not found in data.", target_col))
  }
  
  # 2. Check that all noncat_vars are in data
  missing_vars <- setdiff(noncat_vars, colnames(data))
  if (length(missing_vars) > 0) {
    stop(sprintf("The following vars are missing in data: %s", 
                 paste(missing_vars, collapse = ", ")))
  }
  
  # 3. Check that noncat_vars are numeric
  non_numeric <- noncat_vars[!sapply(data[noncat_vars], is.numeric)]
  if (length(non_numeric) > 0) {
    stop(sprintf("The following vars are not numeric: %s", 
                 paste(non_numeric, collapse = ", ")))
  }
  
  # 4. (Optional) If you want to disallow data frames w/ zero columns:
  if (ncol(data) == 0) {
    stop("Data frame has no columns. Cannot plot an empty dataset.")
  }
  
  # ...then proceed with your ggplot loop
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
