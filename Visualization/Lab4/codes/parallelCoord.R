library(ggplot2)
library(plotly)


#Plotly - can not see observation ID
data=iris
p <- data %>%
  plot_ly(type = 'parcoords', 
          #line = list(color = ~as.numeric(Species)),
                      
          dimensions = list(
            list(label = 'Sepal Width', values = ~Sepal.Width),
            list(label = 'Sepal Length', values = ~Sepal.Length),
            list(label = 'Petal Length', values = ~Petal.Length)
          )
  )

p


## GGplot2 - can see observation ID, no interactivity
library(GGally)

obj<- ggparcoord(iris, columns=1:3)
ggplotly(obj)

#coloring lines
data=iris
data$Col=as.numeric(scale(data$Petal.Length)< -0.5)
obj<- ggparcoord(data, columns=1:3, scale="uniminmax", groupColumn = 6)

ggplotly(obj)

#coloring by another variable
obj<- ggparcoord(data, columns=1:3, scale="uniminmax", groupColumn = 5)

ggplotly(obj)

