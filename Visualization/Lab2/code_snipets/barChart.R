library(dplyr)
library(ggplot2)
library(plotly)

#Bar chart ggplot2
p2<-ggplot(mtcars, aes(cyl))+ geom_bar(fill="orange")
p2

#bar chart ggplot2 another way- any other summary can be computed.
c1<-mtcars %>%   group_by(cyl) %>%   summarise(ncyl = n())
p1<- ggplot(c1, aes(cyl, ncyl))+
  geom_bar(stat = "identity", fill="orange")+
  labs(x="# Cylinders", y="Amount")
print(p1)

#Pie chart ggplot2
c2<-c1
c2$ncyl=c2$ncyl/sum(c2$ncyl)*100
p3<- ggplot(c2, aes(x="", y=ncyl, fill=factor(cyl)))+
  geom_bar(width=1,stat = "identity" )+
  labs(x=NULL, y=NULL, fill="#Cylinders")+
  coord_polar(theta="y")
  
print(p3)

#Bar chart with 2 categories
c3<- mtcars%>% group_by(gear, cyl) %>% summarize( count=n())

p4<- ggplot(c3, aes(gear, count,fill=factor(cyl)))+ 
  geom_bar(stat="identity", position="dodge")+
  labs(fill="#Cylinders")
p4

## NOW in plotly

#Bar chart
c1<-mtcars %>%   group_by(cyl) %>%   summarise(ncyl = n())
p<- plot_ly(data=c1, x=~cyl, y=~ncyl)%>%
  add_bars()%>%layout(xaxis=list(title="Cylinders"), yaxis=list(title="Count"))
p         

# Bar chart wth two categories

c3<- mtcars%>% group_by(gear, cyl) %>% summarize( count=n())

p<- plot_ly(data=c3, x=~cyl, y=~count, color=~factor(gear))%>%
  add_bars()%>%
  layout(xaxis=list(title="Cylinders"), yaxis=list(title="Count"), barmode='group')
p  

#Pie chart plotly
c2<-c1
c2$ncyl=c2$ncyl/sum(c2$ncyl)*100
p3<- plot_ly(c2, labels=~cyl, values=~ncyl)%>%
  add_pie()
  
print(p3)



