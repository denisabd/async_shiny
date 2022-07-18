plotUI <- function(id) {
  ns <- NS(id)
  fluidRow(
    column(width = 10,
           echarts4r::echarts4rOutput(ns("plot")) %>%
             shinycssloaders::withSpinner()
    ),
    column(width = 2,
           actionButton(
             inputId = ns("bar"),
             label = "",
             icon = icon("chart-bar")
           ),
           actionButton(
             inputId = ns("pie"),
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
      
      # Setting reactiveValues for changing plot types
      rv <- reactiveValues(
        plot_type = "bar",
        plot = NULL
      )
      
      # Observer and main calculation
      observeEvent(c(df(), rv$plot_type),{
        
        # We can't use reactives inside of future
        plot_type <- rv$plot_type
        df <- df()
        
        promises::future_promise({
          
          # Timeout to show asyncronity
          Sys.sleep(5)
          
          if (plot_type == "bar") {
            df %>%
              plot_bar()
          } else {
            df %>%
              plot_pie()
          }
        }) %...>%
          (
            function(result){
              rv$plot <- result
            }
          ) %...!% (
            function(error){
              rv$plot <- NULL
              print("Plot Error")
              print(error)
            }
          )
        # hacking intra-session asyncronity
        print(class(rv$plot))
      })
      
      # Observers for actionButtion clicks
      observeEvent(input$bar, {
        rv$plot_type <- "bar"
      })
      
      observeEvent(input$pie,{
        rv$plot_type <- "pie"
      })
      
      # Render Plots
      output$plot <- echarts4r::renderEcharts4r({
        req(rv$plot)
      })
      
    }
  )
}