###############################################################
# Sceloporus occidentalis data downloaded from GBIF 30 Mar 2015
# Sima Bouzid

## Read in data
occ_data <- read.csv("occurrence.txt", sep="\t", header=TRUE, na.strings = c("", " "))

## Plot all records by institution
museums <- occ_data$institutionCode
specimens <- table(museums)
specimen_hist <- barplot(specimens, axes=T, axisnames=T, ylab="# specimens", main=expression(paste(italic("Sceloporus occidentalis "), "by Institution")), las=2)
mtext("Institution", side=1, line=5)

## Specify institution from which you want records, targeted prep type
iCode <- "CAS"
prep <- "Alcohol" # Alcohol, Dry, Tissue; only works for CAS specimens

### Subdivide by Institution
#occ_CAS <- occ_data[occ_data$institutionCode=="CAS",]
occ_rawData <- occ_data[occ_data$institutionCode==iCode,]

## Things with SVL already measured; output .csv file
occ_SVL <- grep("\\<SVL\\>", occ_rawData$occurrenceRemarks)
occ_SVL_measured <- occ_rawData[occ_SVL,]
write.csv(occ_SVL_measured, file=paste(iCode,"_SVL_measured.csv", sep=""))
occ_unmeasured <- occ_rawData[-occ_SVL,]

## Alcohol specimens only
occ_prep <-  grep(prep, occ_unmeasured$preparations)
#occ_CAS_fluid <-  grep("\\<Alcohol\\>", occ_unmeasured$preparations) # grep a single word in a string
occ_unmeasured <- occ_unmeasured[occ_prep,]
#write.csv(occ_unmeasured, file="test.csv") # just a test

# Not lost, missing, or destroyed
occ_lost <- grep("\\<Lost\\>", occ_unmeasured$occurrenceRemarks)
occ_missing <- grep("\\<Missing\\>", occ_unmeasured$occurrenceRemarks)
occ_destroyed <- grep("\\<Destroyed\\>", occ_unmeasured$occurrenceRemarks)
occ_gone <- c(occ_lost, occ_missing, occ_destroyed)
occ_toMeasure <- occ_unmeasured[-occ_gone,]

# Remove columns with all NAs; optional, just to clean data frame
occ_toMeasure <- occ_toMeasure[, unlist(lapply(occ_toMeasure, function(x) !all(is.na(x))))]

## Remove all records without lat/long; optional
occ_toMeasure <- subset(occ_toMeasure, decimalLatitude!="NA" & decimalLongitude!="NA")

## Write .csv of specimens to measure for institution specified in iCode
write.csv(occ_toMeasure, file=paste(iCode,"_SVL_toMeasure.csv",sep=""))



