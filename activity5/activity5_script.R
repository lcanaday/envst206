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

## Q1 - only years with >= 364 observations
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

## Q3 and Q4 - plot mean annual max temp ny vs nd
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

# install ggplot2 package
install.packages("ggplot2")
# load package into session
library(ggplot2)

## Q5 - example precip ggplot with updated colors
#install color brewer package
install.packages("RColorBrewer")
# load package into session
library(RColorBrewer)
# see color options
display.brewer.all()
# example choose colors
brewer.pal(5, "Set2")
# plot
ggplot(data = pr, aes(x = year, y = totalP, color = NAME))+
  geom_point(alpha=0.75)+
  geom_path(alpha=0.75)+
  labs(x = "year", y = "Annual Precipitation")+
  theme_classic()+
  scale_color_manual(values = c("#66C2A5", "#FC8D62", "#8DA0CB", "#A6D854", "#E78AC3"))

# violin plot minimum temps
ggplot(data = datW, aes(x=NAME, y=TMIN))+
  geom_violin(fill=rgb(0.933,0.953,0.98))+
  geom_boxplot(width=0.2, size=0.25, fill="grey90")+
  theme_classic()
# daily patterns within year az 1974
sub <- datW[datW$NAME == nameS[4] & datW$year == 1974,]

## Q6 - indicate data/format as date
sub$DATE <- as.Date(sub$DATE, "%Y-%m-%d")

## Q7 - plots for mormon az 1974
# example plot with dates
ggplot(data=sub, aes(x=DATE, y=TMAX))+
  geom_point()+
  geom_path()+
  theme_classic()+
  labs(x="year", y="Maximum temperature (C)")
# example plot for precip
ggplot(data=sub, aes(x=DATE, y=PRCP))+
  geom_col(fill="royalblue3")+
  theme_classic()+
  labs(x="year", y="Daily precipitation (mm)")

## Q8 - plots to compare to Q7
# daily patterns within year for aberdeen wa 1974
sub.wa <- datW[datW$NAME == nameS[1] & datW$year == 1974,]
# indicate data as date
sub.wa$DATE <- as.Date(sub.wa$DATE, "%Y-%m-%d")
# max temp plot aberdeen
ggplot(data=sub.wa, aes(x=DATE, y=TMAX))+
  geom_point()+
  geom_path()+
  theme_classic()+
  labs(title=nameS[1], x="year", y="Maximum temperature (C)")
# precip plot for aberdeen
ggplot(data=sub.wa, aes(x=DATE, y=PRCP))+
  geom_col(fill="royalblue3")+
  theme_classic()+
  labs(title=nameS[1], x="year", y="Daily precipitation (mm)")

## Q9 - daily min temps since 2000
# get min temp data for one site since 2000
tmin <- datW[datW$NAME == nameS[1] & datW$year >= 2000,]
# indicate data as date
tmin$DATE <- as.Date(tmin$DATE, "%Y-%m-%d")
# scatterplot, daily min temp by year aberdeen
ggplot(data=tmin, aes(x=DATE, y=TMIN))+
  geom_point(size=0.5)+
  geom_path(size=0.5, alpha=0.5)+
  theme_classic()+
  labs(title=nameS[1], x="year", y="Minimum temperature (C)")
