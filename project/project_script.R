# Project Script

# load in packages for spatial data
library(sp)
library(rgdal)
library(dplyr)
# install.packages("rgeos")
library(rgeos)
# install.packages("Kendall")
library(Kendall)

# read in data
seaice <- readOGR("/Users/lindsaycanaday/Documents/sea_ice_all/sea_ice_all.shp")

# calculate area of sea ice extent for each year
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

# plot year vs area
plot(yeararea, main = "Area of Sea Ice Extent from 1979 to 2019",
     xlab = "Year", ylab = "Area (m^2)")
abline(lm(yeararea$area ~ yeararea$year))

# trend of area over time
# Mann-Kendall test
MannKendall(yeararea$area)

# find years with max and min area
# max
yeararea$year[yeararea$area == max(yeararea$area)]
# min
yeararea$year[yeararea$area == min(yeararea$area)]
# plot overlay of max and min area
plot(seaice[seaice$year == 1996,], col="slategrey", main = "Greatest Difference in Sea Ice Extent
     Between 1979 and 2019")
plot(seaice[seaice$year == 2012,], col="tomato3", add=TRUE)
legend("bottomright", c("1996", "2012"),
       col = c("slategray","tomato3"),
       pch = 19, bty = "n")

# table with lagged differences
areadiff <- data.frame(year,area,c(NA,diff(area, lag=1)))
