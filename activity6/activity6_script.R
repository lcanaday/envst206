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

## Q2,3,4 - looking at glacier data with satellite imagery (no code)

## Q5,6 - gAll output, joining tables
# combine area, smaller data frame
gdf66 <- data.frame(GLACNAME = g1966@data$GLACNAME,
                   area66 = g1966@data$Area1966)
gdf15 <- data.frame(GLACNAME = g2015@data$GLACNAME,
                    area15 = g2015@data$Area2015)
# join all data tables by glacier name
gAll <- full_join(gdf66, gdf15, by = "GLACNAME")

## Q7 - percent change plot
# calculate % change in area from 1966 to 2015
gAll$gdiff <- ((gAll$area66-gAll$area15)/gAll$area66)*100
# plot area66 vs diff
plot(gAll$area66, gAll$gdiff,
     xlab = "Glacier Area 1966 (m^2)",
     ylab = "Percent Change 1966 to 2015")

# join data with spatial data table and overwrite into spatial data table
g1966@data <- left_join(g1966@data, gAll, by = "GLACNAME")
# spplot to shade polygons based on % change
spplot(g1966, "gdiff", main = "% change in area", col = "transparent")

# subset spatial data
# look at vulture glacier in 1966
vulture66 <- g1966[g1966@data$GLACNAME == "Vulture Glacier", ]
plot(vulture66, main = "Vulture Glacier in 1966", col = "slategray")

## Q8 - describing glacial loss in Glacier National Park
# mean and stddev of % loss
mean(g1966$gdiff)
sd(g1966$gdiff)
# glaciers w/ largest and smallest % loss
max(g1966$gdiff)
g1966$GLACNAME[g1966$gdiff == max(g1966$gdiff)]
g1966$area66[g1966$gdiff == max(g1966$gdiff)]
min(g1966$gdiff)
g1966$GLACNAME[g1966$gdiff == min(g1966$gdiff)]
g1966$area66[g1966$gdiff == min(g1966$gdiff)]
# % loss of glaciers w/ largest and smallest 1966 area
max(g1966$area66)
g1966$GLACNAME[g1966$area66 == max(g1966$area66)]
g1966$gdiff[g1966$area66 == max(g1966$area66)]
min(g1966$area66)
g1966$GLACNAME[g1966$area66 == min(g1966$area66)]
g1966$gdiff[g1966$area66 == min(g1966$area66)]

## Q9 - footprint maps of glaciers with largest and smallest % loss
# look at glacier w/ max % loss in 1966
maxloss66 <- g1966[g1966@data$gdiff == max(g1966$gdiff),]
# join data w/ spatial data in 2015
g2015@data <- left_join(g2015@data, gAll, by = "GLACNAME")
# look at glacier w/ max % loss in 2015
maxloss15 <- g2015[g2015@data$gdiff == max(g2015$gdiff),]
# plot glacier with max loss
plot(maxloss66, col="slategray",
     main = "Boulder Glacier extent:
     greatest % loss between 1966 and 2015")
plot(maxloss15, col="tomato3", add=TRUE)
legend("topright",
       c("1966", "2015"),
       col = c("slategray", "tomato3"),
       pch = 19,
       bty = "n")
# look at glacier w/ min % loss in 1966
minloss66 <- g1966[g1966@data$gdiff == min(g1966$gdiff),]
# look at glacier w/ min % loss in 2015
minloss15 <- g2015[g2015@data$gdiff == min(g2015$gdiff),]
# plot glacier with min loss
plot(minloss66, col = "slategray",
     main = "Pumpelly Glacier extent:
     smallest % loss between 1966 and 2015")
plot(minloss15, col = "tomato3", add=TRUE)
legend("topright",
       c("1966", "2015"),
       col = c("slategray", "tomato3"),
       pch = 19,
       bty = "n")
