#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Beer Data Analysis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          radioButtons("uiIBUOrABV", "IBU or ABV:", choices = c("IBU", "ABV"), inline = TRUE),
          radioButtons("uiHistOrBox", "Histogram or BoxPlot:", choices = c("Histogram", "BoxPlot"), inline = TRUE),
          sliderInput("uiBins", "Number of bins:", min = 1, max = 50, value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(plotOutput("plot"))
    )
))
