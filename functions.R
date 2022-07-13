library(echarts4r)
library(tidyverse)

data("EuStockMarkets")
data("txhousing")


df <- txhousing %>%
  group_by(city) %>%
  summarise(sales = sum(sales, na.rm = TRUE))


plot_bar <- function(df, sort = FALSE, sort_type = "desc") {
  
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
    echarts4r::e_tooltip()
  
  return(plot)
}

plot_bar(df)
