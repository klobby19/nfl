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
require(XML)
require(RCurl)
require(rlist)
require(textreadr)
require(rvest)
require(xml2)
require(fmsb)

pbp_2020 <- read.csv("../raw:/data:/pbp2020.csv")

qbstat <- read.csv("../raw:/data:/qbadvstats2020.csv")

qbstat$Drop. <- as.numeric(gsub("[\\%,]", "", qbstat$Drop.)) / 100

qbstat$OnTgt. <- as.numeric(gsub("[\\%,]", "", qbstat$OnTgt.)) / 100

qbstat$Prss. <- as.numeric(gsub("[\\%,]", "", qbstat$Prss.)) / 100

qbstat$Bad. <- as.numeric(gsub("[\\%,]", "", qbstat$Bad.)) / 100

qbstats <- qbstat

qbstats <- rbind(qbstats,apply(qbstat,2,min))

qbstats[nrow(qbstats),]["name"] <- "min"

qbstats <- rbind(qbstats,apply(qbstat,2,max))

qbstats[nrow(qbstats),]["name"] <- "max"

rowmean <- colMeans(sapply(qbstat, as.numeric))

qbstats <- rbind(qbstats, rowmean)

qbstats[nrow(qbstats),]["name"] <- "mean"

teamcurr <- read.csv("../raw:/data:/teamanno.csv")

teamanno <- read.csv("../raw:/data:/nfl_teams.csv") %>% 
  mutate(teamlower = str_to_lower(team_id_pfr))

teamanno <- teamanno %>% filter(team_name %in% teamcurr$Name)

get_team_roster <- function(team) {
  team <- teamanno %>%
    filter(team_name == team) %>%
    pull(teamlower)
  
  url <- sprintf("https://www.pro-football-reference.com/teams/%s/2020_roster.htm", team)
  
  html <- read_html(url)
  
  node_list <- html %>%
    html_nodes("#all_games_played_team") %>%
    html_nodes(xpath = "comment()") %>%
    html_text() %>%
    read_html() %>%
    html_nodes("tr") %>%
    html_nodes("a")
  
  players <- c()
  
  short <- "https://www.pro-football-reference.com"
  
  for (node in node_list) {
    node <- toString(node)
    if (str_detect(node, "players")) {
      player <- str_split(str_split(gsub('"', "", node), "=", simplify = TRUE)[,2], ">", simplify = TRUE)
      
      player_url <- player[1,1]
      player_name <- trimws(str_split(player[,2], "<", simplify = TRUE))[1,1]
      players[[player_name]] <- str_c(short, player_url)
    }
  }
  
  players
}

get_player_table <- function(player) {
  
  html <- read_html(currteam[player][[1]])
  
  table <- html %>%
    html_table() %>%
    as.data.frame(skip = 2, header = FALSE)
  
  print(table)
  
  names(table) <- table[1,]
  
  table <- table[-1,]
  
  print(names(table))
  
  table
}

server <- function(input, output, session) {
  
  observeEvent(input$team_input, {
    req(input$team_input)
    currteam <<- get_team_roster(input$team_input)
    
    updateSelectInput(session, 
                      "player_input", 
                      choices = names(currteam)
    )
    
  })
  
  observeEvent(input$player_input, {
    req(input$player_input)
    currplayer <<- get_player_table(input$player_input)
    
    updateSelectInput(session, 
                      "variable_input", 
                      choices = names(currplayer)
    ) 
  })
  
  observeEvent(input$go_input, {
    output$simpleplot <- renderPlotly({
      plot <- currplayer %>%
        ggplot() +
        geom_bar(aes_string(x = 'Year', y = input$variable_input), stat = "identity")
      ggplotly(plot)
    })
  })
  
  output$pressureplot <- renderPlotly({
    
    pressure_summary <- qbstats %>% 
      tail(3)
      
    player_stat <- qbstats %>% 
      filter(name == input$qb_input)
    
    pressure_summary <- pressure_summary[c(2, 29:37)] 
    
    player_stat <- player_stat[c(2, 29:37)]
    
    pressure_df <- rbind(player_stat, pressure_summary)
    
    plot <- ggplot() +
      geom_histogram(qbstat, mapping = aes(x = PktTime))
    plot <- plot + geom_vline(yintercept = as.numeric(player_stat$PktTime))
    
    ggplotly(plot)
  })
  
  output$epaplay <- renderPlotly({
    qb_strings <- str_split(input$qb_input, " ")
    
    qb <- str_c(str_sub(qb_strings[[1]][1], start = 1, end = 1), ".",qb_strings[[1]][2])
    
    player_stat <- pbp_2020 %>% 
      filter(passer_player_name == qb) %>% 
      group_by(week) %>% 
      summarize(epa = mean(qb_epa, na.rm = T))
    
    league_stat <- pbp_2020 %>% 
      group_by(week) %>% 
      summarize(epa = mean(qb_epa, na.rm = T))
    
    plot <- ggplot() +
      geom_line(player_stat, mapping = aes(x = week, y = epa)) +
      geom_line(league_stat, mapping = aes(x = week, y = epa), linetype = "dashed")
    
    ggplotly(plot)
  })

  output$headshot <- renderUI({
    
    html <- qbstat %>% 
      filter(name == input$qb_input) %>% 
      pull(url) %>% 
      read_html()
    
    imgurl <- html %>%
      html_nodes(xpath = '//*[@class="media-item"]') %>% 
      html_nodes("img") %>%
      html_attr("src")
    
    tags$img(src = imgurl, width = 150)
  })
}