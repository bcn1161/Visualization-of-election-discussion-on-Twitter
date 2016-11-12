library(shiny)
library(plotly)
library(markdown)

setwd("~/Desktop/visualization_proj")
td <- read.csv("IV.csv")

shinyUI(
  navbarPage(strong("Interactive Plots of Descriptive Variables in Tweets"),

tabPanel("Daily Tweet Volumes",
  sidebarPanel(selectInput("select1", label = "Choose a candidate:",
                c("Clinton", "Sanders", "Cruz", "Trump"))
  ),
  mainPanel(
    plotlyOutput("trendPlot1")
  )
),

tabPanel("Daily Tweet Proportions",
sidebarPanel(selectInput("select2", label = "Choose a candidate:",
                         c("Clinton", "Sanders", "Cruz", "Trump"))
),
mainPanel(
  plotlyOutput("trendPlot2")
)
),

tabPanel("Positive Tweets Relative Proportions",
         sidebarPanel(selectInput("select3", label = "Choose a candidate:",
                                  c("Clinton", "Sanders", "Cruz", "Trump"))
         ),
         mainPanel(
           plotlyOutput("trendPlot3")
         )
),

tabPanel("Daily Retweet Numbers",
         sidebarPanel(selectInput("select4", label = "Choose a candidate:",
                                  c("Clinton", "Sanders", "Cruz", "Trump"))
         ),
         mainPanel(
           plotlyOutput("trendPlot4")
         )
)
))