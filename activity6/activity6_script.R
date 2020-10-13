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

# format of data
str(g2015)
# map glaciers 1966
plot(g1966, col = "lightblue2", border = "grey50")
# preview data glaciers 2015
head(g2015@data)

## Q1 - look up projection and datum
# projection info
g1966@proj4string

# check glacier names
g1966@data$GLACNAME
g2015@data$GLACNAME
# fix glacier names for consistency
g2015@data$GLACNAME <- ifelse(g2015@data$GLACNAME == "North Swiftcurrent Glacier",
                              "N. Swiftcurrent Glacier",
                              ifelse(g2015@data$GLACNAME == "Miche Wabun",
                                     "Miche Wabun Glacier",
                                     as.character(g2015@data$GLACNAME)))
