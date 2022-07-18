# libraries -------------------------------------------------------------------
library(shiny)
library(tidyverse)
library(future)
library(promises)
library(shinycssloaders)
library(echarts4r)


# plotting functions ------------------------------------------------------
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


# modules -----------------------------------------------------------------
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

# creating a cluster of four workers
plan(multisession, workers = 4)

data("txhousing")

df <- txhousing %>%
  group_by(city) %>%
  summarise(sales = sum(sales, na.rm = TRUE)) %>%
  arrange(desc(sales)) %>%
  slice(1:8)


# app ---------------------------------------------------------------------
ui <- fluidPage(
  h3("Plot Studio"),
  plotUI("main"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  
  plotServer("main", reactive(df))
  
  output$plot <- renderPlot({
    plot(iris)
  })
}

shinyApp(ui, server)

