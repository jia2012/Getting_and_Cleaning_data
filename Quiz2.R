library("sqldf")
path <- "C://Users//shearora//Downloads//getdata-data-ss06pid.csv"
acs <- read.csv(path,header=T,sep=",")
sqldf("select pwgtp1 from acs where AGEP <50")

hurl <- "http://biostat.jhsph.edu/~jleek/contact.html" 
con <- url(hurl)
print(con)
htmlcode <- readLines(con)
print(htmlcode)
close(con)
sapply(htmlcode[c(10,20,30,100)],nchar)

path2<-"C://Users//shearora//Downloads//getdata-wksst8110.for"
data <- read.csv(path2,header=T)
print(data)
df <- read.fwf(file=path2,widths=c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4), skip=4)
sum(df[, 4])
