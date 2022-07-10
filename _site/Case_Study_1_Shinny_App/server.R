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
#theme_set(theme_bw())
theme_set(theme_bw(base_size = 18))
#theme_set(element_text(size=18))

# Load the beers data set
beers = read_csv("https://raw.githubusercontent.com/ayule89/ayule89.github.io/master/Data/beers.csv")

# Helper function for filtering the beers dataset by State
filterData = function(state = "All"){
  if(state == "All") {
    return(beers)
  } else {
    return(beers |> filter(State == state))
  }
}

# Helper function for creating the ggplot object to be displayed by renderPlot
createPlot = function(var = "IBU", histOrBox = "Histogram", binCount = 30, state = "All"){
  plot = if(var == "IBU" && histOrBox == "Histogram") {
    ggplot(filterData(state), aes(x = IBU)) +
      geom_histogram(fill = "#C80F2D", bins = binCount) +
      labs(title = "Distribution of IBU Values Across Beers")
  } else if(var == "IBU" && histOrBox == "BoxPlot"){
    ggplot(filterData(state), aes(y = IBU)) +
      geom_boxplot(fill = "#C80F2D") +
      labs(title = "Distribution of IBU Values Across Beers")
  } else if(var == "ABV" && histOrBox == "Histogram") {
    ggplot(filterData(state), aes(x = ABV)) +
      geom_histogram(fill = "#C80F2D", bins = binCount) +
      labs(title = "Distribution of ABV Values Across Beers")
  } else if(var == "ABV" && histOrBox == "BoxPlot"){
    ggplot(filterData(state), aes(y = ABV)) +
      geom_boxplot(fill = "#C80F2D") +
      labs(title = "Distribution of ABV Values Across Beers")
  }
  
  return(plot)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$plot <- renderPlot({
    # Draw the histogram with the specified number of bins based on user's preference for IBU or ABV
    plot = createPlot(input$uiIBUOrABV, input$uiHistOrBox, input$uiBins, input$uiState)
    plot
  })
})
