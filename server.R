
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)


#get data
load("highriskintersections.RData")

#highrisk <- data.frame(lat = i$Latitude,lng = i$Longitude)
#i$popup <- paste(sep="","<b>",i$Crash.Road,", ",i$T.L.A...RCA.if.not.TLA.,"</b><br/>Intersection Rank: ",i$Rank,"<br/>Fatalaties:",i$Fatalities.2003.12,"<br/>Serious Injuries:",i$Serious.Injuries.2003.12,"<br/>Minor Injuries:",i$Minor.Injuries.2003.2012,"<br/>Total Injuries:",i$Total.Casualties.2003...2012,"<br/>")
#mymap <- highrisk %>% leaflet() %>% addTiles() %>% addMarkers(clusterOptions = markerClusterOptions(),popup=i$popup)
#mymap

attribute <- c("Rank","Area","Crash Road","Side Road"," Minor Injuries","Serious Injuries","Fatalities","Total Casualties")
description <- c("Unfilitered rank in the whole country"
                 ,"Geographic area of the intersection"
                 ,"Name of the road the crash occurred on"
                 ,"The significant other road on the intersection"
                 ,"Number of injuries that didn't require hospitalisation"
                 ,"Number of injuries that did require hospitalisation"
                 ,"Number of fatalities"
                 ,"Total count of people injuried or killed at the intersection")
explanation <- data.frame(attribute = attribute,description = description)


shinyServer(function(input, output) {

  fd <- reactive({
    
    filtereddata <-highriskintersections[ highriskintersections$Minor.Injuries>=input$minorinjuries[1] & highriskintersections$Minor.Injuries<=input$minorinjuries[2] ,] 
    filtereddata <-filtereddata[ filtereddata$Serious.Injuries>=input$seriousinjuries[1] & filtereddata$Serious.Injuries<=input$seriousinjuries[2] ,] 
    filtereddata <-filtereddata[ filtereddata$Fatalities>=input$fatalities[1] & filtereddata$Fatalities<=input$fatalities[2] ,]    
    
  })
  
  output$intersections <- DT::renderDataTable(DT::datatable({
    fd()[,1:8]
  },options = list(paging = FALSE,searching = FALSE)))

  
  output$mymap <- renderLeaflet({ 
    
    filtereddata <- fd()
    
    highrisk <- data.frame(lat = filtereddata$Latitude,lng = filtereddata$Longitude)
    
    highriskpopup <- paste(sep="","<b>",filtereddata$Crash.Road,", ",filtereddata$Area,"</b><br/>Intersection Rank: ",filtereddata$Rank,"<br/>Fatalaties:",filtereddata$Fatalities,"<br/>Serious Injuries:",filtereddata$Serious.Injuries,"<br/>Minor Injuries:",filtereddata$Minor.Injuries,"<br/>Total Injuries:",filtereddata$Total.Casualties,"<br/>")
    
    highrisk %>% leaflet() %>% addTiles() %>% addMarkers(clusterOptions = markerClusterOptions(),popup=highriskpopup)
    
    })
  
  output$explanation <- renderTable(explanation)
  
})


