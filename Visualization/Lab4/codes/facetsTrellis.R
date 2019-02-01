library(plotly)

df=lattice::barley

p<-ggplot(df, aes(y=variety, x=yield, color=year))+geom_point()+
  facet_grid(site~.)
p

ggplotly(p)

df1<-mpg

p1<-ggplot(df1, aes(cty, displ))+geom_point()+geom_smooth()+
  facet_wrap(~class, labeller = "label_both")


df3<-MASS::Aids2
Agerange<-lattice::equal.count(df3$age, number=6, overlap=0.03) #overlap is 3% 

L<-matrix(unlist(levels(Agerange)), ncol=2, byrow = T)
L1<-data.frame(Lower=L[,1],Upper=L[,2], Interval=factor(1:nrow(L)))
ggplot(L1)+geom_linerange(aes(ymin = Lower, ymax = Upper, x=Interval))

index=c()
Class=c()
for(i in 1:nrow(L)){
  Cl=paste("[", L1$Lower[i], ",", L1$Upper[i], "]", sep="")
  ind=which(df3$age>=L1$Lower[i] &df3$age<=L1$Upper[i])
  index=c(index,ind)
  Class=c(Class, rep(Cl, length(ind)))
}

df4<-df3[index,]
df4$Class<-as.factor(Class)

ggplot(df4, aes(x=death-diag, fill="orange"))+ geom_histogram()+
  facet_wrap(~Class, labeller = "label_both")
