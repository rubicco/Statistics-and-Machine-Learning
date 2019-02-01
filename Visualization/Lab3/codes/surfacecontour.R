library(dplyr)
library(ggplot2)
library(MASS)

library(plotly)

mtcars %>%plot_ly(x=~mpg, y=~disp, z=~wt, type="scatter3d")
mtcars %>%plot_ly(x=~mpg, y=~disp, z=~wt, type="contour")

library(akima)
attach(mtcars)
s=interp(mpg,disp,wt, duplicate = "mean")
detach(mtcars)

plot_ly(x=~s$x, y=~s$y, z=~s$z, type="surface")
