# Project Script

# load in packages for spatial data
library(sp)
library(rgdal)
library(dplyr)

# read in data
seaice <- readOGR("/Users/lindsaycanaday/Documents/sea_ice_all/sea_ice_all.shp")

# map data
plot(seaice)
head(seaice@data)
plot(seaice[seaice@data$year == 1979,])
