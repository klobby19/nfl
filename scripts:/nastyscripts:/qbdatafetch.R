require(tidyverse)
require(nflfastR)

all_qbs <- read_html(
  "https://www.pro-football-reference.com/years/2020/passing.htm"
) %>%
  html_nodes("#div_passing") %>% 
  html_nodes("tr") %>%
  html_nodes("a")

players <- c()

short <- "https://www.pro-football-reference.com"

for (node in all_qbs) {
  node <- toString(node)
  if (str_detect(node, "players")) {
    player <- str_split(str_split(gsub('"', "", node), "=", simplify = TRUE)[,2], ">", simplify = TRUE)
    
    player_url <- player[1,1] 
    player_name <- trimws(str_split(player[,2], "<", simplify = TRUE))[1,1]
    players[[player_name]] <- str_c(short, player_url)
  }
}

full_qbs <- read_html(
  "https://www.pro-football-reference.com/years/2020/passing.htm"
) %>% html_table() %>% as.data.frame() %>% 
  filter(!is.numeric(Age)) 

full_qbs$Player <- trimws(gsub("([.-])|[[:punct:]]", "\\1", full_qbs$Player))

players <- players %>% as.data.frame() %>% gather()

players <- players %>% rename("Player" = "key", "url" = "value")

players$Player <- trimws(str_replace(players$Player, "\\.", " "))

joined_qbs <- full_join(players, full_qbs, by = "Player")

list_qb <- joined_qbs %>%
  filter(as.numeric(Att) >= 150 & !is.na(url))

qb_adv_stats <- c()

qb_adv_stats2020 <- data.frame()

html <- read_html("https://www.pro-football-reference.com/players/R/RyanMa00.htm")

table <- html %>% 
  html_table

table <- as.data.frame(table[2:5])

table <- table[, -c(66:71)]

table[1, "PlayAction"] <- "papassatt"
table[1, "PlayAction.1"] <- "papassyds"

names(table) <- table[1,]

table <- table[-1,]

unique_cols <- unique(names(as.list(table)))

for (qb in list_qb$Player) {
  url <- list_qb %>% 
    filter(Player == qb) %>% 
    pull(url)
  
  print(url)
  
  html <- read_html(url)
  
  table <- html %>% 
    html_table
  
  table <- as.data.frame(table[2:5])
  
  table <- table[, -c(66:71)]
  
  table[1, "PlayAction"] <- "papassatt"
  table[1, "PlayAction.1"] <- "papassyds"
  
  names(table) <- table[1,]
  
  table <- table[-1,]
  
  table <- table[unique_cols]
  
  table$Year <- as.numeric(trimws(gsub("([.-])|[[:punct:]]", "\\1", table$Year)))
  
  qb_adv_stats[[qb]] <- table
  
  table <- table %>% 
    mutate(name = qb)
  
  row <- table %>% 
    filter(Year == 2020)
  
  qb_adv_stats2020 <- bind_rows(qb_adv_stats2020, row)
}

qb_adv_stats2020 <- qb_adv_stats2020 %>% 
  select(Pos, everything())

qb_adv_stats2020 <- qb_adv_stats2020 %>% 
  select(Tm, everything())

qb_adv_stats2020 <- qb_adv_stats2020 %>% 
  select(name, everything())

qb_adv_stats2020 <- left_join(qb_adv_stats2020, players, by = c("name" = "Player"))

write.csv(qb_adv_stats2020, "qbadvstats2020.csv")

ids_2020 <- fast_scraper_schedules(2020) %>% 
  pull(game_id)

pbp_2020 <- build_nflfastR_pbp(ids_2020)

write.csv(pbp_2020, "pbp2020.csv")
