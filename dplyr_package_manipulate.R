
# Date : 21st Nov, 2016
# Owner : Rishabh Gautam
# Usefulness of Dplyr package in R.

install.packages("dplyr")
library(dplyr)

# 1. select() 	select columns
# 2. filter() 	filter rows
# 3. arrange() 	re-order or arrange rows
# 4. mutate() 	create new columns
# 5. summarise() 	summarise values
# 6. group_by() 	allows for group operations in the "split-apply-combine" concept

# Just have a look at the data.
iris
names(iris)
head(iris)

# 1.
# select is used to select only few columns.
select(iris, Sepal.Length, Sepal.Width)

# starts_with() = Select columns that start with a character string
select(iris, starts_with("Pe"))

# ends_with() = Select columns that end with a character string
select(iris, ends_with("es"))

# contains() = Select columns that contain that particular string
select(iris, contains("es"))

# matches() = Select columns that match a regular expression
select(iris, matches("pal"))

# one_of() = Select columns names that are from a group of names
vars <- c("Petal.Length", "Petal.Width")
select(iris, one_of(vars))

# 2.
# filter() allows you to select a subset of rows in a data frame
filter(iris, Species == "virginica", Species == "virginica")
filter(iris, Species == "virginica" | Species == "virginica")
filter(iris, Species == "virginica" & Species == "virginica")

# slice function is used to select lots of rows in one go.
slice(iris, 1:10)

# 3. 
# arrange will do the same work as sort.
arrange(iris, Sepal.Length)
arrange(iris, desc(Sepal.Length))

# 3.1
iris1 <- iris
# rename is used to rename variables in dataframe.
rename(iris1, newname1= oldname1, newname2=newname1)

# 3.2
# distinct is used to select unique records from a column.
distinct(iris1, Species)

# 4.
# mutate is used to add new columns in a dataframe.
iris2 <- mutate( iris, new_Sepal.Length=Sepal.Length/2)
head(iris2)

## mutate and transform are almost the same. The only difference is that
## mutate allows you to use the newly created variable in the same step,
## while transform does not allow you to use this.

transmute(iris1, var1=Sepal.Length*Sepal.Width, var2= var1/100)

# 5.
# summarise is used to summarise values of column in a dataframe.
summarise((iris), mean_sepal_len = mean(Sepal.Length, na.rm = TRUE))
summarise((iris), sum_sepal_len = sum(Sepal.Length, na.rm = TRUE))
summarise(iris, first_ob = first(Sepal.Length))
summarise(iris, last_ob = last(Sepal.Length))
summarise(iris, total_obs = n())
summarise(iris, n_distinct(Species))

# 5.1
# sample_n is used to sample fixed number of obs.
# sample_frac is used to sample a fixed fraction of total obs.
sample_n(iris, 10)
sample_frac(iris, 0.1)

# 6.
# group_by() is used to group as per specified vars. Same as SQL.
grouping_Species <- group_by(iris, Species)

# 7.
# Joins using "DPLYR" package in R
# Left join 
left_join(a,b,by="x1")
# Right join
right_join(a,b,by="x1")
# Inner Join
inner_join(a,b,by="x1")
# Full Join
full_join(a,b,by="x1")
# Semi Join. All rows in a having match in b
semi_join(a,b,by="x1")
# Anti Join. All rows in a not having match in b
anti_join(a,b,by="x1")
# Intersect of a and b
intersect(a,b)
# Union of a and b
union(a,b)
# all values of a having match in b
setdiff(a,b)

# binding by rows
bind_rows(x,y)
# binding by cols
bind_cols(x,y)

