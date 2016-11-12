library(shiny)
library(plotly)
library(rsconnect)
setwd("~/Desktop/visualization_proj")
td <- read.csv("IV.csv")

shinyServer(function(input, output) {
 
  
  output$trendPlot1 <- renderPlotly({
      if (input$select1 == "Clinton") {
      p <- plot_ly(td, x = clin_vol, y = clinton, text = paste("Volume", clin_vol), mode = "markers", color = clin_vol, size = clin_vol)
      }
      if (input$select1 == "Sanders") {
      p <- plot_ly(td, x = san_vol, y = sanders, text = paste("Volume", san_vol), mode = "markers", color = san_vol, size = san_vol)
      }
    if (input$select1 == "Cruz") {
      p <- plot_ly(td, x = cruz_vol, y = cruz, text = paste("Volume", cruz_vol), mode = "markers", color = cruz_vol, size = cruz_vol)
    }
    if (input$select1 == "Trump") {
      p <- plot_ly(td, x = trump_vol, y = trump, text = paste("Volume", trump_vol), mode = "markers", color = trump_vol, size = trump_vol)
    }
      print(p)
      })
  
  output$trendPlot2 <- renderPlotly({
    if (input$select2 == "Clinton") {
      p <- plot_ly(td, x = clin_pro, y = clinton, text = paste("Volume", clin_vol), mode = "markers", color = clin_vol, size = clin_vol)
    }
    if (input$select2 == "Sanders") {
      p <- plot_ly(td, x = san_pro, y = sanders, text = paste("Volume", san_vol), mode = "markers", color = san_vol, size = san_vol)
    }
    if (input$select2 == "Cruz") {
      p <- plot_ly(td, x = cruz_pro, y = cruz, text = paste("Volume", cruz_vol), mode = "markers", color = cruz_vol, size = cruz_vol)
    }
    if (input$select2 == "Trump") {
      p <- plot_ly(td, x = trump_pro, y = trump, text = paste("Volume", trump_vol), mode = "markers", color = trump_vol, size = trump_vol)
    }
    print(p)
  })
  
  output$trendPlot3 <- renderPlotly({
    if (input$select3 == "Clinton") {
      p <- plot_ly(td, x = clin_pospro, y = clinton, text = paste("Volume", clin_vol), mode = "markers", color = clin_vol, size = clin_vol)
    }
    if (input$select3 == "Sanders") {
      p <- plot_ly(td, x = san_pospro, y = sanders, text = paste("Volume", san_vol), mode = "markers", color = san_vol, size = san_vol)
    }
    if (input$select3 == "Cruz") {
      p <- plot_ly(td, x = cruz_pospro, y = cruz, text = paste("Volume", cruz_vol), mode = "markers", color = cruz_vol, size = cruz_vol)
    }
    if (input$select3 == "Trump") {
      p <- plot_ly(td, x = trump_pospro, y = trump, text = paste("Volume", trump_vol), mode = "markers", color = trump_vol, size = trump_vol)
    }
    print(p)
  })
  
  output$trendPlot4 <- renderPlotly({
    if (input$select4 == "Clinton") {
      p <- plot_ly(td, x = clin_re, y = clinton, text = paste("Retweet", clin_re), mode = "markers", color = clin_re, size = clin_re)
    }
    if (input$select4 == "Sanders") {
      p <- plot_ly(td, x = san_re, y = sanders, text = paste("Retweet", san_re), mode = "markers", color = san_re, size = san_re)
    }
    if (input$select4 == "Cruz") {
      p <- plot_ly(td, x = cruz_re, y = cruz, text = paste("Retweet", cruz_re), mode = "markers", color = cruz_re, size = cruz_re)
    }
    if (input$select4 == "Trump") {
      p <- plot_ly(td, x = trump_re, y = trump, text = paste("Retweet", trump_re), mode = "markers", color = trump_re, size = trump_re)
    }
    print(p)
  })
  
})