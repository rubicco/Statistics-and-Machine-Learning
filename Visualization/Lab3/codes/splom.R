library(dplyr)
library(ggplot2)

library(plotly)

#plotly

mtcars %>% plot_ly()%>%
  add_trace(type='splom',     dimensions = list(
    list(label='MPG', values=~mpg),
    list(label='Displacement', values=~disp),
    list(label='#Horse Power', values=~hp),
    list(label='weight', values=~wt)),
    marker = list(
      color = as.integer(mtcars$cyl),
      size = ~qsec

    )
    
)

#ggplot2

library(GGally)
ggpairs(mtcars, columns=c(1,3,4,6),
        mapping =aes(color=factor(cyl), size=qsec))
