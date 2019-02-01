library(plotly)
mtscaled=scale(mtcars)

plot_ly(x=colnames(mtscaled), y=rownames(mtscaled), 
        z=mtscaled, type="heatmap", colors =colorRamp(c("yellow", "red")))

                                                                                             
