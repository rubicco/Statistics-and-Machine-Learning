library(plotly)
df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2011_february_us_airport_traffic.csv')


g <- list(
  scope = 'usa'
)

p <- plot_geo(df, lat = ~lat, lon = ~long) %>%
  add_markers(
    text = ~paste(airport, city, state, paste("Arrivals:", cnt), sep = "<br />"),
    color = ~cnt, symbol = I("diamond"), hoverinfo = "text", 
    colors=colorRamp(c("lightblue","darkblue"))
  )  %>%
  layout(geo = g)
p


#size adjustment

p <- plot_geo(df, lat = ~lat, lon = ~long) %>%
  add_markers(
    text = ~paste(airport, city, state, paste("Arrivals:", cnt), sep = "<br />"),
    size = ~cnt, symbol = I("diamond"), hoverinfo = "text", 
    colors=colorRamp(c("lightblue","darkblue"))
  )  %>%
  layout(geo = g)
p

## Other countries than USA- ggplot2

##Example -UK

rds<-readRDS("gadm36_GBR_0_sf.rds")
df<-read.csv("GBcities.csv")
p<-ggplot()+geom_sf(data=rds)+
  geom_point(data=df, mapping = aes(longitude, latitude, color=Price))


p
##Use google chrome- does not work in explorer.

ggplotly(p)


##Now with mapbox

p <- df %>%
  plot_mapbox(lat = ~latitude, lon = ~longitude,
              size = ~Price, 
              mode = 'scattermapbox')
p
