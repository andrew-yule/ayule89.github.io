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

# Helper function for getting IPA and Ales
getIPAsAndAles = function(state = "All"){
  ipa = filterData(state) |>
    filter(!is.na(ABV) & !is.na(IBU)) |>
    filter(str_detect(Style, "(?:IPA|India.*Pale.*Ale)")) |>
    select(ABV, IBU) |>
    mutate(Style = "IPA")
  
  ales = filterData(state) |>
    filter(!is.na(ABV) & !is.na(IBU)) |>
    anti_join(ipa) |>
    filter(str_detect(Style, "Ale")) |>
    select(ABV, IBU) |>
    mutate(Style = "Ale")
  
  ipaAndAles = full_join(ipa, ales)  
}

# Helper function for creating the ggplot object to be displayed by renderPlot
createDistributionPlot = function(var = "IBU", histOrBox = "Histogram", binCount = 30, state = "All"){
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

# Helper function for creating the ggplot object to be displayed by renderPlot
createScatterPlot = function(state = "All", includeTrendLineQ = "True"){
  plot = if(includeTrendLineQ == "True") {
    ggplot(filterData(state), aes(x = IBU, y = ABV)) +
      geom_point(fill = "#C80F2D") + 
      geom_smooth(method = "lm") +
      labs(title = "Relationship Between IBU and ABV")
  } else {
      ggplot(filterData(state), aes(x = IBU, y = ABV)) +
        geom_point(fill = "#C80F2D") +
      labs(title = "Relationship Between IBU and ABV")
    }
  
  return(plot)
}

# Helper function for creating the ggplot object to be displayed by renderPlot
createIPAPlot = function(state = "All"){
  data = getIPAsAndAles(state)
  plot = data |>
    ggplot(aes(x = IBU, y = ABV, color = Style)) +
    geom_point(size = 3) +
    labs(x = "IBU", y = "ABV (%)", title = "Relationship Between IBU and ABV", subtitle = "Broken Down By IPA's and Ale's")
  
  return(plot)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$plot = renderPlot({createDistributionPlot(input$uiIBUOrABV, input$uiHistOrBox, input$uiBins, input$uiState)})
  output$plot2 = renderPlot({createScatterPlot(input$uiState, input$uiIncludeTrendLineQ)})
  output$plot3 = renderPlot({createIPAPlot(input$uiState)})
})
