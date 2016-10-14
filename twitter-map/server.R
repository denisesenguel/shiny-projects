
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# get map info
data("countryExData", envir = environment(), package = "rworldmap")
mymap <- joinCountryData2Map(countryExData, 
                             joinCode = "ISO3", nameJoinColumn = "ISO3V10", mapResolution = "low")
mymap <- fortify(mymap) 

shinyServer <- function(input, output) {

  output$mapPlot <- renderPlot({

    # get data based on input$time:
    # mit dem date gibts noch ein problem!!
    # wie kann man das wieder zurück konvertieren? oder einfach die lhs konvertieren?
    dataSub <- dplyr::filter(tweetsClean, created_at == input$time)
    
    # draw plot
    ggplot() + 
      coord_map(xlim = c(-180, 180), ylim = c(-60, 85)) +
      geom_polygon(data = mymap, aes(long, lat, group = group), 
                   color = "grey75", fill = "grey70", size = 0.3) +
      geom_point(data = dataSub, aes(x = place_lon, y = place_lat, 
                                         alpha = retweet_count, size = retweet_count), 
                 color = "#009999") + 
      theme_void() + 
      theme(legend.position = "none")

  })

}

shinyApp(ui = shinyUI, server = shinyServer)
