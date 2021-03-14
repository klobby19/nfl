library(tidyverse)
library(plotly)

passing <- read.csv("materials/data/nflpassing.csv")

plot <- passing %>% 
  filter(TD >= 20) %>% 
  ggplot() +
  geom_point(aes(x = as.numeric(Sack), y = Rate, color = Player)) +
  stat_smooth(aes(x = as.numeric(Sack), y = Rate), method = "lm", formula = y ~ x + I(x^3), size = 1)

ggplotly(plot)
