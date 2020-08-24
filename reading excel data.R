#### Another more efficient package may be "xlsx", however I'm having issues intalling it on my computer right now due to issues with Java.

setwd("C:/Users/kanoe/Documents/Research Data/R files")
dir()

#f <- read.xls(file="my new aggregate.xlsx", sheet=1, blank.lines.skip=T)
#### this is slow, but reads in the first sheet, maybe...

f1 <- read.csv("sheet1 edit.csv", colClasses = c("character", "character", "character", "character", "numeric", "numeric", "NULL", "NULL"))
f2 <- read.csv("sheet2 edit.csv", colClasses = c("character", "character", "character", "character", "numeric", "numeric", "NULL", "NULL"))

f3 <- read.csv("sheet1 edit.csv", colClasses = c("character", "character", "character", "character", "numeric", "numeric", "NULL", "numeric"))
f4 <- read.csv("sheet2 edit.csv", colClasses = c("character", "character", "character", "character", "numeric", "numeric", "NULL", "numeric"))
dates1<-as.POSIXct(f3[,7] * (60*60*24)
           , origin="1900-01-01"
           , tz="UTC")
dates2<-as.POSIXct(f4[,7] * (60*60*24)
                   , origin="1900-01-01"
                   , tz="UTC")
data1 <- data.frame(datetime = dates1, transmitter=f1[,2], receiver=f1[,3], station=f1[,4], latitude=f1[,5], longitude=f1[,6])
data2 <- data.frame(datetime = dates2, transmitter=f2[,2], receiver=f2[,3], station=f2[,4], latitude=f2[,5], longitude=f2[,6])

f_full <- rbind(data1, data2)


write.csv(f_full, file="data.csv")
#save as csv
save(f_full, file="data.Rdata")
#save as a Rdata binary file which when loaded (using load() function), will automatically load back in as an R object


###### Explore the dataset
### time column needs to get fixed in excel

plot(unique(f_full[,5:6]))
map(add=T)
### can see there is river data, so this is sharks and sturgeon

##### Merging


load("ACTactive.rda")
#this loads in the file that contains the species information for ALL tags tagged by researchers that participate in the ACT Network
head(ACTactive)
active <- data.frame(ACTactive)
#this looks at the first 6 rows
sharktags <- data.frame(active[which(active[,15]=="Sand tiger shark"),])

detections_merge <- merge(f_full, sharktags, by.x="transmitter", by.y="Tag.ID.Code.Standard", all.x=T)
#this merges the detections and the tag metadata database using the common Transmitter ID
head(detections_merge)
tail(detections_merge)

sharkdetecs <- NULL
sharkdetecs <- detections_merge[which(!is.na(detections_merge["Common.Name"])),]

fulldetections <- data.frame(Date.Time = sharkdetecs[,2], Transmitter = sharkdetecs[,1], lat = sharkdetecs[,5], long = sharkdetecs[,6])
plot(unique(fulldetections[,3:4]))

dates_df <- data.frame(fulldetections["Date.Time"])

write.csv(sharkdetecs, file="fulldetections.csv")
write.csv(fulldetections, file="smalldetections.csv")
save(sharkdetecs, fulldetections, file="detection_data.Rdata")

ACTactive[which(ACTactive$Tag.ID.Code.Standard=="A69-1303-11594"),]


