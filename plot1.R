###################################################################
#### Exploratory Data Analysis - Coursera - Project 1 - Plot 1 ####
###################################################################

## Check if there is a raw data file and download it if necessary
if(!file.exists("raw_data.zip")) {
    print("Downloading raw data, please wait as it may take a while depending on your connection... :)")
    url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url,"raw_data.zip", method = "curl", mode = "wb")
}

## Unzip the raw data file if the text file is not there
print("Unzipping the raw data, please wait...")
if(!file.exists("household_power_consumption.txt")) {
    unzip("raw_data.zip")
}


## Read the raw data and subset only the dates we need
print("Reading the raw data, please wait...")
raw_data <- read.table("household_power_consumption.txt", header = TRUE, colClasses = "character", sep = ";", na.strings="?")

elepc <- raw_data[raw_data$Date == "1/2/2007" | raw_data$Date == "2/2/2007",]

## Remove raw data from the environment
rm(raw_data)

## Reverting Global_active_power to numeric
gap <- as.numeric(elepc$Global_active_power)


## Plotting the histogram
print("Building a plot, please wait...")

par(bg = NA, cex = 0.8)
hist(gap, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

## Copying the histogram to a png file of specified dimensions
dev.copy(png, "plot1.png", height = 480, width = 480)

## Closing the device
dev.off()