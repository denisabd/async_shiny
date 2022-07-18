library(echarts4r)
library(tidyverse)

plot_bar <- function(df) {
  
  measure <- df %>%
    dplyr::ungroup() %>%
    dplyr::select_if(is.numeric) %>%
    names()
  
  dimensions <- df %>%
    dplyr::ungroup() %>%
    dplyr::select(where(is.character), where(is.factor)) %>%
    names()
  
  if (length(measure) != 1) stop("Please supply a dataset with one measure")
  
  plot <- df %>%
    echarts4r::e_charts_(dimensions[1]) %>%
    echarts4r::e_bar_(measure) %>%
    echarts4r::e_tooltip() %>%
    echarts4r::e_labels() %>%
    echarts4r::e_x_axis(
      axisLabel = list(
        interval = 0,
        rotate = 45,
        width = 80,
        overflow = "truncate"
      )
    )
  
  return(plot)
}

plot_pie <- function(df) {
  
  measure <- df %>%
    dplyr::ungroup() %>%
    dplyr::select_if(is.numeric) %>%
    names()
  
  dimensions <- df %>%
    dplyr::ungroup() %>%
    dplyr::select(where(is.character), where(is.factor)) %>%
    names()
  
  if (length(measure) != 1) stop("Please supply a dataset with one measure")
  
  plot <- df %>%
    echarts4r::e_charts_(dimensions[1]) %>%
    echarts4r::e_pie_(measure, radius = c("40%", "70%")) %>%
    echarts4r::e_tooltip() %>%
    echarts4r::e_labels(
      show = TRUE,
      formatter = "{c}",
      position = "inside"
    )
  
  return(plot)
}

