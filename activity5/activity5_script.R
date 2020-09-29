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

