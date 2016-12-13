
#create training and validation data from given data
install.packages('caTools')
library(caTools)
attach(mtcars)
dim(mtcars)

set.seed(500)
split <- sample.split(mtcars$mpg, SplitRatio = 0.70)

#get training and test data
mtcars.train <- subset(mtcars, split == TRUE)
mtcars.test <- subset(mtcars, split == FALSE)

mtcars.train
mtcars.test

dim(mtcars.train)
dim(mtcars.test)


