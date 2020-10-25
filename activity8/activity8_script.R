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

## Q5 - NDVI
# calculate NDVI
# NIR-red/(NIR + red)
NDVI <- (rdatB8 - rdatB4)/(rdatB8 + rdatB4)
# visualize NDVI
plot(NDVI)

# read in landcover points data
algae <- readOGR(paste0(dirR,"/Oneida/algae.shp"), verbose=FALSE)
agri <- readOGR(paste0(dirR,"/Oneida/agriculture.shp"), verbose=FALSE)
forest <- readOGR(paste0(dirR,"/Oneida/forest.shp"), verbose=FALSE)
water <- readOGR(paste0(dirR,"/Oneida/water.shp"), verbose=FALSE)
wetlands <- readOGR(paste0(dirR,"/Oneida/wetlands.shp"), verbose=FALSE)

# plot points and true color
plotRGB(rgbS, stretch="lin", maxpixels=2297430)
plot(algae, add=TRUE, col=rgb(0.5,0.5,0.5,0.5), pch=19)
plot(agri, add=TRUE, col=rgb(0.75,0.5,0.5,0.5), pch=19)
plot(forest, add=TRUE, col=rgb(0.75,0.75,0.25,0.5), pch=19)
plot(water, add=TRUE, col=rgb(0.33,0.75,0.75,0.5), pch=19)
plot(wetlands, add=TRUE, col=rgb(0.33,0.33,0.65,0.5), pch=19)
legend("bottomleft", c("algae", "agri", "forest", "water", "wetlands"),
       pch=19, col=c(rgb(0.5,0.5,0.5,0.5),rgb(0.75,0.5,0.5,0.5),col=rgb(0.75,0.75,0.25,0.5),
                     rgb(0.33,0.75,0.75,0.5),col=rgb(0.33,0.33,0.65,0.5)),
       bty="n", cex=0.75)

## Q6 - extracting coordinate data
# set up dataframe with all point coordinates
landExtract <- data.frame(landcID = as.factor(rep(c("algae","water", "agri", "forest", "wetlands"), each=120)),
                          x=c(algae@coords[,1],water@coords[,1],agri@coords[,1],forest@coords[,1],wetlands@coords[,1]),
                          y=c(algae@coords[,2],water@coords[,2],agri@coords[,2],forest@coords[,2],wetlands@coords[,2]))

# stack all bands
allbands <- stack(rdatB2, rdatB3, rdatB4, rdatB8)/10000
# add raster reflectance values to point coordinates
# extract(raster, matrix of coordinates)
ExtractOut <- raster::extract(allbands, landExtract[2:3])
# name the bands
colnames(ExtractOut) <- c("B02", "B03", "B04", "B08")
# combine original data with coordinates with the raster data
rasterEx <- cbind(landExtract,ExtractOut)
#look at data
head(rasterEx)

# scatterplot of reflectance B02 vs B03
ggplot(data=rasterEx, aes(x=B02, y=B03, color=landcID))+
  geom_point(alpha=0.6)+
  theme_classic()

## Q7 - plots for each band vs NIR
# B02 vs NIR
ggplot(data=rasterEx, aes(x=B02, y=B08, color=landcID))+
  geom_point(alpha=0.6)+
  theme_classic()
# B03 vs NIR
ggplot(data=rasterEx, aes(x=B03, y=B08, color=landcID))+
  geom_point(alpha=0.6)+
  theme_classic()
# B04 vs NIR
ggplot(data=rasterEx, aes(x=B04, y=B08, color=landcID))+
  geom_point(alpha=0.6)+
  theme_classic()

## Q8 - extract values for landcover points, violin/boxplot
# extract values
ndviExtract <- raster::extract(NDVI, landExtract[2:3])
ndviEX <- cbind(landExtract,ndviExtract)
colnames(ndviEX) <- c("Landcover", "x", "y", "NDVI")
# violin boxplot of NDVI within agri, forest, wetlands
ggplot(data = ndviEX[ndviEX$Landcover == c("agri","forest","wetlands"), ], aes(x=Landcover, y=NDVI))+
  geom_violin(fill=rgb(0.933,0.953,0.98))+
  geom_boxplot(width=0.2, size=0.25, fill="grey90")+
  theme_classic()

## Q9 - does NDVI differ between groups


