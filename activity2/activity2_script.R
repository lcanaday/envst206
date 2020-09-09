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
fcvec

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

# Q3 - look up hist funtion arguments
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
      mean(datW$TAVE[datW$siteN == 2], na.rm = TRUE),
      sd(datW$TAVE[datW$siteN == 2], na.rm = TRUE)),
      add = TRUE, col = "red")

# get info on normal distribution related functions
help(dnorm)
# pnorm is specified value and BELOW
# pnorm below freezing temps at Aberdeen
pnorm(0,
      mean(datW$TAVE[datW$siteN == 1], na.rm = TRUE),
      sd(datW$TAVE[datW$siteN == 1], na.rm = TRUE))
# pnorm below 5 degrees
pnorm(5,
      mean(datW$TAVE[datW$siteN == 1], na.rm = TRUE),
      sd(datW$TAVE[datW$siteN == 1], na.rm = TRUE))
# pnorm between 0-5 degrees
pnorm(5,
      mean(datW$TAVE[datW$siteN == 1], na.rm = TRUE),
      sd(datW$TAVE[datW$siteN == 1], na.rm = TRUE)) - pnorm(0,
      mean(datW$TAVE[datW$siteN == 1], na.rm = TRUE),
      sd(datW$TAVE[datW$siteN == 1], na.rm = TRUE))
# pnorm above 20 = 1 - pnorm below 20
1 - pnorm(20,
          mean(datW$TAVE[datW$siteN == 1], na.rm = TRUE),
          sd(datW$TAVE[datW$siteN == 1], na.rm = TRUE))
# qnorm is value at which that and below occur at specified probability
# qnorm 95%, unusual high temps start at output value
highthresh <- qnorm(0.95,
      mean(datW$TAVE[datW$siteN == 1], na.rm = TRUE),
      sd(datW$TAVE[datW$siteN == 1], na.rm = TRUE))
highthresh

# Q5 - increase mean temp by 4 in Aberdeen, stddev constant, probability of temps above current high threshold
1 - pnorm(highthresh,
          4 + mean(datW$TAVE[datW$siteN == 1], na.rm = TRUE),
          sd(datW$TAVE[datW$siteN == 1], na.rm = TRUE))

# Q6 - histogram of daily precip in Aberdeen
hist(datW$PRCP[datW$siteN == 1],
     freq = FALSE,
     main = paste(levels(datW$NAME)[1]),
     xlab = "Daily precipitation (mm)",
     ylab = "Relative frequency",
     col = "darkblue",
     border = "black")

# Q7 - total annual precip for each year and site
PRCPAN <- aggregate(datW$PRCP, by=list(datW$NAME, datW$year), FUN="sum", na.rm=TRUE)
PRCPAN
# rename columns
colnames(PRCPAN) <- c("NAME", "YEAR", "ANPRCP")
PRCPAN
# reassign site names as factor
PRCPAN$NAME <- as.factor(PRCPAN$NAME)
levels(PRCPAN$NAME)
# convert level to number for factor
PRCPAN$siteN <- as.numeric(PRCPAN$NAME)

# Q8 - histogram of annual precip for Aberdeen and Mandan Station
# Aberdeen
hist(PRCPAN$ANPRCP[PRCPAN$siteN == 1],
     freq = FALSE,
     main = paste(levels(PRCPAN$NAME)[1]),
     xlab = "Annual precipitation (mm)",
     ylab = "Relative Frequency",
     col = "purple",
     border = "black")
curve(dnorm(x,
            mean(PRCPAN$ANPRCP[PRCPAN$siteN == 1], na.rm = TRUE),
            sd(PRCPAN$ANPRCP[PRCPAN$siteN == 1], na.rm = TRUE)),
      add = TRUE, col = "black")
# Mandan Station
hist(PRCPAN$ANPRCP[PRCPAN$siteN == 3],
     freq = FALSE,
     main = paste(levels(PRCPAN$NAME)[3]),
     xlab = "Annual precipitation (mm)",
     ylab = "Relative Frequency",
     col = "orange",
     border = "white")
curve(dnorm(x,
            mean(PRCPAN$ANPRCP[PRCPAN$siteN == 3], na.rm = TRUE),
            sd(PRCPAN$ANPRCP[PRCPAN$siteN == 3], na.rm = TRUE)),
      add = TRUE, col = "blue")

# Q9 - how likely is a year w/ 700 mm or less precip?
# Aberdeen
pnorm(700,
      mean(PRCPAN$ANPRCP[PRCPAN$siteN == 1], na.rm = TRUE),
      sd(PRCPAN$ANPRCP[PRCPAN$siteN == 1], na.rm = TRUE))
# Mandan Station
pnorm(700,
      mean(PRCPAN$ANPRCP[PRCPAN$siteN == 3], na.rm = TRUE),
      sd(PRCPAN$ANPRCP[PRCPAN$siteN == 3], na.rm = TRUE))
