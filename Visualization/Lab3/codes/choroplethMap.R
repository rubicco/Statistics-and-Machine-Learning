library(plotly)

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')



# WORLD MAP
g <- list(
  projection = list(type = 'Mercator')
)

p <- plot_geo(df) %>%
  add_trace(
    z = ~GDP..BILLIONS., color = ~GDP..BILLIONS., colors = 'Blues',
    text = ~COUNTRY, locations = ~CODE
  ) %>%
    layout(
    geo = g
  )

p

####Other country maps

rds<-readRDS("codes/gadm36_GBR_2_sf.rds")
df<-read.csv("codes/GBcities.csv")

rownames(df)=df$name
rds$Price=df[rds$NAME_2, "Price"]
#Data for some regions absent, setting to 0
rds$Price[is.na(rds$Price)]=0

#plotly
p<-plot_ly()%>%add_sf(data=rds, split=~NAME_2, color=~Price, showlegend=F, alpha=1)
p
#ggplot2
p<-ggplot(rds) +  geom_sf(aes(fill = Price))
ggplotly(p)

#mapbox

p<-plot_mapbox(rds, split=~NAME_2, color=~Price, showlegend=F, alpha=0.5)
p
