require(shiny)

server <- source("server.R")
ui <- source("ui.R")

shinyApp(ui = ui, server = server)