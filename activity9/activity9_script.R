# Activity 9

# install and load in packages
# install.packages(c("caret", "randomForest"))
library(raster)
library(sp)
library(rgdal)
library(caret)
library(randomForest)

# set up directory for oneida data folder
dirR <- "/Users/lindsaycanaday/Documents/a08/oneida"
# read in sentinel data
rdatB2 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B02_20m.tif"))
rdatB3 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B03_20m.tif"))
rdatB4 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B04_20m.tif"))
rdatB5 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B05_20m.tif"))
rdatB6 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B06_20m.tif"))
rdatB7 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B07_20m.tif"))
rdatB8 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B08_20m.tif"))
rdatB11 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B11_20m.tif"))
rdatB12 <- raster(paste0(dirR,"/sentinel/T18TVN_20190814T154911_B12_20m.tif"))
clouds <- raster(paste0(dirR,"/sentinel/MSK_CLDPRB_20m.tif"))

# stack all raster data
allbands <- stack(rdatB2,rdatB3,rdatB4,rdatB5,rdatB6,rdatB7,rdatB8,rdatB11,rdatB12,clouds)

# read in validation data
algae <- readOGR(paste0(dirR,"/Oneida/algae.shp"), verbose=FALSE)
agri <- readOGR(paste0(dirR,"/Oneida/agriculture.shp"), verbose=FALSE)
built <- readOGR(paste0(dirR,"/Oneida/built.shp"), verbose=FALSE)
forest <- readOGR(paste0(dirR,"/Oneida/forest.shp"), verbose=FALSE)
water <- readOGR(paste0(dirR,"/Oneida/water.shp"), verbose=FALSE)
wetlands <- readOGR(paste0(dirR,"/Oneida/wetlands.shp"), verbose=FALSE)

# create function called clouds F
cloudsF <- function(rast){ifelse(rast > 60,NA,1)}
CloudFlag <- calc(allbands[[10]], cloudsF)

# multiply all bands by cloudflag raster
allbandsCloud <- list()
for(i in 1:9){allbandsCloud[[i]] <- CloudFlag*allbands[[i]]}
# new stack
allbandsCloudf <- stack(allbandsCloud[[1]],allbandsCloud[[2]],allbandsCloud[[3]],allbandsCloud[[4]],allbandsCloud[[5]],allbandsCloud[[6]],allbandsCloud[[7]],allbandsCloud[[8]],allbandsCloud[[9]])
# sample plot one band
plot(allbandsCloudf[[1]])

# randomly choose 60 elements in the vector with set seed
set.seed(12153)
sample(seq(1,120),60)

# set seed
set.seed(12153)
# randomly select the data in each set to be used
sampleType <- rep("train", 120)
# samples to randomly convert to validation data
sampleSamp <- sample(seq(1,120),60)
# convert these random samples from training to validation
sampleType[sampleSamp] <- "valid"

