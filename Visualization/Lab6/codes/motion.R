library(plotly)

m=matrix(nrow=0,ncol=3)
for (a in seq(0,3,by=0.03)) {
  x<-seq(0,2,0.01)
  y<-x^a
  m<-rbind(m,cbind(x,y,a))
}

df=as.data.frame(m)

plot_ly(df, x=~x, y=~y, frame =~a)%>%add_lines()%>%animation_opts(
  100, easing = "cubic", redraw = F
)


