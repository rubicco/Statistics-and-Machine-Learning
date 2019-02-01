library(plotly)
library(seriation)

mtscaled=scale(mtcars[1:7])
rowdist<-dist(mtscaled)
coldist<-dist(t(mtscaled))

order1<-seriate(rowdist, "BBURCG")
order2<-seriate(coldist, "BBURCG")
ord1<-get_order(order1)
ord2<-get_order(order2)

reordmatr<-mtscaled[rev(ord1),ord2]

dims=list()
for( i in 1:ncol(reordmatr)){
  dims[[i]]=list( label=colnames(reordmatr)[i],
    values=as.formula(paste("~",colnames(reordmatr)[i])))
}

dims0=list()
for( i in 1:ncol(mtscaled)){
  dims0[[i]]=list( label=colnames(mtscaled)[i],
                  values=as.formula(paste("~",colnames(mtscaled)[i])))
}

p <- as.data.frame(mtscaled) %>%
  plot_ly(type = 'parcoords', 
          #line = list(color = ~as.numeric(Species)),
          
          dimensions = dims0
  )

p

p1 <- as.data.frame(reordmatr) %>%
  plot_ly(type = 'parcoords', 
          #line = list(color = ~as.numeric(Species)),
          
          dimensions = dims
  )

p1


plot_ly(x=colnames(reordmatr), y=rownames(reordmatr), 
        z=reordmatr, type="heatmap", colors =colorRamp(c("yellow", "red")))
