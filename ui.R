
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(leaflet)
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("High Risk Intersections"),
  tags$div(tags$span("Analyse the top 100 most dangerous intersections on New Zealand roads.  The data is available from the NZTA website ")
          ,tags$a(href="http://www.nzta.govt.nz/resources/high-risk-intersections-guide/","here")),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("minorinjuries",
                  "Number of Minor Injuries:",
                  min = 0,
                  max = 50,
                  value = c(0,50))
    ,
    sliderInput("seriousinjuries",
                "Number of Serious Injuries:",
                min = 0,
                max = 20,
                value = c(0,20))
    ,sliderInput("fatalities",
                "Number of Fatalities:",
                min = 0,
                max = 5,
                value = c(0,5))
    ,fluidRow(
      leafletOutput("mymap")        
    )
  ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        
        tabPanel("Table",fluidRow(DT::dataTableOutput("intersections"))),
        tabPanel("Documentation",
        tags$p("Use the filters on the left hand side to find intersections that have different ranges of casualties and casualty severities (Minor, Serious or Fatal)."),
        tags$p("The data lists the top 100 most dangerous intersections on New Zealand Roads.  Each intersection has the following attributes.  The casualty data are the totals between 2003 and 2012."),
        tableOutput("explanation")
          )
      )
    )
  )
))
