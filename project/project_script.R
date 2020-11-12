# Project Script

# load in packages for spatial data
library(sp)
library(rgdal)
library(dplyr)
# install.packages("rgeos")
library(rgeos)

# read in data
seaice <- readOGR("/Users/lindsaycanaday/Documents/sea_ice_all/sea_ice_all.shp")

# map data
plot(seaice)
head(seaice@data)
plot(seaice[seaice@data$year == 1979,])

# calculate area of sea ice extent for year
gArea(seaice[seaice@data$year == 1979,])
gArea(seaice[seaice@data$year == 2019,])

# create table of year and area
