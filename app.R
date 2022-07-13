library(shiny)
library(tidyverse)
library(future)
library(promises)
library(shinycssloaders)

# plan(multisession, workers = 2)
plan(sequential)

# For standard module
source("module.R")
source("functions.R")

data("txhousing")

df <- txhousing %>%
  group_by(city) %>%
  summarise(sales = sum(sales, na.rm = TRUE)) %>%
  arrange(desc(sales)) %>%
  slice(1:8)

ui <- fluidPage(
  h3("Plot Studio"),
  plotUI("main")
)

server <- function(input, output, session) {
  plotServer("main", reactive(df))
}

shinyApp(ui, server)