library(RColorBrewer)
library(ncdf4)
library(fields)
library(lubridate)
library(dplyr)
library(Rfast)
library(ggplot2)

setwd("C:/Users/kanoe/Documents/Research Data/Introsems/Shark_project")

load("shark data/full_detections_2005-2020.Rdata")
#Migration timing
male <- sharks_meta[sharks_meta$sex == "male", ]
female <- sharks_meta[sharks_meta$sex == "female", ]
unknown <- sharks_meta[sharks_meta$sex == "unknown",]

sharks_meta %>% group_by(sex) %>% ggplot(aes(sex, lat)) + geom_boxplot()

#check against yearly sst in South

#avg time of departing south by year

#merge with earlier year dataset

#look for individuals with north and south detections
#choose a threshhold

lat_range <- range(sharks_meta$Latitude)
num_range <- 6
interval <- (lat_range[2] - lat_range[1]) / num_range
sharks_meta <- sharks_meta[,-6]
for(num in 1:length(sharks_meta[,1])) {
  sharks_meta[num,"category"] <- 
    (sharks_meta$lat <= lat_range[1] + (interval * num)) &&
    (sharks_meta$lat >= lat_range[1] + ((num-1) * interval))
}

sharks_meta1 <- sharks_meta %>% mutate(category = floor((Latitude - lat_range[1]) / interval) + 1)
sharks_meta1[sharks_meta1$category == 7, "category"] <- 6
sharks_meta <- sharks_meta1
sharks_meta <- sharks_meta[,c(1,2,4,5,32)]
sharks_meta <- sharks_meta[order(sharks_meta$Date),]


moving_periods <- sharks_meta %>% group_by(Transmitter) %>% 
  mutate(on_the_move = c((diff(Date) <= 40), FALSE), degree_diff = c(diff(lat), 0), date_diff = c(diff(Date), 0)) %>% 
  filter(on_the_move == T, ((degree_diff != 0) & (date_diff / degree_diff) > 3)) %>% ungroup()

count_by_month <- moving_periods %>% group_by(year, month) %>% summarize(count = n(), total_degrees = sum(degree_diff)) %>% ungroup() 
lat_by_month <- count_by_month %>% group_by(month) %>% summarize(count = sum(count), total_degrees = sum(total_degrees))


sharks_meta$DateandTime <- as.Date(sapply(sharks_meta$DateandTime, function(x) strsplit(x, " ")[[1]][1]))
sharks_meta$DateandTime <- as.Date(sharks_meta$DateandTime)

sharks_meta$year <- lubridate::year(sharks_meta$DateandTime)
sharks_meta$month <- lubridate::month(sharks_meta$DateandTime)
sharks_meta$day <- lubridate::day(sharks_meta$DateandTime)

sharks_meta$category <- as.factor(sharks_meta$category)
#plot by receiver and year(find continuous coverage)
lats_by_time <- sharks_meta %>% group_by(year, month, category) %>% summarize(count = n())
lats_by_time %>% ggplot(aes(category, fill = month)) + geom_bar()
sum_time <- lats_by_time %>% group_by(category, month, year) %>% mutate(pct1 = sum(category == 1), pct2 = sum(category == 2), 
                                                                  pct3 = sum(category == 3), pct4 = sum(category == 4),
                                                                  pct5 = sum(category == 5), pct6 = sum(category == 6))

histo <- sharks_meta %>% ggplot(aes(Latitude, color = month)) + geom_histogram(binwidth = 1)
histo

scatter <- lats_by_time %>% group_by(category) %>% ggplot(aes(month, count, color = category)) + geom_point()
scatter
#find when receivers start 