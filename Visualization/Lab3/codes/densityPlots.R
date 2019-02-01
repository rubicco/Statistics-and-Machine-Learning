library(dplyr)
library(ggplot2)
library(plotly)

#Ggplot2: histogram, density and violin plot

p1<-ggplot(mtcars, aes(mpg, fill=factor(am)))+geom_density(alpha=0.2)
p1

p2<-ggplot(mtcars, aes(mpg, fill=factor(am)))+geom_histogram(bins = 5)
p2

p3<-ggplot(mtcars, aes( y=mpg, x=factor(am)))+geom_violin(fill="orange")
p3

#Plotly: histogram, density and violin plot

p1<-plot_ly(mtcars, x=~mpg, color=~factor(am), alpha=0.6)%>%
  add_histogram()%>%
  layout(barmode = "overlay")

p1


#easiest from ggplot2:
p2<-ggplot(mtcars, aes(mpg, fill=factor(am)))+geom_density(alpha=0.6)
ggplotly(p2)

# Violin plot

p3<-plot_ly(mtcars, x=~factor(am), y=~mpg, split=~factor(am),
            type="violin", box=list(visible=T))
p3
