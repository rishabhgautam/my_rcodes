
# assign rodbc library to connect to server
library(RODBC)

wubs <- odbcConnect("Rstudio")

#list down all the tables in the database
sqlTables(wubs)

# to get the list of all columns
sqlColumns(wubs,"TRANSACTIONSFACT")

# To get primary key of a particular table in R
sqlPrimaryKeys(wubs,"TRANSACTIONSFACT")

# Running SQL query in R
sqlQuery(wubs,"SELECT * FROM TGBP_DW.DBAUSER.EMPLOYEE LIMIT 5")

# Close the channel once you are done
odbcClose(wubs)

ds <- file.choose()

