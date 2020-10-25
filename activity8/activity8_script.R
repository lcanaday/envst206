# Activity 8

# install and load in packages
# install.packages("raster")
library(raster)
library(ggplot2)
library(rgdal)

# set up directory for oneida data folder
dirR <- "/Users/lindsaycanaday/Documents/a08/oneida"
# read in sentinel data
rdatB2 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B02_20m.tif"))
rdatB3 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B03_20m.tif"))
rdatB4 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B04_20m.tif"))
rdatB8 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B08_20m.tif"))

# plot blue light
plot(rdatB2/10000)

# stack red green blue
rgbS <- stack(rdatB4, rdatB3, rdatB2)/10000
# view raster stack, scale is 2 for some blue reflectance above 1
plotRGB(rgbS, scale=2)

## Q1 and Q2 - resolution and features
# add contrast and full resolution
plotRGB(rgbS, stretch="lin", maxpixels=rgbS@nrows*rgbS@ncols)

## Q3 - number of cells
# calculate number of cells in raster
rgbS@nrows*rgbS@ncols

## Q4 - false color map
# stack all bands
allS <- stack(rdatB8, rdatB4, rdatB3, rdatB2)/10000
# plot false color image
plotRGB(allS, stretch="lin", maxpixels=allS@nrows*allS@ncols)
