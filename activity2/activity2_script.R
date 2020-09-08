# Activity 2
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
fcvec <- c("North", "Carnegie", "Milbank", "Minor", "Eels")
factor(fcvec)
