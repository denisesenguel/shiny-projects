
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
shinyUI <- shinyUI(fluidPage(

  # Application title
  titlePanel("Tweets that used #presidentialdebate"),

  # show map plot in the first row
  fluidRow(plotOutput("mapPlot")),
  
  # show centered slider in the bottom (second row) to set the time
  fluidRow(align = "center",
    sliderInput("time",
                "Select a day",
                min = as.Date(min(tweetsClean$created_at)),
                max = as.Date(max(tweetsClean$created_at)),
                value = as.Date(min(tweetsClean$created_at)),
                animate = animationOptions())
                )

))
