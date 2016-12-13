
# Outlier Treatment methods in R.
# Dataset : cars
# Owner : Rishabh Gautam

View(cars)
nrow(cars)

cars1 <- cars[1:30, ]  # original data

# Inject outliers into data.
cars_outliers <- data.frame(speed=c(19,19,20,20,20), dist=c(190, 186, 210, 220, 218))  # introduce outliers.
cars2 <- rbind(cars1, cars_outliers)  # data with outliers.

View(cars2)

# Plot of data with outliers.
par(mfrow=c(1, 2))
plot(cars2$speed, cars2$dist, xlim=c(0, 28), ylim=c(0, 230), main="With Outliers", xlab="speed", ylab="dist", pch="*", col="red", cex=2)
abline(lm(dist ~ speed, data=cars2), col="blue", lwd=3, lty=2)
# Plot of original data without outliers. Note the change in slope (angle) of best fit line.
plot(cars1$speed, cars1$dist, xlim=c(0, 28), ylim=c(0, 230), main="Outliers removed \n A much better fit!", xlab="speed", ylab="dist", pch="*", col="red", cex=2)
abline(lm(dist ~ speed, data=cars1), col="blue", lwd=3, lty=2)


# Ways to Detect Outliers

# 1. Univariate approach
# For a given continuous variable, outliers are those observations that 
# lie outside 1.5*IQR, where IQR, the 'Inter Quartile Range' is the difference between 75th and 25th quartiles. 

outlier_values <- boxplot.stats(cars2$dist)$out  # outlier values.
boxplot(cars2$dist, main="Distance", boxwex=0.1)
mtext(paste("Outliers: ", paste(outlier_values, collapse=", ")), cex=0.6)

# 2. Bivariate approach
# Visualize in box-plot of the X and Y, for categorical X's
url <- "http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv"
ozone <- read.csv(url)

# For categorical variable
boxplot(ozone_reading ~ Month, data=ozone, main="Ozone reading across months")  
boxplot(ozone_reading ~ Day_of_week, data=ozone, main="Ozone reading for days of week")  

# For continuous variable (convert to categorical if needed.)
boxplot(ozone_reading ~ pressure_height, data=ozone, main="Boxplot for Pressure height (continuos var) vs Ozone")
boxplot(ozone_reading ~ cut(pressure_height, pretty(ozone$pressure_height)), data=ozone, main="Boxplot for Pressure height (categorial) vs Ozone", cex.axis=0.5)

# 3. Multivariate Model Approach

# Cook's Distance
# Cook's distance is a measure computed with respect to a given 
# regression model and therefore is impacted only by the X variables 
# included in the model. But, what does cook's distance mean? 
# It computes the influence exerted by each data point (row) on the 
# predicted outcome.

# The cook's distance for each observation i measures the change in Y Y^
# (fitted Y) for all observations with and without the presence of observation i, 
# so we know how much the observation i impacted the fitted values.

mod <- lm(ozone_reading ~ ., data=ozone)
cooksd <- cooks.distance(mod)

# Influence measures
# In general use, those observations that have a cook's distance greater 
# than 4 times the mean may be classified as influential. This is not a hard boundary.

plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 4*mean(cooksd, na.rm=T), col="red")  # add cutoff line
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels

# Cook's D plot
# identify D values > 4/(n-k-1)
cutoff <- 4/((nrow(ozone)-length(mod$coefficients)-2))
plot(mod, which=4, cook.levels=cutoff)


# 4. Outliers Test
# The function outlierTest from car package gives the most extreme 
# observation based on the given model.

car::outlierTest(mod)
#This output suggests that observation in row 243 is most extreme.

