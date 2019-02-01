library(ggraph)
library(igraph)
graph <- graph_from_data_frame(flare$edges, vertices = flare$vertices)

ggraph(graph, 'circlepack', weight = 'size') +
  geom_edge_link() +
  geom_node_point(aes(colour = depth)) +
  geom_node_text(label=flare$vertices$shortName, size=1)+
  coord_fixed()

library(visNetwork)
library(rpart)

# Basic classification tree
crabs=read.csv("codes/australian-crabs.csv")
res <- rpart(as.factor(sex)~., data=crabs)
visTree(res, main = "Iris classification Tree", width = "100%")
