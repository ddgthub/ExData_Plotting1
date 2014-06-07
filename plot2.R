###################################################################
#### Exploratory Data Analysis - Coursera - Project 1 - Plot 2 ####
###################################################################

## Check if there is a raw data file and download it if necessary
if(!file.exists("raw_data.zip")) {
    print("Downloading raw data, please wait as it may take a while depending on your connection... :)")
    url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url,"raw_data.zip", method = "curl", mode = "wb")
}

## Unzip the raw data file if the text file is not there
if(!file.exists("household_power_consumption.txt")) {
    print("Unzipping the raw data, please wait...")
    unzip("raw_data.zip")
}

## Read the raw data and grep away only the dates we need
if(!file.exists("filtered.txt")) {
    print("Reading the raw data, please wait...")
    ## Credit to Andreas from discussion forums for the grep part :) 
    rawfile <- file("household_power_consumption.txt", "r")
    cat(grep("(^Date)|(^[1|2]/2/2007)",readLines(rawfile), value=TRUE), sep="\n", file="filtered.txt")
    ## Remove raw unfiltered data from the environment
    close(rawfile)
}

## Building the dataframe from filtered file
elepc <- read.table("filtered.txt", header = TRUE, colClasses = "character", sep = ";", na.strings="?")

## Reverting Global_active_power to numeric
gap <- as.numeric(elepc$Global_active_power)

## Formating date and time
dat <- strptime(paste(elepc$Date, elepc$Time), format="%d/%m/%Y %H:%M:%S")

## Setting the locale to ENG
Sys.setlocale("LC_TIME", "C")

## Plotting - No need to specify dimensions as 480x480px is default; 
## Intentionally left background color white (also default) for legibility
## For my eyes 'antialias = "cleartype"' renders the font slightly better on PC
print("Graph building, please wait...")
png("plot2.png", antialias = "cleartype")
with(elepc, plot(dat, gap, type="l", xlab = "", ylab = "Global Active Power (kilowatts)"))

## Closing the device
dev.off()