rm(list = ls())
library(shiny)
library(data.table)
library(dplyr)
library(rworldmap)

# import data

  #resettleData <- fread("data/resettlement_allyears.csv", header = T, na.strings = "*")  
  # funktioniert nicht da immer die strings wo ein leerzeichen drin ist quotes drumrum haben
  # der rest aber nicht. vielleicht mit read.csv und dann quotes = c("", "\"")?

  asylumData <- fread("data/asylum_seekers_monthly_allyears.csv", header = T, na.strings = "*")
  colnames(asylumData)[1] <- "Country"
  # have to change some country names
  # what is the difference between the two USA entries?
  asylumData$Country[grepl("+United Kingdom", asylumData$Country)] <- "United Kingdom"
  asylumData$Country[grepl("Macedonia", asylumData$Country)] <- "Macedonia"
  asylumData$Country[grepl("Serbia", asylumData$Country)] <- "Serbia and Kosovo"
  # next: merge country population
  # find out how to map country data using rworldmap
  
# summarize by year and country (only for basic viz)
  asylumSumData <- asylumData %>%
    group_by(Country, Year) %>%
    dplyr::summarise(Total = sum(Value)) %>%
    arrange(Country, Year)
    
# Define the UI 
  shinyUI <- fluidPage(
    
    titlePanel("Total Asylum Seekers by Year and Country"),
    sidebarPanel(selectInput("Country", "Choose a country:", 
                             choices = unique(asylumSumData$Country))),
    plotOutput("basicPlot")
  )
  
# Define shiny server code
  shinyServer <- function(input, output) {
    output$basicPlot <- renderPlot({
      plot(subset(asylumSumData, Country == input$Country)$Year, 
           subset(asylumSumData, Country == input$Country)$Total, type = "p",
           xlab = "Years", ylab = "Total Number of Asylum Seekers", main = "Basic Plot")
      })
  }
  
# Return shiny app object
  shinyApp(ui = shinyUI, server = shinyServer)

