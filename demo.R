#set directory here
setwd("C:/Users/kapel/workspace/QC_MATH_342W_Spring_2024/labs")
#we will generate all the help files now before installing the package
pacman::p_load(roxygen2)
roxygenise("QCbasementGBM", clean = TRUE)
#now run "R CMD INSTALL QCbasementGBM" from terminal to create the package

#now we can load it like any other package from CRAN even though it sits locally on our machine:
options(java.parameters = "-Xmx8000m") #remember to give JAVA some RAM first...
pacman::p_load(QCbasementGBM)

#we can look at the help files
?QCbasementGBM::gbm_fit
?QCbasementGBM::gbm_all_predictions
?QCbasementGBM::predict.qc_basement_gbm
?QCbasementGBM::print.qc_basement_gbm

#now we can actually use it to fit (see lab 11)
set.seed(1)
n = 100
p = 3
X = matrix(rnorm(n * p), nrow = n)
bbeta = seq(-1, 1, length.out = p)
y = c(X %*% bbeta + rnorm(n))
y_binary = rbinom(n, 1, 1 / (1 + exp(-X %*% bbeta)))
X = data.frame(X)

#very simple...
g_b = gbm_fit(X, y)
yhats = predict(g_b, X) #canonical R invocation!
head(yhats)

pacman::p_load(ggplot2)
ggplot(data.frame(y = y, yhat = predict(g_b, X))) + aes(x = y, y = yhat) + geom_point()
y_hats_by_m = gbm_all_predictions(g_b, X)
rmses_by_m = apply(y_hats_by_m, 2, function(y_hat){sqrt(mean((y - y_hat)^2))})
rmses_by_m

#now if we want to submit it to CRAN
#we first build it as a compressed file
#R CMD build QCbasementGBM
#then we check it for CRAN checks
#R CMD check --as-cran QCbasementGBM
#if it passes (it doesn't for a whole bunch of reasons), 
#you can upload it to: https://cran.r-project.org/submit.html

