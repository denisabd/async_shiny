library(shiny)
library(tidyverse)
library(future)
library(promises)
library(shinycssloaders)
library(echarts4r)

# creating a cluster of four workers
plan(multisession, workers = 4)

# For standard module
#source("module_async.R")
source("module_test.R")
source("functions.R")

data("txhousing")

df <- txhousing %>%
  group_by(city) %>%
  summarise(sales = sum(sales, na.rm = TRUE)) %>%
  arrange(desc(sales)) %>%
  slice(1:8)

ui <- fluidPage(
  h3("Plot Studio"),
  p("Application deliberately uses a 5 second timeout for plotting the first plot to demonstrate both cross-session and intra-session asyncronity. Notice that the simple iris plot is rendered right away, while the echarts object is still rendering."),
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