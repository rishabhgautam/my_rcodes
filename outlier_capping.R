
# outlier treatment in R.
# Owner : Rishabh Gautam

# To correct outlier problem, we can winsorise extreme values. 
# Winsorize at the 1st and 99th percentile means values that are 
# less than the value at 1st percentile are replaced by the value 
# at 1st percentile, and values that are greater than the value at 
# 99th percentile are replaced by the value at 99th percentile.

########################################################
# R Function for Outlier Treatment : Percentile Capping
########################################################

mtcars
# lets take the data mtcars and variable disp.

data1 <- mtcars
dim(data1)

hist(data1$disp)
quantile(data1$disp, c(0.00,0.01,0.05, 0.10, 0.90, 0.95,0.99,1)) 

pcap <- function(x){
  for (i in which(sapply(x, is.numeric))) {
    quantiles <- quantile( x[,i], c(.05, .95 ), na.rm =TRUE)
    x[,i] = ifelse(x[,i] < quantiles[1] , quantiles[1], x[,i])
    x[,i] = ifelse(x[,i] > quantiles[2] , quantiles[2], x[,i])}
  x}

# Replacing extreme values with percentiles
abcd = pcap(data1)

# Checking Percentile values of 3rd variable i.e. disp
quantile(abcd[,3], c(0.00,0.01,0.05, 0.10, 0.90, 0.95,0.99,1), na.rm = TRUE)

