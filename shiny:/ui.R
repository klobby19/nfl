require(tidyverse)
require(shiny)
require(ggplot2)
require(plotly)
require(viridis)
require(hrbrthemes)
require(gtools)
require(shinythemes)
require(shinyWidgets)
require(shinymaterial)
require(DT)

team_input <- selectInput(
  inputId = "team_input",
  choices = sort(unique(teamanno$team_name)),
  label = "Select Team"
)

player_input <- selectInput(
  inputId = "player_input",
  choices = "",
  label = "Select Player"
)

variable_input <- selectInput(
  inputId = "variable_input",
  choices = "",
  label = "Select Stat"
)

go_input <- actionButton(
  inputId = "go_input",
  label = "GO!"
)

qb_input <- selectInput(
  inputId = "qb_input",
  choices = sort(unique(qbstat$name)),
  label = "Select QB"
)

page_one <- tabPanel(
  "Introduction"
)

page_two <- tabPanel(
  "Stuff",
  style = "margin-top: -20px",
  titlePanel("Stuff"),
  sidebarLayout(
    sidebarPanel(style = "margin-top: 10px",
                 team_input,
                 player_input,
                 variable_input,
                 go_input
    ),
    
    mainPanel(style = "margin-top: 10px",
              wellPanel(style = "padding: 6px",
                        plotlyOutput("simpleplot")
              )
    )
  )
)

page_three <- tabPanel(
  "QB Dashboard",
  style = "margin-top: -20px",
  titlePanel("2020 Overview"),
  column(2, 
         wellPanel(style = "margin-top: 10px",
                   uiOutput("headshot"),
                   qb_input
         )
  ),
  column(7,
         wellPanel(style = "margin-top: 10px",
                   wellPanel(style = "padding: 6px",
                             plotlyOutput("pressureplot")
                   ),
                   wellPanel(style = "padding: 6px",
                             plotlyOutput("epaplay")
                   )
         )
  )
  
  
)

ui <- fluidPage(
  navbarPage(
    page_one,
    page_two,
    page_three
  )
)