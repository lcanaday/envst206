# Activity 5
# read in weather data
datW <- read.csv("/Users/lindsaycanaday/Documents/a05/noaa2011124.csv")
# specify name column as factor
datW$NAME <- as.factor(datW$NAME)
# set up vector of names
nameS <- levels(datW$NAME)
nameS

# dataframe with just precip, year, site
# remove missing
datP <- na.omit(data.frame(NAME=datW$NAME,
                           year=datW$year,
                           PRCP=datW$PRCP))
# total annual precip (mm)
precip <- aggregate(datW$PRCP, by=list(datW$NAME, datW$year), FUN="sum", na.rm=TRUE)
# rename columns
colnames(precip) <- c("NAME", "year", "totalP")
# add x column from aggregate for length of observations from each year
precip$ncount <- aggregate(datP$PRCP, by=list(datP$NAME, datP$year), FUN="length")$x
# new dataframe only years with >=364 observations
pr <- precip[precip$ncount >=364, ]
# look at only livermore and morrisville precip
ca <- pr[pr$NAME == nameS[2], ]
ny <- pr[pr$NAME == nameS[5], ]
# plot of ca precip
plot(ca$year, ca$totalP)

## Q2 - general trends in annual precip ca vs ny
# improve plot of ca precip
plot(ca$year, ca$totalP,
     type = "b",
     pch = 19,
     ylab = "Annual precipitation (mm)",
     xlab = "Year",
     yaxt = "n",
     ylim = c(0, 1600),
     main = "Trends in Annual Precipitation")
# add y axis
# arguments axis number (1 bottom, 2 left, 3 top, 4 right)
# las = 2 changes the labels to be read horizontal
axis(2, seq(0,1600, by=400), las=2)
# add ny to existing plot
points(ny$year, ny$totalP,
       type = "b",
       pch = 19,
       col = "tomato3")
# add legend
legend("topleft",
       c("California", "New York"),
       col = c("black", "tomato3"),
       pch = 19,
       lwd = 1,
       bty = "n")

## Q3 - plot mean annual max temp ny vs nd
# dataframe with just max temp, year, site
# remove missing
datT <- na.omit(data.frame(NAME=datW$NAME,
                           year=datW$year,
                           TMAX=datW$TMAX))
# mean annual max temp
maxtemp <- aggregate(datT$TMAX, by=list(datT$NAME, datT$year), FUN="mean", na.rm=TRUE)
# rename columns
colnames(maxtemp) <- c("NAME", "year", "TMAX")
# add column ncount
maxtemp$ncount <- aggregate(datT$TMAX, by=list(datT$NAME, datT$year), FUN="length")$x
# new dataframe only years >=364 observations
mt <- maxtemp[maxtemp$ncount >= 364, ]
# look only at morrisville and mandan
mny <- mt[mt$NAME == nameS[5], ]
mnd <- mt[mt$NAME == nameS[3], ]
# plot of mny mean annual max temp
plot(mny$year, mny$TMAX,
     type = "b",
     pch = 19,
     ylab = "Mean annual maximum temperature (C)",
     xlab = "Year",
     main = "Trends in Mean Annual Maximum Temperature",
     yaxt = "n",
     ylim = c(8,15))
axis(2, seq(8,15, by=1), las=2)
points(mnd$year, mnd$TMAX,
       type = "b",
       pch = 19,
       col = "tomato3")
legend("bottomright",
       c("Morrisville, NY", "Mandan, ND"),
       col = c("black", "tomato3"),
       pch = 19,
       lwd = 1,
       bty = "n")
