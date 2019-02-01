#devtools::install_github("hrbrmstr/streamgraph")

library(dplyr)
library(ggplot2movies)
library(streamgraph)

ggplot2movies::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally(wt=value) %>%
  ungroup %>%
  streamgraph("genre", "n", "year") %>%
  sg_axis_x(20) %>%
  sg_fill_brewer("PuOr") %>%
  sg_legend(show=TRUE, label="Genres: ")
