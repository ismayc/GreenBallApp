library(shiny)

# Define UI for application that plots random distributions 
shinyUI(fluidPage(
  #pageWithSidebar(
  
  # Application title
  headerPanel(""),
  
  # Show a plot of the generated distribution
  mainPanel(
    withMathJax(),
    numericInput("draws", 
                 "Number of draws:", 
                 min = 1,
                 max = 200, 
                 value = 1),
    plotOutput("distPlot"),
    uiOutput("mean"),
    uiOutput("var"),
    uiOutput("skew")
  )
))
