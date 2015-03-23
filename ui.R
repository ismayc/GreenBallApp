library(shiny)

shinyUI(fluidPage(
  
  # Application title
  headerPanel(""),
  
  mainPanel(
    withMathJax(),
    numericInput("draws", 
                 "Number of draws:", 
                 min = 1,
                 max = 573, 
                 value = 1),
    plotOutput("distPlot"),
    uiOutput("mean"),
    uiOutput("var"),
    uiOutput("skew")
  )
))
