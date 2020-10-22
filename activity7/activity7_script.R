# Activity 7

## Q4 - read in calfire data
fires <- read.csv("/Users/lindsaycanaday/Documents/calfire/mapdataall.csv")
air <- read.csv("/Users/lindsaycanaday/Documents/calfire/ad_viz_plotval_data.csv")

## Q5 - summary statistics and plot
mean(fires$incident_acres_burned[fires$incident_county == "Alameda"])
sd(fires$incident_acres_burned[fires$incident_county == "Alameda"])
# histogram of fire incidents in Alameda by acres burned
hist(fires$incident_acres_burned[fires$incident_county == "Alameda"],
     xlab = "Acres Burned",
     main = "Fire Incidents in Alameda County")
