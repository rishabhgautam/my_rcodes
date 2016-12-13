
setwd("C:/Users/rishabh98459/Downloads")

data <- read.csv("vehicle.csv", header= T)
View(data)
head(data)

library(dplyr)
data1 <- select(data, lc,lh, Mileage)
round(cor(data1),2)

# running full model.
mymodel <- lm(lc~Mileage+lh, data= data1)
summary(mymodel)

mymodel1 <- lm(lc~lh, data= data1)
summary(mymodel1)

anova(mymodel,mymodel1)

