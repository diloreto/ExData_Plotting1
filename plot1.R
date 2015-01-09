# Winter 2015
# Coursera Course EXTDATA 010
# Anthony DiLoreto
# Project 1 - Househouse usage
# plot1.R

# We only want records from 1/2/2007 - 2/2/2007
# In unix, using head, tail, and sed, found that those records
# exist in the household_power_consumption.txt file on lines 66638 - 69518 (2880 total)
# Instead of bringing in all 2MM + records, only import those rows as a dataframe
# Note that in this dataset missing values are coded as ?.

df <- read.table("household_power_consumption.txt", header = TRUE, na.strings ="?", sep = ";", quote="\"", skip=grep("1/2/2007", readLines("household_power_consumption.txt")), nrows=2880)

# even though we specified 'header=TRUE', header names were still ommitted due to skipping
# add them back in
colnames(df) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

# estimate memory usage by this object
paste("Estimated Memory usage by this object:", format(object.size(x=df), units="Mb"))

# Make one DateTime object from the two factor vectors (Date, Time)
df$DateTime <- as.POSIXct(paste(df$Date, df$Time), format="%d/%m/%Y %H:%M:%S")

# Make the Date factor a 'Date' object
df$Date <- as.Date(df$Date, format="%d/%m/%Y")

# Reorder columns
df <- df[, c(10, 1, 2, 3, 4, 5, 6, 7, 8, 9)]

# Figure out how many rows are missing a value for 'Global Active Power'
length(which(is.na(df$Global_active_power))) # only 2 rows

# Remove them
# df <- df[ -c(which(is.na(df$Global_active_power))), ]


# View the dataframe
View(df)


# Generate the first histogram / density plot
png("plot1.png", width=480, height=480, units="px", res=72)
hist(df$Global_active_power, col="red", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power")
dev.off()


# Clean up
rm(df)