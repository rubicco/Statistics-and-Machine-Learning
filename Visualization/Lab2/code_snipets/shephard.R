sh <- Shepard(d, coords)
delta <-as.numeric(d)
D<- as.numeric(dist(coords))

n=nrow(coords)
index=matrix(1:n, nrow=n, ncol=n)
index1=as.numeric(index[lower.tri(index)])

n=nrow(coords)
index=matrix(1:n, nrow=n, ncol=n, byrow = T)
index2=as.numeric(index[lower.tri(index)])



plot_ly()%>%
  add_markers(x=~delta, y=~D, hoverinfo = 'text',
        text = ~paste('Obj1: ', rownames(music)[index1],
                      '<br> Obj 2: ', rownames(music)[index2]))%>%
  #if nonmetric MDS inolved
  add_lines(x=~sh$x, y=~sh$yf)
  
