# Activity 3

# read in lemming data
ch4 <- read.csv("/Users/lindsaycanaday/Documents/a03/lemming_herbivory.csv")
# change herbivory to factor
ch4$herbivory <- as.factor(ch4$herbivory)

# boxplot of ch4 fluxes by treatment
plot(ch4$CH4_Flux ~ ch4$herbivory, xlab = "Treatment", ylab = "CH4 fluxes (mgC m -2 day-1)")

# test normality of data in each treatment
# shapiro-wilk test on ctl plots
shapiro.test(ch4$CH4_Flux[ch4$herbivory == "Ctl"])
# shapiro-wilk test on ex plots
shapiro.test(ch4$CH4_Flux[ch4$herbivory == "Ex"])

# test equal variance
# bartlett test
bartlett.test(ch4$CH4_Flux ~ ch4$herbivory)

## Q1 - two sample t test for CH4 flux and herbivory
t.test(ch4$CH4_Flux ~ ch4$herbivory)

## Q2 - one sided t test arguments
help(t.test)
# example one-sided t test
t.test(ch4$CH4_Flux ~ ch4$herbivory, mu = 0, alternative = "less")

# read in insect data
datI <- read.csv("/Users/lindsaycanaday/Documents/a03/insect_richness.csv")
# change urbanName to factor
datI$urbanName <- as.factor(datI$urbanName)
levels(datI$urbanName)

## Q4 - test assumptions of anova for insect data
# test normality of data in each group
# shapiro-wilk test on dense
shapiro.test(datI$Richness[datI$urbanName == "Dense"])
# shapiro-wilk test on developed
shapiro.test(datI$Richness[datI$urbanName == "Developed"])
# shapiro-wilk test on natural
shapiro.test(datI$Richness[datI$urbanName == "Natural"])
# shapiro-wilk test on suburban
shapiro.test(datI$Richness[datI$urbanName == "Suburban"])
# test equal variance
# bartlett test
bartlett.test(datI$Richness ~ datI$urbanName)

# boxplot of richness data by group to visualize data
plot(datI$Richness ~ datI$urbanName, xlab = "Urban Environment Type", ylab = "Richness")

## Q6 - running anova test on insect data and assigning letters
# specify model for species richness and urban type
in.mod <- lm(datI$Richness ~ datI$urbanName)
# run the ANOVA
in.aov <- aov(in.mod)
# print ANOVA table
summary(in.aov)
# posthoc test to verify differences
# run Tukey HSD
tukeyT <- TukeyHSD(in.aov)
# view results
tukeyT
# plot Tukey HSD results
# make axes labels smaller to fit
plot(tukeyT, cex.axis = 0.5)

## Q7 - calculate means across factor data
tapply(datI$Richness, datI$urbanName, "mean")

# chi-squared goodness of fit test
# set up contingency table
species <- matrix(c(18, 8, 15, 32), ncol = 2, byrow = TRUE)
colnames(species) <- c("Not protected", "Protected")
rownames(species) <- c("Declining", "Stable/Increasing")
# mosaic plot
mosaicplot(species, xlab = "Population Status", ylab = "Legal Protection", main = "Legal protection impacts on population")

## Q8 - expected values under null
mean(18, 8, 15, 32)

## Q9 - chi-squared test
chisq.test(species)
