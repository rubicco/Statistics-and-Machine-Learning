library(plotly)

music = read.csv("music-sub.csv", row.names=1)
music.numeric= scale(music[,4:7])
d=dist(music.numeric)
coords=cmdscale(d,2)
coordsMDS=as.data.frame(coords)
coordsMDS$name=rownames(coordsMDS)

plot_ly(coordsMDS, x=~V1, y=~V2, type="scatter", hovertext=~name)
