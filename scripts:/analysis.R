library(tidyverse)
library(reshape2)
library(nflfastR)

# passing <- read.csv("../raw/data/nflpassing.csv")
# staffordp <- read.csv("../raw/data/nflpassing.csv")

ids_2020 <- fast_scraper_schedules(2020) %>% 
  pull(game_id)

pbp_2020 <- build_nflfastR_pbp(ids_2020)

pbp_2020 %>% 
  filter(passer_player_name == "J.Goff" | passer_player_name == "M.Stafford") %>% 
  group_by(passer_player_name, week) %>% 
  summarize(epa = mean(epa, na.rm = T)) %>% 
  ggplot() +
  geom_line(aes(x = week, y = epa, color = passer_player_name, linetype = passer_player_name)) + 
  theme_minimal()

plot <- pbp_2020 %>% 
  filter(!is.na(passer_player_name)) %>% 
  group_by(posteam, week) %>% 
  summarize(epa = mean(epa, na.rm = T)) %>% 
  ggplot() +
  geom_line(aes(x = week, y = epa)) +
  facet_wrap(~ posteam)
ggplotly(plot)

### RUSS TIME -------
sea_12_20 <- fast_scraper_schedules(c(2012:2020)) %>% 
  pull(game_id) 

sea_12_20 <- sea_12_20[str_detect(sea_12_20, "SEA")]

pbp_sea_12_20 <- build_nflfastR_pbp(sea_12_20)

pbp_sea_12_20 %>% 
  filter(passer_player_name == "R.Wilson") %>% 
  group_by(qb_dropback, season) %>% 
  summarize(epa_play = mean(qb_epa, na.rm = T)) %>% 
  mutate(dropback = qb_dropback == 1) %>% 
  ggplot() +
  geom_line(mapping = aes(x = season, y = epa_play, color = dropback)) +
  theme_minimal()

pbp_sea_12_20 %>% 
  filter(passer_player_name == "R.Wilson") %>% 
  group_by(pass_location) %>% 
  summarize(epa_play = mean(qb_epa, na.rm = T)) %>% 
  filter(pass_location != "NA") %>% 
  ggplot() +
  geom_bar(mapping = aes(x = pass_location, y = epa_play), stat = "identity", fill = "#2C3E50") +
  theme_minimal()

pbp_sea_12_20 %>% 
  filter(passer_player_name == "R.Wilson") %>% 
  group_by(pass_location) %>% 
  filter(pass_location != "NA") %>% 
  ggplot() +
  geom_violin(mapping = aes(x = pass_location, y = qb_epa), fill = "#2C3E50") +
  theme_minimal()

pbp_sea_12_20 %>% 
  filter(passer_player_name == "R.Wilson") %>% 
  group_by(spread_line) %>% 
  summarize(epa_play = mean(qb_epa, na.rm = T)) %>% 
  ggplot() +
  geom_bar(mapping = aes(x = spread_line, y = epa_play), stat = "identity", fill = "#2C3E50") +
  theme_minimal()

pbp_sea_12_20 %>% 
  filter(passer_player_name == "R.Wilson") %>% 
  group_by(season) %>% 
  summarize(avg_yac_epa = mean(yac_epa, na.rm = T), avg_yac = mean(yards_after_catch, na.rm = T)) %>% 
  ggplot() +
  geom_line(aes(x = season, y = avg_yac_epa)) +
  geom_line(aes(x = season, y = avg_yac)) +
  theme_minimal()

pbp_sea_12_20 %>% 
  filter(passer_player_name == "R.Wilson") %>% 
  group_by(season, down) %>% 
  summarize(epa_play = mean(qb_epa, na.rm = T), down = as.character(down)) %>% 
  filter(down != "NA") %>% 
  ggplot() +
  geom_line(aes(x = season, y = epa_play, color = down)) +
  theme_minimal()

pbp_sea_12_20 %>% 
  filter(passer_player_name == "R.Wilson" & season_type == "REG") %>% 
  group_by(season, game_id) %>% 
  summarize(epa = sum(epa, na.rm = T)) %>% 
  group_by(season) %>%
  summarize(above = sum(epa > 0), below = sum(epa < 0)) %>%
  rename("epa > 0" = "above", "epa < 0" = "below") %>% 
  melt(id.vars = "season") %>% 
  rename("epa" = "variable") %>%
  ggplot() +
  geom_bar(aes(x = as.factor(season), y = value, fill = epa), stat = "identity", position="dodge", width = 0.6, alpha = 0.6) +
  scale_fill_discrete(name = NULL) + 
  scale_y_discrete() +
  theme_minimal() +
  labs(x = "Season", y = "Games")

pbp_sea_12_20 %>% 
  filter(passer_player_name == "R.Wilson" & season == 2020) %>% 
  group_by(week, qb_dropback) %>% 
  summarize(epa = mean(qb_epa, na.rm = T))
