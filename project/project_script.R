# Project Script

# load in packages for spatial data
library(sp)
library(rgdal)
library(dplyr)
# install.packages("rgeos")
library(rgeos)

# read in data
seaice <- readOGR("/Users/lindsaycanaday/Documents/sea_ice_all/sea_ice_all.shp")

# calculate area of sea ice extent for year
area <- c(gArea(seaice[seaice@data$year == 1979,]),gArea(seaice[seaice@data$year == 1980,]),
          gArea(seaice[seaice@data$year == 1981,]),gArea(seaice[seaice@data$year == 1982,]),
          gArea(seaice[seaice@data$year == 1983,]),gArea(seaice[seaice@data$year == 1984,]),
          gArea(seaice[seaice@data$year == 1985,]),gArea(seaice[seaice@data$year == 1986,]),
          gArea(seaice[seaice@data$year == 1987,]),gArea(seaice[seaice@data$year == 1988,]),
          gArea(seaice[seaice@data$year == 1989,]),gArea(seaice[seaice@data$year == 1990,]),
          gArea(seaice[seaice@data$year == 1991,]),gArea(seaice[seaice@data$year == 1992,]),
          gArea(seaice[seaice@data$year == 1993,]),gArea(seaice[seaice@data$year == 1994,]),
          gArea(seaice[seaice@data$year == 1995,]),gArea(seaice[seaice@data$year == 1996,]),
          gArea(seaice[seaice@data$year == 1997,]),gArea(seaice[seaice@data$year == 1998,]),
          gArea(seaice[seaice@data$year == 1999,]),gArea(seaice[seaice@data$year == 2000,]),
          gArea(seaice[seaice@data$year == 2001,]),gArea(seaice[seaice@data$year == 2002,]),
          gArea(seaice[seaice@data$year == 2003,]),gArea(seaice[seaice@data$year == 2004,]),
          gArea(seaice[seaice@data$year == 2005,]),gArea(seaice[seaice@data$year == 2006,]),
          gArea(seaice[seaice@data$year == 2007,]),gArea(seaice[seaice@data$year == 2008,]),
          gArea(seaice[seaice@data$year == 2009,]),gArea(seaice[seaice@data$year == 2010,]),
          gArea(seaice[seaice@data$year == 2011,]),gArea(seaice[seaice@data$year == 2012,]),
          gArea(seaice[seaice@data$year == 2013,]),gArea(seaice[seaice@data$year == 2014,]),
          gArea(seaice[seaice@data$year == 2015,]),gArea(seaice[seaice@data$year == 2016,]),
          gArea(seaice[seaice@data$year == 2017,]),gArea(seaice[seaice@data$year == 2018,]),
          gArea(seaice[seaice@data$year == 2019,]))
# vector of years
year <- c(1979,1980,1981,1982,1983,1984,
           1985,1986,1987,1988,1989,1990,
           1991,1992,1993,1994,1995,1996,
           1997,1998,1999,2000,2001,2002,
           2003,2004,2005,2006,2007,2008,
           2009,2010,2011,2012,2013,2014,
           2015,2016,2017,2018,2019)
# create table of year and area
yeararea <- data.frame(year,area)
plot(yeararea)
