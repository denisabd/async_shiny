# Async Shiny Module

Project to show the creation of a standard shiny module for plotting and converting it to fully async, basically achieving both **cross-session asyncronity** and **intra-session asyncronity** 


## Content
-   Plotting functions for bar and pie using the fabulous `echarts4r` package
-   A "simple" `shiny` module
-   Async shiny module


## About
Approach to creating the async shiny apps is described in *Engineering Production Grade Shiny Apps* book by [Colin Fay](https://github.com/ColinFay) - thanks Colin! Check out the [Asynchronous in {shiny}](https://engineering-shiny.org/optimizing-shiny-code.html?q=async#asynchronous-in-shiny) section that explains the use of `reactiveValues` use for building shiny apps.


Understanding [promises](https://rstudio.github.io/promises/) and [future](https://future.futureverse.org/) is quite useful for working with shiny and making parallel computations in R overall.

Here we build an **async shiny module** that won't block user session while calculating and can be then used in a scalable shiny web application.

## Live Version
App is deployed on [shinyapps.io](https://deny.shinyapps.io/async_shiny/)
