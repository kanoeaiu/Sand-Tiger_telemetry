setwd("C:/Users/kanoe/Documents/Research Data/Introsems/Shark_project")

load("shark data/detection_data.Rdata")
#break up by year
fulldetections$year <- lubridate::year(fulldetections$Date.Time)
fulldetections$month <- lubridate::month(fulldetections$Date.Time)

sharks_by_year <- fulldetections %>% group_by(year, Transmitter) %>% 
  summarize(lat_min = range(lat)[1], lat_max = range(lat)[2], mean_lat = mean(lat), lat_sd = sd(lat), num_detecs = n())

shark_stats <- sharks_by_year %>% group_by(year) %>% 
  summarize(mean = mean(mean_lat), min = min(lat_min), max = max(lat_max), num_detecs = sum(num_detecs))

fulldetections <- unique(fulldetections)
#break up by age/gender metadata -- is age correlated to size?
meta1 <- read.csv("other data/tagging_information_fordh_all.csv", stringsAsFactors = F)
meta2 <- read.csv("other data/STS_tagging_for_DH_transmitters.csv", stringsAsFactors = F)
meta3 <- read.csv("other data/STS_tagging_for_Danielle.csv")
meta4 <- read.csv("other data/STS_acoustics1_for danielle.csv")
meta5 <- read.csv("other data/STS_acoustics2_for danielle.csv")

# meta1 <- meta1[,c("acoustic_tag_number", "sex")]
# colnames(meta1) <- c("tag.number", "sex")
# meta2 <- meta2[,c("acoustic_tag_number", "sex")]
# colnames(meta2) <- c("tag.number", "sex")
# meta3 <- meta3[,c("acoustic_tag_number", "sex")]
# colnames(meta3) <- c("tag.number", "sex")
# meta4 <- meta4[,c("Acoustic.tag.number", "Sex")]
# colnames(meta4) <- c("tag.number", "sex")
# meta5 <- meta5[,c("Acoustic.tag.number", "Sex")]
# colnames(meta5) <- c("tag.number", "sex")

#metadata <- rbind(meta1, meta2, meta3, meta4, meta5)
#remove(meta1, meta2, meta3, meta4, meta5)
sharkdetecs <- unique(sharkdetecs)
sharkdetecs <- sharkdetecs[,1:6]

early_dat <- read.csv("shark data/all_sts_with_metadata.csv")
metadata <- early_dat[,-c(1,3,4,5,6)]
metadata <- unique(metadata)

#find receiver name here
early_dat <- early_dat[,2:6]

colnames(early_dat)
colnames(sharkdetecs)
colnames(sharkdetecs) <- c("Transmitter", "DateandTime", "Station", "Latitude", "Longitude")

full_sharks <- rbind(sharkdetecs, early_dat)

sharks_meta <- merge(full_sharks, metadata, by.x = "Transmitter", by.y = "Tag.ID.Code.Standard")

save(sharks_meta, file = "shark data/full_detections_2005-2020.Rdata")
write.csv(sharks_meta, file = "shark data/full_detections_2005-2020.csv")

length(which(is.na(sharks_meta$sex)))
length(which(sharks_meta$sex == ""))