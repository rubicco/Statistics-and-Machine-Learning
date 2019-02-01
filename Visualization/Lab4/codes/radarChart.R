library(plotly)

mtscaled=scale(mtcars)

#Superimposed


p<- plot_ly(type='scatterpolar', fill = 'toself')

for (i in 1:3){
  p<-p%>% add_trace(r=c(mtscaled[i,], mtscaled[i,1]),
                    theta=c(colnames(mtscaled), colnames(mtscaled)[1]),
                    name=rownames(mtscaled)[i])
}

p <- p%>% layout(
  polar = list(
    radialaxis = list(
      visible = T
    )
  )
)

p

#Juxtaposed

#Ugly graphics
stars(mtcars,key.loc=c(15,2), draw.segments=F, col.stars =rep("Yellow", nrow(mtcars)))

##ggplot2
library(scales)
mtcars1<-mtcars%>% mutate_all(funs(rescale))
mtcars1$name=rownames(mtcars)
mtcars2 <- mtcars1%>%tidyr::gather(variable, value, -name, factor_key=T)%>%arrange(name)
p<-mtcars2 %>%
  ggplot(aes(x=variable, y=value, group=name)) + 
  geom_polygon(fill="blue") + 
  coord_polar() + theme_bw() + facet_wrap(~ name) + 
  theme(axis.text.x = element_text(size = 5))
p

## Plotly

library(plotly)
library(dplyr)
library(scales)

Ps=list()
nPlot=10#nrow(mtcars)

mtcars %>%
  add_rownames( var = "group" ) %>%
  mutate_each(funs(rescale), -group) -> mtcars_radar

for (i in 1:nPlot){
  Ps[[i]] <- htmltools::tags$div(
    plot_ly(type = 'scatterpolar', 
            r=as.numeric(mtcars_radar[i,-1]),
            theta= colnames(mtcars_radar)[-1], 
            fill="toself")%>%
      layout(title=mtcars_radar$group[i]), style="width: 25%;")
}

h <-htmltools::tags$div(style = "display: flex; flex-wrap: wrap", Ps)

htmltools::browsable(h)