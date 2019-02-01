library(ggplot2)

######################
### PLOT FUNCTIONS ###
######################

plot_mu = function(mu, title){
  # mu should be a matrix which is KxD size
  plot_df = NULL
  # create df for plot
  for(k in 1:dim(mu)[1]){
    plot_df = rbind(plot_df, data.frame(index = c(1:dim(mu)[2]),
                                        value = mu[k, ],
                                        component = 
                                          rep(paste("mu_", k, sep = ""))))
  }
  
  plot = ggplot(plot_df, aes(x = index, y = value, color = component)) +
    geom_line() +
    geom_point(alpha = 0.6) +
    labs(title = title, x = "index", y = "mu value", 
         color = "Component") +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_brewer(palette="Paired")
    
  return(plot)
}

plot_pi = function(pi, title){
  plot_df = data.frame(index = c(1:length(pi)),
                       pi = pi)
  
  plot = ggplot(plot_df, aes(x=index, y=pi)) +
    geom_bar(stat = "identity") + 
    labs(title = title, x = "index", y = "pi value")
  
  return(plot)
}

plot_llik = function(llik, title){
  plot_df = data.frame(iteration = c(1:length(llik)),
                 llik = llik)
  plot = ggplot(plot_df, aes(x = iteration, y= llik)) +
              geom_line(color = "#eec674", size=1.2) +
              geom_point(color = "#c19371", size = 1.5) 
  return(plot)
}

############################
### REAL DATA GENERATION ###
############################

set.seed(1234567890)
N=1000 # number of training points
D=10 # number of dimensions
x <- matrix(nrow=N, ncol=D) # training data
true_pi <- vector(length = 3) # true mixing coefficients
true_mu <- matrix(nrow=3, ncol=D) # true conditional distributions
true_pi=c(1/3, 1/3, 1/3)
true_mu[1,]=c(0.5,0.6,0.4,0.7,0.3,0.8,0.2,0.9,0.1,1)
true_mu[2,]=c(0.5,0.4,0.6,0.3,0.7,0.2,0.8,0.1,0.9,0)
true_mu[3,]=c(0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5)
plot_true_mu = plot_mu(true_mu, "True Mu Values, K=3")

############################
### SIM DATA GENERATION  ###
############################

# Producing the training data
for(n in 1:N) {
  k <- sample(1:3,1,prob=true_pi)
  for(d in 1:D) {
    x[n,d] <- rbinom(1,1,true_mu[k,d])
  }
}

# number of guessed components
K=3 
# max number of EM iterations
max_it <- 100 
# min change in log likelihood between two consecutive EM iterations
min_change <- 0.1 


pi 
mu

###################
### EM FUNCTION ###
###################

em_bernoulli = function(x, K=3, max_it=100, min_change=0.1){
  N = dim(x)[1]
  D = dim(x)[2]
  ### declare random variable
  z <- matrix(nrow=N, ncol=K) # fractional component assignments
  pi <- vector(length = K) # mixing coefficients
  mu <- matrix(nrow=K, ncol=D) # conditional distributions
  
  llik <- c() # log likelihood of the EM iterations
  # Random initialization of the parameters
  pi <- runif(K,0.49,0.51)
  pi <- pi / sum(pi)
  for(k in 1:K) {
    mu[k,] <- runif(D,0.49,0.51)
  }
  # create initialized mu plot
  plot_init_mu = plot_mu(mu, paste("Init Mu Values, K=", K, sep=""))
  ### main loop
  for(it in 1:max_it) {
    # E-step: Computation of the fractional component assignments
    ### calculate Z matrix
    p = exp(x %*%t (log(mu)) + (1-x) %*% t(log(1-mu)))
    pi_multiplier = matrix(rep(pi, N), nrow=N, byrow = T)
    weighted_p = pi_multiplier * p
    z_probs = weighted_p / rowSums(weighted_p)
    
    ### Log likelihood computation.
    llik[it] = sum(log(rowSums(weighted_p)))
    
    cat("iteration: ", it, "log likelihood: ", llik[it], "\n")
    flush.console()
    # Stop if the log likelihood has not changed significantly
    if(it!=1){
      if(llik[it]-llik[it-1] <= min_change)
        break
    }
    # M-step: ML parameter estimation 
    # from the data and fractional component assignments
    ### calculate pi
    pi = colSums(z_probs) / N
    ### calculate mu
    mu = t(z_probs) %*% x / colSums(z_probs)
  }
  # create final plots
  plot_final_mu = plot_mu(mu, paste("Final Mu Values, K=", K, sep=""))
  plot_final_pi = plot_pi(pi, paste("Final Pi Values, K=", K, sep=""))
  plot_llik = plot_llik(llik, paste("Log-Likelihood, K=", K, sep = ""))
  result = list(llik = llik,
                plots = list(
                  init_mu = plot_init_mu,
                  final_mu = plot_final_mu,
                  final_pi = plot_final_pi,
                  llik = plot_llik)
                )
  return(result)
}
  

em_3 = em_bernoulli(x, K=3)
em_4 = em_bernoulli(x, K=3)
em_5 = em_bernoulli(x, K=3)





