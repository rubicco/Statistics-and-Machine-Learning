name <- "Mim Kemal Tekin"
liuid <- "mimte666"

##
## 1.1 Vectors
##
#### 1.1.1 my_num_vector
my_num_vector <- function(){
  result <- c(log10(11), cos(pi/5), exp(1)^(pi/3), 1173%%7/19)
  return(result)
}


##
#### 1.1.2 filter_my_vector
filter_my_vector <- function(x=c(2, 9, 2, 4, 102), leq=4){
  return (x[ifelse(x<leq, TRUE, NA)])
}

##
#### 1.1.3 dot_prod
dot_prod <- function(a = c(-1,3), b = c(-3,-1)){
  return(sum(a*b))
}

##
#### 1.1.4 approx_e
approx_e <- function(N){
  result <- sum(1/factorial(0:N))
  return(result)
}

##
## 1.2 Matrices
##
#### 1.2.1 my_magic_matrix
my_magic_matrix <- function(){
  x<-matrix(c(c(4,3,8),c(9,5,1),c(2,7,6)),3)
  return(x)
}

##
#### 1.2.2 calculate_elements
calculate_elements <- function(A){
  return(length(A))
}
calculate_elements(cbind(my_magic_matrix(),my_magic_matrix()))

##
#### 1.2.3 row_to_zero
row_to_zero <- function(A, i){
  A[i,]=0
  return(A)
}

##
#### 1.2.4 add_elements_to_matrix
add_elements_to_matrix <- function(A, x, i, j){
  A[i,j]=A[i,j]+x
  return(A)
}

##
## 1.3 Lists
##
#### 1.3.1 my_magic_list
my_magic_list <- function(){
  return(list(info="my own list",my_num_vector(),my_magic_matrix()))
}

##
#### 1.3.2 change_info
change_info <- function(x, text){
  x['info']<-text
  return(x)
}

##
#### 1.3.3 add_note
add_note <- function(x, note){
  x['note']=note
  return(x)
}

##
#### 1.3.4 sum_numeric_parts
sum_numeric_parts <- function(x){
  total=0
  for(i in x){if(is.numeric(i)) total=total+sum(i)}
  return(total)
}

##
## 1.4 data.frames
##
#### 1.4.1 my_data.frame
my_data.frame <- function(){
  d <- data.frame("id"=1:3, "name"=c("John","Lisa","Azra"), "income"=c(7.30,0.00,15.21), "rich"=c(FALSE, FALSE, TRUE))
  return(d)
}

##
#### 1.4.2 sort_head
sort_head <- function(df, var.name, n){
  head(df[order(-df[var.name]),],n)
}

##
#### 1.4.3 add_median_variable
add_median_variable <- function(df, j){
  median = median(df[[j]])
  df$compared_to_median=ifelse(df[[j]]>median,"Greater",ifelse(df[[j]]<median,"Smaller","Median"))
  return(df)
}

##
#### 1.4.4 analyze_columns
analyze_columns <- function(df,j){
  result = list()
  for(c_index in j){
    cn = colnames(df)[c_index]
    ndf = c("mean"=mean(df[[cn]]), "median"=median(df[[cn]]), "sd"=sd(df[[cn]]))
    result[[cn]] = ndf
  }
  result[["correlation_matrix"]] = cor(df[,j])
  return(result)
}
