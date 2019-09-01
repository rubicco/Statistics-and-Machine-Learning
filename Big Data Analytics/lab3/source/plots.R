

gaussian_kernel = function(norm, weight){
  return(exp(-norm^2/(2*weight^2)))
}

#Try different values of h for the distance

x_distance = seq(1,500,10)
h_dist = c(10,50,100,200,500)

df_distance = data.frame(x = x_distance)
for(h in h_dist){
  df_distance[[paste("y",h,sep = "")]] = gaussian_kernel(x_distance, h)
}

library(ggplot2)

plot_df_mu = df_distance
colnames(plot_df_mu) = c("iteration","h = 10", "h = 50","h = 100",
                         "h = 200","h = 500")

plot_df_mu = tidyr::gather(plot_df_mu, key = "h_values", 
                           value ="kernel_values", -iteration)

plot_mu = ggplot(plot_df_mu) +
  geom_line(aes(x=iteration, y = kernel_values, color=h_values)) 

plot_mu
##################### Different values for days #################

x_distance = seq(1,365,1)
h_dist = c(10,30,50,100,200)

df_distance = data.frame(x = x_distance)
for(h in h_dist){
  df_distance[[paste("y",h,sep = "")]] = gaussian_kernel(x_distance, h)
}


plot_df_mu = df_distance
colnames(plot_df_mu) = c("iteration","h = 10", "h = 30","h = 50",
                         "h = 100","h = 200")

plot_df_mu = tidyr::gather(plot_df_mu, key = "h_values", 
                           value ="kernel_values", -iteration)

plot_mu = ggplot(plot_df_mu) +
  geom_line(aes(x=iteration, y = kernel_values, color=h_values)) 
plot_mu


##################### Different values for time(hour) #################

x_distance = seq(1,24,1)
h_dist = c(1,2,3,4,8,12)

df_distance = data.frame(x = x_distance)
for(h in h_dist){
  df_distance[[paste("y",h,sep = "")]] = gaussian_kernel(x_distance, h)
}


plot_df_mu = df_distance
colnames(plot_df_mu) = c("iteration","h = 1", "h = 2", "h = 3", "h = 4","h = 8",
                         "h = 12")

plot_df_mu = tidyr::gather(plot_df_mu, key = "h_values", 
                           value ="kernel_values", -iteration)

plot_mu = ggplot(plot_df_mu) +
  geom_line(aes(x=iteration, y = kernel_values, color=h_values)) 
plot_mu







