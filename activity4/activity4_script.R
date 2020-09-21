# Activity 4

# read in beaver dam data
datB <- read.csv("/Users/lindsaycanaday/Documents/a04/beaver_dam.csv")
head(datB)

# scatter plot beaver dams vs surface water
plot(datB$dams.n, datB$area.ha,
     pch = 19,
     col = "royalblue4",
     ylab = "Surface water area (ha)",
     xlab = "Number of beaver dams")

## Q1 - pch argument options

# set up regression
dam.mod <- lm(datB$area.ha ~ datB$dams.n)
# get standardized residuals
dam.res <- rstandard(dam.mod)

# check assumptions
# set up qq plot
qqnorm(dam.res)
# add qq line
qqline(dam.res)

# shapiro test
shapiro.test(dam.res)

# make residual plot
plot(datB$dams.n, dam.res,
     xlab = "beaver dams",
     ylab = "standardized residual")
# add horizontal line at zero
abline(h=0)

## Q2 - interpreting regression results
# print out regression table
summary(dam.mod)

# plot with regression line
plot(datB$dams.n, datB$area.ha,
     pch = 19,
     col = "royalblue4",
     ylab = "Surface water area (ha)",
     xlab = "Number of beaver dams")
# add line, thicker width
abline(dam.mod, lwd = 2)

# read in leaf out data
pheno <- read.csv("/Users/lindsaycanaday/Documents/a04/red_maple_pheno.csv")

# set up panel of plots
par(mfrow = c(1,2))
plot(pheno$Tmax, pheno$doy,
     pch = 19,
     col = "royalblue4",
     ylab = "Day of leaf out",
     xlab = "Maximum tenperature (C)")
plot(pheno$Prcp, pheno$doy,
     pch = 19,
     col = "royalblue4",
     ylab = "Day of leaf out",
     xlab = "Precipitation (mm)")
dev.off()

# siteDesc as factor
pheno$siteDesc <- as.factor(pheno$siteDesc)

## Q3 - plots of multiple variables
# plots for latitude, elevation, max temp, and urban/rural
par(mfrow = c(2,2))
plot(pheno$Lat, pheno$doy,
     pch = 19,
     col = "royalblue4",
     ylab = "Day of leaf out",
     xlab = "Latitude")
plot(pheno$elev, pheno$doy,
     pch = 19,
     col = "royalblue4",
     ylab = "Day of leaf out",
     xlab = "Elevation (m)")
plot(pheno$Tmax, pheno$doy,
     pch = 19,
     col = "royalblue4",
     ylab = "Day of leaf out",
     xlab = "Maximum temperature (C)")
plot(pheno$doy ~ pheno$siteDesc,
     ylab = "Day of leaf out",
     xlab = "Site type")
dev.off()

## Q4 - check for multi-collinearity
plot(~ pheno$Lat + pheno$Tmax + pheno$Tmin + pheno$Prcp + pheno$elev + pheno$siteDesc)

## Q5 - ifelse function to code site type
pheno$urID <- ifelse(pheno$siteDesc == "Urban", 1, 0)

# set up multiple regression
mlr <- lm(pheno$doy ~ pheno$Tmax + pheno$Prcp + pheno$elev + pheno$urID)
# calculate fitted values
mlFitted <- fitted(mlr)
# get standardized residuals
mlr.res <- rstandard(mlr)

## Q6 - check assumptions for multiple regression
# check normality
qqnorm(mlFitted)
qqline(mlFitted)
# make residual plot
plot(mlFitted, mlr.res,
     xlab = "day of leaf out",
     ylab = "standardized residual")
abline(h=0)

## Q7, Q8, Q8 - interpreting regression results
# print out regression table
summary(mlr)
