library(data.table)
setwd("/Users/shearora/insts/Getting_and_Cleaning_data/data")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
f <- file.path(getwd(), "ss06hid.csv")
download.file(url, f,method="curl")
dt <- data.table(read.csv(f))
varNames <- names(dt)
print(varNames)
varNamesSplit <- strsplit(varNames,"wgtp")
varNamesSplit[[123]]
##############################################
##############################################

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- file.path(getwd(), "GDP.csv")
download.file(url, f,method="curl")
dtGDP <- data.table(read.csv(f, skip = 4, nrows = 215, stringsAsFactors = FALSE))
head(dt)
varNames <- names(dt)
print(varNames)
dtGDP <- dtGDP[X!=""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", "Long.Name", "gdp"))
gdp <- as.numeric(gsub(",", "", dtGDP$gdp))
mean(gdp, na.rm = TRUE)

##############################################
##############################################
isUnited <- grepl("^United", dtGDP$Long.Name)
summary(isUnited)

###############################################
###############################################

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f <- file.path(getwd(), "EDSTATS_Country.csv")
download.file(url, f, method="curl")
dtEd <- data.table(read.csv(f))
dt <- merge(dtGDP, dtEd, all = TRUE, by = c("CountryCode"))
head(dt)
print(names(dt))
print(names(dtGDP))
dt<-merge(dtGDP,dtEd,all = TRUE,by = c("CountryCode"))
head(dt)
print(names(dt))
head(dt$Special.Notes)
isFiscalYearEnd <- grepl("fiscal year end", tolower(dt$Special.Notes))
isJune <- grepl("june", tolower(dt$Special.Notes))
table(isFiscalYearEnd, isJune)
#####################################################
####################################################

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
print(names(amzn))
sampleTimes =index(amzn)
print(sampleTimes)
data <- table(year(sampleTimes),weekdays(sampleTimes))
head(data)
addmargins(data)
