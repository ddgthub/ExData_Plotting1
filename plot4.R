###################################################################
#### Exploratory Data Analysis - Coursera - Project 1 - Plot 4 ####
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
print("Reading the raw data, please wait...")

if(!file.exists("filtered.txt")) {
    ## Credit to Andreas from discussion forums for the grep part :) 
    rawfile <- file("household_power_consumption.txt", "r")
    cat(grep("(^Date)|(^[1|2]/2/2007)",readLines(rawfile), value=TRUE), sep="\n", file="filtered.txt")
    ## Remove raw unfiltered data from the environment
    close(rawfile)
}

## Building the dataframe from filtered file
elepc <- read.table("filtered.txt", header = TRUE, colClasses = "character", sep = ";", na.strings="?")

## Reverting to numeric
sm1 <- as.numeric(elepc$Sub_metering_1)
sm2 <- as.numeric(elepc$Sub_metering_2)
sm3 <- as.numeric(elepc$Sub_metering_3)
vol <- as.numeric(elepc$Voltage)
gap <- as.numeric(elepc$Global_active_power)
grp <- as.numeric(elepc$Global_reactive_power)

## Formating date and time
dat <- strptime(paste(elepc$Date, elepc$Time), format = "%d/%m/%Y %H:%M:%S")

## Setting the locale to ENG
Sys.setlocale("LC_TIME", "C") 

## Plotting - No need to specify dimensions as 480x480px is default; 
## Intentionally left background color white (also default) for legibility
## For my eyes 'antialias = "cleartype"' renders the font slightly better on PC

## When I changed my code to print directly to png device instead of using dev.copy(), 
## I was able to eliminate all the margin and legend tweaks (inset, interspace, etc...) 
## that I spent time playing with in order to make this plot look more as the one on the
## assignment page. By printing directly to png device the only necessary parameter was 
## mfrow = c(2, 2), even the png size came out 480x480px by default... :)

print("Graph building, please wait...")
png("plot4.png", antialias = "cleartype") 
par(mfrow = c(2, 2))
with(elepc, {
    ## subplot 1,1
    plot(dat, gap, type="l", xlab = " ", ylab = "Global Active Power")
    ## subplot 1,2
    plot(dat, vol, type="l", xlab = "datetime", ylab = "Voltage")
    ## subplot 2,1
    plot(dat, sm1, type = "n", xlab = " ", ylab = "Energy sub metering", lwd = 1)
        lines(dat, sm1, col = "black")
        lines(dat, sm2, col = "red")
        lines(dat, sm3, col = "blue")
        legend("topright", bty = "n", col = c("black","red","blue"), lwd = 1,
                c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    ## subplot 2,2
    plot(dat, grp, type="l", xlab = "datetime", ylab = "Global_reactive_power")    
})

## Closing the device
dev.off()