
library(RODBC)

wubs <- odbcConnect("Rstudio")
sqlTables(wubs)
sqlColumns(wubs,"VOL_6")
sqlPrimaryKeys(wubs,"VOL_6")

data1 <- sqlQuery(wubs,"SELECT TURNOVER, log(turnover) as log_turnover FROM VOL_6
where client_id= 170924 and turnover>0", believeNRows=FALSE)
data1

dim(data1)
x <- data1$LOG_TURNOVER
hist(x,breaks=100,main = " distribution of 170924	")

