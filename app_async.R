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