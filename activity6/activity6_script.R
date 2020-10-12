# Activity 6

# install packages
# install.packages(c("sp", "rgdal", "dplyr"))
# package for vector data
library(sp)
# package for reading in spatial data
library(rgdal)
# data management package
library(dplyr)

# read in shapefiles
g1966 <- readOGR("/Users/lindsaycanaday/Documents/a06/GNPglaciers/GNPglaciers_1966.shp")
g2015 <- readOGR("/Users/lindsaycanaday/Documents/a06/GNPglaciers/GNPglaciers_2015.shp")
