library(tidyverse)
library(plotly)
library(DBI)
library(RSQLite)
library(nflfastR)
library(ggimage)

score_df <- read.csv("../materials/Data/scoresspread.csv")
offense_df <- read.csv("../materials/Data/offensehistory.csv")

offense_df %>% 
  ggplot() +
  geom_line(aes(x = year, y = ptd)) +
  theme_minimal()

score_df %>% 
  group_by(schedule_season) %>% 
  summarize(prop = mean(favorite_cover == T)) %>% 
  ggplot() +
  geom_area(aes(schedule_season, y = prop), fill = "blue", alpha = 0.5) +
  labs(x = "Season") +
  theme_minimal()

avgdf <- score_df %>% 
  group_by(stadium) %>% 
  summarize(avgprop = mean(favorite_cover == T))

plot <- score_df %>% 
  filter(schedule_season == 2020) %>% 
  group_by(stadium) %>% 
  summarize(prop = mean(favorite_cover == T), team_home) %>% 
  distinct(team_home, .keep_all = TRUE) %>% 
  ggplot(aes(x = stadium)) + 
  geom_bar(aes(y = prop), stat = "identity") + 
  theme(axis.text.x = element_text(face = "bold", size = 12, angle = 45)) 

ggplotly(plot, tooltip = "team_home")

plot <- score_df %>% 
  filter(schedule_season == 2020) %>% 
  group_by(spread_favorite, team_favorite) %>% 
  summarize(prop = mean(favorite_cover == T)) %>%
  ggplot(aes(team_favorite, spread_favorite, fill = prop)) +
  geom_tile() + 
  theme(axis.text.x = element_text(face = "bold", size = 12, angle = 45)) 
ggplotly(plot)

schedule <- fast_scraper_schedules(2020)
sea_full <- schedule %>% filter(home_team == "SEA" | away_team == "SEA")
sea_gids <- sea_full %>% pull(game_id)

pbp_sea <- build_nflfastR_pbp(unlist(sea_gids))

pbp_sea %>% 
  filter(!is.na(cpoe)) %>% 
  group_by(week) %>% 
  summarize(cpoe = mean(cpoe), attempts = n()) %>% 
  ggplot() +
  geom_line(aes(x = week, y = cpoe), group = 1) + 
  scale_x_continuous(breaks = unique(pbp_sea$week), labels = unique(pbp_sea$week)) +
  xlab("Week") +
  theme_minimal()

pbp_sea %>% 
  filter(posteam != "SEA") %>% 
  group_by(week) %>% 
  summarize(def_epa = mean(epa, na.rm = T)) %>% 
  ggplot() +
  geom_line(aes(x = week, y = def_epa), group = 1) +
  scale_y_continuous() +
  theme_minimal()

pbp_sea$drive_ydstart <- NA
pbp_sea$drive_start_yard_line <- sapply(pbp_sea$drive_start_yard_line, as.String)
for (i in 1:nrow(pbp_sea)) {
  if (pbp_sea$drive_start_yard_line[i] == 50) {
    pbp_sea$drive_ydstart[i] <- 50
  } else if (str_detect(pbp_sea$drive_start_yard_line[i], "SEA")) {
    pbp_sea$drive_ydstart[i] <- str_c("OWN ", str_split(pbp_sea$drive_start_yard_line[i], " ")[[1]][2])
  } else {
    pbp_sea$drive_ydstart[i] <- str_c("OPP ", str_split(pbp_sea$drive_start_yard_line[i], " ")[[1]][2])
  }
}

pbp_sea %>% 
  filter(posteam == "SEA") %>% 
  mutate(own = str_detect(drive_start_yard_line, "SEA")) %>% 
  group_by(drive_ydstart) %>% 
  summarize(epa = mean(epa, na.rm = T), own) %>% 
  ggplot() +
  geom_line(aes(x = drive_ydstart, y = epa), group = 1) +
  facet_wrap(~ own)

russbruh <- pbp_sea %>% 
  filter(posteam == "SEA") %>% 
  mutate(trailing = posteam_score < defteam_score, russ = passer_player_name == "R.Wilson", run = is.na(passer_player_name)) %>% 
  group_by(drive_quarter_start) %>% 
  summarize(russepa = mean(epa[russ == T], na.rm = T), elseepa = mean(epa[run == T], na.rm = T)) %>% filter(drive_quarter_start < 5) 

size <- 0.1

russbruh %>%
  ggplot(aes(x = drive_quarter_start)) +
  geom_image(aes(y = russepa, image = c("/Users/kobesarausad/Desktop/Projects/nfl/materials/pics/russ.png"), size = size)) +
  geom_image(aes(y = elseepa, image = c("/Users/kobesarausad/Desktop/Projects/nfl/materials/pics/pete.png"), size = size)) +
  scale_size_identity() +
  # geom_line(aes(x = drive_quarter_start, y = elseepa), color = "red") +
  # geom_line(aes(x = drive_quarter_start, y = russepa), color = "blue") +
  labs(x = "Quarter", y = "EPA", title = "Pass EPA vs. Rush EPA by Quarter in 2020") +
  theme_minimal() + 
  ggsave("russpete.png", dpi = 320)

russbruhdown <- pbp_sea %>% 
  filter(posteam == "SEA") %>% 
  mutate(trailing = posteam_score < defteam_score, russ = passer_player_name == "R.Wilson", run = is.na(passer_player_name)) %>% 
  group_by(down) %>% 
  summarize(russepa = mean(epa[russ == T], na.rm = T), elseepa = mean(epa[run == T], na.rm = T)) 

russbruhdown %>%
  ggplot(aes(x = down)) +
  geom_image(aes(y = russepa, image = c("/Users/kobesarausad/Desktop/Projects/nfl/materials/pics/russ.png"), size = size)) +
  geom_image(aes(y = elseepa, image = c("/Users/kobesarausad/Desktop/Projects/nfl/materials/pics/pete.png"), size = size)) +
  scale_size_identity() +
  labs(x = "Down", y = "EPA", title = "Pass EPA vs. Rush EPA by Down in 2020") +
  theme_minimal() + 
  ggsave("russpetedown.png", dpi = 320)

russbruhdownweek <- pbp_sea %>% 
  filter(posteam == "SEA") %>% 
  mutate(russ = passer_player_name == "R.Wilson", run = is.na(passer_player_name)) %>% 
  group_by(week, down) %>% 
  summarize(russepa = mean(epa[russ == T], na.rm = T), elseepa = mean(epa[run == T], na.rm = T)) 

russbruhdownweek %>%
  filter(!is.na(down)) %>% 
  ggplot(aes(x = week)) +
  geom_line(aes(y = russepa)) +
  geom_line(aes(y = elseepa)) +
  facet_wrap(~ down) +
  labs(x = "Week", y = "EPA", title = "Pass EPA vs. Rush EPA in 2020") +
  theme_minimal()
