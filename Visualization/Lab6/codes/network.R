library(ggraph)
library(igraph)
library(visNetwork)
library(dplyr)

nodes <- read.csv("Dataset1-Media-Example-NODES.csv", header=T, as.is=T)
links <- read.csv("Dataset1-Media-Example-EDGES.csv", header=T, as.is=T)

## Collapsing multiple links into one

links <- aggregate(links[,3], links[,-3], sum)
links <- links[order(links$from, links$to),]
colnames(links)[4] <- "weight"
rownames(links) <- NULL

nodes$label=nodes$media
net <- graph_from_data_frame(d=links, vertices=nodes, directed=F)
visIgraph(net)
visNetwork(nodes, links)

nodes$group=nodes$type.label
nodes$value=nodes$audience.size
links$width=links$weight
visNetwork(nodes, links)%>%visLegend()

visNetwork(nodes,links)%>%visIgraphLayout(layout="layout_in_circle")

# Community identification
nodes1<-nodes
net <- graph_from_data_frame(d=links, vertices=nodes, directed=F)
ceb <- cluster_edge_betweenness(net)
nodes1$group=ceb$membership
visNetwork(nodes1,links)%>%visIgraphLayout()
##################

#adjacency representation

netm <- get.adjacency(net, attr="weight", sparse=F)
colnames(netm) <- V(net)$media
rownames(netm) <- V(net)$media

rowdist<-dist(netm)

library(seriation)
order1<-seriate(rowdist, "HC")
ord1<-get_order(order1)

reordmatr<-netm[ord1,ord1]

library(plotly)

plot_ly(z=~reordmatr, x=~colnames(reordmatr),
        y=~rownames(reordmatr), type="heatmap")

