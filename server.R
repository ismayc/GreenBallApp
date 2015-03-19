library(shiny)
library(ggplot2)

inputFile <- "gb200x100000.txt"
con  <- file(inputFile, open = "r")

dataList <- list()

while (length(oneLine <- readLines(con, n = 1, warn = FALSE)) > 0) {
  myVector <- (strsplit(oneLine, " "))
  myVector <- list(as.numeric(myVector[[1]]))
  dataList <- c(dataList,myVector)
} 

close(con)

gbPlot <- function(n){
  #range <- 0:n
  range <- ( min(which(dataList[[n]] > 0))) : ( max(which(dataList[[n]] > 0)))
  support <- range - 1
  xlabel <- "\n Green Balls Drawn"
  mainLabel <- "Green Ball Probability Mass Function"
  
  q <- qplot(factor(support),
             #dataList[[n]],
             dataList[[n]][range],
             xlab = xlabel,
             ylab = "Probability",
             main = paste(mainLabel, "\n"),
             geom = "bar", 
             stat = "identity")
  q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
  #ifelse(length(range) > 25, q + theme(axis.text.x = element_text(angle = 90, hjust = 1)), q)
}
#manipulate( gbPlot(n), n = slider(1,200))



# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$distPlot <- renderPlot({
    gbPlot(input$draws)
  })
  
  #\\mu = \\mathbb{E}(X)
  output$mean <- renderUI({
    withMathJax(sprintf("$$Mean(X) = %.03f$$",
                        0:input$draws %*% dataList[[input$draws]]
    ))
  })
  
  #\\sigma = \\sqrt{\\mathbb{V}(X)}
  output$var <- renderUI({
    withMathJax(sprintf("$$SD(X) = %.03f$$",
                        sqrt((0:input$draws)^2 %*% dataList[[input$draws]] - (0:input$draws %*% dataList[[input$draws]])^2)
    ))
  })
  
  #\\gamma_1 = \\frac{\\mathbb{E}(X^3) - 3\\mu\\sigma^2 - \\mu^3}{\\sigma^3}
  output$skew <- renderUI({
    withMathJax(sprintf("$$Skew(X)  = %.03f$$",
                        ( ((0:input$draws)^3 %*% dataList[[input$draws]]) - 3*(0:input$draws %*% dataList[[input$draws]])*((0:input$draws)^2 %*% dataList[[input$draws]] - (0:input$draws %*% dataList[[input$draws]])^2) - (0:input$draws %*% dataList[[input$draws]])^3  )/(sqrt((0:input$draws)^2 %*% dataList[[input$draws]] - (0:input$draws %*% dataList[[input$draws]])^2))^3
    ))
  })

})