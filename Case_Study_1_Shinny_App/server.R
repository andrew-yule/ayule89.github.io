#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)

# Set the theme
theme_set(theme_bw())

# Load the beers data set
beers = read_csv("https://www.wolframcloud.com/obj/andrew.yule/DDS_Beers")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$hist <- renderPlot({
    # Draw the histogram with the specified number of bins based on user's preference for IBU or ABV
    # plot = beers |>
    #   ggplot(aes(x = ABV)) +
    #   geom_histogram(fill = "#C80F2D", bins = input$uiBins) +
    #   labs(x = "ABV (%)", y = "Frequency", title = "Distribution of ABV Values Across Beers") +
    #   theme(text=element_text(size=18))
    print(input$uiIBUOrABV)
    plot = if(input$uiIBUOrABV == "IBU") {
      ggplot(beers, aes(x = IBU)) +
        geom_histogram(fill = "#C80F2D", bins = input$uiBins) +
        labs(x = "IBU (-)", y = "Frequency", title = "Distribution of IBU Values Across Beers") +
        theme(text=element_text(size=18))
      } else {
        ggplot(beers, aes(x = ABV)) +
          geom_histogram(fill = "#C80F2D", bins = input$uiBins) +
          labs(x = "ABV (%)", y = "Frequency", title = "Distribution of ABV Values Across Beers") +
          theme(text=element_text(size=18))
      }
    plot
  })
})
