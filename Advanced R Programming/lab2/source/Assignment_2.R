# library(markmyassignment)
# lab_path <- "https://raw.githubusercontent.com/STIMALiU/AdvRCourse/master/Labs/Tests/lab2.yml" 
# set_assignment(lab_path)
name <- "Mim Kemal Tekin"
liuid <- "mimte666"

##
## 1.1 Conditional Statement
##
#### 1.1.1 sheldon_game
sheldon_game <- function(player1, player2){
  rules <- data.frame("rock"=c("lizard","scissors"), "paper"=c("rock","spock"), "scissors"=c("paper","lizard"),"spock"=c("scissors","rock"),"lizard"=c("spock","paper"))
  if(is.element(player2, rules[[player1]]))
    return("Player 1 wins!")
  else if(is.element(player1, rules[[player2]]))
    return("Player 2 wins!")
  else if(player1==player2)
    return("Draw!")
  else
    stop()
}

##
## 1.2 for Loops
##
#### 1.2.1 my_moving_median
my_moving_median <- function(x, n, ...){
  if(!(is.numeric(x) && is.numeric(n)))
    stop("parameters should be scalar numeric.")
  opt_arg_list <- list(...)
  if(! ("na.rm" %in% names(opt_arg_list)))
    na.rm = FALSE
  else
    na.rm = opt_arg_list$na.rm
  result<-c()
  for(i in 1:(length(x)-n))
      result<-c(result,median(x[i:(i+n)], na.rm))
  return(result)
}
# my_moving_median(x = 1:10, n=2)
# my_moving_median(x = 5:15, n=4)
# my_moving_median(x = c(5,1,2,NA,2,5,6,8,9,9), n=2)
# my_moving_median(x = c(5,1,2,NA,2,5,6,8,9,9), n=2, na.rm=TRUE)

##
#### 1.2.2 for_mult_table
for_mult_table <- function(from, to){
  if(!(is.numeric(from) && is.numeric(to)))
    stop("parameters should be scalar numeric.")
  ft_row = from:to
  result <- matrix(nrow=(to-from+1), ncol=(to-from+1))
  for(i in 1:(to-from+1)){
    result[i,] <- ft_row*from + ft_row*(i-1)
  }
  return(result)
}
# for_mult_table(from = 1, to = 5)
# for_mult_table(from = 10, to = 12)

##
#### 1.2.3 * cor_matrix
cor_matrix <- function(X){
  # cov_matrix = data.matrix(t(X))%*%data.matrix(X)
  #cov calculation
  if(!is.data.frame(X))
    stop("Argument has to be a data.frame!")
  cor_matrix = matrix(nrow=length(X), ncol=length(X))
  for(i in 1:nrow(cor_matrix)){
    for(j in 1:ncol(cor_matrix)){
      x <- X[,i]
      y <- X[,j]
      cov_xy = sum((x-mean(x))*(y-mean(y)))/(length(x)-1)
      cov_x = sum((x-mean(x))^2)/(length(x)-1)
      cov_y = sum((y-mean(y))^2)/(length(y)-1)
      cor_matrix[i,j] = cov_xy/((cov_x^(1/2))*(cov_y^(1/2)))
    }
  }
  return(cor_matrix)
}
# data(iris)
# cor_matrix(iris[,1:4])
# data(faithful) 
# cor_matrix(faithful)


##
## 1.3 while loops
##
#### 1.3.1 find_cumsum()
find_cumsum <- function(x, find_sum){
  if(!(is.numeric(x) && is.numeric(find_sum)))
    stop("x: numeric vector, find_sum: numeric scalar")
  sum <- 0
  i<-1
  while(i<length(x)+1 && sum<find_sum){
    sum<-sum+x[i]
    i<-i+1
  }
  return(sum)
}
# find_cumsum(x=1:100, find_sum=500)
# find_cumsum(x=1:10, find_sum=1000)

##
#### 1.3.2 while_mult_table
while_mult_table <- function(from, to){
  i<-1
  j<-1
  result <- matrix(nrow=(to-from+1), ncol=(to-from+1))
  while(i<=to-from+1){
    j<-1
    while(j<=to-from+1){
      result[i,j] <- (from+j-1)*(from+i-1)
      j <- j + 1
    }
    i <- i +1
  }
  return(result)
}
# while_mult_table(from = 3, to = 5)
# while_mult_table(from = 7, to = 12)

##
#### 1.3.3 * trial_division_dactorization
trial_division_factorization <- function(x){
  a = c()
  while(x%%2==0){
    a = c(a,2)
    x = x/2
  }
  f=3
  while(f*f<=x){
    if(x%%f==0){
      a = c(a,f)
      x = x/f
    }
    else
      f = f+2
  }
  if(x!=1)
    a = c(a,x)
  return(a)
}
# trial_division_factorization(x = 2^3 * 13 * 17 * 31)
# trial_division_factorization(x = 47 * 91 * 97)
    
##
## 1.4 repeat and loop controls
##
#### 1.4.1 repeat_find_cumsum()
repeat_find_cumsum <- function(x, find_sum){
  sum <- 0
  i <- 1
  repeat{
    if(i==length(x)+1 || sum>find_sum)
      return(sum)
    sum <- sum + x[i]
    i <- i+1
  }
}
# repeat_find_cumsum(x=1:100, find_sum=500)
# repeat_find_cumsum(x=1:10, find_sum=1000)

##
#### 1.4.1 repeat_my_moving_median()
repeat_my_moving_median <- function(x, n, ...){
  if(!(is.numeric(x) && is.numeric(n)))
    stop("parameters should be scalar numeric.")
  result <- c()
  i <- 1
  opt_arg_list <- list(...)
  if(! ("na.rm" %in% names(opt_arg_list)))
    na.rm = FALSE
  else
    na.rm = opt_arg_list$na.rm
  repeat{
    if(i>length(x)-n) 
      return(result)
    result <- c(result, median(x[i:(i+n)], na.rm))
    i <- i+1
  }
}
# my_moving_median(x = 1:10, n=2)
# my_moving_median(x = 5:15, n=4)
# my_moving_median(x = c(5,1,2,NA,2,5,6,8,9,9), n=2)
# my_moving_median(x = c(5,1,2,NA,2,5,6,8,9,9), n=2, na.rm=TRUE)

##
## 1.5 Environment
##
#### 1.5.1 in_environment()
in_environment <- function(env){
  return(ls(env))
}
# env <- search()[length(search())]
# funs <- in_environment(env)
# funs[1:5]


##
#### 1.5.2 * where()
where <- function(fun){
  all_pkg = search()
  for(i in 1:length(all_pkg)){
    curr_pkg = ls(all_pkg[i])
    if(fun%in%curr_pkg)
      return(all_pkg[i])
  }
  return("non_existant_function not found!")
}
where(fun = "sd")
where(fun = "read.table")
where(fun = "non_existant_function")

##
## 1.6 Functionals
##
#### 1.6 cov()
cov <- function(X){
  if(!is.data.frame(X))
    stop("X must be a dataframe")
  return (sapply(X, function(x) sd(x)/mean(x), simplify = TRUE))
}
# data(iris)
# asd = cov(X = iris[1:4])
# typeof(asd)

##
## 1.7 Closures
##
#### 1.7.1 moment()
moment <- function(i){
  if(!is.numeric(i))
    stop("i must be numeric.")
  return(function(x){return(sum((x-mean(x))^i)/length(x))})
}
# m1 <- moment(i=1)
# m2 <- moment(i=2)
# m1(1:100)
# m2(1:100)



