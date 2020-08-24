library(fields)
library(dplyr)
library(xml2)
library(VTrack)
library(dplyr)
library(XML)

setwd("C:/Users/kanoe/Documents/Research Data/Introsems/Shark_project")

load("shark data/full_detections_2005-2020.Rdata")
sharks_meta <- unique(sharks_meta[,c(1,2,4,5)])
#fix station names

rename <- unique(sharks_meta[,c("Latitude", "Longitude")])
rename$Station <- NA
for(num in 1:length(rename[,1])) {
  rename[num,3] <- paste0("station", num)
}

rename$Station <- sapply(rename$Station, as.factor)

lapply(replace, class)
lapply(others, class)

rename$receiver <- sapply(rename$Station, function(x) paste0("VR2W-", as.numeric(x)))
sharks_meta <- merge(sharks_meta, rename, by = c("Latitude", "Longitude"))
lapply(sharks_meta, class)


vtrack_df <- data.frame("timestamp" = sharks_meta$DateandTime, "STATIONNAME" = sharks_meta$Station, 
                        "latitude" = sharks_meta$Latitude, "longitude" = sharks_meta$Longitude, 
                        "RECEIVERID" = sharks_meta$receiver, "tag.ID" = sharks_meta$Transmitter, "species" = NA,
                        "uploader" = NA, "transmitterid" = NA)


vtrack_df$transmitterid <- do.call(rbind,strsplit(as.character(sharks_meta$Transmitter), split="-"))[,3]
vtrack_df$tag.ID <- vtrack_df$transmitterid
vtrack_df <- ReadInputData(infile = vtrack_df)

sharks_meta <- sharks_meta[order(sharks_meta$DateandTime),]
vtrack_df$STATIONNAME <- sharks_meta$Station

colnames(rename)
colnames(rename) <- c("LATITUDE", "LONGITUDE", "STATION", "RECEIVER")
sharks_vtrack <- merge(vtrack_df[,1:4], rename, by)


sharks_array <- unique(sharks_meta[,c("Station", "Latitude", "Longitude")])
colnames(sharks_array) <- c("LOCATION", "LATITUDE", "LONGITUDE")
sharks_array$LOCATION <- gsub(" ", ".", sharks_array$LOCATION)
sharks_array <- sharks_array %>% filter(!is.na(sharks_array$LOCATION))
sharks_array$RADIUS <- 500

lapply(sharks_array, class)
sharks_array <- na.omit(sharks_array)
sharks_array <- unique(sharks_array)
sharks_array <- sharks_array %>% filter(!duplicated(LATITUDE, LONGITUDE))

shark_array_dm <- GenerateDirectDistance(sharks_array)

sharka <- ExtractData(vtrack_df, sQueryTransmitterList = c(transmitters[5]))
transmitters <- ExtractUniqueValues(vtrack_df, 2)
stations <- ExtractUniqueValues(vtrack_df, 6)


shark_rs <- RunResidenceExtraction(sharka, "STATIONNAME", 2, 60 * 60 * 12, shark_array_dm)
res <- shark_rs$residences
nonres <- shark_rs$nonresidences
