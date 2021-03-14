library(rvest)
library(rlist)
library(tidyverse)

tbl_final <- data.frame()

for (year in 1940:2020) {
  url <- sprintf("https://www.footballdb.com/statistics/nfl/player-stats/passing/%s/regular-season?sort=passrate&limit=100", year) 
  
  webpage <- read_html(url)
  
  tbls_ls <- webpage %>%
    html_nodes("table") %>%
    .[1] %>%
    html_table(fill = TRUE)
  
  tbl <- tbls_ls[[1]]
  
  tbl <- mutate(tbl, year = year)
  
  if (year >= 1970) {
    tbl <- select(tbl, -c(Gms))
  }
  
  tbl_final <- rbind(tbl_final, tbl)
}

vec <- c()

for (player in tbl_final$Player) {
  player <- str_sub(player, start = 1, end = str_locate(player, "\\.")[1] - 2)
  vec <- append(vec, player)
}

tbl_final$Player <- vec

write.csv(tbl_final, "nflpassing.csv")