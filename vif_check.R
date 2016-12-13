
#Using divusa dataset from faraway package
library(faraway)
data(divusa)
head(divusa)

#Removing 1st column from divusa dataset
mydata <- data.frame(divusa[,-1])
head(mydata)

round(cor(mydata),2)

#Multiple Linear Regression Model
mymodel <- lm(divorce~., mydata)
summary(mymodel)

#Assessing multicollinearity using Variance Inflation Factor (VIF)
vif(mymodel)

