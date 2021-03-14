library(tidyverse)
library(ggrepel)

pbwr <- read.csv("datasets/pbwr.csv")
pbwr <- pbwr %>% mutate(team = trimws(sub(".*\\.", "", pbwr$team))) %>% 
  mutate(rate = as.numeric(str_remove(rate, "%")) / 100) %>% 
  rename("pbwr" = "rate")
rbwr <- read.csv("datasets/rbwr.csv")
rbwr <- rbwr %>% mutate(team = trimws(sub(".*\\.", "", rbwr$team))) %>% 
  mutate(rate = as.numeric(str_remove(rate, "%")) / 100) %>% 
  rename("rbwr" = "rate")

playoff_teams <- read.csv("datasets/playoffs.csv") %>% 
  pull(Tm)

wr_df <- left_join(pbwr, rbwr, by="team")

wr_df <- mutate(wr_df, playoffs = team %in% playoff_teams)

wr_df %>% 
  ggplot(aes(x = rbwr, y = pbwr, color = playoffs)) +
  geom_point() +
  scale_color_manual(values = c("black", "red")) +
  geom_label_repel(aes(label = team),
                   size = 2,
                   box.padding = unit(0.5, "lines"), 
                   point.padding = 0.5,
                   segment.color = 'grey50') +
  theme_minimal() +
  ggsave("pbrbrate.png")
