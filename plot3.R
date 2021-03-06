library(dplyr)
library(lubridate)

# Initialize some initial values
targetFolder <- 'household_power_consumption'
zfilename <- 'household_power_consumption.zip'
filename <- 'household_power_consumption.txt'

# check if the user has already the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists(targetFolder)){
        if(!file.exists(zfilename)){
                download.file(fileUrl, zfilename)
        }
        if(!file.exists(filename)){
                unzip(zfilename)
        }}

# load the file
data <- read.table(filename,sep = ";", header = TRUE, 
                   stringsAsFactors = FALSE, na.strings = "?")

# change data types 
data <- mutate(data, datetime = paste(Date,Time))
data$datetime <- as.POSIXct(strptime(data$datetime,"%d/%m/%Y %H:%M:%S "))
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# filter the dataset 
data.wanted <- data %>%
        filter(year(datetime) == 2007, month(datetime) == 2) %>% 
        filter(day(datetime) == 1 | day(datetime) == 2) %>% 
        arrange(datetime)

# make the plot and save as png file
png('plot3.png', width = 480, height = 480)
with(data.wanted, plot(datetime,Sub_metering_1,type='n',
                       xlab = '',ylab = 'Energy sub metering'))
with(data.wanted, lines(datetime, Sub_metering_1, col = 'black'))
with(data.wanted, lines(datetime, Sub_metering_2, col = 'red'))
with(data.wanted, lines(datetime, Sub_metering_3, col = 'blue'))        
legend("topright", lty=1, col =c('black','red','blue'),
       legend = c('Sub_metering_1','Sub_metering_2','Sub_metering_3'))
dev.off()
