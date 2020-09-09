# Activity 2
# vector example: tree heights m
heights <- c(30, 41, 20, 22)
# convert to cm
heights_cm <- heights*100
heights_cm
# subsetting: look at specific tree heights
# first height
heights[1]
# second through third height
heights[2:3]

# matrix example: info
help(matrix)
# 2 columns fill by row
Mat <- matrix(c(1, 2, 3, 4, 5, 6), ncol=2, byrow=TRUE)
Mat
# 2 columns fill by column
Mat.bycol <- matrix(c(1, 2, 3, 4, 5, 6), ncol=2, byrow=FALSE)
Mat.bycol
# subsetting: look at specifc spots
# row 1 col 2
Mat.bycol[1,2]
# all row 1
Mat.bycol[1,]
# all col 2
Mat.bycol[,2]

# read in weather station file
datW <- read.csv("/Users/lindsaycanaday/Documents/a02/noaa2011124.csv")

# Q1 - info about datW
str(datW)

# reassign site names as factors
datW$NAME <- as.factor(datW$NAME)

# Q2 - example vectors
# character vector
chvec <- c("yes", "no", "no", "maybe", "no")
# numeric vector
nmvec <- c(4.2, 6.7, 5.4, 34.6, 87)
# integer vector
invec <- c(4, 5, 6, 7, 8)
# factor vector
fcvec <- factor(c("North", "Carnegie", "Milbank", "Minor", "Eels"))

# site names
levels(datW$NAME)
# mean max temp for Aberdeen: removed missing observations
mean(datW$TMAX[datW$NAME == "ABERDEEN, WA US"], na.rm=TRUE)
# stddev of max temp for Aberdeen: removed missing observations
sd(datW$TMAX[datW$NAME == "ABERDEEN, WA US"], na.rm=TRUE)
# calculate average daily temp: create new column
datW$TAVE <- datW$TMIN + ((datW$TMAX - datW$TMIN)/2)
# mean temp across all sites: use aggregate function
averageTemp <- aggregate(datW$TAVE, by=list(datW$NAME), FUN="mean", na.rm=TRUE)
averageTemp
# change column names for output
colnames(averageTemp) <- c("NAME", "MAAT")
averageTemp
# convert level to number for factor data
datW$siteN <- as.numeric(datW$NAME)

# histogram for first site in levels
hist(datW$TAVE[datW$siteN == 1],
     freq = FALSE,
     main = paste(levels(datW$NAME)[1]),
     xlab = "Average daily temperature (degrees C)",
     ylab = "Relative frequency",
     col = "grey75",
     border = "white")
# look up hist funtion arguments
help(hist)

# Q4 - histogram for different weather station
hist(datW$TAVE[datW$siteN == 2],
     freq = FALSE,
     main = paste(levels(datW$NAME)[2]),
     xlab = "Average daily temperature (degrees C)",
     ylab = "Relative frequency",
     col = "grey75",
     border = "white")
curve(dnorm(x,
      mean = mean(datW$TAVE[datW$siteN == 2], na.rm = TRUE),
      sd = sd(datW$TAVE[datW$siteN == 2], na.rm = TRUE)),
      add = TRUE, col = "red")


