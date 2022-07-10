#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)

# Load the beers data set
beers = read_csv("https://raw.githubusercontent.com/ayule89/ayule89.github.io/master/Data/beers.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Beer Data Analysis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          selectInput("uiState", "Select state:", choices = add_row(arrange(unique(select(beers, State)), State), State = "All", .before = 1)),
          radioButtons("uiIBUOrABV", "IBU or ABV:", choices = c("IBU", "ABV"), inline = TRUE),
          radioButtons("uiHistOrBox", "Histogram or BoxPlot:", choices = c("Histogram", "BoxPlot"), inline = TRUE),
          sliderInput("uiBins", "Number of bins:", min = 1, max = 50, value = 30),
          radioButtons("uiIncludeTrendLineQ", "Include trend line on scatter plot:", choices = c("True", "False"), inline = TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("plot"),
          plotOutput("plot2"),
          plotOutput("plot3")
        )
    )
))
