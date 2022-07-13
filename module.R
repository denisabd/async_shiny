plotUI <- function(id) {
  ns <- NS(id)
  fluidRow(
    column(width = 10,
           echarts4r::echarts4rOutput(ns("plot")) %>%
             shinycssloaders::withSpinner()
    ),
    column(width = 2,
           actionButton(
             inputId = "bar",
             label = "",
             icon = icon("chart-bar")
           ),
           actionButton(
             inputId = "pie",
             label = "",
             icon = icon("chart-pie")
           )
    )
  )
  
}

plotServer <- function(id, df) {
  moduleServer(
    id,
    function(input, output, session) {
      
      
      output$plot <- echarts4r::renderEcharts4r({
        df() %>%
          plot_bar()
      })
    }
  )
}