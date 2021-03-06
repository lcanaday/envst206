# Activity 9

# install and load in packages
# install.packages(c("caret", "randomForest"))
# install.packages("e1071")
library(raster)
library(sp)
library(rgdal)
library(caret)
library(randomForest)
library(e1071)

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

# set up table with coordinates and data type (validate or train) for each point
landExtract <- data.frame(landcID = rep(seq(1,6),each=120),
                          x=c(algae@coords[,1],water@coords[,1],agri@coords[,1],built@coords[,1],forest@coords[,1],wetlands@coords[,1]),
                          y=c(algae@coords[,2],water@coords[,2],agri@coords[,2],built@coords[,2],forest@coords[,2],wetlands@coords[,2]))
# add sample type
landExtract$sampleType <- rep(sampleType, times=6)

# create id table that gives each landcover an ID
landclass <- data.frame(landcID = seq(1,6),
                        landcover = c("algal bloom", "open water", "agriculture", "built", "forest", "wetlands"))

# extract raster data at each point
rasterEx <- data.frame(extract(allbandsCloudf,landExtract[,2:3]))
# give names of bands
colnames(rasterEx) <- c("B2", "B3","B4","B5","B6","B7","B8","B11","B12")

# combine point information with raster information
dataAll <- cbind(landExtract,rasterEx)
# preview
head(dataAll)

# remove missing data
dataAlln <- na.omit(dataAll)

# subset into two different dataframes
trainD <- dataAlln[dataAlln$sampleType == "train",]
validD <- dataAlln[dataAlln$sampleType == "valid",]

# Kfold cross validation
tc <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

# random forests
rf.grid <- expand.grid(mtry=1:sqrt(9))

# train the random forest model to the sentinel-2 data
rf_model <- caret::train(x = trainD[,c(5:13)],
                         y = as.factor(trainD$landcID),
                         medthod = "rf",
                         metric = "Accuracy",
                         trainControl = tc,
                         tuneGrid = rf.grid)
# check output
rf_model

# change name in raster stack to match training data
names(allbandsCloudf) <- c("B2","B3","B4","B5","B6","B7","B8","B11","B12")
# apply random forest model to the sentinel-2 data
rf_prediction <- raster::predict(allbandsCloudf, model = rf_model)
# view predictions
plot(rf_prediction)

# landcover class names
landclass
# set up categorical colors
landclass$cols <- c("#a6d854","#8da0cb","#66c2a5","#fc8d62","#ffffb3","#ffd92f")
# make plot and hide legend
plot(rf_prediction,
     breaks=seq(0,6),
     col=landclass$cols,
     legend = FALSE, axes = FALSE)
legend("bottomleft", paste(landclass$landcover),
       fill=landclass$cols, bty = "n", horiz=TRUE)

# get validation data from raster by extracting
rf_Eval <- extract(rf_prediction, validD[,2:3])

# make the confusion matrix
rf_errorM <- confusionMatrix(as.factor(rf_Eval),as.factor(validD$landcID))
# add landcover names
colnames(rf_errorM$table) <- landclass$landcover
rownames(rf_errorM$table) <- landclass$landcover
# view the matrix
rf_errorM$table
# look at the overall accuracy
rf_errorM$overall
