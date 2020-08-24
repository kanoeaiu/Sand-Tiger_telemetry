library(RColorBrewer)
library(ncdf4)
library(fields)
library(lubridate)
library(dplyr)

setwd("C:/Users/kanoe/Documents/Research Data/Introsems/Shark_project")

load("data/detection_data.Rdata")
sharks <- unique(fulldetections$Transmitter)
groups <- data.frame(sharks, x=0)
for (n in 1:length(sharks)) {
  templist <- which(fulldetections$Transmitter==sharks[n])
  range <- range(fulldetections[which(fulldetections$Transmitter == groups[n,1]),3])
  # uniques? : (unique(fulldetections[templist,3:4]))
  if(length(unique(fulldetections[templist,3])) < 5) {
    groups[n,2] = -1
  }
  else if((range[2] - range[1]) < 2) {
    groups[n,2] = -2
  }
  else {
    if (length(which(fulldetections[templist,3] < 35) > 0)) {
      groups[n,2] = 1
    }
    #try 39.22
    if (length(which(fulldetections[templist,3] > 39.3) > 0)){
      groups[n,2] = groups[n,2] + 2
    }
  }
}

which(groups[,2] == 3)
which(groups[,2] == 0)
length(which(groups[,2] == -2))

south <- which(groups[,2] == 1)
north <- which(groups[,2] == 2)

#-------------------------------#

f <- nc_open("ETOPO1_Ice_g_gmt4.grd")
bath_lon <- ncvar_get(f, "x")
bath_lat <- ncvar_get(f, "y")
bath <- ncvar_get(f, "z")
nc_close(f)


bathy_cols <- rev(brewer.pal(n = 9, name = "Blues"))
#try as.POSIX of as.character of the datetimes instead
sub_bath_lat <- 0
sub_bath_lon <- 0
sub_land <- 0

mons <- month(fulldetections$Date.Time)
mon.cols <- c("red","blue","green","pink","purple","orange","yellow","lightblue","salmon", "cornflowerblue", "grey", "black")

upper_sharks <- groups[which(groups[,2] == 2),1]
lower_sharks <- groups[which(groups[,2] == 1),1]



for(i in 1:2){
  if(i == 1) {
    list <- upper_sharks
  } else {
    list <- lower_sharks
  }
  
  ind <- which(fulldetections$Transmitter %in% list)
  
  lons <- fulldetections$long[ind]
  lats <- fulldetections$lat[ind]
  
  mons.ind <- mons[ind]
  
  lat_ind <- which(bath_lat <= (max(lats)+1) & bath_lat >= (min(lats)-1))
  lon_ind <- which(bath_lon <= (max(lons)+1) & bath_lon >= (min(lons)-1))
  sub_bath_lat <- bath_lat[lat_ind]
  sub_bath_lon <- bath_lon[lon_ind]
  
  sub_bath <- bath[lon_ind,lat_ind]
  
  sub_depth<- replace(sub_bath, sub_bath>0, NA) #replace land pixels with NA’s so they are not plotted
  
  sub_land<-replace(sub_bath, sub_bath>0, 1)
  sub_land<-replace(sub_land, sub_land<0, NA)
  
  png(paste("group", i, ".png", sep=""), height=800, width=800)
  #bitmap
  
  image.plot(sub_bath_lon, sub_bath_lat, sub_depth, zlim=c(-100,0),col=bathy_cols, xlab="Lon", ylab="Lat", las=1, main=list) #reduce range of depths plotted to help color the plot better
  image(sub_bath_lon, sub_bath_lat, sub_land, col="grey", add=T) #add land mask to plot
  
  points(lons, lats, pch=16, cex=1.5, col=mon.cols[mons.ind])
  
  legend("bottomright", pch=16, legend=month.name,pt.cex=1.5, col=mon.cols, bg="white")
  
  dev.off()
  
}

range(fulldetections[fulldetections$Transmitter == groups[98,1],]$lat)

early_data <- read.csv("all_sts_with_metadata.csv")
