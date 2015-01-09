# Winter 2015
# Coursera Course EXTDATA 010
# Anthony DiLoreto
# Project 1 - Househouse usage
# plot4.R

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



# Create the multiple line plot
png("plot4.png", width=480, height=480, units="px", res=72)

# Setup a 2x2 grid
par(mfrow=c(2,2))
# Plot 1
plot(df$Global_active_power ~ df$DateTime, type = "l", ylab = "Global Active Power", xlab="")
# Plot 2
plot(df$Voltage ~ df$DateTime, type = "l", ylab = "Voltage", xlab="datetime")

# Plot 3
plot(df$Sub_metering_1 ~ df$DateTime, type = "l", ylab = "Energy sub metering", xlab="", col="black")
lines(x = df$DateTime, y = df$Sub_metering_2, col = "red")
lines(x = df$DateTime, y = df$Sub_metering_3, col = "blue")
legend("topright", c("sub_metering_1", "sub_metering_2", "sub_metering_3"), bty="n", adj = c(0, .6), lty=c(1,1,1), cex=0.75, col=c("black", "red", "blue") )

# Plot 4
plot(df$Global_reactive_power ~ df$DateTime, type = "l", ylab = "Global_reactive_power", xlab="datetime")

dev.off()


# Clean up
rm(df)