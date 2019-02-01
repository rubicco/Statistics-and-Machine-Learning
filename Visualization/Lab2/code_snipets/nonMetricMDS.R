library(plotly)
library(MASS)

music = read.csv("code_snipets/music-sub.csv", row.names=1)
music.numeric= scale(music[,4:7])
d=dist(music.numeric)
res=isoMDS(d,k=3)
coords=res$points

coordsMDS=as.data.frame(coords)
coordsMDS$name=rownames(coordsMDS)
coordsMDS$artist=music$artist

plot_ly(coordsMDS, x=~V1, y=~V2, z=~V3, type="scatter3d", hovertext=~name, color= ~artist)
